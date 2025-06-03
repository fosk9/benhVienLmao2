package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({
        "/doctor-completed-history",
        "/doctor-create-appointment",
        "/doctor-home",
        "/doctor-view-detail/*"
})
public class DoctorAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null
                || session.getAttribute("role") == null
                || !"1".equals(session.getAttribute("role").toString())) {
            // Nếu chưa đăng nhập hoặc role không phải Doctor (role_id = 1) → chuyển về login
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
        } else {
            chain.doFilter(request, response);
        }
    }
}
