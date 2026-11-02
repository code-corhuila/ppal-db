BEGIN;

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL CHECK (length(btrim(name)) > 0),
    quantity NUMERIC(12, 3) NOT NULL CHECK (quantity > 0),
    unit TEXT NOT NULL CHECK (unit IN ('unit', 'g', 'kg', 'ml', 'L', 'package')),
    category TEXT NOT NULL CHECK (
        category IN (
            'produce',
            'dairy',
            'pantry_staples',
            'canned_goods',
            'bakery',
            'meat_eggs',
            'snacks_other'
        )
    ),
    expiration_date DATE NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT products_integer_quantity_for_countable_units
        CHECK (unit NOT IN ('unit', 'package') OR quantity = trunc(quantity))
);

CREATE INDEX IF NOT EXISTS idx_products_expiration_date
    ON products (expiration_date ASC NULLS LAST);

CREATE OR REPLACE FUNCTION set_products_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_products_updated_at ON products;

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION set_products_updated_at();

COMMIT;
