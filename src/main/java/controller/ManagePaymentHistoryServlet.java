package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Payment;
import view.PaymentDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/payments/manage")
public class ManagePaymentHistoryServlet extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        paymentDAO = new PaymentDAO(); // Khởi tạo DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định là hiển thị danh sách
        }

        switch (action) {
            case "list":
                listPaymentHistory(request, response);
                break;
            // Ex:
            // case "view":
            //     viewPaymentDetails(request, response);
            //     break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private void listPaymentHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số tìm kiếm
        String searchPaymentIdStr = request.getParameter("searchPaymentId");
        String searchAppointmentIdStr = request.getParameter("searchAppointmentId");
        String searchMethod = request.getParameter("searchMethod");
        String searchStatus = request.getParameter("searchStatus");
        String searchCreatedAtFromStr = request.getParameter("searchCreatedAtFrom");
        String searchCreatedAtToStr = request.getParameter("searchCreatedAtTo");

        Integer searchPaymentId = null;
        if (searchPaymentIdStr != null && !searchPaymentIdStr.trim().isEmpty()) {
            try {
                searchPaymentId = Integer.parseInt(searchPaymentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Payment ID format.");
            }
        }

        Integer searchAppointmentId = null;
        if (searchAppointmentIdStr != null && !searchAppointmentIdStr.trim().isEmpty()) {
            try {
                searchAppointmentId = Integer.parseInt(searchAppointmentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Appointment ID format.");
            }
        }

        LocalDateTime searchCreatedAtFrom = null;
        if (searchCreatedAtFromStr != null && !searchCreatedAtFromStr.trim().isEmpty()) {
            try {
                searchCreatedAtFrom = LocalDateTime.parse(searchCreatedAtFromStr + "T00:00:00"); // Thêm thời gian để parse
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid 'Created At From' date format.");
            }
        }

        LocalDateTime searchCreatedAtTo = null;
        if (searchCreatedAtToStr != null && !searchCreatedAtToStr.trim().isEmpty()) {
            try {
                searchCreatedAtTo = LocalDateTime.parse(searchCreatedAtToStr + "T23:59:59"); // Thêm thời gian để parse
            } catch (DateTimeParseException e) {
                request.setAttribute("errorMessage", "Invalid 'Created At To' date format.");
            }
        }

        // Lấy tham số phân trang
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            try {
                currentPage = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // Mặc định vẫn là 1 nếu không hợp lệ
            }
        }
        int pageSize = 10; // Số lượng bản ghi trên mỗi trang (có thể cấu hình)

        // Lấy tổng số bản ghi phù hợp với điều kiện tìm kiếm để tính tổng số trang
        int totalRecords = paymentDAO.countFilteredPayments(
                searchPaymentId, searchAppointmentId, searchMethod, searchStatus,
                searchCreatedAtFrom, searchCreatedAtTo
        );
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Lấy danh sách thanh toán đã được lọc và phân trang
        List<Payment> payments = paymentDAO.getFilteredPayments(
                searchPaymentId, searchAppointmentId, searchMethod, searchStatus,
                searchCreatedAtFrom, searchCreatedAtTo,
                currentPage, pageSize
        );

        // Đặt thuộc tính vào request để JSP có thể truy cập
        request.setAttribute("payments", payments);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);

        // Forward tới trang JSP
        request.getRequestDispatcher("/payment/manage/list.jsp").forward(request, response);
    }
}