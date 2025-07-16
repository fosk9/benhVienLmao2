package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DoctorShift;
import view.DoctorShiftDAO;
import view.AppointmentDAO;

import java.io.IOException;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet({"/add-doctor-shift-modal", "/edit-doctor-shift-modal", "/delete-doctor-shift"})
public class DoctorShiftFormModalServlet extends HttpServlet {
    private final DoctorShiftDAO shiftDAO = new DoctorShiftDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    private static final Logger LOGGER = Logger.getLogger(DoctorShiftFormModalServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        try {
            if (uri.endsWith("/add-doctor-shift-modal")) {
                int doctorId = Integer.parseInt(req.getParameter("doctorId"));
                Date date = Date.valueOf(req.getParameter("date"));
                String slot = req.getParameter("slot");

                DoctorShift shift = new DoctorShift();
                shift.setDoctorId(doctorId);
                shift.setShiftDate(date);
                shift.setTimeSlot(slot);

                req.setAttribute("shift", shift);
                req.setAttribute("isEdit", false);
                req.setAttribute("hasAppointment", false);

                LOGGER.info("[ADD MODAL] doctorId=" + doctorId + ", date=" + date + ", slot=" + slot);
                req.getRequestDispatcher("/Manager/shift-form-modal.jsp").forward(req, resp);

            } else if (uri.endsWith("/edit-doctor-shift-modal")) {
                int shiftId = Integer.parseInt(req.getParameter("shiftId"));
                DoctorShift shift = shiftDAO.select(shiftId);
                if (shift == null) {
                    LOGGER.warning("[EDIT MODAL] Shift not found with ID: " + shiftId);
                    resp.sendError(404, "Shift not found");
                    return;
                }

                boolean hasAppointment = appointmentDAO.hasAppointment(
                        shift.getDoctorId(),
                        shift.getShiftDate(),
                        shift.getTimeSlot()
                );

                req.setAttribute("shift", shift);
                req.setAttribute("isEdit", true);
                req.setAttribute("hasAppointment", hasAppointment);

                LOGGER.info("[EDIT MODAL] shiftId=" + shiftId + ", doctorId=" + shift.getDoctorId());
                req.getRequestDispatcher("/Manager/shift-form-modal.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[ERROR] While processing GET " + uri, e);
            resp.sendError(400, "Dữ liệu không hợp lệ hoặc lỗi xử lý");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String uri = req.getRequestURI();
        try {
            if (uri.endsWith("/delete-doctor-shift")) {
                int shiftId = Integer.parseInt(req.getParameter("shiftId"));
                DoctorShift shift = shiftDAO.select(shiftId);
                if (shift == null) {
                    LOGGER.warning("[DELETE] Shift not found with ID: " + shiftId);
                    resp.sendError(404, "Shift not found");
                    return;
                }

                boolean hasAppointment = appointmentDAO.hasAppointment(
                        shift.getDoctorId(),
                        shift.getShiftDate(),
                        shift.getTimeSlot()
                );

                String redirectUrl = req.getContextPath() + "/view-doctor-schedule?doctorId=" + shift.getDoctorId()
                        + "&startDate=" + shift.getShiftDate();

                if (hasAppointment) {
                    LOGGER.warning("[DELETE] Cannot delete shiftId=" + shiftId + " (has appointments)");
                    redirectUrl += "&error=Không thể xoá ca trực vì đã có lịch hẹn!";
                } else {
                    shiftDAO.delete(shiftId);
                    LOGGER.info("[DELETE] Deleted shiftId=" + shiftId + " for doctorId=" + shift.getDoctorId());
                    redirectUrl += "&success=Ca trực đã được xoá thành công.";
                }

                resp.sendRedirect(redirectUrl);
            } else {
                resp.sendError(405, "POST method not supported for this path.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[ERROR] While processing POST " + uri, e);
            resp.sendError(400, "Lỗi khi xoá ca trực");
        }
    }
}
