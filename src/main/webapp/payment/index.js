/* eslint-disable no-undef */
const buttonContainer = document.getElementById("button-container");
const contentContainer = document.getElementById("content-container");
let isOpen = false;
let config = {
    RETURN_URL: window.location.href,
    ELEMENT_ID: "embeded-payment-container",
    CHECKOUT_URL: "",
    embedded: true,
    onSuccess: (event) => {
        contentContainer.innerHTML = `
        <div style="padding-top: 20px; padding-bottom:20px">
            Thanh toán thành công!
        </div>
    `;
        buttonContainer.innerHTML = `
        <button
            type="button"
            id="create-payment-link-btn"
            style="
            width: 100%;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px;
            font-size: 1.2em;
            border-radius: 6px;
            "
            onclick="window.location.reload()"
        >
            Quay lại trang thanh toán
        </button>
    `;
    },
};
buttonContainer.addEventListener("click", async (event) => {
    if (isOpen) {
        const { exit } = PayOSCheckout.usePayOS(config);
        exit();
        // Không cần reset contentContainer vì đã có thông tin appointment
    } else {
        const checkoutUrl = await getPaymentLink();
        config = {
            ...config,
            CHECKOUT_URL: checkoutUrl,
        };
        const { open } = PayOSCheckout.usePayOS(config);
        open();
    }
    isOpen = !isOpen;
    changeButton();
});

const getPaymentLink = async () => {
    const appointmentId = window.PAYMENT_APPOINTMENT_ID;
    const response = await fetch(
        "/benhVienLmao_war_exploded/payment",
        {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "appointmentId=" + encodeURIComponent(appointmentId)
        }
    );
    if (!response.ok) {
        alert("Không thể tạo link thanh toán!");
        return "";
    }
    const result = await response.json();
    return result.checkoutUrl;
};

const changeButton = () => {
    if (isOpen) {
        buttonContainer.innerHTML = `
        <button
            type="button"
            id="create-payment-link-btn"
            style="
            width: 100%;
            background-color: gray;
            color: white;
            border: none;
            padding: 12px;
            font-size: 1.2em;
            border-radius: 6px;
            "
        >
            Đóng link thanh toán
        </button>
      `;
    } else {
        buttonContainer.innerHTML = `
        <button
            type="button"
            id="create-payment-link-btn"
            style="
                width: 100%;
                background-color: #28a745;
                color: white;
                border: none;
                padding: 12px;
                font-size: 1.2em;
                border-radius: 6px;
            "
            >
            Tạo Link thanh toán
        </button> 
    `;
    }
};