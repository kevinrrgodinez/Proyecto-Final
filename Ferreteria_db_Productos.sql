CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE marcas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_venta NUMERIC(10,2) NOT NULL CHECK (precio_venta >= 0),
    costo NUMERIC(10,2) NOT NULL CHECK (costo >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    stock_minimo INTEGER NOT NULL CHECK (stock_minimo >= 0),
    id_categoria INTEGER NOT NULL,
    id_marca INTEGER NOT NULL,
    unidad_medida VARCHAR(30) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id),

    CONSTRAINT fk_marca
        FOREIGN KEY (id_marca)
        REFERENCES marcas(id),

    CONSTRAINT check_precio_mayor_costo
        CHECK (precio_venta >= costo)
);

INSERT INTO categorias (nombre) VALUES
('Herramientas manuales'),
('Herramientas eléctricas'),
('Material eléctrico'),
('Plomería'),
('Pintura'),
('Tornillería y fijación'),
('Construcción');

INSERT INTO marcas (nombre) VALUES
('Truper'),
('Pretul'),
('Urrea'),
('Bosch'),
('Makita'),
('Volteck'),
('Philips'),
('Cemex');

SELECT * FROM categorias;
SELECT * FROM marcas;

INSERT INTO productos (
    codigo,
    nombre,
    descripcion,
    precio_venta,
    costo,
    stock,
    stock_minimo,
    id_categoria,
    id_marca,
    unidad_medida
)
SELECT
    'FER-' || LPAD(gs::text, 4, '0'),

    CASE 
        WHEN gs BETWEEN 1 AND 30 THEN 'Martillo ' || (10 + (gs % 5)*2) || ' oz'
        WHEN gs BETWEEN 31 AND 60 THEN 'Desarmador Phillips ' || (4 + (gs % 4)) || '"'
        WHEN gs BETWEEN 61 AND 90 THEN 'Cable THW calibre ' || (10 + (gs % 6))
        WHEN gs BETWEEN 91 AND 120 THEN 'Tubo PVC hidráulico ' || (1 + (gs % 3)) || '/2"'
        WHEN gs BETWEEN 121 AND 150 THEN 'Tornillo galvanizado 1/4 x ' || (1 + (gs % 4)) || '"'
        WHEN gs BETWEEN 151 AND 170 THEN 'Pintura vinílica blanca ' || (4 + (gs % 4)*4) || 'L'
        WHEN gs BETWEEN 171 AND 185 THEN 'Cemento gris 50kg'
        ELSE 'Guantes de seguridad talla ' || 
             CASE WHEN gs % 3 = 0 THEN 'M'
                  WHEN gs % 3 = 1 THEN 'L'
                  ELSE 'XL'
             END
    END,

    'Producto ferretero comercial',

    -- PRECIO calculado en base al costo
    ROUND((costo_base * 1.35)::numeric,2),

    costo_base,

    (RANDOM()*200 + 20)::int,
    10,

    CASE 
        WHEN gs BETWEEN 1 AND 60 THEN 1
        WHEN gs BETWEEN 61 AND 90 THEN 3
        WHEN gs BETWEEN 91 AND 120 THEN 4
        WHEN gs BETWEEN 121 AND 150 THEN 6
        WHEN gs BETWEEN 151 AND 170 THEN 5
        WHEN gs BETWEEN 171 AND 185 THEN 7
        ELSE 1
    END,

    (RANDOM()*7 + 1)::int,

    CASE 
        WHEN gs BETWEEN 61 AND 90 THEN 'rollo'
        WHEN gs BETWEEN 151 AND 170 THEN 'litro'
        WHEN gs BETWEEN 171 AND 185 THEN 'bulto'
        ELSE 'pieza'
    END

FROM (
    SELECT 
        gs,
        ROUND((RANDOM()*600 + 50)::numeric,2) AS costo_base
    FROM generate_series(1,200) AS gs
) sub;

TRUNCATE TABLE productos RESTART IDENTITY;

SELECT COUNT(*) FROM productos;

CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(id_categoria);
CREATE INDEX idx_productos_marca ON productos(id_marca);
CREATE INDEX idx_productos_codigo ON productos(codigo);

SELECT p.nombre, c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id;

SELECT *
FROM productos
WHERE nombre ILIKE '%martillo%';

SELECT * FROM productos;