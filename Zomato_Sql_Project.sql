use zomato_project;

select * from main;
select * from date;
select * from country;
select * from currency;

----------/* Count_of_Restaurant  KPI*/----------

select count(restaurantid) as Count_of_Restaurant from main;

----------/* Count_of_City  KPI*/----------

select count(distinct(city)) as Count_of_City from main;

----------/* Count_of_Country  KPI*/----------

select count(Countryid) as Count_of_Country from country;

----------/* Count_of_Currency  KPI*/----------

select count(currency) as Count_of_Currency from currency;

----------/* Avg_Rating KPI*/----------

select round(avg(rating),2) as Avg_Rating from main;

----------/* Total_Votes KPI*/----------

select concat(round(sum(votes)/1000), "K") as Total_Votes from main;

----------/* Table_Booking */----------

select count(restaurantid) as Count_of_Restaurant, has_table_booking as Table_Booking from main
group by has_table_booking;

----------/* Online_Delivery */----------

select count(restaurantid) as Count_of_Restaurant, has_online_delivery as Online_Delivery from main
group by has_online_delivery;

----------/* Count of Cuisines by Country Name */----------

select count(m.cuisines) as Cuisines, c.countryname 
from main as m 
join country as c on m.countrycode = c.countryid
group by c.countryname
order by Cuisines desc;

----------/* Count of Restaurant by City */----------

select count(restaurantid) as Count_of_Restaurant, City from main
group by city
order by Count_of_Restaurant desc
limit 10;

----------/* Count of Restaurant by Locality */----------

select count(restaurantid) as Count_of_Restaurant, Locality 
from main
group by locality
order by Count_of_Restaurant desc
limit 10;

----------/* Count of Restaurant by Years */----------

select count(restaurantid) as Count_of_Restaurant, year(datekey_opening) as Years
from main
group by year(datekey_opening)
order by years asc;

----------/* Count of Restaurant by Quarters */----------

select count(restaurantid) as Count_of_Restaurant, quarter(datekey_opening) as Quarters
from main
group by quarter(datekey_opening)
order by Quarters asc;

----------/* Count of Restaurant by Months */----------

select count(restaurantid) as Count_of_Restaurant, monthname(datekey_opening) as Months
from main
group by monthname(datekey_opening)
order by field(Months, 'January', 'February', 'March', 'April', 'May', 'June', 
'July','August','September','October','November','December');

----------/* Count of Restaurant by Avg_Rating_Bucket */----------

SELECT count(restaurantid) as Count_of_Restaurant,
Case
        WHEN Rating >= 1 AND Rating <= 2 THEN '1-2'
        WHEN Rating > 2 AND Rating <= 3 THEN '2-3'
        WHEN Rating > 3 AND Rating <= 4 THEN '3-4'
        WHEN Rating > 4 AND Rating <= 5 THEN '4-5'
    END AS Avg_Rating_Bucket
FROM Main
group by Avg_Rating_Bucket
order by Avg_Rating_Bucket;

----------/* Avg_Cost_for_two_in_USD by Avg_Rating_Bucket */----------

select round(avg(m.Average_Cost_for_two * c.`USD Rate`),3) as Avg_Cost_for_two_in_USD,
Case
        WHEN Rating >= 1 AND Rating <= 2 THEN '1-2'
        WHEN Rating > 2 AND Rating <= 3 THEN '2-3'
        WHEN Rating > 3 AND Rating <= 4 THEN '3-4'
        WHEN Rating > 4 AND Rating <= 5 THEN '4-5'
    END AS Avg_Rating_Bucket
    from main as m
join currency as c on c.currency = m.currency
group by Avg_Rating_Bucket
order by Avg_Rating_Bucket;

----------/* Avg_Cost_for_two_in_USD by City */----------

select round(avg(m.Average_Cost_for_two * c.`USD Rate`),3) as Avg_Cost_for_two_in_USD, m.city
from main as m
join currency as c on c.currency = m.currency
group by m.city
order by Avg_Cost_for_two_in_USD desc
limit 5;

----------/* Avg_Cost_for_two_in_USD by Cuisines */----------

select round(avg(m.Average_Cost_for_two * c.`USD Rate`),3) as Avg_Cost_for_two_in_USD, m.Cuisines
from main as m
join currency as c on c.currency = m.currency
group by m.Cuisines
order by Avg_Cost_for_two_in_USD desc
limit 10;

----------/* Count_of_Restaurant by Price_range and City */----------

select count(RestaurantID) as Count_of_Restaurant ,Price_range,city from main
group by Price_range,city
order by Count_of_Restaurant desc
limit 16;

