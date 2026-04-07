-- Consultas 
/* Consulta 1: El "Efecto Abandono"
Estamos perdiendo dinero con pedidos cancelados, ¿qué porcentaje de ingresos totales se ha perdido en pedidos 'Cancelled'?. 
¿Obtener el total de dinero real (Completed) vs. el dinero perdido (Cancelled)?" */
WITH ResumenVentas AS(
	SELECT
		SUM(oi.quantity * oi.unit_price) AS total_revenue, 
		SUM(CASE WHEN o.status = 'Completed' THEN oi.quantity * oi.unit_price ELSE 0 END) AS Revenue_completed, 
		SUM(CASE WHEN o.status = 'Cancelled' THEN oi.quantity * oi.unit_price ELSE 0 END) AS Revenue_cancelled
	FROM order_items oi
	JOIN orders o ON oi.order_id=o.order_id
)
SELECT 
	total_revenue,
    Revenue_completed,
    ROUND((Revenue_completed / total_revenue), 2) * 100 AS Percentage_revenue_completed,
    Revenue_cancelled,
    ROUND((Revenue_cancelled / total_revenue), 2) * 100 AS Percentage_revenue_cancelled
FROM ResumenVentas;

/* Consulta 2: Los "Cazadores de Ofertas" 
Premiar a los clientes fieles, no los que compraron una vez y desaparecieron, los que realizaron 3 o mas pedidos. 
Necesito una lista de los correos electrónicos de clientes que hayan realizado más de 3 pedidos 'Completed' y cuyo gasto total sea superior a $500."*/
WITH clientes_fieles AS(
	SELECT 
		c.first_name, 
        c.email, 
		SUM(oi.quantity * oi.unit_price) AS total_spent,
        COUNT(DISTINCT o.order_id) AS total_orders
	FROM customers c
	JOIN orders o ON c.customer_id=o.customer_id
	JOIN order_items oi ON oi.order_id=o.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.email
)
SELECT 
    first_name, 
    email, 
    total_spent, 
    total_orders
FROM clientes_fieles
WHERE total_orders > 3 AND total_spent > 500;   


/*Consulta 3: Alerta de Stock Crítico 
Gestionar el almacén, ¿qué productos tienen menos de 2 unidades en stock y han sido vendidos más de 3 veces en el último mes?. 
Esos son mis productos 'Estrella' en peligro." */
SELECT 
	oi.product_id, 
    p.product_name,
    p.category, 
	SUM(oi.quantity) AS units_sold_product, 
    p.stock_quantity
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL 1 MONTH
GROUP BY product_id, product_name
HAVING units_sold_product > 3 AND stock_quantity <= 2;   

/* Consulta 4 - Top de la discordia 
Lista con el beneficio que obtenemos de cada producto
Encontrar el producto que mas unidades ha vendido */
SELECT 
	p.product_id, 
	p.product_name, 
	oi.unit_price - p.price AS unit_margin, 
	SUM(oi.quantity * oi.unit_price) AS total_revenue,
	ROUND((SUM(oi.quantity * oi.unit_price) / SUM(SUM(oi.quantity * oi.unit_price)) OVER()) * 100, 2) AS percentage_of_company_total
FROM products p 
JOIN order_items oi ON oi.product_id = p.product_id 
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name, unit_margin
ORDER BY total_revenue DESC;

/* Consulta 5: Reabastecimiento masivo
Incrementar en 50 unidades el producto qeu tiene 2 o menos unidades en stock */
SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET stock_quantity = stock_quantity + 50
WHERE stock_quantity <= 2;
SET SQL_SAFE_UPDATES = 1;

SELECT
    product_name, 
    stock_quantity AS stock_actualizado
FROM products;

/* Consulta 6: Reporte del reabastecimiento inteligente (CTE + JOIN)
El cliente quiere saber cuanto dinero tiene en el almacen y cuanto cuesta la ultima reposicion. 
Necesitamo: nombre del producto, valor del inventario actual, columna que diga critico o normal si el stock es igual o menor a 2.
Si el estado es critico cuanto costaria comprar 100 unidades mas. */
WITH stock_initial AS(
	SELECT 
		p.product_name, 
		p.stock_quantity,
        p.price,
		CASE WHEN p.stock_quantity <= 2 THEN 'Critico' ELSE 'Normal' END AS stock_status
	FROM products p
)
SELECT 
	product_name, 
    stock_quantity, 
    stock_status, 
    CASE WHEN stock_status = 'Critico' THEN (price * 100) ELSE 0 END AS price_stock_increase
FROM stock_initial;

/* Consulta 7: Reporte de ventas perdidas y fidelizacion. 
Consulta con nombre de cliente, el total de sus compras, producto mas comprado por ese cliente y el stock actual de ese producto diciendo Reabastecer si es menor de 2. */
WITH total_cliente AS (
    SELECT
        c.customer_id,
        c.first_name,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name
),
producto_top AS (
    SELECT
        c.customer_id,
        p.product_name,
        p.stock_quantity,
        SUM(oi.quantity) AS total_units,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_id 
            ORDER BY SUM(oi.quantity) DESC
        ) AS ranking
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.status = 'Completed'
    GROUP BY 
        c.customer_id, 
        p.product_name, 
        p.stock_quantity
)
SELECT
    tc.first_name,
    tc.total_spent,  -- ✅ ahora sí es el total real
    pt.product_name AS most_purchased_product,
    pt.stock_quantity,
    CASE 
        WHEN pt.stock_quantity <= 2 THEN 'Reabastecer'
        ELSE 'Stock OK'
    END AS stock_alert
FROM total_cliente tc
JOIN producto_top pt 
    ON tc.customer_id = pt.customer_id
WHERE pt.ranking = 1;
