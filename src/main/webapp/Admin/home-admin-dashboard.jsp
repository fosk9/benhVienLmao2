<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Admin Dashboard</title>

    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
            background-color: #f8f9fa;
            margin: 0;
        }

        /* Main Layout */
        .hospital-admin {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: #ffffff;
            border-right: 1px solid #e9ecef;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            overflow-y: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* Hospital Logo Header */
        .hospital-header {
            padding: 24px 20px;
            border-bottom: 1px solid #e9ecef;
            background: #ffffff;
        }

        .hospital-logo {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .hospital-icon {
            width: 48px;
            height: 48px;
            background: #4285f4;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .hospital-icon i {
            color: white;
            font-size: 24px;
        }

        .hospital-title {
            font-size: 20px;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .hospital-subtitle {
            color: #6b7280;
            font-size: 14px;
            margin: 0;
            margin-top: 4px;
        }

        /* Navigation Menu */
        .nav-menu {
            padding: 16px 0;
        }

        .nav-menu ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .nav-menu li {
            margin: 0;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #6b7280;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.2s ease;
            border-left: 3px solid transparent;
        }

        .nav-menu a:hover {
            background-color: #f3f4f6;
            color: #374151;
            text-decoration: none;
        }

        .nav-menu a.active {
            background-color: #dbeafe;
            color: #1d4ed8;
            border-left-color: #1d4ed8;
        }

        .nav-menu i {
            width: 20px;
            margin-right: 12px;
            font-size: 18px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            flex: 1;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .content-header {
            background: #ffffff;
            padding: 20px 24px;
            border-bottom: 1px solid #e9ecef;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .content-body {
            padding: 24px;
        }

        /* Page Header */
        .page-header h1 {
            font-size: 28px;
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .page-title-action {
            background: #4285f4;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            margin-left: 12px;
            transition: background 0.2s ease;
        }

        .page-title-action:hover {
            background: #3367d6;
            color: #fff;
            text-decoration: none;
        }

        /* Notices */
        .notice {
            background: #ffffff;
            border: 1px solid #e9ecef;
            border-left: 4px solid #4285f4;
            border-radius: 6px;
            padding: 16px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .notice p {
            margin: 0;
            color: #374151;
            line-height: 1.5;
        }

        .notice a {
            color: #4285f4;
            text-decoration: none;
        }

        .notice a:hover {
            text-decoration: underline;
        }

        /* Subsubsub */
        .subsubsub {
            list-style: none;
            margin: 0 0 20px 0;
            padding: 0;
            font-size: 14px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .subsubsub li {
            margin: 0;
            padding: 0;
        }

        .subsubsub a {
            text-decoration: none;
            color: #6b7280;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .subsubsub a:hover,
        .subsubsub .current a {
            background: #f3f4f6;
            color: #374151;
            text-decoration: none;
        }

        .subsubsub .count {
            color: #9ca3af;
            font-weight: normal;
        }

        /* Table */
        .hospital-table {
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }

        .hospital-table table {
            width: 100%;
            margin: 0;
            border-spacing: 0;
        }

        .hospital-table thead th {
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }

        .hospital-table tbody td {
            border-top: 1px solid #f3f4f6;
            padding: 16px;
            vertical-align: top;
            color: #374151;
        }

        .hospital-table tbody tr:hover {
            background: #f8f9fa;
        }

        .hospital-table .check-column {
            width: 40px;
            text-align: center;
        }

        /* Tablenav */
        .tablenav {
            background: #ffffff;
            padding: 16px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .tablenav .actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tablenav select {
            border: 1px solid #d1d5db;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 14px;
            background: #ffffff;
        }

        .tablenav-pages {
            color: #6b7280;
            font-size: 14px;
        }

        /* Search Box */
        .search-box {
            display: flex;
            gap: 8px;
        }

        .search-box input[type="search"] {
            border: 1px solid #d1d5db;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 14px;
            width: 280px;
        }

        /* Buttons */
        .btn-hospital {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background: #ffffff;
            color: #374151;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-hospital:hover {
            background: #f9fafb;
            border-color: #9ca3af;
            text-decoration: none;
            color: #374151;
        }

        .btn-primary {
            background: #4285f4;
            border-color: #4285f4;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #3367d6;
            border-color: #3367d6;
            color: #ffffff;
        }

        /* Responsive */
        @media screen and (max-width: 768px) {
            .sidebar {
                width: 60px;
            }

            .main-content {
                margin-left: 60px;
            }

            .hospital-header {
                padding: 16px 12px;
            }

            .hospital-title,
            .hospital-subtitle {
                display: none;
            }

            .nav-menu a {
                padding: 16px 12px;
                justify-content: center;
            }

            .nav-menu span {
                display: none;
            }

            .nav-menu i {
                margin-right: 0;
            }
        }
    </style>
</head>
<body>
<div class="hospital-admin">
    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Hospital Header -->
        <div class="hospital-header">
            <div class="hospital-logo">
                <div class="hospital-icon">
                    <a href="home-admin-dashboard.jsp">
                        <i class="fas fa-stethoscope"></i>
                    </a>
                </div>
                <div>
                    <a href="home-admin-dashboard.jsp">
                        <h2 class="hospital-title">Hospital Admin</h2>
                        <p class="hospital-subtitle">Quản lý bệnh viện</p>
                    </a>
                </div>
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="nav-menu">
            <ul>
                <li>
                    <a href="home-admin-dashboard.jsp" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Trang chủ</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/blog-dashboard" class="nav-link">
                        <i class="fas fa-blog"></i>
                        <span>Blog</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-podcast"></i>
                        <span>Post</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Cài đặt</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Content Header -->
        <div class="content-header">
            <div class="page-header d-flex justify-content-between align-items-center">
                <h1>Quản lý Bệnh nhân</h1>
                <div class="d-flex align-items-center">
                    <!-- Search Box -->
                    <div class="search-box mr-3">
                        <input type="search" placeholder="Tìm kiếm bệnh nhân...">
                        <button class="btn-hospital btn-primary">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <a href="#" class="page-title-action">
                        <i class="fas fa-plus mr-2"></i>Thêm bệnh nhân mới
                    </a>
                </div>
            </div>
        </div>

        <!-- Content Body -->
        <div class="content-body">
            <!-- Notice -->
            <div class="notice">
                <p><strong>Thông báo:</strong> Hệ thống đã được cập nhật với các tính năng mới.
                    <a href="#">Xem chi tiết</a> | <a href="#">Đóng thông báo</a></p>
            </div>

            <!-- Subsubsub Navigation -->
            <ul class="subsubsub">
                <li><a href="#" class="current">Tất cả <span class="count">(1,234)</span></a></li>
                <li><a href="#">Đang điều trị <span class="count">(89)</span></a></li>
                <li><a href="#">Xuất viện <span class="count">(1,145)</span></a></li>
                <li><a href="#">Chờ khám <span class="count">(45)</span></a></li>
                <li><a href="#">Cần cập nhật <span class="count">(12)</span></a></li>
            </ul>

            <!-- Table -->
            <div class="hospital-table">
                <!-- Table Navigation Top -->
                <div class="tablenav">
                    <div class="actions">
                        <select name="action">
                            <option value="-1">Hành động hàng loạt</option>
                            <option value="activate">Kích hoạt</option>
                            <option value="deactivate">Vô hiệu hóa</option>
                            <option value="export">Xuất Excel</option>
                            <option value="delete">Xóa</option>
                        </select>
                        <button class="btn-hospital">Áp dụng</button>
                    </div>
                    <div class="actions">
                        <select name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active">Đang điều trị</option>
                            <option value="discharged">Xuất viện</option>
                            <option value="waiting">Chờ khám</option>
                        </select>
                        <button class="btn-hospital">Lọc</button>
                    </div>
                    <div class="tablenav-pages">
                        <span class="displaying-num">1,234 bệnh nhân</span>
                    </div>
                </div>

                <!-- Patients Table -->
                <table>
                    <thead>
                    <tr>
                        <th class="check-column">
                            <input type="checkbox" id="cb-select-all">
                        </th>
                        <th>Mã BN</th>
                        <th>Họ và tên</th>
                        <th>Ngày sinh</th>
                        <th>Giới tính</th>
                        <th>Số điện thoại</th>
                        <th>Trạng thái</th>
                        <th>Ngày nhập viện</th>
                        <th>Bác sĩ phụ trách</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="1">
                        </td>
                        <td><strong>BN001234</strong></td>
                        <td>
                            <strong>Nguyễn Văn An</strong><br>
                            <small>nguyenvanan@email.com</small>
                        </td>
                        <td>15/03/1985</td>
                        <td>Nam</td>
                        <td>0123456789</td>
                        <td><span class="badge badge-success">Đang điều trị</span></td>
                        <td>10/12/2024</td>
                        <td>BS. Trần Thị Mai</td>
                    </tr>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="2">
                        </td>
                        <td><strong>BN001235</strong></td>
                        <td>
                            <strong>Lê Thị Bình</strong><br>
                            <small>lethibinh@email.com</small>
                        </td>
                        <td>22/07/1992</td>
                        <td>Nữ</td>
                        <td>0987654321</td>
                        <td><span class="badge badge-info">Xuất viện</span></td>
                        <td>08/12/2024</td>
                        <td>BS. Phạm Văn Đức</td>
                    </tr>
                    <tr>
                        <td class="check-column">
                            <input type="checkbox" name="patient_ids[]" value="3">
                        </td>
                        <td><strong>BN001236</strong></td>
                        <td>
                            <strong>Trần Minh Cường</strong><br>
                            <small>tranminhcuong@email.com</small>
                        </td>
                        <td>05/11/1978</td>
                        <td>Nam</td>
                        <td>0369852147</td>
                        <td><span class="badge badge-warning">Chờ khám</span></td>
                        <td>12/12/2024</td>
                        <td>BS. Hoàng Thị Lan</td>
                    </tr>
                    </tbody>
                </table>

                <!-- Table Navigation Bottom -->
                <div class="tablenav">
                    <div class="actions">
                        <select name="action2">
                            <option value="-1">Hành động hàng loạt</option>
                            <option value="activate">Kích hoạt</option>
                            <option value="deactivate">Vô hiệu hóa</option>
                            <option value="export">Xuất Excel</option>
                            <option value="delete">Xóa</option>
                        </select>
                        <button class="btn-hospital">Áp dụng</button>
                    </div>
                    <div class="tablenav-pages">
                        <span class="displaying-num">Hiển thị 1-20 trong 1,234 bệnh nhân</span>
                        <div class="pagination-links">
                            <a href="#" class="btn-hospital">‹ Trước</a>
                            <span class="current-page">1</span>
                            <a href="#" class="btn-hospital">Sau ›</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <p class="text-muted"><em>Hệ thống quản lý bệnh viện - Hospital Admin Dashboard</em></p>
            </div>
        </div>
    </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Select all functionality
    $('#cb-select-all').change(function() {
        $('input[name="patient_ids[]"]').prop('checked', this.checked);
    });

    // Mobile responsive
    $(window).resize(function() {
        if ($(window).width() <= 768) {
            $('.sidebar').addClass('mobile');
        } else {
            $('.sidebar').removeClass('mobile');
        }
    }).trigger('resize');

    // Navigation active state
    $('.nav-link').click(function(e) {
        // Chỉ preventDefault nếu href là '#'
        if ($(this).attr('href') === '#') {
            e.preventDefault();
        }
        $('.nav-link').removeClass('active');
        $(this).addClass('active');
    });
</script>
</body>
</html>
