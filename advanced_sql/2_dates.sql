-- SELECT
--     COUNT(job_id),
--     EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS date_month
-- FROM
--     job_postings_fact
-- WHERE
--     EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') = 2023
-- GROUP BY
--     date_month
-- ORDER BY
--     date_month 
-- LIMIT 20;





-- SELECT 
--     COUNT(job_id) AS job_posted_count,
--     EXTRACT(MONTH FROM job_posted_date) AS date_month
-- FROM
--     job_postings_fact
-- WHERE
--     job_title_short = 'Data Analyst'
-- GROUP BY
--     date_month
-- ORDER BY
--     job_posted_count DESC;




-- SELECT
--     COUNT(job_id) AS number_of_jobs,
--     CASE
--         WHEN job_location = 'Anywhere' THEN 'Remote'
--         WHEN job_location = 'New York, NY' THEN 'Local'
--         ELSE 'Onsite'
--     END AS location_type
-- FROM
--      job_postings_fact
-- WHERE
--     job_title_short = 'Data Analyst'
-- GROUP BY
--     location_type;


-- SELECT
--     job_title_short,
--     salary_year_avg,
--     CASE
--         WHEN salary_year_avg < 40000 THEN 'Low'
--         WHEN salary_year_avg <= 80000 THEN 'Standard'
--         WHEN salary_year_avg > 80000 THEN 'High'
--         ELSE 'Unknown'
--     END AS salary_category
-- FROM
--     job_postings_fact
-- WHERE
--     job_title_short = 'Data Analyst'
-- ORDER BY
--     salary_year_avg DESC
-- LIMIT 20;





-- SELECT
--     company_id,
--     name AS company_name
-- FROM
--     company_dim
-- WHERE company_id IN (
--     SELECT
--             company_id
--     FROM
--             job_postings_fact
--     WHERE
--             job_no_degree_mention = TRUE
--     ORDER BY
--             company_id
-- )

-- -- SOLUTION WITHOUT SUBQUERY
-- SELECT 
--     skills,
--     COUNT(job_id) AS number_of_jobs
-- FROM skills_dim
-- LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
-- GROUP BY skills 
-- ORDER BY
--         number_of_jobs DESC
-- LIMIT 5;

-- SELECT
--     skills_dim.skills,
--     new_dim.job_count
-- FROM (
--     SELECT
--         COUNT(job_id) AS job_count,
--         skill_id
--     FROM
--         skills_job_dim
--     GROUP BY
--         skill_id
--     ORDER BY
--         job_count DESC
--     LIMIT 5
-- ) AS new_dim

-- INNER JOIN skills_dim ON skills_dim.skill_id = new_dim.skill_id

-- ORDER BY
--         job_count DESC


-- SELECT
--         name AS company_name,
--         number_of_jobs,
--         CASE 
--             WHEN number_of_jobs < 10 THEN 'small'
--             WHEN number_of_jobs BETWEEN 10 AND 50 THEN 'medium'
--             WHEN number_of_jobs > 50 THEN 'large'
--             ELSE 'unknown'
--         END
-- FROM(
--         SELECT
--                 COUNT(job_id) number_of_jobs,
--                 company_id
                
--         FROM
--                 job_postings_fact
--         GROUP BY
--                 company_id 
-- ) AS new_fact_table

-- INNER JOIN company_dim ON new_fact_table.company_id = company_dim.company_id



-- --SOLVING by subquery
-- SELECT
--         skills,
--         COUNT(new_fact_table.job_id) AS number_of_jobs
-- FROM(
--         t        job_id
--         FROM
--                 job_postings_fact
--         WHERE
--                 job_work_from_home = TRUE
-- ) AS new_fact_table

-- INNER JOIN skills_job_dim ON new_fact_table.job_id = skills_job_dim.job_id
-- INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

-- GROUP BY skills
-- ORDER BY number_of_jobs DESC

-- LIMIT 5;

-- --CTA
-- WITH connection AS(
--         SELECT
--                 skill_id,
--                 COUNT(job_postings_fact.job_id) AS job_count
--         FROM
--                 job_postings_fact
--         INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
--         WHERE 
--                 job_work_from_home = TRUE AND
--                 job_title_short = 'Data Analyst'
--         GROUP BY
--                 skill_id
-- )

-- SELECT 
--         connection.skill_id,
--         job_count,
--         skills
-- FROM connection
-- INNER JOIN skills_dim ON connection.skill_id = skills_dim.skill_id
-- LIMIT 5

-- SELECT 
--         job_posted_date,
--         skills,
--         type
-- FROM january_jobs
-- LEFT JOIN skills_job_dim ON january_jobs.job_id = skills_job_dim.job_id
-- LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
-- WHERE salary_year_avg > 70000

-- UNION ALL

-- SELECT 
--         job_posted_date,
--         skills,
--         type
-- FROM february_jobs
-- LEFT JOIN skills_job_dim ON february_jobs.job_id = skills_job_dim.job_id
-- LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
-- WHERE salary_year_avg > 70000


-- UNION ALL

-- SELECT 
--         job_posted_date,
--         skills,
--         type
-- FROM march_jobs
-- LEFT JOIN skills_job_dim ON march_jobs.job_id = skills_job_dim.job_id
-- LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

-- WHERE salary_year_avg > 70000

-- SELECT
--         job_title_short,
--         salary_year_avg
-- FROM  january_jobs
-- WHERE
--         salary_year_avg > 70000

-- UNION ALL

-- SELECT
--         job_title_short,
--         salary_year_avg
-- FROM  february_jobs
-- WHERE
--         salary_year_avg > 70000

-- UNION ALL

-- SELECT
--         job_title_short,
--         salary_year_avg
-- FROM  march_jobs
-- WHERE
--         salary_year_avg > 70000



-- SELECT 
--         salary_year_avg,
--         job_title_short,
--         job_posted_date,
--         job_via
-- FROM(
--         SELECT *
--         FROM january_jobs
--         UNION ALL
--         SELECT *
--         FROM february_jobs
--         UNION ALL
--         SELECT *
--         FROM march_jobs
-- ) AS quarter1

-- WHERE 
-- salary_year_avg > 70000 AND
-- job_title_short = 'Data Analyst'
-- ORDER BY salary_year_avg DESC


