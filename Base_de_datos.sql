
CREATE DATABASE riwi_analytics;

-- Conectar a la nueva base de datos
\c riwi_analytics;

-- 2. Crear esquema
CREATE SCHEMA IF NOT EXISTS analytics;

-- Establecer esquema por defecto
SET search_path TO analytics, public;

-- 3. TABLA REGIONES
CREATE TABLE analytics.regiones (
    region_id SERIAL PRIMARY KEY,
    pais VARCHAR(50) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    ciudad_normalizada VARCHAR(100),
    pais_normalizado VARCHAR(50),
    codigo_region VARCHAR(10),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABLA TIPOS PRODUCTO
CREATE TABLE analytics.tipos_producto (
    tipo_producto_id SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(100) NOT NULL UNIQUE,
    categoria_principal VARCHAR(50),
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. TABLA PRODUCTOS
CREATE TABLE analytics.productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(200) NOT NULL,
    tipo_producto_id INTEGER REFERENCES analytics.tipos_producto(tipo_producto_id),
    categoria_sistema VARCHAR(100),
    precio_referencial DECIMAL(10,2),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_producto_nombre UNIQUE (nombre_producto)
);

-- 6. TABLA TIPOS CLIENTE
CREATE TABLE analytics.tipos_cliente (
    tipo_cliente_id SERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    prioridad INTEGER DEFAULT 1,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. TABLA CANALES VENTA
CREATE TABLE analytics.canales_venta (
    canal_id SERIAL PRIMARY KEY,
    nombre_canal VARCHAR(50) NOT NULL UNIQUE,
    tipo_canal VARCHAR(30),
    es_digital BOOLEAN DEFAULT FALSE,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. TABLA VENTAS
CREATE TABLE analytics.ventas (
    venta_id BIGSERIAL PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    producto_id INTEGER NOT NULL REFERENCES analytics.productos(producto_id),
    region_id INTEGER NOT NULL REFERENCES analytics.regiones(region_id),
    canal_id INTEGER NOT NULL REFERENCES analytics.canales_venta(canal_id),
    tipo_cliente_id INTEGER NOT NULL REFERENCES analytics.tipos_cliente(tipo_cliente_id),
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento_porcentaje DECIMAL(5,2) DEFAULT 0.00,
    costo_envio DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(10,2),
    monto_descuento DECIMAL(10,2),
    monto_total DECIMAL(10,2),
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hash_fila VARCHAR(64)
);

-- 9. TABLA VENTAS RECHAZADAS
CREATE TABLE analytics.ventas_rechazadas (
    rechazo_id BIGSERIAL PRIMARY KEY,
    fecha_rechazo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    razon_rechazo VARCHAR(200),
    datos_originales JSONB,
    tabla_destino VARCHAR(50),
    proceso_rechazo VARCHAR(100)
);

-- 10. ÍNDICES BÁSICOS
CREATE INDEX idx_ventas_fecha ON analytics.ventas(fecha_venta);
CREATE INDEX idx_ventas_producto ON analytics.ventas(producto_id);
CREATE INDEX idx_ventas_region ON analytics.ventas(region_id);
CREATE INDEX idx_ventas_canal ON analytics.ventas(canal_id);
CREATE INDEX idx_ventas_tipo_cliente ON analytics.ventas(tipo_cliente_id);
CREATE INDEX idx_ventas_hash ON analytics.ventas(hash_fila);
CREATE INDEX idx_regiones_pais_ciudad ON analytics.regiones(pais, ciudad);
CREATE INDEX idx_productos_nombre ON analytics.productos(nombre_producto);