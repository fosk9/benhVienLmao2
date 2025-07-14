package util;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "payos.api")
public class PayOSProperties {

    private String clientId;
    private String apiKey;
    private String checksumKey;
    private String baseUrl;
    private String domain; // NEW: Thêm trường domain
}