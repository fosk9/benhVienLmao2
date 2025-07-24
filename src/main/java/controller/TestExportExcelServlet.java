package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/test-export-excel")
public class TestExportExcelServlet extends HttpServlet {

    static class RowData {
        String activity;
        int count;
        double total;

        public RowData(String activity, int count, double total) {
            this.activity = activity;
            this.count = count;
            this.total = total;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Dữ liệu mẫu
        List<RowData> data = Arrays.asList(
                new RowData("Appointments", 25, 12500000),
                new RowData("Diagnoses", 21, 8400000),
                new RowData("Prescriptions", 30, 15000000)
        );

        double grandTotal = data.stream().mapToDouble(d -> d.total).sum();

        // Tạo workbook
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Hospital Report");

        int rowNum = 0;

        // Header
        Row header = sheet.createRow(rowNum++);
        header.createCell(0).setCellValue("Activity Type");
        header.createCell(1).setCellValue("Count");
        header.createCell(2).setCellValue("Total Fee (VNĐ)");

        // Dữ liệu
        for (RowData rowData : data) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(rowData.activity);
            row.createCell(1).setCellValue(rowData.count);
            row.createCell(2).setCellValue(rowData.total);
        }

        // Total row
        Row totalRow = sheet.createRow(rowNum++);
        totalRow.createCell(1).setCellValue("Total");
        totalRow.createCell(2).setCellValue(grandTotal);

        // Set response header
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=report-demo.xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }
}
