package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DoctorShift;
import model.Employee;
import view.AppointmentDAO;
import view.DoctorShiftDAO;
import view.EmployeeDAO;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/approve-leave")
public class ApproveLeaveServlet extends HttpServlet {
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String shiftIdParam = request.getParameter("shiftId");
        if (shiftIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int shiftId = Integer.parseInt(shiftIdParam);

        // 1. Get shift info
        DoctorShift shift = shiftDAO.select(shiftId);


        if (shift == null || !"PendingLeave".equals(shift.getStatus())) {
            response.sendRedirect("request-leave-list.jsp"); // hoặc thông báo lỗi
            return;
        }

        // 2. Find available doctors (those who don't work same date/slot)
        List<Employee> availableDoctors = employeeDAO.getAvailableDoctors(shift.getShiftDate(), shift.getTimeSlot(), shift.getDoctorId());

        // 3. Send to JSP
        request.setAttribute("shift", shift);
        request.setAttribute("availableDoctors", availableDoctors);
        request.getRequestDispatcher("approve-leave.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int shiftId = Integer.parseInt(request.getParameter("shiftId"));
        String action = request.getParameter("action"); // "approve" or "reject"
        int managerId = Integer.parseInt(request.getParameter("managerId")); // lấy từ session thực tế
        Timestamp now = new Timestamp(System.currentTimeMillis()); // dùng sql.Timestamp

        if ("approve".equals(action)) {
            int replacementDoctorId = Integer.parseInt(request.getParameter("replacementDoctorId"));

            // 1. Cập nhật shift gốc thành "Leave"
            shiftDAO.updateStatusAndManager(shiftId, "Leave", managerId, now);

                // 2. Gán appointment (nếu có) sang doctor mới
            DoctorShift originalShift = shiftDAO.select(shiftId);
            appointmentDAO.transferAppointments(
                    originalShift.getDoctorId(),
                    replacementDoctorId,
                    originalShift.getShiftDate(),
                    originalShift.getTimeSlot()
            );

            // 3. Tạo lịch mới cho bác sĩ thay thế
            DoctorShift newShift = DoctorShift.builder()
                    .doctorId(replacementDoctorId)
                    .shiftDate(originalShift.getShiftDate())
                    .timeSlot(originalShift.getTimeSlot())
                    .status("Working")
                    .managerId(managerId)
                    .approvedAt(now)
                    .build();
            shiftDAO.insert(newShift);

        } else if ("reject".equals(action)) {
            shiftDAO.updateStatusAndManager(shiftId, "Rejected", managerId, now);
        }

        response.sendRedirect("request-leave-list");
    }

}

