# ElectroWorld – Análisis y Gestión de Ventas 

Bienvenido al proyecto **ElectroWorld**, una base de datos simulada de ventas de productos electrónicos, con consultas avanzadas para análisis de negocio. 
Este proyecto demuestra habilidades en SQL, modelado de datos, CTEs y optimización con índices. 

--- 

## Objetivo del Proyecto 
1. Crear un **modelo de base de datos relacional** para gestionar clientes, productos, pedidos y detalle de pedidos.
2. Implementar **consultas analíticas** para:
   - Medir ingresos y pérdidas por pedidos cancelados.
   - Identificar clientes fieles y premiarlos.
   - Detectar productos en stock crítico y planificar reabastecimiento.
   - Analizar productos más vendidos y márgenes de beneficio.

3. Aplicar buenas prácticas de **diseño y optimización**, incluyendo índices y claves foráneas.

--- 

## Estructura de Archivos 
|ElectroWorld 

│ 

├─ schema.sql # Creación de tablas, inserción de datos y definición de índices 

├─ queries.sql # Consultas analíticas y actualizaciones 

└─ README.md # Documentación del proyecto 

--- 

## Modelo de Base de Datos
### Tablas principales 
- **customers** – Información de clientes
- **products** – Inventario de productos
- **orders** – Pedidos realizados por clientes
- **order_items** – Detalle de los productos de cada pedido

### Relaciones 
- orders.customer_id → customers.customer_id
- order_items.order_id → orders.order_id
- order_items.product_id → products.product_id > Claves primarias, foráneas y

**índices optimizados** para JOINs y filtros frecuentes. 

--- 
## Índices Clave Se crearon índices para mejorar el rendimiento de las consultas:

sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

##  Consultas Implementadas
1️ Efecto Abandono – Calcula ingresos perdidos por pedidos cancelados vs. completados
2️ Cazadores de Ofertas – Lista clientes fieles con gasto > $500
3️ Alerta de Stock Crítico – Detecta productos vendidos más de 3 veces en el último mes con stock ≤ 2
4️ Top de la Discordia – Identifica el producto más vendido, margen unitario y porcentaje sobre el total
5️ Reabastecimiento Masivo – Incrementa stock en 50 unidades para productos con stock ≤ 2
6️ Reporte de Reabastecimiento Inteligente – Valor del inventario y cálculo de reposición si está en estado crítico
7️ Ventas Perdidas y Fidelización – Total de gasto del cliente, producto más comprado y alertas de stock

##  Tecnologías
- MySQL 
- SQL avanzado: CTEs, Window Functions, JOINs múltiples, índices

## Buenas Prácticas Aplicadas
- Separación de schema y consultas
- FOREIGN KEYS y ON DELETE CASCADE
- Índices para JOINs y filtros frecuentes
- Modelado escalable (VARCHAR(100) para nombres)
- Consultas analíticas que reflejan métricas de negocio

##  Cómo Ejecutar
1. Crear base de datos y tablas:
bash mysql -u usuario -p < schema.sql
2. Ejecutar consultas analíticas:
3. mysql -u usuario -p < queries.sql

## Autor

Paula Ramos Delgado 

[LinkedIn](www.linkedin.com/in/paula-ramos-delgado-1bb425163)

[Github](https://github.com/PaulaRD5)

[Email](ramosdelgado@hotmail.es)
