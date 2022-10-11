package org.invested.accountservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.invested.accountservice.models.application.Account;
import org.invested.accountservice.respository.AccountJPARepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/invested_account")
public class AccountController {

    @Autowired
    private AccountJPARepo accountRepo;

    @GetMapping("/authenticate")
    public ResponseEntity<Map<String, String>> authenticateUser(@RequestBody JsonNode userCredentials) {
        // Decryption happens here when implementation works

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping()
    public ResponseEntity<Map<String, String>> createUser(@RequestBody Account newAccount) {
        accountRepo.save(newAccount);

        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
