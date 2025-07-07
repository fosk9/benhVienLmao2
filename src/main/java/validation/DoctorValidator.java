package validation;

import java.util.regex.Pattern;

public class DoctorValidator {

    // Pattern for validating name (only letters and spaces allowed)
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}\\s]+$");

    // Pattern for validating phone numbers (starts with 0 or +84, followed by 9 digits)
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)(\\d{9})$");

    // Pattern for validating insurance number (only letters & digits, no special chars)
    private static final Pattern INSURANCE_PATTERN = Pattern.compile("^[A-Za-z0-9]+$");

    /**
     * Clean input: Trim đầu cuối và thay nhiều khoảng trắng liên tiếp thành 1 khoảng trắng.
     */
    public static String cleanInput(String input) {
        if (input == null) return null;
        return input.trim().replaceAll("\\s+", " ");
    }

    /**
     * Validate full name: letters + spaces, no double spaces.
     */
    public static boolean isValidFullName(String fullName) {
        if (fullName == null) return false;
        String cleaned = cleanInput(fullName);
        if (cleaned.isEmpty() || cleaned.contains("  ")) return false;
        return NAME_PATTERN.matcher(cleaned).matches();
    }

    /**
     * Validate phone: Must start with 0 or +84 and have exactly 9 digits after.
     */
    public static boolean isValidPhoneNumber(String phone) {
        if (phone == null) return false;
        String cleaned = cleanInput(phone);
        if (cleaned.isEmpty() || cleaned.contains("  ")) return false;
        return PHONE_PATTERN.matcher(cleaned).matches();
    }

    /**
     * Validate insurance number: Only letters and digits, at least one letter.
     */
    public static boolean isValidInsuranceNumber(String insuranceNumber) {
        if (insuranceNumber == null) return false;
        String cleaned = cleanInput(insuranceNumber);
        if (cleaned.isEmpty() || cleaned.contains("  ")) return false;
        if (!INSURANCE_PATTERN.matcher(cleaned).matches()) return false;
        if (!cleaned.matches(".*[A-Za-z].*")) return false; // must have at least one letter
        return true;
    }
}
