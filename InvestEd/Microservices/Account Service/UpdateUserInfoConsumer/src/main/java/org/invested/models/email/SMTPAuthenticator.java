package org.invested.models.email;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticator extends Authenticator {
    public PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(SendEmail.senderEmail, SendEmail.senderPassword);
    }
}