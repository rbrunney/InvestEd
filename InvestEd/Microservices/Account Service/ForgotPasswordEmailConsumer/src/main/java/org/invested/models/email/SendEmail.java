package org.invested.models.email;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class SendEmail {
    final static String senderEmail = System.getenv("EMAIL");
    final static String senderPassword = System.getenv("EMAIL_PASSWORD");
    final String emailSMTPServer = "smtp.gmail.com";
    final String emailServerPort = "465";
    String receiverEmail;
    static String emailSubject;
    static String emailBody;

    public SendEmail(String receiverEmail, String subject, String body) {
        this.receiverEmail = receiverEmail;
        emailSubject = subject;
        emailBody = body;

        Properties props = new Properties();
        props.put("mail.smtp.user", senderEmail);
        props.put("mail.smtp.host", emailSMTPServer);
        props.put("mail.smtp.port", emailServerPort);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.socketFactory.port", emailServerPort);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");

        try {
            Authenticator auth = new SMTPAuthenticator();
            Session session = Session.getInstance(props, auth);
            MimeMessage msg = new MimeMessage(session);
            msg.setContent(emailBody, "text/html");
            msg.setSubject(emailSubject);
            msg.setFrom(new InternetAddress(senderEmail, "InvestEd"));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(receiverEmail));
            Transport.send(msg);
            System.out.println("Email Sent Successfully");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
