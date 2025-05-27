package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Employee;
import model.Specialization;
import view.EmployeeDAO;
import view.SpecializationDAO;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/DoctorList")
public class DoctorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EmployeeDAO employeeDAO = new EmployeeDAO();
        SpecializationDAO specializationDAO = new SpecializationDAO();

        // Lấy tất cả nhân viên có role là Doctor (giả sử role_id = 1 là Doctor)
        List<Employee> allEmployees = employeeDAO.select();
        List<Employee> doctors = allEmployees.stream()
                .filter(e -> e.getRoleId() == 1) // 1 = Doctor
                .collect(Collectors.toList());

        // Lấy toàn bộ chuyên khoa
        List<Specialization> specializations = specializationDAO.select();

        // Gửi dữ liệu qua JSP
        request.setAttribute("doctors", doctors);
        request.setAttribute("specializations", specializations);

        request.getRequestDispatcher("doctor-list.jsp").forward(request, response);
    }
}
