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
        if (appointmentIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/appointments");
            return;
        }
        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/appointments");
            return;
        }
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        Appointment appointment = appointmentDAO.getAppointmentDetailById(appointmentId);
        if (appointment == null) {
            resp.sendRedirect(req.getContextPath() + "/appointments");
            return;
        }
        req.setAttribute("appointment", appointment);
        req.getRequestDispatcher("/payment/payment.jsp").forward(req, resp);
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

            ItemData itemData = ItemData.builder()
                    .name(serviceName)
                    .quantity(1)
                    .price(price)
                    .build();

            PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(price)
                    .description("Thanh toán lịch khám #" + appointmentId)
                    .returnUrl(domain + "appointments/details?id=" + appointmentId)
                    .cancelUrl(domain + "appointments/details?id=" + appointmentId)
                    .item(itemData)
                    .build();

            CheckoutResponseData result = payOS.createPaymentLink(paymentData);

            resp.setContentType("application/json");
            PrintWriter out = resp.getWriter();
            out.print(result.toString());
            out.flush();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.setContentType("application/json");
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}