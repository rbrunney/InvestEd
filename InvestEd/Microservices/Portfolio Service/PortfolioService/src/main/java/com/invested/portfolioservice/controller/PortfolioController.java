package com.invested.portfolioservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.invested.portfolioservice.models.application.Portfolio;
import com.invested.portfolioservice.services.PortfolioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/invested_portfolio")
public class PortfolioController {

    @Autowired
    private PortfolioService portfolioService;

    // /////////////////////////////////////////////////////////////////////////////
    // Create Portfolio End Points

    /**
     * An endpoint to make a portfolio for a user
     * @param principal Used to get the username and email off of our UserPassAuthToken
     * @return Will return a 200 OK when finished, otherwise it will be a 400 BAD_REQUEST
     */
    @PostMapping()
    public ResponseEntity<Map<String, Object>> makePortfolio(Principal principal) {
        if (!portfolioService.hasPortfolio(principal.getName())) {
            Map<String, Object> portfolioInfo = portfolioService.createPortfolio(principal.getName());
            return new ResponseEntity<>(new HashMap<>() {{
                put("message", "Portfolio Successfully Created!");
                put("results", portfolioInfo);
                put("date-time", LocalDateTime.now());
            }}, HttpStatus.CREATED);
        }

        return new ResponseEntity<>(new HashMap<>() {{
            put("message", "Current User Already has a Portfolio!");
            put("date-time", LocalDateTime.now());
        }},HttpStatus.BAD_REQUEST);
    }

    // /////////////////////////////////////////////////////////////////////
    // Portfolio Retrieval End points

    /**
     * An endpoint to get a Portfolio with all of its stocks inside
     * @param principal Used to get the username and email off of our UserPassAuthToken
     * @return Will return a 200 OK with the portfolio information
     */
    @GetMapping()
    public ResponseEntity<Map<String, Object>> getPortfolio(Principal principal) {
        Map<String, String> userInfo = portfolioService.convertMsgToMap(principal.getName());
        Portfolio portfolio = portfolioService.getPortfolio(userInfo.get("username"));

        return new ResponseEntity<>(new HashMap<>() {{
            put("message", portfolio.getId() + " has been retrieved");
            put("results", portfolio);
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.OK);
    }

    // /////////////////////////////////////////////////////////////////////
    // Portfolio Deletion End points

    @DeleteMapping("")
    public ResponseEntity<Map<String, Object>> deletePortfolio(Principal principal) {
        Map<String, String> userInfo = portfolioService.convertMsgToMap(principal.getName());
        portfolioService.deletePortfolio(userInfo.get("username"));
        return new ResponseEntity<>(new HashMap<>() {{
            put("message", "Portfolio has been deleted!");
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.NO_CONTENT);
    }
}
