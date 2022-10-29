package com.invested.portfolioservice.controller;

import com.fasterxml.jackson.databind.JsonNode;
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
    // Dealing with the portfolio itself
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

    @GetMapping("/{portfolioId}")
    public ResponseEntity<Map<String, Object>> getPortfolio(Principal principal, @PathVariable String portfolioId) {
        if(portfolioService.portfolioExists(portfolioId)) {
            if (portfolioService.isUsersPortfolio(principal.getName(), portfolioId)) {
                return new ResponseEntity<>(new HashMap<>() {{
                    put("message", portfolioId + " has been retrieved");
                    put("results", portfolioService.getPortfolio(portfolioId));
                    put("date-time", LocalDateTime.now());
                }}, HttpStatus.OK);
            }

            return new ResponseEntity<>(new HashMap<>(){{
                put("message", portfolioId + " does not belong to current user");
            }},HttpStatus.UNAUTHORIZED);
        }

        return new ResponseEntity<>(new HashMap<>(){{
            put("message", portfolioId + " does not exist!");
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{portfolioId}")
    public ResponseEntity<Map<String, Object>> deletePortfolio(Principal principal, @PathVariable String portfolioId) {
        if(portfolioService.portfolioExists(portfolioId)) {
            if (portfolioService.isUsersPortfolio(principal.getName(), portfolioId)) {

                portfolioService.deletePortfolio(portfolioId);
                return new ResponseEntity<>(new HashMap<>() {{
                    put("message", portfolioId + " has been deleted!");
                    put("date-time", LocalDateTime.now());
                }}, HttpStatus.NO_CONTENT);
            }

            return new ResponseEntity<>(new HashMap<>(){{
                put("message", portfolioId + " does not belong to current user");
            }},HttpStatus.UNAUTHORIZED);
        }

        return new ResponseEntity<>(new HashMap<>(){{
            put("message", portfolioId + " does not exist!");
            put("date-time", LocalDateTime.now());
        }}, HttpStatus.BAD_REQUEST);
    }

    // ///////////////////////////////////////////////////////////
    // Dealing with the stocks within the portfolio

    @PutMapping("/buy_stock/{userId}")
    public ResponseEntity<Map<String, Object>> addStockToPortfolio(@PathVariable String userId, @RequestBody JsonNode stock) {
        String portfolioId = portfolioService.getPortfolioId(userId);

        // Saving Incoming Stock
        portfolioService.buyStock(stock.get("ticker").asText(),
                portfolioId,
                stock.get("stock-qty").asDouble(),
                stock.get("stock-qty").asDouble() * stock.get("price-per-share").asDouble()
                );

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/sell_stock/{userId}")
    public ResponseEntity<Map<String, Object>> removeStockFromPortfolio(@PathVariable String userId, @RequestBody JsonNode stock) {
        String portfolioId = portfolioService.getPortfolioId(userId);

        Map<String, Object> response = portfolioService.sellStock(
            stock.get("ticker").asText(),
            portfolioId,
            stock.get("stock-qty").asDouble(),
            stock.get("stock-qty").asDouble() * stock.get("price-per-share").asDouble()
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
