package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.PageContent;
import view.PageContentDAO;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Servlet for managing PageContent in the admin panel.
 */
@WebServlet("/admin/contents")
@MultipartConfig
public class AdminPageContentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminPageContentServlet.class.getName());
    private final PageContentDAO pageContentDAO = new PageContentDAO();
    private static final String UPLOAD_DIR = "assets/img/uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        String pageName = request.getParameter("pageName");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                // Provide an empty PageContent object for the form (for pageName binding)
                request.setAttribute("content", new PageContent());
                request.getRequestDispatcher("/admin/contents/add.jsp").forward(request, response);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                PageContent content = pageContentDAO.select(id);
                request.setAttribute("content", content);
                request.getRequestDispatcher("/admin/contents/edit.jsp").forward(request, response);
                break;
            case "delete":
                id = Integer.parseInt(request.getParameter("id"));
                int deleted = pageContentDAO.delete(id);
                if (deleted > 0) {
                    LOGGER.info("Successfully deleted PageContent ID: " + id);
                } else {
                    LOGGER.warning("Failed to delete PageContent ID: " + id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/contents?action=list");
                break;
            case "list":
            default:
                List<PageContent> allContents = pageContentDAO.select(pageName);

                // Search/filter logic for all fields except ID
                String searchPageName = request.getParameter("searchPageName");
                String searchKey = request.getParameter("searchKey");
                String searchValue = request.getParameter("searchValue");
                String searchActive = request.getParameter("searchActive");
                String searchVideoUrl = request.getParameter("searchVideoUrl");
                String searchButtonUrl = request.getParameter("searchButtonUrl");
                String searchButtonText = request.getParameter("searchButtonText");

                if (searchPageName != null) searchPageName = searchPageName.trim();
                if (searchKey != null) searchKey = searchKey.trim();
                if (searchValue != null) searchValue = searchValue.trim();
                if (searchActive != null) searchActive = searchActive.trim();
                if (searchVideoUrl != null) searchVideoUrl = searchVideoUrl.trim();
                if (searchButtonUrl != null) searchButtonUrl = searchButtonUrl.trim();
                if (searchButtonText != null) searchButtonText = searchButtonText.trim();

                List<PageContent> filteredContents = allContents;
                if ((searchPageName != null && !searchPageName.isEmpty()) ||
                    (searchKey != null && !searchKey.isEmpty()) ||
                    (searchValue != null && !searchValue.isEmpty()) ||
                    (searchActive != null && !searchActive.isEmpty()) ||
                    (searchVideoUrl != null && !searchVideoUrl.isEmpty()) ||
                    (searchButtonUrl != null && !searchButtonUrl.isEmpty()) ||
                    (searchButtonText != null && !searchButtonText.isEmpty())) {
                    String finalSearchPageName = searchPageName;
                    String finalSearchKey = searchKey;
                    String finalSearchValue = searchValue;
                    String finalSearchActive = searchActive;
                    String finalSearchVideoUrl = searchVideoUrl;
                    String finalSearchButtonUrl = searchButtonUrl;
                    String finalSearchButtonText = searchButtonText;
                    filteredContents = allContents.stream()
                        .filter(pc -> (finalSearchPageName == null || finalSearchPageName.isEmpty() || (pc.getPageName() != null && pc.getPageName().toLowerCase().contains(finalSearchPageName.toLowerCase()))))
                        .filter(pc -> (finalSearchKey == null || finalSearchKey.isEmpty() || (pc.getContentKey() != null && pc.getContentKey().toLowerCase().contains(finalSearchKey.toLowerCase()))))
                        .filter(pc -> (finalSearchValue == null || finalSearchValue.isEmpty() || (pc.getContentValue() != null && pc.getContentValue().toLowerCase().contains(finalSearchValue.toLowerCase()))))
                        .filter(pc -> (finalSearchActive == null || finalSearchActive.isEmpty() ||
                            (finalSearchActive.equals("true") && pc.isActive()) ||
                            (finalSearchActive.equals("false") && !pc.isActive())))
                        .filter(pc -> (finalSearchVideoUrl == null || finalSearchVideoUrl.isEmpty() || (pc.getVideoUrl() != null && pc.getVideoUrl().toLowerCase().contains(finalSearchVideoUrl.toLowerCase()))))
                        .filter(pc -> (finalSearchButtonUrl == null || finalSearchButtonUrl.isEmpty() || (pc.getButtonUrl() != null && pc.getButtonUrl().toLowerCase().contains(finalSearchButtonUrl.toLowerCase()))))
                        .filter(pc -> (finalSearchButtonText == null || finalSearchButtonText.isEmpty() || (pc.getButtonText() != null && pc.getButtonText().toLowerCase().contains(finalSearchButtonText.toLowerCase()))))
                        .collect(Collectors.toList());
                }

                // Pagination
                int pageSize = 10;
                int currentPage = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        currentPage = Integer.parseInt(pageParam);
                        if (currentPage < 1) currentPage = 1;
                    } catch (NumberFormatException ignored) {}
                }
                int totalItems = filteredContents.size();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
                int fromIndex = (currentPage - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalItems);
                List<PageContent> pageContents = filteredContents.subList(fromIndex, toIndex);

                request.setAttribute("contents", pageContents);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/admin/contents/list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            LOGGER.warning("User not logged in");
            return;
        }

        Object accountObj = session.getAttribute("account");
        Integer roleId = null;
        if (accountObj instanceof model.Employee) {
            model.Employee employee = (model.Employee) accountObj;
            roleId = employee.getRoleId();
        }

        if (roleId == null || roleId != 3) { // Admin role_id = 3
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }

        String action = request.getParameter("action");
        PageContent content = new PageContent();
        content.setPageName(request.getParameter("pageName"));
        content.setContentKey(request.getParameter("contentKey"));
        content.setContentValue(request.getParameter("contentValue"));
        content.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
        content.setVideoUrl(request.getParameter("videoUrl"));
        content.setButtonUrl(request.getParameter("buttonUrl"));
        content.setButtonText(request.getParameter("buttonText"));

        // Handle file upload
        String imageError = null;
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            String savePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File fileSaveDir = new File(savePath);

            String contentType = filePart.getContentType();
            String fileExtension = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

            boolean isImage = contentType.startsWith("image/")
                    && (fileExtension.equals(".jpg") || fileExtension.equals(".jpeg") || fileExtension.equals(".png"));

            if (!isImage) {
                imageError = "ONLY (jpg, jpeg, png).";
                LOGGER.warning("Invalid image upload: " + fileName + " (" + contentType + ")");
            } else {
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                String filePath = savePath + File.separator + fileName;
                filePart.write(filePath);
                content.setImageUrl(UPLOAD_DIR + "/" + fileName);
            }
        } else {
            content.setImageUrl(request.getParameter("existingImageUrl"));
        }

        if (imageError != null) {
            // Đẩy lỗi lên frontend
            request.setAttribute("imageError", imageError);
            if ("add".equals(action)) {
                request.setAttribute("content", content);
                request.getRequestDispatcher("/admin/contents/add.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                content.setContentId(Integer.parseInt(request.getParameter("id")));
                request.setAttribute("content", content);
                request.getRequestDispatcher("/admin/contents/edit.jsp").forward(request, response);
            }
            return;
        }

        if ("add".equals(action)) {
            int inserted = pageContentDAO.insert(content);
            if (inserted > 0) {
                LOGGER.info("Successfully inserted PageContent: " + content.getContentKey());
            } else {
                LOGGER.warning("Failed to insert PageContent: " + content.getContentKey());
            }
        } else if ("edit".equals(action)) {
            content.setContentId(Integer.parseInt(request.getParameter("id")));
            int updated = pageContentDAO.update(content);
            if (updated > 0) {
                LOGGER.info("Successfully updated PageContent ID: " + content.getContentId());
            } else {
                LOGGER.warning("Failed to update PageContent ID: " + content.getContentId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/contents?action=list");
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}