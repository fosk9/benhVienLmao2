document.addEventListener("DOMContentLoaded", () => {
    const chatIcon = document.getElementById("chat-icon");
    const chatbox = document.getElementById("chatbox");
    const sendBtn = document.getElementById("send-button");
    const input = document.getElementById("chat-input");
    const messages = document.getElementById("chat-messages");

    // Toggle chatbox hiển thị
    chatIcon.addEventListener("click", () => {
        const isVisible = chatbox.style.display === "flex";
        chatbox.style.display = isVisible ? "none" : "flex";
    });

    // Gửi khi bấm nút hoặc nhấn Enter
    sendBtn.onclick = sendMessage;
    input.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();
            sendMessage();
        }
    });

    // Gửi tin nhắn
    function sendMessage() {
        const msg = input.value.trim();
        if (!msg) return;

        appendMessage(msg, "user");
        input.value = "";

        fetch(contextPath + "/chatbot", {
            method: "POST",
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "message=" + encodeURIComponent(msg)
        })
            .then(res => {
                if (!res.ok) throw new Error("Server error: " + res.status);
                return res.json();
            })
            .then(data => {
                appendMessage(data.reply, "bot");
            })
            .catch(err => {
                console.error(err);
                appendMessage("❌ Sorry, something went wrong.", "bot");
            });
    }

    // Hiển thị tin nhắn lên khung chat
    function appendMessage(content, sender) {
        const msgWrapper = document.createElement("div");
        msgWrapper.className = `message-wrapper ${sender}`;

        const msgDiv = document.createElement("div");
        msgDiv.className = `message ${sender}`;

        const bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.textContent = content;

        if (sender === "bot") {
            const avatar = document.createElement("img");
            avatar.src = contextPath + "/assets/img/chatbot.png"; // Đường dẫn ảnh avatar
            avatar.alt = "Bot";
            avatar.className = "avatar";
            msgDiv.appendChild(avatar);
        }

        msgDiv.appendChild(bubble);
        msgWrapper.appendChild(msgDiv);
        messages.appendChild(msgWrapper);
        messages.scrollTop = messages.scrollHeight;
    }

});
