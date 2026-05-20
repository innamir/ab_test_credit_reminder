-- ============================================
-- Sample Size Calculation: A/B Test Credit Reminder
-- ============================================

-- --------------------------------------------
-- 1. SAMPLE SIZE PER GROUP
-- Формула: z-scores * variance / effect^2
-- alpha = 0.05, power = 80%, MDE = 10% relative
-- --------------------------------------------
WITH params AS (
  SELECT
    0.0545 AS baseline_cr,
    0.10   AS mde,
    1.645  AS z_alpha,   -- one-sided, 95% confidence
    0.842  AS z_beta     -- power 80%
),
calc AS (
  SELECT
    baseline_cr,
    baseline_cr * (1 + mde) AS target_cr,
    z_alpha,
    z_beta
  FROM params
)
SELECT
  ROUND(baseline_cr * 100, 2) AS baseline_cr_pct,
  ROUND(target_cr * 100, 2)   AS target_cr_pct,
  CEIL(
    (z_alpha + z_beta)*(z_alpha + z_beta) *
    (baseline_cr*(1-baseline_cr) + target_cr*(1-target_cr)) /
    ((target_cr - baseline_cr)*(target_cr - baseline_cr))
  ) AS sample_size_per_group
FROM calc;

-- Result: 28,477 users per group

-- --------------------------------------------
-- 2. TEST DURATION
-- На основі денного трафіку з історичних даних
-- --------------------------------------------
WITH daily_traffic AS (
  SELECT
    COUNT(*) / 9 AS avg_daily_users
  FROM `hw-skelar.ab_test.ab_test_task_historical_data`
)
SELECT
  ROUND(avg_daily_users, 0) AS avg_daily_users,
  28477                      AS sample_size_per_group,
  CEIL(28477 / avg_daily_users) AS days_needed
FROM daily_traffic;

-- Result: 5 days minimum

