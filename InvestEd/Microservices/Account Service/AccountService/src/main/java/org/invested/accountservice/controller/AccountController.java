package org.invested.accountservice.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/invested_account")
public class AccountController {

    @GetMapping()
    public String testWorks() {
        return "Hello, from Invested Account API";
    }
}
