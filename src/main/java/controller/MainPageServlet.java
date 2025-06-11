package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import view.BlogDAO;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/index")
public class MainPageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MainPageServlet.class.getName());
    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Processing GET request for index page");

        // Fetch the three most recent blog posts
        List<Blog> recentBlogs = blogDAO.getRecentBlogsLimited(3);
        LOGGER.info("Fetched " + recentBlogs.size() + " recent blogs");

        // Log details of each blog
        for (Blog blog : recentBlogs) {
            LOGGER.info(String.format("Blog [ID=%d, Title=%s, Image=%s, Date=%s]",
                    blog.getBlogId(), blog.getBlogName(), blog.getBlogImg(), blog.getDate()));
        }

        // Set the blog list as a request attribute
        request.setAttribute("recentBlogs", recentBlogs);

        // Forward to index.jsp
        LOGGER.info("Forwarding to index.jsp");

        // Forward to index.jsp
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}