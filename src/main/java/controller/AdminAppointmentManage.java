package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AppointmentType;
import view.AppointmentTypeDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet to manage AppointmentType operations (list, add, edit, delete)
 * Handles requests for admin management of appointment types at /admin/appointments
 */
@WebServlet("/admin/appointments")
public class AdminAppointmentManage extends HttpServlet {
    private AppointmentTypeDAO appointmentTypeDAO;

    @Override
    public void init() {
        appointmentTypeDAO = new AppointmentTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";



        switch (action) {
            case "add":
                showAddForm(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteAppointmentType(req, resp);
                break;
            default:
                listAppointmentTypes(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");



        if ("add".equals(action)) {
            addAppointmentType(req, resp);
        } else if ("edit".equals(action)) {
            editAppointmentType(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    /**
     * Lists all appointment types with search, sort, and pagination
     */
    private void listAppointmentTypes(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1, pageSize = 10;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        String searchName = req.getParameter("searchName");
        String priceFrom = req.getParameter("priceFrom");
        String priceTo = req.getParameter("priceTo");
        String sortBy = req.getParameter("sortBy");

        List<AppointmentType> appointmentTypes = appointmentTypeDAO.select();

        // Apply name filter
        if (searchName != null && !searchName.trim().isEmpty()) {
            appointmentTypes = appointmentTypes.stream()
                    .filter(type -> type.getTypeName().toLowerCase().contains(searchName.toLowerCase()))
                    .collect(Collectors.toList());
        }

        // Apply price range filter
        BigDecimal fromPrice = null, toPrice = null;
        try {
            if (priceFrom != null && !priceFrom.trim().isEmpty()) {
                fromPrice = new BigDecimal(priceFrom);
            }
            if (priceTo != null && !priceTo.trim().isEmpty()) {
                toPrice = new BigDecimal(priceTo);
            }
        } catch (NumberFormatException ignored) {}

        if (fromPrice != null) {
            BigDecimal finalFromPrice = fromPrice;
            appointmentTypes = appointmentTypes.stream()
                    .filter(type -> type.getPrice() != null && type.getPrice().compareTo(finalFromPrice) >= 0)
                    .collect(Collectors.toList());
        }
        if (toPrice != null) {
            BigDecimal finalToPrice = toPrice;
            appointmentTypes = appointmentTypes.stream()
                    .filter(type -> type.getPrice() != null && type.getPrice().compareTo(finalToPrice) <= 0)
                    .collect(Collectors.toList());
        }

        // Apply sorting
        if (sortBy != null) {
            switch (sortBy) {
                case "priceDesc":
                    appointmentTypes.sort(Comparator.comparing(AppointmentType::getPrice, Comparator.reverseOrder()));
                    break;
                case "priceAsc":
                    appointmentTypes.sort(Comparator.comparing(AppointmentType::getPrice));
                    break;
                case "newest":
                    appointmentTypes.sort(Comparator.comparing(AppointmentType::getAppointmentTypeId, Comparator.reverseOrder()));
                    break;
                case "alphabetical":
                    appointmentTypes.sort(Comparator.comparing(AppointmentType::getTypeName));
                    break;
            }
        }

        // Pagination
        int total = appointmentTypes.size();
        int totalPages = (int) Math.ceil((double) total / pageSize);
        int start = Math.max(0, (page - 1) * pageSize);
        int end = Math.min(start + pageSize, appointmentTypes.size());
        List<AppointmentType> paginatedList = appointmentTypes.subList(start, end);

        req.setAttribute("appointmentTypes", paginatedList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("searchName", searchName);
        req.setAttribute("priceFrom", priceFrom);
        req.setAttribute("priceTo", priceTo);
        req.setAttribute("sortBy", sortBy);
        req.getRequestDispatcher("/admin/appointments/list.jsp").forward(req, resp);
    }

    /**
     * Shows form to add new appointment type
     */
    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/admin/appointments/add.jsp").forward(req, resp);
    }

    /**
     * Handles adding new appointment type
     */
    private void addAppointmentType(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            AppointmentType appointmentType = AppointmentType.builder()
                    .typeName(req.getParameter("typeName"))
                    .description(req.getParameter("description"))
                    .price(new BigDecimal(req.getParameter("price")))
                    .build();

            int result = appointmentTypeDAO.insert(appointmentType);
            if (result > 0) {
                req.getSession().setAttribute("successMessage", "Appointment type added successfully");
            } else {
                req.setAttribute("errorMessage", "Failed to add appointment type");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid price format");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/appointments?action=list");
    }

    /**
     * Shows form to edit existing appointment type
     */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        AppointmentType appointmentType = appointmentTypeDAO.select(id);
        if (appointmentType == null) {
            req.setAttribute("errorMessage", "Appointment type not found");
            req.getRequestDispatcher("/admin/appointments/list.jsp").forward(req, resp);
            return;
        }
        req.setAttribute("appointmentType", appointmentType);
        req.getRequestDispatcher("/admin/appointments/edit.jsp").forward(req, resp);
    }

    /**
     * Handles updating existing appointment type
     */
    private void editAppointmentType(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            AppointmentType appointmentType = AppointmentType.builder()
                    .appointmentTypeId(Integer.parseInt(req.getParameter("id")))
                    .typeName(req.getParameter("typeName"))
                    .description(req.getParameter("description"))
                    .price(new BigDecimal(req.getParameter("price")))
                    .build();

            int result = appointmentTypeDAO.update(appointmentType);
            if (result > 0) {
                req.getSession().setAttribute("successMessage", "Appointment type updated successfully");
            } else {
                req.setAttribute("errorMessage", "Failed to update appointment type");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("errorMessage", "Invalid price format");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/appointments?action=list");
    }

    /**
     * Handles deleting appointment type
     */
    private void deleteAppointmentType(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String page = req.getParameter("page");
        String searchName = req.getParameter("searchName");
        String priceFrom = req.getParameter("priceFrom");
        String priceTo = req.getParameter("priceTo");
        String sortBy = req.getParameter("sortBy");

        int result = appointmentTypeDAO.delete(id);
        if (result > 0) {
            req.getSession().setAttribute("successMessage", "Appointment type deleted successfully");
        } else {
            req.getSession().setAttribute("errorMessage", "Failed to delete appointment type");
        }

        // Build redirect URL with current parameters
        StringBuilder redirectUrl = new StringBuilder(req.getContextPath() + "/admin/appointments?action=list");
        if (page != null) redirectUrl.append("&page=").append(page);
        if (searchName != null && !searchName.trim().isEmpty()) redirectUrl.append("&searchName=").append(searchName);
        if (priceFrom != null && !priceFrom.trim().isEmpty()) redirectUrl.append("&priceFrom=").append(priceFrom);
        if (priceTo != null && !priceTo.trim().isEmpty()) redirectUrl.append("&priceTo=").append(priceTo);
        if (sortBy != null && !sortBy.trim().isEmpty()) redirectUrl.append("&sortBy=").append(sortBy);

        resp.sendRedirect(redirectUrl.toString());
    }
}