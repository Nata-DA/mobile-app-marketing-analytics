SQL
WITH 
  installs AS (
    SELECT 
      DATE(timestamp) AS event_date,
      media_source,
      CAST(campaign_id AS STRING) AS campaign_id,
      MAX(campaign_name) AS campaign_name,
      COUNT(DISTINCT firebase_analytic_app_id) AS total_installs
    FROM `mornhouse-test-environment.test_app_dataset.non_org_installs_report`
    WHERE timestamp IS NOT NULL
    GROUP BY 1, 2, 3
  ),
  costs AS (
    SELECT 
      PARSE_DATE('%Y-%m-%d', date) AS event_date,
      media_source,
      CAST(campaign_id AS STRING) AS campaign_id,
      MAX(campaign) AS campaign_name,
      SUM(cost) AS total_cost
    FROM `mornhouse-test-environment.test_app_dataset.cost_table`
    GROUP BY 1, 2, 3
  ),
  in_app_rev AS (
    SELECT 
      DATE(timestamp) AS event_date,
      media_source,
      CAST(campaign_id AS STRING) AS campaign_id,
      SUM(event_revenue_usd) AS iap_revenue
    FROM `mornhouse-test-environment.test_app_dataset.in_app_events_report`
    WHERE event_revenue_usd IS NOT NULL
    GROUP BY 1, 2, 3
  ),
  ad_rev AS (
    SELECT 
      DATE(timestamp) AS event_date,
      media_source,
      CAST(campaign_id AS STRING) AS campaign_id,
      SUM(event_revenue_usd) AS ad_revenue
    FROM `mornhouse-test-environment.test_app_dataset.ad_revenue_raw`
    WHERE event_revenue_usd IS NOT NULL
    GROUP BY 1, 2, 3
  ),
  all_keys AS (
    SELECT event_date, media_source, campaign_id FROM installs
    UNION DISTINCT
    SELECT event_date, media_source, campaign_id FROM costs
    UNION DISTINCT
    SELECT event_date, media_source, campaign_id FROM in_app_rev
    UNION DISTINCT
    SELECT event_date, media_source, campaign_id FROM ad_rev
  )

SELECT 
  k.event_date,
  k.media_source,
  k.campaign_id,
  COALESCE(i.campaign_name, c.campaign_name, 'Unknown') AS campaign_name,
  COALESCE(i.total_installs, 0) AS installs,
  COALESCE(c.total_cost, 0) AS cost,
  COALESCE(iap.iap_revenue, 0) AS iap_revenue,
  COALESCE(ad.ad_revenue, 0) AS ad_revenue,
  (COALESCE(iap.iap_revenue, 0) + COALESCE(ad.ad_revenue, 0)) AS total_revenue,
  (COALESCE(iap.iap_revenue, 0) + COALESCE(ad.ad_revenue, 0)) - COALESCE(c.total_cost, 0) AS profit,
  CASE 
    WHEN COALESCE(c.total_cost, 0) > 0 
    THEN SAFE_DIVIDE((COALESCE(iap.iap_revenue, 0) + COALESCE(ad.ad_revenue, 0)) - c.total_cost, c.total_cost) * 100
    ELSE NULL 
  END AS roi_percent
FROM all_keys k
LEFT JOIN installs i ON k.event_date = i.event_date AND k.media_source = i.media_source AND k.campaign_id = i.campaign_id
LEFT JOIN costs c ON k.event_date = c.event_date AND k.media_source = c.media_source AND k.campaign_id = c.campaign_id
LEFT JOIN in_app_rev iap ON k.event_date = iap.event_date AND k.media_source = iap.media_source AND k.campaign_id = iap.campaign_id
LEFT JOIN ad_rev ad ON k.event_date = ad.event_date AND k.media_source = ad.media_source AND k.campaign_id = ad.campaign_id
WHERE k.event_date BETWEEN '2026-06-01' AND '2026-07-31'
ORDER BY k.event_date DESC, total_revenue DESC;
