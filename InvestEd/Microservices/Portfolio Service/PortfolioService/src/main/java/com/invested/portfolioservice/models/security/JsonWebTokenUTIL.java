package com.invested.portfolioservice.models.security;

import com.auth0.jwt.algorithms.Algorithm;

public class JsonWebTokenUTIL {

    private static final Algorithm algorithm = Algorithm.HMAC256(System.getenv("JWT_SECRET").getBytes());

    public static Algorithm getAlgorithm() {
        return algorithm;
    }
}
