package org.invested.accountservice.models.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import org.invested.accountservice.respository.AccountJPARepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Date;
import java.util.stream.Collectors;

public class JsonWebToken {
    private final String generatedToken;

    public JsonWebToken(UserDetails user, String email,Algorithm algorithm, int expireTimeInMinutes) {
        // Creating JWT
        generatedToken = JWT.create()
                .withSubject(user.getUsername())
                .withExpiresAt(new Date(System.currentTimeMillis() + (long) expireTimeInMinutes * 60 * 1000)) // Giving it expiration date
                .withIssuer(System.getenv("JWT_ISSUER"))
                .withClaim("email", email)
                .withClaim("roles", user.getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(Collectors.toList()))
                .sign(algorithm);
    }

    public String getGeneratedToken() {
        return generatedToken;
    }
}
