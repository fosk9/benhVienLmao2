package validation;

import java.math.BigDecimal;

public class DoctorDetailsValidator {

    public static boolean isValidLicenseNumber(String licenseNumber) {
        return licenseNumber != null && !licenseNumber.trim().isEmpty() && licenseNumber.length() <= 100;
    }

    public static boolean isValidRating(BigDecimal rating) {
        if (rating == null) return false;
        return rating.compareTo(new BigDecimal("1.00")) >= 0 &&
                rating.compareTo(new BigDecimal("5.00")) <= 0;
    }
}
