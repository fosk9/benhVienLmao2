package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SystemItem;
import view.SystemItemDAO;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

/**
 * SecurityFilter enforces role-based access control using SystemItems and RoleSystemItems.
 * Checks session for login-as (patient/employee), assigns role_id, and verifies access.
 * Uses caching for performance and includes detailed logging for debugging.
 * Compatible with existing LoginServlet session attributes.
 */
@WebFilter("/*") // Apply to all URLs
public class SecurityFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(SecurityFilter.class.getName());
    private SystemItemDAO systemItemDAO;
    // Cache for SystemItems by role_id
    private final Map<Integer, List<SystemItem>> roleItemsCache = new ConcurrentHashMap<>();
    // Cache timestamps for expiration
    private final Map<Integer, Long> cacheTimestamps = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION_MS = 5 * 60 * 1000; // 5 minutes

    @Override
    public void init(FilterConfig filterConfig) {
        systemItemDAO = new SystemItemDAO();
        LOGGER.info("SecurityFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Get requested URL path
        String requestPath = httpRequest.getServletPath();
        if (requestPath == null || requestPath.isEmpty()) {
            requestPath = "/index";
        }
        LOGGER.info("Processing request for path: " + requestPath);

        // Allow public resources
        if (isPublicResource(requestPath)) {
            LOGGER.info("Allowing public resource: " + requestPath);
            chain.doFilter(request, response);
            return;
        }

        // Determine role_id
        int roleId = 6; // Default to Guest
        String loginAs = null;
        String username = null;

        if (session != null) {
            loginAs = (String) session.getAttribute("login-as");
            username = (String) session.getAttribute("username");

            if ("patient".equalsIgnoreCase(loginAs)) {
                roleId = 5; // Patient role_id
                Integer patientId = (Integer) session.getAttribute("patientId");
                if (patientId == null || username == null) {
                    LOGGER.warning("Invalid patient session: username=" + username + ", patientId=" + patientId);
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                    return;
                }
                LOGGER.info("Patient session: username=" + username + ", role_id=" + roleId);
            } else if ("employee".equalsIgnoreCase(loginAs)) {
                Integer employeeRoleId = (Integer) session.getAttribute("role");
                if (employeeRoleId != null && username != null) {
                    roleId = employeeRoleId;
                    LOGGER.info("Employee session: username=" + username + ", role_id=" + roleId);
                } else {
                    LOGGER.warning("Invalid employee session: username=" + username + ", role=" + employeeRoleId);
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                    return;
                }
            } else {
                LOGGER.warning("Unknown login-as value: " + loginAs);
            }
        } else {
            LOGGER.info("No session, treating as Guest: role_id=" + roleId);
        }

        // Check authorization
        boolean isAuthorized = checkAuthorization(roleId, requestPath);
        if (isAuthorized) {
            LOGGER.info("Access granted to " + requestPath + " for role_id=" + roleId + ", username=" + username);
            chain.doFilter(request, response);
        } else {
            LOGGER.warning("Access denied to " + requestPath + " for role_id=" + roleId + ", username=" + username);
            String redirectUrl = (session == null) ? "/login.jsp" : "/unauthorized.jsp";
            httpRequest.setAttribute("errorMessage", "Access denied to " + requestPath);
            httpResponse.sendRedirect(httpRequest.getContextPath() + redirectUrl);
        }
    }

    /**
     * Checks if the requested path is a public resource (e.g., CSS, JS, public pages).
     */
    private boolean isPublicResource(String path) {
        return path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".jpg") ||
                path.endsWith(".png") ||
                path.endsWith(".svg") ||
                path.matches("/assets/.*") ||
                path.equals("/login.jsp") ||
                path.equals("/register.jsp") ||
                path.equals("/unauthorized.jsp") ||
                path.equals("/index") ||
                path.equals("/services.html") ||
                path.equals("/login") ||
                path.equals("/logout") ||
                path.equals("/register") ||
                path.equals("/book-appointment") ||
                path.equals("/MyProfile") ||
                path.equals("/blog") ||
                path.equals("/blog-detail") ||
                path.equals("/resend-otp") ||
                path.equals("/verify-otp") ||
                path.equals("/reset-password") ||
                path.equals("/change-password") ||
                path.equals("/header-data") ||
                path.equals("/appointments/details") ||
                path.equals("/otp-verification.jsp") ||
                path.equals("/examination-note") ||
                path.equals("/payment") ||
                path.equals("/hospital-statistics") ||
                path.equals("/unassigned-appointments") ||
                path.equals("/request-leave-list") ||
                path.equals("/UpdateMyProfileEmployee") ||
                path.equals("/UpdateEmployeeAvatar") ||
                path.equals("/UpdateMyProfilePatient") ||
                path.equals("/UpdatePatientAvatar") ||
                path.equals("/PatientDetails") ||
                path.equals("/UpdatePatientDetails") ||
                path.equals("/doctor-details") ||
                path.equals("/update-doctor-details") ||
                path.equals("/doctor-shift-detail") ||
                path.equals("/doctor-schedule") ||
                path.equals("/request-doctor-leave") ||
                path.equals("/doctor-leave-list") ||
                path.equals("/examination-history-details") ||
                path.equals("/assign-appointment") ||
                path.equals("/update-examination-note") ||
                path.equals("/approve-leave") ||
                path.equals("/export-activity-report") ||
                path.equals("/forgot-password");
    }

    /**
     * Checks if the role has access to the requested path using SystemItems.
     */
    private boolean checkAuthorization(int roleId, String requestPath) {
        // Normalize request path
        String normalizedPath = requestPath.startsWith("/") ? requestPath.substring(1) : requestPath;
        String basePath = normalizedPath.split("\\?")[0]; // Ignore query parameters
        LOGGER.info("Checking authorization for role_id=" + roleId + ", path=" + basePath);

        // Get accessible SystemItems from cache or database
        List<SystemItem> accessibleItems = getCachedItems(roleId);
        if (accessibleItems == null) {
            accessibleItems = systemItemDAO.getActiveItemsByRoleAndType(roleId, null); // Fetch all types
            if (accessibleItems == null) {
                LOGGER.severe("Failed to fetch SystemItems for role_id=" + roleId);
                return false;
            }
            roleItemsCache.put(roleId, accessibleItems);
            cacheTimestamps.put(roleId, System.currentTimeMillis());
            LOGGER.info("Cached SystemItems for role_id=" + roleId + ": " + accessibleItems.size() + " items");
        }

        // Log accessible items for debugging
        for (SystemItem item : accessibleItems) {
            LOGGER.info("Accessible item for role_id=" + roleId + ": " + item.getItemName() + " (" + item.getItemUrl() + ")");
        }

        // Check if the path matches any accessible SystemItem
        for (SystemItem item : accessibleItems) {
            String itemUrl = item.getItemUrl();
            if (itemUrl != null && !itemUrl.isEmpty()) {
                String normalizedItemUrl = itemUrl.split("\\?")[0];
                if (basePath.equals(normalizedItemUrl) || basePath.startsWith(normalizedItemUrl + "/")) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Retrieves cached SystemItems for a role, checking for expiration.
     */
    private List<SystemItem> getCachedItems(int roleId) {
        Long timestamp = cacheTimestamps.get(roleId);
        if (timestamp == null || (System.currentTimeMillis() - timestamp) > CACHE_DURATION_MS) {
            roleItemsCache.remove(roleId);
            cacheTimestamps.remove(roleId);
            LOGGER.info("Cache expired or missing for role_id=" + roleId);
            return null;
        }
        return roleItemsCache.get(roleId);
    }

    @Override
    public void destroy() {
        roleItemsCache.clear();
        cacheTimestamps.clear();
        LOGGER.info("SecurityFilter destroyed.");
    }
}