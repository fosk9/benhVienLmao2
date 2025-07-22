package filter;

import view.LogSystemDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Employee;
import model.LogSystem;
import model.Patient;

import java.io.IOException;
import java.sql.Timestamp;

/**
 * Filter theo dõi hoạt động người dùng realtime.
 */
@WebFilter("/*")
public class ActivityFilter implements Filter {

    LogSystemDAO logSystemDAO = new LogSystemDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);
        String path = req.getRequestURI();
        String method = req.getMethod();

        Integer employeeId = null;
        Integer patientId = null;
        String userName = null;
        String roleName = null;

        if (session != null) {
            Object acc = session.getAttribute("account");

            if (acc instanceof Employee) {
                Employee emp = (Employee) acc;
                employeeId = emp.getEmployeeId();
                userName = emp.getFullName();
                roleName = "Employee";
            } else if (acc instanceof Patient) {
                Patient pat = (Patient) acc;
                patientId = pat.getPatientId();
                userName = pat.getFullName();
                roleName = "Patient";
            }
        }

        // Build action string rõ ràng
        String action;
        if (userName != null) {
            action = userName + " (" + roleName + ") " + method + " " + path;
        } else {
            action = "Guest " + method + " " + path;
        }

        // Ghi log
        LogSystem logSystem = LogSystem.builder()
                .employeeId(employeeId)
                .patientId(patientId)
                .userName(userName)
                .roleName(roleName)
                .action(action)
                .logLevel("INFO")
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        logSystemDAO.insert(logSystem);

        chain.doFilter(request, response);
    }

}
