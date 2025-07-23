package controller;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class SmsSender {

    public static void sendOtp(String phone, String otpCode) throws IOException {
        String apiKey = "948859F788CFEA246D059FEE42786D";
        String secretKey = "9D464F5F6DC8BC7BA17EDA1C7544DA";
        String content = "Your OTP is: " + otpCode;

        String requestUrl = "http://rest.esms.vn/MainService.svc/json/SendMultipleMessage_V4_get" +
                "?ApiKey=" + URLEncoder.encode(apiKey, "UTF-8") +
                "&SecretKey=" + URLEncoder.encode(secretKey, "UTF-8") +
                "&Phone=" + URLEncoder.encode(phone, "UTF-8") +
                "&Content=" + URLEncoder.encode(content, "UTF-8") +
                "&SmsType=8"; // 2 là brandname, 8 là số thuê bao thường

        URL url = new URL(requestUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader in = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        System.out.println("Response from eSMS: " + response);
    }

    public static void main(String[] args) throws IOException {
        sendOtp("84964907175", "123456"); // số điện thoại +84, không có dấu "+"
    }
}
