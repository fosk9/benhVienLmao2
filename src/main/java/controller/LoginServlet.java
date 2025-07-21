package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Employee;
import model.Log;
import model.Patient;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.ThreadContext;
import view.EmployeeDAO;
import view.PatientDAO;
import view.LogDAO;
import websocket.LogWebSocket;

import java.io.IOException;
import java.sql.Timestamp;

// Servlet to handle user login and log activities using Log4j 2 with database fallback
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(LoginServlet.class);
    private LogDAO logDAO;

    @Override
    public void init() throws ServletException {
        logDAO = new LogDAO();
        logger.info("LoginServlet initialized");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String loginAs = request.getParameter("login-as");

        HttpSession session = request.getSession();

        try {
            logger.debug("Processing login request: username={}, loginAs={}", username, loginAs);
            if ("Patient".equals(loginAs)) {
                PatientDAO patientDAO = new PatientDAO();
                Patient patient = patientDAO.login(username, password);
                if (patient != null) {
                    // Check account status
                    if (patient.getAccStatus() != null && patient.getAccStatus() == 1) {
                        // Set MDC for logging
                        ThreadContext.put("patient_id", String.valueOf(patient.getPatientId()));
                        ThreadContext.put("employee_id", null);
                        logger.info("Patient login successful: username={}", username);
                        // Fallback: Manually insert log
                        insertLogFallback(patient.getPatientId(), null, "Patient login successful: username=" + username, "INFO");
                        // Notify WebSocket clients
                        LogWebSocket.notifyNewLog();

                        // Set session attributes
                        session.setAttribute("username", username);
                        session.setAttribute("patientId", patient.getPatientId());
                        session.setAttribute("role", "Patient");
                        session.setAttribute("account", patient);
                        session.setAttribute("login-as", "patient");
                        response.sendRedirect(request.getContextPath() + "/pactHome");
                        return;
                    } else {
                        ThreadContext.put("patient_id", String.valueOf(patient.getPatientId()));
                        ThreadContext.put("employee_id", null);
                        logger.warn("Patient login failed: account inactive, username={}", username);
                        // Fallback: Manually insert log
                        insertLogFallback(patient.getPatientId(), null, "Patient login failed: account inactive, username=" + username, "WARN");
                        // Notify WebSocket clients
                        LogWebSocket.notifyNewLog();
                        request.setAttribute("username", username);
                        request.setAttribute("password", password);
                        request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                    }
                } else {
                    ThreadContext.put("patient_id", null);
                    ThreadContext.put("employee_id", null);
                    logger.warn("Patient login failed: invalid credentials, username={}", username);
                    // Fallback: Manually insert log
                    insertLogFallback(null, null, "Patient login failed: invalid credentials, username=" + username, "WARN");
                    // Notify WebSocket clients
                    LogWebSocket.notifyNewLog();
                    request.setAttribute("username", username);
                    request.setAttribute("password", password);
                    request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng");
                }
            } else if ("Employee".equals(loginAs)) {
                EmployeeDAO employeeDAO = new EmployeeDAO();
                Employee employee = employeeDAO.login(username, password);
                if (employee != null) {
                    // Check account status
                    if (employee.getAccStatus() != null && employee.getAccStatus() == 1) {
                        // Set MDC for logging
                        ThreadContext.put("employee_id", String.valueOf(employee.getEmployeeId()));
                        ThreadContext.put("patient_id", null);
                        logger.info("Employee login successful: username={}, role_id={}", username, employee.getRoleId());
                        // Fallback: Manually insert log
                        insertLogFallback(null, employee.getEmployeeId(), "Employee login successful: username=" + username + ", role_id=" + employee.getRoleId(), "INFO");
                        // Notify WebSocket clients
                        LogWebSocket.notifyNewLog();

                        // Set session attributes
                        session.setAttribute("account", employee);
                        session.setAttribute("username", username);
                        session.setAttribute("role", employee.getRoleId());
                        session.setAttribute("login-as", "employee");

                        // Redirect based on role
                        int roleId = employee.getRoleId();
                        switch (roleId) {
                            case 1:
                                response.sendRedirect(request.getContextPath() + "/doctor-home");
                                break;
                            case 2:
                                response.sendRedirect(request.getContextPath() + "/receptionist-dashboard");
                                break;
                            case 3:
                                response.sendRedirect(request.getContextPath() + "/admin/home");
                                break;
                            case 4:
                                response.sendRedirect(request.getContextPath() + "/update-user-role");
                                break;
                            default:
                                response.sendRedirect(request.getContextPath() + "/index.html");
                                break;
                        }
                        return;
                    } else {
                        ThreadContext.put("employee_id", String.valueOf(employee.getEmployeeId()));
                        ThreadContext.put("patient_id", null);
                        logger.warn("Employee login failed: account inactive, username={}", username);
                        // Fallback: Manually insert log
                        insertLogFallback(null, employee.getEmployeeId(), "Employee login failed: account inactive, username=" + username, "WARN");
                        // Notify WebSocket clients
                        LogWebSocket.notifyNewLog();
                        request.setAttribute("username", username);
                        request.setAttribute("password", password);
                        request.setAttribute("error", "Your account is inactive.");
                    }
                } else {
                    ThreadContext.put("employee_id", null);
                    ThreadContext.put("patient_id", null);
                    logger.warn("Employee login failed: invalid credentials, username={}", username);
                    // Fallback: Manually insert log
                    insertLogFallback(null, null, "Employee login failed: invalid credentials, username=" + username, "WARN");
                    // Notify WebSocket clients
                    LogWebSocket.notifyNewLog();
                    request.setAttribute("username", username);
                    request.setAttribute("password", password);
                    request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng");
                }
            } else {
                ThreadContext.put("employee_id", null);
                ThreadContext.put("patient_id", null);
                logger.warn("Invalid login role selected: loginAs={}", loginAs);
                // Fallback: Manually insert log
                insertLogFallback(null, null, "Invalid login role selected: loginAs=" + loginAs, "WARN");
                // Notify WebSocket clients
                LogWebSocket.notifyNewLog();
                request.setAttribute("username", username);
                request.setAttribute("password", password);
                request.setAttribute("error", "Invalid login role selected!");
            }

            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            ThreadContext.put("employee_id", null);
            ThreadContext.put("patient_id", null);
            logger.error("Unexpected error during login", e);
            // Fallback: Manually insert log
            insertLogFallback(null, null, "Unexpected error during login: " + e.getMessage(), "ERROR");
            // Notify WebSocket clients
            LogWebSocket.notifyNewLog();
            request.setAttribute("error", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // Clear MDC to prevent data leakage
            ThreadContext.clearMap();
        }
    }

    // Fallback method to manually insert logs into SystemLogs table
    private void insertLogFallback(Integer patientId, Integer employeeId, String action, String logLevel) {
        try {
            Log log = new Log();
            log.setPatientId(patientId);
            log.setEmployeeId(employeeId);
            log.setAction(action);
            log.setLogLevel(logLevel);
            log.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            int rows = logDAO.insert(log);
            logger.debug("Fallback: Inserted log into SystemLogs: action={}, patient_id={}, employee_id={}, rows_affected={}",
                    action, patientId, employeeId, rows);
        } catch (Exception e) {
            logger.error("Failed to insert log into SystemLogs: action={}", action, e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.debug("Rendering login page");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}