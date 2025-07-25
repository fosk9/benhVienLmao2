package service;

import com.cloudinary.Cloudinary;

import java.util.HashMap;
import java.util.Map;

public class CloudinaryService {

    private static Cloudinary cloudinary;

    static {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", "dszml4h40");
        config.put("api_key", "884262167538811");
        config.put("api_secret", "7vD8-Oqv15KZxBfLuoq-5ofxsEE");
        cloudinary = new Cloudinary(config);
    }

    public static Cloudinary getInstance() {
        return cloudinary;
    }
}
