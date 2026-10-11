-- Run with: wrangler d1 execute huariskin --file=migrations/001_initial.sql

-- ── Ingredients ────────────────────────────────────────────────────────────
-- One row per canonical ingredient name (e.g. "vitamin_e", "retinol").
CREATE TABLE IF NOT EXISTS ingredients (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    canonical_name  TEXT NOT NULL UNIQUE
);

-- Maps alternate names to their canonical ingredient.
-- e.g. alias="tocopherol" → ingredient_id for "vitamin_e"
CREATE TABLE IF NOT EXISTS ingredient_aliases (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    alias         TEXT NOT NULL UNIQUE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id)
);

-- ── Active classes ──────────────────────────────────────────────────────────
-- Groups ingredients by functional class (e.g. "retinoid", "aha", "niacinamide").
CREATE TABLE IF NOT EXISTS active_classes (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

-- An ingredient can belong to more than one class (e.g. glycolic acid is both AHA and exfoliant).
CREATE TABLE IF NOT EXISTS ingredient_classes (
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    class_id      INTEGER NOT NULL REFERENCES active_classes(id),
    PRIMARY KEY (ingredient_id, class_id)
);

-- ── Conflict & timing rules ─────────────────────────────────────────────────
-- Hard: two classes must never appear in the same routine slot.
-- Soft: pairing is discouraged but not blocked (affects scoring).
CREATE TABLE IF NOT EXISTS conflict_rules (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    class_a_id  INTEGER NOT NULL REFERENCES active_classes(id),
    class_b_id  INTEGER NOT NULL REFERENCES active_classes(id),
    rule_type   TEXT NOT NULL CHECK(rule_type IN ('hard', 'soft')),
    reason      TEXT NOT NULL,
    citation    TEXT
);

-- Whether a class is restricted to AM, PM, or both.
CREATE TABLE IF NOT EXISTS timing_rules (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id     INTEGER NOT NULL REFERENCES active_classes(id),
    allowed_time TEXT NOT NULL CHECK(allowed_time IN ('am_only', 'pm_only', 'both'))
);

-- ── Products ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    name                  TEXT NOT NULL,
    brand                 TEXT,
    product_type          TEXT,   -- "cleanser", "toner", "serum", "moisturizer", "spf" …
    open_beauty_facts_id  TEXT    -- null until looked up via the API
);

-- Ingredients in label order (position 1 = highest concentration).
-- label_position is used by the scorer to weight evidence.
CREATE TABLE IF NOT EXISTS product_ingredients (
    product_id    INTEGER NOT NULL REFERENCES products(id),
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
    label_position INTEGER NOT NULL,
    PRIMARY KEY (product_id, ingredient_id)
);

-- Step order for routine assembly: lower order_index = applied first.
CREATE TABLE IF NOT EXISTS step_order (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    product_type TEXT NOT NULL UNIQUE,
    order_index  INTEGER NOT NULL
);

-- ── Users ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    email             TEXT UNIQUE,
    timezone          TEXT NOT NULL DEFAULT 'UTC',
    skin_type         TEXT CHECK(skin_type IN ('dry', 'oily', 'combination', 'normal', 'sensitive')),
    sensitivity_level INTEGER CHECK(sensitivity_level BETWEEN 1 AND 5)
);

-- One row per concern per user. severity 1 (mild) – 5 (severe).
CREATE TABLE IF NOT EXISTS user_concerns (
    user_id  INTEGER NOT NULL REFERENCES users(id),
    concern  TEXT NOT NULL,
    severity INTEGER NOT NULL CHECK(severity BETWEEN 1 AND 5),
    PRIMARY KEY (user_id, concern)
);

CREATE TABLE IF NOT EXISTS shelf_items (
    user_id    INTEGER NOT NULL REFERENCES users(id),
    product_id INTEGER NOT NULL REFERENCES products(id),
    added_at   TEXT NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (user_id, product_id)
);

-- ── Routines ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS routines (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id      INTEGER NOT NULL REFERENCES users(id),
    time_of_day  TEXT NOT NULL CHECK(time_of_day IN ('am', 'pm')),
    generated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS routine_steps (
    routine_id  INTEGER NOT NULL REFERENCES routines(id),
    product_id  INTEGER NOT NULL REFERENCES products(id),
    step_number INTEGER NOT NULL,
    why         TEXT,
    citation    TEXT,
    PRIMARY KEY (routine_id, step_number)
);

-- ── Weekly schedule ─────────────────────────────────────────────────────────
-- day_of_week: 0=Monday … 6=Sunday
CREATE TABLE IF NOT EXISTS weekly_schedule (
    user_id      INTEGER NOT NULL REFERENCES users(id),
    day_of_week  INTEGER NOT NULL CHECK(day_of_week BETWEEN 0 AND 6),
    routine_id   INTEGER NOT NULL REFERENCES routines(id),
    PRIMARY KEY (user_id, day_of_week)
);

-- ── Reminders ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reminders (
    user_id     INTEGER NOT NULL REFERENCES users(id),
    time_of_day TEXT NOT NULL CHECK(time_of_day IN ('am', 'pm')),
    time        TEXT NOT NULL,  -- "HH:MM" in the user's timezone
    enabled     INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (user_id, time_of_day)
);
