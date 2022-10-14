package org.invested.accountservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.models.application.Response;
import org.invested.accountservice.models.security.RSA;
import org.invested.accountservice.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/invested_account")
public class AccountController {

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
    public ResponseEntity<Map<String, Object>> createUser(@RequestBody Account newAccount) {
        // Check to see if username or email us taken
        if(!(accountService.checkIfAccountExists("username", newAccount.getUsername())
                || accountService.checkIfAccountExists("email", newAccount.getEmail()))) {
            // Saving user
            accountService.saveUser(newAccount);

            return new ResponseEntity<>(HttpStatus.CREATED);
        }

        return new ResponseEntity<>(new Response("Username or Email Already Taken!", new HashMap<>(){{
            put("status-code", HttpStatus.BAD_REQUEST.value());
        }}).getResponseBody(), HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping()
    public ResponseEntity<Map<String, Object>> deleteUser(Principal principal) {
        accountService.deleteUser(principal.getName());
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PutMapping()
    public ResponseEntity<Map<String, Object>> updateUser(Principal principal, @RequestBody JsonNode requestBody) {


    }

    @GetMapping("/forgot_password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestBody JsonNode requestBody) {

        accountService.sendCode(requestBody.get("user_email").asText());
        return new ResponseEntity<>(new Response("Verification Code Sent", new HashMap<>(){{
            put("status-code", HttpStatus.OK.value());
        }}).getResponseBody(), HttpStatus.OK);
    }

    @GetMapping("/verify_code")
    public ResponseEntity<Map<String, Object>> verifyCode(@RequestBody JsonNode requestBody) {

        // Verifying Code
        if(accountService.verifyCode(requestBody.get("user_email").asText(),
                Integer.parseInt(requestBody.get("verification_code").asText()))) {

            accountService.deleteVerificationCode(requestBody.get("user_email").asText());
            return new ResponseEntity<>(new Response("Verification Code Valid!", new HashMap<>(){{
                put("status-code", HttpStatus.OK.value());
            }}).getResponseBody(), HttpStatus.OK);
        } else {
            accountService.deleteVerificationCode(requestBody.get("user_email").asText());
        }

        return new ResponseEntity<>(new Response("Verification Code Invalid!", new HashMap<>(){{
            put("status-code", HttpStatus.BAD_REQUEST.value());
        }}).getResponseBody(), HttpStatus.BAD_REQUEST);

    }
}
