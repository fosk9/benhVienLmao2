package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Comment;
import model.Patient;
import model.Category;
import view.BlogDAO;
import view.CommentDAO;
import view.PatientDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/blog-detail")
public class BlogDetailServlet extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();
    private final CommentDAO commentDAO = new CommentDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tham số id từ request
            String idParam = request.getParameter("id");

            // Kiểm tra tham số id hợp lệ (phải là số dương)
            if (idParam == null || !idParam.matches("\\d+")) {
                // Nếu không hợp lệ, chuyển hướng về trang blog chính
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }

            int blogId = Integer.parseInt(idParam);

            // Lấy blog theo id
            Blog blog = blogDAO.select(blogId);

            // Kiểm tra nếu blog không tồn tại
            if (blog == null) {
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }

            // Lấy danh mục và bài viết gần nhất để hiển thị trong blog-sidebar
            List<Category> categories = blogDAO.getCategoriesWithBlogCount();
            List<Blog> recentBlogs = blogDAO.getRecentBlogs();

            // Lấy số trang và số bình luận mỗi trang từ request
            int currentPage = 1;  // Mặc định là trang 1
            int commentsPerPage = 5;  // Số bình luận mỗi trang

            String pageParam = request.getParameter("page");
            if (pageParam != null && pageParam.matches("\\d+")) {
                currentPage = Integer.parseInt(pageParam);
            }

            // Tính toán offset (vị trí bắt đầu lấy bình luận)
            int offset = (currentPage - 1) * commentsPerPage;

            // Lấy tổng số bình luận
            int totalComments = commentDAO.getTotalCommentsByBlogId(blogId);

            // Tính số trang
            int totalPages = (int) Math.ceil((double) totalComments / commentsPerPage);

            // Lấy các bình luận của blog với phân trang
            List<Comment> comments = commentDAO.getCommentsByBlogId(blogId, offset, commentsPerPage);

            // Đưa các dữ liệu vào request để truyền đến JSP
            request.setAttribute("blog", blog);
            request.setAttribute("comments", comments);
            request.setAttribute("categories", categories);
            request.setAttribute("recentBlogs", recentBlogs);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            // Chuyển tiếp đến trang blog-detail.jsp
            request.getRequestDispatcher("/blog-detail.jsp").forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [BlogDetailServlet] doPost called ===");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String email = request.getParameter("userEmail");
        String content = request.getParameter("content");
        String blogId = request.getParameter("blogId");

        System.out.println("username: " + username);
        System.out.println("email: " + email);
        System.out.println("content: " + content);
        System.out.println("blogId: " + blogId);

        String patientImage = null;

        try {
            // Kiểm tra xem người dùng đã đăng nhập chưa
            if (username != null) {
                System.out.println("User is logged in.");
                // Nếu đã đăng nhập, lấy thông tin bệnh nhân từ database
                Patient patient = patientDAO.getPatientByUsername(username);
                System.out.println("Patient by username: " + patient);
                if (patient != null) {
                    patientImage = patient.getPatientAvaUrl();

                    java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
                    int blogIdInt;
                    try {
                        blogIdInt = Integer.parseInt(blogId);
                    } catch (Exception e) {
                        request.setAttribute("errorMessage", "ID bài viết không hợp lệ.");
                        forwardWithError(request, response, email, content, blogId);
                        return;
                    }
                    Comment comment = Comment.builder()
                            .patientName(patient.getFullName())
                            .patientEmail(patient.getEmail())
                            .patientId(patient.getPatientId())
                            .patientImage(patientImage)
                            .content(content)
                            .date(currentDate)
                            .blogId(blogIdInt)
                            .build();

                    System.out.println("Insert comment: " + comment);
                    int result = commentDAO.insert(comment);

                    System.out.println("Insert result: " + result);

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
                System.out.println("User is NOT logged in.");
                // Nếu chưa đăng nhập, yêu cầu nhập email và tên
                if (email != null && content != null && !content.trim().isEmpty()) {
                    // Kiểm tra email đã đăng ký
                    Patient patient = patientDAO.getPatientByEmail(email);
                    System.out.println("Patient by email: " + patient);

                    if (patient != null) {
                        String patientName = patient.getFullName();
                        java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
                        int blogIdInt;
                        try {
                            blogIdInt = Integer.parseInt(blogId);
                        } catch (Exception e) {
                            request.setAttribute("errorMessage", "ID bài viết không hợp lệ.");
                            forwardWithError(request, response, email, content, blogId);
                            return;
                        }
                        Comment comment = Comment.builder()
                                .patientName(patientName)
                                .patientId(patient.getPatientId())
                                .patientEmail(email)
                                .patientImage(patient.getPatientAvaUrl()) // Nếu không có ảnh từ bệnh nhân, để null
                                .content(content)
                                .date(currentDate)
                                .blogId(blogIdInt)
                                .build();

                        System.out.println("Insert comment: " + comment);
                        int result = commentDAO.insert(comment);

                        System.out.println("Insert result: " + result);

                        if (result > 0) {
                            response.sendRedirect("blog-detail?id=" + blogId);
                            return;
                        } else {
                            request.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi bình luận.");
                        }
                    } else {
                        request.setAttribute("errorMessage", "Email này chưa được đăng ký. Hãy đăng ký tài khoản để có thể comment.");
                    }
                } else {
                    request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi trong doPost BlogDetailServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        // Khi có lỗi, load lại dữ liệu và forward về JSP
        forwardWithError(request, response, email, content, blogId);
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String email, String content, String blogId)
            throws ServletException, IOException {
        int blogIdInt = -1;
        try {
            blogIdInt = Integer.parseInt(blogId);
        } catch (Exception ignore) {}

        Blog blog = blogDAO.select(blogIdInt);

        List<Comment> comments;
        try {
            if (blogIdInt > 0) {
                comments = commentDAO.selectCommentsByBlogId(blogIdInt);
            } else {
                comments = java.util.Collections.emptyList();
                request.setAttribute("errorMessage", "Không tìm thấy ID bài viết để lấy bình luận.");
            }
        } catch (Exception ex) {
            comments = java.util.Collections.emptyList();
            request.setAttribute("errorMessage", "Lỗi khi lấy bình luận: " + ex.getMessage());
        }

        List<Category> categories = blogDAO.getCategoriesWithBlogCount();
        List<Blog> recentBlogs = blogDAO.getRecentBlogs();

        request.setAttribute("blog", blog);
        request.setAttribute("comments", comments);
        request.setAttribute("categories", categories);
        request.setAttribute("recentBlogs", recentBlogs);

        // Trả lại giá trị form cho người dùng
        request.setAttribute("userEmail", email);
        request.setAttribute("content", content);
        request.setAttribute("blogId", blogId);

        request.getRequestDispatcher("/blog-detail.jsp").forward(request, response);
    }
}