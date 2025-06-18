package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Blog;
import model.AppointmentType;
import model.SystemItem;
import model.PageContent;
import view.BlogDAO;
import view.AppointmentTypeDAO;
import view.SystemItemDAO;
import view.PageContentDAO;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/index")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class MainPageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MainPageServlet.class.getName());
    private final BlogDAO blogDAO = new BlogDAO();
    private final AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();
    private final PageContentDAO pageContentDAO = new PageContentDAO();
    private static final String UPLOAD_DIR = "assets/img/uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Processing GET request for index page at " + new java.util.Date());

        // Log action parameter
        String action = request.getParameter("action");
        LOGGER.info("Action parameter: " + action);

        // Determine role
        Integer sessionRole = (Integer) request.getSession().getAttribute("role");
        int role = 0; // Guest role
        if (sessionRole != null) {
            role = sessionRole;
        }
        LOGGER.info("Session role: " + role);

        // Check for edit mode
        boolean editMode = "edit".equals(action) && (role == 3 || role == 4);
        LOGGER.info("Edit mode: " + editMode);

        // Fetch recent blogs
        List<Blog> recentBlogs = blogDAO.getRecentBlogsLimited(3);
        LOGGER.info("Fetched " + recentBlogs.size() + " recent blogs");

        // Fetch appointment types
        List<AppointmentType> services = new ArrayList<>();
        try {
            services.addAll(appointmentTypeDAO.select());
            LOGGER.info("Fetched " + services.size() + " appointment types");
        } catch (Exception e) {
            LOGGER.severe("Error fetching appointment types: " + e.getMessage());
        }

        // Fetch navigation items
//        List<SystemItem> navItems = new ArrayList<>();
//        try {
//            navItems = systemItemDAO.getActiveItemsByRoleAndType(role, "Navigation");
//            LOGGER.info("Fetched " + navItems.size() + " navigation items for role " + role);
//        } catch (SQLException e) {
//            LOGGER.severe("Error fetching navigation items: " + e.getMessage());
//        }

        // Fetch feature items
//        List<SystemItem> featureItems = new ArrayList<>();
//        try {
//            featureItems = systemItemDAO.getActiveItemsByRoleAndType(role, "Feature");
//            LOGGER.info("Fetched " + featureItems.size() + " feature items for role " + role);
//
//            //for debugging, listing feature items' isActive
////            for (SystemItem item : featureItems) {
////                LOGGER.info("Feature Item: " + item.getItemName() + ", Active: " + item.isActive());
////            }
//        } catch (SQLException e) {
//            LOGGER.severe("Error fetching feature items: " + e.getMessage());
//        }

        // Fetch page content
//        List<PageContent> pageContents = pageContentDAO.selectByPage("index");
//        LOGGER.info("Fetched " + pageContents.size() + " page contents for index");

        // Set attributes
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("services", services);
//        request.setAttribute("navItems", navItems);
//        request.setAttribute("featureItems", featureItems);
//        request.setAttribute("pageContents", pageContents);
//        request.setAttribute("editMode", editMode);

        // Forward to index.jsp
        LOGGER.info("Forwarding to index.jsp with editMode=" + editMode);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Integer role = (Integer) request.getSession().getAttribute("role");
        if (role == null || (role != 3 && role != 4)) {
            LOGGER.warning("Unauthorized POST attempt with role: " + role);
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        if ("save".equals(action)) {
            // Update SystemItems
            String[] itemIds = request.getParameterValues("itemId");
            if (itemIds != null) {
                for (String id : itemIds) {
                    SystemItem item = new SystemItem();
                    item.setItemId(Integer.parseInt(id));
                    item.setItemName(request.getParameter("itemName_" + id));
                    item.setItemUrl(request.getParameter("itemUrl_" + id));
                    item.setActive(Boolean.parseBoolean(request.getParameter("isActive_" + id)));
                    String displayOrder = request.getParameter("displayOrder_" + id);
                    item.setDisplayOrder(displayOrder.isEmpty() ? null : Integer.parseInt(displayOrder));
                    String parentItemId = request.getParameter("parentItemId_" + id);
                    item.setParentItemId(parentItemId.isEmpty() ? null : Integer.parseInt(parentItemId));
                    item.setItemType(request.getParameter("itemType_" + id));

                    // Handle image upload
                    Part filePart = request.getPart("imageFile_" + id);
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
                        item.setImageUrl(request.getParameter("existingImageUrl_" + id));
                    }

                    systemItemDAO.update(item);
                }
            }

            // Update PageContent
            String[] contentIds = request.getParameterValues("contentId");
            if (contentIds != null) {
                for (String id : contentIds) {
                    PageContent content = new PageContent();
                    content.setContentId(Integer.parseInt(id));
                    content.setContentValue(request.getParameter("contentValue_" + id));
                    content.setPageName("index");
                    content.setContentKey(request.getParameter("contentKey_" + id));
                    content.setActive(true);
                    pageContentDAO.update(content);
                }
            }

            LOGGER.info("Changes saved successfully for role: " + role);
            response.sendRedirect(request.getContextPath() + "/index");
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