package service;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import util.PayOSProperties; // Import lớp mới tạo

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;

@Service
public class PayOSApiClient {

    private final RestTemplate restTemplate;
    private final PayOSProperties payOSProperties; // Inject PayOSProperties

    // Inject PayOSProperties vào constructor
    public PayOSApiClient(RestTemplateBuilder restTemplateBuilder, PayOSProperties payOSProperties) {
        this.restTemplate = restTemplateBuilder.build();
        this.payOSProperties = payOSProperties;
    }

    public String getTransactionHistory(LocalDate startDate, LocalDate endDate) {
        String startDateStr = startDate.format(DateTimeFormatter.ISO_LOCAL_DATE);
        String endDateStr = endDate.format(DateTimeFormatter.ISO_LOCAL_DATE);

        String url = UriComponentsBuilder.fromHttpUrl(payOSProperties.getBaseUrl()) // Sử dụng baseUrl từ properties
                .path("/transactions") // Kiểm tra endpoint chính xác trong tài liệu PayOS
                .queryParam("startDate", startDateStr)
                .queryParam("endDate", endDateStr)
                .toUriString();

        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set("X-API-KEY", payOSProperties.getApiKey()); // Sử dụng apiKey từ properties

        HttpEntity<String> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    entity,
                    String.class
            );
            System.out.println("PayOS API Response Status: " + response.getStatusCode());
            return response.getBody();
        } catch (Exception e) {
            System.err.println("Error calling PayOS API: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}