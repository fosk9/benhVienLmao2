<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Blog Sức Khỏe</title>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f5f5f5;
    }

    .banner {
      background-color: #2196F3;
      color: white;
      padding: 30px 20px;
      text-align: center;
      font-size: 2em;
      font-weight: bold;
    }

    .container {
      display: flex;
      padding: 20px;
    }

    .left-column {
      width: 65%;
      padding-right: 20px;
    }

    .right-column {
      width: 35%;
      background-color: #ffffff;
      padding: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      border-radius: 10px;
    }

    .post {
      background-color: white;
      padding: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #2196F3;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .post h3 {
      margin-top: 0;
    }

    .summary-title {
      font-size: 1.5em;
      margin-bottom: 15px;
      color: #333;
    }

    .summary-text {
      font-size: 1em;
      color: #666;
      line-height: 1.6;
    }
  </style>ư
</head>
<body>

<div class="banner">
  Chào mừng đến với Blog Sức Khỏe
</div>

<div class="container">
  <div class="left-column">
    <div class="post">
      <h3><a href="blogDetail.jsp?id=1" style="text-decoration:none; color:inherit;">Cẩm nang dinh dưỡng</a></h3>
      <p>Ăn uống đủ chất, ngủ đủ giấc, vận động đều đặn và kiểm soát stress là những cách hiệu quả để có một sực khỏe tốt.</p>
    </div>
    <div class="post">
      <h3><a href="blogDetail.jsp?id=2" style="text-decoration:none; color:inherit;">Tác Dụng Của Việc Uống Nước Đúng Cách</a></h3>
      <p>Uống đủ nước giúp thải độc tố, hỗ trợ tiêu hóa và làm đẹp da. Tránh uống quá nhiều một lúc hoặc khi quá khát.</p>
    </div>
  </div>

  <div class="right-column">
    <div class="summary-title">Tóm tắt nổi bật</div>
    <div class="summary-text">
      Trang blog sức khỏe chia sẻ các bài viết hữu ích về dinh dưỡng, vận động, phòng tránh bệnh tật và nâng cao sức khỏe tinh thần. Cập nhật mỗi ngày với      kiến thức đáng tin cậy từ các chuyên gia.
    </div>
  </div>
</div>

</body>
</html>
