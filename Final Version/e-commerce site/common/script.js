let slideIndex = 0;
showSlides();

function showSlides() {
    let i;
    const slides = document.getElementsByClassName("slide");
    for (i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
    }
    slideIndex++;
    if (slideIndex > slides.length) {slideIndex = 1}
    slides[slideIndex-1].style.display = "block";
    setTimeout(showSlides, 2000);
}

function addToCart(itemName, itemPrice) {
    const quantitySelect = document.getElementById(`quantity_${itemName.replace(/\s+/g, '_').toLowerCase()}`);
    const quantity = parseInt(quantitySelect.value);
    if (quantity > 0) {
        let cart = JSON.parse(getCookie("cart") || "{}");
        if (cart[itemName]) {
            cart[itemName].quantity += quantity;
        } else {
            cart[itemName] = { quantity: quantity, price: itemPrice };
        }
        setCookie("cart", JSON.stringify(cart), 1);
        alert("Item added to cart!");
    } else {
        alert("Please select a quantity greater than 0.");
    }
}

function setCookie(name, value, days) {
    const expires = new Date(Date.now() + days * 864e5).toUTCString();
    document.cookie = `${name}=${encodeURIComponent(value)}; expires=${expires}; path=/`;
}

function getCookie(name) {
    return document.cookie.split('; ').reduce((r, v) => {
        const parts = v.split('=');
        return parts[0] === name ? decodeURIComponent(parts[1]) : r
    }, '');
}

function validateForm() {
    // Regex patterns for validation
    const namePattern = /^[a-zA-Z\s]+$/;
    const zipPattern = /^\d{5}$/;
    const cardNumberPattern = /^\d{16}$/;
    const cvvPattern = /^\d{3}$/;

    const shippingFirstName = document.getElementById('shipping-firstname').value;
    const shippingLastName = document.getElementById('shipping-lastname').value;
    const shippingEmail = document.getElementById('shipping-email').value;
    const shippingAddress = document.getElementById('shipping-address').value;
    const shippingCity = document.getElementById('shipping-city').value;
    const shippingState = document.getElementById('shipping-state').value;
    const shippingZip = document.getElementById('shipping-zip').value;

    if (!shippingFirstName.match(namePattern) || !shippingLastName.match(namePattern) || !shippingEmail || !shippingAddress || !shippingCity || !shippingState || !shippingZip.match(zipPattern)) {
        alert('Please fill out all required shipping information correctly.');
        return false;
    }

    const billingFirstName = document.getElementById('billing-firstname').value;
    const billingLastName = document.getElementById('billing-lastname').value;
    const billingEmail = document.getElementById('billing-email').value;
    const billingAddress = document.getElementById('billing-address').value;
    const billingCity = document.getElementById('billing-city').value;
    const billingState = document.getElementById('billing-state').value;
    const billingZip = document.getElementById('billing-zip').value;

    if (!billingFirstName.match(namePattern) || !billingLastName.match(namePattern) || !billingEmail || !billingAddress || !billingCity || !billingState || !billingZip.match(zipPattern)) {
        alert('Please fill out all required billing information correctly.');
        return false;
    }

    const cardNumber = document.getElementById('card-number').value;
    const cardName = document.getElementById('card-name').value;
    const expiryDate = document.getElementById('expiry-date').value;
    const cvv = document.getElementById('cvv').value;

    if (!cardNumber.match(cardNumberPattern) || !cardName.match(namePattern) || !expiryDate || !cvv.match(cvvPattern)) {
        alert('Please fill out all required payment information correctly.');
        return false;
    }

    submitCheckout();
    return true;
}

function submitCheckout() {
    const shippingFirstName = document.getElementById('shipping-firstname').value;
    const shippingLastName = document.getElementById('shipping-lastname').value;
    const shippingEmail = document.getElementById('shipping-email').value;
    const shippingAddress = document.getElementById('shipping-address').value;
    const shippingCity = document.getElementById('shipping-city').value;
    const shippingState = document.getElementById('shipping-state').value;
    const shippingZip = document.getElementById('shipping-zip').value;

    const billingFirstName = document.getElementById('billing-firstname').value;
    const billingLastName = document.getElementById('billing-lastname').value;
    const billingEmail = document.getElementById('billing-email').value;
    const billingAddress = document.getElementById('billing-address').value;
    const billingCity = document.getElementById('billing-city').value;
    const billingState = document.getElementById('billing-state').value;
    const billingZip = document.getElementById('billing-zip').value;

    const cardNumber = document.getElementById('card-number').value;
    const cardName = document.getElementById('card-name').value;
    const expiryDate = document.getElementById('expiry-date').value;
    const cvv = document.getElementById('cvv').value;

    setCookie('shipping-firstname', shippingFirstName, 1);
    setCookie('shipping-lastname', shippingLastName, 1);
    setCookie('shipping-email', shippingEmail, 1);
    setCookie('shipping-address', shippingAddress, 1);
    setCookie('shipping-city', shippingCity, 1);
    setCookie('shipping-state', shippingState, 1);
    setCookie('shipping-zip', shippingZip, 1);

    setCookie('billing-firstname', billingFirstName, 1);
    setCookie('billing-lastname', billingLastName, 1);
    setCookie('billing-email', billingEmail, 1);
    setCookie('billing-address', billingAddress, 1);
    setCookie('billing-city', billingCity, 1);
    setCookie('billing-state', billingState, 1);
    setCookie('billing-zip', billingZip, 1);

    setCookie('card-number', cardNumber, 1);
    setCookie('card-name', cardName, 1);
    setCookie('expiry-date', expiryDate, 1);
    setCookie('cvv', cvv, 1);

    //alert("Your order has been placed! Thank you for shopping with us!");
    //window.location.href = "thankyou.html";
}

