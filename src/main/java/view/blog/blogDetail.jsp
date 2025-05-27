<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Blog, model.Comment" %>
<%@ page import="java.util.List" %>
<%
  Blog blog = (Blog) request.getAttribute("blog");
  List<Comment> comments = (List<Comment>) request.getAttribute("comments");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= blog != null ? blog.getBlogName() : "Chi tiết bài viết" %></title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<% if (blog != null) { %>
<h1><%= blog.getBlogName() %></h1>
<p><strong>Tác giả:</strong> <%= blog.getAuthor() %> | <strong>Ngày:</strong> <%= blog.getDate() %></p>
<img src="<%= blog.getImage() %>" alt="ảnh bài viết" style="max-width:400px;"><br><br>
<p><%= blog.getContent() %></p>

<h2>Bình luận</h2>
<% if (comments != null && !comments.isEmpty()) {
  for (Comment c : comments) { %>
<div class="comment">
  <p><strong>Patient #<%= c.getPatientId() %></strong> - <%= c.getDate() %></p>
  <p><%= c.getContent() %></p>
  <hr>
</div>
<%  } } else { %>
<p>Chưa có bình luận nào.</p>
<% } %>
<% } else { %>
<p>Bài viết không tồn tại.</p>
<% } %>

</body>
</html>