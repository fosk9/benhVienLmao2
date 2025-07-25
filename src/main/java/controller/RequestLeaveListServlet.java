package controller;

import dto.PendingLeaveDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.DoctorShiftDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/request-leave-list")
public class RequestLeaveListServlet extends HttpServlet {
    private final DoctorShiftDAO dao = new DoctorShiftDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PendingLeaveDTO> list = dao.selectPendingLeaveRequests();
        request.setAttribute("pendingLeaveList", list);
        request.getRequestDispatcher("request-leave-list.jsp").forward(request, response);
    }
}
