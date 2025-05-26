package controller;

import DAO.BlogDAO;
import model.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDate;

@WebServlet(name = "AddBlogServlet", urlPatterns = {"/add-blog"})
@MultipartConfig
public class AddBlogServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            // Các trường văn bản
            String blogName = request.getParameter("blogName");
            String author = request.getParameter("author");
            String content = request.getParameter("content");
            LocalDate date = LocalDate.parse(request.getParameter("date"));
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            boolean selectedBanner = request.getParameter("selectedBanner") != null;

            // Lấy ảnh từ file upload
            Part filePart = request.getPart("imageFile"); // 'imageFile' là tên input type="file"
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Đường dẫn thư mục upload trong server
            String appPath = request.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Đường dẫn tuyệt đối lưu file
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath); // Ghi file lên server

            // Đường dẫn ảnh để lưu vào DB (tương đối, dùng để hiển thị sau này)
            String imagePath = UPLOAD_DIR + "/" + fileName;

            Blog blog = new Blog();
            blog.setBlogName(blogName);
            blog.setImage(imagePath);
            blog.setAuthor(author);
            blog.setContent(content);
            blog.setDate(date);
            blog.setTypeId(typeId);
            blog.setSelectedBanner(selectedBanner);


            BlogDAO dao = new BlogDAO();
            dao.insertBlog(blog);

                        response.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý blog: " + e.getMessage());
        }
    }
}
