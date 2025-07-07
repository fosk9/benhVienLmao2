package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in and has Admin or Manager role
        if (session != null && session.getAttribute("user") != null) {
            // Assuming user object has roleId; replace with your user model
            Integer roleId = (Integer) session.getAttribute("roleId"); // Adjust based on your session attribute
            if (roleId != null && (roleId == 3 || roleId == 4)) { // Admin or Manager
                chain.doFilter(request, response);
                return;
            }
        }

        // Redirect to login or unauthorized page
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
    }
}