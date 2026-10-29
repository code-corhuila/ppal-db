# ppal-db

Versioned PostgreSQL schema and migration assets for PantryPal.

## Scope

The MVP stores products for one controlled demonstration pantry. It has no user accounts, pantry ownership, or per-user isolation. The database is suitable for local development and controlled demonstrations only.

## Contents

- \`migrations/001_create_products.sql\`: creates the products table, constraints, expiration index, and update timestamp trigger.
- \`seeds/002_seed_demo_products.sql\`: inserts four illustrative products only when the table is empty.

## Product contract

The database uses the wire values defined in the project domain model:

- Units: \`unit\`, \`g\`, \`kg\`, \`ml\`, \`L\`, \`package\`.
- Categories: \`produce\`, \`dairy\`, \`pantry_staples\`, \`canned_goods\`, \`bakery\`, \`meat_eggs\`, \`snacks_other\`.
- \`expiration_date\` is nullable and uses PostgreSQL \`DATE\`, not a UTC timestamp.
- Quantity must be greater than zero with at most three decimal places; Units and Packages require integer quantities. The schema uses NUMERIC(12, 3).
- IDs and timestamps are managed by PostgreSQL.

## Local execution

From a PostgreSQL shell connected to a dedicated development database:

\`\`\`sql
\\i migrations/001_create_products.sql
\\i seeds/002_seed_demo_products.sql
\`\`\`

The migration is also mounted into the local Docker Compose stack maintained by ppal-infra. PostgreSQL's container initialization scripts run only when the data directory is first created. To reinitialize a disposable local demo database, use docker compose down -v from the infrastructure directory; this permanently deletes that local database volume.

## Security boundary

The current API has no authentication. Do not expose this database or its unauthenticated API as a public multi-user production service, and do not store sensitive personal data.
