<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Register</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "Segoe UI", sans-serif;
            background: url("assets/img/gallery/about.png") no-repeat left center,
            url("assets/img/gallery/about2.png") no-repeat right center,
            url("assets/img/gallery/footer-bg.png");
            background-size: auto 100%, auto 100%;
            background-color: #f3f3f3;
        }

        .form-container {
            max-width: 800px;
            margin: 60px auto;
            background-color: white;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .form-title {
            text-align: center;
            font-weight: bold;
            margin-bottom: 30px;
            color: #2d2d2d;
        }

        .form-row .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 600;
        }

        .btn-primary {
            width: 100%;
            padding: 12px;
            font-weight: 600;
            background-color: #5AAC4E;
            border: none;
            border-radius: 8px;
        }

        .btn-primary:hover {
            background-color: #4a9a44;
        }

        .alert {
            margin-top: 20px;
            color: #ff2f2f;
            font-weight: 600;
        }

        .link-group {
            text-align: center;
            margin-top: 15px;
            color: #000000;
        }

        .link-group a {
            color: #000000;
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
        }

        .link-group a:hover {
            text-decoration: underline;
            color: red;
            opacity: 0.5;
        }

        .form-group input,
        .form-group select {
            border-radius: 8px;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="form-container">
        <h2 class="form-title">Patient Registration</h2>

        <form action="register" method="post">
            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Username:</label>
                    <input name="username" class="form-control" required>
                </div>
                <div class="form-group col-md-6">
                    <label>Password:</label>
                    <input name="password" type="password" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Full Name:</label>
                    <input name="full_name" class="form-control">
                </div>
                <div class="form-group col-md-6">
                    <label>Date of Birth:</label>
                    <input name="dob" type="date" class="form-control">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Gender:</label>
                    <select name="gender" class="form-control">
                        <option value="M">Male</option>
                        <option value="F">Female</option>
                    </select>
                </div>
                <div class="form-group col-md-6">
                    <label>Email:</label>
                    <input name="email" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Phone:</label>
                    <input name="phone" class="form-control">
                </div>
                <div class="form-group col-md-6">
                    <label>Address:</label>
                    <input name="address" class="form-control">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-md-6">
                    <label>Insurance Number:</label>
                    <input name="insurance_number" class="form-control">
                </div>
                <div class="form-group col-md-6">
                    <label>Emergency Contact:</label>
                    <input name="emergency_contact" class="form-control">
                </div>
            </div>

            <button type="submit" class="btn btn-primary" onclick="return confirm('Bạn có chắc chắn muốn đăng ký không?');">Register</button>
            <div class="link-group">
                <a href="login.jsp">Already have an account? Login</a>
            </div>
        </form>

        <c:if test="${not empty error}">
            <div class="alert">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert">${success}</div>
        </c:if>
    </div>
</div>
</body>
</html>