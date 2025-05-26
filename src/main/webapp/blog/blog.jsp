<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.object.Blog"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Blog</title>
  <style>
    body {
      font-family: "Segoe UI", sans-serif;
      margin: 0;
      background-color: #f4f8fc;
    }

    header {
      background: linear-gradient(to right, #8e44ad, #6a1b9a);
      color: white;
      padding: 30px;
      text-align: center;
      font-size: 28px;
      font-weight: bold;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      position: relative;
    }

    .write-btn {
      position: absolute;
      top: 30px;
      right: 30px;
      background-color: #ffffff;
      color: #6a1b9a;
      padding: 8px 15px;
      border-radius: 5px;
      border: 2px solid #6a1b9a;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .write-btn:hover {
      background-color: #d1c4e9;
    }

    .container {
      display: flex;
      padding: 30px;
      gap: 30px;
    }

    .sidebar {
      width: 70%;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    .sidebar h3 {
      margin-bottom: 15px;
      color: #6a1b9a;
      border-bottom: 2px solid #d1c4e9;
      padding-bottom: 5px;
    }

    .sidebar a {
      display: block;
      margin-bottom: 12px;
      font-size: 16px;
      color: #3b0080;
      text-decoration: none;
      transition: all 0.2s;
    }

    .sidebar a:hover {
      color: #6a1b9a;
      padding-left: 5px;
    }

    .content {
      width: 30%;
      padding: 20px;
      background-color: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    .content h3 {
      color: #6a1b9a;
      margin-bottom: 10px;
    }

    .content h2 {
      font-size: 20px;
      color: #3b0080;
      margin-bottom: 5px;
    }

    .content p {
      font-size: 14px;
      margin: 5px 0;
    }

    .content hr {
      margin: 15px 0;
      border: 0;
      height: 1px;
      background-color: #ccc;
    }

    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 10;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0,0,0,0.4);
    }

    .modal-content {
      background-color: #fff;
      margin: 10% auto;
      padding: 20px;
      width: 40%;
      border-radius: 10px;
      box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    .modal-content h3 {
      color: #6a1b9a;
    }

    .modal-content input,
    .modal-content textarea {
      width: 100%;
      padding: 8px;
      margin-top: 10px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .modal-content button {
      padding: 8px 15px;
      background-color: #6a1b9a;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .close {
      float: right;
      font-size: 24px;
      cursor: pointer;
      color: #888;
    }

    .close:hover {
      color: red;
    }
  </style>
</head>
<body>

<header>
  Blog bệnh viện LMAO
  <form action="add_blog.jsp" method="get" style="position: absolute; top: 30px; right: 30px;">
    <button class="write-btn" type="submit">Viết blog</button>
  </form>
</header>

<div class="container">
  <!-- Danh sách blog chính -->
  <div class="sidebar">
    <h3>Danh sách bài viết</h3>
    <%
      List<Blog> blogs = (List<Blog>) request.getAttribute("blogs");
      if (blogs != null) {
        for (Blog b : blogs) {
    %>
    <div style="margin-bottom: 20px;">
      <a href="blog_detail?id=<%= b.getId() %>" style="font-size: 18px; font-weight: bold;"><%= b.getBlogName() %></a>
      <p style="margin: 5px 0;"><strong>Tác giả:</strong> <%= b.getAuthor() %></p>
      <p style="margin: 5px 0;"><strong>Ngày:</strong> <%= b.getDate() %></p>
      <p style="font-size: 14px; color: #444;"><%= b.getSummary() %></p>
      <hr/>
    </div>
    <%
        }
      }
    %>
  </div>

  <div class="content">
    <h3>Nổi bật</h3>
    <%
      if (blogs != null) {
        for (Blog b : blogs) {
    %>
    <p><a href="blog_detail?id=<%= b.getId() %>"><%= b.getBlogName() %></a></p>
    <%
        }
      }
    %>
  </div>
  </div>
</body>
</html>