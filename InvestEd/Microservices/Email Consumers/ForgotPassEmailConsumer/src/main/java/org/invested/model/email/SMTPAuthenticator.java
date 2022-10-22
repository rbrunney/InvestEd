package org.invested.model.email;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticator extends Authenticator {
    public PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(SendEmail.senderEmail, SendEmail.senderPassword);
    }
}
