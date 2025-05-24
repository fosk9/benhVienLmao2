
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
  String id = request.getParameter("id");
  String title = "Tiêu đề mặc định";
  String content = "Nội dung blog sẽ hiển thị tại đây.";

  if ("1".equals(id)) {
    title = "Cẩm Nang Dinh Dưỡng Cho Người Làm Việc Văn Phòng";
    content = "<p>Trong nhịp sống hiện đại, dân văn phòng thường đối mặt với tình trạng ngồi nhiều, ít vận động và áp lực công việc cao.</p>" +
            "<p>Việc bổ sung dinh dưỡng đúng cách giúp cải thiện sức khỏe và nâng cao hiệu suất làm việc.</p>" +
            "<h3>1. Ăn sáng đầy đủ</h3>" +
            "<p>Bữa sáng là nguồn năng lượng chính. Một bữa sáng nên bao gồm tinh bột (bánh mì, yến mạch), đạm (trứng, sữa) và rau quả.</p>" +
            "<h3>2. Uống đủ nước</h3>" +
            "<p>Cơ thể cần ít nhất 1.5 - 2 lít nước mỗi ngày. Nên mang theo bình nước bên cạnh để tránh quên uống nước.</p>" +
            "<h3>3. Ăn vặt lành mạnh</h3>" +
            "<p>Tránh snack, hãy ăn hạt khô, trái cây tươi hoặc sữa chua.</p>" +
            "<h3>4. Tránh ăn trưa quá no</h3>" +
            "<p>Bữa trưa nhẹ giúp bạn không buồn ngủ vào buổi chiều.</p>" +
            "<p>...</p>";
  }else if("2".equals(id)){
    title = "Tác Dụng Của Việc Uống Nước Đúng Cách";
    content = "Chi tiết bài viết về lợi ích của việc uống nước, thải độc, hỗ trợ tiêu hóa...";
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title><%= title %></title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f9f9f9;
      padding: 30px;
    }

    .blog-container {
      max-width: 800px;
      margin: auto;
      background: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    h1 {
      color: #2196F3;
    }

    p {
      font-size: 1.1em;
      line-height: 1.8;
      color: #444;
    }

    .back-link {
      display: block;
      margin-top: 20px;
      text-decoration: none;
      color: #2196F3;
    }
  </style>
</head>
<body>
<div class="blog-container">
  <h1><%= title %></h1>
  <p><%= content %></p>
  <a href="blogList.jsp" class="back-link">← Quay lại danh sách</a>
</div>
</body>
</html>