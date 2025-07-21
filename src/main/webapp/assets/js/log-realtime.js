// JavaScript for real-time log updates
function updateLogs(latestLogId) {
    const params = new URLSearchParams(window.location.search);
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/admin/logs?ajax=true&latestLogId=' + latestLogId + '&' + params.toString(), true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            const newLogs = JSON.parse(xhr.responseText);
            const tbody = document.getElementById('logTableBody');
            tbody.innerHTML = '';
            if (newLogs.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center">No logs found.</td></tr>';
            } else {
                newLogs.forEach(log => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>${log.logId}</td>
                        <td>${log.userName}</td>
                        <td>${log.employeeId ? log.employeeId + ' (Employee)' : log.patientId ? log.patientId + ' (Patient)' : 'System'}</td>
                        <td>${log.roleName}</td>
                        <td>${log.action}</td>
                        <td>${log.logLevel}</td>
                        <td>${log.createdAt}</td>
                    `;
                    tbody.appendChild(row);
                });
            }
        }
    };
    xhr.send();
}

// Fallback AJAX polling if WebSocket fails
setInterval(() => {
    updateLogs(document.getElementById('logTableBody').firstElementChild?.firstElementChild?.textContent || 0);
}, 10000); // Poll every 10 seconds