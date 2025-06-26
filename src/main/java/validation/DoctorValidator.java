package validation;

import java.util.regex.Pattern;

public class DoctorValidator {

    // Pattern for validating name (only letters and spaces allowed)
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}\\s]+$");

    // Pattern for validating phone numbers (starts with 0 or +84, followed by 9 digits)
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)(\\d{9})$");

    // Pattern for validating insurance number (only digits and spaces, no consecutive spaces)
    private static final Pattern INSURANCE_PATTERN = Pattern.compile("^[0-9\\s]+$");

    public static String cleanInput(String input) {
        if (input == null) return null;
        return input.trim().replaceAll("\\s+", " ");  // Replace multiple spaces with a single space
    }
    // Validate full name (no consecutive spaces, only letters and spaces)

    public static boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) return false;
        String trimmed = fullName.trim();
        // Ensure no consecutive spaces
        if (trimmed.contains("  ")) return false;
        // Check if it contains only letters and spaces
        return NAME_PATTERN.matcher(trimmed).matches();
    }

    // Validate phone number (must start with 0 or +84, followed by exactly 9 digits)
    public static boolean isValidPhoneNumber(String phone) {
        if (phone == null || phone.trim().isEmpty()) return false;
        String trimmedPhone = phone.trim();
        // Ensure no consecutive spaces and not empty
        if (trimmedPhone.contains("  ") || trimmedPhone.isEmpty()) return false;
        return PHONE_PATTERN.matcher(trimmedPhone).matches();
    }

    // Validate insurance number (only numbers and spaces are allowed, no consecutive spaces)
    public static boolean isValidInsuranceNumber(String insuranceNumber) {
        if (insuranceNumber == null || insuranceNumber.trim().isEmpty()) return false;
        String trimmedInsurance = insuranceNumber.trim();
        // Ensure no consecutive spaces and not empty
        if (trimmedInsurance.contains("  ") || trimmedInsurance.isEmpty()) return false;
        return INSURANCE_PATTERN.matcher(trimmedInsurance).matches();
    }
}
