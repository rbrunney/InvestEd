package org.invested.accountservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.Response;
import org.invested.accountservice.models.security.JsonWebToken;
import org.invested.accountservice.models.security.RSA;
import org.invested.accountservice.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.security.InvalidKeyException;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping("/invested_account")
public class AccountController {

    @Autowired
    private AccountService accountService;

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Get Account Information End Points

    /**
     * A end-point to get the users buying power
     * @param principal Used to get the username off of our UserPassAuthToken
     * @return Will return a double containing the users buying power
     */
    @GetMapping("/buying_power")
    public double getBuyingPower(Principal principal) {
        return accountService.getUserBuyingPower(principal.getName());
    }

    @GetMapping("/encrypt/{msg}")
    public String encrypt(@PathVariable String msg) {
        try {
            RSA rsa = new RSA();
            return rsa.encrypt(msg);
        } catch(Exception e) {
            return "Encrypt MSG Failed";
        }
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // User Authentication End Point

    /**
     * An end-point to authenticate a user with their username and password which is RSA encrypted
     * @param userCredentials JsonNode which is the RSA encrypted username and password
     * @return If valid it will return the two Json Web Tokens, an access token and a refresh token. If not
     * then it will return a BAD_REQUEST.
     */
    @PostMapping("/authenticate")
    public ResponseEntity<Map<String, Object>> authenticateUser(@RequestBody JsonNode userCredentials) {
        // Decrypt incoming body
        Map<String, String> loginInfo = accountService.decryptUserCredentials(userCredentials.get("username").asText(), userCredentials.get("password").asText());

        // Check to see if user is valid
        if (accountService.validateUserCredentials(loginInfo)) {
            Map<String, Object> tokens = accountService.generateJsonWebTokens(loginInfo, 10);

            return new ResponseEntity<>(new Response("Authentication Passed!", tokens).getResponseBody(), HttpStatus.OK);
        }

        Map<String, Object> status = new HashMap<>();
        status.put("status-code", HttpStatus.BAD_REQUEST.value());

        return new ResponseEntity<>(new Response("Authentication Invalid!", status).getResponseBody(), HttpStatus.BAD_REQUEST);
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // User Creation End Points

    /**
     * An end-point to check to see if username or email is already taken, before we actually save the account
     * @param email A String containing the email to check to see if it is already in use
     * @param username A String containing the username to check to see if it already in use
     * @return Will return a status code 200 if it's OK, otherwise it will return 400 BAD_REQUEST
     */
    @GetMapping("/check_taken")
    public ResponseEntity<Map<String, Object>> checkTaken(@RequestParam String email, @RequestParam String username){
        try {
            // Check to see if username or email us taken
            if(accountService.checkIfAccountExists("username", username)) {
                return new ResponseEntity<>(new Response("Username Already Taken!", new HashMap<>(){{
                    put("status-code", HttpStatus.BAD_REQUEST.value());
                }}).getResponseBody(), HttpStatus.BAD_REQUEST);
            } else if(accountService.checkIfAccountExists("email", email)) {
                return new ResponseEntity<>(new Response("Email Already Taken!", new HashMap<>(){{
                    put("status-code", HttpStatus.BAD_REQUEST.value());
                }}).getResponseBody(), HttpStatus.BAD_REQUEST);
            }
        } catch(InvalidKeyException ike) {
            System.err.println("[ERROR] " + ike.getMessage());
        }

        return new ResponseEntity<>(new Response("Username and Email valid!", new HashMap<>(){{
            put("status-code", HttpStatus.OK.value());
        }}).getResponseBody(), HttpStatus.OK);
    }


    /**
     * An end-point to create a new account for the user
     * @param newAccount An Account Object containing the users: username, password, first name, last name, email, and birthdate
     * @return If a valid creation is made it will just return a 201 CREATED! Otherwise, it will return a 400 BAD_REQUEST
     */
    @PostMapping()
    public ResponseEntity<Map<String, Object>> createUser(@RequestBody Account newAccount) {

        // Decrypting the newAccount Information
        newAccount = accountService.decryptUserInformation(newAccount);

        try {
            // Check to see if username or email is taken
            if(!(accountService.checkIfAccountExists("username", newAccount.getUsername())
                    || accountService.checkIfAccountExists("email", newAccount.getEmail()))) {
                // Saving user
                newAccount.setId(UUID.randomUUID().toString());
                accountService.saveUser(newAccount);

                return new ResponseEntity<>(HttpStatus.CREATED);
            }
        } catch(InvalidKeyException ike) {
            System.err.println("[ERROR] " + ike.getMessage());
        }

        return new ResponseEntity<>(new Response("Username or Email Already Taken!", new HashMap<>(){{
            put("status-code", HttpStatus.BAD_REQUEST.value());
        }}).getResponseBody(), HttpStatus.BAD_REQUEST);
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Update Account End Points

    /**
     * A end-point to update a users account information
     * @param principal Used to get the username off of our UserPassAuthToken
     * @param requestBody A JsonNode containing all the fields the user may want to update on their account
     * @return Returns a ResponseEntity simply changing the status code of response 200 if it was good, 400 if it was bad
     * @throws InvalidKeyException Throws IKE, if there is a field that should not belong in the request body JSON
     */
    @PutMapping()
    public ResponseEntity<Map<String, Object>> updateUser(Principal principal, @RequestBody JsonNode requestBody) throws InvalidKeyException {
        Account accountToUpdate = null;

        // Going through all the keys and updating fields as needed
        Iterator<String> accountPropertyKeys = requestBody.fieldNames();
        while(accountPropertyKeys.hasNext()) {
            String key = accountPropertyKeys.next();
            accountToUpdate = accountService.updateUserField(principal.getName(), key, requestBody.get(key).asText());
        }

        // Checking to see if we had an actual update to the object!
        if(accountToUpdate != null) {
            accountService.updateUser(accountToUpdate);
            return new ResponseEntity<>(HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    /**
     * An end-point to update a users buying power
     * @param authHead A Basic Auth Header so other Resources can update a user's account
     * @param userId A PathVariable, which a String, containing and Account's Id
     * @param requestBody A JsonNode containing the total-purchase-price so we can update the Account Buying Power
     * @return If the update is successful we will return a 200 OK, otherwise it will return a 400 BAD_REQUEST
     */
    @PutMapping("/buying_power/{userId}")
    public ResponseEntity<Map<String, Object>> updateUserBuyingPower(@RequestHeader(value = "Authorization") String authHead, @PathVariable String userId, @RequestBody JsonNode requestBody) {
        // Check Auth, by decoding it
        String[] requestAuthInfo = accountService.decodeAuth(authHead);
        if(requestAuthInfo[0].equals(System.getenv("CUSTOM_USERNAME")) && requestAuthInfo[1].equals(System.getenv("CUSTOM_PASSWORD"))) {
            accountService.updateUserBuyingPower(userId, requestBody.get("total-purchase-price").asDouble());
            return new ResponseEntity<>(HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Delete Account End Points

    /**
     * An end-point to delete a Users Account!
     * @param principal Used to get the username off of our UserPassAuthToken
     * @return Will return a response entity containing a 204 or a NO_CONTENT
     */
    @DeleteMapping()
    public ResponseEntity<Map<String, Object>> deleteUser(Principal principal) {
        accountService.deleteUser(principal.getName());
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    // /////////////////////////////////////////////////////////////////////////////////////////////
    // Forgot Password End Points

    /**
     * An end-point to send a code when a user forgets their password
     * @param email A String containing the users email
     * @return Will return a response of OK, when the code has been sent
     */
    @GetMapping("/forgot_password/{email}")
    public ResponseEntity<Map<String, Object>> forgotPassword(@PathVariable String email) {

        accountService.sendCode(email);
        return new ResponseEntity<>(new Response("Verification Code Sent", new HashMap<>(){{
            put("status-code", HttpStatus.OK.value());
        }}).getResponseBody(), HttpStatus.OK);
    }

    /**
     * An end-point for verifying the generated verification code
     * @param requestBody A JsonNode containing a user email and verification code
     * @return Returns a temporary token if the verification code was correct, otherwise it will return
     * a 400 BAD_REQUEST
     */
    @PostMapping("/verify_code")
    public ResponseEntity<Map<String, Object>> verifyCode(@RequestBody JsonNode requestBody) {

        // Verifying Code
        if(accountService.verifyCode(requestBody.get("user_email").asText(),
                Integer.parseInt(requestBody.get("verification_code").asText()))) {

            accountService.deleteVerificationCode(requestBody.get("user_email").asText());
            return new ResponseEntity<>(new Response("Verification Code Valid!", new HashMap<>() {{
                put("status-code", HttpStatus.OK.value());
                put("temp-token", accountService.generateTempJWTToken((requestBody.get("user_email").asText())));
            }}).getResponseBody(), HttpStatus.OK);
        }

        accountService.deleteVerificationCode(requestBody.get("user_email").asText());
        return new ResponseEntity<>(new Response("Verification Code Invalid!", new HashMap<>(){{
            put("status-code", HttpStatus.BAD_REQUEST.value());
        }}).getResponseBody(), HttpStatus.BAD_REQUEST);

    }
}
