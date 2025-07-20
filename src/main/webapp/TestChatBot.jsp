<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Simple Chatbot Test</title>
    <style>
        #chatbox {
            width: 300px;
            margin: 20px auto;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 8px;
            font-family: Arial, sans-serif;
        }

        #messages {
            height: 200px;
            overflow-y: auto;
            border: 1px solid #eee;
            padding: 5px;
            margin-bottom: 10px;
        }

        .user-msg {
            text-align: right;
            background-color: #cce5ff;
            margin: 5px;
            padding: 5px;
            border-radius: 5px;
        }

        .bot-msg {
            text-align: left;
            background-color: #e2e3e5;
            margin: 5px;
            padding: 5px;
            border-radius: 5px;
        }

        #chat-input {
            width: 70%;
            padding: 5px;
        }

        #send-btn {
            width: 25%;
            padding: 5px;
        }
    </style>
</head>
<body>

<div id="chatbox">
    <div id="messages"></div>
    <input type="text" id="chat-input" placeholder="Type message..."/>
    <button id="send-btn">Send</button>
</div>

<script>
    const input = document.querySelector("#chat-input");
    const sendBtn = document.querySelector("#send-btn");
    const messages = document.querySelector("#messages");

    function appendMessage(content, sender) {
        const msgDiv = document.createElement("div");
        msgDiv.className = sender === "user" ? "user-msg" : "bot-msg";
        msgDiv.textContent = content;
        messages.appendChild(msgDiv);
        messages.scrollTop = messages.scrollHeight;
    }

    function sendMessage() {
        const msg = input.value.trim();
        if (!msg) return;

        appendMessage(msg, "user");
        input.value = "";

        fetch("<%=request.getContextPath()%>/chatbot", {
            method: "POST",
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "message=" + encodeURIComponent(msg)
        })
            .then(res => res.json())
            .then(data => {
                appendMessage(data.reply, "bot");
            })
            .catch(err => {
                console.error(err);
                appendMessage("❌ Failed to get reply", "bot");
            });
    }

    sendBtn.onclick = sendMessage;
    input.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();
            sendMessage();
        }
    });
</script>

</body>
</html>
