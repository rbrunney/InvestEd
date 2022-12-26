package org.invested.accountservice.config.security.filter;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.invested.accountservice.models.security.JsonWebTokenUTIL;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import static java.util.Arrays.stream;

public class CustomAuthorizationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // Grabbing authorization header from request
        String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        if(isValidHeader(authHeader)) {
            try {
                DecodedJWT decodedJWT = decodeJWT(getJWTToken(authHeader));
                UsernamePasswordAuthenticationToken authToken = generateUserPassAuthToken(decodedJWT);
                SecurityContextHolder.getContext().setAuthentication(authToken);
                filterChain.doFilter(request, response);
            } catch(Exception e) {
                // If hit here then we had an issue with the Auth Header
                response.setHeader("error", e.getMessage());
                response.setStatus(HttpStatus.FORBIDDEN.value());

                // Generating Error Response
                Map<String, String> error = new HashMap<>();
                error.put("error_message", e.getMessage());
                response.setContentType("application/json");
                new ObjectMapper().writeValue(response.getOutputStream(), error);
            }
        } else {
            filterChain.doFilter(request, response);
        }
    }

    public boolean isValidHeader(String authHeader) {
        // Checking to see if auth header is a bearer token
        return authHeader != null && authHeader.startsWith("Bearer ");
    }

    public String getJWTToken(String bearerToken) {
        return bearerToken.substring("Bearer ".length());
    }

    public DecodedJWT decodeJWT(String tokenToDecode) {
        // Getting key and verifying if legit token
        Algorithm algo = JsonWebTokenUTIL.getAlgorithm();
        JWTVerifier verifier = JWT.require(algo).build();
        return verifier.verify(tokenToDecode);
    }

    public UsernamePasswordAuthenticationToken generateUserPassAuthToken(DecodedJWT token) {
        // Pulling information off of Json Web Token
        String username = token.getSubject();
        String[] roles = token.getClaim("roles").asArray(String.class);
        Collection<SimpleGrantedAuthority> authorities = new ArrayList<>();
        stream(roles).forEach(role -> {authorities.add(new SimpleGrantedAuthority(role));});

        // Generating UserPassAuthToken for Spring
        return new UsernamePasswordAuthenticationToken(username, null, authorities);
    }
}
