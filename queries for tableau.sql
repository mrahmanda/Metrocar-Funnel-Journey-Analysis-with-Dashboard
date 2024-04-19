/* 
Query 1: 

The Funnel analysis highlights critical drop-off points in the Metrocar customer or ride funnel and suggests focusing on specific stages 
for further investigation and improvement. By prioritizing these key drop-off points and implementing targeted strategies to address them, 
Metrocar can enhance the user experience, increase conversion rates, and ultimately drive business growth. 

And then we can add multiple metrics such as platform, age range, download date etc. to get diversified visual of the data. 

As Beekeeper has a limit of 50,000 rows to download, we had to create 2 other independent tables with similar join keys to join them on Tableau.
*/


-- Common Table Expression (CTE) to calculate various metrics at different funnel steps

WITH temp_totals AS (
    SELECT
        ad.platform, 
        COALESCE(s.age_range, 'Unknown') AS age_ranges,
        DATE(ad.download_ts) AS download_date,
        
        COUNT(DISTINCT s.user_id) AS total_users_signed_up,
        COUNT(DISTINCT rr.user_id) AS total_users_ride_requested,
        COUNT(DISTINCT ad.app_download_key) AS total_downloads,
        COUNT(DISTINCT rr.user_id) FILTER(WHERE rr.accept_ts IS NOT NULL) AS total_users_ride_accepted,
        COUNT(DISTINCT rr.user_id) FILTER(WHERE rr.cancel_ts IS NULL) AS total_users_ride_completed,
        COUNT(DISTINCT rr.user_id) FILTER(WHERE tr.charge_status='Approved') AS total_users_ride_paid,
        COUNT(DISTINCT rv.user_id) AS total_users_with_review, 
  
        COUNT(rr.ride_id) AS total_ride_requested,
  		COUNT(rr.ride_id) FILTER(WHERE rr.accept_ts IS NOT NULL) AS total_ride_accepted,
        COUNT(rr.ride_id) FILTER(WHERE rr.cancel_ts IS NULL) AS total_ride_completed,
        COUNT(rr.ride_id) FILTER(WHERE tr.charge_status='Approved') AS total_ride_paid,
        COUNT(rv.ride_id) AS total_ride_reviewed,
    	SUM(tr.purchase_amount_usd) AS revenue
  
  FROM app_downloads ad
    
  LEFT JOIN signups s ON ad.app_download_key = s.session_id
  FULL JOIN ride_requests rr ON s.user_id = rr.user_id
  FULL JOIN transactions tr ON tr.ride_id = rr.ride_id
  FULL JOIN reviews rv ON rv.ride_id = rr.ride_id
   
  GROUP BY ad.platform, age_ranges, download_date
),

-- CTE to represent each funnel step with its corresponding metrics platform, age_ranges, download_date, user_count, ride_count 

temp_steps AS (
    SELECT
        0 AS funnel_step,
        'downloads' AS funnel_name,
        total_downloads AS user_count, platform AS platform, age_ranges, download_date, 0 AS ride_count
    FROM temp_totals

    UNION

    SELECT
        1 AS funnel_step,
        'signups' AS funnel_name,
        total_users_signed_up AS user_count, platform AS platform, age_ranges, download_date, 0 AS ride_count
    FROM temp_totals

    UNION

    SELECT
        2 AS funnel_step,
        'ride_requested' AS funnel_name,
        total_users_ride_requested AS user_count, platform AS platform, age_ranges, download_date, total_ride_requested AS ride_count
    FROM temp_totals

    UNION

    SELECT
        3 AS funnel_step,
        'ride_accepted' AS funnel_name,
        total_users_ride_accepted AS user_count, platform AS platform, age_ranges, download_date, total_ride_accepted AS ride_count
    FROM temp_totals

    UNION

    SELECT
        4 AS funnel_step,
        'ride_completed' AS funnel_name,
        total_users_ride_completed AS user_count, platform AS platform, age_ranges, download_date, total_ride_completed AS ride_count
    FROM temp_totals

    UNION

    SELECT
        5 AS funnel_step,
        'payment' AS funnel_name,
        total_users_ride_paid AS user_count, platform AS platform, age_ranges, download_date, total_ride_paid AS ride_count
    FROM temp_totals

    UNION

    SELECT
        6 AS funnel_step,
        'Reviews' AS funnel_name,
        total_users_with_review AS user_count, platform AS platform, age_ranges, download_date, total_ride_reviewed AS ride_count
    FROM temp_totals
 
    ORDER BY funnel_step
)

-- Select and present the results with metrics for each funnel step
SELECT funnel_step, funnel_name, platform, age_ranges, download_date, user_count, ride_count 
FROM temp_steps 

ORDER BY funnel_step
;






/* 
Query 2: 
The purpose of this query is to calculate the revenue against Charge Status (Approved or Decline) to customise the revenue with a filter
And some other common metrics (platform, age_ranges, user_count, ride_count ) to make visualisation easier from the same table without any error. 

To add, allocating marketing budgets strategically, with a focus on platforms and demographics that demonstrate the highest engagement and conversion rates. 
By investing resources in acquiring and retaining users from high-performing segments, we can maximize the return on investment in our marketing efforts.
Also data explosion is an issue due to the beekeeper. 
*/

----user and ride metrics against revenue, platform and age ranges

WITH 

totals_by_platform AS (
SELECT 
  COUNT(DISTINCT rr.user_id) AS user_count,
  UPPER(ad.platform) AS platform,
  su.age_range AS age_ranges,
  ROUND(SUM(ts.purchase_amount_usd)::NUMERIC, 2) AS revenue, 
  COUNT(ts.ride_id) AS ride_count,
  ts.charge_status
  
FROM transactions AS ts
INNER JOIN ride_requests AS rr ON ts.ride_id = rr.ride_id
INNER JOIN signups AS su ON rr.user_id = su.user_id
INNER JOIN app_downloads AS ad ON su.session_id = ad.app_download_key
GROUP BY ad.platform, age_ranges, ts.charge_status
ORDER BY revenue DESC
)

--SELECT sum(tp.revenue) FROM totals_by_platform tp ;

SELECT 
tp.platform,
tp.age_ranges,
tp.revenue,
tp.ride_count,
tp.user_count,
tp.charge_status

FROM totals_by_platform tp
;





/* 
Query 3: 
To Calculate User request and Ride request count based on Date and Hour of the day, Avg wait time (Completed rides), 
avg cancel timem (After and before accepted), platform. 
As per the questions, we need to analyse surge pricing strategy, by visualising the peak or off-peak hours. Also we can filter days with date 
and see any particular days or week or month's track records. 
By analysing the wait and cancel time we could know the reason behind the significant dropoff rates in the funnel distribution.

*/


SELECT 
    ad.platform,
    DATE(rr.request_ts) AS request_date,
    EXTRACT(HOUR FROM rr.request_ts) AS hour_of_day,
    COUNT(DISTINCT rr.user_id) AS user_requested_count,
    COUNT(rr.ride_id) AS ride_requested_count,
    COUNT(rr.ride_id) FILTER(WHERE rr.accept_ts IS NOT NULL) AS ride_accepted_count,
    COALESCE((AVG(rr.accept_ts::TIME - rr.request_ts::TIME) FILTER(WHERE rr.accept_ts IS NOT NULL AND rr.dropoff_ts IS NOT NULL)), '00:00:00') 
                                                                            AS avg_wait_time_bfr_accept,
    COALESCE((AVG(rr.cancel_ts::TIME - rr.request_ts::TIME) FILTER(WHERE rr.accept_ts IS NOT NULL)), '00:00:00') 
    																		AS avg_cancel_time_accepted,
    COALESCE((AVG(rr.cancel_ts::TIME - rr.request_ts::TIME) FILTER(WHERE rr.accept_ts IS NULL)), '00:00:00') 
    																		AS avg_cancel_time_Not_accepted

FROM ride_requests rr
FULL JOIN  signups s ON s.user_id = rr.user_id
FULL JOIN app_downloads ad ON ad.app_download_key = s.session_id
FULL JOIN reviews rv ON rr.ride_id = rv.ride_id
FULL JOIN transactions tr ON rr.ride_id = tr.ride_id
    
GROUP BY request_date, hour_of_day, ad.platform
;






