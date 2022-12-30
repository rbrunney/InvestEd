package org.invested.services;

import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class Requests {

    public static Map<String, String> get(String link) {
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
            return convertResponseToMap(response.toString());
        } catch(Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
        }

        return new HashMap<>();
    }

    private static Map<String, String> convertResponseToMap(String responseToConvert) {

        // Replacing the { } so we can just get straight key values
        responseToConvert = responseToConvert.replace("{", "").replace("}", "").replace(" ", "");
        Map<String, String> finalResult = new HashMap<>();

        // Splitting to get key values
        String[] jsonPairs = responseToConvert.split(",");

        // Generating map based off of message
        for(String pair : jsonPairs) {
            String[] keyValue = pair.split("=");
            finalResult.put(keyValue[0], keyValue[1]);
        }

        return finalResult;
    }
}
