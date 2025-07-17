package model;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties; // NEW
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import vn.payos.PayOS;
import util.PayOSProperties; // Import lớp mới tạo

@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
@Configuration
@EnableScheduling
@EnableConfigurationProperties(PayOSProperties.class) // NEW: Kích hoạt xử lý PayOSProperties
public class SpringbootBackendPayosApplication implements WebMvcConfigurer {

    public static void main(String[] args) {
        SpringApplication.run(SpringbootBackendPayosApplication.class, args);
    }

    @Override
    public void addCorsMappings(@NonNull CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowedHeaders("*")
                .exposedHeaders("*")
                .allowCredentials(false).maxAge(3600);
    }

    @Bean
    public PayOS payOS(PayOSProperties payOSProperties) { // Inject PayOSProperties
        return new PayOS(payOSProperties.getClientId(), payOSProperties.getApiKey(), payOSProperties.getChecksumKey());
    }
}