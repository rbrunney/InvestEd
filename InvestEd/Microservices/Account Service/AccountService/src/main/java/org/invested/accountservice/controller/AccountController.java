package org.invested.accountservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.Response;
import org.invested.accountservice.models.security.JWTUtil;
import org.invested.accountservice.models.security.JsonWebToken;
import org.invested.accountservice.models.security.RSA;
import org.invested.accountservice.respository.AccountJPARepo;
import org.invested.accountservice.service.AccountService;
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

    @Autowired
    private AccountService accountService;

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
