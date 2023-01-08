package org.invested.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class Requests {

    public static JsonNode get(String link) {
        try {
            // Making Connection
            URL url = new URL(link);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            // Reading Connection
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Closing Connection
            con.disconnect();
            return convertResponseToJson(response.toString());
        } catch(Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
        }

        return new ObjectMapper().createObjectNode();
    }

    private static JsonNode convertResponseToJson(String responseToConvert) {
        ObjectMapper mapper = new ObjectMapper();

        try {
            return mapper.readTree(responseToConvert);
        } catch (JsonProcessingException jpe) {
            System.err.println("[ERROR] " + jpe.getMessage());
        }

        return mapper.createObjectNode();
    }
}
