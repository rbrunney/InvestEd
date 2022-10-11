package org.invested.accountservice.models;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Date;
import java.util.stream.Collectors;

public class JsonWebToken {
    private final String generatedToken;

    public JsonWebToken(User user, Algorithm algorithm, int expireTimeInMinutes) {
        // Creating JWT
        generatedToken = JWT.create()
                .withSubject(user.getUsername())
                .withExpiresAt(new Date(System.currentTimeMillis() + (long) expireTimeInMinutes * 60 * 1000)) // Giving it expiration date
                .withIssuer(System.getenv("JWT_ISSUER"))
                .withClaim("roles", user.getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(Collectors.toList()))
                .sign(algorithm);
    }

    public String getGeneratedToken() {
        return generatedToken;
    }
}
