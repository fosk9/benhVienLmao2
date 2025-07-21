package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Category;
import model.Comment;
import model.Employee;
import util.HistoryLogger;
import view.BlogDAO;
import view.CommentDAO;

import java.io.IOException;
import java.util.List;

@WebServlet({"/blog-dashboard", "/blog-dashboard/edit", "/blog-dashboard/delete"})
public class BlogDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        try {
            if ("/blog-dashboard".equals(path)) {
                // Lấy tổng số blog và danh mục
                int totalBlogs = blogDAO.getTotalBlogsCount();
                List<Category> categories = blogDAO.getAllCategories();

                // Tham số phân trang
                int page = 1;  // Trang mặc định là 1
                int limit = 5;  // Số lượng blog mỗi trang
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }
                int offset = (page - 1) * limit; // Sửa: offset phải là (page-1)*limit

                // Tìm kiếm và lọc blog
                String keyword = request.getParameter("keyword");
                String categoryIdParam = request.getParameter("categoryId");
                List<Blog> blogList;
                Integer selectedCategoryId = null;
                String errorMessage = null;

                // Kiểm tra từ khóa tìm kiếm
                if (keyword != null) {
                    keyword = keyword.trim().toLowerCase().replaceAll("\\s+", " ");
                }

                if (keyword != null && !keyword.isEmpty() && categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    try {
                        selectedCategoryId = Integer.parseInt(categoryIdParam);
                        blogList = blogDAO.searchBlogsByNameAndCategory(keyword, selectedCategoryId, offset, limit); // Sửa: truyền offset
                    } catch (NumberFormatException ex) {
                        blogList = blogDAO.select(offset, limit);
                    }
                } else if (keyword != null && !keyword.isEmpty()) {
                    blogList = blogDAO.searchBlogsByName(keyword, offset, limit); // Sửa: truyền offset
                } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    try {
                        selectedCategoryId = Integer.parseInt(categoryIdParam);
                        blogList = blogDAO.getBlogsByCategory(selectedCategoryId, offset, limit); // Sửa: truyền offset
                    } catch (NumberFormatException ex) {
                        blogList = blogDAO.select(offset, limit);
                    }
                } else {
                    blogList = blogDAO.select(offset, limit); // Sửa: truyền offset
                }

                // Tính tổng số trang
                int totalPages = (int) Math.ceil((double) totalBlogs / limit);

                // Gửi dữ liệu đến JSP
                request.setAttribute("totalBlogs", totalBlogs);
                request.setAttribute("categories", categories);
                request.setAttribute("blogList", blogList);
                request.setAttribute("selectedCategoryId", selectedCategoryId);
                request.setAttribute("keyword", keyword);
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
                request.getRequestDispatcher("/Manager/blog-dashboard.jsp").forward(request, response);
            } else if ("/blog-dashboard/edit".equals(path)) {
                String blogIdStr = request.getParameter("blogId");
                System.out.println("[GET] blogIdStr: " + blogIdStr);
                try {
                    if (blogIdStr == null || blogIdStr.trim().isEmpty()) {
                        throw new NumberFormatException("blogId null hoặc rỗng");
                    }
                    int blogId = Integer.parseInt(blogIdStr.trim());
                    Blog blog = blogDAO.select(blogId);
                    List<Category> categories = blogDAO.getAllCategories();
                    if (blog != null) {
                        System.out.println("[GET] blogId truyền sang JSP: " + blog.getBlogId());
                        request.setAttribute("blog", blog);
                        request.setAttribute("categories", categories);
                        request.getRequestDispatcher("/Manager/edit-blog.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy blog với ID: " + blogId);
                    }
                } catch (NumberFormatException ex) {
                    request.setAttribute("errorMessage", "ID blog không hợp lệ hoặc thiếu.");
                }
                response.sendRedirect(request.getContextPath() + "/blog-dashboard");
            } else if ("/blog-dashboard/delete".equals(path)) {
                String blogIdStr = request.getParameter("blogId");
                System.out.println("blogIdStr: " + blogIdStr);
                Employee manager = (Employee) request.getSession().getAttribute("account");
                if (manager == null || manager.getRoleId() != 4) {
                    request.setAttribute("error", "You must be logged in as a manager to perform this action.");
                    response.sendRedirect("login.jsp");
                    return;
                }
                try {
                    if (blogIdStr == null || blogIdStr.trim().isEmpty()) {
                        throw new NumberFormatException("blogId null hoặc rỗng");
                    }
                    int blogId = Integer.parseInt(blogIdStr.trim());
                    blogDAO.delete(blogId);
                    if (manager != null) {
                        HistoryLogger.log(
                                manager.getEmployeeId(),
                                manager.getFullName(),
                                blogId,
                                "Blog ID " + blogId,
                                "Blog",
                                "Delete Blog ID: " + blogId
                        );
                    }
                } catch (NumberFormatException ex) {
                    System.out.println("[BlogDashboardServlet] Invalid blogId: " + ex.getMessage());
                }
                response.sendRedirect(request.getContextPath() + "/blog-dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ chuyển sang GET để tránh xử lý POST ở servlet này
        doGet(request, response);
    }
}