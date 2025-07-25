package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Category;
import model.Employee;
import util.HistoryLogger;
import dal.BlogDAO;

import java.io.File;
import java.io.IOException;
import java.util.List;

@MultipartConfig
@WebServlet("/edit-blog")
public class EditBlogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            Employee manager = (Employee) request.getSession().getAttribute("account");
            if (manager == null || manager.getRoleId() != 4) {
                request.setAttribute("error", "You must be logged in as a manager to perform this action.");
                response.sendRedirect("login.jsp");
                return;
            }
            String blogIdStr = request.getParameter("blogId");
            if (blogIdStr == null || blogIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Không tìm thấy ID blog để cập nhật.");
                forwardWithCategories(request, response);
                return;
            }

            int blogId;
            try {
                blogId = Integer.parseInt(blogIdStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID blog không hợp lệ.");
                forwardWithCategories(request, response);
                return;
            }

            String blogName = request.getParameter("blogName");
            String blogSubContent = request.getParameter("blogSubContent");
            String content = request.getParameter("content");
            String author = request.getParameter("author");
            String categoryIdStr = request.getParameter("categoryId");
            String newCategoryName = request.getParameter("newCategoryName");

            if (blogName == null || blogName.trim().isEmpty() ||
                    blogSubContent == null || blogSubContent.trim().isEmpty() ||
                    content == null || content.trim().isEmpty() ||
                    author == null || author.trim().isEmpty() ||
                    categoryIdStr == null || categoryIdStr.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường bắt buộc!");
                forwardWithCategories(request, response);
                return;
            }

            int categoryId;
            if ("other".equals(categoryIdStr)) {
                if (newCategoryName == null || newCategoryName.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Vui lòng nhập tên danh mục mới.");
                    forwardWithCategories(request, response);
                    return;
                }
                categoryId = blogDAO.addNewCategory(newCategoryName.trim());
            } else {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Danh mục không hợp lệ!");
                    forwardWithCategories(request, response);
                    return;
                }
            }

            String blogImagePath;
            try {
                blogImagePath = saveImage(request.getPart("blogImage"));
            } catch (IOException e) {
                request.setAttribute("errorMessage", e.getMessage());
                forwardWithCategories(request, response);
                return;
            }

            if (blogImagePath == null) {
                Blog oldBlog = blogDAO.select(blogId);
                blogImagePath = oldBlog != null ? oldBlog.getBlogImg() : null;
            }

            Blog blog = new Blog();
            blog.setBlogId(blogId);
            blog.setBlogName(blogName);
            blog.setBlogSubContent(blogSubContent);
            blog.setContent(content);
            blog.setAuthor(author);
            blog.setCategoryId(categoryId);
            blog.setBlogImg(blogImagePath);
            blog.setDate(new java.sql.Date(System.currentTimeMillis()));

            int result = blogDAO.update(blog);
            if (result > 0) {
                if (manager != null) {
                    HistoryLogger.log(
                            manager.getEmployeeId(),
                            manager.getFullName(),
                            result, // blog_id được trả về
                            blogName,
                            "Blog",
                            "Edit Blog - " + blogName
                    );
                }
                request.setAttribute("successMessage", "Cập nhật blog thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật blog thất bại!");
            }

            Blog updatedBlog = blogDAO.select(blogId);
            request.setAttribute("blog", updatedBlog);
            forwardWithCategories(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không xác định: " + ex.getMessage());
            forwardWithCategories(request, response);
        }
    }

    private void forwardWithCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = blogDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/Manager/edit-blog.jsp").forward(request, response);
    }

    private String saveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) return null;

        long maxSize = 5 * 1024 * 1024;
        if (imagePart.getSize() > maxSize) {
            throw new IOException("Kích thước file ảnh vượt quá 5MB");
        }

        String fileName = new File(imagePart.getSubmittedFileName()).getName();
        String lowerFileName = fileName.toLowerCase();
        if (!(lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg") ||
                lowerFileName.endsWith(".png") || lowerFileName.endsWith(".gif") || lowerFileName.endsWith(".webp"))) {
            throw new IOException("Chỉ cho phép tải lên các file ảnh JPG, JPEG, PNG, GIF, WEBP.");
        }

        String uploadPath = getServletContext().getRealPath("/assets/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String newFileName = System.currentTimeMillis() + "_" + fileName;
        File file = new File(uploadDir, newFileName);
        imagePart.write(file.getAbsolutePath());

        return "assets/img/blog/" + newFileName;
    }
}