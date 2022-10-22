package com.invested.portfolioservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.invested.portfolioservice.services.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/invested_portfolio")
public class PortfolioController {

    @Autowired
    private PortfolioService portfolioService;

    @PostMapping()
    public ResponseEntity<Map<String, Object>> makePortfolio(Principal principal) {
        if (!portfolioService.hasPortfolio(principal.getName())) {
            return new ResponseEntity<>(new HashMap<>() {{
                put("message", "Portfolio Successfully Created!");
                put("date-time", LocalDateTime.now());
            }}, HttpStatus.CREATED);
        }

        return new ResponseEntity<>(new HashMap<>() {{
            put("message", "Current User Already has a Portfolio!");
            put("date-time", LocalDateTime.now());
        }},HttpStatus.BAD_REQUEST);
    }
}
