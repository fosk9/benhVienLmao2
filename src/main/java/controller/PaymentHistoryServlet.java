package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Payment;
import view.PaymentDAO;
import view.AppointmentDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/payment/history")
public class PaymentHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("patientId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int patientId = (int) session.getAttribute("patientId");
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        String status = req.getParameter("status");

        PaymentDAO paymentDAO = new PaymentDAO();
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Payment> filteredPayments = new ArrayList<>();

        // Lấy tất cả appointmentId của bệnh nhân này
        List<Integer> appointmentIds = new ArrayList<>();
        appointmentDAO.getAppointmentsByPatientId(patientId).forEach(a -> appointmentIds.add(a.getAppointmentId()));

        // Lấy tất cả payment liên quan (tối ưu, lấy 1 lần)
        List<Payment> allPayments = paymentDAO.getPaymentsByAppointmentIds(appointmentIds);

        // Lọc theo ngày và status nếu có
        LocalDate fromDate = null, toDate = null;
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            fromDate = LocalDate.parse(fromDateStr);
        }
        if (toDateStr != null && !toDateStr.isEmpty()) {
            toDate = LocalDate.parse(toDateStr);
        }
        for (Payment p : allPayments) {
            boolean match = true;
            if (fromDate != null && p.getCreatedAt() != null) {
                match = match && !p.getCreatedAt().toLocalDate().isBefore(fromDate);
            }
            if (toDate != null && p.getCreatedAt() != null) {
                match = match && !p.getCreatedAt().toLocalDate().isAfter(toDate);
            }
            if (status != null && !status.isEmpty()) {
                match = match && status.equalsIgnoreCase(p.getStatus());
            }
            if (match) filteredPayments.add(p);
        }
        req.setAttribute("payments", filteredPayments);
        req.getRequestDispatcher("/payment/history.jsp").forward(req, resp);
    }
}
