package org.invested.accountservice.models.security;

import javax.crypto.Cipher;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

// Rivest-Shamir-Adleman Algorithm
public class RSA {

    private final PrivateKey rsaPrivateKey = extractPrivateKey(System.getenv("RSA_PRIVATE_KEY"));
    private final PublicKey rsaPublicKey = extractPublicKey(System.getenv("RSA_PUBLIC_KEY"));

    public String encrypt(String msgToEncrypt) {
        try {
            Cipher encryptCipher = Cipher.getInstance("RSA"); // Starting instance of RSA
            encryptCipher.init(Cipher.ENCRYPT_MODE, rsaPublicKey); // Intializing encrypt mode ith key
            return Base64.getEncoder().encodeToString(encryptCipher.doFinal(msgToEncrypt.getBytes(StandardCharsets.UTF_8))); // Doing actual encryption
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }

        return null;
    }

    public String decrypt(byte[] encryptedMessage) {
        try {
            Cipher decryptCipher = Cipher.getInstance("RSA"); // Starting instance of RSA
            decryptCipher.init(Cipher.DECRYPT_MODE, rsaPrivateKey); // Initializing decrypt mode with key
            return new String(decryptCipher.doFinal(encryptedMessage), StandardCharsets.UTF_8); // Doing actual decryption
        } catch (Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }

        return null;
    }

    private PrivateKey extractPrivateKey(String privateKeyPem) {
        privateKeyPem = privateKeyPem.replace("-----BEGIN RSA PRIVATE KEY-----", "");
        privateKeyPem = privateKeyPem.replace("-----END RSA PRIVATE KEY-----", "");
        privateKeyPem = privateKeyPem.replace(" ", "");

        // Decode the Base64
        byte[] pkcs8EncodeBytes = Base64.getDecoder().decode(privateKeyPem);

        // Extracting the private key

        try {
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(pkcs8EncodeBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            return kf.generatePrivate(keySpec);
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }

        return null;
    }

    private PublicKey extractPublicKey(String publicKeyPem) {
        publicKeyPem = publicKeyPem.replace("-----BEGIN PUBLIC KEY-----", "");
        publicKeyPem = publicKeyPem.replace("-----END PUBLIC KEY-----", "");
        publicKeyPem = publicKeyPem.replace("\\s+", "");

        // Decode the Base64
        byte[] pkcs8EncodeBytes = Base64.getDecoder().decode(publicKeyPem);

        // Extracting the private key
        try {
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(pkcs8EncodeBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            return kf.generatePublic(keySpec);
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }

        return null;
    }
}
