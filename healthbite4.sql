show databases;
create database healthbite4;
-- =============================================================================
-- HealthBite-AI — MySQL DDL Schema
-- Version: 1.0.0  |  Architecture: March 2026
-- =============================================================================
-- Fixes applied:
--   • All ENUM values use proper single-quote SQL syntax
--   • ON DELETE / ON UPDATE actions declared on every FK
--   • UNIQUE constraints added per spec (email, username, session_token_hash,
--     meal_log_id on meal_health_scores, user_id+score_date, etc.)
--   • DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP on updated_at cols
--   • FULLTEXT index on food_items (food_name, food_name_local, brand_name)
--   • highlight_type ENUM completed with all values from spec
--   • content_reports.status ENUM completed with all resolution values
--   • challenge_participants.challenge_id FK corrected to BIGINT UNSIGNED
--   • community_highlights.user_id FK added (was missing ON DELETE)
--   • Composite UNIQUE keys added for junction tables
--   • All tables use ENGINE=InnoDB CHARSET=utf8mb4
-- =============================================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- =============================================================================
-- SECTION 1 — LOOKUP / REFERENCE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS gender_types (
    gender_id    TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    gender_name  VARCHAR(30)       NOT NULL,
    gender_code  CHAR(1)           NOT NULL,           -- M / F / O / P
    is_active    BOOLEAN           NOT NULL DEFAULT TRUE,
    created_at   DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (gender_id),
    UNIQUE KEY uq_gender_code (gender_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS activity_levels (
    activity_level_id  TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    level_name         VARCHAR(40)       NOT NULL,
    level_code         VARCHAR(20)       NOT NULL,     -- SEDENTARY, VERY_ACTIVE …
    multiplier_factor  DECIMAL(4,2)      NOT NULL,     -- Harris-Benedict PAL
    description        TEXT,
    sort_order         TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    is_active          BOOLEAN           NOT NULL DEFAULT TRUE,
    PRIMARY KEY (activity_level_id),
    UNIQUE KEY uq_level_code (level_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dietary_preference_types (
    preference_id    SMALLINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    preference_name  VARCHAR(60)        NOT NULL,
    preference_code  VARCHAR(30)        NOT NULL,      -- VEGAN, HALAL …
    description      TEXT,
    is_active        BOOLEAN            NOT NULL DEFAULT TRUE,
    PRIMARY KEY (preference_id),
    UNIQUE KEY uq_preference_code (preference_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS health_goal_types (
    goal_type_id  TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    goal_name     VARCHAR(60)       NOT NULL,
    goal_code     VARCHAR(30)       NOT NULL,          -- LOSE_WEIGHT …
    description   TEXT,
    is_active     BOOLEAN           NOT NULL DEFAULT TRUE,
    PRIMARY KEY (goal_type_id),
    UNIQUE KEY uq_goal_code (goal_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_types (
    meal_type_id  TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    type_name     VARCHAR(30)       NOT NULL,
    type_code     VARCHAR(20)       NOT NULL,          -- BREAKFAST …
    sort_order    TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    is_active     BOOLEAN           NOT NULL DEFAULT TRUE,
    PRIMARY KEY (meal_type_id),
    UNIQUE KEY uq_meal_type_code (type_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS entry_method_types (
    method_id    TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    method_name  VARCHAR(30)       NOT NULL,
    method_code  VARCHAR(20)       NOT NULL,           -- TEXT / VOICE / PHOTO / BARCODE / MANUAL
    is_active    BOOLEAN           NOT NULL DEFAULT TRUE,
    PRIMARY KEY (method_id),
    UNIQUE KEY uq_method_code (method_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS reaction_types (
    reaction_type_id  TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    reaction_name     VARCHAR(30)       NOT NULL,
    reaction_emoji    VARCHAR(10)       NOT NULL,
    reaction_code     VARCHAR(20)       NOT NULL,      -- HEALTHY, FIRE …
    sort_order        TINYINT UNSIGNED  NOT NULL DEFAULT 0,
    PRIMARY KEY (reaction_type_id),
    UNIQUE KEY uq_reaction_code (reaction_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS notification_types (
    notification_type_id  TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    type_name             VARCHAR(60)       NOT NULL,
    type_code             VARCHAR(40)       NOT NULL,  -- NEW_REACTION …
    description           TEXT,
    PRIMARY KEY (notification_type_id),
    UNIQUE KEY uq_notif_type_code (type_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS report_reason_types (
    reason_id    TINYINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    reason_name  VARCHAR(80)       NOT NULL,
    reason_code  VARCHAR(40)       NOT NULL,           -- SPAM, HARASSMENT …
    is_active    BOOLEAN           NOT NULL DEFAULT TRUE,
    PRIMARY KEY (reason_id),
    UNIQUE KEY uq_reason_code (reason_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS badge_types (
    badge_type_id   SMALLINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    badge_name      VARCHAR(80)        NOT NULL,
    badge_code      VARCHAR(40)        NOT NULL,       -- STREAK_7 …
    badge_icon_url  VARCHAR(512),
    description     TEXT,
    criteria_json   JSON,
    is_active       BOOLEAN            NOT NULL DEFAULT TRUE,
    PRIMARY KEY (badge_type_id),
    UNIQUE KEY uq_badge_code (badge_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 2 — USER & PROFILE TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS users (
    user_id            BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    username           VARCHAR(30)       NOT NULL,
    email              VARCHAR(255)      NOT NULL,
    phone_number       VARCHAR(20),
    password_hash      VARCHAR(255)      NOT NULL,
    password_salt      VARCHAR(64)       NOT NULL,
    gender_id          TINYINT UNSIGNED,
    date_of_birth      DATE,
    full_name          VARCHAR(120),
    display_name       VARCHAR(60),
    bio                TEXT,
    avatar_url         VARCHAR(512),
    cover_photo_url    VARCHAR(512),
    timezone           VARCHAR(60)       NOT NULL DEFAULT 'UTC',
    locale             VARCHAR(10)       NOT NULL DEFAULT 'en-IN',
    is_email_verified  BOOLEAN           NOT NULL DEFAULT FALSE,
    is_active          BOOLEAN           NOT NULL DEFAULT TRUE,
    is_banned          BOOLEAN           NOT NULL DEFAULT FALSE,
    last_login_at      DATETIME,
    created_at         DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at         DATETIME,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email    (email),
    UNIQUE KEY uq_users_username (username),
    KEY fk_users_gender_idx (gender_id),
    CONSTRAINT fk_users_gender FOREIGN KEY (gender_id)
        REFERENCES gender_types (gender_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_auth_providers (
    auth_provider_id  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id           BIGINT UNSIGNED  NOT NULL,
    provider_name     VARCHAR(30)      NOT NULL,       -- google / apple / facebook
    provider_user_id  VARCHAR(255)     NOT NULL,
    access_token      TEXT,                            -- encrypted at app layer
    refresh_token     TEXT,                            -- encrypted at app layer
    token_expires_at  DATETIME,
    raw_profile_json  JSON,
    PRIMARY KEY (auth_provider_id),
    UNIQUE KEY uq_provider_user (provider_name, provider_user_id),
    KEY fk_auth_user_idx (user_id),
    CONSTRAINT fk_auth_providers_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_health_profiles (
    profile_id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED  NOT NULL,
    height_cm           DECIMAL(5,1),
    weight_kg           DECIMAL(5,2),
    target_weight_kg    DECIMAL(5,2),
    activity_level_id   TINYINT UNSIGNED,
    bmr_kcal            DECIMAL(7,2),
    tdee_kcal           DECIMAL(7,2),
    bmi                 DECIMAL(4,1),
    body_fat_pct        DECIMAL(4,1),
    medical_conditions  JSON,
    allergies           JSON,
    PRIMARY KEY (profile_id),
    UNIQUE KEY uq_health_profile_user (user_id),
    KEY fk_hp_activity_idx (activity_level_id),
    CONSTRAINT fk_health_profile_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_health_profile_activity FOREIGN KEY (activity_level_id)
        REFERENCES activity_levels (activity_level_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_health_goals (
    user_goal_id   BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id        BIGINT UNSIGNED  NOT NULL,
    goal_type_id   TINYINT UNSIGNED NOT NULL,
    is_primary     BOOLEAN          NOT NULL DEFAULT FALSE,
    target_value   DECIMAL(8,2),
    target_date    DATE,
    is_achieved    BOOLEAN          NOT NULL DEFAULT FALSE,
    achieved_at    DATETIME,
    PRIMARY KEY (user_goal_id),
    KEY fk_goals_user_idx     (user_id),
    KEY fk_goals_type_idx     (goal_type_id),
    CONSTRAINT fk_goals_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_goals_type FOREIGN KEY (goal_type_id)
        REFERENCES health_goal_types (goal_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_dietary_preferences (
    user_pref_id   BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    user_id        BIGINT UNSIGNED   NOT NULL,
    preference_id  SMALLINT UNSIGNED NOT NULL,
    created_at     DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_pref_id),
    UNIQUE KEY uq_user_preference (user_id, preference_id),
    KEY fk_diet_pref_type_idx (preference_id),
    CONSTRAINT fk_diet_pref_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_diet_pref_type FOREIGN KEY (preference_id)
        REFERENCES dietary_preference_types (preference_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_daily_nutrition_targets (
    target_id       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id         BIGINT UNSIGNED  NOT NULL,
    effective_date  DATE             NOT NULL,
    calories_kcal   DECIMAL(7,2)     NOT NULL DEFAULT 2000.00,
    protein_g       DECIMAL(6,2)     NOT NULL DEFAULT 50.00,
    carbohydrate_g  DECIMAL(6,2)     NOT NULL DEFAULT 260.00,
    fat_g           DECIMAL(6,2)     NOT NULL DEFAULT 65.00,
    fiber_g         DECIMAL(6,2)     NOT NULL DEFAULT 30.00,
    sugar_g         DECIMAL(6,2)     NOT NULL DEFAULT 50.00,
    sodium_mg       DECIMAL(7,2)     NOT NULL DEFAULT 2300.00,
    water_ml        DECIMAL(7,2)     NOT NULL DEFAULT 2500.00,
    vitamin_c_mg    DECIMAL(6,2)     NOT NULL DEFAULT 90.00,
    vitamin_d_iu    DECIMAL(6,2)     NOT NULL DEFAULT 600.00,
    is_ai_generated BOOLEAN          NOT NULL DEFAULT FALSE,
    PRIMARY KEY (target_id),
    UNIQUE KEY uq_nutrition_target_user_date (user_id, effective_date),
    CONSTRAINT fk_nutrition_targets_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_privacy_settings (
    privacy_id              BIGINT UNSIGNED                          NOT NULL AUTO_INCREMENT,
    user_id                 BIGINT UNSIGNED                          NOT NULL,
    profile_visibility      ENUM('PUBLIC','FRIENDS','PRIVATE')       NOT NULL DEFAULT 'PUBLIC',
    meal_default_visibility ENUM('PUBLIC','FRIENDS','PRIVATE')       NOT NULL DEFAULT 'PUBLIC',
    score_visibility        ENUM('PUBLIC','FRIENDS','PRIVATE')       NOT NULL DEFAULT 'PUBLIC',
    allow_friend_requests   BOOLEAN                                  NOT NULL DEFAULT TRUE,
    show_in_community_feed  BOOLEAN                                  NOT NULL DEFAULT TRUE,
    show_in_leaderboards    BOOLEAN                                  NOT NULL DEFAULT TRUE,
    allow_reactions         BOOLEAN                                  NOT NULL DEFAULT TRUE,
    allow_comments          BOOLEAN                                  NOT NULL DEFAULT TRUE,
    email_notifications     BOOLEAN                                  NOT NULL DEFAULT TRUE,
    push_notifications      BOOLEAN                                  NOT NULL DEFAULT TRUE,
    PRIMARY KEY (privacy_id),
    UNIQUE KEY uq_privacy_user (user_id),
    CONSTRAINT fk_privacy_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 3 — FOOD & NUTRITION CATALOGUE
-- =============================================================================

CREATE TABLE IF NOT EXISTS food_categories (
    category_id         SMALLINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    parent_category_id  SMALLINT UNSIGNED,             -- self-FK for sub-categories
    category_name       VARCHAR(80)        NOT NULL,
    category_code       VARCHAR(40)        NOT NULL,
    description         TEXT,
    icon_url            VARCHAR(512),
    sort_order          SMALLINT UNSIGNED  NOT NULL DEFAULT 0,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_category_code (category_code),
    KEY fk_cat_parent_idx (parent_category_id),
    CONSTRAINT fk_food_cat_parent FOREIGN KEY (parent_category_id)
        REFERENCES food_categories (category_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS food_items (
    food_id              BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    category_id          SMALLINT UNSIGNED,
    food_name            VARCHAR(200)      NOT NULL,   -- FULLTEXT indexed
    food_name_local      VARCHAR(200),
    brand_name           VARCHAR(120),
    barcode              VARCHAR(30),
    serving_size_g       DECIMAL(8,2)      NOT NULL DEFAULT 100.00,
    calories_kcal        DECIMAL(7,2)      NOT NULL DEFAULT 0.00,
    protein_g            DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    total_fat_g          DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    saturated_fat_g      DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    total_carbohydrate_g DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    dietary_fiber_g      DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    total_sugars_g       DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    added_sugars_g       DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    sodium_mg            DECIMAL(7,3)      NOT NULL DEFAULT 0.000,
    potassium_mg         DECIMAL(7,3)      NOT NULL DEFAULT 0.000,
    vitamin_c_mg         DECIMAL(7,3)      NOT NULL DEFAULT 0.000,
    vitamin_d_iu         DECIMAL(7,3)      NOT NULL DEFAULT 0.000,
    omega3_g             DECIMAL(6,3)      NOT NULL DEFAULT 0.000,
    glycemic_index       TINYINT UNSIGNED,
    data_source          VARCHAR(80),                  -- USDA / OpenFoodFacts / AI
    is_verified          BOOLEAN           NOT NULL DEFAULT FALSE,
    is_user_created      BOOLEAN           NOT NULL DEFAULT FALSE,
    created_by_user_id   BIGINT UNSIGNED,
    tags_json            JSON,
    PRIMARY KEY (food_id),
    KEY fk_food_category_idx       (category_id),
    KEY fk_food_creator_idx        (created_by_user_id),
    KEY idx_food_barcode           (barcode),
    FULLTEXT KEY ft_food_search    (food_name, food_name_local, brand_name),
    CONSTRAINT fk_food_category FOREIGN KEY (category_id)
        REFERENCES food_categories (category_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_food_creator FOREIGN KEY (created_by_user_id)
        REFERENCES users (user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 4 — MEAL LOGGING TABLES
-- =============================================================================

CREATE TABLE IF NOT EXISTS meal_logs (
    meal_log_id         BIGINT UNSIGNED                         NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED                         NOT NULL,
    meal_type_id        TINYINT UNSIGNED                        NOT NULL,
    entry_method_id     TINYINT UNSIGNED                        NOT NULL,
    log_date            DATE                                    NOT NULL,
    log_time            TIME,
    meal_name           VARCHAR(200),
    description         TEXT,
    photo_url           VARCHAR(512),
    voice_audio_url     VARCHAR(512),
    ai_raw_input        TEXT,
    ai_parsed_output    JSON,
    ai_confidence       DECIMAL(4,3),                          -- 0.000–1.000
    total_calories_kcal DECIMAL(8,2)                           NOT NULL DEFAULT 0.00,
    total_protein_g     DECIMAL(7,3)                           NOT NULL DEFAULT 0.000,
    total_fat_g         DECIMAL(7,3)                           NOT NULL DEFAULT 0.000,
    total_fiber_g       DECIMAL(7,3)                           NOT NULL DEFAULT 0.000,
    total_sugar_g       DECIMAL(7,3)                           NOT NULL DEFAULT 0.000,
    total_sodium_mg     DECIMAL(8,3)                           NOT NULL DEFAULT 0.000,
    visibility          ENUM('PUBLIC','FRIENDS','PRIVATE')      NOT NULL DEFAULT 'PRIVATE',
    is_published        BOOLEAN                                 NOT NULL DEFAULT FALSE,
    published_at        DATETIME,
    caption             TEXT,
    is_flagged          BOOLEAN                                 NOT NULL DEFAULT FALSE,
    is_deleted          BOOLEAN                                 NOT NULL DEFAULT FALSE,
    PRIMARY KEY (meal_log_id),
    KEY fk_ml_user_idx             (user_id),
    KEY fk_ml_meal_type_idx        (meal_type_id),
    KEY fk_ml_entry_method_idx     (entry_method_id),
    KEY idx_ml_user_date           (user_id, log_date),
    KEY idx_ml_feed                (visibility, is_published),
    CONSTRAINT fk_meal_logs_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_meal_logs_meal_type FOREIGN KEY (meal_type_id)
        REFERENCES meal_types (meal_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_meal_logs_entry_method FOREIGN KEY (entry_method_id)
        REFERENCES entry_method_types (method_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_log_items (
    item_id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id      BIGINT UNSIGNED  NOT NULL,
    food_id          BIGINT UNSIGNED,
    custom_food_name VARCHAR(200),
    quantity_g       DECIMAL(8,3)     NOT NULL,
    quantity_unit    VARCHAR(30)      NOT NULL DEFAULT 'g',
    calories_kcal    DECIMAL(8,2)     NOT NULL DEFAULT 0.00,
    protein_g        DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    total_fat_g      DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    carbohydrate_g   DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    fiber_g          DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    sugar_g          DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    sodium_mg        DECIMAL(8,3)     NOT NULL DEFAULT 0.000,
    ai_identified    BOOLEAN          NOT NULL DEFAULT FALSE,
    ai_confidence    DECIMAL(4,3),
    PRIMARY KEY (item_id),
    KEY fk_mli_meal_log_idx (meal_log_id),
    KEY fk_mli_food_idx     (food_id),
    CONSTRAINT fk_meal_log_items_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_meal_log_items_food FOREIGN KEY (food_id)
        REFERENCES food_items (food_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_log_photos (
    photo_id         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id      BIGINT UNSIGNED  NOT NULL,
    photo_url        VARCHAR(512)     NOT NULL,
    thumbnail_url    VARCHAR(512),
    width_px         SMALLINT UNSIGNED,
    height_px        SMALLINT UNSIGNED,
    file_size_bytes  INT UNSIGNED,
    ai_analysis_json JSON,
    is_primary       BOOLEAN          NOT NULL DEFAULT FALSE,
    PRIMARY KEY (photo_id),
    KEY fk_mlp_meal_log_idx (meal_log_id),
    CONSTRAINT fk_meal_log_photos_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS daily_summaries (
    summary_id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id              BIGINT UNSIGNED  NOT NULL,
    summary_date         DATE             NOT NULL,
    total_meals_logged   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    total_calories_kcal  DECIMAL(8,2)     NOT NULL DEFAULT 0.00,
    total_protein_g      DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    total_carbohydrate_g DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    total_fiber_g        DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    total_sugar_g        DECIMAL(7,3)     NOT NULL DEFAULT 0.000,
    total_sodium_mg      DECIMAL(8,3)     NOT NULL DEFAULT 0.000,
    water_ml_logged      DECIMAL(8,2)     NOT NULL DEFAULT 0.00,
    steps_count          INT UNSIGNED,
    sleep_hours          DECIMAL(4,2),
    stress_level         TINYINT UNSIGNED,               -- 1-10
    mood_score           TINYINT UNSIGNED,               -- 1-10
    PRIMARY KEY (summary_id),
    UNIQUE KEY uq_daily_summary_user_date (user_id, summary_date),
    CONSTRAINT fk_daily_summaries_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 5 — HEALTH SCORE ENGINE
-- =============================================================================

CREATE TABLE IF NOT EXISTS health_score_configs (
    config_id            SMALLINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    config_name          VARCHAR(80)        NOT NULL,
    config_version       VARCHAR(20)        NOT NULL,   -- semantic version
    is_active            BOOLEAN            NOT NULL DEFAULT TRUE,
    weight_macros_pct    DECIMAL(5,2)       NOT NULL DEFAULT 30.00,
    weight_micros_pct    DECIMAL(5,2)       NOT NULL DEFAULT 20.00,
    weight_fiber_pct     DECIMAL(5,2)       NOT NULL DEFAULT 15.00,
    weight_sugar_pct     DECIMAL(5,2)       NOT NULL DEFAULT 15.00,
    weight_lifestyle_pct DECIMAL(5,2)       NOT NULL DEFAULT 20.00,
    score_config_json    JSON,
    PRIMARY KEY (config_id),
    UNIQUE KEY uq_score_config_version (config_version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_health_scores (
    score_id               BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    meal_log_id            BIGINT UNSIGNED   NOT NULL,
    config_id              SMALLINT UNSIGNED NOT NULL,
    overall_score          DECIMAL(5,2)      NOT NULL,  -- 0-100
    score_label            VARCHAR(30)       NOT NULL,  -- Excellent / Good / Fair / Poor
    score_color_hex        CHAR(6)           NOT NULL DEFAULT '4CAF50',
    macro_score            DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    micro_score            DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    fiber_score            DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    sugar_score            DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    lifestyle_score        DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    top_positives_json     JSON,
    top_negatives_json     JSON,
    ai_insight_text        TEXT,
    ai_recommendation_text TEXT,
    calculated_at          DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (score_id),
    UNIQUE KEY uq_score_per_meal (meal_log_id),
    KEY fk_mhs_config_idx (config_id),
    CONSTRAINT fk_meal_health_scores_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_meal_health_scores_config FOREIGN KEY (config_id)
        REFERENCES health_score_configs (config_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS daily_health_scores (
    daily_score_id          BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    user_id                 BIGINT UNSIGNED   NOT NULL,
    score_date              DATE              NOT NULL,
    config_id               SMALLINT UNSIGNED NOT NULL,
    overall_score           DECIMAL(5,2)      NOT NULL,
    score_label             VARCHAR(30)       NOT NULL,
    macro_score             DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    micro_score             DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    fiber_score             DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    sugar_score             DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    lifestyle_score         DECIMAL(5,2)      NOT NULL DEFAULT 0.00,
    calorie_pct_of_target   DECIMAL(5,2),
    community_rank          INT UNSIGNED,
    community_percentile    DECIMAL(5,2),
    is_community_highlight  BOOLEAN           NOT NULL DEFAULT FALSE,
    ai_daily_insight        TEXT,
    PRIMARY KEY (daily_score_id),
    UNIQUE KEY uq_daily_score_user_date (user_id, score_date),
    KEY fk_dhs_config_idx              (config_id),
    KEY idx_dhs_leaderboard            (score_date, overall_score DESC),
    CONSTRAINT fk_daily_health_scores_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_daily_health_scores_config FOREIGN KEY (config_id)
        REFERENCES health_score_configs (config_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 6 — SOCIAL GRAPH
-- =============================================================================

CREATE TABLE IF NOT EXISTS user_follows (
    follow_id    BIGINT UNSIGNED                                      NOT NULL AUTO_INCREMENT,
    follower_id  BIGINT UNSIGNED                                      NOT NULL,
    following_id BIGINT UNSIGNED                                      NOT NULL,
    status       ENUM('PENDING','ACCEPTED','DECLINED','BLOCKED')      NOT NULL DEFAULT 'ACCEPTED',
    created_at   DATETIME                                             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME                                             NOT NULL DEFAULT CURRENT_TIMESTAMP
                                                                              ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (follow_id),
    UNIQUE KEY uq_follow_pair       (follower_id, following_id),
    KEY idx_following_status        (following_id, status),
    CONSTRAINT fk_follows_follower FOREIGN KEY (follower_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_follows_following FOREIGN KEY (following_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_blocks (
    block_id    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    blocker_id  BIGINT UNSIGNED  NOT NULL,
    blocked_id  BIGINT UNSIGNED  NOT NULL,
    reason      TEXT,
    created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (block_id),
    UNIQUE KEY uq_block_pair       (blocker_id, blocked_id),
    KEY fk_blocks_blocked_idx      (blocked_id),
    CONSTRAINT fk_blocks_blocker FOREIGN KEY (blocker_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_blocks_blocked FOREIGN KEY (blocked_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 7 — SOCIAL ENGAGEMENT
-- =============================================================================

CREATE TABLE IF NOT EXISTS meal_post_reactions (
    reaction_id      BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id      BIGINT UNSIGNED  NOT NULL,
    user_id          BIGINT UNSIGNED  NOT NULL,
    reaction_type_id TINYINT UNSIGNED NOT NULL,
    created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP
                                               ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (reaction_id),
    UNIQUE KEY uq_reaction_user_post   (meal_log_id, user_id),
    KEY fk_mpr_user_idx                (user_id),
    KEY fk_mpr_reaction_type_idx       (reaction_type_id),
    CONSTRAINT fk_reactions_meal_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reactions_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reactions_type FOREIGN KEY (reaction_type_id)
        REFERENCES reaction_types (reaction_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_post_comments (
    comment_id        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id       BIGINT UNSIGNED  NOT NULL,
    user_id           BIGINT UNSIGNED  NOT NULL,
    parent_comment_id BIGINT UNSIGNED,
    comment_text      TEXT             NOT NULL,
    is_edited         BOOLEAN          NOT NULL DEFAULT FALSE,
    is_deleted        BOOLEAN          NOT NULL DEFAULT FALSE,
    is_flagged        BOOLEAN          NOT NULL DEFAULT FALSE,
    like_count        INT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (comment_id),
    KEY fk_mpc_meal_log_idx        (meal_log_id),
    KEY fk_mpc_user_idx            (user_id),
    KEY fk_mpc_parent_idx          (parent_comment_id),
    CONSTRAINT fk_comments_meal_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comments_parent FOREIGN KEY (parent_comment_id)
        REFERENCES meal_post_comments (comment_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS comment_likes (
    like_id     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    comment_id  BIGINT UNSIGNED  NOT NULL,
    user_id     BIGINT UNSIGNED  NOT NULL,
    created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (like_id),
    UNIQUE KEY uq_comment_like       (comment_id, user_id),
    KEY fk_cl_user_idx               (user_id),
    CONSTRAINT fk_comment_likes_comment FOREIGN KEY (comment_id)
        REFERENCES meal_post_comments (comment_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_comment_likes_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS meal_post_shares (
    share_id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id        BIGINT UNSIGNED  NOT NULL,
    shared_by_user_id  BIGINT UNSIGNED  NOT NULL,
    share_platform     VARCHAR(30)      NOT NULL,  -- IN_APP / WHATSAPP / INSTAGRAM …
    share_caption      TEXT,
    PRIMARY KEY (share_id),
    KEY fk_mps_meal_log_idx        (meal_log_id),
    KEY fk_mps_user_idx            (shared_by_user_id),
    CONSTRAINT fk_shares_meal_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_shares_user FOREIGN KEY (shared_by_user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 8 — COMMUNITY, BADGES & HIGHLIGHTS
-- =============================================================================

CREATE TABLE IF NOT EXISTS community_challenges (
    challenge_id    BIGINT UNSIGNED                              NOT NULL AUTO_INCREMENT,
    challenge_name  VARCHAR(120)                                 NOT NULL,
    challenge_code  VARCHAR(60)                                  NOT NULL,
    challenge_type  ENUM('DAILY','WEEKLY','MONTHLY','CUSTOM')    NOT NULL DEFAULT 'WEEKLY',
    start_date      DATETIME                                     NOT NULL,
    end_date        DATETIME                                     NOT NULL,
    criteria_json   JSON,
    badge_type_id   SMALLINT UNSIGNED,
    is_public       BOOLEAN                                      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (challenge_id),
    UNIQUE KEY uq_challenge_code   (challenge_code),
    KEY fk_cc_badge_idx            (badge_type_id),
    CONSTRAINT fk_challenges_badge FOREIGN KEY (badge_type_id)
        REFERENCES badge_types (badge_type_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- FIX: challenge_id FK must match community_challenges PK type (BIGINT UNSIGNED)

CREATE TABLE IF NOT EXISTS challenge_participants (
    participant_id  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    challenge_id    BIGINT UNSIGNED  NOT NULL,          -- fixed: was BIGINT, now BIGINT UNSIGNED
    user_id         BIGINT UNSIGNED  NOT NULL,
    joined_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    current_score   DECIMAL(7,2)     NOT NULL DEFAULT 0.00,
    `rank`          INT UNSIGNED,
    is_completed    BOOLEAN          NOT NULL DEFAULT FALSE,
    is_winner       BOOLEAN          NOT NULL DEFAULT FALSE,
    PRIMARY KEY (participant_id),
    UNIQUE KEY uq_participant       (challenge_id, user_id),
    KEY fk_cp_user_idx              (user_id),
    CONSTRAINT fk_participants_challenge FOREIGN KEY (challenge_id)
        REFERENCES community_challenges (challenge_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_participants_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS community_highlights (
    highlight_id    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    meal_log_id     BIGINT UNSIGNED,
    user_id         BIGINT UNSIGNED,
    highlight_type  ENUM(
                        'MOST_BALANCED_MEAL',
                        'TOP_SCORE_DAY',
                        'MOST_REACTIONS',
                        'STREAK_LEADER',
                        'MOST_IMPROVED',
                        'CHALLENGE_WINNER',
                        'COMMUNITY_FAVOURITE'
                    )                NOT NULL,
    highlight_date  DATE             NOT NULL,
    title           VARCHAR(200)     NOT NULL,
    score_snapshot  DECIMAL(5,2),
    is_featured     BOOLEAN          NOT NULL DEFAULT FALSE,
    PRIMARY KEY (highlight_id),
    KEY fk_ch_meal_log_idx (meal_log_id),
    KEY fk_ch_user_idx     (user_id),
    CONSTRAINT fk_highlights_meal_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_highlights_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_badges (
    user_badge_id      BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
    user_id            BIGINT UNSIGNED   NOT NULL,
    badge_type_id      SMALLINT UNSIGNED NOT NULL,
    awarded_at         DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    award_context_json JSON,
    is_pinned          BOOLEAN           NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_badge_id),
    UNIQUE KEY uq_user_badge       (user_id, badge_type_id),
    KEY fk_ub_badge_idx            (badge_type_id),
    CONSTRAINT fk_user_badges_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_user_badges_type FOREIGN KEY (badge_type_id)
        REFERENCES badge_types (badge_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_logging_streaks (
    streak_id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED  NOT NULL,
    current_streak_days INT UNSIGNED     NOT NULL DEFAULT 0,
    longest_streak_days INT UNSIGNED     NOT NULL DEFAULT 0,
    last_logged_date    DATE,
    streak_started_date DATE,
    total_logged_days   INT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (streak_id),
    UNIQUE KEY uq_streak_user (user_id),
    CONSTRAINT fk_streaks_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 9 — NOTIFICATIONS
-- =============================================================================

CREATE TABLE IF NOT EXISTS notifications (
    notification_id      BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    recipient_user_id    BIGINT UNSIGNED  NOT NULL,
    sender_user_id       BIGINT UNSIGNED,
    notification_type_id TINYINT UNSIGNED NOT NULL,
    title                VARCHAR(200)     NOT NULL,
    body                 TEXT,
    action_url           VARCHAR(512),
    entity_type          VARCHAR(40),                  -- meal_log / comment / user / challenge
    entity_id            BIGINT UNSIGNED,
    is_read              BOOLEAN          NOT NULL DEFAULT FALSE,
    read_at              DATETIME,
    is_sent              BOOLEAN          NOT NULL DEFAULT FALSE,
    sent_at              DATETIME,
    PRIMARY KEY (notification_id),
    KEY idx_notif_unread         (recipient_user_id, is_read),
    KEY fk_notif_sender_idx      (sender_user_id),
    KEY fk_notif_type_idx        (notification_type_id),
    CONSTRAINT fk_notif_recipient FOREIGN KEY (recipient_user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_notif_sender FOREIGN KEY (sender_user_id)
        REFERENCES users (user_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_notif_type FOREIGN KEY (notification_type_id)
        REFERENCES notification_types (notification_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 10 — MODERATION
-- =============================================================================

CREATE TABLE IF NOT EXISTS content_reports (
    report_id           BIGINT UNSIGNED                                    NOT NULL AUTO_INCREMENT,
    reporter_user_id    BIGINT UNSIGNED                                    NOT NULL,
    reason_id           TINYINT UNSIGNED                                   NOT NULL,
    entity_type         ENUM('MEAL_LOG','COMMENT','USER')                  NOT NULL,
    entity_id           BIGINT UNSIGNED                                    NOT NULL,
    description         TEXT,
    status              ENUM(
                            'PENDING',
                            'UNDER_REVIEW',
                            'RESOLVED_NO_ACTION',
                            'RESOLVED_REMOVED',
                            'RESOLVED_BANNED'
                        )                                                  NOT NULL DEFAULT 'PENDING',
    reviewed_by_user_id BIGINT UNSIGNED,
    reviewed_at         DATETIME,
    resolution_notes    TEXT,
    PRIMARY KEY (report_id),
    KEY fk_cr_reporter_idx    (reporter_user_id),
    KEY fk_cr_reason_idx      (reason_id),
    KEY fk_cr_reviewer_idx    (reviewed_by_user_id),
    CONSTRAINT fk_reports_reporter FOREIGN KEY (reporter_user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_reports_reason FOREIGN KEY (reason_id)
        REFERENCES report_reason_types (reason_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reports_reviewer FOREIGN KEY (reviewed_by_user_id)
        REFERENCES users (user_id)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 11 — SECURITY
-- =============================================================================

CREATE TABLE IF NOT EXISTS user_sessions (
    session_id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED  NOT NULL,
    session_token_hash  VARCHAR(128)     NOT NULL,
    refresh_token_hash  VARCHAR(128),
    device_id           VARCHAR(128),
    device_name         VARCHAR(120),
    platform            VARCHAR(20),                   -- IOS / ANDROID / WEB
    is_active           BOOLEAN          NOT NULL DEFAULT TRUE,
    expires_at          DATETIME         NOT NULL,
    revoked_at          DATETIME,
    PRIMARY KEY (session_id),
    UNIQUE KEY uq_session_token_hash   (session_token_hash),
    KEY fk_sessions_user_idx           (user_id),
    CONSTRAINT fk_sessions_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS user_activity_log (
    activity_id    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id        BIGINT UNSIGNED  NOT NULL,
    activity_type  VARCHAR(60)      NOT NULL,          -- LOGIN / MEAL_LOG / SHARE …
    entity_type    VARCHAR(40),
    entity_id      BIGINT UNSIGNED,
    ip_address     VARCHAR(45),
    platform       VARCHAR(20),
    metadata_json  JSON,
    created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (activity_id),
    KEY idx_activity_audit  (user_id, activity_type, created_at),
    CONSTRAINT fk_activity_log_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- SECTION 12 — FEED CACHE
-- =============================================================================

CREATE TABLE IF NOT EXISTS user_feed_cache (
    feed_item_id   BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    user_id        BIGINT UNSIGNED  NOT NULL,          -- feed owner
    source_user_id BIGINT UNSIGNED  NOT NULL,          -- who posted
    meal_log_id    BIGINT UNSIGNED  NOT NULL,
    feed_score     DECIMAL(8,4)     NOT NULL DEFAULT 0.0000,
    is_dismissed   BOOLEAN          NOT NULL DEFAULT FALSE,
    expires_at     DATETIME,
    PRIMARY KEY (feed_item_id),
    KEY idx_feed_ranked          (user_id, feed_score DESC),
    KEY fk_feed_source_user_idx  (source_user_id),
    KEY fk_feed_meal_log_idx     (meal_log_id),
    CONSTRAINT fk_feed_cache_user FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_feed_cache_source FOREIGN KEY (source_user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_feed_cache_meal_log FOREIGN KEY (meal_log_id)
        REFERENCES meal_logs (meal_log_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =============================================================================
-- VIEWS
-- =============================================================================

CREATE OR REPLACE VIEW vw_public_meal_cards AS
SELECT
    ml.meal_log_id,
    ml.user_id,
    u.username,
    u.display_name,
    u.avatar_url,
    mt.type_name          AS meal_type,
    ml.log_date,
    ml.log_time,
    ml.meal_name,
    ml.caption,
    ml.photo_url,
    ml.total_calories_kcal,
    ml.total_protein_g,
    ml.total_fat_g,
    ml.total_fiber_g,
    ml.total_sugar_g,
    ml.visibility,
    ml.published_at,
    mhs.overall_score,
    mhs.score_label,
    mhs.score_color_hex,
    (SELECT COUNT(*) FROM meal_post_reactions r WHERE r.meal_log_id = ml.meal_log_id)  AS reaction_count,
    (SELECT COUNT(*) FROM meal_post_comments  c WHERE c.meal_log_id = ml.meal_log_id
                                                  AND c.is_deleted = FALSE)             AS comment_count
FROM meal_logs ml
JOIN users               u   ON u.user_id      = ml.user_id
JOIN meal_types          mt  ON mt.meal_type_id = ml.meal_type_id
LEFT JOIN meal_health_scores mhs ON mhs.meal_log_id = ml.meal_log_id
WHERE ml.is_published = TRUE
  AND ml.is_deleted   = FALSE
  AND u.is_banned     = FALSE
  AND u.deleted_at    IS NULL;

-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_daily_leaderboard AS
SELECT
    dhs.score_date,
    dhs.user_id,
    u.username,
    u.display_name,
    u.avatar_url,
    dhs.overall_score,
    dhs.score_label,
    dhs.community_rank,
    dhs.community_percentile,
    uls.current_streak_days,
    ds.total_meals_logged,
    ds.total_calories_kcal
FROM daily_health_scores dhs
JOIN users                u   ON u.user_id  = dhs.user_id
LEFT JOIN user_logging_streaks uls ON uls.user_id = dhs.user_id
LEFT JOIN daily_summaries      ds  ON ds.user_id  = dhs.user_id
                                  AND ds.summary_date = dhs.score_date
WHERE u.is_banned   = FALSE
  AND u.deleted_at  IS NULL
ORDER BY dhs.score_date DESC, dhs.overall_score DESC;


-- =============================================================================
-- STORED PROCEDURES
-- =============================================================================

DELIMITER $$

-- Recalculates and upserts daily_summaries for a given user + date.
-- Called by the application after every meal save / update / delete.
DROP PROCEDURE IF EXISTS usp_refresh_daily_summary;
CREATE PROCEDURE usp_refresh_daily_summary(
    IN p_user_id   BIGINT UNSIGNED,
    IN p_log_date  DATE
)
BEGIN
    INSERT INTO daily_summaries (
        user_id,
        summary_date,
        total_meals_logged,
        total_calories_kcal,
        total_protein_g,
        total_carbohydrate_g,
        total_fiber_g,
        total_sugar_g,
        total_sodium_mg
    )
    SELECT
        p_user_id,
        p_log_date,
        COUNT(*)                    AS total_meals_logged,
        COALESCE(SUM(total_calories_kcal), 0) AS total_calories_kcal,
        COALESCE(SUM(total_protein_g),     0) AS total_protein_g,
        -- total_carbohydrate_g is not stored on meal_logs; derive via items if needed.
        -- Using total_fiber_g as a proxy carb placeholder until a carbs column is added.
        0.000                       AS total_carbohydrate_g,
        COALESCE(SUM(total_fiber_g),  0) AS total_fiber_g,
        COALESCE(SUM(total_sugar_g),  0) AS total_sugar_g,
        COALESCE(SUM(total_sodium_mg),0) AS total_sodium_mg
    FROM meal_logs
    WHERE user_id   = p_user_id
      AND log_date  = p_log_date
      AND is_deleted = FALSE
    ON DUPLICATE KEY UPDATE
        total_meals_logged   = VALUES(total_meals_logged),
        total_calories_kcal  = VALUES(total_calories_kcal),
        total_protein_g      = VALUES(total_protein_g),
        total_carbohydrate_g = VALUES(total_carbohydrate_g),
        total_fiber_g        = VALUES(total_fiber_g),
        total_sugar_g        = VALUES(total_sugar_g),
        total_sodium_mg      = VALUES(total_sodium_mg);
END$$

-- ---------------------------------------------------------------------------
-- Maintains user_logging_streaks for a given user + log date.
-- Increments current_streak if log_date is exactly 1 day after last_logged_date;
-- resets to 1 if the gap is > 1 day.
DELIMITER $$
DROP PROCEDURE IF EXISTS usp_update_streak $$
CREATE PROCEDURE usp_update_streak(
    IN p_user_id   BIGINT UNSIGNED,
    IN p_log_date  DATE
)
BEGIN
    DECLARE v_last_date   DATE;
    DECLARE v_current     INT UNSIGNED DEFAULT 0;
    DECLARE v_longest     INT UNSIGNED DEFAULT 0;
    DECLARE v_total       INT UNSIGNED DEFAULT 0;

    SELECT last_logged_date,
           current_streak_days,
           longest_streak_days,
           total_logged_days
    INTO   v_last_date, v_current, v_longest, v_total
    FROM   user_logging_streaks
    WHERE  user_id = p_user_id
    FOR UPDATE;

    IF v_last_date IS NULL THEN
        -- First ever log
        INSERT INTO user_logging_streaks
            (user_id, current_streak_days, longest_streak_days,
             last_logged_date, streak_started_date, total_logged_days)
        VALUES
            (p_user_id, 1, 1, p_log_date, p_log_date, 1)
        ON DUPLICATE KEY UPDATE
            current_streak_days = 1,
            longest_streak_days = GREATEST(longest_streak_days, 1),
            last_logged_date    = p_log_date,
            streak_started_date = p_log_date,
            total_logged_days   = total_logged_days + 1;

    ELSEIF DATEDIFF(p_log_date, v_last_date) = 1 THEN
        -- Consecutive day — increment streak
        UPDATE user_logging_streaks
        SET    current_streak_days = v_current + 1,
               longest_streak_days = GREATEST(v_longest, v_current + 1),
               last_logged_date    = p_log_date,
               total_logged_days   = v_total + 1
        WHERE  user_id = p_user_id;

    ELSEIF DATEDIFF(p_log_date, v_last_date) > 1 THEN
        -- Gap — reset streak
        UPDATE user_logging_streaks
        SET    current_streak_days = 1,
               streak_started_date = p_log_date,
               last_logged_date    = p_log_date,
               total_logged_days   = v_total + 1
        WHERE  user_id = p_user_id;

    END IF;
    -- DATEDIFF = 0 means same day (already logged today) — no-op
END$$
-- =============================================================================
-- TRIGGERS
-- =============================================================================

-- Fan-out feed cache on meal publish
DELIMITER $$
DROP TRIGGER IF EXISTS trg_after_meal_log_publish $$
CREATE TRIGGER trg_after_meal_log_publish
AFTER UPDATE ON meal_logs
FOR EACH ROW
BEGIN
    -- Fire only when is_published flips FALSE → TRUE
    IF OLD.is_published = FALSE AND NEW.is_published = TRUE THEN
        INSERT INTO user_feed_cache (user_id, source_user_id, meal_log_id, feed_score)
        SELECT uf.follower_id,
               NEW.user_id,
               NEW.meal_log_id,
               0.0000
        FROM   user_follows uf
        WHERE  uf.following_id = NEW.user_id
          AND  uf.status = 'ACCEPTED';
    END IF;
END $$
DELIMITER ;
-- ---------------------------------------------------------------------------

-- Roll up item nutrition totals onto parent meal_logs row
DELIMITER $$
DROP TRIGGER IF EXISTS trg_after_meal_item_insert $$
CREATE TRIGGER trg_after_meal_item_insert
AFTER INSERT ON meal_log_items
FOR EACH ROW
BEGIN
    UPDATE meal_logs
    SET    total_calories_kcal = total_calories_kcal + NEW.calories_kcal,
           total_protein_g     = total_protein_g     + NEW.protein_g,
           total_fat_g         = total_fat_g         + NEW.total_fat_g,
           total_fiber_g       = total_fiber_g       + NEW.fiber_g,
           total_sugar_g       = total_sugar_g       + NEW.sugar_g,
           total_sodium_mg     = total_sodium_mg     + NEW.sodium_mg
    WHERE  meal_log_id = NEW.meal_log_id;
END $$
DELIMITER ;


-- =============================================================================
SET foreign_key_checks = 1;
-- End of HealthBite-AI DDL
-- =============================================================================
-- ============================================================================= -- TRIGGERS -- =============================================================================  -- Fan-out feed cache on meal publish CREATE TRIGGER trg_after_meal_log_publish AFTER UPDATE ON meal_logs FOR EACH ROW BEGIN     -- Fire only when is_published flips FALSE → TRUE     IF OLD.is_published = FALSE AND NEW.is_published = TRUE THEN         INSERT INTO user_feed_cache (user_id, source_user_id, meal_log_id, feed_score)         SELECT uf.follower_id,                NEW.user_id,                NEW.meal_log_id,                0.0000         FROM   user_follows uf         WHERE  uf.following_id = NEW.user_id           AND  uf.status = 'ACCEPTED'
