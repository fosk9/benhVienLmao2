package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Category;
import view.BlogDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/blog")
public class BlogControllerServlet extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int currentPage = 1;
        int pageSize = 4;  // Giới hạn số bài viết mỗi trang

        // Kiểm tra tham số trang trong URL (ví dụ: ?page=2)
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1; // Nếu không phải là số hợp lệ thì mặc định là trang 1
            }
        }

        // Tính toán offset (vị trí bắt đầu của dữ liệu trong cơ sở dữ liệu)
        int offset = (currentPage - 1) * pageSize;

        // Lấy tham số tìm kiếm từ request
        String searchKeyword = request.getParameter("search");

        // Lấy tham số danh mục từ request
        String categoryIdParam = request.getParameter("categoryId");

        // Kiểm tra nếu có tìm kiếm theo từ khóa
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // Loại bỏ khoảng trắng thừa ở đầu và cuối chuỗi, và thay thế nhiều khoảng trắng bằng 1 khoảng trắng duy nhất
            searchKeyword = searchKeyword.trim().replaceAll("\\s+", " ");

            // Lấy kết quả tìm kiếm từ BlogDAO với phân trang
            List<Blog> searchResults = blogDAO.searchBlogsByName(searchKeyword, offset, pageSize);

            // Lấy tổng số kết quả tìm kiếm
            int totalBlogs = blogDAO.getTotalBlogsCount(searchKeyword);
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

            // Đưa kết quả tìm kiếm vào request
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchKeyword", searchKeyword);  // Đưa từ khóa tìm kiếm vào để hiển thị lại
            request.setAttribute("currentPage", currentPage);  // Trang hiện tại
            request.setAttribute("totalPages", totalPages);    // Tổng số trang
        }
        // Kiểm tra nếu có tìm kiếm theo danh mục
        else if (categoryIdParam != null) {
            try {
                // Loại bỏ khoảng trắng thừa ở đầu và cuối chuỗi
                categoryIdParam = categoryIdParam.trim();
                if (categoryIdParam.isEmpty() || !categoryIdParam.matches("\\d+")) {
                    throw new NumberFormatException("Invalid or empty category ID");
                }
                int categoryId = Integer.parseInt(categoryIdParam);

                // Lấy bài viết theo danh mục với phân trang
                List<Blog> blogListByCategory = blogDAO.getBlogsByCategory(categoryId, offset, pageSize);

                // Lấy tổng số bài viết của danh mục
                int totalBlogsByCategory = blogDAO.getTotalBlogsCountByCategory(categoryId);
                int totalPages = (int) Math.ceil((double) totalBlogsByCategory / pageSize);

                // Đưa kết quả theo danh mục vào request
                request.setAttribute("blogListByCategory", blogListByCategory);
                request.setAttribute("categoryId", categoryId);  // Đưa danh mục vào để hiển thị trang hiện tại
                request.setAttribute("currentPage", currentPage);  // Trang hiện tại
                request.setAttribute("totalPages", totalPages);    // Tổng số trang
            } catch (Exception e) {
                // Nếu lỗi, chuyển hướng về trang blog chính (hoặc forward với thông báo lỗi)
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
        } else {
            // Nếu không có từ khóa tìm kiếm, hiển thị tất cả các bài viết
            List<Blog> blogList = blogDAO.getPaginatedBlogs(offset, pageSize);  // Lấy tất cả các blog với phân trang

            // Lấy tổng số bài viết để tính tổng số trang
            int totalBlogs = blogDAO.getTotalBlogsCount();
            int totalPages = (int) Math.ceil((double) totalBlogs / pageSize);

            // Đưa các dữ liệu vào request
            request.setAttribute("searchResults", blogList);  // Danh sách các blog trên trang
            request.setAttribute("currentPage", currentPage);  // Trang hiện tại
            request.setAttribute("totalPages", totalPages);  // Tổng số trang
        }

        // Lấy các danh mục và bài viết gần nhất
        List<Category> categories = blogDAO.getCategoriesWithBlogCount();
        List<Blog> recentBlogs = blogDAO.getRecentBlogs();

        // Đưa các dữ liệu vào request
        request.setAttribute("categories", categories);  // Các danh mục bài viết
        request.setAttribute("recentBlogs", recentBlogs);  // Bài viết gần nhất

        // Chuyển tiếp đến trang blog.jsp để hiển thị
        request.getRequestDispatcher("/blog.jsp").forward(request, response);
    }

    // Phương thức xử lý yêu cầu POST (nếu có yêu cầu tìm kiếm hoặc xử lý khác)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);  // Gọi lại doGet để xử lý việc tìm kiếm hoặc cập nhật
    }
}