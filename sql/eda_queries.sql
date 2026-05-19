-- ============================================
-- EDA: A/B Test Credit Reminder
-- ============================================

-- --------------------------------------------
-- 1. HISTORICAL DATA: baseline metrics
-- --------------------------------------------
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT id_user) AS unique_users,
  COUNT(*) - COUNT(DISTINCT id_user) AS duplicates,
  MIN(date_reg) AS first_reg,
  MAX(date_reg) AS last_reg,
  ROUND(COUNT(date_first_payment) * 100.0 / COUNT(*), 2) AS conversion_pct,
  COUNT(date_first_payment) AS paid_users,
  COUNT(*) - COUNT(date_first_payment) AS not_paid_users
FROM `hw-skelar.ab_test.ab_test_task_historical_data`;

-- --------------------------------------------
-- 2. TEST DATA: group distribution
-- --------------------------------------------
SELECT
  match AS group_id,
  COUNT(*) AS total_rows,
  COUNT(DISTINCT id_user) AS unique_users,
  MIN(date_reg) AS first_reg,
  MAX(date_reg) AS last_reg,
  COUNT(date_first_payment) AS paid_users,
  ROUND(COUNT(date_first_payment) * 100.0 / COUNT(*), 2) AS conversion_pct,
  COUNT(date_reminder) AS got_reminder
FROM `hw-skelar.ab_test.ab_test_task_data`
GROUP BY match
ORDER BY match;

-- --------------------------------------------
-- 3. CONTROL GROUP CONTAMINATION CHECK
-- --------------------------------------------
SELECT
  COUNT(*) AS total_control,
  COUNT(date_reminder) AS got_reminder,
  ROUND(COUNT(date_reminder) * 100.0 / COUNT(*), 4) AS contamination_pct
FROM `hw-skelar.ab_test.ab_test_task_data`
WHERE match = 0;

-- Result: 0.14% — acceptable (< 1% threshold)
-- 89 users excluded from further analysis
