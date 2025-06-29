package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.SystemItem;
import view.SystemItemDAO;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.regex.Pattern;


/**
 * Servlet for managing SystemItems in the admin panel.
 */
@WebServlet("/admin/system-items")
public class AdminSystemItemsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminSystemItemsServlet.class.getName());
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();
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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                // Fetch all SystemItems for parent item dropdown
                List<SystemItem> allItems = systemItemDAO.select();
                request.setAttribute("allItems", allItems);
                request.getRequestDispatcher("/admin/system-items/add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                SystemItem item = systemItemDAO.select(id);
                allItems = systemItemDAO.select();
                request.setAttribute("item", item);
                request.setAttribute("allItems", allItems);
                request.getRequestDispatcher("/admin/system-items/edit.jsp").forward(request, response);
                break;
            case "delete":
                id = Integer.parseInt(request.getParameter("id"));
                int deleted = systemItemDAO.delete(id);
                if (deleted > 0) {
                    LOGGER.info("Successfully deleted SystemItem ID: " + id);
                } else {
                    LOGGER.warning("Failed to delete SystemItem ID: " + id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/system-items");
                break;
            case "list":
            default:
                allItems = systemItemDAO.select();
                request.setAttribute("items", allItems);
                request.getRequestDispatcher("/admin/system-items/list.jsp").forward(request, response);
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
        SystemItem item = new SystemItem();
        item.setItemName(request.getParameter("itemName"));
        item.setItemUrl(request.getParameter("itemUrl"));
        item.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
        String displayOrder = request.getParameter("displayOrder");
        item.setDisplayOrder(displayOrder.isEmpty() ? null : Integer.parseInt(displayOrder));
        String parentItemId = request.getParameter("parentItemId");
        item.setParentItemId(parentItemId.isEmpty() ? null : Integer.parseInt(parentItemId));
        item.setItemType(request.getParameter("itemType"));

        String imageError = null;
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String savePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File fileSaveDir = new File(savePath);

            String contentType = filePart.getContentType();
            String fileExtension = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

            // Chỉ cho phép jpg, jpeg, png
            boolean isImage = contentType.startsWith("image/")
                    && (fileExtension.equals(".jpg") || fileExtension.equals(".jpeg") || fileExtension.equals(".png"));

            if (!isImage) {
                imageError = "File upload must be an image (jpg, jpeg, png).";
                LOGGER.warning("Invalid image upload: " + fileName + " (" + contentType + ")");
            } else {
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                String filePath = savePath + File.separator + fileName;
                filePart.write(filePath);
                item.setImageUrl(UPLOAD_DIR + "/" + fileName);
            }
        } else {
            item.setImageUrl(request.getParameter("existingImageUrl"));
        }

        if (imageError != null) {
            // Đẩy lỗi lên frontend
            request.setAttribute("imageError", imageError);
            List<SystemItem> allItems = systemItemDAO.select();
            request.setAttribute("allItems", allItems);
            if ("add".equals(action)) {
                request.getRequestDispatcher("/admin/system-items/add.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                item.setItemId(Integer.parseInt(request.getParameter("id")));
                request.setAttribute("item", item);
                request.getRequestDispatcher("/admin/system-items/edit.jsp").forward(request, response);
            }
            return;
        }

        if ("add".equals(action)) {
            int inserted = systemItemDAO.insert(item);
            if (inserted > 0) {
                LOGGER.info("Successfully inserted SystemItem: " + item.getItemName());
            } else {
                LOGGER.warning("Failed to insert SystemItem: " + item.getItemName());
            }
        } else if ("edit".equals(action)) {
            item.setItemId(Integer.parseInt(request.getParameter("id")));
            int updated = systemItemDAO.update(item);
            if (updated > 0) {
                LOGGER.info("Successfully updated SystemItem ID: " + item.getItemId());
            } else {
                LOGGER.warning("Failed to update SystemItem ID: " + item.getItemId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/system-items");
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