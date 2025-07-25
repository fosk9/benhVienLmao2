package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class SmsSender {

    public static void sendOtp(String phone, String otpCode) throws IOException {
        String apiKey = "948859F788CFEA246D059FEE42786D";
        String secretKey = "9D464F5F6DC8BC7BA17EDA1C7544DA";
        String brandName = "Baotrixemay"; // Brandname được cấp
        String content = "Ma OTP cua ban la: " + otpCode;

        // Thay bằng domain thật (HTTPS) nếu bạn muốn nhận callback
        String callbackUrl = "https://yourdomain.com/esms-callback";

        String requestUrl = "http://rest.esms.vn/MainService.svc/json/SendMultipleMessage_V4_get" +
                "?ApiKey=" + URLEncoder.encode(apiKey, "UTF-8") +
                "&SecretKey=" + URLEncoder.encode(secretKey, "UTF-8") +
                "&Phone=" + URLEncoder.encode(phone, "UTF-8") +
                "&Content=" + URLEncoder.encode(content, "UTF-8") +
                "&SmsType=8" + // Brandname
                "&CallbackUrl=" + URLEncoder.encode(callbackUrl, "UTF-8");

        URL url = new URL(requestUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        try (BufferedReader in = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"))) {

            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }

            System.out.println("Response from eSMS: " + response);
        }
    }

    public static void main(String[] args) throws IOException {
        sendOtp("84964907175", "123456"); // Định dạng: 84xxxxxxxxx
    }
}
