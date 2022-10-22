package com.invested.portfolioservice.controller;

import com.invested.portfolioservice.services.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.Map;

@RestController
@RequestMapping("/invested_portfolio")
public class PortfolioController {

    @Autowired
    private PortfolioService portfolioService;

    @PostMapping()
    public ResponseEntity<Map<String, Object>> makePortfolio(Principal principal) {
        portfolioService.createPortfolio(principal.getName());

        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
