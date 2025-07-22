package service;

import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;
import com.google.genai.types.GenerationConfig;

import java.util.List;

public class GeminiService {
    // Giữ API key hardcoded theo yêu cầu để test
    private static final String API_KEY = "AIzaSyBKOni8FJ6KDVDSltbm06-2nvvt1FC1-D8";
    private final Client client;

    // Định nghĩa vai trò của chatbot ở đây
    private static final String CHATBOT_PERSONA = "Bạn là một trợ lý AI và là tư vấn viên chuyên nghiệp của Nha khoa 'Dental Care'. Hãy luôn trả lời một cách thân thiện, chuyên nghiệp và hữu ích. " +
            "Nhiệm vụ của bạn bao gồm: " +
            "- Chào hỏi và hỏi thăm vấn đề của khách hàng. " +
            "- Tư vấn về các dịch vụ của nha khoa như: cạo vôi răng, trám răng, niềng răng, trồng răng Implant, tẩy trắng răng. " +
            "- Cung cấp thông tin ước tính về chi phí và thời gian điều trị. " +
            "- Hỗ trợ đặt lịch hẹn với bác sĩ. " +
            "- Trả lời các câu hỏi thường gặp về chăm sóc răng miệng. " +
            "- Không được đưa ra chẩn đoán y tế. Thay vào đó, hãy khuyên người dùng nên đến gặp bác sĩ để được khám trực tiếp.\n\n";

    public GeminiService() {
        this.client = Client.builder().apiKey(API_KEY).build();
    }

    /**
     * Tạo câu trả lời từ Gemini dựa vào lịch sử cuộc trò chuyện và vai trò được xác định trước.
     * Tin nhắn mới nhất của người dùng đã phải có trong history.
     *
     * @param history Lịch sử cuộc trò chuyện, bao gồm cả tin nhắn mới nhất của người dùng.
     * @return Câu trả lời của Bot.
     */
    public String generateReply(List<String> history) {
        // Luôn bắt đầu prompt bằng việc xác định vai trò của chatbot
        StringBuilder prompt = new StringBuilder(CHATBOT_PERSONA);

        // Thêm lịch sử trò chuyện vào prompt
        for (String line : history) {
            prompt.append(line).append("\n");
        }
        // Thêm định dạng để model biết cần phải trả lời
        prompt.append("Bot:");

        try {
            // Sử dụng tên model chính xác. "gemini-1.5-flash-latest" là một lựa chọn tốt và mới hơn.
            // Lưu ý: "gemini-2.0-flash" không phải là tên model hợp lệ tại thời điểm hiện tại.
            GenerateContentResponse response = client.models.generateContent(
                    "gemini-2.0-flash", // Sửa thành tên model hợp lệ
                    prompt.toString(),
                    null
            );
            return response.text();
        } catch (Exception e) {
            // Xử lý khi API của Gemini bị lỗi
            e.printStackTrace(); // In lỗi ra console để debug
            return "Xin lỗi, tôi đang gặp sự cố. Vui lòng thử lại sau.";
        }
    }
}