-- =============================================================================
-- HealthBite-AI — Sample Data (5 Users, Fully Varied Results)
-- =============================================================================
-- Users:
--   1. Aryan Sharma    — Fitness enthusiast, Lose Weight goal, HIGH scorer
--   2. Priya Mehta     — Vegetarian, Build Muscle goal, MODERATE scorer
--   3. Ravi Kumar      — Keto diet, Maintain Weight goal, GOOD scorer
--   4. Sneha Patel     — Vegan, Improve Energy goal, LOW scorer
--   5. Kabir Singh     — Diabetic-aware, Heart Health goal, FAIR scorer
-- =============================================================================
USE healthbite4;
SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- =============================================================================
-- SECTION 1 — LOOKUP / REFERENCE DATA
-- =============================================================================

INSERT INTO gender_types (gender_id, gender_name, gender_code, is_active) VALUES
(1, 'Male',           'M', TRUE),
(2, 'Female',         'F', TRUE),
(3, 'Other',          'O', TRUE),
(4, 'Prefer Not Say', 'P', TRUE);
select* from gender_types;

-- ---------------------------------------------------------------------------

INSERT INTO activity_levels (activity_level_id, level_name, level_code, multiplier_factor, description, sort_order, is_active) VALUES
(1, 'Sedentary',       'SEDENTARY',        1.20, 'Little or no exercise',                      1, TRUE),
(2, 'Lightly Active',  'LIGHTLY_ACTIVE',   1.37, 'Light exercise 1-3 days/week',               2, TRUE),
(3, 'Moderately Active','MODERATELY_ACTIVE',1.55, 'Moderate exercise 3-5 days/week',            3, TRUE),
(4, 'Very Active',     'VERY_ACTIVE',      1.72, 'Hard exercise 6-7 days/week',                4, TRUE),
(5, 'Extra Active',    'EXTRA_ACTIVE',     1.90, 'Very hard exercise and physical job',         5, TRUE);
select* from activity_levels;
-- ---------------------------------------------------------------------------

INSERT INTO dietary_preference_types (preference_id, preference_name, preference_code, description, is_active) VALUES
(1, 'Vegetarian',    'VEGETARIAN',  'No meat or fish',                     TRUE),
(2, 'Vegan',         'VEGAN',       'No animal products at all',           TRUE),
(3, 'Keto',          'KETO',        'High fat, very low carbohydrate',     TRUE),
(4, 'Halal',         'HALAL',       'Islamically permissible food',        TRUE),
(5, 'Gluten Free',   'GLUTEN_FREE', 'No gluten-containing grains',         TRUE),
(6, 'Diabetic Safe', 'DIABETIC',    'Low glycemic index foods',            TRUE);
select* from dietary_preference_types;
-- ---------------------------------------------------------------------------

INSERT INTO health_goal_types (goal_type_id, goal_name, goal_code, description, is_active) VALUES
(1, 'Lose Weight',     'LOSE_WEIGHT',     'Reduce body weight and fat percentage',       TRUE),
(2, 'Build Muscle',    'BUILD_MUSCLE',    'Increase lean muscle mass',                   TRUE),
(3, 'Maintain Weight', 'MAINTAIN_WEIGHT', 'Keep current body weight stable',             TRUE),
(4, 'Improve Energy',  'IMPROVE_ENERGY',  'Boost daily energy and reduce fatigue',       TRUE),
(5, 'Heart Health',    'HEART_HEALTH',    'Improve cardiovascular health markers',       TRUE);
select* from health_goal_types;
-- ---------------------------------------------------------------------------

INSERT INTO meal_types (meal_type_id, type_name, type_code, sort_order, is_active) VALUES
(1, 'Breakfast', 'BREAKFAST', 1, TRUE),
(2, 'Lunch',     'LUNCH',     2, TRUE),
(3, 'Dinner',    'DINNER',    3, TRUE),
(4, 'Snack',     'SNACK',     4, TRUE),
(5, 'Pre-Workout','PRE_WORKOUT',5,TRUE);
select* from meal_types;
-- ---------------------------------------------------------------------------

INSERT INTO entry_method_types (method_id, method_name, method_code, is_active) VALUES
(1, 'Manual Entry', 'MANUAL',  TRUE),
(2, 'Text Input',   'TEXT',    TRUE),
(3, 'Voice Input',  'VOICE',   TRUE),
(4, 'Photo Scan',   'PHOTO',   TRUE),
(5, 'Barcode Scan', 'BARCODE', TRUE);
select* from entry_method_types;
-- ---------------------------------------------------------------------------

INSERT INTO reaction_types (reaction_type_id, reaction_name, reaction_emoji, reaction_code, sort_order) VALUES
(1, 'Healthy',    '🥗', 'HEALTHY',    1),
(2, 'Love It',    '❤️', 'LOVE_IT',    2),
(3, 'Fire',       '🔥', 'FIRE',       3),
(4, 'Inspiring',  '💪', 'INSPIRING',  4),
(5, 'Yummy',      '😋', 'YUMMY',      5);
select* from reaction_types;
-- ---------------------------------------------------------------------------

INSERT INTO notification_types (notification_type_id, type_name, type_code, description) VALUES
(1, 'New Reaction',        'NEW_REACTION',        'Someone reacted to your meal post'),
(2, 'New Comment',         'NEW_COMMENT',         'Someone commented on your meal post'),
(3, 'New Follower',        'NEW_FOLLOWER',         'Someone started following you'),
(4, 'Badge Earned',        'BADGE_EARNED',         'You earned a new achievement badge'),
(5, 'Streak Milestone',    'STREAK_MILESTONE',     'You hit a logging streak milestone'),
(6, 'Challenge Joined',    'CHALLENGE_JOINED',     'You were added to a challenge'),
(7, 'Daily Score Ready',   'DAILY_SCORE_READY',    'Your daily health score is ready');
select* from notification_types;
-- ---------------------------------------------------------------------------

INSERT INTO report_reason_types (reason_id, reason_name, reason_code, is_active) VALUES
(1, 'Spam',                 'SPAM',         TRUE),
(2, 'Harassment',           'HARASSMENT',   TRUE),
(3, 'Misinformation',       'MISINFORMATION',TRUE),
(4, 'Inappropriate Content','INAPPROPRIATE', TRUE),
(5, 'Fake Account',         'FAKE_ACCOUNT', TRUE);
select* from report_reason_types;
-- ---------------------------------------------------------------------------

INSERT INTO badge_types (badge_type_id, badge_name, badge_code, description, criteria_json, is_active) VALUES
(1, '7-Day Streak',     'STREAK_7',    'Logged meals 7 days in a row',    '{"streak_days":7}',   TRUE),
(2, '30-Day Streak',    'STREAK_30',   'Logged meals 30 days in a row',   '{"streak_days":30}',  TRUE),
(3, 'First Meal',       'FIRST_MEAL',  'Logged your very first meal',     '{"meals":1}',         TRUE),
(4, 'Perfect Score',    'PERFECT_100', 'Achieved a 100/100 health score', '{"score":100}',       TRUE),
(5, 'Social Butterfly', 'SOCIAL_50',   'Received 50 reactions on posts',  '{"reactions":50}',    TRUE);
select* from badge_types;

-- =============================================================================
-- SECTION 2 — USERS (5 different users)
-- =============================================================================
-- Passwords below are bcrypt hashes of 'Password@123' (for demo only)

INSERT INTO users (user_id, username, email, phone_number, password_hash, password_salt,
                   gender_id, date_of_birth, full_name, display_name, bio,
                   timezone, locale, is_email_verified, is_active, is_banned,
                   last_login_at, created_at) VALUES

(1, 'aryan_sharma',  'aryan.sharma@email.com',  '+919876543210',
   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO.XFvO5ZFrqJQRFqJQRFqJQRFqJQRFqJ',
   'salt_aryan_01',
   1, '1995-03-15', 'Aryan Sharma',  'Aryan 💪',
   'Fitness freak. Love clean eating. On a weight loss journey!',
   'Asia/Kolkata', 'en-IN', TRUE, TRUE, FALSE,
   '2026-03-28 07:30:00', '2025-06-01 10:00:00'),

(2, 'priya_mehta',   'priya.mehta@email.com',   '+919812345678',
   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO.XFvO5ZFrqJQRFqJQRFqJQRFqJQRFqJ',
   'salt_priya_02',
   2, '1998-07-22', 'Priya Mehta',   'Priya 🌿',
   'Vegetarian foodie. Building muscle the plant-based way 🌱',
   'Asia/Kolkata', 'en-IN', TRUE, TRUE, FALSE,
   '2026-03-28 08:15:00', '2025-08-10 09:30:00'),

(3, 'ravi_kumar',    'ravi.kumar@email.com',    '+919923456789',
   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO.XFvO5ZFrqJQRFqJQRFqJQRFqJQRFqJ',
   'salt_ravi_03',
   1, '1990-11-05', 'Ravi Kumar',    'Ravi 🥩',
   'Strict keto since 2024. Maintaining my ideal weight. Loving it!',
   'Asia/Kolkata', 'hi-IN', TRUE, TRUE, FALSE,
   '2026-03-28 06:45:00', '2025-05-20 08:00:00'),

(4, 'sneha_patel',   'sneha.patel@email.com',   '+919734567890',
   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO.XFvO5ZFrqJQRFqJQRFqJQRFqJQRFqJ',
   'salt_sneha_04',
   2, '2001-01-30', 'Sneha Patel',   'Sneha 🌻',
   '100% Vegan. Still figuring out my nutrition. Getting there!',
   'Asia/Kolkata', 'en-IN', FALSE, TRUE, FALSE,
   '2026-03-27 21:00:00', '2026-01-15 11:00:00'),

(5, 'kabir_singh',   'kabir.singh@email.com',   '+919645678901',
   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO.XFvO5ZFrqJQRFqJQRFqJQRFqJQRFqJ',
   'salt_kabir_05',
   1, '1975-09-18', 'Kabir Singh',   'Kabir ❤️',
   'Managing type-2 diabetes through diet. Heart health is my priority.',
   'Asia/Kolkata', 'en-IN', TRUE, TRUE, FALSE,
   '2026-03-28 09:00:00', '2025-03-01 07:00:00');
select* from users;
-- ---------------------------------------------------------------------------
-- User OAuth Providers
-- ---------------------------------------------------------------------------

INSERT INTO user_auth_providers (auth_provider_id, user_id, provider_name, provider_user_id, token_expires_at) VALUES
(1, 1, 'google',   'google_uid_aryan_001',  '2026-04-28 07:30:00'),
(2, 2, 'google',   'google_uid_priya_002',  '2026-04-28 08:15:00'),
(3, 3, 'facebook', 'fb_uid_ravi_003',       '2026-04-28 06:45:00'),
(4, 4, 'apple',    'apple_uid_sneha_004',   '2026-04-27 21:00:00'),
(5, 5, 'google',   'google_uid_kabir_005',  '2026-04-28 09:00:00');
select* from user_auth_providers;
-- ---------------------------------------------------------------------------
-- User Health Profiles (all different biometrics)
-- ---------------------------------------------------------------------------

INSERT INTO user_health_profiles (profile_id, user_id, height_cm, weight_kg, target_weight_kg,
                                   activity_level_id, bmr_kcal, tdee_kcal, bmi,
                                   body_fat_pct, medical_conditions, allergies) VALUES
-- Aryan: 28yr male, 178cm, 88kg → target 75kg, Very Active
(1, 1, 178.0, 88.00, 75.00, 4, 1923.00, 3307.56, 27.8, 22.5,
   '[]', '["peanuts"]'),

-- Priya: 27yr female, 162cm, 58kg → target 63kg (build muscle), Moderately Active
(2, 2, 162.0, 58.00, 63.00, 3, 1398.00, 2166.90, 22.1, 18.2,
   '[]', '[]'),

-- Ravi: 35yr male, 175cm, 80kg → maintain 80kg, Lightly Active
(3, 3, 175.0, 80.00, 80.00, 2, 1837.00, 2516.69, 26.1, 19.8,
   '[]', '["shellfish"]'),

-- Sneha: 25yr female, 155cm, 50kg → target 52kg, Sedentary
(4, 4, 155.0, 50.00, 52.00, 1, 1271.00, 1525.20, 20.8, 16.5,
   '[]', '["dairy"]'),

-- Kabir: 50yr male, 170cm, 78kg → target 72kg, Lightly Active, diabetic
(5, 5, 170.0, 78.00, 72.00, 2, 1672.00, 2290.64, 27.0, 24.0,
   '["type_2_diabetes","hypertension"]', '[]');
select* from user_health_profiles;
-- ---------------------------------------------------------------------------
-- User Health Goals
-- ---------------------------------------------------------------------------

INSERT INTO user_health_goals (user_goal_id, user_id, goal_type_id, is_primary,
                                target_value, target_date, is_achieved) VALUES
(1, 1, 1, TRUE,  75.00, '2026-09-01', FALSE),  -- Aryan: Lose Weight
(2, 2, 2, TRUE,  63.00, '2026-12-01', FALSE),  -- Priya: Build Muscle
(3, 3, 3, TRUE,  80.00, '2026-12-31', FALSE),  -- Ravi: Maintain Weight
(4, 4, 4, TRUE,  NULL,  '2026-06-01', FALSE),  -- Sneha: Improve Energy
(5, 5, 5, TRUE,  72.00, '2026-10-01', FALSE);  -- Kabir: Heart Health
select* from user_health_goals;
-- ---------------------------------------------------------------------------
-- User Dietary Preferences
-- ---------------------------------------------------------------------------

INSERT INTO user_dietary_preferences (user_pref_id, user_id, preference_id) VALUES
(1, 2, 1),  -- Priya: Vegetarian
(2, 3, 3),  -- Ravi: Keto
(3, 4, 2),  -- Sneha: Vegan
(4, 5, 6),  -- Kabir: Diabetic Safe
(5, 5, 5);  -- Kabir: also Gluten Free
select* from user_dietary_preferences;
-- ---------------------------------------------------------------------------
-- User Daily Nutrition Targets (each user has different macro targets)
-- ---------------------------------------------------------------------------

INSERT INTO user_daily_nutrition_targets (target_id, user_id, effective_date,
    calories_kcal, protein_g, carbohydrate_g, fat_g, fiber_g, sugar_g,
    sodium_mg, water_ml, vitamin_c_mg, vitamin_d_iu, is_ai_generated) VALUES
-- Aryan: caloric deficit for weight loss
(1, 1, '2026-03-28', 2200.00, 180.00, 200.00, 70.00, 35.00, 30.00, 2000.00, 3000.00, 90.00, 600.00, TRUE),
-- Priya: muscle gain — high protein
(2, 2, '2026-03-28', 2400.00, 160.00, 280.00, 75.00, 30.00, 40.00, 2200.00, 2800.00, 90.00, 800.00, TRUE),
-- Ravi: keto — very low carb, high fat
(3, 3, '2026-03-28', 2500.00, 150.00,  50.00,190.00, 20.00, 10.00, 2300.00, 2500.00, 90.00, 600.00, TRUE),
-- Sneha: light maintenance
(4, 4, '2026-03-28', 1600.00,  60.00, 200.00, 55.00, 28.00, 45.00, 1800.00, 2200.00,120.00, 600.00, FALSE),
-- Kabir: diabetic — controlled carbs, heart-healthy
(5, 5, '2026-03-28', 1900.00, 110.00, 160.00, 65.00, 38.00, 20.00, 1500.00, 2700.00, 90.00, 800.00, TRUE);
select* from user_daily_nutrition_targets;
-- ---------------------------------------------------------------------------
-- User Privacy Settings
-- ---------------------------------------------------------------------------

INSERT INTO user_privacy_settings (privacy_id, user_id, profile_visibility,
    meal_default_visibility, score_visibility, allow_friend_requests,
    show_in_community_feed, show_in_leaderboards, allow_reactions,
    allow_comments, email_notifications, push_notifications) VALUES
(1, 1, 'PUBLIC',  'PUBLIC',  'PUBLIC',  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE),
(2, 2, 'PUBLIC',  'FRIENDS', 'PUBLIC',  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE),
(3, 3, 'FRIENDS', 'FRIENDS', 'PRIVATE', FALSE, FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE),
(4, 4, 'PUBLIC',  'PUBLIC',  'PUBLIC',  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE),
(5, 5, 'PRIVATE', 'PRIVATE', 'PRIVATE', FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE);
select* from user_privacy_settings;

-- =============================================================================
-- SECTION 3 — FOOD CATALOGUE
-- =============================================================================

INSERT INTO food_categories (category_id, parent_category_id, category_name, category_code, sort_order) VALUES
(1, NULL, 'Grains & Cereals',  'GRAINS',    1),
(2, NULL, 'Proteins',          'PROTEINS',  2),
(3, NULL, 'Dairy',             'DAIRY',     3),
(4, NULL, 'Fruits',            'FRUITS',    4),
(5, NULL, 'Vegetables',        'VEGETABLES',5),
(6, NULL, 'Fats & Oils',       'FATS',      6),
(7, NULL, 'Beverages',         'BEVERAGES', 7);
select* from food_categories;
-- ---------------------------------------------------------------------------
-- Food Items (nutrition values per 100g)
-- ---------------------------------------------------------------------------

INSERT INTO food_items (food_id, category_id, food_name, food_name_local,
    serving_size_g, calories_kcal, protein_g, total_fat_g, saturated_fat_g,
    total_carbohydrate_g, dietary_fiber_g, total_sugars_g, added_sugars_g,
    sodium_mg, potassium_mg, vitamin_c_mg, vitamin_d_iu, omega3_g,
    glycemic_index, data_source, is_verified, is_user_created) VALUES

(1,  1, 'Brown Rice',         'Bhura Chawal',  100, 367.00, 7.900, 2.920, 0.580, 77.240, 3.500, 0.850, 0.000,  7.000, 223.000,  0.000,   0.000, 0.027, 50, 'USDA', TRUE,  FALSE),
(2,  2, 'Chicken Breast',     'Murgi ka Seena',100, 165.00,31.000, 3.600, 1.010,  0.000, 0.000, 0.000, 0.000, 74.000, 256.000,  0.000,   4.000, 0.062,  0, 'USDA', TRUE,  FALSE),
(3,  3, 'Greek Yogurt',       'Dahi',          100,  59.00, 9.900, 0.390, 0.260,  3.600, 0.000, 3.200, 0.000, 36.000, 141.000,  0.000,   0.000, 0.000, 11, 'USDA', TRUE,  FALSE),
(4,  4, 'Banana',             'Kela',          100,  89.00, 1.090, 0.330, 0.112, 22.840, 2.600,12.230, 0.000,  1.000, 358.000,  8.700,   0.000, 0.027,51, 'USDA', TRUE,  FALSE),
(5,  5, 'Spinach',            'Palak',         100,  23.00, 2.860, 0.390, 0.063,  3.630, 2.200, 0.420, 0.000, 79.000, 558.000, 28.100,   0.000, 0.138,15, 'USDA', TRUE,  FALSE),
(6,  2, 'Paneer',             'Paneer',        100, 265.00,18.300,20.800,13.000,  1.200, 0.000, 1.200, 0.000, 30.000, 110.000,  0.000,   0.000, 0.000, 27,'USDA', TRUE,  FALSE),
(7,  6, 'Avocado',            'Makhanphal',    100, 160.00, 2.000,14.660, 2.126,  8.530, 6.700, 0.660, 0.000,  7.000, 485.000, 10.000,   0.000, 0.111,15, 'USDA', TRUE,  FALSE),
(8,  1, 'Oats',               'Jaie',          100, 389.00,16.890, 6.900, 1.217, 66.270,10.600, 0.000, 0.000,  2.000, 429.000,  0.000,   0.000, 0.111,55, 'USDA', TRUE,  FALSE),
(9,  2, 'Eggs (whole)',       'Anda',          100, 143.00,12.560, 9.510, 3.126,  0.720, 0.000, 0.370, 0.000,142.000, 126.000,  0.000,  87.000, 0.036,  0, 'USDA', TRUE,  FALSE),
(10, 7, 'Black Coffee',       'Black Coffee',  100,   2.00, 0.280, 0.000, 0.000,  0.000, 0.000, 0.000, 0.000,  4.000,  92.000,  0.000,   0.000, 0.000,  0, 'USDA', TRUE,  FALSE),
(11, 5, 'Broccoli',           'Hari Phool Gobhi',100, 34.00, 2.820, 0.370, 0.039,  6.640, 2.600, 1.700, 0.000, 33.000, 316.000, 89.200,   0.000, 0.049,10, 'USDA', TRUE,  FALSE),
(12, 2, 'Almonds',            'Badam',         100, 579.00,21.150,49.930, 3.802, 21.550,12.500, 4.350, 0.000,  1.000, 705.000,  0.000,   0.000, 0.003, 0, 'USDA', TRUE,  FALSE),
(13, 1, 'White Rice',         'Safed Chawal',  100, 365.00, 7.130, 0.660, 0.184, 80.000, 1.300, 0.120, 0.000,  1.000,  35.000,  0.000,   0.000, 0.018,73, 'USDA', TRUE,  FALSE),
(14, 4, 'Apple',              'Seb',           100,  52.00, 0.260, 0.170, 0.028, 13.810, 2.400,10.390, 0.000,  1.000, 107.000,  4.600,   0.000, 0.009,36, 'USDA', TRUE,  FALSE),
(15, 3, 'Full Fat Milk',      'Doodh',         100,  61.00, 3.200, 3.270, 1.865,  4.800, 0.000, 5.050, 0.000, 44.000, 150.000,  0.500,  40.000, 0.072,31, 'USDA', TRUE,  FALSE);
select* from food_items;

-- =============================================================================
-- SECTION 4 — MEAL LOGS (each user has 2 meals on 2026-03-28)
-- =============================================================================

INSERT INTO meal_logs (meal_log_id, user_id, meal_type_id, entry_method_id,
    log_date, log_time, meal_name, description,
    total_calories_kcal, total_protein_g, total_fat_g, total_fiber_g, total_sugar_g, total_sodium_mg,
    visibility, is_published, published_at, caption, is_flagged, is_deleted) VALUES

-- Aryan (user 1): Breakfast + Lunch — high protein, balanced
(1,  1, 1, 4, '2026-03-28', '07:30:00', 'Morning Power Bowl',
    'Oats with eggs and banana — pre-gym fuel',
    420.00, 28.500, 11.200, 6.800, 14.500, 168.000,
    'PUBLIC', TRUE, '2026-03-28 07:45:00', 'Starting the day right 💪 #FitLife', FALSE, FALSE),

(2,  1, 2, 2, '2026-03-28', '13:00:00', 'Protein Lunch',
    'Grilled chicken breast with brown rice and broccoli',
    510.00, 45.200,  8.100, 6.200,  2.100, 130.000,
    'PUBLIC', TRUE, '2026-03-28 13:15:00', 'Clean eating never looked this good 🥗', FALSE, FALSE),

-- Priya (user 2): Breakfast + Dinner — vegetarian, muscle building
(3,  2, 1, 1, '2026-03-28', '08:00:00', 'Veggie Protein Breakfast',
    'Paneer bhurji with oats and greek yogurt',
    540.00, 35.700, 22.400, 4.500,  5.800,  98.000,
    'FRIENDS', TRUE, '2026-03-28 08:20:00', 'Plant-powered mornings 🌱', FALSE, FALSE),

(4,  2, 3, 1, '2026-03-28', '20:00:00', 'Spinach Paneer Dinner',
    'Palak paneer with brown rice',
    480.00, 22.100, 18.900, 5.100,  2.300,  95.000,
    'FRIENDS', TRUE, '2026-03-28 20:15:00', 'Comfort food that fuels gains 💚', FALSE, FALSE),

-- Ravi (user 3): Breakfast + Dinner — strict keto, low carb
(5,  3, 1, 2, '2026-03-28', '09:00:00', 'Keto Egg Bowl',
    'Scrambled eggs with avocado and almonds',
    520.00, 18.300, 44.600, 8.900,  1.200,  98.000,
    'FRIENDS', TRUE, '2026-03-28 09:20:00', 'Keto breakfast done right 🥑🥚', FALSE, FALSE),

(6,  3, 3, 1, '2026-03-28', '19:30:00', 'Keto Chicken Dinner',
    'Chicken breast with spinach and avocado salad',
    440.00, 38.500, 22.700, 7.300,  1.100, 115.000,
    'FRIENDS', FALSE, NULL, NULL, FALSE, FALSE),

-- Sneha (user 4): Breakfast + Lunch — vegan, lower calories
(7,  4, 1, 3, '2026-03-28', '09:30:00', 'Vegan Morning Smoothie Bowl',
    'Banana oat smoothie with almonds on top',
    390.00, 10.200, 14.700,12.100, 18.200,  12.000,
    'PUBLIC', TRUE, '2026-03-28 09:45:00', 'Keeping it plant-based and yummy 🍌', FALSE, FALSE),

(8,  4, 2, 3, '2026-03-28', '14:00:00', 'Vegan Lunch Bowl',
    'Brown rice with spinach and broccoli stir fry',
    320.00,  9.800,  4.200, 9.500,  3.100,  95.000,
    'PUBLIC', TRUE, '2026-03-28 14:15:00', 'Simple vegan lunch 🌿', FALSE, FALSE),

-- Kabir (user 5): Breakfast + Dinner — diabetic safe, heart healthy
(9,  5, 1, 1, '2026-03-28', '07:00:00', 'Diabetic Safe Breakfast',
    'Oats with apple slices and black coffee',
    310.00,  8.700,  4.100, 11.200, 11.500, 28.000,
    'PRIVATE', FALSE, NULL, NULL, FALSE, FALSE),

(10, 5, 3, 1, '2026-03-28', '19:00:00', 'Heart Healthy Dinner',
    'Grilled chicken with steamed broccoli and spinach salad',
    380.00, 36.200,  8.400, 8.700,  2.200, 118.000,
    'PRIVATE', FALSE, NULL, NULL, FALSE, FALSE);
select* from meal_logs;
-- ---------------------------------------------------------------------------
-- Meal Log Items (line items for each meal)
-- ---------------------------------------------------------------------------

INSERT INTO meal_log_items (item_id, meal_log_id, food_id, quantity_g, quantity_unit,
    calories_kcal, protein_g, total_fat_g, carbohydrate_g, fiber_g, sugar_g, sodium_mg,
    ai_identified, ai_confidence) VALUES

-- Meal 1 (Aryan Breakfast): Oats 80g + Eggs 100g + Banana 100g
(1,  1,  8,  80.00, 'g', 311.20, 13.511, 5.520, 53.016, 8.480,  0.000, 1.600, TRUE,  0.940),
(2,  1,  9, 100.00, 'g', 143.00, 12.560, 9.510,  0.720, 0.000,  0.370,142.000, TRUE, 0.960),
(3,  1,  4, 100.00, 'g',  89.00,  1.090, 0.330, 22.840, 2.600, 12.230,  1.000, FALSE,NULL),

-- Meal 2 (Aryan Lunch): Chicken 150g + Brown Rice 120g + Broccoli 100g
(4,  2,  2, 150.00, 'g', 247.50, 46.500, 5.400,  0.000, 0.000,  0.000,111.000, FALSE,NULL),
(5,  2,  1, 120.00, 'g', 440.40,  9.480, 3.504, 92.688, 4.200,  1.020,  8.400, FALSE,NULL),
(6,  2, 11, 100.00, 'g',  34.00,  2.820, 0.370,  6.640, 2.600,  1.700, 33.000, FALSE,NULL),

-- Meal 3 (Priya Breakfast): Paneer 100g + Oats 80g + Greek Yogurt 80g
(7,  3,  6, 100.00, 'g', 265.00, 18.300,20.800,  1.200, 0.000,  1.200, 30.000, FALSE,NULL),
(8,  3,  8,  80.00, 'g', 311.20, 13.511, 5.520, 53.016, 8.480,  0.000,  1.600, FALSE,NULL),
(9,  3,  3,  80.00, 'g',  47.20,  7.920, 0.312,  2.880, 0.000,  2.560, 28.800, FALSE,NULL),

-- Meal 4 (Priya Dinner): Paneer 80g + Brown Rice 100g + Spinach 80g
(10, 4,  6,  80.00, 'g', 212.00, 14.640,16.640,  0.960, 0.000,  0.960, 24.000, FALSE,NULL),
(11, 4,  1, 100.00, 'g', 367.00,  7.900, 2.920, 77.240, 3.500,  0.850,  7.000, FALSE,NULL),
(12, 4,  5,  80.00, 'g',  18.40,  2.288, 0.312,  2.904, 1.760,  0.336, 63.200, FALSE,NULL),

-- Meal 5 (Ravi Breakfast): Eggs 150g + Avocado 100g + Almonds 30g
(13, 5,  9, 150.00, 'g', 214.50, 18.840,14.265,  1.080, 0.000,  0.555,213.000, FALSE,NULL),
(14, 5,  7, 100.00, 'g', 160.00,  2.000,14.660,  8.530, 6.700,  0.660,  7.000, FALSE,NULL),
(15, 5, 12,  30.00, 'g', 173.70,  6.345,14.979,  6.465, 3.750,  1.305,  0.300, FALSE,NULL),

-- Meal 6 (Ravi Dinner): Chicken 130g + Spinach 80g + Avocado 60g
(16, 6,  2, 130.00, 'g', 214.50, 40.300, 4.680,  0.000, 0.000,  0.000, 96.200, FALSE,NULL),
(17, 6,  5,  80.00, 'g',  18.40,  2.288, 0.312,  2.904, 1.760,  0.336, 63.200, FALSE,NULL),
(18, 6,  7,  60.00, 'g',  96.00,  1.200, 8.796,  5.118, 4.020,  0.396,  4.200, FALSE,NULL),

-- Meal 7 (Sneha Breakfast): Banana 120g + Oats 60g + Almonds 25g
(19, 7,  4, 120.00, 'g', 106.80,  1.308, 0.396, 27.408, 3.120, 14.676,  1.200, TRUE,  0.880),
(20, 7,  8,  60.00, 'g', 233.40, 10.134, 4.140, 39.762, 6.360,  0.000,  1.200, TRUE,  0.910),
(21, 7, 12,  25.00, 'g', 144.75,  5.288,12.483,  5.388, 3.125,  1.088,  0.250, FALSE, NULL),

-- Meal 8 (Sneha Lunch): Brown Rice 100g + Spinach 100g + Broccoli 80g
(22, 8,  1, 100.00, 'g', 367.00,  7.900, 2.920, 77.240, 3.500,  0.850,  7.000, FALSE, NULL),
(23, 8,  5, 100.00, 'g',  23.00,  2.860, 0.390,  3.630, 2.200,  0.420, 79.000, FALSE, NULL),
(24, 8, 11,  80.00, 'g',  27.20,  2.256, 0.296,  5.312, 2.080,  1.360, 26.400, FALSE, NULL),

-- Meal 9 (Kabir Breakfast): Oats 70g + Apple 100g + Black Coffee 200g
(25, 9,  8,  70.00, 'g', 272.30, 11.823, 4.830, 46.389, 7.420,  0.000,  1.400, FALSE, NULL),
(26, 9, 14, 100.00, 'g',  52.00,  0.260, 0.170, 13.810, 2.400, 10.390,  1.000, FALSE, NULL),
(27, 9, 10, 200.00, 'g',   4.00,  0.560, 0.000,  0.000, 0.000,  0.000,  8.000, FALSE, NULL),

-- Meal 10 (Kabir Dinner): Chicken 120g + Broccoli 100g + Spinach 80g
(28,10,  2, 120.00, 'g', 198.00, 37.200, 4.320,  0.000, 0.000,  0.000, 88.800, FALSE, NULL),
(29,10, 11, 100.00, 'g',  34.00,  2.820, 0.370,  6.640, 2.600,  1.700, 33.000, FALSE, NULL),
(30,10,  5,  80.00, 'g',  18.40,  2.288, 0.312,  2.904, 1.760,  0.336, 63.200, FALSE, NULL);
select* from meal_log_items;
-- ---------------------------------------------------------------------------
-- Meal Log Photos (for published meals)
-- ---------------------------------------------------------------------------

INSERT INTO meal_log_photos (photo_id, meal_log_id, photo_url, thumbnail_url,
    width_px, height_px, file_size_bytes, is_primary) VALUES
(1, 1, 'https://cdn.healthbite.ai/photos/meal_1_full.jpg',  'https://cdn.healthbite.ai/photos/meal_1_thumb.jpg',  1080, 1080, 524288, TRUE),
(2, 2, 'https://cdn.healthbite.ai/photos/meal_2_full.jpg',  'https://cdn.healthbite.ai/photos/meal_2_thumb.jpg',  1080, 1080, 612400, TRUE),
(3, 3, 'https://cdn.healthbite.ai/photos/meal_3_full.jpg',  'https://cdn.healthbite.ai/photos/meal_3_thumb.jpg',  1080,  960, 480200, TRUE),
(4, 4, 'https://cdn.healthbite.ai/photos/meal_4_full.jpg',  'https://cdn.healthbite.ai/photos/meal_4_thumb.jpg',  1080, 1080, 390500, TRUE),
(5, 5, 'https://cdn.healthbite.ai/photos/meal_5_full.jpg',  'https://cdn.healthbite.ai/photos/meal_5_thumb.jpg',  1080, 1080, 558000, TRUE),
(6, 7, 'https://cdn.healthbite.ai/photos/meal_7_full.jpg',  'https://cdn.healthbite.ai/photos/meal_7_thumb.jpg',  1080,  960, 420000, TRUE),
(7, 8, 'https://cdn.healthbite.ai/photos/meal_8_full.jpg',  'https://cdn.healthbite.ai/photos/meal_8_thumb.jpg',  1080, 1080, 385000, TRUE);
select* from meal_log_photos;
-- ---------------------------------------------------------------------------
-- Daily Summaries
-- ---------------------------------------------------------------------------

INSERT INTO daily_summaries (summary_id, user_id, summary_date,
    total_meals_logged, total_calories_kcal, total_protein_g, total_carbohydrate_g,
    total_fiber_g, total_sugar_g, total_sodium_mg, water_ml_logged,
    steps_count, sleep_hours, stress_level, mood_score) VALUES
-- Aryan: very active, high steps, great sleep
(1, 1, '2026-03-28', 2,  930.00, 73.700,  175.304, 13.000, 16.600, 298.000, 2800.00, 12500, 7.50, 3, 9),
-- Priya: good activity, moderate sleep
(2, 2, '2026-03-28', 2, 1020.00, 57.800,  137.200, 10.240,  5.056, 193.000, 2600.00,  8200, 6.50, 4, 7),
-- Ravi: keto macros, desk job low steps
(3, 3, '2026-03-28', 2,  960.00, 56.800,   24.097, 16.230,  2.252, 383.700,  2200.00, 4800, 8.00, 2, 8),
-- Sneha: low calorie, sedentary
(4, 4, '2026-03-28', 2,  710.00, 20.000,  158.749, 17.085, 28.290, 114.050, 1800.00,  3200, 5.50, 6, 5),
-- Kabir: controlled intake, decent steps
(5, 5, '2026-03-28', 2,  690.00, 44.900,   69.743, 14.180, 12.426, 194.000, 2500.00,  7500, 7.00, 5, 6);
select* from daily_summaries;

-- =============================================================================
-- SECTION 5 — HEALTH SCORE ENGINE
-- =============================================================================

INSERT INTO health_score_configs (config_id, config_name, config_version, is_active,
    weight_macros_pct, weight_micros_pct, weight_fiber_pct, weight_sugar_pct, weight_lifestyle_pct) VALUES
(1, 'Standard v2 Scoring', '2.0.0', TRUE, 30.00, 20.00, 15.00, 15.00, 20.00);
select* from health_score_configs;
-- ---------------------------------------------------------------------------
-- Meal Health Scores (5 different score profiles per spec)
-- ---------------------------------------------------------------------------

INSERT INTO meal_health_scores (score_id, meal_log_id, config_id,
    overall_score, score_label, score_color_hex,
    macro_score, micro_score, fiber_score, sugar_score, lifestyle_score,
    top_positives_json, top_negatives_json, ai_insight_text, ai_recommendation_text,
    calculated_at) VALUES

-- Aryan Breakfast: Excellent 91/100
(1, 1, 1, 91.00, 'Excellent', '4CAF50', 92.00, 88.00, 90.00, 85.00, 95.00,
   '["High protein oats combo","Good fiber intake","Natural sugars only"]',
   '["Slightly high sugar from banana"]',
   'Outstanding breakfast! Your protein-to-carb ratio is ideal for pre-workout fuelling.',
   'Consider adding a handful of mixed berries for extra antioxidants.',
   '2026-03-28 07:50:00'),

-- Aryan Lunch: Excellent 95/100
(2, 2, 1, 95.00, 'Excellent', '4CAF50', 97.00, 93.00, 88.00, 96.00, 98.00,
   '["Outstanding protein content","Excellent fiber from broccoli","Very low sugar","Lean fat profile"]',
   '["Could add healthy fats"]',
   'Perfect post-workout meal. Chicken and broccoli combination delivers maximum muscle recovery nutrients.',
   'Add half an avocado for heart-healthy monounsaturated fats.',
   '2026-03-28 13:20:00'),

-- Priya Breakfast: Good 78/100
(3, 3, 1, 78.00, 'Good', '8BC34A', 82.00, 74.00, 72.00, 78.00, 80.00,
   '["Good plant-based protein","Oats provide sustained energy"]',
   '["High saturated fat from paneer","Consider reducing portion"]',
   'Good vegetarian protein combination. Paneer and oats complement each other well.',
   'Try replacing half the paneer with tofu to reduce saturated fat intake.',
   '2026-03-28 08:25:00'),

-- Priya Dinner: Good 75/100
(4, 4, 1, 75.00, 'Good', '8BC34A', 78.00, 72.00, 70.00, 80.00, 74.00,
   '["Balanced macros","Good iron from palak"]',
   '["High fat from paneer","Moderate fiber only"]',
   'Nutritious Indian classic. Spinach adds excellent micronutrients.',
   'Add a side of cucumber raita with low-fat yogurt to improve calcium and probiotic intake.',
   '2026-03-28 20:20:00'),

-- Ravi Breakfast: Good 80/100 (keto-aligned)
(5, 5, 1, 80.00, 'Good', '8BC34A', 85.00, 76.00, 88.00, 95.00, 75.00,
   '["Near-zero net carbs","High healthy fats","Excellent fiber from avocado"]',
   '["Low micronutrients","Very low vitamin C"]',
   'Perfect keto breakfast macro split. Avocado provides excellent heart-healthy fats.',
   'Add a vitamin C supplement or a small handful of bell peppers for micronutrient balance.',
   '2026-03-28 09:25:00'),

-- Sneha Breakfast: Fair 58/100 (needs improvement)
(6, 7, 1, 58.00, 'Fair', 'FF9800', 55.00, 60.00, 72.00, 45.00, 55.00,
   '["Good fiber from oats","Natural fruit sugars"]',
   '["Very high sugar content","Low protein","Unbalanced macros"]',
   'Your breakfast is high in natural sugars. While fruits are healthy, balance is key for energy stability.',
   'Add a protein source like tofu scramble or hemp seeds to improve satiety and muscle support.',
   '2026-03-28 09:50:00'),

-- Sneha Lunch: Fair 52/100
(7, 8, 1, 52.00, 'Fair', 'FF9800', 48.00, 62.00, 80.00, 70.00, 42.00,
   '["Excellent fiber intake","Good micronutrients from vegetables"]',
   '["Very low protein","Low caloric intake","Missing healthy fats"]',
   'Your lunch is rich in fiber and micronutrients but severely lacks protein and healthy fats.',
   'Add chickpeas, lentils, or tofu to significantly boost protein. A drizzle of olive oil adds essential fats.',
   '2026-03-28 14:20:00'),

-- Kabir Breakfast: Good 72/100 (diabetic-safe)
(8, 9, 1, 72.00, 'Good', '8BC34A', 70.00, 68.00, 85.00, 75.00, 72.00,
   '["Low glycemic breakfast","Excellent fiber for blood sugar control","No added sugars"]',
   '["Low protein for age","Minimal healthy fats"]',
   'Well-controlled diabetic breakfast. Oats and apple provide slow-release energy minimising glucose spikes.',
   'Add 2 boiled eggs or a handful of walnuts to increase protein and omega-3 intake for heart health.',
   '2026-03-28 07:10:00'),

-- Kabir Dinner: Good 76/100
(9, 10, 1, 76.00, 'Good', '8BC34A', 80.00, 78.00, 82.00, 88.00, 70.00,
   '["High protein lean meal","Excellent micronutrients","Very low sugar","Heart-healthy profile"]',
   '["Low caloric density","Could add complex carbs"]',
   'Excellent heart-healthy dinner. Lean protein with vegetables is ideal for your cardiovascular goals.',
   'Consider adding a small portion of sweet potato for complex carbs and potassium to support blood pressure.',
   '2026-03-28 19:10:00');
select* from meal_health_scores;
-- ---------------------------------------------------------------------------
-- Daily Health Scores (1 per user, 2026-03-28) — very different results
-- ---------------------------------------------------------------------------

INSERT INTO daily_health_scores (daily_score_id, user_id, score_date, config_id,
    overall_score, score_label,
    macro_score, micro_score, fiber_score, sugar_score, lifestyle_score,
    calorie_pct_of_target, community_rank, community_percentile,
    is_community_highlight, ai_daily_insight) VALUES
-- Aryan: TOP scorer
(1, 1, '2026-03-28', 1, 93.00, 'Excellent', 94.00, 90.00, 89.00, 90.00, 96.00,
   42.27, 1, 99.20, TRUE,
   'Incredible day Aryan! You are in the top 1% of the community today. Your protein targets are spot on for your weight loss journey.'),

-- Priya: Good scorer, room to improve fat intake
(2, 2, '2026-03-28', 1, 76.00, 'Good',      80.00, 73.00, 71.00, 79.00, 77.00,
   42.50, 3, 82.40, FALSE,
   'Great plant-based day Priya! Your iron and calcium intake from paneer and spinach was impressive. Watch saturated fat.'),

-- Ravi: Good, keto-specific score
(3, 3, '2026-03-28', 1, 80.00, 'Good',      85.00, 72.00, 88.00, 95.00, 75.00,
   38.40, 2, 90.10, FALSE,
   'Excellent keto adherence today Ravi. Your fat-to-protein ratio was ideal. Add more vitamin C sources.'),

-- Sneha: Fair, needs significant improvement
(4, 4, '2026-03-28', 1, 55.00, 'Fair',      51.00, 61.00, 76.00, 57.00, 48.00,
   44.38, 5, 31.60, FALSE,
   'You had a fiber-rich day Sneha, which is great! However, protein and calorie intake were well below your targets. Focus on adding protein.'),

-- Kabir: Good, steady and controlled
(5, 5, '2026-03-28', 1, 74.00, 'Good',      75.00, 73.00, 83.00, 81.00, 71.00,
   36.32, 4, 65.50, FALSE,
   'Well managed day Kabir! Your blood sugar-friendly food choices were excellent. Slightly below calorie target — ensure adequate energy for heart health.');
select* from daily_health_scores;

-- =============================================================================
-- SECTION 6 — SOCIAL GRAPH
-- =============================================================================

-- Follow relationships (varied — not everyone follows everyone)
INSERT INTO user_follows (follow_id, follower_id, following_id, status) VALUES
(1, 1, 2, 'ACCEPTED'),  -- Aryan follows Priya
(2, 1, 3, 'ACCEPTED'),  -- Aryan follows Ravi
(3, 2, 1, 'ACCEPTED'),  -- Priya follows Aryan
(4, 2, 4, 'ACCEPTED'),  -- Priya follows Sneha
(5, 3, 1, 'ACCEPTED'),  -- Ravi follows Aryan
(6, 4, 1, 'ACCEPTED'),  -- Sneha follows Aryan
(7, 4, 2, 'ACCEPTED'),  -- Sneha follows Priya
(8, 1, 5, 'PENDING'),   -- Aryan sent request to Kabir (pending)
(9, 5, 3, 'ACCEPTED');  -- Kabir follows Ravi
select* from user_follows;
-- Kabir blocks Sneha (he wants privacy)
INSERT INTO user_blocks (block_id, blocker_id, blocked_id, reason) VALUES
(1, 5, 4, 'Prefers complete privacy from new users');
select* from user_blocks;

-- =============================================================================
-- SECTION 7 — SOCIAL ENGAGEMENT
-- =============================================================================

-- Reactions on published meals
INSERT INTO meal_post_reactions (reaction_id, meal_log_id, user_id, reaction_type_id) VALUES
(1, 1, 2, 1),  -- Priya reacts 🥗 Healthy on Aryan Breakfast
(2, 1, 3, 4),  -- Ravi reacts 💪 Inspiring on Aryan Breakfast
(3, 1, 4, 2),  -- Sneha reacts ❤️ Love It on Aryan Breakfast
(4, 2, 2, 4),  -- Priya reacts 💪 on Aryan Lunch
(5, 2, 3, 1),  -- Ravi reacts 🥗 on Aryan Lunch
(6, 3, 1, 1),  -- Aryan reacts 🥗 on Priya Breakfast
(7, 3, 4, 2),  -- Sneha reacts ❤️ on Priya Breakfast
(8, 5, 1, 3),  -- Aryan reacts 🔥 on Ravi Keto Breakfast
(9, 7, 1, 5),  -- Aryan reacts 😋 on Sneha Smoothie Bowl
(10,7, 2, 2);  -- Priya reacts ❤️ on Sneha Smoothie Bowl
select* from meal_post_reactions;
-- Comments on meals
INSERT INTO meal_post_comments (comment_id, meal_log_id, user_id, parent_comment_id,
    comment_text, is_edited, is_deleted, is_flagged, like_count) VALUES
(1, 1, 2, NULL,
   'Wow Aryan! That breakfast looks amazing. What brand of oats do you use?', FALSE, FALSE, FALSE, 2),
(2, 1, 1, 1,
   'Thanks Priya! I use Quaker Oats. Works great pre-gym 💪', FALSE, FALSE, FALSE, 1),
(3, 1, 4, NULL,
   'So inspiring! I wish I had that discipline in the morning 🌟', FALSE, FALSE, FALSE, 3),
(4, 2, 3, NULL,
   'That chicken lunch is textbook clean eating. Respect!', FALSE, FALSE, FALSE, 1),
(5, 3, 1, NULL,
   'Paneer for muscle building is a genius move Priya 🔥', FALSE, FALSE, FALSE, 2),
(6, 7, 2, NULL,
   'Love this vegan bowl Sneha! So colourful and fresh 🌈', FALSE, FALSE, FALSE, 1);
select* from meal_post_comments;
-- Comment Likes
INSERT INTO comment_likes (like_id, comment_id, user_id) VALUES
(1, 1, 1),  -- Aryan likes Priya comment on meal 1
(2, 1, 4),  -- Sneha likes Priya comment on meal 1
(3, 3, 1),  -- Aryan likes Sneha comment
(4, 3, 2),  -- Priya likes Sneha comment
(5, 3, 3),  -- Ravi likes Sneha comment
(6, 5, 2),  -- Priya likes Aryan comment on her meal
(7, 6, 4);  -- Sneha likes Priya comment on her bowl
select* from comment_likes;
-- Shares
INSERT INTO meal_post_shares (share_id, meal_log_id, shared_by_user_id, share_platform, share_caption) VALUES
(1, 2, 1, 'WHATSAPP',   'Check out my clean lunch today! #HealthBiteAI #CleanEating'),
(2, 1, 2, 'INSTAGRAM',  'My fitness inspiration @aryan_sharma! Amazing breakfast bowl 💪'),
(3, 7, 4, 'IN_APP',     'My smoothie bowl for the community feed!');
select* from meal_post_shares;

-- =============================================================================
-- SECTION 8 — COMMUNITY, BADGES & HIGHLIGHTS
-- =============================================================================

INSERT INTO community_challenges (challenge_id, challenge_name, challenge_code,
    challenge_type, start_date, end_date, criteria_json, badge_type_id, is_public) VALUES
(1, 'March Clean Eating Week',  'MARCH_CLEAN_2026',  'WEEKLY',
   '2026-03-23 00:00:00', '2026-03-29 23:59:59',
   '{"min_score":70,"meals_per_day":2,"no_junk":true}', 1, TRUE),
(2, 'Monthly Streak Champion',  'STREAK_MARCH_2026', 'MONTHLY',
   '2026-03-01 00:00:00', '2026-03-31 23:59:59',
   '{"min_streak_days":20}', 2, TRUE);
select* from community_challenges;

INSERT INTO challenge_participants (participant_id, challenge_id, user_id,
    joined_at, current_score, `rank`, is_completed, is_winner) VALUES
(1, 1, 1, '2026-03-23 08:00:00', 93.00, 1, FALSE, FALSE),  -- Aryan: 1st
(2, 1, 2, '2026-03-23 09:00:00', 76.00, 3, FALSE, FALSE),  -- Priya: 3rd
(3, 1, 3, '2026-03-23 10:00:00', 80.00, 2, FALSE, FALSE),  -- Ravi: 2nd
(4, 1, 4, '2026-03-24 11:00:00', 55.00, 4, FALSE, FALSE),  -- Sneha: 4th
(5, 2, 1, '2026-03-01 08:00:00', 88.00, 1, FALSE, FALSE),  -- Aryan in streak challenge
(6, 2, 3, '2026-03-01 09:00:00', 82.00, 2, FALSE, FALSE);  -- Ravi in streak challenge
select* from challenge_participants;
-- Community Highlights
INSERT INTO community_highlights (highlight_id, meal_log_id, user_id,
    highlight_type, highlight_date, title, score_snapshot, is_featured) VALUES
(1, 2, 1, 'TOP_SCORE_DAY',       '2026-03-28', 'Aryan Scores 95 on Protein Lunch!',        95.00, TRUE),
(2, 1, 1, 'MOST_REACTIONS',      '2026-03-28', 'Aryan Breakfast Gets 3 Reactions Today!',   91.00, FALSE),
(3, 3, 2, 'MOST_BALANCED_MEAL',  '2026-03-28', 'Priya\'s Veggie Breakfast — Well Balanced!',78.00, FALSE);
select* from community_highlights;
-- User Badges
INSERT INTO user_badges (user_badge_id, user_id, badge_type_id, awarded_at, award_context_json, is_pinned) VALUES
(1, 1, 3, '2026-03-28 07:50:00', '{"meal_log_id":1,"trigger":"first_meal_logged"}',     TRUE),   -- Aryan: First Meal
(2, 1, 1, '2026-03-14 20:00:00', '{"streak_days":7,"ended_date":"2026-03-14"}',         TRUE),   -- Aryan: 7-Day Streak
(3, 2, 3, '2025-08-10 10:00:00', '{"meal_log_id":null,"trigger":"first_meal_logged"}',  FALSE),  -- Priya: First Meal
(4, 3, 1, '2026-02-20 19:00:00', '{"streak_days":7,"ended_date":"2026-02-20"}',         TRUE),   -- Ravi: 7-Day Streak
(5, 3, 2, '2026-03-15 19:00:00', '{"streak_days":30,"ended_date":"2026-03-15"}',        TRUE),   -- Ravi: 30-Day Streak
(6, 5, 3, '2025-03-01 08:00:00', '{"trigger":"first_meal_logged"}',                     FALSE);  -- Kabir: First Meal
select* from user_badges;
-- Logging Streaks (all different)
INSERT INTO user_logging_streaks (streak_id, user_id, current_streak_days,
    longest_streak_days, last_logged_date, streak_started_date, total_logged_days) VALUES
(1, 1, 27, 27, '2026-03-28', '2026-03-01', 87),   -- Aryan: 27-day current streak
(2, 2, 12, 21, '2026-03-28', '2026-03-17', 45),   -- Priya: 12-day streak
(3, 3, 28, 30, '2026-03-28', '2026-03-01', 110),  -- Ravi: 28-day streak, had 30 before
(4, 4,  3,  8, '2026-03-28', '2026-03-26', 18),   -- Sneha: only 3-day streak
(5, 5, 14, 22, '2026-03-28', '2026-03-15', 62);   -- Kabir: 14-day streak
select* from user_logging_streaks;


-- =============================================================================
-- SECTION 9 — NOTIFICATIONS
-- =============================================================================

INSERT INTO notifications (notification_id, recipient_user_id, sender_user_id,
    notification_type_id, title, body, action_url,
    entity_type, entity_id, is_read, read_at, is_sent, sent_at) VALUES
(1,  1, 2, 1, 'Priya reacted to your meal',
    'Priya Mehta reacted 🥗 Healthy to your Morning Power Bowl',
    '/meals/1', 'meal_log', 1, TRUE,  '2026-03-28 10:00:00', TRUE, '2026-03-28 09:58:00'),

(2,  1, 3, 1, 'Ravi reacted to your meal',
    'Ravi Kumar reacted 💪 Inspiring to your Morning Power Bowl',
    '/meals/1', 'meal_log', 1, TRUE,  '2026-03-28 10:05:00', TRUE, '2026-03-28 10:03:00'),

(3,  1, 2, 2, 'Priya commented on your meal',
    'Priya Mehta: Wow Aryan! That breakfast looks amazing...',
    '/meals/1#comment-1', 'meal_log', 1, TRUE, '2026-03-28 10:10:00', TRUE, '2026-03-28 10:08:00'),

(4,  1, NULL, 4, 'You earned a badge!',
    'Congratulations! You earned the 7-Day Streak badge 🏅',
    '/badges', 'user', 1, TRUE, '2026-03-28 08:00:00', TRUE, '2026-03-28 07:58:00'),

(5,  1, NULL, 7, 'Your daily score is ready',
    'Your health score for today is 93/100 — Excellent! 🌟',
    '/scores/daily', 'user', 1, FALSE, NULL, TRUE, '2026-03-28 23:00:00'),

(6,  2, 1, 1, 'Aryan reacted to your meal',
    'Aryan Sharma reacted 🥗 Healthy to your Veggie Protein Breakfast',
    '/meals/3', 'meal_log', 3, TRUE,  '2026-03-28 11:00:00', TRUE, '2026-03-28 10:58:00'),

(7,  2, NULL, 7, 'Your daily score is ready',
    'Your health score for today is 76/100 — Good! Keep it up 💪',
    '/scores/daily', 'user', 2, FALSE, NULL, TRUE, '2026-03-28 23:00:00'),

(8,  4, 1, 1, 'Aryan reacted to your meal',
    'Aryan Sharma reacted 😋 Yummy to your Vegan Morning Smoothie Bowl',
    '/meals/7', 'meal_log', 7, FALSE, NULL, TRUE, '2026-03-28 15:00:00'),

(9,  4, 2, 2, 'Priya commented on your meal',
    'Priya Mehta: Love this vegan bowl Sneha! So colourful and fresh 🌈',
    '/meals/7#comment-6', 'meal_log', 7, FALSE, NULL, TRUE, '2026-03-28 16:00:00'),

(10, 3, NULL, 5, 'Streak Milestone!',
    'Amazing! You have logged 28 days in a row! Your 30-day badge is within reach 🔥',
    '/streaks', 'user', 3, TRUE, '2026-03-28 20:00:00', TRUE, '2026-03-28 19:58:00');
select* from notifications;

-- =============================================================================
-- SECTION 10 — MODERATION
-- =============================================================================

INSERT INTO content_reports (report_id, reporter_user_id, reason_id,
    entity_type, entity_id, description, status) VALUES
(1, 3, 1, 'MEAL_LOG', 7,
   'This post appears to be promoting an unrealistic diet.',
   'PENDING');
select* from content_reports;

-- =============================================================================
-- SECTION 11 — SECURITY
-- =============================================================================

INSERT INTO user_sessions (session_id, user_id, session_token_hash, refresh_token_hash,
    device_name, platform, is_active, expires_at) VALUES
(1, 1, 'hash_session_aryan_android_001', 'hash_refresh_aryan_001', 'Aryan OnePlus 12', 'ANDROID', TRUE, '2026-04-28 07:30:00'),
(2, 2, 'hash_session_priya_ios_001',     'hash_refresh_priya_001', 'Priya iPhone 15',  'IOS',     TRUE, '2026-04-28 08:15:00'),
(3, 3, 'hash_session_ravi_web_001',      'hash_refresh_ravi_001',  'Chrome on Windows','WEB',     TRUE, '2026-04-28 06:45:00'),
(4, 4, 'hash_session_sneha_ios_001',     'hash_refresh_sneha_001', 'Sneha iPhone 14',  'IOS',     TRUE, '2026-04-27 21:00:00'),
(5, 5, 'hash_session_kabir_android_001', 'hash_refresh_kabir_001', 'Kabir Samsung S23','ANDROID', TRUE, '2026-04-28 09:00:00');
select* from user_sessions;

-- =============================================================================
-- SECTION 12 — AUDIT LOG
-- =============================================================================

INSERT INTO user_activity_log (activity_id, user_id, activity_type, entity_type, entity_id, ip_address, platform) VALUES
(1,  1, 'LOGIN',       NULL,       NULL, '103.21.55.101', 'ANDROID'),
(2,  1, 'MEAL_LOG',    'meal_log', 1,    '103.21.55.101', 'ANDROID'),
(3,  1, 'MEAL_LOG',    'meal_log', 2,    '103.21.55.101', 'ANDROID'),
(4,  1, 'REACTION',    'meal_log', 3,    '103.21.55.101', 'ANDROID'),
(5,  2, 'LOGIN',       NULL,       NULL, '49.36.12.200',  'IOS'),
(6,  2, 'MEAL_LOG',    'meal_log', 3,    '49.36.12.200',  'IOS'),
(7,  2, 'MEAL_LOG',    'meal_log', 4,    '49.36.12.200',  'IOS'),
(8,  3, 'LOGIN',       NULL,       NULL, '117.55.8.90',   'WEB'),
(9,  3, 'MEAL_LOG',    'meal_log', 5,    '117.55.8.90',   'WEB'),
(10, 4, 'LOGIN',       NULL,       NULL, '122.161.45.33', 'IOS'),
(11, 4, 'MEAL_LOG',    'meal_log', 7,    '122.161.45.33', 'IOS'),
(12, 5, 'LOGIN',       NULL,       NULL, '180.151.22.10', 'ANDROID'),
(13, 5, 'MEAL_LOG',    'meal_log', 9,    '180.151.22.10', 'ANDROID'),
(14, 1, 'SHARE',       'meal_log', 2,    '103.21.55.101', 'ANDROID'),
(15, 5, 'REPORT',      'meal_log', 7,    '180.151.22.10', 'ANDROID');
select* from user_activity_log;

-- =============================================================================
-- SECTION 13 — FEED CACHE
-- =============================================================================

INSERT INTO user_feed_cache (feed_item_id, user_id, source_user_id, meal_log_id,
    feed_score, is_dismissed, expires_at) VALUES
-- Aryan's feed: sees Priya and Ravi's published meals
(1, 1, 2, 3, 8.7500, FALSE, '2026-03-31 23:59:59'),  -- Priya breakfast in Aryan feed
(2, 1, 2, 4, 8.2000, FALSE, '2026-03-31 23:59:59'),  -- Priya dinner in Aryan feed
(3, 1, 3, 5, 7.9000, FALSE, '2026-03-31 23:59:59'),  -- Ravi breakfast in Aryan feed
-- Priya's feed: sees Aryan's meals
(4, 2, 1, 1, 9.5000, FALSE, '2026-03-31 23:59:59'),  -- Aryan breakfast in Priya feed
(5, 2, 1, 2, 9.8000, FALSE, '2026-03-31 23:59:59'),  -- Aryan lunch in Priya feed
(6, 2, 4, 7, 6.5000, FALSE, '2026-03-31 23:59:59'),  -- Sneha bowl in Priya feed
-- Sneha's feed: sees Aryan and Priya's meals
(7, 4, 1, 1, 9.2000, FALSE, '2026-03-31 23:59:59'),  -- Aryan breakfast in Sneha feed
(8, 4, 1, 2, 9.6000, FALSE, '2026-03-31 23:59:59'),  -- Aryan lunch in Sneha feed
(9, 4, 2, 3, 8.1000, TRUE,  '2026-03-31 23:59:59');  -- Priya breakfast dismissed by Sneha
select* from user_feed_cache;
-- =============================================================================
SET foreign_key_checks = 1;
-- End of HealthBite-AI Sample Data
-- =============================================================================
