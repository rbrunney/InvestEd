package org.invested.accountservice.config.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.invested.accountservice.config.models.JWTUtil;
import org.invested.accountservice.config.models.JsonWebToken;
import org.invested.accountservice.config.models.RSA;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class CustomAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    private final AuthenticationManager authenticationManager;

    public CustomAuthenticationFilter(AuthenticationManager authenticationManager) {
        this.authenticationManager = authenticationManager;
    }

    // Checks to see if user is authenticated

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Decrypting user information that was encrypted
        username = new RSA().decrypt(username.getBytes());
        password = new RSA().decrypt(password.getBytes());

        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(username, password);

        return authenticationManager.authenticate(authenticationToken);
    }

    // If successful this is where we will generate JWT token
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) throws IOException, ServletException {

        User user = (User) authentication.getPrincipal();
        JsonWebToken accessToken = new JsonWebToken(user, JWTUtil.getAlgorithm(), 10);
        JsonWebToken refreshToken = new JsonWebToken(user, JWTUtil.getAlgorithm(), 30);

        Map<String, String> tokens = new HashMap<>();
        tokens.put("access_token", accessToken.getGeneratedToken());
        tokens.put("refresh_token", refreshToken.getGeneratedToken());

        response.setContentType("application/json");
        new ObjectMapper().writeValue(response.getOutputStream(), tokens);
    }
}
