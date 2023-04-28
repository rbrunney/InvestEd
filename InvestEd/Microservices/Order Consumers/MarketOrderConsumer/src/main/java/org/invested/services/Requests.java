package org.invested.services;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class Requests {

    public static JSONObject get(String link) {
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
            return convertResponse(convertResponse(response.toString()).get("results").toString());
        } catch(Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
        }

        return new JSONObject();
    }

    static void post(String link, String requestBody) {
        try {
            URL url = new URL(link);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/json");

            try (DataOutputStream dos = new DataOutputStream(conn.getOutputStream())) {
                dos.writeBytes(requestBody);
            }

            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    conn.getInputStream())))
            {
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println(line);
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static private JSONObject convertResponse(String response) {
        JSONParser parser = new JSONParser();
        try {
            return (JSONObject) parser.parse(response);
        } catch (ParseException e) {
            System.err.println("[ERROR] Could not parse response");
        }

        return new JSONObject();
    }

    static private Map<String, String> convertResponseToMap(String msgToConvert) {
        // Turn body into a string
        // Replacing the { } so we can just get straight key values
        msgToConvert = msgToConvert.replace("{", "").replace("}", "").replace(" ", "");
        Map<String, String> finalResult = new HashMap<>();

        // Splitting to get key values
        String[] jsonPairs = msgToConvert.split(",");

        // Generating map based off of message
        for(String pair : jsonPairs) {
            String[] keyValue = pair.split("=");
            finalResult.put(keyValue[0], keyValue[1]);
        }

        return finalResult;
    }
}
