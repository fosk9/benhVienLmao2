        package controller;
        import jakarta.servlet.ServletException;
        import model.GoogleAccount;
        import view.EmployeeDAO;
        import view.PatientDAO;
        import model.Employee;
        import model.Patient;

        import jakarta.servlet.http.*;
        import jakarta.servlet.annotation.*;
        import java.io.IOException;
        import java.util.Random;

        @WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/google-login"})
        public class GoogleLoginServlet extends HttpServlet {

            @Override
            protected void doGet(HttpServletRequest request, HttpServletResponse response)
                    throws ServletException, IOException {
                try {
                    String code = request.getParameter("code");
                    HttpSession session = request.getSession();

                    if (code == null || code.isEmpty()) {
                        response.sendRedirect("login.jsp?error=no_code");
                        return;
                    }

                    // Lấy thông tin tài khoản Google
                    String accessToken = GoogleUtils.getToken(code);
                    GoogleAccount account = GoogleUtils.getUserInfo(accessToken);
                    String email = account.getEmail();
                    String name = account.getName();
                    String avatarUrl = account.getPicture();


                    PatientDAO patientDAO = new PatientDAO();
                    EmployeeDAO employeeDAO = new EmployeeDAO();

                    Patient patient = patientDAO.getPatientByEmail(email);
                    Employee employee = employeeDAO.getEmployeeByEmail(email);

                    if (patient != null) {
                        // Đã tồn tại trong bệnh nhân => đăng nhập
                        session.setAttribute("account", patient);
                        session.setAttribute("patient", patient);
                        session.setAttribute("username", patient.getUsername());
                        session.setAttribute("patientId", patient.getPatientId());
                        session.setAttribute("role", "Patient");
                        response.sendRedirect(request.getContextPath() + "/pactHome");
                        return;
                    }

                    if (employee != null) {
                        // Đã tồn tại trong nhân viên => đăng nhập
                        session.setAttribute("account", employee);
                        session.setAttribute("employee", employee);
                        session.setAttribute("username", employee.getUsername());
                        session.setAttribute("employeeId", employee.getEmployeeId());
                        session.setAttribute("role", "employee");
                        response.sendRedirect("home.jsp");
                        return;
                    }

                    // Nếu chưa có trong cả 2 bảng thì mới insert
                    String pass = generatePass(6);
                    Patient newPatient = Patient.builder()
                            .username(email)
                            .passwordHash(pass)
                            .fullName(name)
                            .email(email)
                            .patientAvaUrl(avatarUrl)
                            .build();


                    int inserted = patientDAO.insert(newPatient);
                    if (inserted > 0) {
                        SendingEmail emailSender = new SendingEmail();
                        try {
                            emailSender.sendEmail(email, "HRMS - Gửi Tài Khoản", "Tài khoản: " + email + "\nMật khẩu (Vui Lòng Đổi Mật Khẩu): " + pass);
                        } catch (Exception e) {
                            e.printStackTrace();
                            response.sendRedirect("login.jsp?error=send_email_failed");
                            return;
                        }

                        Patient registered = patientDAO.getPatientByEmail(email);
                        session.setAttribute("account", registered);
                        session.setAttribute("patient", registered);
                        session.setAttribute("username", registered.getUsername());
                        session.setAttribute("patientId", registered.getPatientId());
                        session.setAttribute("role", "Patient");
                        response.sendRedirect(request.getContextPath() + "/pactHome");
                    } else {
                        response.sendRedirect("login.jsp?error=insert_failed");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("login.jsp?error=exception");
                }
            }

            private String generatePass(int length) {
                String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                Random rand = new Random();
                StringBuilder otp = new StringBuilder();
                for (int i = 0; i < length; i++) {
                    otp.append(chars.charAt(rand.nextInt(chars.length())));
                }
                return otp.toString();
            }
        }

