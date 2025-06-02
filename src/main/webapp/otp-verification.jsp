<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: url("assets/img/gallery/about.png") no-repeat left center,
            url("assets/img/gallery/about2.png") no-repeat right center,
            url("assets/img/gallery/footer-bg.png");
            background-size: auto 100%, auto 100%;
            background-color: #f3f3f3;
        }

        .login-container {
            width: 360px;
            margin: 80px auto;
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.15);
            position: relative;
            z-index: 1;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #5AAC4E;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #4a9a44;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }

        .link-group {
            text-align: center;
            margin-top: 15px;
        }

        .link-group a {
            color: #000000;
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
        }

        .link-group a:hover {
            text-decoration: underline;
            color: #1dc116;
            opacity: 0.5;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Enter OTP</h2>
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="error-message"><%= error %></div>
    <% } %>
    <% String msg = request.getParameter("msg"); %>
    <% if ("otp_sent".equals(msg)) { %>
    <p style="color: green; font-weight: bold;">Đã gửi OTP vào email.</p>
    <% } %>


    <form action="verify-otp" method="post">
        <input type="text" name="otp" placeholder="Enter 8-character OTP" required />
        <input type="submit" value="Verify OTP" />
    </form>

    <div class="link-group">
        <a href="forgot-password.jsp">Resend or Try Again</a>
    </div>
</div>

</body>
</html>