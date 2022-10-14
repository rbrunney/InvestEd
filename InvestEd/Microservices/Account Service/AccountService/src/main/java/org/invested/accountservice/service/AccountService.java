package org.invested.accountservice.service;

import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.RedisUtil;
import org.invested.accountservice.models.security.JWTUtil;
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
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class AccountService {

    @Autowired
    private AccountJPARepo accountRepo;

    @Autowired
    private AmqpTemplate amqpTemplate;

    public Map<String, String> decryptUserCredentials(String username, String password) {
        // Having to Decrypt User Information using RSA
        RSA rsa = new RSA();
        String decryptedUsername = rsa.decrypt(username);
        String decryptedPassword = rsa.decrypt(password);

        Map<String, String> decryptedUserInfo = new HashMap<>();
        decryptedUserInfo.put("username", decryptedUsername);
        decryptedUserInfo.put("password", decryptedPassword);

        return decryptedUserInfo;
    }

    public boolean validateUserCredentials(Map<String, String> userCredentials) {
        Account foundUser = accountRepo.getAccountByUsername(userCredentials.get("username"));

        if(foundUser != null) {
            return BCrypt.checkpw(userCredentials.get("password"), foundUser.getPassword());
        }

        return false;
    }

    public Map<String, Object> generateJsonWebTokens(Map<String, String> userCredentials, int expireTimeInMinutes) {
        // Making user detail object so spring can keep track of it for a short term
        UserDetails authenticatedUser = User.withUsername(userCredentials.get("username"))
                .password(userCredentials.get("password")).roles("USER").build();

        Map<String, Object> tokens = new HashMap<>();
        // Generate the actual tokens
        tokens.put("access-token", new JsonWebToken(authenticatedUser, JWTUtil.getAlgorithm(), expireTimeInMinutes).getGeneratedToken());
        tokens.put("refresh-token", new JsonWebToken(authenticatedUser, JWTUtil.getAlgorithm(), expireTimeInMinutes * 2).getGeneratedToken());

        return tokens;
    }

    public boolean checkIfAccountExists(String key, String value) {
        Account foundUser;
        if(key.equals("username"))
            foundUser = accountRepo.getAccountByUsername(value);
        else if(key.equals("email"))
            foundUser = accountRepo.getAccountByEmail(value);
        else
            throw new IllegalArgumentException("Key must either be 'username' or 'email'");

        return foundUser != null;
    }

    public void saveUser(Account newAccount) {
        // Encrypting Password so it's not plain text on database
        newAccount.setPassword(BCrypt.hashpw(newAccount.getPassword(), BCrypt.gensalt()));

        // Save to database
        Account savedAccount = accountRepo.save(newAccount);

        // Creating RabbitMQ Message
        Map<String, String> message = new HashMap<>() {{
            put("email", savedAccount.getEmail());
            put("fname", savedAccount.getFirstName());
            put("lname", savedAccount.getLastName());
        }};

        // Make Call to RabbitMQ to send confirmation email
        amqpTemplate.convertAndSend("ACCOUNT_EMAIL_EXCHANGE", "email.confirmation", message.toString());
    }

    public void deleteUser(String username) {
        try {
            Account accountToDelete = accountRepo.getAccountByUsername(username);
            accountRepo.deleteById(accountToDelete.getUsername());
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }
    }

    public void updateUser(Account updatedAccount) {
        accountRepo.save(updatedAccount);

        Map<String, String> message = new HashMap<>() {{
            put("email", updatedAccount.getEmail());
            put("fname", updatedAccount.getFirstName());
            put("lname", updatedAccount.getLastName());
        }};

        amqpTemplate.convertAndSend("ACCOUNT_EMAIL_EXCHANGE", "email.user-info-update", message.toString());
    }

    public Account updateUserField(String username, String fieldToUpdate, String newInfo) throws InvalidKeyException {
        Account accountToUpdate = accountRepo.getAccountByUsername(username);

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
            case "phone" -> {
                accountToUpdate.setPhone(newInfo);
                return accountToUpdate;
            }
            default -> throw new InvalidKeyException("Invalid Property in Json");
        }
    }

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

    public String generateSixDigitCode() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    public boolean verifyCode(String email, int code) {
        // Get current code from redis and check to see if it's the same
        String currentCode = RedisUtil.redisConnection.get(email);
        return currentCode != null && Integer.parseInt(currentCode) == code;
    }

    public void deleteVerificationCode(String email) {
        RedisUtil.redisConnection.del(email);
    }
}
