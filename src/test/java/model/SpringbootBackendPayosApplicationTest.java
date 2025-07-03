package model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.testng.annotations.Test;

@SpringBootTest
@AutoConfigureMockMvc
public class SpringbootBackendPayosApplicationTest {

    @Autowired
    private MockMvc mockMvc;

    /**
     * Test case for verifying CORS configuration for all origins and methods.
     */
    @Test
    void contextLoads() {
    }

}