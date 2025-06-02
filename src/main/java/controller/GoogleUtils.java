package controller;

import com.google.gson.Gson;
import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import model.GoogleAccount;

public class GoogleUtils {
    //Cần thêm mã gg
    private static final String CLIENT_ID = "";
    private static final String CLIENT_SECRET = "";
    private static final String REDIRECT_URI = "http://localhost:8080/benhVienLmao_war_exploded/google-login";
    private static final String TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";
    private static final String USER_INFO_ENDPOINT = "https://www.googleapis.com/oauth2/v2/userinfo";

    /**
     * Lấy access_token từ mã code mà Google redirect về
     */
    public static String getToken(String code) throws IOException {
        URL url = new URL(TOKEN_ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String params = "code=" + URLEncoder.encode(code, "UTF-8")
                + "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes());
            os.flush();
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
        }

        // Trích xuất access_token từ JSON
        String responseStr = response.toString();
        String accessToken = new Gson().fromJson(responseStr, AccessTokenResponse.class).access_token;

        return accessToken;
    }

    /**
     * Lấy thông tin người dùng từ access_token
     */
    public static GoogleAccount getUserInfo(String accessToken) throws IOException {
        URL url = new URL(USER_INFO_ENDPOINT + "?access_token=" + accessToken);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        StringBuilder response = new StringBuilder();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
        }

        return new Gson().fromJson(response.toString(), GoogleAccount.class);
    }

    /**
     * Class nội bộ để parse JSON response khi lấy token
     */
    private static class AccessTokenResponse {
        String access_token;
        String expires_in;
        String token_type;
        String refresh_token;
    }
}

