package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import view.AppointmentDAO;
import model.Appointment;
import java.io.IOException;
import java.io.PrintWriter;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import vn.payos.type.PaymentLinkData;

@WebServlet("/payment")
public class PaymentControllerServlet extends HttpServlet {

    private PayOS payOS;
    private String domain = "http://localhost:8080/benhVienLmao_war_exploded/";

    @Override
    public void init() throws ServletException {
        String clientId = "8ada356e-2e8f-4ac2-893c-b9dd34f259b5";
        String apiKey = "99428222-900b-4792-b511-ef72cc2d0853";
        String checksumKey = "de4193745f19d74a5b0f6dc354555d881e8a8ef14874a863eb5c7c5a4af95c0a";
        payOS = new PayOS(clientId, apiKey, checksumKey);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String appointmentIdStr = req.getParameter("appointmentId");
        String payosOrderCode = req.getParameter("orderCode");
        String payosStatus = req.getParameter("status");
        // Nếu có callback từ PayOS (thanh toán thành công hoặc huỷ)
        if (appointmentIdStr != null && payosStatus != null) {
            if (payosStatus.equalsIgnoreCase("Paid")) {
                try {
                    int appointmentId = Integer.parseInt(appointmentIdStr);
                    AppointmentDAO appointmentDAO = new AppointmentDAO();
                    appointmentDAO.updateStatus(appointmentId, "Pending");
                } catch (Exception ex) {
                    // log error
                }
            }
            // Dù là PAID hay CANCEL đều về trang appointments
            resp.sendRedirect(req.getContextPath() + "/appointments");
            return;
        }
        String appointmentId;
        try {
            appointmentId = req.getParameter("appointmentId");
            if (appointmentId == null) {
                resp.sendRedirect(req.getContextPath() + "/appointments");
                return;
            }
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            Appointment appointment = appointmentDAO.getAppointmentDetailById(Integer.parseInt(appointmentId));
            if (appointment == null) {
                resp.sendRedirect(req.getContextPath() + "/appointments");
                return;
            }
            req.setAttribute("appointment", appointment);
            req.getRequestDispatcher("/payment/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/appointments");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String appointmentIdStr = req.getParameter("appointmentId");
        if (appointmentIdStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing appointmentId\"}");
            return;
        }
        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdStr);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid appointmentId\"}");
            return;
        }
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        Appointment appointment = appointmentDAO.getAppointmentDetailById(appointmentId);
        if (appointment == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"error\":\"Appointment not found\"}");
            return;
        }

        try {
            Long orderCode = System.currentTimeMillis() / 1000;
            String serviceName = appointment.getAppointmentType() != null && appointment.getAppointmentType().getTypeName() != null
                    ? appointment.getAppointmentType().getTypeName()
                    : "Medical Service";
            int price = appointment.getAppointmentType() != null && appointment.getAppointmentType().getPrice() != null
                    ? appointment.getAppointmentType().getPrice().intValue()
                    : 2000;

            // Patient ID for the description
            Integer patientId = appointment.getPatient() != null ? appointment.getPatient().getPatientId() : null;

            // Create the payment link data
            ItemData itemData = ItemData.builder()
                    .name(serviceName)
                    .quantity(1)
                    .price(price)
                    .build();

            // Create the payment data
            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(price)
                    .description("#" + patientId + "_# " + appointmentId + "_" + serviceName)
                    .returnUrl(domain + "payment?appointmentId=" + appointmentId + "&status=Paid")
                    .cancelUrl(domain + "payment?appointmentId=" + appointmentId + "&status=Cancelled")
                    .item(itemData)
                    .build();

            CheckoutResponseData result = payOS.createPaymentLink(paymentData);
            String checkoutUrl = result.getCheckoutUrl();

            resp.setHeader("Location", checkoutUrl); // Redirect to PayOS checkout page
            resp.setStatus(HttpServletResponse.SC_FOUND); // 302 Found
            return;
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}