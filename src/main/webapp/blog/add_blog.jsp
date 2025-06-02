<%--
  Created by IntelliJ IDEA.
  User: HieuPC
  Date: 26-May-25
  Time: 2:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm bài viết mới</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #007bff;
            margin-bottom: 30px;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 6px;
            color: #333;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        .form-check {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .form-check input[type="checkbox"] {
            margin-right: 10px;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .submit-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Thêm bài viết mới</h1>

    <form action="add-blog" method="post" enctype="multipart/form-data">
        <label for="blogName">Tiêu đề</label>
        <input type="text" name="blogName" id="blogName" required>

        <label for="imageFile">Ảnh</label>
        <input type="file" name="imageFile" id="imageFile" accept="image/*" required>

        <label for="author">Tác giả</label>
        <input type="text" name="author" id="author" required>

        <label for="content">Nội dung</label>
        <textarea name="content" id="content" rows="6" required></textarea>

        <label for="date">Ngày đăng</label>
        <input type="date" name="date" id="date" required>

        <label for="typeId">Loại</label>
        <input type="number" name="typeId" id="typeId" required>

        <div class="form-check">
            <input type="checkbox" name="selectedBanner" id="selectedBanner">
            <label for="selectedBanner">Hiển thị trên banner</label>
        </div>

        <button type="submit" class="submit-btn">Thêm Blog</button>
        <a class="back-link" href="blog">← Quay về</a>
    </form>
</div>

</body>
</html>