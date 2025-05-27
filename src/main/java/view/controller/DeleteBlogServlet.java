package view.controller;

import view.DAO.BlogDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/delete_blog")
public class DeleteBlogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        BlogDAO dao = new BlogDAO();
        try {
            dao.deleteBlog(id);
        } catch (Exception ex) {
            Logger.getLogger(DeleteBlogServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect("blog");
    }
}
