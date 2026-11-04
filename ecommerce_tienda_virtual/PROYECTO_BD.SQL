-- BASE DE DATOS: PLATAFORMA INTERNACIONAL DE COMERCIO ELECTRÓNICO
-- ======================================================================
 
CREATE DATABASE tienda_virtual;
USE tienda_virtual;
 
-- ==========================================
-- DDL: CREACIÓN DE TABLAS
-- (en orden de dependencias)
-- ==========================================
 
-- 1. País
CREATE TABLE `País` (
    idPais INT AUTO_INCREMENT,
    codigoPais VARCHAR(10) NOT NULL UNIQUE,
    nombrePais VARCHAR(100) NOT NULL,
    activoPais BOOLEAN NOT NULL,
    PRIMARY KEY (idPais)
);
 
-- 2. Idioma
CREATE TABLE Idioma (
    idIdioma INT AUTO_INCREMENT,
    codigoIdioma VARCHAR(10) NOT NULL UNIQUE,
    nombreIdioma VARCHAR(100) NOT NULL,
    activoIdioma BOOLEAN NOT NULL,
    PRIMARY KEY (idIdioma)
);
 
-- 3. Moneda
CREATE TABLE Moneda (
    idMoneda INT AUTO_INCREMENT,
    codigoMoneda VARCHAR(10) NOT NULL UNIQUE,
    nombreMoneda VARCHAR(100) NOT NULL,
    esBaseMoneda BOOLEAN NOT NULL,
    activaMoneda BOOLEAN NOT NULL,
    PRIMARY KEY (idMoneda)
);
 
-- 4. Marca
CREATE TABLE Marca (
    idMarca INT AUTO_INCREMENT,
    nombreMarca VARCHAR(100) NOT NULL,
    PRIMARY KEY (idMarca)
);
 
-- 5. Categoría
CREATE TABLE `Categoría` (
    idCategoria INT AUTO_INCREMENT,
    nombreCategoria VARCHAR(100) NOT NULL,
    idCategoriaPadre INT NULL,
    PRIMARY KEY (idCategoria),
    FOREIGN KEY (idCategoriaPadre) REFERENCES `Categoría`(idCategoria)
);
 
-- 6. Transportadora
CREATE TABLE Transportadora (
    idTransportadora INT AUTO_INCREMENT,
    nombreTransportadora VARCHAR(100) NOT NULL,
    activaTransportadora BOOLEAN NOT NULL,
    PRIMARY KEY (idTransportadora)
);
 
-- 7. Método de envío
CREATE TABLE `Método de envío` (
    idMetodoEnvio INT AUTO_INCREMENT,
    nombreMetodoEnvio VARCHAR(100) NOT NULL,
    activoMetodoEnvio BOOLEAN NOT NULL,
    PRIMARY KEY (idMetodoEnvio)
);
 
-- 8. Producto
CREATE TABLE Producto (
    idProducto INT AUTO_INCREMENT,
    skuProducto VARCHAR(50) NOT NULL UNIQUE,
    nombreProducto VARCHAR(150) NOT NULL,
    descripcionProducto TEXT NULL,
    activoProducto BOOLEAN NOT NULL,
    idMarca INT NOT NULL,
    idCategoria INT NOT NULL,
    PRIMARY KEY (idProducto),
    FOREIGN KEY (idMarca) REFERENCES Marca(idMarca),
    FOREIGN KEY (idCategoria) REFERENCES `Categoría`(idCategoria)
);
 
-- 9. Precio de producto
CREATE TABLE `Precio de producto` (
    idPrecioProducto INT AUTO_INCREMENT,
    precioProducto DECIMAL(12,2) NOT NULL,
    fechaInicioVigenciaPrecio DATE NOT NULL,
    idProducto INT NOT NULL,
    idMoneda INT NOT NULL,
    PRIMARY KEY (idPrecioProducto),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda),
    UNIQUE (idProducto, idMoneda, fechaInicioVigenciaPrecio)
);
 
-- 10. Tasa de cambio
CREATE TABLE `Tasa de cambio` (
    idTasaCambio INT AUTO_INCREMENT,
    tasaCambio DECIMAL(18,6) NOT NULL,
    fechaTasaCambio DATE NOT NULL,
    idMonedaOrigen INT NOT NULL,
    idMonedaDestino INT NOT NULL,
    PRIMARY KEY (idTasaCambio),
    FOREIGN KEY (idMonedaOrigen) REFERENCES Moneda(idMoneda),
    FOREIGN KEY (idMonedaDestino) REFERENCES Moneda(idMoneda),
    UNIQUE (idMonedaOrigen, idMonedaDestino, fechaTasaCambio)
);
 
-- 11. Impuesto por país
CREATE TABLE `Impuesto por país` (
    idImpuestoPais INT AUTO_INCREMENT,
    porcentajeImpuesto DECIMAL(5,2) NOT NULL,
    fechaInicioVigenciaImpuesto DATE NOT NULL,
    idPais INT NOT NULL,
    PRIMARY KEY (idImpuestoPais),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais),
    UNIQUE (idPais, fechaInicioVigenciaImpuesto)
);
 
-- 12. Bodega
CREATE TABLE Bodega (
    idBodega INT AUTO_INCREMENT,
    nombreBodega VARCHAR(100) NOT NULL,
    idPais INT NOT NULL,
    PRIMARY KEY (idBodega),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais)
);
 
-- 13. Stock por bodega
CREATE TABLE `Stock por bodega` (
    idStockBodega INT AUTO_INCREMENT,
    cantidadStockBodega INT NOT NULL,
    idBodega INT NOT NULL,
    idProducto INT NOT NULL,
    PRIMARY KEY (idStockBodega),
    FOREIGN KEY (idBodega) REFERENCES Bodega(idBodega),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    UNIQUE (idBodega, idProducto)
);
 
-- 14. Cobertura
CREATE TABLE Cobertura (
    idCobertura INT AUTO_INCREMENT,
    activaCobertura BOOLEAN NOT NULL,
    idTransportadora INT NOT NULL,
    idPais INT NOT NULL,
    PRIMARY KEY (idCobertura),
    FOREIGN KEY (idTransportadora) REFERENCES Transportadora(idTransportadora),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais),
    UNIQUE (idTransportadora, idPais)
);
 
-- 15. Tarifa de envío
CREATE TABLE `Tarifa de envío` (
    idTarifaEnvio INT AUTO_INCREMENT,
    costoTarifaEnvio DECIMAL(12,2) NOT NULL,
    tiempoEstimadoDiasTarifaEnvio INT NOT NULL,
    activaTarifaEnvio BOOLEAN NOT NULL,
    idCobertura INT NOT NULL,
    idMetodoEnvio INT NOT NULL,
    PRIMARY KEY (idTarifaEnvio),
    FOREIGN KEY (idCobertura) REFERENCES Cobertura(idCobertura),
    FOREIGN KEY (idMetodoEnvio) REFERENCES `Método de envío`(idMetodoEnvio),
    UNIQUE (idCobertura, idMetodoEnvio)
);
 
-- 16. Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT,
    nombreCliente VARCHAR(100) NOT NULL,
    correoCliente VARCHAR(150) NOT NULL UNIQUE,
    idPais INT NOT NULL,
    idIdioma INT NOT NULL,
    idMoneda INT NOT NULL,
    PRIMARY KEY (idCliente),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais),
    FOREIGN KEY (idIdioma) REFERENCES Idioma(idIdioma),
    FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda)
);
 
-- 17. Dirección
CREATE TABLE `Dirección` (
    idDireccion INT AUTO_INCREMENT,
    calleDireccion VARCHAR(150) NOT NULL,
    ciudadDireccion VARCHAR(100) NOT NULL,
    codigoPostalDireccion VARCHAR(20) NULL,
    esPredeterminadaDireccion BOOLEAN NOT NULL,
    activaDireccion BOOLEAN NOT NULL,
    idCliente INT NOT NULL,
    idPais INT NOT NULL,
    PRIMARY KEY (idDireccion),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais)
);
 
-- 18. Carrito
CREATE TABLE Carrito (
    idCarrito INT AUTO_INCREMENT,
    idCliente INT NOT NULL,
    PRIMARY KEY (idCarrito),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
 
-- 19. Detalle de carrito
CREATE TABLE `Detalle de carrito` (
    idDetalleCarrito INT AUTO_INCREMENT,
    cantidadDetalleCarrito INT NOT NULL,
    idCarrito INT NOT NULL,
    idProducto INT NOT NULL,
    PRIMARY KEY (idDetalleCarrito),
    FOREIGN KEY (idCarrito) REFERENCES Carrito(idCarrito),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    UNIQUE (idCarrito, idProducto)
);
 
-- 20. Pedido
-- idPagoAprobado se declara aquí y su FOREIGN KEY se agrega después con ALTER TABLE
-- (Pedido y Pago se referencian mutuamente).
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT,
    fechaPedido DATETIME NOT NULL,
    estadoPedido VARCHAR(20) NOT NULL,
    subtotalPedido DECIMAL(12,2) NOT NULL,
    porcentajeImpuestoPedido DECIMAL(5,2) NOT NULL,
    impuestosPedido DECIMAL(12,2) NOT NULL,
    costoEnvioPedido DECIMAL(12,2) NOT NULL,
    totalPedido DECIMAL(12,2) NOT NULL,
    tasaCambioPedido DECIMAL(18,6) NOT NULL,
    calleEnvioPedido VARCHAR(150) NOT NULL,
    ciudadEnvioPedido VARCHAR(100) NOT NULL,
    codigoPostalEnvioPedido VARCHAR(20) NULL,
    idCliente INT NOT NULL,
    idDireccion INT NOT NULL,
    idPais INT NOT NULL,
    idMoneda INT NOT NULL,
    idTarifaEnvio INT NOT NULL,
    idPagoAprobado INT NULL UNIQUE,
    PRIMARY KEY (idPedido),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idDireccion) REFERENCES `Dirección`(idDireccion),
    FOREIGN KEY (idPais) REFERENCES `País`(idPais),
    FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda),
    FOREIGN KEY (idTarifaEnvio) REFERENCES `Tarifa de envío`(idTarifaEnvio)
);
 
-- 21. Detalle de pedido
CREATE TABLE `Detalle de pedido` (
    idDetallePedido INT AUTO_INCREMENT,
    cantidadDetallePedido INT NOT NULL,
    precioUnitarioDetallePedido DECIMAL(12,2) NOT NULL,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,
    PRIMARY KEY (idDetallePedido),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto),
    UNIQUE (idPedido, idProducto)
);
 
-- 22. Historial de estado del pedido
CREATE TABLE `Historial de estado del pedido` (
    idHistorialEstadoPedido INT AUTO_INCREMENT,
    estadoHistorialPedido VARCHAR(20) NOT NULL,
    fechaCambioHistorialPedido DATETIME NOT NULL,
    idPedido INT NOT NULL,
    PRIMARY KEY (idHistorialEstadoPedido),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);
 
-- 23. Pago
CREATE TABLE Pago (
    idPago INT AUTO_INCREMENT,
    metodoPago VARCHAR(30) NOT NULL,
    montoPago DECIMAL(12,2) NOT NULL,
    fechaPago DATETIME NOT NULL,
    estadoPago VARCHAR(20) NOT NULL,
    ultimos4DigitosPago CHAR(4) NULL,
    idPedido INT NOT NULL,
    idMoneda INT NOT NULL,
    PRIMARY KEY (idPago),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idMoneda) REFERENCES Moneda(idMoneda)
);
 
-- 24. Envío
CREATE TABLE `Envío` (
    idEnvio INT AUTO_INCREMENT,
    numeroGuiaEnvio VARCHAR(50) NOT NULL UNIQUE,
    idPedido INT NOT NULL,
    idTransportadora INT NOT NULL,
    PRIMARY KEY (idEnvio),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idTransportadora) REFERENCES Transportadora(idTransportadora)
);
 
-- 25. Evento de envío
CREATE TABLE `Evento de envío` (
    idEventoEnvio INT AUTO_INCREMENT,
    estadoEventoEnvio VARCHAR(20) NOT NULL,
    fechaEventoEnvio DATETIME NOT NULL,
    ubicacionEventoEnvio VARCHAR(150) NOT NULL,
    idEnvio INT NOT NULL,
    PRIMARY KEY (idEventoEnvio),
    FOREIGN KEY (idEnvio) REFERENCES `Envío`(idEnvio)
);
 
-- 26. Devolución
CREATE TABLE `Devolución` (
    idDevolucion INT AUTO_INCREMENT,
    fechaSolicitudDevolucion DATETIME NOT NULL,
    estadoDevolucion VARCHAR(20) NOT NULL,
    idPedido INT NOT NULL,
    PRIMARY KEY (idDevolucion),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);
 
-- 27. Detalle de devolución
CREATE TABLE `Detalle de devolución` (
    idDetalleDevolucion INT AUTO_INCREMENT,
    cantidadDetalleDevolucion INT NOT NULL,
    motivoDetalleDevolucion VARCHAR(255) NOT NULL,
    idDevolucion INT NOT NULL,
    idDetallePedido INT NOT NULL,
    PRIMARY KEY (idDetalleDevolucion),
    FOREIGN KEY (idDevolucion) REFERENCES `Devolución`(idDevolucion),
    FOREIGN KEY (idDetallePedido) REFERENCES `Detalle de pedido`(idDetallePedido),
    UNIQUE (idDevolucion, idDetallePedido)
);
 
-- 28. Reembolso
CREATE TABLE Reembolso (
    idReembolso INT AUTO_INCREMENT,
    montoReembolso DECIMAL(12,2) NOT NULL,
    fechaReembolso DATETIME NOT NULL,
    idPago INT NOT NULL,
    idDevolucion INT NULL UNIQUE,
    PRIMARY KEY (idReembolso),
    FOREIGN KEY (idPago) REFERENCES Pago(idPago),
    FOREIGN KEY (idDevolucion) REFERENCES `Devolución`(idDevolucion)
);
 
-- 29. Movimiento de inventario
CREATE TABLE `Movimiento de inventario` (
    idMovimientoInventario INT AUTO_INCREMENT,
    tipoMovimientoInventario VARCHAR(40) NOT NULL,
    cantidadMovimientoInventario INT NOT NULL,
    fechaMovimientoInventario DATETIME NOT NULL,
    idStockBodega INT NOT NULL,
    idDetallePedido INT NOT NULL,
    idDetalleDevolucion INT NULL UNIQUE,
    PRIMARY KEY (idMovimientoInventario),
    FOREIGN KEY (idStockBodega) REFERENCES `Stock por bodega`(idStockBodega),
    FOREIGN KEY (idDetallePedido) REFERENCES `Detalle de pedido`(idDetallePedido),
    FOREIGN KEY (idDetalleDevolucion) REFERENCES `Detalle de devolución`(idDetalleDevolucion)
);
 
-- ==========================================
-- ALTER TABLE: relación circular Pedido <-> Pago
-- (Pedido.idPagoAprobado -> Pago.idPago, relación SE LIQUIDA CON)
-- ==========================================
 
ALTER TABLE Pedido
    ADD FOREIGN KEY (idPagoAprobado) REFERENCES Pago(idPago);
 
-- ==========================================
-- DML: INSERCIÓN DE DATOS
-- (en orden de dependencias)
-- ==========================================
 
-- País (8 registros)
INSERT INTO `País` (codigoPais, nombrePais, activoPais) VALUES
('CO', 'Colombia', TRUE),
('ES', 'España', TRUE),
('MX', 'México', TRUE),
('US', 'Estados Unidos', TRUE),
('AR', 'Argentina', TRUE),
('CL', 'Chile', TRUE),
('PE', 'Perú', TRUE),
('BR', 'Brasil', TRUE);
 
-- Idioma (5 registros)
INSERT INTO Idioma (codigoIdioma, nombreIdioma, activoIdioma) VALUES
('es', 'Español', TRUE),
('en', 'Inglés', TRUE),
('pt', 'Portugués', TRUE),
('fr', 'Francés', TRUE),
('de', 'Alemán', TRUE);
 
-- Moneda (5 registros)
INSERT INTO Moneda (codigoMoneda, nombreMoneda, esBaseMoneda, activaMoneda) VALUES
('USD', 'Dólar estadounidense', TRUE, TRUE),
('COP', 'Peso colombiano', FALSE, TRUE),
('EUR', 'Euro', FALSE, TRUE),
('MXN', 'Peso mexicano', FALSE, TRUE),
('BRL', 'Real brasileño', FALSE, TRUE);
 
-- Marca (10 registros)
INSERT INTO Marca (nombreMarca) VALUES
('Apple'),
('Samsung'),
('Sony'),
('Lenovo'),
('HP'),
('Dell'),
('Logitech'),
('Xiaomi'),
('JBL'),
('Asus');
 
-- Categoría (12 registros)
INSERT INTO `Categoría` (nombreCategoria, idCategoriaPadre) VALUES
('Tecnología', NULL),
('Computadores', 1),
('Celulares', 1),
('Audio', 1),
('Accesorios', 1),
('Portátiles', 2),
('Computadores de escritorio', 2),
('Smartphones', 3),
('Audífonos', 4),
('Parlantes', 4),
('Teclados y mouse', 5),
('Almacenamiento', 5);
 
-- Transportadora (5 registros)
INSERT INTO Transportadora (nombreTransportadora, activaTransportadora) VALUES
('DHL Express', TRUE),
('FedEx', TRUE),
('UPS', TRUE),
('Servientrega', TRUE),
('Correos Internacional', TRUE);
 
-- Método de envío (4 registros)
INSERT INTO `Método de envío` (nombreMetodoEnvio, activoMetodoEnvio) VALUES
('Estándar', TRUE),
('Express', TRUE),
('Económico', TRUE),
('Prioritario', TRUE);
 
-- Producto (30 registros)
INSERT INTO Producto (skuProducto, nombreProducto, descripcionProducto, activoProducto, idMarca, idCategoria) VALUES
('APL-MBA13-M3', 'MacBook Air 13" M3', 'Portátil ultradelgado con chip M3, 8 GB de RAM y 256 GB de SSD', TRUE, 1, 6),
('APL-IPH15-128', 'iPhone 15 128 GB', 'Smartphone con pantalla Super Retina XDR de 6,1 pulgadas', TRUE, 1, 8),
('APL-APP2-USBC', 'AirPods Pro (2.ª generación)', 'Audífonos inalámbricos con cancelación activa de ruido', TRUE, 1, 9),
('SAM-S24-256', 'Samsung Galaxy S24 256 GB', 'Smartphone Android con pantalla AMOLED de 6,2 pulgadas', TRUE, 2, 8),
('SAM-GB4-15', 'Samsung Galaxy Book4 15"', 'Portátil con procesador Intel Core i5 y 16 GB de RAM', TRUE, 2, 6),
('SAM-970EVO-1T', 'SSD Samsung 970 EVO Plus 1 TB', 'Unidad de estado sólido NVMe M.2', TRUE, 2, 12),
('SON-WH1000XM5', 'Sony WH-1000XM5', 'Audífonos inalámbricos con cancelación de ruido', TRUE, 3, 9),
('SON-SRSXB43', 'Parlante Sony SRS-XB43', 'Parlante Bluetooth portátil resistente al agua', TRUE, 3, 10),
('LEN-TPE14-G5', 'Lenovo ThinkPad E14', 'Portátil empresarial de 14 pulgadas con 16 GB de RAM', TRUE, 4, 6),
('LEN-IDC-AIO', 'Lenovo IdeaCentre AIO 24"', 'Computador todo en uno con pantalla Full HD', TRUE, 4, 7),
('HP-PAV15-EG', 'HP Pavilion 15', 'Portátil de 15,6 pulgadas con Intel Core i5', TRUE, 5, 6),
('HP-PAV-TP01', 'HP Pavilion Desktop TP01', 'Computador de escritorio con Ryzen 5 y 512 GB de SSD', TRUE, 5, 7),
('HP-X3000-MOUSE', 'Mouse inalámbrico HP X3000', 'Mouse óptico inalámbrico de 1200 DPI', TRUE, 5, 11),
('DEL-XPS13-9340', 'Dell XPS 13', 'Portátil premium de 13,4 pulgadas con pantalla InfinityEdge', TRUE, 6, 6),
('DEL-INS-3030', 'Dell Inspiron Desktop 3030', 'Computador de escritorio con Intel Core i5 y 8 GB de RAM', TRUE, 6, 7),
('DEL-KB216', 'Teclado Dell KB216', 'Teclado USB con cable en español', TRUE, 6, 11),
('LOG-MXM3S', 'Logitech MX Master 3S', 'Mouse ergonómico inalámbrico de alta precisión', TRUE, 7, 11),
('LOG-K380', 'Teclado Logitech K380', 'Teclado Bluetooth compacto multidispositivo', TRUE, 7, 11),
('LOG-GPROX', 'Audífonos Logitech G PRO X', 'Audífonos gamer con micrófono desmontable', TRUE, 7, 9),
('XIA-RN13-256', 'Xiaomi Redmi Note 13', 'Smartphone con pantalla AMOLED de 6,67 pulgadas', TRUE, 8, 8),
('XIA-14-512', 'Xiaomi 14 512 GB', 'Smartphone de gama alta con cámara Leica', TRUE, 8, 8),
('XIA-MB8', 'Xiaomi Smart Band 8', 'Pulsera de actividad con pantalla AMOLED', TRUE, 8, 5),
('JBL-FLIP6', 'Parlante JBL Flip 6', 'Parlante Bluetooth portátil resistente al agua IP67', TRUE, 9, 10),
('JBL-T760NC', 'Audífonos JBL Tune 760NC', 'Audífonos inalámbricos con cancelación de ruido', TRUE, 9, 9),
('JBL-CHARGE5', 'Parlante JBL Charge 5', 'Parlante portátil con batería de 20 horas', TRUE, 9, 10),
('ASU-ROG-G16', 'ASUS ROG Strix G16', 'Portátil gamer con Intel Core i7 y RTX 4060', TRUE, 10, 6),
('ASU-VIVO15', 'ASUS Vivobook 15', 'Portátil de 15,6 pulgadas con Ryzen 5', TRUE, 10, 6),
('ASU-VA24', 'Monitor ASUS VA24 24"', 'Monitor Full HD de 24 pulgadas', TRUE, 10, 5),
('SAM-T7-1T', 'SSD externo Samsung T7 1 TB', 'Unidad portátil de estado sólido USB 3.2', TRUE, 2, 12),
('SON-MDRZX110', 'Audífonos Sony MDR-ZX110', NULL, TRUE, 3, 9);
 
-- Precio de producto (40 registros)
INSERT INTO `Precio de producto` (precioProducto, fechaInicioVigenciaPrecio, idProducto, idMoneda) VALUES
(1099.00, '2026-06-01', 1, 1),
(799.00, '2026-06-01', 2, 1),
(249.00, '2026-06-01', 3, 1),
(799.99, '2026-06-01', 4, 1),
(1199.00, '2026-06-01', 5, 1),
(119.99, '2026-06-01', 6, 1),
(399.99, '2026-06-01', 7, 1),
(229.99, '2026-06-01', 8, 1),
(849.00, '2026-06-01', 9, 1),
(699.00, '2026-06-01', 10, 1),
(749.00, '2026-06-01', 11, 1),
(649.00, '2026-06-01', 12, 1),
(19.99, '2026-06-01', 13, 1),
(1299.00, '2026-06-01', 14, 1),
(599.00, '2026-06-01', 15, 1),
(24.99, '2026-06-01', 16, 1),
(99.99, '2026-06-01', 17, 1),
(39.99, '2026-06-01', 18, 1),
(129.99, '2026-06-01', 19, 1),
(249.99, '2026-06-01', 20, 1),
(699.99, '2026-06-01', 21, 1),
(39.99, '2026-06-01', 22, 1),
(129.95, '2026-06-01', 23, 1),
(99.95, '2026-06-01', 24, 1),
(179.95, '2026-06-01', 25, 1),
(1499.00, '2026-06-01', 26, 1),
(549.00, '2026-06-01', 27, 1),
(189.00, '2026-06-01', 28, 1),
(109.99, '2026-06-01', 29, 1),
(29.99, '2026-06-01', 30, 1),
(4341000.00, '2026-06-01', 1, 2),
(3156000.00, '2026-06-01', 2, 2),
(984000.00, '2026-06-01', 3, 2),
(3160000.00, '2026-06-01', 4, 2),
(4736000.00, '2026-06-01', 5, 2),
(109.99, '2026-06-01', 6, 3),
(367.99, '2026-06-01', 7, 3),
(211.99, '2026-06-01', 8, 3),
(780.99, '2026-06-01', 9, 3),
(642.99, '2026-06-01', 10, 3);
 
-- Tasa de cambio (10 registros)
INSERT INTO `Tasa de cambio` (tasaCambio, fechaTasaCambio, idMonedaOrigen, idMonedaDestino) VALUES
(3950.000000, '2026-07-01', 1, 2),
(0.920000, '2026-07-01', 1, 3),
(17.200000, '2026-07-01', 1, 4),
(5.100000, '2026-07-01', 1, 5),
(0.000253, '2026-07-01', 2, 1),
(1.086957, '2026-07-01', 3, 1),
(0.058140, '2026-07-01', 4, 1),
(0.196078, '2026-07-01', 5, 1),
(4050.250000, '2026-10-01', 1, 2),
(0.930000, '2026-10-01', 1, 3);
 
-- Impuesto por país (8 registros)
INSERT INTO `Impuesto por país` (porcentajeImpuesto, fechaInicioVigenciaImpuesto, idPais) VALUES
(19.00, '2025-01-01', 1),
(21.00, '2025-01-01', 2),
(16.00, '2025-01-01', 3),
(7.00, '2025-01-01', 4),
(21.00, '2025-01-01', 5),
(19.00, '2025-01-01', 6),
(18.00, '2025-01-01', 7),
(17.00, '2025-01-01', 8);
 
-- Bodega (5 registros)
INSERT INTO Bodega (nombreBodega, idPais) VALUES
('Bodega Bogotá', 1),
('Bodega Madrid', 2),
('Bodega Ciudad de México', 3),
('Bodega Miami', 4),
('Bodega São Paulo', 8);
 
-- Stock por bodega (50 registros)
INSERT INTO `Stock por bodega` (cantidadStockBodega, idBodega, idProducto) VALUES
(106, 1, 1),
(159, 2, 2),
(203, 3, 3),
(209, 4, 4),
(103, 5, 5),
(137, 1, 6),
(184, 2, 7),
(215, 3, 8),
(205, 4, 9),
(190, 5, 10),
(135, 1, 11),
(80, 2, 12),
(99, 3, 13),
(105, 4, 14),
(151, 5, 15),
(105, 1, 16),
(195, 2, 17),
(79, 3, 18),
(201, 4, 19),
(158, 5, 20),
(133, 1, 21),
(181, 2, 22),
(144, 3, 23),
(169, 4, 24),
(171, 5, 25),
(175, 1, 26),
(210, 2, 27),
(97, 3, 28),
(165, 4, 29),
(102, 5, 30),
(214, 2, 1),
(153, 3, 2),
(151, 4, 3),
(197, 5, 4),
(113, 1, 5),
(159, 2, 6),
(86, 3, 7),
(171, 4, 8),
(172, 5, 9),
(196, 1, 10),
(183, 2, 11),
(103, 3, 12),
(181, 4, 13),
(207, 5, 14),
(104, 1, 15),
(184, 2, 16),
(209, 3, 17),
(199, 4, 18),
(180, 5, 19),
(212, 1, 20);
 
-- Cobertura (15 registros)
INSERT INTO Cobertura (activaCobertura, idTransportadora, idPais) VALUES
(TRUE, 1, 1),
(TRUE, 1, 2),
(TRUE, 1, 3),
(TRUE, 2, 4),
(TRUE, 2, 3),
(TRUE, 2, 8),
(TRUE, 3, 4),
(TRUE, 3, 2),
(TRUE, 3, 5),
(TRUE, 4, 1),
(TRUE, 4, 6),
(TRUE, 4, 7),
(TRUE, 5, 8),
(TRUE, 5, 5),
(TRUE, 5, 6);
 
-- Tarifa de envío (20 registros)
INSERT INTO `Tarifa de envío` (costoTarifaEnvio, tiempoEstimadoDiasTarifaEnvio, activaTarifaEnvio, idCobertura, idMetodoEnvio) VALUES
(15.14, 8, TRUE, 1, 1),
(33.77, 4, TRUE, 2, 2),
(13.75, 14, TRUE, 3, 3),
(46.24, 2, TRUE, 4, 4),
(18.39, 7, TRUE, 5, 1),
(35.84, 3, TRUE, 6, 2),
(16.87, 12, TRUE, 7, 3),
(45.21, 4, TRUE, 8, 4),
(19.36, 7, TRUE, 9, 1),
(35.34, 5, TRUE, 10, 2),
(12.89, 13, TRUE, 11, 3),
(39.45, 3, TRUE, 12, 4),
(14.84, 7, TRUE, 13, 1),
(34.41, 5, TRUE, 14, 2),
(13.17, 14, TRUE, 15, 3),
(32.80, 5, TRUE, 1, 2),
(14.08, 13, TRUE, 2, 3),
(18.23, 8, TRUE, 4, 1),
(44.85, 3, TRUE, 7, 4),
(14.11, 14, TRUE, 10, 3);
 
-- Cliente (25 registros)
INSERT INTO Cliente (nombreCliente, correoCliente, idPais, idIdioma, idMoneda) VALUES
('Camila Rojas', 'camila.rojas@correo.com', 1, 1, 2),
('Santiago Gómez', 'santiago.gomez@correo.com', 1, 1, 2),
('Valentina Herrera', 'valentina.herrera@correo.com', 1, 1, 2),
('Andrés Castillo', 'andres.castillo@correo.com', 1, 1, 2),
('Daniela Moreno', 'daniela.moreno@correo.com', 1, 1, 2),
('Sebastián Ramírez', 'sebastian.ramirez@correo.com', 1, 1, 2),
('Lucía Fernández', 'lucia.fernandez@correo.com', 2, 1, 3),
('Javier Martín', 'javier.martin@correo.com', 2, 1, 3),
('Carmen Ortega', 'carmen.ortega@correo.com', 2, 4, 3),
('Pablo Navarro', 'pablo.navarro@correo.com', 2, 5, 3),
('Ximena Torres', 'ximena.torres@correo.com', 3, 1, 4),
('Diego Hernández', 'diego.hernandez@correo.com', 3, 1, 4),
('Fernanda Ruiz', 'fernanda.ruiz@correo.com', 3, 1, 4),
('Luis Mendoza', 'luis.mendoza@correo.com', 3, 1, 4),
('Emily Johnson', 'emily.johnson@correo.com', 4, 2, 1),
('Michael Brown', 'michael.brown@correo.com', 4, 2, 1),
('Sarah Davis', 'sarah.davis@correo.com', 4, 2, 1),
('Daniel Wilson', 'daniel.wilson@correo.com', 4, 2, 1),
('Martina López', 'martina.lopez@correo.com', 5, 1, 1),
('Facundo Sosa', 'facundo.sosa@correo.com', 5, 1, 1),
('Isidora Soto', 'isidora.soto@correo.com', 6, 1, 1),
('Matías Vargas', 'matias.vargas@correo.com', 6, 1, 1),
('Alejandra Quispe', 'alejandra.quispe@correo.com', 7, 1, 1),
('Gabriel Silva', 'gabriel.silva@correo.com', 8, 3, 5),
('Beatriz Oliveira', 'beatriz.oliveira@correo.com', 8, 3, 5);
 
-- Dirección (35 registros)
INSERT INTO `Dirección` (calleDireccion, ciudadDireccion, codigoPostalDireccion, esPredeterminadaDireccion, activaDireccion, idCliente, idPais) VALUES
('Calle 138 # 62-52', 'Barranquilla', '312369', TRUE, TRUE, 1, 1),
('Calle 85 # 35-2', 'Bogotá', '257122', TRUE, TRUE, 2, 1),
('Calle 127 # 67-63', 'Cali', '309544', TRUE, TRUE, 3, 1),
('Calle 76 # 63-60', 'Barranquilla', '947206', TRUE, TRUE, 4, 1),
('Calle 121 # 5-38', 'Cali', '579886', TRUE, TRUE, 5, 1),
('Calle 35 # 57-89', 'Cali', '574921', TRUE, TRUE, 6, 1),
('Calle de Alcalá 55', 'Sevilla', '18427', TRUE, TRUE, 7, 2),
('Calle Gran Vía 116', 'Sevilla', '58513', TRUE, TRUE, 8, 2),
('Calle Mayor 25', 'Sevilla', '29183', TRUE, TRUE, 9, 2),
('Calle del Prado 118', 'Madrid', '22080', TRUE, TRUE, 10, 2),
('Av. Insurgentes 1858', 'Ciudad de México', '89971', TRUE, TRUE, 11, 3),
('Av. Reforma 1025', 'Ciudad de México', '91405', TRUE, TRUE, 12, 3),
('Av. Insurgentes 2248', 'Monterrey', '97618', TRUE, TRUE, 13, 3),
('Av. Juárez 643', 'Ciudad de México', '51083', TRUE, TRUE, 14, 3),
('9652 Biscayne Blvd', 'Houston', '81539', TRUE, TRUE, 15, 4),
('3752 Biscayne Blvd', 'Houston', '88398', TRUE, TRUE, 16, 4),
('8369 Maple Dr', 'Miami', '64759', TRUE, TRUE, 17, 4),
('2723 Oak Ave', 'Chicago', '76545', TRUE, TRUE, 18, 4),
('Av. Santa Fe 1699', 'Buenos Aires', NULL, TRUE, TRUE, 19, 5),
('Av. Rivadavia 3405', 'Buenos Aires', NULL, TRUE, TRUE, 20, 5),
('Av. Apoquindo 157', 'Santiago', NULL, TRUE, TRUE, 21, 6),
('Av. Apoquindo 400', 'Santiago', NULL, TRUE, TRUE, 22, 6),
('Av. Javier Prado 1547', 'Lima', NULL, TRUE, TRUE, 23, 7),
('Rua Augusta 1055', 'Río de Janeiro', '52960-699', TRUE, TRUE, 24, 8),
('Rua das Flores 931', 'Río de Janeiro', '25908-509', TRUE, TRUE, 25, 8),
('Calle 129 # 22-20', 'Medellín', '554670', FALSE, TRUE, 1, 1),
('Calle 96 # 59-77', 'Medellín', '811457', FALSE, TRUE, 2, 1),
('Calle 27 # 52-5', 'Medellín', '778670', FALSE, FALSE, 4, 1),
('Calle 54 # 6-83', 'Bogotá', '573768', FALSE, TRUE, 6, 1),
('Calle de Alcalá 62', 'Madrid', '26926', FALSE, TRUE, 8, 2),
('Calle de Serrano 28', 'Barcelona', '31022', FALSE, TRUE, 10, 2),
('Av. Reforma 1607', 'Monterrey', '65752', FALSE, FALSE, 12, 3),
('8832 Biscayne Blvd', 'Miami', '60224', FALSE, TRUE, 15, 4),
('5095 Oak Ave', 'Chicago', '32897', FALSE, TRUE, 18, 4),
('Av. Apoquindo 2000', 'Valparaíso', NULL, FALSE, FALSE, 21, 6);
 
-- Carrito (15 registros)
INSERT INTO Carrito (idCliente) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15);
 
-- Detalle de carrito (30 registros)
INSERT INTO `Detalle de carrito` (cantidadDetalleCarrito, idCarrito, idProducto) VALUES
(2, 1, 25),
(2, 1, 27),
(2, 2, 15),
(3, 2, 6),
(1, 3, 16),
(3, 3, 15),
(2, 4, 26),
(1, 4, 17),
(1, 5, 28),
(1, 5, 7),
(2, 6, 3),
(3, 6, 29),
(3, 7, 11),
(3, 7, 14),
(2, 8, 6),
(1, 8, 1),
(3, 9, 12),
(3, 9, 18),
(1, 10, 26),
(1, 10, 18),
(2, 11, 20),
(3, 11, 23),
(3, 12, 25),
(1, 12, 19),
(3, 13, 19),
(2, 13, 10),
(1, 14, 22),
(1, 14, 18),
(1, 15, 26),
(2, 15, 9);
 
-- Pedido (30 registros)
INSERT INTO Pedido (fechaPedido, estadoPedido, subtotalPedido, porcentajeImpuestoPedido, impuestosPedido, costoEnvioPedido, totalPedido, tasaCambioPedido, calleEnvioPedido, ciudadEnvioPedido, codigoPostalEnvioPedido, idCliente, idDireccion, idPais, idMoneda, idTarifaEnvio) VALUES
('2026-07-06 11:06:00', 'entregado', 2316.55, 21.00, 486.48, 31.07, 2834.10, 0.920000, 'Calle de Alcalá 62', 'Madrid', '26926', 8, 30, 2, 3, 2),
('2026-07-11 09:48:00', 'cancelado', 219.98, 19.00, 41.80, 13.17, 274.95, 1.000000, 'Av. Apoquindo 400', 'Santiago', NULL, 22, 22, 6, 1, 15),
('2026-07-16 14:46:00', 'entregado', 24663800.00, 19.00, 4686122.00, 139593.00, 29489515.00, 3950.000000, 'Calle 127 # 67-63', 'Cali', '309544', 3, 3, 1, 2, 10),
('2026-07-21 11:41:00', 'cancelado', 10709.85, 17.00, 1820.67, 182.78, 12713.30, 5.100000, 'Rua Augusta 1055', 'Río de Janeiro', '52960-699', 24, 24, 8, 5, 6),
('2026-07-26 10:32:00', 'entregado', 15590.60, 17.00, 2650.40, 75.68, 18316.68, 5.100000, 'Rua das Flores 931', 'Río de Janeiro', '25908-509', 25, 25, 8, 5, 13),
('2026-07-31 14:17:00', 'cancelado', 259.90, 21.00, 54.58, 34.41, 348.89, 1.000000, 'Av. Santa Fe 1699', 'Buenos Aires', NULL, 19, 19, 5, 1, 14),
('2026-08-05 18:53:00', 'entregado', 10573992.00, 19.00, 2009058.48, 129560.00, 12712610.48, 3950.000000, 'Calle 121 # 5-38', 'Cali', '579886', 5, 5, 1, 2, 16),
('2026-08-10 10:18:00', 'entregado', 4705.99, 7.00, 329.42, 16.87, 5052.28, 1.000000, '8369 Maple Dr', 'Miami', '64759', 17, 17, 4, 1, 7),
('2026-08-15 14:10:00', 'cancelado', 1947.00, 7.00, 136.29, 18.23, 2101.52, 1.000000, '9652 Biscayne Blvd', 'Houston', '81539', 15, 15, 4, 1, 18),
('2026-08-20 13:16:00', 'cancelado', 119.55, 21.00, 25.11, 31.07, 175.73, 0.920000, 'Calle Mayor 25', 'Sevilla', '29183', 9, 9, 2, 3, 2),
('2026-08-25 10:00:00', 'entregado', 3335.97, 19.00, 633.83, 12.89, 3982.69, 1.000000, 'Av. Apoquindo 157', 'Santiago', NULL, 21, 21, 6, 1, 11),
('2026-08-30 15:55:00', 'cancelado', 2398.00, 7.00, 167.86, 46.24, 2612.10, 1.000000, '3752 Biscayne Blvd', 'Houston', '88398', 16, 16, 4, 1, 4),
('2026-09-04 13:26:00', 'entregado', 11288902.50, 19.00, 2144891.48, 129560.00, 13563353.98, 3950.000000, 'Calle 54 # 6-83', 'Bogotá', '573768', 6, 29, 1, 2, 16),
('2026-09-09 09:03:00', 'cancelado', 18.39, 21.00, 3.86, 31.07, 53.32, 0.920000, 'Calle de Alcalá 55', 'Sevilla', '18427', 7, 7, 2, 3, 2),
('2026-09-14 10:15:00', 'cancelado', 44685.60, 16.00, 7149.70, 316.31, 52151.61, 17.200000, 'Av. Insurgentes 2248', 'Monterrey', '97618', 13, 13, 3, 4, 5),
('2026-10-01 09:19:00', 'enviado', 3134.97, 7.00, 219.45, 46.24, 3400.66, 1.000000, '2723 Oak Ave', 'Chicago', '76545', 18, 18, 4, 1, 4),
('2026-10-03 10:06:00', 'pagado', 8035274.50, 19.00, 1526702.16, 143135.84, 9705112.50, 4050.250000, 'Calle 76 # 63-60', 'Barranquilla', '947206', 4, 4, 1, 2, 10),
('2026-10-05 17:36:00', 'pendiente', 24.99, 21.00, 5.25, 19.36, 49.60, 1.000000, 'Av. Rivadavia 3405', 'Buenos Aires', NULL, 20, 20, 5, 1, 9),
('2026-10-07 14:20:00', 'enviado', 78999.60, 16.00, 12639.94, 316.31, 91955.85, 17.200000, 'Av. Insurgentes 1858', 'Ciudad de México', '89971', 11, 11, 3, 4, 5),
('2026-10-09 16:38:00', 'pagado', 1744.68, 21.00, 366.38, 13.09, 2124.15, 0.930000, 'Calle de Serrano 28', 'Barcelona', '31022', 10, 31, 2, 3, 17),
('2026-10-11 18:02:00', 'pendiente', 1863034.00, 19.00, 353976.46, 143135.84, 2360146.30, 4050.250000, 'Calle 138 # 62-52', 'Barranquilla', '312369', 1, 1, 1, 2, 10),
('2026-10-13 15:20:00', 'pagado', 66340.06, 16.00, 10614.41, 316.31, 77270.78, 17.200000, 'Av. Juárez 643', 'Ciudad de México', '51083', 14, 14, 3, 4, 5),
('2026-10-15 18:13:00', 'enviado', 3377.93, 18.00, 608.03, 39.45, 4025.41, 1.000000, 'Av. Javier Prado 1547', 'Lima', NULL, 23, 23, 7, 1, 12),
('2026-10-17 18:29:00', 'pendiente', 161929.00, 19.00, 30766.51, 132848.20, 325543.71, 4050.250000, 'Calle 96 # 59-77', 'Medellín', '811457', 2, 27, 1, 2, 16),
('2026-10-19 15:43:00', 'pagado', 39937.89, 16.00, 6390.06, 316.31, 46644.26, 17.200000, 'Av. Reforma 1025', 'Ciudad de México', '91405', 12, 12, 3, 4, 5),
('2026-10-21 10:43:00', 'pendiente', 3033637.25, 19.00, 576391.08, 57149.03, 3667177.36, 4050.250000, 'Calle 76 # 63-60', 'Barranquilla', '947206', 4, 4, 1, 2, 20),
('2026-10-23 14:55:00', 'enviado', 11820983.00, 19.00, 2245986.77, 143135.84, 14210105.61, 4050.250000, 'Calle 96 # 59-77', 'Medellín', '811457', 2, 27, 1, 2, 10),
('2026-10-25 17:43:00', 'pagado', 5301696.25, 19.00, 1007322.29, 61320.79, 6370339.33, 4050.250000, 'Calle 121 # 5-38', 'Cali', '579886', 5, 5, 1, 2, 1),
('2026-10-27 13:24:00', 'pendiente', 499.98, 7.00, 35.00, 44.85, 579.83, 1.000000, '8369 Maple Dr', 'Miami', '64759', 17, 17, 4, 1, 19),
('2026-10-29 13:52:00', 'pendiente', 37805.60, 16.00, 6048.90, 236.50, 44091.00, 17.200000, 'Av. Reforma 1025', 'Ciudad de México', '91405', 12, 12, 3, 4, 3);
 
-- Detalle de pedido (60 registros)
INSERT INTO `Detalle de pedido` (cantidadDetallePedido, precioUnitarioDetallePedido, idPedido, idProducto) VALUES
(1, 1103.08, 1, 5),
(1, 18.39, 1, 13),
(1, 1195.08, 1, 14),
(2, 109.99, 2, 29),
(1, 3353550.00, 3, 9),
(3, 5131050.00, 3, 14),
(2, 2958550.00, 3, 11),
(3, 3569.95, 4, 21),
(2, 3819.90, 5, 11),
(1, 5604.90, 5, 1),
(2, 1172.95, 5, 8),
(2, 129.95, 6, 23),
(2, 1579960.50, 7, 7),
(3, 2366050.00, 7, 15),
(2, 157960.50, 7, 18),
(2, 1199.00, 8, 5),
(2, 1099.00, 8, 1),
(1, 109.99, 8, 29),
(3, 649.00, 9, 12),
(1, 119.55, 10, 23),
(3, 129.99, 11, 19),
(3, 799.00, 11, 2),
(1, 549.00, 11, 27),
(2, 1199.00, 12, 5),
(2, 513460.50, 13, 19),
(3, 1579960.50, 13, 7),
(2, 2761050.00, 13, 10),
(1, 18.39, 14, 13),
(2, 22342.80, 15, 14),
(2, 39.99, 16, 18),
(2, 1099.00, 16, 1),
(1, 109.99, 16, 29),
(3, 249.00, 16, 3),
(2, 3033637.25, 17, 11),
(2, 984000.00, 17, 3),
(1, 24.99, 18, 16),
(2, 10302.80, 19, 15),
(1, 25782.80, 19, 26),
(2, 4282.80, 19, 3),
(2, 12022.80, 19, 10),
(2, 696.57, 20, 11),
(2, 175.77, 20, 28),
(2, 931517.00, 21, 8),
(2, 2235.83, 22, 19),
(3, 20622.80, 22, 5),
(2, 799.99, 23, 4),
(2, 599.00, 23, 15),
(3, 39.99, 23, 18),
(2, 229.99, 23, 8),
(2, 80964.50, 24, 13),
(3, 12882.80, 25, 11),
(3, 429.83, 25, 16),
(1, 3033637.25, 26, 11),
(2, 161969.50, 27, 18),
(2, 4736000.00, 27, 5),
(2, 1012522.00, 27, 20),
(2, 931517.00, 28, 8),
(1, 3438662.25, 28, 9),
(2, 249.99, 29, 20),
(2, 18902.80, 30, 1);
 
-- Historial de estado del pedido (75 registros)
INSERT INTO `Historial de estado del pedido` (estadoHistorialPedido, fechaCambioHistorialPedido, idPedido) VALUES
('pendiente', '2026-07-06 11:06:00', 1),
('pagado', '2026-07-06 14:38:58', 1),
('enviado', '2026-07-08 20:38:58', 1),
('entregado', '2026-07-16 18:38:58', 1),
('pendiente', '2026-07-11 09:48:00', 2),
('cancelado', '2026-07-12 14:48:00', 2),
('pendiente', '2026-07-16 14:46:00', 3),
('pagado', '2026-07-16 17:24:16', 3),
('enviado', '2026-07-17 18:24:16', 3),
('entregado', '2026-07-24 02:24:16', 3),
('pendiente', '2026-07-21 11:41:00', 4),
('pagado', '2026-07-21 14:01:02', 4),
('cancelado', '2026-07-22 17:01:02', 4),
('pendiente', '2026-07-26 10:32:00', 5),
('pagado', '2026-07-26 14:03:01', 5),
('enviado', '2026-07-28 18:03:01', 5),
('entregado', '2026-08-04 02:03:01', 5),
('pendiente', '2026-07-31 14:17:00', 6),
('cancelado', '2026-08-01 18:17:00', 6),
('pendiente', '2026-08-05 18:53:00', 7),
('pagado', '2026-08-05 21:05:17', 7),
('enviado', '2026-08-09 03:05:17', 7),
('entregado', '2026-08-16 10:05:17', 7),
('pendiente', '2026-08-10 10:18:00', 8),
('pagado', '2026-08-10 13:43:13', 8),
('enviado', '2026-08-11 19:43:13', 8),
('entregado', '2026-08-18 02:43:13', 8),
('pendiente', '2026-08-15 14:10:00', 9),
('cancelado', '2026-08-16 17:10:00', 9),
('pendiente', '2026-08-20 13:16:00', 10),
('pagado', '2026-08-20 14:48:34', 10),
('cancelado', '2026-08-21 18:48:34', 10),
('pendiente', '2026-08-25 10:00:00', 11),
('pagado', '2026-08-25 12:30:05', 11),
('enviado', '2026-08-26 13:30:05', 11),
('entregado', '2026-09-01 14:30:05', 11),
('pendiente', '2026-08-30 15:55:00', 12),
('cancelado', '2026-08-31 18:55:00', 12),
('pendiente', '2026-09-04 13:26:00', 13),
('pagado', '2026-09-04 15:57:42', 13),
('enviado', '2026-09-05 19:57:42', 13),
('entregado', '2026-09-13 04:57:42', 13),
('pendiente', '2026-09-09 09:03:00', 14),
('pagado', '2026-09-09 11:26:04', 14),
('cancelado', '2026-09-10 16:26:04', 14),
('pendiente', '2026-09-14 10:15:00', 15),
('cancelado', '2026-09-15 10:15:00', 15),
('pendiente', '2026-10-01 09:19:00', 16),
('pagado', '2026-10-01 11:59:59', 16),
('enviado', '2026-10-03 15:59:59', 16),
('pendiente', '2026-10-03 10:06:00', 17),
('pagado', '2026-10-03 11:49:54', 17),
('pendiente', '2026-10-05 17:36:00', 18),
('pendiente', '2026-10-07 14:20:00', 19),
('pagado', '2026-10-07 16:51:35', 19),
('enviado', '2026-10-09 18:51:35', 19),
('pendiente', '2026-10-09 16:38:00', 20),
('pagado', '2026-10-09 20:55:34', 20),
('pendiente', '2026-10-11 18:02:00', 21),
('pendiente', '2026-10-13 15:20:00', 22),
('pagado', '2026-10-13 18:46:50', 22),
('pendiente', '2026-10-15 18:13:00', 23),
('pagado', '2026-10-15 20:24:17', 23),
('enviado', '2026-10-19 02:24:17', 23),
('pendiente', '2026-10-17 18:29:00', 24),
('pendiente', '2026-10-19 15:43:00', 25),
('pagado', '2026-10-19 17:18:41', 25),
('pendiente', '2026-10-21 10:43:00', 26),
('pendiente', '2026-10-23 14:55:00', 27),
('pagado', '2026-10-23 17:09:23', 27),
('enviado', '2026-10-24 22:09:23', 27),
('pendiente', '2026-10-25 17:43:00', 28),
('pagado', '2026-10-25 19:52:45', 28),
('pendiente', '2026-10-27 13:24:00', 29),
('pendiente', '2026-10-29 13:52:00', 30);
 
-- Pago (35 registros)
INSERT INTO Pago (metodoPago, montoPago, fechaPago, estadoPago, ultimos4DigitosPago, idPedido, idMoneda) VALUES
('tarjeta', 2834.10, '2026-07-06 14:38:58', 'aprobado', '8713', 1, 3),
('transferencia', 274.95, '2026-07-11 10:24:22', 'rechazado', NULL, 2, 1),
('transferencia', 29489515.00, '2026-07-16 17:24:16', 'aprobado', NULL, 3, 2),
('transferencia', 12713.30, '2026-07-21 14:01:02', 'reembolsado', NULL, 4, 5),
('tarjeta', 18316.68, '2026-07-26 14:03:01', 'aprobado', '8875', 5, 5),
('transferencia', 348.89, '2026-07-31 14:55:53', 'rechazado', NULL, 6, 1),
('transferencia', 12712610.48, '2026-08-05 21:05:17', 'aprobado', NULL, 7, 2),
('transferencia', 5052.28, '2026-08-10 13:43:13', 'aprobado', NULL, 8, 1),
('transferencia', 2101.52, '2026-08-15 14:28:55', 'rechazado', NULL, 9, 1),
('billetera digital', 175.73, '2026-08-20 14:48:34', 'reembolsado', NULL, 10, 3),
('billetera digital', 3982.69, '2026-08-25 12:30:05', 'aprobado', NULL, 11, 1),
('billetera digital', 2612.10, '2026-08-30 16:42:38', 'rechazado', NULL, 12, 1),
('transferencia', 13563353.98, '2026-09-04 15:57:42', 'aprobado', NULL, 13, 2),
('tarjeta', 53.32, '2026-09-09 11:26:04', 'reembolsado', '3856', 14, 3),
('billetera digital', 52151.61, '2026-09-14 10:46:33', 'rechazado', NULL, 15, 4),
('tarjeta', 3400.66, '2026-10-01 11:59:59', 'aprobado', '4519', 16, 1),
('transferencia', 9705112.50, '2026-10-03 10:22:15', 'rechazado', NULL, 17, 2),
('billetera digital', 9705112.50, '2026-10-03 11:49:54', 'aprobado', NULL, 17, 2),
('tarjeta', 49.60, '2026-10-05 18:24:32', 'rechazado', '4461', 18, 1),
('tarjeta', 91955.85, '2026-10-07 16:51:35', 'aprobado', '6337', 19, 4),
('billetera digital', 2124.15, '2026-10-09 17:16:25', 'rechazado', NULL, 20, 3),
('billetera digital', 2124.15, '2026-10-09 20:55:34', 'aprobado', NULL, 20, 3),
('tarjeta', 2360146.30, '2026-10-11 18:29:38', 'rechazado', '3508', 21, 2),
('tarjeta', 77270.78, '2026-10-13 15:44:51', 'rechazado', '2000', 22, 4),
('transferencia', 77270.78, '2026-10-13 18:46:50', 'aprobado', NULL, 22, 4),
('tarjeta', 4025.41, '2026-10-15 20:24:17', 'aprobado', '9852', 23, 1),
('tarjeta', 325543.71, '2026-10-17 19:06:29', 'rechazado', '3757', 24, 2),
('billetera digital', 46644.26, '2026-10-19 16:09:03', 'rechazado', NULL, 25, 4),
('transferencia', 46644.26, '2026-10-19 17:18:41', 'aprobado', NULL, 25, 4),
('billetera digital', 3667177.36, '2026-10-21 11:29:01', 'rechazado', NULL, 26, 2),
('billetera digital', 14210105.61, '2026-10-23 17:09:23', 'aprobado', NULL, 27, 2),
('tarjeta', 6370339.33, '2026-10-25 18:32:29', 'rechazado', '7664', 28, 2),
('tarjeta', 6370339.33, '2026-10-25 19:52:45', 'aprobado', '9326', 28, 2),
('transferencia', 579.83, '2026-10-27 13:41:00', 'rechazado', NULL, 29, 1),
('tarjeta', 44091.00, '2026-10-29 14:10:22', 'rechazado', '5214', 30, 4);
 
-- Se asigna el pago aprobado de cada pedido (relación SE LIQUIDA CON)
UPDATE Pedido SET idPagoAprobado = 1 WHERE idPedido = 1;
UPDATE Pedido SET idPagoAprobado = 3 WHERE idPedido = 3;
UPDATE Pedido SET idPagoAprobado = 4 WHERE idPedido = 4;
UPDATE Pedido SET idPagoAprobado = 5 WHERE idPedido = 5;
UPDATE Pedido SET idPagoAprobado = 7 WHERE idPedido = 7;
UPDATE Pedido SET idPagoAprobado = 8 WHERE idPedido = 8;
UPDATE Pedido SET idPagoAprobado = 10 WHERE idPedido = 10;
UPDATE Pedido SET idPagoAprobado = 11 WHERE idPedido = 11;
UPDATE Pedido SET idPagoAprobado = 13 WHERE idPedido = 13;
UPDATE Pedido SET idPagoAprobado = 14 WHERE idPedido = 14;
UPDATE Pedido SET idPagoAprobado = 16 WHERE idPedido = 16;
UPDATE Pedido SET idPagoAprobado = 18 WHERE idPedido = 17;
UPDATE Pedido SET idPagoAprobado = 20 WHERE idPedido = 19;
UPDATE Pedido SET idPagoAprobado = 22 WHERE idPedido = 20;
UPDATE Pedido SET idPagoAprobado = 25 WHERE idPedido = 22;
UPDATE Pedido SET idPagoAprobado = 26 WHERE idPedido = 23;
UPDATE Pedido SET idPagoAprobado = 29 WHERE idPedido = 25;
UPDATE Pedido SET idPagoAprobado = 31 WHERE idPedido = 27;
UPDATE Pedido SET idPagoAprobado = 33 WHERE idPedido = 28;
 
-- Envío (35 registros)
INSERT INTO `Envío` (numeroGuiaEnvio, idPedido, idTransportadora) VALUES
('DHL2831663233', 1, 1),
('1Z8971331159', 1, 3),
('1Z3528667534', 1, 3),
('DHL6360824456', 3, 1),
('DHL7874572128', 3, 1),
('SER7699085417', 3, 4),
('FDX4401901879', 5, 2),
('FDX6979780252', 5, 2),
('FDX6128400198', 5, 2),
('SER2473573638', 7, 4),
('SER7807360872', 7, 4),
('SER6073927319', 7, 4),
('1Z4690598281', 8, 3),
('FDX3304284514', 8, 2),
('1Z3918276116', 8, 3),
('SER7805780370', 11, 4),
('COR1214304907', 11, 5),
('SER8288983708', 11, 4),
('SER7130066817', 13, 4),
('DHL0512983725', 13, 1),
('DHL2328385642', 13, 1),
('FDX2061769585', 16, 2),
('FDX9871120984', 16, 2),
('FDX4800527913', 16, 2),
('FDX9043163499', 16, 2),
('DHL7942607911', 19, 1),
('FDX7452198033', 19, 2),
('DHL5716477447', 19, 1),
('SER3521362958', 23, 4),
('SER3984886457', 23, 4),
('SER7094098584', 23, 4),
('SER8409342692', 23, 4),
('SER9855683068', 27, 4),
('DHL2796726835', 27, 1),
('SER6953896501', 27, 4);
 
-- Evento de envío (80 registros)
INSERT INTO `Evento de envío` (estadoEventoEnvio, fechaEventoEnvio, ubicacionEventoEnvio, idEnvio) VALUES
('despachado', '2026-07-08 20:38:58', 'Miami, Estados Unidos', 1),
('en tránsito', '2026-07-09 23:38:58', 'Centro logístico de Madrid', 1),
('entregado', '2026-07-14 00:38:58', 'Madrid, España', 1),
('despachado', '2026-07-09 06:38:58', 'Bogotá, Colombia', 2),
('entregado', '2026-07-12 07:38:58', 'Madrid, España', 2),
('despachado', '2026-07-10 12:38:58', 'Ciudad de México, México', 3),
('en tránsito', '2026-07-11 14:38:58', 'Centro logístico de Madrid', 3),
('entregado', '2026-07-16 18:38:58', 'Madrid, España', 3),
('despachado', '2026-07-17 18:24:16', 'Bogotá, Colombia', 4),
('entregado', '2026-07-20 21:24:16', 'Cali, Colombia', 4),
('despachado', '2026-07-18 08:24:16', 'São Paulo, Brasil', 5),
('en tránsito', '2026-07-19 15:24:16', 'Centro logístico de Cali', 5),
('entregado', '2026-07-23 10:24:16', 'Cali, Colombia', 5),
('despachado', '2026-07-18 23:24:16', 'Bogotá, Colombia', 6),
('en tránsito', '2026-07-20 00:24:16', 'Centro logístico de Cali', 6),
('entregado', '2026-07-24 02:24:16', 'Cali, Colombia', 6),
('despachado', '2026-07-28 18:03:01', 'Madrid, España', 7),
('en tránsito', '2026-07-30 01:03:01', 'Centro logístico de Río de Janeiro', 7),
('entregado', '2026-08-03 19:03:01', 'Río de Janeiro, Brasil', 7),
('despachado', '2026-07-28 19:03:01', 'São Paulo, Brasil', 8),
('en tránsito', '2026-07-30 01:03:01', 'Centro logístico de Río de Janeiro', 8),
('entregado', '2026-08-01 20:03:01', 'Río de Janeiro, Brasil', 8),
('despachado', '2026-07-29 01:03:01', 'Bogotá, Colombia', 9),
('en tránsito', '2026-07-30 08:03:01', 'Centro logístico de Río de Janeiro', 9),
('entregado', '2026-08-04 02:03:01', 'Río de Janeiro, Brasil', 9),
('despachado', '2026-08-09 03:05:17', 'Miami, Estados Unidos', 10),
('en tránsito', '2026-08-10 10:05:17', 'Centro logístico de Cali', 10),
('entregado', '2026-08-12 10:05:17', 'Cali, Colombia', 10),
('despachado', '2026-08-09 21:05:17', 'Miami, Estados Unidos', 11),
('en tránsito', '2026-08-11 02:05:17', 'Centro logístico de Cali', 11),
('entregado', '2026-08-12 21:05:17', 'Cali, Colombia', 11),
('despachado', '2026-08-10 09:05:17', 'Miami, Estados Unidos', 12),
('en tránsito', '2026-08-11 11:05:17', 'Centro logístico de Cali', 12),
('entregado', '2026-08-16 10:05:17', 'Cali, Colombia', 12),
('despachado', '2026-08-11 19:43:13', 'Ciudad de México, México', 13),
('en tránsito', '2026-08-13 03:43:13', 'Centro logístico de Miami', 13),
('entregado', '2026-08-16 01:43:13', 'Miami, Estados Unidos', 13),
('despachado', '2026-08-12 05:43:13', 'Bogotá, Colombia', 14),
('en tránsito', '2026-08-13 10:43:13', 'Centro logístico de Miami', 14),
('entregado', '2026-08-16 05:43:13', 'Miami, Estados Unidos', 14),
('despachado', '2026-08-12 20:43:13', 'Madrid, España', 15),
('en tránsito', '2026-08-14 00:43:13', 'Centro logístico de Miami', 15),
('entregado', '2026-08-18 02:43:13', 'Miami, Estados Unidos', 15),
('despachado', '2026-08-26 13:30:05', 'Bogotá, Colombia', 16),
('en tránsito', '2026-08-27 16:30:05', 'Centro logístico de Santiago', 16),
('entregado', '2026-08-31 14:30:05', 'Santiago, Chile', 16),
('despachado', '2026-08-27 05:30:05', 'Miami, Estados Unidos', 17),
('en tránsito', '2026-08-28 06:30:05', 'Centro logístico de Santiago', 17),
('entregado', '2026-09-01 10:30:05', 'Santiago, Chile', 17),
('despachado', '2026-08-27 11:30:05', 'Miami, Estados Unidos', 18),
('entregado', '2026-09-01 14:30:05', 'Santiago, Chile', 18),
('despachado', '2026-09-05 19:57:42', 'São Paulo, Brasil', 19),
('entregado', '2026-09-10 03:57:42', 'Bogotá, Colombia', 19),
('despachado', '2026-09-06 06:57:42', 'Miami, Estados Unidos', 20),
('en tránsito', '2026-09-07 10:57:42', 'Centro logístico de Bogotá', 20),
('entregado', '2026-09-09 14:57:42', 'Bogotá, Colombia', 20),
('despachado', '2026-09-07 00:57:42', 'São Paulo, Brasil', 21),
('en tránsito', '2026-09-08 04:57:42', 'Centro logístico de Bogotá', 21),
('entregado', '2026-09-13 04:57:42', 'Bogotá, Colombia', 21),
('despachado', '2026-10-03 15:59:59', 'Miami, Estados Unidos', 22),
('despachado', '2026-10-04 00:59:59', 'Ciudad de México, México', 23),
('en tránsito', '2026-10-05 03:59:59', 'Centro logístico de Chicago', 23),
('despachado', '2026-10-04 21:59:59', 'São Paulo, Brasil', 24),
('despachado', '2026-10-05 03:59:59', 'Miami, Estados Unidos', 25),
('en tránsito', '2026-10-06 05:59:59', 'Centro logístico de Chicago', 25),
('despachado', '2026-10-09 18:51:35', 'Ciudad de México, México', 26),
('despachado', '2026-10-10 12:51:35', 'São Paulo, Brasil', 27),
('en tránsito', '2026-10-11 16:51:35', 'Centro logístico de Ciudad de México', 27),
('despachado', '2026-10-11 09:51:35', 'Ciudad de México, México', 28),
('en tránsito', '2026-10-12 13:51:35', 'Centro logístico de Ciudad de México', 28),
('despachado', '2026-10-19 02:24:17', 'Bogotá, Colombia', 29),
('en tránsito', '2026-10-20 05:24:17', 'Centro logístico de Lima', 29),
('despachado', '2026-10-19 17:24:17', 'Bogotá, Colombia', 30),
('despachado', '2026-10-20 04:24:17', 'Madrid, España', 31),
('despachado', '2026-10-20 06:24:17', 'São Paulo, Brasil', 32),
('en tránsito', '2026-10-21 11:24:17', 'Centro logístico de Lima', 32),
('despachado', '2026-10-24 22:09:23', 'Ciudad de México, México', 33),
('en tránsito', '2026-10-25 23:09:23', 'Centro logístico de Medellín', 33),
('despachado', '2026-10-24 23:09:23', 'Ciudad de México, México', 34),
('despachado', '2026-10-25 13:09:23', 'Miami, Estados Unidos', 35);
 
-- Devolución (8 registros)
INSERT INTO `Devolución` (fechaSolicitudDevolucion, estadoDevolucion, idPedido) VALUES
('2026-07-31 00:38:58', 'completada', 1),
('2026-08-02 19:38:58', 'rechazada', 1),
('2026-08-07 02:24:16', 'completada', 3),
('2026-08-07 07:03:01', 'aprobada', 5),
('2026-08-19 14:05:17', 'rechazada', 7),
('2026-08-31 08:43:13', 'completada', 8),
('2026-09-04 17:30:05', 'solicitada', 11),
('2026-09-18 07:57:42', 'completada', 13);
 
-- Detalle de devolución (12 registros)
INSERT INTO `Detalle de devolución` (cantidadDetalleDevolucion, motivoDetalleDevolucion, idDevolucion, idDetallePedido) VALUES
(1, 'Llegó dañado', 1, 1),
(1, 'Falla de fábrica', 1, 2),
(1, 'Modelo equivocado', 2, 3),
(1, 'Llegó dañado', 3, 5),
(1, 'Falla de fábrica', 3, 6),
(1, 'Modelo equivocado', 4, 9),
(2, 'Modelo equivocado', 5, 13),
(1, 'Producto defectuoso', 5, 14),
(1, 'Llegó dañado', 6, 16),
(1, 'Producto defectuoso', 7, 21),
(2, 'Llegó dañado', 8, 25),
(2, 'Modelo equivocado', 8, 26);
 
-- Reembolso (8 registros)
INSERT INTO Reembolso (montoReembolso, fechaReembolso, idPago, idDevolucion) VALUES
(12713.30, '2026-07-22 17:41:02', 4, NULL),
(1121.47, '2026-08-03 14:38:58', 1, 1),
(3819.90, '2026-08-09 13:03:01', 5, 4),
(8484600.00, '2026-08-09 14:24:16', 3, 3),
(175.73, '2026-08-21 19:07:34', 10, NULL),
(1199.00, '2026-09-02 21:43:13', 8, 6),
(53.32, '2026-09-10 16:43:04', 14, NULL),
(4186842.00, '2026-09-20 01:57:42', 13, 8);
 
-- Movimiento de inventario (100 registros)
INSERT INTO `Movimiento de inventario` (tipoMovimientoInventario, cantidadMovimientoInventario, fechaMovimientoInventario, idStockBodega, idDetallePedido, idDetalleDevolucion) VALUES
('descuento por pedido', 1, '2026-07-06 11:06:00', 5, 1, NULL),
('descuento por pedido', 1, '2026-07-06 11:06:00', 43, 2, NULL),
('descuento por pedido', 1, '2026-07-06 11:06:00', 14, 3, NULL),
('descuento por pedido', 2, '2026-07-11 09:48:00', 29, 4, NULL),
('reposición por cancelación', 2, '2026-07-12 14:48:00', 29, 4, NULL),
('descuento por pedido', 1, '2026-07-16 14:46:00', 39, 5, NULL),
('descuento por pedido', 3, '2026-07-16 14:46:00', 14, 6, NULL),
('descuento por pedido', 1, '2026-07-16 14:46:00', 11, 7, NULL),
('descuento por pedido', 1, '2026-07-16 14:46:00', 41, 7, NULL),
('descuento por pedido', 3, '2026-07-21 11:41:00', 21, 8, NULL),
('reposición por cancelación', 3, '2026-07-22 17:01:02', 21, 8, NULL),
('descuento por pedido', 2, '2026-07-26 10:32:00', 11, 9, NULL),
('descuento por pedido', 1, '2026-07-26 10:32:00', 1, 10, NULL),
('descuento por pedido', 1, '2026-07-26 10:32:00', 8, 11, NULL),
('descuento por pedido', 1, '2026-07-26 10:32:00', 38, 11, NULL),
('descuento por pedido', 2, '2026-07-31 14:17:00', 23, 12, NULL),
('reposición por cancelación', 2, '2026-08-01 18:17:00', 23, 12, NULL),
('reposición por devolución', 1, '2026-08-03 03:38:58', 5, 1, 1),
('reposición por devolución', 1, '2026-08-03 03:38:58', 43, 2, 2),
('descuento por pedido', 2, '2026-08-05 18:53:00', 7, 13, NULL),
('descuento por pedido', 3, '2026-08-05 18:53:00', 45, 14, NULL),
('descuento por pedido', 1, '2026-08-05 18:53:00', 18, 15, NULL),
('descuento por pedido', 1, '2026-08-05 18:53:00', 48, 15, NULL),
('reposición por devolución', 1, '2026-08-09 05:24:16', 39, 5, 4),
('reposición por devolución', 1, '2026-08-09 05:24:16', 14, 6, 5),
('reposición por devolución', 1, '2026-08-09 10:03:01', 11, 9, 6),
('descuento por pedido', 2, '2026-08-10 10:18:00', 35, 16, NULL),
('descuento por pedido', 1, '2026-08-10 10:18:00', 1, 17, NULL),
('descuento por pedido', 1, '2026-08-10 10:18:00', 31, 17, NULL),
('descuento por pedido', 1, '2026-08-10 10:18:00', 29, 18, NULL),
('descuento por pedido', 3, '2026-08-15 14:10:00', 42, 19, NULL),
('reposición por cancelación', 3, '2026-08-16 17:10:00', 42, 19, NULL),
('descuento por pedido', 1, '2026-08-20 13:16:00', 23, 20, NULL),
('reposición por cancelación', 1, '2026-08-21 18:48:34', 23, 20, NULL),
('descuento por pedido', 3, '2026-08-25 10:00:00', 19, 21, NULL),
('descuento por pedido', 2, '2026-08-25 10:00:00', 2, 22, NULL),
('descuento por pedido', 1, '2026-08-25 10:00:00', 32, 22, NULL),
('descuento por pedido', 1, '2026-08-25 10:00:00', 27, 23, NULL),
('descuento por pedido', 2, '2026-08-30 15:55:00', 5, 24, NULL),
('reposición por cancelación', 2, '2026-08-31 18:55:00', 5, 24, NULL),
('reposición por devolución', 1, '2026-09-02 11:43:13', 35, 16, 9),
('descuento por pedido', 2, '2026-09-04 13:26:00', 49, 25, NULL),
('descuento por pedido', 3, '2026-09-04 13:26:00', 7, 26, NULL),
('descuento por pedido', 1, '2026-09-04 13:26:00', 10, 27, NULL),
('descuento por pedido', 1, '2026-09-04 13:26:00', 40, 27, NULL),
('descuento por pedido', 1, '2026-09-09 09:03:00', 13, 28, NULL),
('reposición por cancelación', 1, '2026-09-10 16:26:04', 13, 28, NULL),
('descuento por pedido', 2, '2026-09-14 10:15:00', 14, 29, NULL),
('reposición por cancelación', 2, '2026-09-15 10:15:00', 14, 29, NULL),
('reposición por devolución', 2, '2026-09-19 07:57:42', 49, 25, 11),
('reposición por devolución', 2, '2026-09-19 07:57:42', 7, 26, 12),
('descuento por pedido', 2, '2026-10-01 09:19:00', 48, 30, NULL),
('descuento por pedido', 1, '2026-10-01 09:19:00', 1, 31, NULL),
('descuento por pedido', 1, '2026-10-01 09:19:00', 31, 31, NULL),
('descuento por pedido', 1, '2026-10-01 09:19:00', 29, 32, NULL),
('descuento por pedido', 2, '2026-10-01 09:19:00', 3, 33, NULL),
('descuento por pedido', 1, '2026-10-01 09:19:00', 33, 33, NULL),
('descuento por pedido', 2, '2026-10-03 10:06:00', 11, 34, NULL),
('descuento por pedido', 2, '2026-10-03 10:06:00', 3, 35, NULL),
('descuento por pedido', 1, '2026-10-05 17:36:00', 46, 36, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 15, 37, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 45, 37, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 26, 38, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 3, 39, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 33, 39, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 10, 40, NULL),
('descuento por pedido', 1, '2026-10-07 14:20:00', 40, 40, NULL),
('descuento por pedido', 1, '2026-10-09 16:38:00', 11, 41, NULL),
('descuento por pedido', 1, '2026-10-09 16:38:00', 41, 41, NULL),
('descuento por pedido', 2, '2026-10-09 16:38:00', 28, 42, NULL),
('descuento por pedido', 1, '2026-10-11 18:02:00', 8, 43, NULL),
('descuento por pedido', 1, '2026-10-11 18:02:00', 38, 43, NULL),
('descuento por pedido', 1, '2026-10-13 15:20:00', 19, 44, NULL),
('descuento por pedido', 1, '2026-10-13 15:20:00', 49, 44, NULL),
('descuento por pedido', 2, '2026-10-13 15:20:00', 5, 45, NULL),
('descuento por pedido', 1, '2026-10-13 15:20:00', 35, 45, NULL),
('descuento por pedido', 2, '2026-10-15 18:13:00', 4, 46, NULL),
('descuento por pedido', 1, '2026-10-15 18:13:00', 15, 47, NULL),
('descuento por pedido', 1, '2026-10-15 18:13:00', 45, 47, NULL),
('descuento por pedido', 1, '2026-10-15 18:13:00', 18, 48, NULL),
('descuento por pedido', 2, '2026-10-15 18:13:00', 48, 48, NULL),
('descuento por pedido', 1, '2026-10-15 18:13:00', 8, 49, NULL),
('descuento por pedido', 1, '2026-10-15 18:13:00', 38, 49, NULL),
('descuento por pedido', 1, '2026-10-17 18:29:00', 13, 50, NULL),
('descuento por pedido', 1, '2026-10-17 18:29:00', 43, 50, NULL),
('descuento por pedido', 3, '2026-10-19 15:43:00', 41, 51, NULL),
('descuento por pedido', 3, '2026-10-19 15:43:00', 46, 52, NULL),
('descuento por pedido', 1, '2026-10-21 10:43:00', 11, 53, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 18, 54, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 48, 54, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 5, 55, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 35, 55, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 20, 56, NULL),
('descuento por pedido', 1, '2026-10-23 14:55:00', 50, 56, NULL),
('descuento por pedido', 2, '2026-10-25 17:43:00', 8, 57, NULL),
('descuento por pedido', 1, '2026-10-25 17:43:00', 39, 58, NULL),
('descuento por pedido', 1, '2026-10-27 13:24:00', 20, 59, NULL),
('descuento por pedido', 1, '2026-10-27 13:24:00', 50, 59, NULL),
('descuento por pedido', 1, '2026-10-29 13:52:00', 1, 60, NULL),
('descuento por pedido', 1, '2026-10-29 13:52:00', 31, 60, NULL);