package controller;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendingEmail {

    private final String username = "sonnphe181147@fpt.edu.vn";
    private final String password = "iejn bxay jihg djiq"; // Mật khẩu ứng dụng

    // Trả về true nếu gửi thành công, false nếu thất bại
    public boolean sendEmail(String to, String subject, String body) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
            System.out.println("✅ Email sent successfully to " + to);
            return true;
        } catch (MessagingException e) {
            System.err.println("❌ Failed to send email to " + to);
            e.printStackTrace();
            return false;
        }
    }
}
