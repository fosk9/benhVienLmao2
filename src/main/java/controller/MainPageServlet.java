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
        LOGGER.info("=== [doGet] Start processing GET request for index page at " + new java.util.Date() + " ===");

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
            request.setAttribute("error", "Failed to load appointment types: " + e.getMessage());
        }

        // Fetch navigation items
        List<SystemItem> navItems = new ArrayList<>();
        try {
            navItems = systemItemDAO.getActiveItemsByRoleAndType(role, "Navigation");
            LOGGER.info("Fetched " + navItems.size() + " navigation items for role " + role);
        } catch (Exception e) {
            LOGGER.severe("Error fetching navigation items: " + e.getMessage());
            request.setAttribute("error", "Failed to load navigation items: " + e.getMessage());
        }

        // Fetch feature items
        List<SystemItem> featureItems = new ArrayList<>();
        try {
            featureItems = systemItemDAO.getActiveItemsByRoleAndType(role, "Feature");
            LOGGER.info("Fetched " + featureItems.size() + " feature items for role " + role);
            for (SystemItem item : featureItems) {
                LOGGER.fine("Feature Item: " + item.getItemName() + ", Active: " + item.isActive());
            }
        } catch (Exception e) {
            LOGGER.severe("Error fetching feature items: " + e.getMessage());
            request.setAttribute("error", "Failed to load feature items: " + e.getMessage());
        }

        // Fetch page content
        List<PageContent> pageContents = new ArrayList<>();
        try {
            pageContents = pageContentDAO.select("index");
            LOGGER.info("Fetched " + pageContents.size() + " page contents for index");
            for (PageContent content : pageContents) {
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
            if (pageContents.isEmpty()) {
                LOGGER.warning("No PageContent entries found for pageName=index");
                request.setAttribute("error", "No page content available.");
            }
        } catch (Exception e) {
            LOGGER.severe("Error fetching page contents: " + e.getMessage());
            request.setAttribute("error", "Failed to load page content: " + e.getMessage());
        }

        // Set attributes
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("services", services);
        request.setAttribute("navItems", navItems);
        request.setAttribute("featureItems", featureItems);
        request.setAttribute("pageContents", pageContents);
        request.setAttribute("editMode", editMode);

        // Forward to index.jsp
        LOGGER.info("=== [doGet] Forwarding to index.jsp with editMode=" + editMode + " ===");
        try {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("=== [doGet] Exception when forwarding to index.jsp: " + e.getMessage());
            throw e;
        }
        LOGGER.info("=== [doGet] End processing GET request for index page ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("=== [doPost] Start processing POST request for index page at " + new java.util.Date() + " ===");
        String action = request.getParameter("action");
        Integer role = (Integer) request.getSession().getAttribute("role");
        LOGGER.info("[doPost] action=" + action + ", role=" + role);

        if (role == null || (role != 3 && role != 4)) {
            LOGGER.warning("[doPost] Unauthorized POST attempt with role: " + role);
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        if ("save".equals(action)) {
            // Update SystemItems
            String[] itemIds = request.getParameterValues("itemId");
            LOGGER.info("[doPost] itemIds=" + (itemIds == null ? "null" : java.util.Arrays.toString(itemIds)));
            if (itemIds != null) {
                for (String id : itemIds) {
                    SystemItem item = new SystemItem();
                    item.setItemId(Integer.parseInt(id));
                    String itemName = request.getParameter("itemName_" + id);
                    item.setItemName((itemName != null && !itemName.trim().isEmpty()) ? itemName : null);
                    String itemUrl = request.getParameter("itemUrl_" + id);
                    item.setItemUrl((itemUrl != null && !itemUrl.trim().isEmpty()) ? itemUrl : null);
                    item.setActive(Boolean.parseBoolean(request.getParameter("isActive_" + id)));
                    String displayOrder = request.getParameter("displayOrder_" + id);
                    item.setDisplayOrder((displayOrder != null && !displayOrder.trim().isEmpty()) ? Integer.parseInt(displayOrder) : null);
                    String parentItemId = request.getParameter("parentItemId_" + id);
                    item.setParentItemId((parentItemId != null && !parentItemId.trim().isEmpty()) ? Integer.parseInt(parentItemId) : null);
                    String itemType = request.getParameter("itemType_" + id);
                    item.setItemType((itemType != null && !itemType.trim().isEmpty()) ? itemType : null);

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
                        LOGGER.info("[doPost] Uploaded image for SystemItem ID " + id + ": " + fileName);
                    } else {
                        String existingImageUrl = request.getParameter("existingImageUrl_" + id);
                        item.setImageUrl((existingImageUrl != null && !existingImageUrl.trim().isEmpty()) ? existingImageUrl : null);
                    }

                    int updated = systemItemDAO.update(item);
                    if (updated > 0) {
                        LOGGER.info("[doPost] Successfully updated SystemItem ID: " + id);
                    } else {
                        LOGGER.warning("[doPost] Failed to update SystemItem ID: " + id);
                    }
                }
            }

            // Update PageContent
            String[] contentIds = request.getParameterValues("contentId");
            LOGGER.info("[doPost] contentIds=" + (contentIds == null ? "null" : java.util.Arrays.toString(contentIds)));
            if (contentIds != null) {
                for (String id : contentIds) {
                    PageContent content = new PageContent();
                    content.setContentId(Integer.parseInt(id));
                    content.setPageName("index");
                    String contentKey = request.getParameter("contentKey_" + id);
                    content.setContentKey((contentKey != null && !contentKey.trim().isEmpty()) ? contentKey : null);
                    String contentValue = request.getParameter("contentValue_" + id);
                    content.setContentValue((contentValue != null && !contentValue.trim().isEmpty()) ? contentValue : null);
                    content.setActive(Boolean.parseBoolean(request.getParameter("isActive_" + id)));
                    String videoUrl = request.getParameter("videoUrl_" + id);
                    content.setVideoUrl((videoUrl != null && !videoUrl.trim().isEmpty()) ? videoUrl : null);
                    String buttonUrl = request.getParameter("buttonUrl_" + id);
                    content.setButtonUrl((buttonUrl != null && !buttonUrl.trim().isEmpty()) ? buttonUrl : null);
                    String buttonText = request.getParameter("buttonText_" + id);
                    content.setButtonText((buttonText != null && !buttonText.trim().isEmpty()) ? buttonText : null);

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
                        content.setImageUrl(UPLOAD_DIR + "/" + fileName);
                        LOGGER.info("[doPost] Uploaded image for PageContent ID " + id + ": " + fileName);
                    } else {
                        String existingImageUrl = request.getParameter("existingImageUrl_" + id);
                        content.setImageUrl((existingImageUrl != null && !existingImageUrl.trim().isEmpty()) ? existingImageUrl : null);
                    }

                    int updated = pageContentDAO.update(content);
                    if (updated > 0) {
                        LOGGER.info("[doPost] Successfully updated PageContent ID: " + id);
                    } else {
                        LOGGER.warning("[doPost] Failed to update PageContent ID: " + id);
                    }
                }
            }

            LOGGER.info("[doPost] Changes saved successfully for role: " + role);
            LOGGER.info("[doPost] Redirecting to " + request.getContextPath() + "/index");
            response.sendRedirect(request.getContextPath() + "/index");
            LOGGER.info("=== [doPost] End processing POST request for index page ===");
        } else {
            LOGGER.info("[doPost] action != save, fallback to doGet");
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