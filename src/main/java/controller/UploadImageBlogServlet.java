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

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Part filePart = request.getPart("upload");

            if (filePart == null || filePart.getSize() == 0) {
                sendError(out, request, "Không tìm thấy file ảnh.");
                return;
            }

            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = "";

            int dotIndex = originalFileName.lastIndexOf(".");
            if (dotIndex > 0 && dotIndex < originalFileName.length() - 1) {
                fileExtension = originalFileName.substring(dotIndex).toLowerCase();
            } else {
                sendError(out, request, "Định dạng file không hợp lệ.");
                return;
            }

            // Kiểm tra định dạng hợp lệ
            if (!fileExtension.matches("\\.(jpg|jpeg|png|gif|webp)")) {
                sendError(out, request, "Chỉ hỗ trợ các định dạng ảnh: JPG, JPEG, PNG, GIF, WEBP.");
                return;
            }

            // Sinh tên file ngẫu nhiên để tránh trùng tên file cũ
            String randomFileName = UUID.randomUUID().toString() + fileExtension;

            // Lấy đường dẫn tuyệt đối đến thư mục upload ảnh trong webapp
            String uploadPath = getServletContext().getRealPath("") + File.separator + IMAGE_UPLOAD_DIR;

            // Tạo thư mục upload nếu chưa tồn tại
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Đường dẫn đầy đủ đến file sẽ lưu trên server
            String fullPath = uploadPath + File.separator + randomFileName;

            // Lưu file ảnh vào thư mục upload
            filePart.write(fullPath);

            // Trả về URL ảnh để hiển thị trong CKEditor
            String fileUrl = request.getContextPath() + "/" + IMAGE_UPLOAD_DIR + randomFileName;
            String callback = request.getParameter("CKEditorFuncNum");

            out.println("<script>window.parent.CKEDITOR.tools.callFunction(" + callback + ", '" + fileUrl + "', '');</script>");

        } catch (Exception e) {
            sendError(response.getWriter(), request, "Lỗi khi upload ảnh: " + e.getMessage());
        }
    }

    private void sendError(PrintWriter out, HttpServletRequest request, String message) {
        String callback = request.getParameter("CKEditorFuncNum");
        out.println("<script>window.parent.CKEDITOR.tools.callFunction(" + callback + ", '', '" + message + "');</script>");
    }
}