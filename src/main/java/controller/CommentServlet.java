    package controller;

    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;
    import model.Comment;
    import model.Patient;
    import view.CommentDAO;
    import view.PatientDAO;

    import java.io.IOException;
    import java.sql.Date;

    @WebServlet("/add-comment")
    public class CommentServlet extends HttpServlet {

        private final CommentDAO commentDAO = new CommentDAO();
        private final PatientDAO patientDAO = new PatientDAO();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            // Lấy thông tin từ form hoặc session
            HttpSession session = request.getSession();
            String username = (String) session.getAttribute("username"); // Lấy username từ session
            String content = request.getParameter("content");
            String blogId = request.getParameter("blogId");

            String patientImage = null; // Khai báo biến lưu ảnh đại diện của bệnh nhân

            // Kiểm tra xem có session của bệnh nhân không
            if (username != null) {
                // Nếu đã đăng nhập, lấy thông tin bệnh nhân từ database
                Patient patient = patientDAO.getPatientByUsername(username);

                if (patient != null) {
                    patientImage = patient.getPatientAvaUrl(); // Lấy ảnh từ thông tin bệnh nhân

                    // Tạo bình luận và lưu vào cơ sở dữ liệu
                    java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
                    Comment comment = Comment.builder()
                            .patientName(patient.getFullName())
                            .patientImage(patientImage) // Thêm ảnh của bệnh nhân vào bình luận
                            .content(content)
                            .date(currentDate)
                            .blogId(Integer.parseInt(blogId)) // Chuyển blogId từ String sang int
                            .build();

                    int result = commentDAO.insert(comment);

                    // Nếu thêm bình luận thành công, chuyển hướng về trang chi tiết blog
                    if (result > 0) {
                        response.sendRedirect("blog-detail?id=" + blogId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi bình luận.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân.");
                }
            } else {
                // Nếu chưa đăng nhập, yêu cầu nhập thông tin thủ công
                if (content != null && !content.trim().isEmpty()) {
                    java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
                    Comment comment = Comment.builder()
                            .patientName(request.getParameter("userName")) // Lấy tên từ form
                            .patientImage(null) // Nếu không có ảnh từ bệnh nhân, để null
                            .content(content)
                            .date(currentDate)
                            .blogId(Integer.parseInt(blogId)) // Chuyển blogId từ String sang int
                            .build();

                    int result = commentDAO.insert(comment);

                    // Nếu thêm bình luận thành công, chuyển hướng về trang chi tiết blog
                    if (result > 0) {
                        response.sendRedirect("blog-detail?id=" + blogId);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi bình luận.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
                }
            }

            // Trả về lại dữ liệu đã nhập nếu có lỗi
            request.setAttribute("userName", request.getParameter("userName"));
            request.setAttribute("content", content);
            request.setAttribute("blogId", blogId);
            request.getRequestDispatcher("/blog-detail?id=" + blogId).forward(request, response);
        }
    }
