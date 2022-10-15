package org.invested.accountservice.models.application;

import redis.clients.jedis.Jedis;

public class RedisUtil {
    public static Jedis redisConnection = new Jedis(System.getenv("REDIS_HOST"), Integer.parseInt(System.getenv("REDIS_PORT")));

}
