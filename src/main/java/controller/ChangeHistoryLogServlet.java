package controller;

import dal.ChangeHistoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ChangeHistory;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ChangeHistoryLogServlet", urlPatterns = {"/change-history-log"})
public class ChangeHistoryLogServlet extends HttpServlet {

    private final ChangeHistoryDAO dao = new ChangeHistoryDAO();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy các tham số filter và phân trang
            String keyword = request.getParameter("keyword");
            String source = request.getParameter("source");
            String action = request.getParameter("action");
            String fromDateStr = request.getParameter("from");
            String toDateStr = request.getParameter("to");
            String pageStr = request.getParameter("page");

            int page = 1;
            int pageSize = 5;

            if (pageStr != null && pageStr.matches("\\d+")) {
                page = Integer.parseInt(pageStr);
                if (page <= 0) page = 1;
            }

            // Chuyển đổi ngày
            Date from = null, to = null;
            try {
                if (fromDateStr != null && !fromDateStr.isEmpty()) {
                    from = sdf.parse(fromDateStr);
                }
                if (toDateStr != null && !toDateStr.isEmpty()) {
                    to = sdf.parse(toDateStr);
                }
            } catch (ParseException pe) {
                pe.printStackTrace();
                request.setAttribute("error", "Invalid date format. Please use yyyy-MM-dd.");
            }

            // Truy vấn danh sách + đếm tổng
            int totalRecords = dao.countFiltered(keyword, source, action, from, to);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            int offset = (page - 1) * pageSize;

            List<ChangeHistory> logs = dao.selectFiltered(offset, pageSize, keyword, source, action, from, to);

            // Thống kê
            int totalChanges = dao.countAll();
            int todayChanges = dao.countToday();
            int recentActions = dao.countLast24h();
            int activeManagers = dao.countActiveManagers();

            // Set dữ liệu cho JSP
            request.setAttribute("changeHistoryList", logs);
            System.out.println("Change history list size: " + logs.size());
            request.setAttribute("totalChanges", totalChanges);
            request.setAttribute("todayChanges", todayChanges);
            request.setAttribute("recentActions", recentActions);
            request.setAttribute("activeManagers", activeManagers);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

            // Giữ filter
            request.setAttribute("keyword", keyword);
            request.setAttribute("source", source);
            request.setAttribute("action", action);
            request.setAttribute("from", fromDateStr);
            request.setAttribute("to", toDateStr);

            request.getRequestDispatcher("Manager/change-history-log.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
