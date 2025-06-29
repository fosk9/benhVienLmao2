package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.PageContent;
import view.PageContentDAO;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet for handling the Test Admin Functions page.
 */
@WebServlet("/admin/test-admin-func")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AdminTestFuncServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminTestFuncServlet.class.getName());
    private final PageContentDAO pageContentDAO = new PageContentDAO();
    private static final String UPLOAD_DIR = "assets/img/uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        String fullName = "Admin";
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
            fullName = employee.getFullName();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        // Check for edit mode
        boolean editMode = "true".equals(request.getParameter("edit"));
        LOGGER.info("Edit mode: " + editMode);

        // Fetch PageContent entries for index page
        List<PageContent> contents = new ArrayList<>();
        try {
            contents = pageContentDAO.select("index");
            LOGGER.info("Fetched " + contents.size() + " PageContent entries for pageName=index");
            for (PageContent content : contents) {
                LOGGER.fine("Content ID: " + content.getContentId() +
                        ", PageName: " + (content.getPageName() != null ? content.getPageName() : "NULL") +
                        ", ContentKey: " + (content.getContentKey() != null ? content.getContentKey() : "NULL") +
                        ", ContentValue: " + (content.getContentValue() != null ? content.getContentValue() : "NULL") +
                        ", ImageUrl: " + (content.getImageUrl() != null ? content.getImageUrl() : "NULL") +
                        ", VideoUrl: " + (content.getVideoUrl() != null ? content.getVideoUrl() : "NULL") +
                        ", ButtonUrl: " + (content.getButtonUrl() != null ? content.getButtonUrl() : "NULL") +
                        ", ButtonText: " + (content.getButtonText() != null ? content.getButtonText() : "NULL") +
                        ", IsActive: " + content.isActive());
            }
            if (contents.isEmpty()) {
                LOGGER.warning("No PageContent entries found for pageName=index");
                request.setAttribute("error", "No page content available. Please add content via Edit This Page.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error fetching PageContent: " + e.getMessage());
            request.setAttribute("error", "Failed to load page content: " + e.getMessage());
        }

        // Set attributes
        request.setAttribute("contents", contents);
        request.setAttribute("fullName", fullName);
        request.setAttribute("editMode", editMode);

        // Forward to test-admin-func.jsp
        LOGGER.info("Forwarding to test-admin-func.jsp");
        request.getRequestDispatcher("/admin/test-admin-func.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("save".equals(action)) {
            String[] contentIds = request.getParameterValues("contentId");
            boolean hasImageError = false;
            String imageError = null;
            if (contentIds != null) {
                for (String id : contentIds) {
                    PageContent content = new PageContent();
                    content.setContentId(Integer.parseInt(id));
                    content.setPageName("index");
                    content.setContentKey(request.getParameter("contentKey_" + id));
                    content.setContentValue(request.getParameter("contentValue_" + id));
                    content.setActive(Boolean.parseBoolean(request.getParameter("isActive_" + id)));
                    content.setVideoUrl(request.getParameter("videoUrl_" + id));
                    content.setButtonUrl(request.getParameter("buttonUrl_" + id));
                    content.setButtonText(request.getParameter("buttonText_" + id));

                    // Handle file upload with image type check
                    Part filePart = request.getPart("imageFile_" + id);
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = extractFileName(filePart);
                        String contentType = filePart.getContentType();
                        String fileExtension = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

                        boolean isImage = contentType.startsWith("image/")
                                && (fileExtension.equals(".jpg") || fileExtension.equals(".jpeg") || fileExtension.equals(".png"));

                        if (!isImage) {
                            imageError = "Chỉ cho phép tải lên file ảnh (jpg, jpeg, png).";
                            LOGGER.warning("Invalid image upload: " + fileName + " (" + contentType + ")");
                            hasImageError = true;
                        } else {
                            String savePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                            File fileSaveDir = new File(savePath);
                            if (!fileSaveDir.exists()) {
                                fileSaveDir.mkdirs();
                            }
                            String filePath = savePath + File.separator + fileName;
                            filePart.write(filePath);
                            content.setImageUrl(UPLOAD_DIR + "/" + fileName);
                        }
                    } else {
                        content.setImageUrl(request.getParameter("existingImageUrl_" + id));
                    }

                    if (!hasImageError) {
                        int updated = pageContentDAO.update(content);
                        if (updated > 0) {
                            LOGGER.info("Successfully updated PageContent ID: " + id);
                        } else {
                            LOGGER.warning("Failed to update PageContent ID: " + id);
                        }
                    }
                }
            }
            if (hasImageError) {
                // Reload contents and show error
                List<PageContent> contents = pageContentDAO.select("index");
                request.setAttribute("contents", contents);
                request.setAttribute("editMode", true);
                request.setAttribute("imageError", imageError);
                request.getRequestDispatcher("/admin/test-admin-func.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/test-admin-func");
        } else {
            doGet(request, response);
        }
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}