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
