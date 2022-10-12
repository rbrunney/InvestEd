package org.invested.accountservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.Response;
import org.invested.accountservice.models.security.JWTUtil;
import org.invested.accountservice.models.security.JsonWebToken;
import org.invested.accountservice.models.security.RSA;
import org.invested.accountservice.respository.AccountJPARepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/invested_account")
public class AccountController {

    @Autowired
    private AccountJPARepo accountRepo;

    @GetMapping("/test")
    public String testJWTWorks() {
        return "JWT Working";
    }

    @GetMapping("/encrypt/{msg}")
    public String encrypt(@PathVariable String msg) {
        try {
            RSA rsa = new RSA();
            rsa.initFromStrings();
            return rsa.encrypt(msg);
        } catch(Exception e) {
            return "Encrypt MSG Failed";
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<Map<String, Object>> authenticateUser(@RequestBody JsonNode userCredentials) {
        // Decryption happens here when implementation works
        RSA rsa = new RSA();
        rsa.initFromStrings();
        String username = rsa.decrypt(userCredentials.get("username").asText());
        String password = rsa.decrypt(userCredentials.get("password").asText());

        Account accountFound = accountRepo.getAccountByUsername(username);

        // Need to do comparison once its encrypt the password data
        if(accountFound != null && accountFound.getPassword().equals(password)) {
            UserDetails authenticatedUser = User.withUsername(username).password(password).roles("USER").build();

            Map<String, Object> tokens = new HashMap<>();
            tokens.put("access-token", new JsonWebToken(authenticatedUser, JWTUtil.getAlgorithm(), 10).getGeneratedToken());
            tokens.put("refresh-token", new JsonWebToken(authenticatedUser, JWTUtil.getAlgorithm(), 30).getGeneratedToken());

            return new ResponseEntity<>(new Response("Authenication Valid!", tokens).getResponseBody(), HttpStatus.OK);
        }

        Map<String, Object> status = new HashMap<>();
        status.put("status-code", HttpStatus.BAD_REQUEST);

        return new ResponseEntity<>(new Response("Authentication Invalid!", status).getResponseBody(), HttpStatus.BAD_REQUEST);
    }

    @PostMapping()
    public ResponseEntity<Map<String, String>> createUser(@RequestBody Account newAccount) {
        accountRepo.save(newAccount);
        // Check to see if username us taken
            // If taken New ResponsEnityy with Bad Request
            // Else make new account
                // Make Message to RabbitMQ
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
