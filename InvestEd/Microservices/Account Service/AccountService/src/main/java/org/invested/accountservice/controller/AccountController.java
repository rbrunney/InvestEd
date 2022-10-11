package org.invested.accountservice.controller;

import org.invested.accountservice.models.JWTUtil;
import org.invested.accountservice.models.JsonWebToken;
import org.invested.accountservice.models.RSA;
import org.invested.accountservice.security.SecurityConfig;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/invested_user")
public class AccountController {

    @GetMapping("/authenticate/{username}/{password}")
    public ResponseEntity authenticateUser(@PathVariable String username, @PathVariable String password) {
        // Decryption happens here when implementation works

        return new ResponseEntity(new JsonWebToken(, JWTUtil.getAlgorithm(), 10).getGeneratedToken(), HttpStatus.OK);
    }
}
