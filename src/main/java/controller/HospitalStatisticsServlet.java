package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import view.ReportDAO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/hospital-statistics")
public class HospitalStatisticsServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ReportDAO dao = new ReportDAO();

        Map<String, Double> monthlyIncome = dao.getMonthlyIncome();
        Map<String, Double> doctorIncome = dao.getIncomeByDoctor();
        List<Double> growthData = dao.getGrowthTwoRecentMonths();

        double totalIncome = monthlyIncome.values().stream().mapToDouble(Double::doubleValue).sum();
        double thisMonth = growthData.size() > 0 ? growthData.get(0) : 0;
        double lastMonth = growthData.size() > 1 ? growthData.get(1) : 0;
        double growthRate = (lastMonth != 0) ? (thisMonth - lastMonth) / lastMonth * 100 : 0;

        List<String> topDoctors = dao.getTopDoctorsLimit(3);
        List<String> popularServices = dao.getPopularServicesLimit(3);

        // Biểu đồ
        request.setAttribute("monthlyIncomeLabels", gson.toJson(monthlyIncome.keySet()));
        request.setAttribute("monthlyIncomeData", gson.toJson(monthlyIncome.values()));
        request.setAttribute("doctorNames", gson.toJson(doctorIncome.keySet()));
        request.setAttribute("doctorIncomeData", gson.toJson(doctorIncome.values()));

        // Dữ liệu văn bản
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("thisMonth", thisMonth);
        request.setAttribute("lastMonth", lastMonth);
        request.setAttribute("growthRate", growthRate);
        request.setAttribute("topDoctors", topDoctors);
        request.setAttribute("popularServices", popularServices);

        request.getRequestDispatcher("hospital-statistics.jsp").forward(request, response);
    }
}
