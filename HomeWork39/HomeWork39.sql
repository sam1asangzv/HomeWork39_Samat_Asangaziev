-- Домашнее задание №39
-- Запросы с использованием подзапросов.
--
-- Используемые таблицы:
-- actions(action_id, product_id, supplier_id, action_date, qty, price)
-- products(product_id, product_name, category_id)
-- suppliers(supplier_id, supplier_name)
-- categories(category_id, category_name)

-- 1. Поставщики, которые в 2016 году поставили товаров на сумму больше,
-- чем поставщик IDT.

SELECT
  s.supplier_name
FROM suppliers s
WHERE (
  SELECT SUM(a.qty * a.price)
  FROM actions a
  WHERE a.supplier_id = s.supplier_id
    AND a.action_date >= '2016-01-01'
    AND a.action_date < '2017-01-01'
) > (
  SELECT SUM(a.qty * a.price)
  FROM actions a
  WHERE a.supplier_id IN (
    SELECT supplier_id
    FROM suppliers
    WHERE supplier_name = 'IDT'
  )
    AND a.action_date >= '2016-01-01'
    AND a.action_date < '2017-01-01'
)
ORDER BY s.supplier_name;


-- 2. Товары, которые не поставлялись поставщиком IDT.

SELECT
  p.product_name
FROM products p
WHERE NOT EXISTS (
  SELECT 1
  FROM actions a
  WHERE a.product_id = p.product_id
    AND a.supplier_id IN (
    SELECT supplier_id
    FROM suppliers
    WHERE supplier_name = 'IDT'
  )
)
ORDER BY p.product_name;


-- 3. Категории товаров, которые были поставлены поставщиком IDT
-- летом 2016 года.

SELECT DISTINCT
  c.category_name
FROM categories c
WHERE c.category_id IN (
  SELECT p.category_id
  FROM products p
  WHERE p.product_id IN (
    SELECT a.product_id
    FROM actions a
    WHERE a.supplier_id IN (
      SELECT supplier_id
      FROM suppliers
      WHERE supplier_name = 'IDT'
    )
      AND a.action_date >= '2016-06-01'
      AND a.action_date < '2016-09-01'
  )
)
ORDER BY c.category_name;
