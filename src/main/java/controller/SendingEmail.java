package controller;

// Import các thư viện cần thiết để gửi email qua JavaMail API

import java.util.Properties;

import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendingEmail {

    // Định nghĩa các thông tin đăng nhập cho tài khoản email gửi đi
    private final String username = "sonnphe181147@fpt.edu.vn";
    private final String password = "iejn bxay jihg djiq"; // Mật khẩu ứng dụng

    // Phương thức để gửi email với các tham số: địa chỉ nhận, tiêu đề và nội dung
    public void sendEmail(String to, String subject, String body) {
        // Tạo thuộc tính cho phiên email, bao gồm các cấu hình SMTP
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true"); // Yêu cầu xác thực SMTP
        props.put("mail.smtp.starttls.enable", "true"); // Kích hoạt bảo mật TLS cho kết nối
        props.put("mail.smtp.host", "smtp.gmail.com"); // Máy chủ SMTP của Gmail
        props.put("mail.smtp.port", "587"); // Cổng SMTP cho giao thức bảo mật TLS

        // Tạo phiên làm việc với SMTP server
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // Trả về đối tượng xác thực với tên người dùng và mật khẩu
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Khởi tạo một đối tượng MimeMessage để xây dựng email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username)); // Đặt địa chỉ email gửi đi
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); // Thiết lập địa chỉ nhận email
            message.setSubject(subject); // Đặt tiêu đề email
            message.setText(body); // Đặt nội dung văn bản cho email

            // Thực hiện gửi email qua Transport
            Transport.send(message);
            System.out.println("Email sent successfully to " + to); // Thông báo gửi thành công

        } catch (MessagingException e) {
            // In ra lỗi nếu xảy ra ngoại lệ khi gửi email
            e.printStackTrace();
            throw new RuntimeException(e); // Ném lại ngoại lệ để thông báo cho phương thức gọi
        }
    }
}
