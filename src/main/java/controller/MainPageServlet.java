package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import model.AppointmentType;
import view.BlogDAO;
import view.AppointmentTypeDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/index")
public class MainPageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MainPageServlet.class.getName());
    private final BlogDAO blogDAO = new BlogDAO();
    private final AppointmentTypeDAO appointmentTypeDAO = new AppointmentTypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Processing GET request for index page at " + new java.util.Date());

        // Fetch the three most recent blog posts
        List<Blog> recentBlogs = blogDAO.getRecentBlogsLimited(3);
        LOGGER.info("Fetched " + recentBlogs.size() + " recent blogs");

        for (Blog blog : recentBlogs) {
            LOGGER.info(String.format("Blog [ID=%d, Title=%s, Image=%s, Date=%s]",
                    blog.getBlogId(), blog.getBlogName(), blog.getBlogImg(), blog.getDate()));
        }

        // Fetch all appointment types into an ArrayList
        List<AppointmentType> services = new ArrayList<>();
        try {
            services.addAll(appointmentTypeDAO.select());
            LOGGER.info("Fetched " + services.size() + " appointment types into ArrayList");
        } catch (Exception e) {
            LOGGER.severe("Error fetching appointment types: " + e.getMessage());
            services = new ArrayList<>(); // Default to empty list on error
        }

        // Set attributes
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("services", services);

        // Forward to index.jsp
        LOGGER.info("Forwarding to index.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}