-- Результати по групах (без забруднених юзерів)
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
ORDER BY match
