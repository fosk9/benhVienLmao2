package model;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import vn.payos.PayOS;

@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
@Configuration
public class SpringbootBackendPayosApplication implements WebMvcConfigurer {

    @Value("8ada356e-2e8f-4ac2-893c-b9dd34f259b5")
    private String clientId;

    @Value("99428222-900b-4792-b511-ef72cc2d0853")
    private String apiKey;

    @Value("de4193745f19d74a5b0f6dc354555d881e8a8ef14874a863eb5c7c5a4af95c0a")
    private String checksumKey;

    @Override
    public void addCorsMappings(@NonNull CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowedHeaders("*")
                .exposedHeaders("*")
                .allowCredentials(false)
                .maxAge(3600); // Max age of the CORS pre-flight request
    }

    @Bean
    public PayOS payOS() {
        return new PayOS(clientId, apiKey, checksumKey);
    }

    public static void main(String[] args) {
        SpringApplication.run(SpringbootBackendPayosApplication.class, args);
    }
}