-- SQL queries for Product Metrics Dashboard (adapt to your DB: DATE_TRUNC / FLOOR / EXTRACT syntax may vary)

-- 1. DAU, sessions, revenue, ARPU per day
SELECT
  date,
  COUNT(DISTINCT user_id) AS dau,
  SUM(sessions) AS sessions,
  SUM(revenue) AS revenue,
  CASE WHEN COUNT(DISTINCT user_id) = 0 THEN 0 ELSE SUM(revenue)::float / COUNT(DISTINCT user_id) END AS arpu
FROM events
GROUP BY date
ORDER BY date;

-- 2. WAU / MAU (rolling windows)
-- WAU: number of distinct users in each 7-day window ending on date
WITH daily AS (
  SELECT date, COUNT(DISTINCT user_id) AS dau FROM events GROUP BY date
)
SELECT
  d.date,
  (SELECT COUNT(DISTINCT user_id) FROM events e WHERE e.date BETWEEN d.date - INTERVAL '6 days' AND d.date) AS wau,
  (SELECT COUNT(DISTINCT user_id) FROM events e WHERE e.date BETWEEN d.date - INTERVAL '29 days' AND d.date) AS mau
FROM (SELECT DISTINCT date FROM events) d
ORDER BY d.date;

-- 3. Acquisition channel performance (total revenue, ARPU, users)
SELECT
  acq_channel,
  COUNT(DISTINCT user_id) AS users,
  SUM(revenue) AS total_revenue,
  CASE WHEN COUNT(DISTINCT user_id)=0 THEN 0 ELSE SUM(revenue)::float/COUNT(DISTINCT user_id) END AS arpu
FROM events
GROUP BY acq_channel
ORDER BY total_revenue DESC;

-- 4. Revenue by country and week
SELECT
  DATE_TRUNC('week', date) AS week_start,
  country,
  SUM(revenue) AS revenue
FROM events
GROUP BY week_start, country
ORDER BY week_start;

-- 5. Cohort retention (weekly cohorts)
WITH reg AS (
  SELECT user_id, DATE_TRUNC('week', reg_date) AS reg_week FROM (SELECT DISTINCT user_id, reg_date FROM events) x
),
ev AS (
  SELECT user_id, DATE_TRUNC('week', date) AS event_week FROM events
)
SELECT
  r.reg_week,
  e.event_week,
  COUNT(DISTINCT e.user_id) AS active_users,
  FLOOR(EXTRACT(epoch FROM (e.event_week - r.reg_week))/604800) AS cohort_week
FROM reg r
JOIN ev e ON r.user_id = e.user_id
GROUP BY r.reg_week, e.event_week
ORDER BY r.reg_week, cohort_week;

-- 6. Churn proxy: users who were active in a baseline month and not active in the following 30 days
WITH baseline AS (
  SELECT DISTINCT user_id FROM events WHERE date BETWEEN '2025-03-01' AND '2025-03-31'
),
future AS (
  SELECT DISTINCT user_id FROM events WHERE date BETWEEN '2025-04-01' AND '2025-04-30'
)
SELECT COUNT(*)::float / (SELECT COUNT(*) FROM baseline) AS churn_rate
FROM baseline b LEFT JOIN future f ON b.user_id = f.user_id
WHERE f.user_id IS NULL;

-- 7. LTV (simple cumulative revenue per cohort week)
SELECT
  DATE_TRUNC('week', reg_date) AS reg_week,
  SUM(revenue) AS total_revenue
FROM events
GROUP BY reg_week
ORDER BY reg_week;
