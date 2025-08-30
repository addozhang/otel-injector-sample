package com.example.servicea;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;

@SpringBootApplication
public class ServiceAApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServiceAApplication.class, args);
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

@RestController
class ChainController {

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping("/chain")
    public ResponseEntity<String> startChain() {
        try {
            // Call Service-B
            String serviceBUrl = "http://service-b:3000/chain";
            ResponseEntity<String> serviceBResponse = restTemplate.getForEntity(serviceBUrl, String.class);

            String response = String.format("Service-A (Java) → %s", serviceBResponse.getBody());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.ok("Service-A (Java) → Service-B call failed: " + e.getMessage());
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Service-A (Java) is healthy");
    }
}