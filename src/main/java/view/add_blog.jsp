<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm bài viết mới</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #eafaf1;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 700px;
            margin: 50px auto;
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }

        h1 {
            text-align: center;
            color: #28a745;
            margin-bottom: 35px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-bottom: 8px;
            color: #2f4f4f;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            box-sizing: border-box;
            transition: border-color 0.3s ease;
        }

        input:focus,
        textarea:focus {
            border-color: #28a745;
            outline: none;
        }

        textarea {
            resize: vertical;
        }

        .form-check {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }

        .form-check input[type="checkbox"] {
            margin-right: 10px;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #218838;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-align: center;
            width: 100%;
            color: #28a745;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .back-link:hover {
            color: #1e7e34;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>📝 post</h1>

    <form action="add-blog" method="post" enctype="multipart/form-data">
        <label for="blogName">📝 Title</label>
        <input type="text" name="blogName" id="blogName" required>

        <label for="imageFile">🖼️ picture</label>
        <input type="file" name="imageFile" id="imageFile" accept="image/*" required>

        <label for="author">✍️ writer</label>
        <input type="text" name="author" id="author" required>

        <label for="content">📄 content</label>
        <textarea name="content" id="content" rows="6" required></textarea>

        <label for="date">📅 post date</label>
        <input type="date" name="date" id="date" required>

        <label for="typeId">🏷️ type</label>
        <input type="number" name="typeId" id="typeId" required>

        <div class="form-check">
            <input type="checkbox" name="selectedBanner" id="selectedBanner">
            <label for="selectedBanner">show on banner</label>
        </div>

        <button type="submit" class="submit-btn">✅ add</button>
        <a class="back-link" href="blog">← back</a>
    </form>
</div>

</body>
</html>

