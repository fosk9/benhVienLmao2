document.addEventListener('DOMContentLoaded', function () {
    const form = document.querySelector('form[action="UpdateMyProfileEmployee"]');

    form.addEventListener('submit', function (e) {
        const fullName = form.fullName.value.trim();
        const dob = form.dob.value;
        const phone = form.phone.value.trim();

        let errors = [];

        // Validate full name: chỉ cho chữ cái, khoảng trắng, không số, không ký tự đặc biệt
        const fullNameRegex = /^[A-Za-z\s]+$/;
        if (!fullNameRegex.test(fullName)) {
            errors.push("Full name must contain only letters and spaces.");
        }

        // Validate dob: năm phải < năm hiện tại
        if (dob) {
            const inputYear = new Date(dob).getFullYear();
            const currentYear = new Date().getFullYear();
            if (inputYear >= currentYear) {
                errors.push("Date of birth must be before the current year.");
            }
        } else {
            errors.push("Date of birth is required.");
        }

        // Validate phone: chỉ cho phép số, bắt đầu bằng 0, có 10 chữ số
        const phoneRegex = /^0\d{9}$/;
        if (!phoneRegex.test(phone)) {
            errors.push("Phone number must start with 0 and be exactly 10 digits.");
        }

        // Nếu có lỗi thì ngăn submit và báo lỗi
        if (errors.length > 0) {
            e.preventDefault();
            alert(errors.join("\n"));
        }
    });
});
