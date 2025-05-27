package controller;

import view.BlogDAO;
import model.Blog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogServlet", urlPatterns = {"/blog", "/blog_detail"})
public class BlogServlet extends HttpServlet {
    private BlogDAO blogDAO;

    @Override
    public void init() throws ServletException {
        blogDAO = new BlogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/blog":
                List<Blog> blogs = blogDAO.select();
                Blog bannerBlog = blogDAO.getBannerBlog();
                request.setAttribute("blogs", blogs);
                request.setAttribute("banner", bannerBlog);
                request.getRequestDispatcher("blog.jsp").forward(request, response);
                break;

            case "/blog_detail":
                String idStr = request.getParameter("id");
                try {
                    if (idStr != null) {
                        int blogId = Integer.parseInt(idStr);
                        Blog blog = blogDAO.select(blogId);
                        if (blog != null) {
                            request.setAttribute("blog", blog);
                            request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
                            return;
                        }
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace(); // optional: log the error
                }
                response.sendRedirect("blog"); // fallback
                break;

            default:
                response.sendRedirect("blog");
        }
    }
}