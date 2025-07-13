<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
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
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
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

        .success-message {
            color: #4a9a44;
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

        .google-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background-color: #db4437;
            color: white;
            border: none;
            padding: 12px;
            width: 93.75%;
            border-radius: 6px;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            margin-top: 15px;
            text-decoration: none;
        }

        .google-btn img {
            width: 20px;
            height: 20px;
        }

        .google-btn:hover {
            background-color: #c23321;
        }

        input[type="text"],
        input[type="password"],
        select {
            width: 100%;
            padding: 12px 14px;
            margin: 10px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 15px;
            font-family: inherit;
            line-height: 1.5;
            box-sizing: border-box;
            display: block;
        }


    </style>
</head>
<body>

<div class="login-container">
    <h2>Login</h2>
    <% String error = (String) request.getAttribute("error"); %>
    <% String success = (String) request.getAttribute("success"); %>
    <% if (error != null) { %>
    <div class="error-message"><%= error %>
    </div>
    <% } %>
    <% if (success != null) { %>
    <div class="success-message"><%= success %>
    </div>
    <% } %>
    <% String msg = request.getParameter("msg"); %>
    <% if ("register_success".equals(msg)) { %>
    <p style="color: green; font-weight: bold;">Đã tạo tài khoản thành công. Vui lòng đăng nhập.</p>
    <% } %>


    <form action="login" method="post">
        <input type="text" name="username" placeholder="Username" value="${username}" required/>
        <input type="password" name="password" placeholder="Password" value="${password}" required/>

        <select name="login-as" style="margin-bottom: 10px" required>
            <option value="Patient">Patient</option>
            <option value="Employee">Employee</option>
        </select>


        <input type="submit" value="Login"/>
    </form>

    <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:8080/benhVienLmao_war_exploded/google-login&response_type=code&client_id=497598502234-jmgcibueto8hc1qh61gngkr44pcu90c6.apps.googleusercontent.com&prompt=consent" class="google-btn">
        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo">
        Sign in with Google
    </a>


    <div class="link-group mt-3">
        <a href="forgot-password.jsp">Forgot Password?</a>
        <a href="register.jsp">Don't have an account?</a>

    </div>
</div>

</body>
</html>