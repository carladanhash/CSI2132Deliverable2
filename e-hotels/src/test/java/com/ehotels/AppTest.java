package com.ehotels;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;


@SpringBootTest
@ActiveProfiles("test")  // ✅ This ensures Spring loads `application-test.properties`
class AppTest {

    @Test
    void contextLoads() {
        // Just checks if the application starts
    }
}
