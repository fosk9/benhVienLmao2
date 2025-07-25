package controller;

import dto.ActivityReport;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import view.ReportDAO;
import validation.InputSanitizer;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

    @WebServlet("/export-activity-report")
public class ReportExportServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String fromDateStr = request.getParameter("from_date");
        String toDateStr = request.getParameter("to_date");
        String monthStr = request.getParameter("month");
        String search = request.getParameter("search");
        search = InputSanitizer.cleanSearchQuery(search);

        Date fromDate = null;
        Date toDate = null;
        Integer month = null;
        Integer year = null;

        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
            }
        } catch (IllegalArgumentException e) {
            fromDate = null;
        }

        try {
            if (toDateStr != null && !toDateStr.isEmpty()) {
                toDate = Date.valueOf(toDateStr);
            }
        } catch (IllegalArgumentException e) {
            toDate = null;
        }

        try {
            if (monthStr != null && !monthStr.isEmpty()) {
                String[] parts = monthStr.split("-");
                if (parts.length == 2) {
                    year = Integer.parseInt(parts[0]);
                    month = Integer.parseInt(parts[1]);
                }
            }
        } catch (Exception e) {
            month = null;
            year = null;
        }

        List<ActivityReport> reportList = reportDAO.filterReports(fromDate, toDate, month, year, search);
        request.setAttribute("reportList", reportList);

        // Đẩy lại các filter để giữ lại input cũ
        request.setAttribute("from_date", fromDateStr);
        request.setAttribute("to_date", toDateStr);
        request.setAttribute("month", monthStr);
        request.setAttribute("search", search);

        try {
            request.getRequestDispatcher("request-report.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Forward error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String fromDateStr = request.getParameter("from_date");
        String toDateStr = request.getParameter("to_date");
        String monthStr = request.getParameter("month");
        String search = request.getParameter("search");

        Date fromDate = null;
        Date toDate = null;
        Integer month = null;
        Integer year = null;

        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
            }
        } catch (IllegalArgumentException e) {
            fromDate = null;
        }

        try {
            if (toDateStr != null && !toDateStr.isEmpty()) {
                toDate = Date.valueOf(toDateStr);
            }
        } catch (IllegalArgumentException e) {
            toDate = null;
        }

        try {
            if (monthStr != null && !monthStr.isEmpty()) {
                String[] parts = monthStr.split("-");
                if (parts.length == 2) {
                    year = Integer.parseInt(parts[0]);
                    month = Integer.parseInt(parts[1]);
                }
            }
        } catch (Exception e) {
            month = null;
            year = null;
        }

        List<ActivityReport> reportList = reportDAO.filterReports(fromDate, toDate, month, year, search);

        // Export file Excel
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Hospital Report");

        Row header = sheet.createRow(0);
        String[] headers = {"STT", "From Date", "To Date", "Service", "Doctor", "Patient", "Total Amount"};
        for (int i = 0; i < headers.length; i++) {
            header.createCell(i).setCellValue(headers[i]);
        }

        double totalSum = 0;
        int rowNum = 1;
        int serial = 1;

        for (ActivityReport r : reportList) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(serial++); // STT
            row.createCell(1).setCellValue(r.getCreatedAt().toString());
            row.createCell(2).setCellValue(r.getUpdatedAt().toString());
            row.createCell(3).setCellValue(r.getServiceName());
            row.createCell(4).setCellValue(r.getDoctorName());
            row.createCell(5).setCellValue(r.getPatientName());
            row.createCell(6).setCellValue(r.getTotalAmount().doubleValue());

            totalSum += r.getTotalAmount().doubleValue();
        }

        Row totalRow = sheet.createRow(rowNum);
        totalRow.createCell(5).setCellValue("Total:");
        totalRow.createCell(6).setCellValue(totalSum);

        for (int i = 0; i <= 6; i++) {
            sheet.autoSizeColumn(i);
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=activity-report.xlsx");

        try (ServletOutputStream out = response.getOutputStream()) {
            workbook.write(out);
        }

        workbook.close();
    }
}
