<%--
  Created by IntelliJ IDEA.
  User: Fosk Jesky
  Date: 7/22/2025
  Time: 11:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Realtime Logs</title>
    <script>
        let socket = new WebSocket("ws://localhost:8080/benhVienLmao_war_exploded/admin/logSocket");

        socket.onmessage = function(event) {
            let logArea = document.getElementById("logs");
            logArea.value += event.data + "\n";
        };
    </script>
</head>
<body>
<h2>Real-time Log Viewer</h2>
<textarea id="logs" rows="20" cols="80" readonly></textarea>
</body>
</html>
