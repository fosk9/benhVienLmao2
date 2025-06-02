package controller;

import view.BlogDAO;
import model.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;

@WebServlet(name = "AddBlogServlet", urlPatterns = {"/add-blog"})
@MultipartConfig
public class AddBlogServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            String blogName = request.getParameter("blogName");
            String author = request.getParameter("author");
            String content = request.getParameter("content");
            Timestamp createdAt = new Timestamp(System.currentTimeMillis());
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            boolean selectedBanner = request.getParameter("selectedBanner") != null;

            Part filePart = request.getPart("imageFile");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String appPath = request.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            String imagePath = UPLOAD_DIR + "/" + fileName;

            Blog blog = new Blog();
            blog.setBlogName(blogName);
            blog.setImage(imagePath);
            blog.setAuthor(author);
            blog.setContent(content);
            blog.setCreatedAt(createdAt);
            blog.setTypeId(typeId);
            blog.setSelectedBanner(selectedBanner);

            BlogDAO dao = new BlogDAO();
            dao.insert(blog);

            response.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý blog: " + e.getMessage());
        }
    }
}

