package org.invested.accountservice.models.application;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

public class Response {
    private final Map<String, Object> responseBody = new HashMap<>();

    public Response(String message, Map<String, Object> results) {
        responseBody.put("message", message);
        responseBody.put("results", results);
        responseBody.put("date-time-finished", LocalDateTime.now());
    }

    public Map<String, Object> getResponseBody() {
        return responseBody;
    }
}
