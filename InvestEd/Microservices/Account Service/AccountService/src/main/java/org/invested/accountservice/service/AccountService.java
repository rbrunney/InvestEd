package org.invested.accountservice.service;

import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.RedisUtil;
import org.invested.accountservice.models.security.JsonWebTokenUTIL;
import org.invested.accountservice.models.security.JsonWebToken;
import org.invested.accountservice.models.security.RSA;
import org.invested.accountservice.respository.AccountJPARepo;
import org.springframework.amqp.core.AmqpTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.security.InvalidKeyException;
import java.time.LocalDate;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class AccountService {

    @Autowired
    private AccountJPARepo accountRepo;

    @Autowired
    private AmqpTemplate amqpTemplate;

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // User Authentication Methods

    /**
     * A method to decrypt incoming RSA encrypted user credentials, from a request!
     * @param username An RSA encrypted string containing the users username
     * @param password An RSA encrypted string containing the users password
     * @return A Map containing the decrypted username and password
     */
    public Map<String, String> decryptUserCredentials(String username, String password) {
        // Having to Decrypt User Information using RSA
        RSA rsa = new RSA();
        String decryptedUsername = rsa.decrypt(username);
        String decryptedPassword = rsa.decrypt(password);

        // Generate Decrypted User Credentials
        Map<String, String> decryptedUserInfo = new HashMap<>();
        decryptedUserInfo.put("username", decryptedUsername);
        decryptedUserInfo.put("password", decryptedPassword);

        return decryptedUserInfo;
    }

    /**
     * A method to validate user credentials against what is in the database
     * @param userCredentials A Map containing a users decrypted username and password
     * @return Will return true if the users information is valid, otherwise it will be false
     */
    public boolean validateUserCredentials(Map<String, String> userCredentials) {
        Account foundUser = accountRepo.getAccountByUsername(userCredentials.get("username"));

        if(foundUser != null) {
            return BCrypt.checkpw(userCredentials.get("password"), foundUser.getPassword());
        }

        return false;
    }

    /**
     * A method to generate two Json Web Tokens, an Access Token and a Refresh Token.
     * @param userCredentials A Map containing a users decrypted username and password
     * @param expireTimeInMinutes An int representing minutes for when the Json Web Token will expire
     * @return Returns a Map containing the Access Token and the Refresh Token
     */
    public Map<String, Object> generateJsonWebTokens(Map<String, String> userCredentials, int expireTimeInMinutes) {
        // Making user detail object so spring can keep track of it for a short term
        UserDetails authenticatedUser = User.withUsername(accountRepo.getIdByUsername(userCredentials.get("username")))
                .password(userCredentials.get("password")).roles("USER").build();

        // Generate the actual access token and the refresh token
        Map<String, Object> tokens = new HashMap<>();
        tokens.put("access-token", new JsonWebToken(authenticatedUser, accountRepo.getEmailByUsername(userCredentials.get("username")), JsonWebTokenUTIL.getAlgorithm(), expireTimeInMinutes).getGeneratedToken());
        tokens.put("refresh-token", new JsonWebToken(authenticatedUser, accountRepo.getEmailByUsername(userCredentials.get("username")), JsonWebTokenUTIL.getAlgorithm(), expireTimeInMinutes * 2).getGeneratedToken());

        return tokens;
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Account Creation Methods

    /**
     * A method to decrypt incoming new account information
     * @param newAccount An Account where its properties are encrypted in RSA
     * @return Will return an Account Object with most of the properties decrypted
     */
    public Account decryptUserInformation(Account newAccount) {
        // Having to Decrypt User Information using RSA to get the actual values
        RSA rsa = new RSA();
        newAccount.setUsername(rsa.decrypt(newAccount.getUsername()));
        newAccount.setPassword(rsa.decrypt(newAccount.getPassword()));
        newAccount.setFirstName(rsa.decrypt(newAccount.getFirstName()));
        newAccount.setLastName(rsa.decrypt(newAccount.getLastName()));
        newAccount.setBirthdate(rsa.decrypt(newAccount.getBirthdate()));
        newAccount.setEmail(rsa.decrypt(newAccount.getEmail()));

        return newAccount;
    }

    /**
     * A method to check to see if there is Account already made with either the given username or email
     * @param key A String which tells either we should be looking for an account with a specific username or an account with a specific email
     * @param value A String which is the value we are trying to see if it already exists
     * @return A true of if there is a match in the database, otherwise it will be false
     * @throws InvalidKeyException If there is an invalid key passed in it will throw a InvalidKeyException
     */
    public boolean checkIfAccountExists(String key, String value) throws InvalidKeyException {
        Account foundUser;
        if(key.equals("username"))
            foundUser = accountRepo.getAccountByUsername(value);
        else if(key.equals("email"))
            foundUser = accountRepo.getAccountByEmail(value);
        else
            throw new InvalidKeyException("Key must either be 'username' or 'email'");

        return foundUser != null;
    }

    /**
     * A method to save a new account to the database and send a message to RabbitMQ, so we can send a confirmation email
     * @param newAccount An Account object containing the information for the new Account
     */
    public void saveUser(Account newAccount) {
        // Encrypting Password so it's not plain text on database
        newAccount.setPassword(BCrypt.hashpw(newAccount.getPassword(), BCrypt.gensalt()));

        // Setting Join Date
        newAccount.setJoinDate(LocalDate.now().toString());

        // Save to database
        Account savedAccount = accountRepo.save(newAccount);

        // Creating RabbitMQ Message
        Map<String, String> message = new HashMap<>() {{
            put("email", savedAccount.getEmail());
            put("fname", savedAccount.getFirstName());
            put("lname", savedAccount.getLastName());
        }};

        // Make call to RabbitMQ to send confirmation email
        amqpTemplate.convertAndSend("ACCOUNT_EMAIL_EXCHANGE", "email.confirmation", message.toString());
    }

    // //////////////////////////////////////////////////////////////////
    // Update Account Methods

    /**
     * A method to update specific Account Fields on an Account Object!
     * @param id A String containing the user's id, so we can fetch it off the database
     * @param fieldToUpdate A String containing the specific field we will be updating
     * @param newInfo A String containing the new information that will be saved
     * @return An Account object, meaning that the user actually existed, and we are sending it back with the new information
     * @throws InvalidKeyException If there is a invalid key passed in it will throw a InvalidKeyException
     */
    public Account updateUserField(String id, String fieldToUpdate, String newInfo) throws InvalidKeyException {
        Account accountToUpdate = accountRepo.getAccountById(id);

        switch (fieldToUpdate) {
            case "first_name" -> {
                accountToUpdate.setFirstName(newInfo);
                return accountToUpdate;
            }
            case "last_name" -> {
                accountToUpdate.setLastName(newInfo);
                return accountToUpdate;
            }
            case "password" -> {
                accountToUpdate.setPassword(BCrypt.hashpw(newInfo, BCrypt.gensalt()));
                return accountToUpdate;
            }
            case "buying_power_to_add" -> {
                accountToUpdate.setBuyingPower(accountToUpdate.getBuyingPower() + Double.parseDouble(newInfo));
                return accountToUpdate;
            }
            default -> throw new InvalidKeyException("Invalid Property in Json");
        }
    }

    /**
     * A method to update the user information on the database
     * @param updatedAccount An Account containing all the fields with new information to update
     */
    public void updateUser(Account updatedAccount) {
        // Saving the Account to the Database
        accountRepo.save(updatedAccount);

        // Making the message for to notify the user that their account has been updated
        Map<String, String> message = new HashMap<>() {{
            put("email", updatedAccount.getEmail());
            put("fname", updatedAccount.getFirstName());
            put("lname", updatedAccount.getLastName());
        }};

        // Sending the message off to RabbitMQ
        amqpTemplate.convertAndSend("ACCOUNT_EMAIL_EXCHANGE", "email.user-info-update", message.toString());
    }

    /**
     * A method to decode a Basic Auth Header off a Request
     * @param encodedString The encoded basic auth header from the request
     * @return It will return a String[] containing the decoded username and password
     */
    public String[] decodeAuth(String encodedString) {
        encodedString = encodedString.substring(encodedString.indexOf(" ") + 1);
        byte[] decodedBytes = Base64.getDecoder().decode(encodedString);
        String decodedString = new String(decodedBytes);
        return decodedString.split(":", 2);
    }

    /**
     * A method to update an Account's buying power on the Database
     * @param userId A String containing the Account's Id we are going to update
     * @param totalPurchasePrice A double containing how much we either need to add or remove from Account
     */
    public void updateUserBuyingPower(String userId, double totalPurchasePrice) {
        Account account = accountRepo.getAccountById(userId);
        account.setBuyingPower(account.getBuyingPower() + totalPurchasePrice);
        accountRepo.save(account);
    }

    // //////////////////////////////////////////////////////////////////
    // Delete Account Methods

    /**
     * A method to delete an Account
     * @param id A String containing an Account's ID
     */
    public void deleteUser(String id) {
        try {
            accountRepo.deleteById(id);
        } catch(Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
        }
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Forgot Password Methods

    /**
     * A method for generating a temp six-digit code
     * @return A String containing the six-digit code
     */
    public String generateSixDigitCode() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    /**
     * A method to generate a code and send it to RabbitMQ and Redis
     * @param email A String containing the users email
     */
    public void sendCode(String email) {
        // Generate code and put into redis
        String generatedCode = generateSixDigitCode();
        RedisUtil.redisConnection.set(email, generatedCode);

        // Making message information
        Map<String, String> forgotPassMsg = new HashMap<>() {{
            put("email", email);
            put("verification-code", generatedCode);
        }};

        // Make Call to RabbitMQ to send forgot email password
        amqpTemplate.convertAndSend("ACCOUNT_EMAIL_EXCHANGE", "email.forgot-pass", forgotPassMsg.toString());
    }

    /**
     * A method to verify the verification code the user sent
     * @param email A String containing the users email
     * @param code An int containing the users verification code they entered
     * @return A boolean to see if the code in Redis is the same as the once sent in the request
     */
    public boolean verifyCode(String email, int code) {
        // Get current code from redis and check to see if it's the same
        String currentCode = RedisUtil.redisConnection.get(email);
        return currentCode != null && Integer.parseInt(currentCode) == code;
    }

    /**
     * A method to delete the current verification code in Redis
     * @param email A String containing the users email
     */
    public void deleteVerificationCode(String email) {
        RedisUtil.redisConnection.del(email);
    }

    /**
     * A method to generate a Temporary Json Web Token so the user can update there password after validating their verification code
     * @param email A String containing the users email
     * @return A String containing the temporary Json Web Token
     */
    public String generateTempJWTToken(String email) {
        Account account = accountRepo.getAccountByEmail(email);
        UserDetails authenticatedUser = User.withUsername(accountRepo.getIdByUsername(account.getUsername()))
                .password(account.getPassword()).roles("USER").build();
        return new JsonWebToken(authenticatedUser, email, JsonWebTokenUTIL.getAlgorithm(), 5).getGeneratedToken();
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Get Account Information End Points

    /**
     * A method to get the buying power for an account
     * @param id A String containing the users id
     * @return A double containing the users current buying power
     */
    public double getUserBuyingPower(String id) {
        return accountRepo.getBuyingPowerById(id);
    }
}
