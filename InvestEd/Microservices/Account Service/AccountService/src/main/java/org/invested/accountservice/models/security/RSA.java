package org.invested.accountservice.models.security;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

// Rivest-Shamir-Adleman Algorithm
public class RSA {

    private PrivateKey privateKey;
    private PublicKey publicKey;

    private static final String PUBLIC_KEY = System.getenv("RSA_PUBLIC_KEY").replace("\"", "");
    private static final String PRIVATE_KEY = System.getenv("RSA_PRIVATE_KEY").replace("\"", "");

    public void init() {
        try {
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
            generator.initialize(2048);
            KeyPair pair = generator.generateKeyPair();

            privateKey = pair.getPrivate();
            publicKey = pair.getPublic();
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }
    }

    public void initFromStrings() {
        try {
            X509EncodedKeySpec keySpecPublic = new X509EncodedKeySpec(decode(PUBLIC_KEY));
            PKCS8EncodedKeySpec keySpecPrivate = new PKCS8EncodedKeySpec(decode(PRIVATE_KEY));

            KeyFactory keyFactory = KeyFactory.getInstance("RSA");

            publicKey = keyFactory.generatePublic(keySpecPublic);
            privateKey = keyFactory.generatePrivate(keySpecPrivate);
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
        }
    }

    public void printKeys() {
        System.out.println(encode(publicKey.getEncoded()));
        System.out.println(encode(privateKey.getEncoded()));
    }

    public String encrypt(String msgToEncrypt) throws Exception {
        byte[] msgToBytes = msgToEncrypt.getBytes();
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(msgToBytes);
        return encode(encryptedBytes);
    }

    private String encode(byte[] data) {
        return Base64.getEncoder().encodeToString(data);
    }

    public String decrypt(String msgToDecrypt) {

        try {
            byte[] encryptedBytes = decode(msgToDecrypt);
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

            return new String(decryptedBytes, "UTF8");
        } catch(Exception e) {
            System.out.println("[ERROR] " + e.getMessage());
            return "";
        }
    }

    private byte[] decode(String data) {
        return Base64.getDecoder().decode(data);
    }
}
