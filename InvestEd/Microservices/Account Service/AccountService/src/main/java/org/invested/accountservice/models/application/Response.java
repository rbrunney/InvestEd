package org.invested.accountservice.models.application;

import lombok.Getter;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Getter
public class Response {
    private final Map<String, Object> responseBody = new HashMap<>();

    public Response(String message, Map<String, Object> results) {
        responseBody.put("message", message);
        responseBody.put("results", results);
        responseBody.put("date-time-finished", LocalDateTime.now());
    }
}
