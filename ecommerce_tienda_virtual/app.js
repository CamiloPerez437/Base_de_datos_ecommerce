// Database entities data structures (Producto, Marca, Categoría, Precio de Producto, Stock por Bodega, Impuesto por País)

// 1. Moneda & Tasa de cambio data
const monedas = {
    '1': { idMoneda: 1, codigo: 'COP', simbolo: '$', tasaVsCOP: 1.0, esBase: true },
    '2': { idMoneda: 2, codigo: 'USD', simbolo: 'USD $', tasaVsCOP: 0.00026, esBase: false },
    '3': { idMoneda: 3, codigo: 'EUR', simbolo: '€', tasaVsCOP: 0.00024, esBase: false },
    '4': { idMoneda: 4, codigo: 'MXN', simbolo: 'MX $', tasaVsCOP: 0.0045, esBase: false }
};

// 2. Impuesto por País data
const impuestosPais = {
    '1': { idPais: 1, codigo: 'CO', nombre: 'Colombia', porcentaje: 19.0 },
    '2': { idPais: 2, codigo: 'US', nombre: 'Estados Unidos', porcentaje: 7.0 },
    '3': { idPais: 3, codigo: 'ES', nombre: 'España', porcentaje: 21.0 },
    '4': { idPais: 4, codigo: 'MX', nombre: 'México', porcentaje: 16.0 }
};

// 3. Productos (Matching Producto, Marca, Categoría, Stock por Bodega, Precio)
const productosDB = [
    {
        idProducto: 1,
        skuProducto: 'PROD-ELEC-001',
        nombreProducto: 'Smartphone Pro 128GB',
        descripcionProducto: 'Pantalla OLED 6.5", cámara triple, procesador de alta eficiencia.',
        idMarca: 1,
        nombreMarca: 'TechMaster',
        idCategoria: 2, // Subcategoría Smartphones
        nombreCategoria: 'Smartphones',
        precioCOP: 2400000.00,
        cantidadStockBodega: 15,
        activoProducto: true,
        imagen: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600&auto=format&fit=crop'
    },
    {
        idProducto: 2,
        skuProducto: 'PROD-ELEC-002',
        nombreProducto: 'Laptop Ultra Slim 15"',
        descripcionProducto: 'Intel Core i7, 16GB RAM, SSD 512GB Nvme.',
        idMarca: 1,
        nombreMarca: 'TechMaster',
        idCategoria: 3, // Subcategoría Laptops
        nombreCategoria: 'Laptops',
        precioCOP: 4200000.00,
        cantidadStockBodega: 8,
        activoProducto: true,
        imagen: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=600&auto=format&fit=crop'
    },
    {
        idProducto: 3,
        skuProducto: 'PROD-MODA-001',
        nombreProducto: 'Chaqueta Urban Street Style',
        descripcionProducto: 'Corte boxy, material sintético impermeable reforzado.',
        idMarca: 2,
        nombreMarca: 'UrbanWear',
        idCategoria: 4,
        nombreCategoria: 'Moda & Calzado',
        precioCOP: 220000.00,
        cantidadStockBodega: 25,
        activoProducto: true,
        imagen: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?q=80&w=600&auto=format&fit=crop'
    },
    {
        idProducto: 4,
        skuProducto: 'PROD-MODA-002',
        nombreProducto: 'Sneakers Runner Pro',
        descripcionProducto: 'Suela ergonómica amortiguada para entrenamiento ligero.',
        idMarca: 2,
        nombreMarca: 'UrbanWear',
        idCategoria: 4,
        nombreCategoria: 'Moda & Calzado',
        precioCOP: 310000.00,
        cantidadStockBodega: 0, // Stock agotado de prueba
        activoProducto: true,
        imagen: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=600&auto=format&fit=crop'
    }
];

// App State (Carrito, Detalle de Carrito)
let carrito = [];
let selectedMonedaId = '1';
let selectedPaisId = '1';

// DOM Elements
const productGrid = document.getElementById('productGrid');
const paisSelect = document.getElementById('paisSelect');
const monedaSelect = document.getElementById('monedaSelect');
const categoriaFilter = document.getElementById('categoriaFilter');
const searchInput = document.getElementById('searchInput');
const cartBtn = document.getElementById('cartBtn');
const cartModal = document.getElementById('cartModal');
const closeCart = document.getElementById('closeCart');
const cartItemsContainer = document.getElementById('cartItems');
const checkoutForm = document.getElementById('checkoutForm');
const cartSubtotalEl = document.getElementById('cartSubtotal');
const cartImpuestosEl = document.getElementById('cartImpuestos');
const cartEnvioEl = document.getElementById('cartEnvio');
const cartTotalEl = document.getElementById('cartTotal');
const cartCountEl = document.getElementById('cartCount');
const impuestoPorcentajeEl = document.getElementById('impuestoPorcentaje');

// Currency Converter utility
function calcularPrecioFormatted(montoCOP) {
    const moneda = monedas[selectedMonedaId];
    const valorConvertido = montoCOP * moneda.tasaVsCOP;
    
    if (moneda.codigo === 'COP') {
        return `${moneda.simbolo}${Math.round(valorConvertido).toLocaleString('es-CO')} ${moneda.codigo}`;
    }
    return `${moneda.simbolo}${valorConvertido.toFixed(2)} ${moneda.codigo}`;
}

// Render Products Grid
function renderCatalog() {
    productGrid.innerHTML = '';
    const searchTerm = searchInput.value.toLowerCase();
    const categoriaId = parseInt(categoriaFilter.value);

    const productosFiltrados = productosDB.filter(p => {
        const coincideBusqueda = p.nombreProducto.toLowerCase().includes(searchTerm) || p.skuProducto.toLowerCase().includes(searchTerm);
        const coincideCategoria = categoriaId === 0 || p.idCategoria === categoriaId;
        return coincideBusqueda && coincideCategoria && p.activoProducto;
    });

    if (productosFiltrados.length === 0) {
        productGrid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #888;">No se encontraron productos que coincidan.</p>';
        return;
    }

    productosFiltrados.forEach(prod => {
        const stockTexto = prod.cantidadStockBodega > 0 
            ? `<span class="product-stock"><i class="fa-solid fa-check"></i> Stock en Bodega: ${prod.cantidadStockBodega} unds</span>` 
            : `<span class="product-stock out"><i class="fa-solid fa-xmark"></i> Agotado en Bodega</span>`;

        const card = document.createElement('div');
        card.classList.add('product-card');
        card.innerHTML = `
            <img src="${prod.imagen}" alt="${prod.nombreProducto}" class="product-img">
            <div class="product-info">
                <div class="product-meta">
                    <span>${prod.nombreMarca} / ${prod.nombreCategoria}</span>
                    <span class="product-sku">${prod.skuProducto}</span>
                </div>
                <h3 class="product-title">${prod.nombreProducto}</h3>
                <p class="product-desc">${prod.descripcionProducto}</p>
                ${stockTexto}
                <div class="product-price">${calcularPrecioFormatted(prod.precioCOP)}</div>
                <button class="btn" ${prod.cantidadStockBodega === 0 ? 'disabled style="opacity:0.5; cursor:not-allowed;"' : ''} onclick="agregarAlCarrito(${prod.idProducto})">
                    ${prod.cantidadStockBodega === 0 ? 'Sin Stock' : 'Añadir al Carrito'}
                </button>
            </div>
        `;
        productGrid.appendChild(card);
    });
}

// Add item to Carrito / Detalle de carrito
function agregarAlCarrito(idProducto) {
    const prod = productosDB.find(p => p.idProducto === idProducto);
    if (!prod || prod.cantidadStockBodega <= 0) return;

    const itemExistente = carrito.find(item => item.idProducto === idProducto);
    if (itemExistente) {
        if (itemExistente.cantidad < prod.cantidadStockBodega) {
            itemExistente.cantidad++;
        } else {
            alert('Has alcanzado el límite de stock disponible en bodega.');
        }
    } else {
        carrito.push({
            idProducto: prod.idProducto,
            nombreProducto: prod.nombreProducto,
            precioCOP: prod.precioCOP,
            cantidad: 1
        });
    }
    actualizarCarritoUI();
}

// Update Shopping Cart Modal UI (Subtotal, Impuestos, Envío, Total)
function actualizarCarritoUI() {
    const totalCantidad = carrito.reduce((sum, item) => sum + item.cantidad, 0);
    cartCountEl.textContent = totalCantidad;

    if (carrito.length === 0) {
        cartItemsContainer.innerHTML = '<p class="empty-msg">El carrito está vacío.</p>';
        checkoutForm.style.display = 'none';
        cartSubtotalEl.textContent = calcularPrecioFormatted(0);
        cartImpuestosEl.textContent = calcularPrecioFormatted(0);
        cartEnvioEl.textContent = calcularPrecioFormatted(0);
        cartTotalEl.textContent = calcularPrecioFormatted(0);
        return;
    }

    checkoutForm.style.display = 'block';
    cartItemsContainer.innerHTML = '';
    let subtotalCOP = 0;

    carrito.forEach(item => {
        const itemSubtotal = item.precioCOP * item.cantidad;
        subtotalCOP += itemSubtotal;

        const row = document.createElement('div');
        row.classList.add('cart-item');
        row.innerHTML = `
            <div>
                <strong>${item.nombreProducto}</strong>
                <p>${calcularPrecioFormatted(item.precioCOP)} x ${item.cantidad}</p>
            </div>
            <div>
                <strong>${calcularPrecioFormatted(itemSubtotal)}</strong>
            </div>
        `;
        cartItemsContainer.appendChild(row);
    });

    const impuestoInfo = impuestosPais[selectedPaisId];
    impuestoPorcentajeEl.textContent = `${impuestoInfo.porcentaje}%`;

    const impuestosCOP = subtotalCOP * (impuestoInfo.porcentaje / 100);
    const costoEnvioCOP = subtotalCOP > 0 ? 25000 : 0; // Envío fijo estimado en COP
    const totalPedidoCOP = subtotalCOP + impuestosCOP + costoEnvioCOP;

    cartSubtotalEl.textContent = calcularPrecioFormatted(subtotalCOP);
    cartImpuestosEl.textContent = calcularPrecioFormatted(impuestosCOP);
    cartEnvioEl.textContent = calcularPrecioFormatted(costoEnvioCOP);
    cartTotalEl.textContent = calcularPrecioFormatted(totalPedidoCOP);
}

// Checkout simulation aligned with Pedido, Pago, Envío logic
function procesarPedido() {
    if (carrito.length === 0) {
        alert('El carrito está vacío.');
        return;
    }

    const calle = document.getElementById('calleEnvio').value;
    const ciudad = document.getElementById('ciudadEnvio').value;
    const metodoPago = document.getElementById('metodoPagoSelect').value;

    if (!calle || !ciudad) {
        alert('Por favor completa la dirección de envío.');
        return;
    }

    alert(`¡Pedido registrado con éxito en la base de datos!

` +
          `• Estado Pedido: Pendiente / Pago Aprobado
` +
          `• Dirección: ${calle}, ${ciudad}
` +
          `• Método de Pago: ${metodoPago}
` +
          `• País Destino: ${impuestosPais[selectedPaisId].nombre}
` +
          `• Moneda: ${monedas[selectedMonedaId].codigo}`);

    carrito = [];
    cartModal.style.display = 'none';
    actualizarCarritoUI();
}

// Event Handlers
paisSelect.addEventListener('change', (e) => {
    selectedPaisId = e.target.value;
    actualizarCarritoUI();
});

monedaSelect.addEventListener('change', (e) => {
    selectedMonedaId = e.target.value;
    renderCatalog();
    actualizarCarritoUI();
});

categoriaFilter.addEventListener('change', renderCatalog);
searchInput.addEventListener('input', renderCatalog);

cartBtn.addEventListener('click', () => { cartModal.style.display = 'flex'; });
closeCart.addEventListener('click', () => { cartModal.style.display = 'none'; });
window.addEventListener('click', (e) => { if (e.target === cartModal) cartModal.style.display = 'none'; });

// Initial Execution
renderCatalog();
actualizarCarritoUI();
