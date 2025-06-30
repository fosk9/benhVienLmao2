package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import model.AppointmentType;
import model.SystemItem;
import model.PageContent;
import view.BlogDAO;
import view.AppointmentTypeDAO;
import view.SystemItemDAO;
import view.PageContentDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/index")
public class MainPageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MainPageServlet.class.getName());
    private final BlogDAO blogDAO = new BlogDAO();
    private final AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();
    private final SystemItemDAO systemItemDAO = new SystemItemDAO();
    private final PageContentDAO pageContentDAO = new PageContentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("=== [doGet] Start processing GET request for index page at " + new java.util.Date() + " ===");

        // Fetch recent blogs (3 newest)
        List<Blog> recentBlogs = blogDAO.getRecentBlogsLimited(3);
        LOGGER.info("Fetched " + recentBlogs.size() + " recent blogs");

        // Fetch all appointment types (services)
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
            navItems = systemItemDAO.getActiveItemsByRoleAndType(0, "Navigation"); // Guest role
            LOGGER.info("Fetched " + navItems.size() + " navigation items for guest role");
        } catch (Exception e) {
            LOGGER.severe("Error fetching navigation items: " + e.getMessage());
            navItems = new ArrayList<>(); // Ensure not null
            request.setAttribute("error", "Failed to load navigation items: " + e.getMessage());
        }

        // Fetch feature items
        List<SystemItem> featureItems = new ArrayList<>();
        try {
            featureItems = systemItemDAO.getActiveItemsByRoleAndType(0, "Feature"); // Guest role
            LOGGER.info("Fetched " + featureItems.size() + " feature items for guest role");
            for (SystemItem item : featureItems) {
                LOGGER.fine("Feature Item: ID=" + item.getItemId() + ", Name=" + item.getItemName() + ", URL=" + item.getItemUrl() + ", Active=" + item.isActive());
                if (item.getItemId() <= 0) {
                    LOGGER.warning("Feature item with invalid itemId: " + item.getItemName() + " (itemId=" + item.getItemId() + ")");
                }
            }
        } catch (Exception e) {
            LOGGER.severe("Error fetching feature items: " + e.getMessage());
            featureItems = new ArrayList<>(); // Ensure not null
            request.setAttribute("error", "Failed to load feature items: " + e.getMessage());
        }

        // Fetch page content for index page
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

        // Set all attributes for JSP
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("services", services);
        request.setAttribute("navItems", navItems);
        request.setAttribute("featureItems", featureItems);
        request.setAttribute("pageContents", pageContents);

        LOGGER.info("=== [doGet] Forwarding to index.jsp ===");
        try {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("=== [doGet] Exception when forwarding to index.jsp: " + e.getMessage());
            // Optionally, forward to a generic error page or show a simple error message
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<h2>Internal error loading home page. Please try again later.</h2>");
            response.getWriter().write("<pre>" + e.getMessage() + "</pre>");
            return;
        }
        LOGGER.info("=== [doGet] End processing GET request for index page ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("=== [doPost] Start processing POST request for index page at " + new java.util.Date() + " ===");
        LOGGER.warning("[doPost] Editing is disabled for this page");
        response.sendRedirect(request.getContextPath() + "/index");
        LOGGER.info("=== [doPost] End processing POST request for index page ===");
    }
}