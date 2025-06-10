package validation;

import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

public class PatientValidator {

    // Name: Only letters (with diacritics) and whitespace
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}\\s]+$");

    // Phone: starts with 0 or +84, followed by 9 digits
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)(\\d{9})$");

    // Email: standard email format
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,6}$");

    public static boolean isValidFullName(String fullName) {
        if (fullName == null) return false;
        String trimmed = fullName.trim();
        // Không cho phép khoảng trắng liên tiếp
        if (trimmed.contains("  ")) return false;
        // Kiểm tra chỉ chứa chữ và khoảng trắng
        return NAME_PATTERN.matcher(trimmed).matches();
    }

    public static boolean isValidDob(Date dob) {
        if (dob == null) return false;
        LocalDate today = LocalDate.now();
        return !dob.toLocalDate().isAfter(today) && dob.toLocalDate().getYear() >= 1900;
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidGender(String gender) {
        return "M".equals(gender) || "F".equals(gender) || "O".equals(gender);
    }

    public static boolean isValidEmergencyContact(String emergencyContact) {
        return emergencyContact == null || PHONE_PATTERN.matcher(emergencyContact.trim()).matches();
    }

    public static boolean isValidInsuranceNumber(String insuranceNumber) {
        return insuranceNumber == null || insuranceNumber.trim().length() <= 20;
    }

    public static boolean isValidAddress(String address) {
        return address == null || address.trim().length() <= 255;
    }
}
