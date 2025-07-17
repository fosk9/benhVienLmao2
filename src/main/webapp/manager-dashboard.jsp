<!doctype html>
<html class="no-js" lang="zxx">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Manager Dashboard | Hospital Management System</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

    <!-- CSS here -->
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="assets/css/slicknav.css">
    <link rel="stylesheet" href="assets/css/flaticon.css">
    <link rel="stylesheet" href="assets/css/gijgo.css">
    <link rel="stylesheet" href="assets/css/animate.min.css">
    <link rel="stylesheet" href="assets/css/animated-headline.css">
    <link rel="stylesheet" href="assets/css/magnific-popup.css">
    <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="assets/css/themify-icons.css">
    <link rel="stylesheet" href="assets/css/slick.css">
    <link rel="stylesheet" href="assets/css/nice-select.css">
    <link rel="stylesheet" href="assets/css/style.css">

    <!-- Chart.js for dashboard charts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .dashboard-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #2c5aa0;
        }
        .stat-label {
            color: #666;
            font-size: 1.1rem;
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin: 20px 0;
        }
        .quick-action-btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin: 10px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: white;
            text-decoration: none;
        }
        .alert-item {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 15px;
            margin: 10px 0;
        }
        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }
        .activity-item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
<!-- ? Preloader Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="assets/img/logo/loder.png" alt="">
            </div>
        </div>
    </div>
</div>
<!-- Preloader Start -->

<header>
    <!--? Header Start -->
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <!-- Logo -->
                    <div class="col-xl-2 col-lg-2 col-md-1">
                        <div class="logo">
                            <a href="manager-dashboard.jsp"><img src="assets/img/logo/logo.png" alt=""></a>
                        </div>
                    </div>
                    <div class="col-xl-10 col-lg-10 col-md-10">
                        <div class="menu-main d-flex align-items-center justify-content-end">
                            <!-- Main-menu -->
                            <div class="main-menu f-right d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <li><a href="manager-dashboard.jsp">Dashboard</a></li>
                                        <li><a href="patients.jsp">Patients</a></li>
                                        <li><a href="staff.jsp">Staff</a></li>
                                        <li><a href="appointments.jsp">Appointments</a></li>
                                        <li><a href="reports.jsp">Reports</a>
                                            <ul class="submenu">
                                                <li><a href="financial-reports.jsp">Financial</a></li>
                                                <li><a href="patient-reports.jsp">Patient Reports</a></li>
                                                <li><a href="staff-reports.jsp">Staff Reports</a></li>
                                            </ul>
                                        </li>
                                        <li><a href="settings.jsp">Settings</a></li>
                                    </ul>
                                </nav>
                            </div>
                            <div class="header-right-btn f-right d-none d-lg-block ml-15">
                                <a href="profile.jsp" class="btn header-btn">Profile</a>
                                <a href="logout.jsp" class="btn header-btn">Logout</a>
                            </div>
                        </div>
                    </div>
                    <!-- Mobile Menu -->
                    <div class="col-12">
                        <div class="mobile_menu d-block d-lg-none"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Header End -->
</header>

<main>
    <!-- Dashboard Header -->
    <div class="slider-area" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 60px 0;">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="text-center text-white">
                        <h1>Manager Dashboard</h1>
                        <p>Welcome back! Here's what's happening at your hospital today.</p>
                        <p><strong>Today's Date:</strong> <span id="currentDate"></span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Key Statistics -->
    <div class="about-area2 section-padding40">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="dashboard-card text-center">
                        <div class="stat-number">247</div>
                        <div class="stat-label">Total Patients Today</div>
                        <i class="fas fa-users" style="font-size: 2rem; color: #2c5aa0; margin-top: 15px;"></i>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="dashboard-card text-center">
                        <div class="stat-number">89</div>
                        <div class="stat-label">Active Staff</div>
                        <i class="fas fa-user-md" style="font-size: 2rem; color: #2c5aa0; margin-top: 15px;"></i>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="dashboard-card text-center">
                        <div class="stat-number">156</div>
                        <div class="stat-label">Appointments Today</div>
                        <i class="fas fa-calendar-check" style="font-size: 2rem; color: #2c5aa0; margin-top: 15px;"></i>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="dashboard-card text-center">
                        <div class="stat-number">12</div>
                        <div class="stat-label">Emergency Cases</div>
                        <i class="fas fa-ambulance" style="font-size: 2rem; color: #dc3545; margin-top: 15px;"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts and Analytics -->
    <div class="service-area">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="dashboard-card">
                        <h3>Patient Admissions - Last 7 Days</h3>
                        <div class="chart-container">
                            <canvas id="admissionsChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="dashboard-card">
                        <h3>Department Distribution</h3>
                        <div class="chart-container">
                            <canvas id="departmentChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-6">
                    <div class="dashboard-card">
                        <h3>Revenue Overview</h3>
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="dashboard-card">
                        <h3>Staff Performance</h3>
                        <div class="chart-container">
                            <canvas id="performanceChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions and Alerts -->
    <div class="about-area2 section-padding40">
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <div class="dashboard-card">
                        <h3>Quick Actions</h3>
                        <a href="add-patient.jsp" class="quick-action-btn">
                            <i class="fas fa-user-plus"></i> Add New Patient
                        </a>
                        <a href="schedule-appointment.jsp" class="quick-action-btn">
                            <i class="fas fa-calendar-plus"></i> Schedule Appointment
                        </a>
                        <a href="staff-management.jsp" class="quick-action-btn">
                            <i class="fas fa-users-cog"></i> Manage Staff
                        </a>
                        <a href="inventory.jsp" class="quick-action-btn">
                            <i class="fas fa-boxes"></i> Check Inventory
                        </a>
                        <a href="financial-report.jsp" class="quick-action-btn">
                            <i class="fas fa-chart-line"></i> Generate Report
                        </a>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="dashboard-card">
                        <h3>System Alerts</h3>
                        <div class="alert-item">
                            <strong>Low Inventory:</strong> Surgical masks running low (23 units remaining)
                        </div>
                        <div class="alert-item">
                            <strong>Staff Schedule:</strong> Dr. Smith requested time off next week
                        </div>
                        <div class="alert-item">
                            <strong>Equipment:</strong> MRI machine scheduled for maintenance tomorrow
                        </div>
                        <div class="alert-item">
                            <strong>Payment:</strong> 5 overdue patient payments require attention
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="dashboard-card">
                        <h3>Recent Activity</h3>
                        <div class="recent-activity">
                            <div class="activity-item">
                                <strong>10:30 AM</strong> - New patient registered: John Doe
                            </div>
                            <div class="activity-item">
                                <strong>10:15 AM</strong> - Dr. Johnson completed surgery
                            </div>
                            <div class="activity-item">
                                <strong>09:45 AM</strong> - Emergency patient admitted to ICU
                            </div>
                            <div class="activity-item">
                                <strong>09:30 AM</strong> - Lab results uploaded for Patient #1247
                            </div>
                            <div class="activity-item">
                                <strong>09:00 AM</strong> - Staff meeting scheduled for 2:00 PM
                            </div>
                            <div class="activity-item">
                                <strong>08:45 AM</strong> - Pharmacy inventory updated
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Upcoming Appointments -->
    <section class="home-blog-area section-padding30">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-7 col-md-9 col-sm-10">
                    <div class="section-tittle text-center mb-100">
                        <h2>Today's Priority Appointments</h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-6">
                    <div class="dashboard-card">
                        <h4>Dr. Sarah Wilson</h4>
                        <p><strong>Time:</strong> 2:00 PM - 3:00 PM</p>
                        <p><strong>Patient:</strong> Maria Garcia</p>
                        <p><strong>Type:</strong> Cardiology Consultation</p>
                        <p><strong>Status:</strong> <span style="color: green;">Confirmed</span></p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="dashboard-card">
                        <h4>Dr. Michael Chen</h4>
                        <p><strong>Time:</strong> 3:30 PM - 4:30 PM</p>
                        <p><strong>Patient:</strong> Robert Johnson</p>
                        <p><strong>Type:</strong> Orthopedic Surgery</p>
                        <p><strong>Status:</strong> <span style="color: orange;">Pending</span></p>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="dashboard-card">
                        <h4>Dr. Emily Davis</h4>
                        <p><strong>Time:</strong> 4:00 PM - 5:00 PM</p>
                        <p><strong>Patient:</strong> Lisa Anderson</p>
                        <p><strong>Type:</strong> Pediatric Checkup</p>
                        <p><strong>Status:</strong> <span style="color: green;">Confirmed</span></p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<footer>
    <div class="footer-wrappr section-bg3" data-background="assets/img/gallery/footer-bg.png">
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-8 col-lg-8 col-md-6 col-sm-12">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-logo mb-25">
                                <a href="manager-dashboard.jsp"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
                            </div>
                            <div class="header-area">
                                <div class="main-header main-header2">
                                    <div class="menu-main d-flex align-items-center justify-content-start">
                                        <div class="main-menu main-menu2">
                                            <nav>
                                                <ul>
                                                    <li><a href="manager-dashboard.jsp">Dashboard</a></li>
                                                    <li><a href="patients.jsp">Patients</a></li>
                                                    <li><a href="staff.jsp">Staff</a></li>
                                                    <li><a href="reports.jsp">Reports</a></li>
                                                    <li><a href="settings.jsp">Settings</a></li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
                        <div class="single-footer-caption">
                            <div class="footer-tittle mb-50">
                                <h4>Hospital Management System</h4>
                            </div>
                            <div class="footer-tittle">
                                <div class="footer-pera">
                                    <p>Efficiently managing healthcare operations with comprehensive tools for patient care, staff management, and administrative oversight.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom-area">
            <div class="container">
                <div class="footer-border">
                    <div class="row">
                        <div class="col-xl-10">
                            <div class="footer-copy-right">
                                <p>Copyright &copy;<script>document.write(new Date().getFullYear());</script> Hospital Management System. All rights reserved.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Scroll Up -->
<div id="back-top">
    <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>
</div>

<!-- JS here -->
<script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
<script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<script src="./assets/js/jquery.slicknav.min.js"></script>
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/slick.min.js"></script>
<script src="./assets/js/wow.min.js"></script>
<script src="./assets/js/animated.headline.js"></script>
<script src="./assets/js/jquery.magnific-popup.js"></script>
<script src="./assets/js/gijgo.min.js"></script>
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>
<script src="./assets/js/jquery.counterup.min.js"></script>
<script src="./assets/js/waypoints.min.js"></script>
<script src="./assets/js/jquery.countdown.min.js"></script>
<script src="./assets/js/hover-direction-snake.min.js"></script>
<script src="./assets/js/contact.js"></script>
<script src="./assets/js/jquery.form.js"></script>
<script src="./assets/js/jquery.validate.min.js"></script>
<script src="./assets/js/mail-script.js"></script>
<script src="./assets/js/jquery.ajaxchimp.min.js"></script>
<script src="./assets/js/plugins.js"></script>
<script src="./assets/js/main.js"></script>

<script>
    // Set current date
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString();

    // Initialize Charts
    document.addEventListener('DOMContentLoaded', function() {
        // Admissions Chart
        const admissionsCtx = document.getElementById('admissionsChart').getContext('2d');
        new Chart(admissionsCtx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Patient Admissions',
                    data: [45, 52, 38, 67, 73, 41, 29],
                    borderColor: '#2c5aa0',
                    backgroundColor: 'rgba(44, 90, 160, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Department Chart
        const departmentCtx = document.getElementById('departmentChart').getContext('2d');
        new Chart(departmentCtx, {
            type: 'doughnut',
            data: {
                labels: ['Cardiology', 'Orthopedics', 'Pediatrics', 'Emergency', 'Surgery'],
                datasets: [{
                    data: [30, 25, 20, 15, 10],
                    backgroundColor: ['#2c5aa0', '#667eea', '#764ba2', '#f093fb', '#f5576c']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue ($)',
                    data: [125000, 135000, 142000, 138000, 155000, 162000],
                    backgroundColor: '#667eea'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Performance Chart
        const performanceCtx = document.getElementById('performanceChart').getContext('2d');
        new Chart(performanceCtx, {
            type: 'radar',
            data: {
                labels: ['Patient Satisfaction', 'Efficiency', 'Quality', 'Safety', 'Innovation'],
                datasets: [{
                    label: 'Hospital Performance',
                    data: [85, 78, 92, 88, 75],
                    borderColor: '#764ba2',
                    backgroundColor: 'rgba(118, 75, 162, 0.2)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    r: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });
    });
</script>

</body>
</html>