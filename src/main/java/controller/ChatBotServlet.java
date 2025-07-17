package controller;

import com.google.gson.Gson; // Import thư viện Gson
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.GeminiService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@WebServlet("/chatbot")
public class ChatBotServlet extends HttpServlet {
    private final GeminiService geminiService = new GeminiService();
    // Khởi tạo Gson để sử dụng trong toàn bộ servlet
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userMessage = request.getParameter("message");
        HttpSession session = request.getSession();

        // Luôn lấy history từ session, khởi tạo nếu chưa có
        List<String> history = (List<String>) session.getAttribute("chatHistory");
        if (history == null) {
            history = new ArrayList<>();
        }

        // Thêm câu hỏi mới của người dùng vào lịch sử
        history.add("User: " + userMessage);

        // Giới hạn history còn 10 dòng gần nhất (5 cặp hỏi-đáp)
        if (history.size() > 10) {
            history = new ArrayList<>(history.subList(history.size() - 10, history.size()));
        }

        // Gọi service chỉ với history đã được cập nhật
        String botReply = geminiService.generateReply(history);

        // Thêm câu trả lời của bot vào lịch sử
        history.add("Bot: " + botReply);
        session.setAttribute("chatHistory", history);

        // Dùng Gson để tạo JSON một cách an toàn và đúng chuẩn
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Tạo một Map để Gson chuyển thành đối tượng JSON {"reply": "..."}
        Map<String, String> jsonResponse = Collections.singletonMap("reply", botReply);
        String jsonOutput = gson.toJson(jsonResponse);

        out.print(jsonOutput);
        out.flush();
    }
}