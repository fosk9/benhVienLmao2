package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Blog;
import model.Category;
import view.BlogDAO;


import java.io.File;
import java.io.IOException;
import java.util.List;

@MultipartConfig
@WebServlet("/add-blog")
public class AddBlogControllerServlet extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();

    // Phương thức xử lý yêu cầu GET (hiển thị form)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách các danh mục (category) để hiển thị trong form
        List<Category> categories = blogDAO.getCategoriesWithBlogCount();
        request.setAttribute("categories", categories);

        // Truyền lại các dữ liệu đã nhập vào trong form nếu có
        request.setAttribute("blogName", request.getAttribute("blogName"));
        request.setAttribute("blogSubContent", request.getAttribute("blogSubContent"));
        request.setAttribute("content", request.getAttribute("content"));
        request.setAttribute("author", request.getAttribute("author"));
        request.setAttribute("categoryId", request.getAttribute("categoryId"));

        request.getRequestDispatcher("/Admin/add-blog-dashboard.jsp").forward(request, response);
    }

    // Phương thức xử lý yêu cầu POST (lưu blog)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý encoding
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String blogName = request.getParameter("blogName");
        String blogSubContent = request.getParameter("blogSubContent");
        String content = request.getParameter("content");
        String author = request.getParameter("author");
        String categoryIdParam = request.getParameter("categoryId");
        String newCategoryName = request.getParameter("newCategoryName");  // Tên danh mục mới
        Part blogImagePart = request.getPart("blogImage");

        // 1. Kiểm tra các trường bắt buộc
        if (blogName == null || blogName.trim().isEmpty() ||
                blogSubContent == null || blogSubContent.trim().isEmpty() ||
                content == null || content.trim().isEmpty() ||
                author == null || author.trim().isEmpty() ||
                categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            // Nếu thiếu trường bắt buộc, thông báo lỗi và quay lại form
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường bắt buộc!");
            doGet(request, response);  // Gọi lại doGet để hiển thị lại form với thông báo lỗi
            return;
        }
        // Kiểm tra danh mục nếu là "Khác"
        int categoryId = -1;
        if ("other".equals(categoryIdParam)) {
            // Nếu là "Khác", kiểm tra tên danh mục mới
            if (newCategoryName == null || newCategoryName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập tên danh mục mới.");
                doGet(request, response);
                return;
            }

            // Thêm danh mục mới vào cơ sở dữ liệu
            categoryId = blogDAO.addNewCategory(newCategoryName);
        } else {
            // Nếu không phải "Khác", chuyển giá trị categoryId từ form
            try {
                categoryId = Integer.parseInt(categoryIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Danh mục không hợp lệ!");
                doGet(request, response);
                return;
            }
        }

        // Lấy thời gian hiện tại
        java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());


        String blogImagePath = null;
        try {
            blogImagePath = saveImage(blogImagePart);
        } catch (IOException e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
            return;
        }


        // 4. Tạo đối tượng Blog từ dữ liệu người dùng nhập vào
        Blog newBlog = new Blog();
        newBlog.setBlogName(blogName);
        newBlog.setBlogSubContent(blogSubContent);
        newBlog.setContent(content);
        newBlog.setAuthor(author);
        newBlog.setCategoryId(categoryId);
        newBlog.setBlogImg(blogImagePath);
        newBlog.setDate(currentDate);  // Lưu thời gian hiện tại

        // 5. Lưu blog vào cơ sở dữ liệu thông qua BlogDAO
        int success = blogDAO.insert(newBlog);

        // 6. Kiểm tra kết quả lưu trữ và thông báo cho người dùng
        if (success > 0) {
            request.setAttribute("successMessage", "Bài viết đã được lưu thành công!");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu bài viết!");
        }

        // 7. Chuyển tiếp lại trang add-blog.jsp để hiển thị thông báo
        doGet(request, response);
    }

    private String saveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        // Kiểm tra kích thước ảnh (tối đa 5MB)
        long maxSize = 5 * 1024 * 1024;
        if (imagePart.getSize() > maxSize) {
            throw new IOException("Kích thước file ảnh vượt quá 5MB");
        }

        // Lấy tên file gốc
        String fileName = new File(imagePart.getSubmittedFileName()).getName();

        // Kiểm tra định dạng file ảnh
        String lowerFileName = fileName.toLowerCase();
        if (!(lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg") ||
              lowerFileName.endsWith(".png") || lowerFileName.endsWith(".gif") || lowerFileName.endsWith(".webp"))) {
            throw new IOException("Chỉ cho phép tải lên các file ảnh JPG, JPEG, PNG, GIF, WEBP.");
        }

        // Tạo đường dẫn upload
        String uploadPath = getServletContext().getRealPath("/assets/img/blog");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("[AddBlogControllerServlet] Tạo thư mục upload: " + uploadPath + " - " + created);
        } else {
            System.out.println("[AddBlogControllerServlet] Thư mục upload đã tồn tại: " + uploadPath);
        }

        // Tránh trùng tên file bằng cách thêm timestamp
        String newFileName = System.currentTimeMillis() + "_" + fileName;
        File file = new File(uploadDir, newFileName);

        // Lưu file vào thư mục
        imagePart.write(file.getAbsolutePath());
        System.out.println("[AddBlogControllerServlet] Đã lưu file ảnh vào: " + file.getAbsolutePath());

        return "assets/img/blog/" + newFileName;
    }
}