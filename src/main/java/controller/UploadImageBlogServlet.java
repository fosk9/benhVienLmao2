package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/upload-image-blog")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1MB
        maxFileSize = 5 * 1024 * 1024,       // 5MB
        maxRequestSize = 10 * 1024 * 1024    // 10MB
)
public class UploadImageBlogServlet extends HttpServlet {

    private static final String IMAGE_UPLOAD_DIR = "assets/img/blog/";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy ảnh từ CKEditor (name = upload) mặc định là "upload"
        Part filePart = request.getPart("upload");
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String randomFileName = UUID.randomUUID().toString() + fileExtension;

        // Đường dẫn lưu trên server
        String uploadPath = getServletContext().getRealPath("") + File.separator + IMAGE_UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // Ghi file vào thư mục đích
        String fullPath = uploadPath + File.separator + randomFileName;
        filePart.write(fullPath);

        // Trả về URL để CKEditor chèn vào content
        String fileUrl = request.getContextPath() + "/" + IMAGE_UPLOAD_DIR + randomFileName;

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(
                "<script>window.parent.CKEDITOR.tools.callFunction(" +
                        request.getParameter("CKEditorFuncNum") +
                        ", '" + fileUrl + "', '');</script>");
    }
}
