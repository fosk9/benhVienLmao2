document.addEventListener("DOMContentLoaded", function () {
    const chatbox = document.querySelector("#chatbox");
    const input = document.querySelector("#chat-input");
    const sendBtn = document.querySelector("#send-btn");
    const chatHistory = document.querySelector("#chat-history");

    sendBtn.onclick = () => {
        const message = input.value.trim();
        if (message === "") return;

        chatHistory.innerHTML += `<div class="user-msg">${message}</div>`;
        input.value = "";

        fetch("chatbot", {
            method: "POST",
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: "message=" + encodeURIComponent(message)
        })
            .then(res => res.json())
            .then(data => {
                chatHistory.innerHTML += `<div class="bot-msg">${data.reply}</div>`;
                chatbox.scrollTop = chatbox.scrollHeight;
            });
    };
});
