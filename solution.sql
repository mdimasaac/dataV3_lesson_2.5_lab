-- 1. Select all the actors with the first name ‘Scarlett’.
-- 2. How many films (movies) are available for rent and
--    how many films have been rented?
-- 3. What are the shortest and longest movie duration?
--    Name the values max_duration and min_duration.
-- 4. What's the average movie duration expressed in format (hours, minutes)?
-- 5. How many distinct (different) actors' last names are there?
-- 6. Since how many days has the company been operating (check DATEDIFF() function)?
-- 7. Show rental info with additional columns month and weekday. Get 20 results.
-- 8. Add an additional column day_type with values
--    'weekend' and 'workday' depending on the rental day of the week.
-- 9. Get release years.
-- 10. Get all films with ARMAGEDDON in the title.
-- 11. Get all films which title ends with APOLLO.
-- 12. Get 10 the longest films.
-- 13. How many films include Behind the Scenes content?

-- 1
use sakila;
select * from actor where first_name = "Scarlett";
-- 2
select
(select count(*) from rental
where date(return_date) >= date(rental_date)) as "available",
(select count(*) from rental
where return_date is null)as "rented";
-- if return_date is more actual (higher than) rental_date,
-- then we assume the film is available in store
-- if return_date is null, then we assume the film is still being rented

-- select * from rental;
-- select * from inventory;
-- -- select sum(distinct film_id) from inventory group by film_id, store_id;
-- 3
 select max(length) as "max", min(length) as "min" from film;
-- 4
select SEC_TO_TIME(round(avg(length*60),0)) AS "average" from film;
-- the length in minute is converted to second (multiply by 60),
-- and then convert to time format using sec_to_time
-- 5
SELECT COUNT(DISTINCT last_name) AS distinct_surnames FROM actor;
-- 6
select datediff(Max(last_update),MIN(rental_date)) FROM rental;
-- is calculated from the first day the store rented a film, to the last update
-- 7
SELECT *, MONTHNAME(rental_date) AS month, 
DAYNAME(rental_date) AS weekday FROM rental LIMIT 20;
-- 8
-- select case when rental_date
SELECT *, MONTHNAME(rental_date) AS month, 
DAYNAME(rental_date) AS weekday,
CASE
WHEN dayname(rental_date)
IN ('Saturday', 'Sunday')
THEN 'Weekend' 
ELSE 'Weekday'
END
AS day_type FROM rental;
-- giving value "weekend" for all saturdays and sundays,
-- giving value "weekday" otherwise
-- 9
select distinct release_year from film;
-- 10
SELECT * FROM film WHERE title like '%ARMAGEDDON%'; 
-- 11
SELECT * FROM film WHERE title like '%apollo';
-- no percent sign on the right side means apollo needs to be the last word
-- 12
select title, length from film order by length desc limit 10;
-- 13
SELECT COUNT(title) FROM film WHERE special_features LIKE '%Behind the Scenes%';