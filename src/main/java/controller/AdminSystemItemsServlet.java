package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.SystemItem;
import view.SystemItemDAO;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/admin/system-items")

public class AdminSystemItemsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminSystemItemsServlet.class.getName());
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();
    private static final String UPLOAD_DIR = "assets/img/uploads";
    private static final String SAVE_DIR = "src/main/webapp/assets/img/uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                systemItemDAO.delete(id);
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
            item.setImageUrl(UPLOAD_DIR + "/" + fileName);
        } else {
            item.setImageUrl(request.getParameter("existingImageUrl"));
        }

        if ("add".equals(action)) {
            systemItemDAO.insert(item);
        } else if ("edit".equals(action)) {
            item.setItemId(Integer.parseInt(request.getParameter("id")));
            systemItemDAO.update(item);
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