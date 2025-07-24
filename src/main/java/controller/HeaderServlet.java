package controller;

import util.HeaderController;
import view.AppointmentDAO;
import view.EmployeeDAO;
import view.AppointmentTypeDAO;
import view.PatientDAO;
import model.Appointment;
import model.Employee;
import model.AppointmentType;
import model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/header")
public class HeaderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HeaderController headerController = new HeaderController();
        request.setAttribute("systemItems", headerController.getNavigationItems(5, "Navigation"));
        request.getRequestDispatcher("/Pact/header.jsp").forward(request, response);
    }

}
