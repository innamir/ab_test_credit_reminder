-- ============================================
-- Results Analysis: A/B Test Credit Reminder
-- ============================================

-- --------------------------------------------
-- 1. PRIMARY METRIC — Conversion Rate
-- Виключаємо 89 забруднених юзерів контролю
-- --------------------------------------------
SELECT
  match AS group_id,
  COUNT(*) AS total_users,
  COUNT(date_first_payment) AS conversions,
  ROUND(COUNT(date_first_payment) * 100.0 / COUNT(*), 4) AS conversion_rate,
  MIN(date_reg) AS test_start,
  MAX(date_reg) AS test_end
FROM `hw-skelar.ab_test.ab_test_task_data`
WHERE NOT (match = 0 AND date_reminder IS NOT NULL)
GROUP BY match
ORDER BY match;

-- Result:
-- Група 0: CR = 5.5987%
-- Група 1: CR = 5.9554%
-- Різниця: +6.37% ✅

-- --------------------------------------------
-- 2. HEALTH METRIC BASELINE — історичні дані
-- Базові значення до запуску тесту
-- --------------------------------------------
SELECT
  ROUND(COUNT(date_spent_15_credits) * 100.0 / COUNT(*), 4) AS spent_15_rate,
  ROUND(AVG(DATE_DIFF(DATE(date_first_payment),
        DATE(date_reg), DAY)), 2) AS avg_days_to_payment
FROM `hw-skelar.ab_test.ab_test_task_historical_data`;

-- Result:
-- spent_15_rate: 37.26%
-- avg_days_to_payment: 16.5 днів

-- --------------------------------------------
-- 3. HEALTH METRIC — Витрата 15 кредитів
-- Перевіряємо чи не прискорило нагадування
-- витрату кредитів замість оплати
-- --------------------------------------------
SELECT
  match AS group_id,
  COUNT(date_spent_15_credits) AS spent_15_users,
  COUNT(*) AS total_users,
  ROUND(COUNT(date_spent_15_credits) * 100.0 / COUNT(*), 4) AS spent_15_rate
FROM `hw-skelar.ab_test.ab_test_task_data`
WHERE NOT (match = 0 AND date_reminder IS NOT NULL)
GROUP BY match
ORDER BY match;

-- Result:
-- Група 0: 41.03%
-- Група 1: 41.27%
-- Різниця: +0.24% ✅ норма

-- --------------------------------------------
-- 4. HEALTH METRIC — Час до першої оплати
-- Перевіряємо чи прискорює нагадування
-- прийняття рішення про оплату
-- --------------------------------------------
SELECT
  match AS group_id,
  ROUND(AVG(DATE_DIFF(DATE(date_first_payment),
        DATE(date_reg), DAY)), 2) AS avg_days_to_payment
FROM `hw-skelar.ab
