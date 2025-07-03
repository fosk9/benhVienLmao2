<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dental Management Dashboard</title>

  <!-- Bootstrap 4 CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <!-- Custom CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Manager/css/manager-dashboard.css">
</head>
<body>
<div class="dental-admin">
  <!-- Sidebar -->
  <div class="sidebar" id="sidebar">
    <!-- Dental Header -->
    <div class="dental-header">
      <div class="dental-logo">
        <div class="dental-icon">
          <i class="fas fa-tooth"></i>
        </div>
        <div>
          <h2 class="dental-title">SmileCare Dental</h2>
          <p class="dental-subtitle">Management System</p>
        </div>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="nav-menu">
      <ul>
        <li>
          <a href="#" class="nav-link active">
            <i class="fas fa-home"></i>
            <span>Dashboard</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-users"></i>
            <span>Patients</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-calendar-alt"></i>
            <span>Appointments</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-user-md"></i>
            <span>Dentists</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-procedures"></i>
            <span>Treatments</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-x-ray"></i>
            <span>X-Ray & Imaging</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-file-medical"></i>
            <span>Medical Records</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-pills"></i>
            <span>Inventory</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-money-bill-wave"></i>
            <span>Billing</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-chart-bar"></i>
            <span>Reports</span>
          </a>
        </li>
        <li>
          <a href="#" class="nav-link">
            <i class="fas fa-cog"></i>
            <span>Settings</span>
          </a>
        </li>
      </ul>
    </nav>

    <!-- User Profile -->
    <div class="user-profile">
      <div class="user-info">
        <div class="user-avatar">
          <i class="fas fa-user"></i>
        </div>
        <div class="user-details">
          <h4>Dr. John Smith</h4>
          <p>Dental Manager</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <!-- Content Header -->
    <div class="content-header">
      <div class="page-header">
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div>
            <button class="btn-dental d-md-none" onclick="toggleSidebar()">
              <i class="fas fa-bars"></i>
            </button>
            <h1>Dental Management Dashboard</h1>
            <p class="page-subtitle">Welcome back! Here's your clinic overview for today</p>
          </div>
          <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" class="form-control" placeholder="Search patients, treatments...">
          </div>
        </div>
      </div>
    </div>

    <!-- Content Body -->
    <div class="content-body">
      <!-- Stats Cards -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-teal">1,247</h3>
              <p>Total Patients</p>
            </div>
            <div class="stat-icon stat-teal">
              <i class="fas fa-users"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-blue">28</h3>
              <p>Today's Appointments</p>
            </div>
            <div class="stat-icon stat-blue">
              <i class="fas fa-calendar-check"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-green">6</h3>
              <p>Active Dentists</p>
            </div>
            <div class="stat-icon stat-green">
              <i class="fas fa-user-md"></i>
            </div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-card-content">
            <div class="stat-info">
              <h3 class="stat-orange">12</h3>
              <p>Treatments Today</p>
            </div>
            <div class="stat-icon stat-orange">
              <i class="fas fa-procedures"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="quick-actions">
        <h3><i class="fas fa-bolt mr-2"></i>Quick Actions</h3>
        <div class="action-buttons">
          <a href="#" class="btn-dental btn-primary">
            <i class="fas fa-plus mr-2"></i>Add New Patient
          </a>
          <a href="#" class="btn-dental btn-success">
            <i class="fas fa-calendar-plus mr-2"></i>Schedule Appointment
          </a>
          <a href="#" class="btn-dental btn-warning">
            <i class="fas fa-tooth mr-2"></i>Start Treatment
          </a>
          <a href="#" class="btn-dental">
            <i class="fas fa-x-ray mr-2"></i>Take X-Ray
          </a>
        </div>
      </div>

      <!-- Main Grid -->
      <div class="row">
        <!-- Patient Form -->
        <div class="col-lg-8">
          <div class="patient-form-container">
            <div class="form-header">
              <h3><i class="fas fa-user-plus mr-2"></i>Add New Patient</h3>
            </div>
            <div class="form-body">
              <form id="patientForm">
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="required">Full Name</label>
                      <input type="text" class="form-control" name="fullName" placeholder="John Doe" required>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Patient ID</label>
                      <input type="text" class="form-control" name="patientId" placeholder="PT001234">
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="required">Gender</label>
                      <select class="form-control" name="gender" required>
                        <option value="">Select Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="other">Other</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="required">Date of Birth</label>
                      <input type="date" class="form-control" name="birthDate" required>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="required">Phone Number</label>
                      <input type="tel" class="form-control" name="phone" placeholder="+1 (555) 123-4567" required>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Email Address</label>
                      <input type="email" class="form-control" name="email" placeholder="patient@email.com">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Insurance Number</label>
                      <input type="text" class="form-control" name="insurance" placeholder="INS123456789">
                    </div>
                  </div>
                </div>
                <div class="form-group">
                  <label class="required">Address</label>
                  <textarea class="form-control" name="address" rows="2" placeholder="Street address, City, State, ZIP Code" required></textarea>
                </div>
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Assigned Dentist</label>
                      <select class="form-control" name="doctor">
                        <option value="">Select Dentist</option>
                        <option value="1">Dr. John Smith - General Dentistry</option>
                        <option value="2">Dr. Sarah Johnson - Orthodontics</option>
                        <option value="3">Dr. Michael Brown - Periodontics</option>
                        <option value="4">Dr. Emily Davis - Endodontics</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label>Treatment Type</label>
                      <select class="form-control" name="treatmentType">
                        <option value="">Select Treatment</option>
                        <option value="examination">General Examination</option>
                        <option value="cleaning">Dental Cleaning</option>
                        <option value="filling">Tooth Filling</option>
                        <option value="extraction">Tooth Extraction</option>
                        <option value="orthodontics">Orthodontic Treatment</option>
                        <option value="implant">Dental Implant</option>
                        <option value="crown">Crown/Bridge</option>
                        <option value="whitening">Teeth Whitening</option>
                      </select>
                    </div>
                  </div>
                </div>
                <div class="form-group">
                  <label>Chief Complaint/Symptoms</label>
                  <textarea class="form-control" name="symptoms" rows="3" placeholder="Describe current dental problems or symptoms..."></textarea>
                </div>
                <div class="form-group">
                  <label>Medical History</label>
                  <textarea class="form-control" name="medicalHistory" rows="2" placeholder="Previous medical conditions, allergies, medications..."></textarea>
                </div>
                <div class="text-right">
                  <button type="button" class="btn-dental" onclick="resetForm()">Cancel</button>
                  <button type="submit" class="btn-dental btn-primary">Save Patient</button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Appointment List & Treatment Plans -->
        <div class="col-lg-4">
          <!-- Today's Appointments -->
          <div class="appointment-container mb-4">
            <div class="appointment-header">
              <h3><i class="fas fa-clock mr-2"></i>Today's Appointments</h3>
            </div>
            <div class="appointment-list">
              <div class="appointment-item">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <div>
                    <h6 class="mb-1">Sarah Wilson</h6>
                    <small class="text-muted">Dr. John Smith</small>
                  </div>
                  <span class="badge badge-confirmed">Confirmed</span>
                </div>
                <div class="d-flex justify-content-between text-muted">
                  <small><i class="fas fa-clock mr-1"></i>08:30 AM</small>
                  <small><i class="fas fa-tooth mr-1"></i>Tooth Filling</small>
                </div>
              </div>

              <div class="appointment-item">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <div>
                    <h6 class="mb-1">Michael Johnson</h6>
                    <small class="text-muted">Dr. Sarah Johnson</small>
                  </div>
                  <span class="badge badge-waiting">Waiting</span>
                </div>
                <div class="d-flex justify-content-between text-muted">
                  <small><i class="fas fa-clock mr-1"></i>09:15 AM</small>
                  <small><i class="fas fa-tooth mr-1"></i>Dental Cleaning</small>
                </div>
              </div>

              <div class="appointment-item">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <div>
                    <h6 class="mb-1">Emma Davis</h6>
                    <small class="text-muted">Dr. Michael Brown</small>
                  </div>
                  <span class="badge badge-in-progress">In Treatment</span>
                </div>
                <div class="d-flex justify-content-between text-muted">
                  <small><i class="fas fa-clock mr-1"></i>10:00 AM</small>
                  <small><i class="fas fa-tooth mr-1"></i>Orthodontics</small>
                </div>
              </div>

              <div class="appointment-item">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <div>
                    <h6 class="mb-1">Robert Brown</h6>
                    <small class="text-muted">Dr. Emily Davis</small>
                  </div>
                  <span class="badge badge-confirmed">Confirmed</span>
                </div>
                <div class="d-flex justify-content-between text-muted">
                  <small><i class="fas fa-clock mr-1"></i>10:45 AM</small>
                  <small><i class="fas fa-tooth mr-1"></i>Wisdom Tooth Extraction</small>
                </div>
              </div>
            </div>
            <div class="p-3 border-top">
              <a href="#" class="btn-dental btn-primary btn-block">View All Appointments</a>
            </div>
          </div>

          <!-- Popular Treatments -->
          <div class="appointment-container">
            <div class="appointment-header">
              <h3><i class="fas fa-procedures mr-2"></i>Popular Treatments</h3>
            </div>
            <div class="p-3">
              <div class="treatment-card">
                <div class="treatment-header">
                  <h6 class="treatment-name">Dental Cleaning</h6>
                  <span class="treatment-price">$120</span>
                </div>
                <p class="treatment-description">Professional teeth cleaning and plaque removal</p>
                <div class="treatment-duration">
                  <i class="fas fa-clock mr-1"></i>30 minutes
                </div>
              </div>

              <div class="treatment-card">
                <div class="treatment-header">
                  <h6 class="treatment-name">Tooth Filling</h6>
                  <span class="treatment-price">$180</span>
                </div>
                <p class="treatment-description">Cavity treatment with composite filling</p>
                <div class="treatment-duration">
                  <i class="fas fa-clock mr-1"></i>45 minutes
                </div>
              </div>

              <div class="treatment-card">
                <div class="treatment-header">
                  <h6 class="treatment-name">Tooth Extraction</h6>
                  <span class="treatment-price">$300</span>
                </div>
                <p class="treatment-description">Removal of damaged or impacted teeth</p>
                <div class="treatment-duration">
                  <i class="fas fa-clock mr-1"></i>60 minutes
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Additional Info Cards -->
      <div class="row mt-4">
        <div class="col-md-4">
          <div class="notification-panel">
            <div class="form-header">
              <h3><i class="fas fa-bell mr-2"></i>Notifications</h3>
            </div>
            <div class="notification-item">
              <div class="notification-icon info">
                <i class="fas fa-info"></i>
              </div>
              <div class="notification-content">
                <h6>New Appointment</h6>
                <p>Patient John Doe scheduled for 2:00 PM</p>
              </div>
            </div>
            <div class="notification-item">
              <div class="notification-icon warning">
                <i class="fas fa-exclamation"></i>
              </div>
              <div class="notification-content">
                <h6>Low Inventory</h6>
                <p>Composite filling material running low</p>
              </div>
            </div>
            <div class="notification-item">
              <div class="notification-icon success">
                <i class="fas fa-check"></i>
              </div>
              <div class="notification-content">
                <h6>Payment Received</h6>
                <p>Patient Mary Smith paid $450</p>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="stat-card">
            <div class="form-header">
              <h3><i class="fas fa-chart-line mr-2"></i>Quick Reports</h3>
            </div>
            <div class="p-3">
              <div class="d-flex justify-content-between mb-2">
                <span>Today's Revenue</span>
                <strong class="text-success">$5,120</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Monthly Revenue</span>
                <strong class="text-primary">$147,800</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Patient Satisfaction</span>
                <strong class="text-success">98.5%</strong>
              </div>
              <div class="d-flex justify-content-between">
                <span>Available Chairs</span>
                <strong class="text-warning">2/8</strong>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="stat-card">
            <div class="form-header">
              <h3><i class="fas fa-calendar mr-2"></i>Staff Schedule</h3>
            </div>
            <div class="p-3">
              <div class="d-flex justify-content-between mb-2">
                <span>Morning Shift (8:00-12:00)</span>
                <strong class="text-success">4 dentists</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Afternoon Shift (1:00-5:00)</span>
                <strong class="text-primary">6 dentists</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Evening Shift (6:00-9:00)</span>
                <strong class="text-warning">2 dentists</strong>
              </div>
              <div class="d-flex justify-content-between">
                <span>Weekend On-Call</span>
                <strong class="text-danger">1 dentist</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- jQuery and Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
  // Toggle sidebar for mobile
  function toggleSidebar() {
    $('#sidebar').toggleClass('open');
  }

  // Navigation active state
  $('.nav-link').click(function(e) {
    if ($(this).attr('href') === '#') {
      e.preventDefault();
    }
    $('.nav-link').removeClass('active');
    $(this).addClass('active');
  });

  // Form validation and submission
  $('#patientForm').on('submit', function(e) {
    e.preventDefault();

    // Basic validation
    let isValid = true;
    $(this).find('input[required], select[required], textarea[required]').each(function() {
      if (!$(this).val().trim()) {
        isValid = false;
        $(this).addClass('is-invalid');
        $(this).removeClass('is-valid');
      } else {
        $(this).removeClass('is-invalid');
        $(this).addClass('is-valid');
      }
    });

    // Phone validation
    const phone = $('input[name="phone"]').val();
    if (phone && !/^[\+]?[1-9][\d]{0,15}$/.test(phone.replace(/[\s\-$$$$]/g, ''))) {
      isValid = false;
      $('input[name="phone"]').addClass('is-invalid');
    }

    // Email validation
    const email = $('input[name="email"]').val();
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      isValid = false;
      $('input[name="email"]').addClass('is-invalid');
    }

    if (isValid) {
      alert('Patient information has been saved successfully!');
      resetForm();
    } else {
      alert('Please fill in all required fields correctly!');
    }
  });

  // Reset form
  function resetForm() {
    $('#patientForm')[0].reset();
    $('#patientForm').find('.is-invalid, .is-valid').removeClass('is-invalid is-valid');
  }

  // Search functionality
  $('.search-bar input').on('input', function() {
    const searchTerm = $(this).val().toLowerCase();
    console.log('Searching for:', searchTerm);
    // Implement search logic here
  });

  // Real-time clock
  function updateClock() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('en-US');
    const dateString = now.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });

    // Update page subtitle with current time
    $('.page-subtitle').html(`Welcome back! Here's your clinic overview for today - ${timeString}`);
  }

  // Update clock every minute
  setInterval(updateClock, 60000);
  updateClock(); // Initial call

  // Close sidebar when clicking outside on mobile
  $(document).on('click', function(e) {
    if ($(window).width() <= 768) {
      if (!$(e.target).closest('.sidebar, .btn-dental').length) {
        $('#sidebar').removeClass('open');
      }
    }
  });

  // Initialize tooltips
  $('[data-toggle="tooltip"]').tooltip();

  // Auto-refresh appointments every 5 minutes
  setInterval(function() {
    console.log('Refreshing appointments...');
    // Implement AJAX call to refresh appointment data
  }, 300000);

  // Simulate real-time updates
  function simulateRealTimeUpdates() {
    // Update stats randomly
    setInterval(function() {
      const totalPatients = Math.floor(Math.random() * 50) + 1200;
      const todayAppointments = Math.floor(Math.random() * 10) + 25;
      const activeDentists = Math.floor(Math.random() * 3) + 5;
      const treatmentsToday = Math.floor(Math.random() * 5) + 10;

      $('.stat-teal').text(totalPatients.toLocaleString());
      $('.stat-blue').text(todayAppointments);
      $('.stat-green').text(activeDentists);
      $('.stat-orange').text(treatmentsToday);
    }, 30000); // Update every 30 seconds
  }

  // Start real-time updates
  simulateRealTimeUpdates();
</script>

</body>
</html>