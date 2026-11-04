// Sample Products Data
const products = [
    {
        id: 1,
        name: 'AromaElite Sauvage Replica 1.1',
        category: 'Fragancia Masculina',
        basePriceCOP: 180000,
        image: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600&auto=format&fit=crop'
    },
    {
        id: 2,
        name: 'AromaElite Baccarat Rouge 1.1',
        category: 'Fragancia Unisex',
        basePriceCOP: 250000,
        image: 'https://images.unsplash.com/photo-1541643600914-78b084683601?q=80&w=600&auto=format&fit=crop'
    },
    {
        id: 3,
        name: 'AromaElite Bleu Intense 1.1',
        category: 'Fragancia Masculina',
        basePriceCOP: 195000,
        image: 'https://images.unsplash.com/photo-1594035910387-fea47794261f?q=80&w=600&auto=format&fit=crop'
    },
    {
        id: 4,
        name: 'AromaElite Good Girl Floral 1.1',
        category: 'Fragancia Femenina',
        basePriceCOP: 210000,
        image: 'https://images.unsplash.com/photo-1588405748880-12d1d2a59f75?q=80&w=600&auto=format&fit=crop'
    }
];

let cart = [];
let currentCurrency = 'COP';
let currentRate = 1;
let currentSymbol = '$';

// DOM Elements
const productGrid = document.getElementById('productGrid');
const currencySelect = document.getElementById('currencySelect');
const cartBtn = document.getElementById('cartBtn');
const cartModal = document.getElementById('cartModal');
const closeCart = document.getElementById('closeCart');
const cartItemsContainer = document.getElementById('cartItems');
const cartTotalElement = document.getElementById('cartTotal');
const cartCountElement = document.getElementById('cartCount');

// Format Price Function
function formatPrice(amountCOP) {
    const converted = amountCOP * currentRate;
    if (currentCurrency === 'COP') {
        return `${currentSymbol}${Math.round(converted).toLocaleString('es-CO')} COP`;
    }
    return `${currentSymbol}${converted.toFixed(2)} ${currentCurrency}`;
}

// Render Products
function renderProducts() {
    productGrid.innerHTML = '';
    products.forEach(product => {
        const card = document.createElement('div');
        card.classList.add('product-card');
        card.innerHTML = `
            <img src="${product.image}" alt="${product.name}" class="product-img">
            <div class="product-info">
                <span class="product-category">${product.category}</span>
                <h3 class="product-title">${product.name}</h3>
                <div class="product-price">${formatPrice(product.basePriceCOP)}</div>
                <button class="btn" onclick="addToCart(${product.id})">Añadir al Carrito</button>
            </div>
        `;
        productGrid.appendChild(card);
    });
}

// Add to Cart
function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    const existing = cart.find(item => item.id === productId);
    if (existing) {
        existing.quantity++;
    } else {
        cart.push({ ...product, quantity: 1 });
    }
    updateCartUI();
}

// Update Cart UI
function updateCartUI() {
    const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
    cartCountElement.textContent = totalItems;

    if (cart.length === 0) {
        cartItemsContainer.innerHTML = '<p class="empty-msg">El carrito está vacío.</p>';
        cartTotalElement.textContent = formatPrice(0);
        return;
    }

    cartItemsContainer.innerHTML = '';
    let totalCOP = 0;

    cart.forEach(item => {
        totalCOP += item.basePriceCOP * item.quantity;
        const itemElement = document.createElement('div');
        itemElement.classList.add('cart-item');
        itemElement.innerHTML = `
            <div>
                <h4>${item.name}</h4>
                <p>${formatPrice(item.basePriceCOP)} x ${item.quantity}</p>
            </div>
            <div>
                <strong>${formatPrice(item.basePriceCOP * item.quantity)}</strong>
            </div>
        `;
        cartItemsContainer.appendChild(itemElement);
    });

    cartTotalElement.textContent = formatPrice(totalCOP);
}

// Event Listeners
currencySelect.addEventListener('change', (e) => {
    const selectedOption = e.target.options[e.target.selectedIndex];
    currentCurrency = e.target.value;
    currentRate = parseFloat(selectedOption.getAttribute('data-rate'));
    currentSymbol = selectedOption.getAttribute('data-symbol');
    
    renderProducts();
    updateCartUI();
});

cartBtn.addEventListener('click', () => {
    cartModal.style.display = 'flex';
});

closeCart.addEventListener('click', () => {
    cartModal.style.display = 'none';
});

window.addEventListener('click', (e) => {
    if (e.target === cartModal) {
        cartModal.style.display = 'none';
    }
});

// Initial Render
renderProducts();
