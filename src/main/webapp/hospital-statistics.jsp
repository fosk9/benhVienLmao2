<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="common-css.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Report Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<main>
    <div class="slider-area slider-area2">
        <div class="single-slider d-flex align-items-center slider-height2">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">
                        <div class="hero-wrapper">
                            <div class="hero__caption">
                                <h1 data-animation="fadeInUp">Revenue Report</h1>
                                <p data-animation="fadeInUp">Visualized financial data & insights</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="whole-wrap">
        <div class="container box_1170">

            <!-- KPI Block -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">Key Revenue Indicators</h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-md-4">
                            <h5>Total Income</h5>
                            <p class="text-primary h5 mb-0">
                                <%= String.format("%,.0f VND", request.getAttribute("totalIncome")) %>
                            </p>
                        </div>
                        <div class="col-md-4">
                            <h5>This Month</h5>
                            <p class="text-success h5 mb-0">
                                <%= String.format("%,.0f VND", request.getAttribute("thisMonth")) %>
                            </p>
                        </div>
                        <div class="col-md-4">
                            <h5>Growth</h5>
                            <%
                                double rate = (double) request.getAttribute("growthRate");
                            %>
                            <p class="<%= rate >= 0 ? "text-success" : "text-danger" %> h5 mb-0">
                                <%= String.format("%.2f%% %s", Math.abs(rate), rate >= 0 ? "▲" : "▼") %>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chart Blocks -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Monthly Income</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="monthlyIncomeChart" height="200"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h5 class="mb-0">Top Doctor Revenue</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="doctorIncomeChart" height="200"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Text-based Reports -->
            <div class="row">
                <!-- Top Doctors -->
                <div class="col-md-6">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Top Doctors This Month</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <%
                                java.util.List<String> topDoctors = (java.util.List<String>) request.getAttribute("topDoctors");
                                for (String s : topDoctors) {
                            %>
                            <li class="list-group-item py-3">
                                <i class="fas fa-user-md text-primary me-2"></i> <%= s %>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                </div>

                <!-- Popular Services -->
                <div class="col-md-6">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">Popular Services Recently</h5>
                        </div>
                        <ul class="list-group list-group-flush">
                            <%
                                java.util.List<String> popularServices = (java.util.List<String>) request.getAttribute("popularServices");
                                for (String s : popularServices) {
                            %>
                            <li class="list-group-item py-3">
                                <i class="fas fa-stethoscope text-success me-2"></i> <%= s %>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main>
<%@ include file="footer.jsp" %>
<%@ include file="common-scripts.jsp" %>
<script>
    const monthlyIncomeLabels = ${monthlyIncomeLabels};
    const monthlyIncomeData = ${monthlyIncomeData};
    const doctorNames = ${doctorNames};
    const doctorIncomeData = ${doctorIncomeData};

    new Chart(document.getElementById('monthlyIncomeChart'), {
        type: 'bar',
        data: {
            labels: monthlyIncomeLabels,
            datasets: [{
                label: 'Monthly Income (VND)',
                data: monthlyIncomeData,
                backgroundColor: '#0d6efd'
            }]
        }
    });

    new Chart(document.getElementById('doctorIncomeChart'), {
        type: 'bar',
        data: {
            labels: doctorNames,
            datasets: [{
                label: 'Doctor Income (VND)',
                data: doctorIncomeData,
                backgroundColor: '#198754'
            }]
        },
        options: {
            indexAxis: 'y'
        }
    });
</script>
</body>
</html>
