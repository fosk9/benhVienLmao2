package service;

import com.google.genai.Client;
import com.google.genai.types.GenerateContentResponse;

import java.util.List;

public class GeminiService {
    // Giữ API key hardcoded theo yêu cầu để test
    private static final String API_KEY = "AIzaSyBKOni8FJ6KDVDSltbm06-2nvvt1FC1-D8";
    private final Client client;

    // Định nghĩa vai trò của chatbot ở đây
    private static final String CHATBOT_PERSONA =
            "Bạn là một trợ lý AI thân thiện và là tư vấn viên chuyên nghiệp của Nha khoa 'Dental Care'. " +
                    "Hãy luôn trả lời ngắn gọn,không được quá dài, dễ hiểu và hữu ích như đang nói chuyện với bệnh nhân thông thường. " +
                    "Tránh dùng thuật ngữ y khoa phức tạp hoặc giải thích chuyên sâu. " +
                    "Nhiệm vụ của bạn bao gồm:\n" +
                    "- Chào hỏi người dùng một cách lịch sự và thân thiện.\n" +
                    "- Hỏi người dùng đang gặp vấn đề gì về răng miệng khi người dùng bắt đầu nói chuyện.\n" +
                    "- Nếu người dùng chỉ nói đau, mà không nói kĩ là đau như nào, đau ở đâu, triệu chứng như nào, thì hỏi người dùng nói kĩ hơn.\n" +
                    "- Chỉ gợi ý dịch vụ nha khoa khi người dùng nói rõ tình trạng đau răng đang gặp.\n" +
                    "- Giới thiệu các dịch vụ nha khoa như: cạo vôi răng, trám răng, niềng răng, trồng răng Implant, tẩy trắng răng...\n" +
                    "- Cung cấp thông tin ước lượng chi phí và thời gian thực hiện từng dịch vụ (chỉ mang tính tham khảo).\n" +
                    "- Luôn nhấn mạnh rằng để biết chính xác, người dùng cần đến khám trực tiếp với bác sĩ.\n" +
                    "- Gợi ý người dùng bấm nút 'Book Appointment' để đặt lịch trước với bệnh viện, giúp sắp xếp bác sĩ phù hợp.\n" +
                    "- Sau mỗi phần tư vấn, hãy khuyến khích người dùng đặt lịch.\n" +
                    "- Không đưa ra chẩn đoán y tế cụ thể.\n" +
                    "- **Không sử dụng các hiệu ứng chữ viết như in đậm, nghiêng, markdown hoặc emoji động** vì giao diện chatbox không hỗ trợ chúng.\n";

    public GeminiService() {
        try {
            // Disable hostname verification and SSL check (NOT FOR PRODUCTION)
            javax.net.ssl.TrustManager[] trustAllCerts = new javax.net.ssl.TrustManager[]{
                    new javax.net.ssl.X509TrustManager() {
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            return null;
                        }

                        public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                        }

                        public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                        }
                    }
            };

            javax.net.ssl.SSLContext sc = javax.net.ssl.SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            javax.net.ssl.HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
            javax.net.ssl.HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);

        } catch (Exception e) {
            e.printStackTrace(); // In ra nếu setup SSL fail
        }

        // Tạo client Gemini như bình thường
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
            GenerateContentResponse response = client.models.generateContent(
                    "gemini-2.0-flash",
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