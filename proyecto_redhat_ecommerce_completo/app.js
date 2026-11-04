const monedas = {
    '1': { idMoneda: 1, codigo: 'COP', simbolo: '$', tasaVsCOP: 1.0 },
    '2': { idMoneda: 2, codigo: 'USD', simbolo: 'USD $', tasaVsCOP: 0.00026 },
    '3': { idMoneda: 3, codigo: 'EUR', simbolo: '€', tasaVsCOP: 0.00024 },
    '4': { idMoneda: 4, codigo: 'MXN', simbolo: 'MX $', tasaVsCOP: 0.0045 }
};
const impuestosPais = {
    '1': { porcentaje: 19.0 },
    '2': { porcentaje: 7.0 },
    '3': { porcentaje: 21.0 },
    '4': { porcentaje: 16.0 }
};
const productosDB = [
    { idProducto: 1, skuProducto: 'PROD-ELEC-001', nombreProducto: 'Smartphone Pro 128GB', descripcionProducto: 'Pantalla OLED 6.5", cámara triple.', nombreMarca: 'TechMaster', nombreCategoria: 'Smartphones', precioCOP: 2400000.00, cantidadStockBodega: 15, activoProducto: true, imagen: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600&auto=format&fit=crop' },
    { idProducto: 2, skuProducto: 'PROD-ELEC-002', nombreProducto: 'Laptop Ultra Slim 15"', descripcionProducto: 'Intel Core i7, 16GB RAM, SSD 512GB.', nombreMarca: 'TechMaster', nombreCategoria: 'Laptops', precioCOP: 4200000.00, cantidadStockBodega: 8, activoProducto: true, imagen: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=600&auto=format&fit=crop' },
    { idProducto: 3, skuProducto: 'PROD-MODA-001', nombreProducto: 'Chaqueta Urban Street Style', descripcionProducto: 'Corte boxy, material impermeable.', nombreMarca: 'UrbanWear', nombreCategoria: 'Moda', precioCOP: 220000.00, cantidadStockBodega: 25, activoProducto: true, imagen: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=600&auto=format&fit=crop' }
];

let carrito = [];
let selectedMonedaId = '1';
let selectedPaisId = '1';

const productGrid = document.getElementById('productGrid');
const paisSelect = document.getElementById('paisSelect');
const monedaSelect = document.getElementById('monedaSelect');
const searchInput = document.getElementById('searchInput');
const cartBtn = document.getElementById('cartBtn');
const cartModal = document.getElementById('cartModal');
const closeCart = document.getElementById('closeCart');
const cartItemsContainer = document.getElementById('cartItems');
const checkoutForm = document.getElementById('checkoutForm');

function calcularPrecioFormatted(montoCOP) {
    const moneda = monedas[selectedMonedaId];
    const val = montoCOP * moneda.tasaVsCOP;
    return moneda.codigo === 'COP' ? `${moneda.simbolo}${Math.round(val).toLocaleString('es-CO')} ${moneda.codigo}` : `${moneda.simbolo}${val.toFixed(2)} ${moneda.codigo}`;
}

function renderCatalog() {
    productGrid.innerHTML = '';
    const term = searchInput.value.toLowerCase();
    productosDB.filter(p => p.nombreProducto.toLowerCase().includes(term) || p.skuProducto.toLowerCase().includes(term)).forEach(prod => {
        const card = document.createElement('div');
        card.classList.add('product-card');
        card.innerHTML = `
            <img src="${prod.imagen}" alt="${prod.nombreProducto}" class="product-img">
            <div class="product-info">
                <div class="product-meta"><span>${prod.nombreMarca}</span><span>${prod.skuProducto}</span></div>
                <h3 class="product-title">${prod.nombreProducto}</h3>
                <p class="product-desc">${prod.descripcionProducto}</p>
                <div class="product-price">${calcularPrecioFormatted(prod.precioCOP)}</div>
                <button class="btn" onclick="agregarAlCarrito(${prod.idProducto})">Añadir al Carrito</button>
            </div>
        `;
        productGrid.appendChild(card);
    });
}

function agregarAlCarrito(id) {
    const prod = productosDB.find(p => p.idProducto === id);
    const item = carrito.find(i => i.idProducto === id);
    if (item) item.cantidad++;
    else carrito.push({ idProducto: prod.idProducto, nombreProducto: prod.nombreProducto, precioCOP: prod.precioCOP, cantidad: 1 });
    actualizarCarritoUI();
}

function actualizarCarritoUI() {
    document.getElementById('cartCount').textContent = carrito.reduce((s, i) => s + i.cantidad, 0);
    if (carrito.length === 0) {
        cartItemsContainer.innerHTML = '<p class="empty-msg">El carrito está vacío.</p>';
        checkoutForm.style.display = 'none';
        return;
    }
    checkoutForm.style.display = 'block';
    cartItemsContainer.innerHTML = '';
    let subtotal = 0;
    carrito.forEach(item => {
        subtotal += item.precioCOP * item.cantidad;
        cartItemsContainer.innerHTML += `<div class="cart-item"><div><strong>${item.nombreProducto}</strong><p>${item.cantidad}x ${calcularPrecioFormatted(item.precioCOP)}</p></div><strong>${calcularPrecioFormatted(item.precioCOP * item.cantidad)}</strong></div>`;
    });
    const pct = impuestosPais[selectedPaisId].porcentaje;
    document.getElementById('impuestoPorcentaje').textContent = `${pct}%`;
    const imp = subtotal * (pct / 100);
    const env = 25000;
    document.getElementById('cartSubtotal').textContent = calcularPrecioFormatted(subtotal);
    document.getElementById('cartImpuestos').textContent = calcularPrecioFormatted(imp);
    document.getElementById('cartEnvio').textContent = calcularPrecioFormatted(env);
    document.getElementById('cartTotal').textContent = calcularPrecioFormatted(subtotal + imp + env);
}

function procesarPedido() {
    alert('¡Pedido procesado con éxito en Red Hat OpenShift!');
    carrito = [];
    cartModal.style.display = 'none';
    actualizarCarritoUI();
}

paisSelect.addEventListener('change', (e) => { selectedPaisId = e.target.value; actualizarCarritoUI(); });
monedaSelect.addEventListener('change', (e) => { selectedMonedaId = e.target.value; renderCatalog(); actualizarCarritoUI(); });
searchInput.addEventListener('input', renderCatalog);
cartBtn.addEventListener('click', () => cartModal.style.display = 'flex');
closeCart.addEventListener('click', () => cartModal.style.display = 'none');

renderCatalog();
