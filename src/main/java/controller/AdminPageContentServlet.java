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
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet for managing PageContent in the admin panel.
 */
@WebServlet("/admin/page-content")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AdminPageContentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminPageContentServlet.class.getName());
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
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        String pageName = request.getParameter("pageName");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                request.setAttribute("pageName", pageName);
                request.getRequestDispatcher("/admin/page-content/add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                PageContent content = pageContentDAO.select(id);
                request.setAttribute("content", content);
                request.setAttribute("pageName", pageName);
                request.getRequestDispatcher("/admin/page-content/edit.jsp").forward(request, response);
                break;
            case "delete":
                id = Integer.parseInt(request.getParameter("id"));
                int deleted = pageContentDAO.delete(id);
                if (deleted > 0) {
                    LOGGER.info("Successfully deleted PageContent ID: " + id);
                } else {
                    LOGGER.warning("Failed to delete PageContent ID: " + id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/page-content?pageName=" + (pageName != null ? pageName : ""));
                break;
            case "list":
            default:
                List<PageContent> contents = pageContentDAO.select(pageName);
                request.setAttribute("contents", contents);
                request.setAttribute("pageName", pageName);
                request.getRequestDispatcher("/admin/page-content/list.jsp").forward(request, response);
                break;
        }
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
        String pageName = request.getParameter("pageName");
        PageContent content = new PageContent();
        content.setPageName(request.getParameter("pageName"));
        content.setContentKey(request.getParameter("contentKey"));
        content.setContentValue(request.getParameter("contentValue"));
        content.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
        content.setVideoUrl(request.getParameter("videoUrl"));
        content.setButtonUrl(request.getParameter("buttonUrl"));
        content.setButtonText(request.getParameter("buttonText"));

        // Handle file upload
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String savePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File fileSaveDir = new File(savePath);
            if (!fileSaveDir.exists()) {
                fileSaveDir.mkdirs();
            }
            String filePath = savePath + File.separator + fileName;
            filePart.write(filePath);
            content.setImageUrl(UPLOAD_DIR + "/" + fileName);
        } else {
            content.setImageUrl(request.getParameter("existingImageUrl"));
        }

        if ("add".equals(action)) {
            int inserted = pageContentDAO.insert(content);
            if (inserted > 0) {
                LOGGER.info("Successfully inserted PageContent: " + content.getContentKey());
            } else {
                LOGGER.warning("Failed to insert PageContent: " + content.getContentKey());
            }
        } else if ("edit".equals(action)) {
            content.setContentId(Integer.parseInt(request.getParameter("id")));
            int updated = pageContentDAO.update(content);
            if (updated > 0) {
                LOGGER.info("Successfully updated PageContent ID: " + content.getContentId());
            } else {
                LOGGER.warning("Failed to update PageContent ID: " + content.getContentId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/page-content?pageName=" + (pageName != null ? pageName : ""));
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