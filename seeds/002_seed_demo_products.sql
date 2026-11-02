-- Demo-only sample data. This script inserts the sample set only into an empty table.
INSERT INTO products (name, quantity, unit, category, expiration_date)
SELECT sample.name, sample.quantity, sample.unit, sample.category, sample.expiration_date
FROM (
    VALUES
        ('Greek Yogurt', 2::numeric, 'unit', 'dairy', DATE '2026-10-23'),
        ('Whole Milk', 1::numeric, 'L', 'dairy', DATE '2026-10-30'),
        ('Apples', 6::numeric, 'unit', 'produce', DATE '2026-11-10'),
        ('Rice', 1::numeric, 'kg', 'pantry_staples', NULL::date)
) AS sample(name, quantity, unit, category, expiration_date)
WHERE NOT EXISTS (SELECT 1 FROM products);
