
create table dat_table as select datekey_opening,concat(year(datekey_opening),"-",month(datekey_opening),"-",day(datekey_opening)) 
as date_col from zomata_main2;
select *from dat_table;
alter table dat_table modify date_col date;
desc dat_table;
/*Date Table*/
create table Final_dates as select date_col,year(date_col) as "Year",quarter(date_col) as "Quater",case when quarter(date_col)=1 then "QTR-1"
      when quarter(date_col)=2 then "QTR-2"
      when quarter(date_col)=3 then "QTR-3"
	when quarter(date_col)=4 then "QTR-4" end as "Qyarter_Name",month(date_col) as "Month",date_format(date_col,"%M") as "MonthName",
    day(date_col) as "DayNo",
date_format(date_col,"%W") as weekdayName,concat(year(date_col),"-",month(date_col)) as "Year/Month",
case when month(date_col)=4 then "FM-1"
     when month(date_col)=5 then "FM-2"
     when month(date_col)=6 then "FM-3"
     when month(date_col)=7 then "FM-4"
     when month(date_col)=8 then "FM-5"
     when month(date_col)=9 then "FM-6"
     when month(date_col)=10 then "FM-7"
     when month(date_col)=11 then "FM-8"
     when month(date_col)=12 then "FM-9"
     when month(date_col)=1 then "FM-10"
     when month(date_col)=2 then "FM-11"
     when month(date_col)=3 then "FM=12" end as "Financial_Month",
     case when month(date_col) in (4,5,6) then "FQ-1"
           when month(date_col) in (7,8,9) then "FQ-2"
           when month(date_col) in (10,11,12) then "FQ-3"
           when month(date_col) in (1,2,3) then "FQ-4" end as "Financial_Quarter" from dat_table;

/*Currency Conversion*/
alter table zomata_main2 drop column converted_currency;
alter table zomata_main2 add column converted_currency decimal(10,2);
UPDATE zomata_main2 z
JOIN zomata_currency c ON z.currency = c.currency
SET z.converted_currency = z.average_cost_for_two * c.USD_Rate where converted_currency is null;
select *from zomata_main2; 


/*no.of restaurants by city*/
select city,count(restaurantid) from zomata_main2 group by city;

/*No.of Restaurants by country*/
select c.countryname,count(z.restaurantid) as Total_count 
from zomata_main2 z join zomata_country c on z.countrycode=c.countryid group by countryname;

/*Numbers of Resturants opening based on Year , Quarter , Month*/
select count(restaurantid) as "Total_count",year(dates) as "Year",quarter(dates) as "Quarter",month(dates) as 
"Months" from zomata_main2 group by year(dates),quarter(dates),month(dates) order by year(dates);

/*Top rated cuisines*/
select c.countryname,z.cuisines,sum(z.votes) as "Total_votes" from zomata_main2 z join zomata_country c on z.countrycode=c.countryid 
group by c.countryname,z.cuisines order by sum(votes) desc;


/*Top rated cuisine in each country*/
with ranked_cuisines as (select c.countryname,z.cuisines,sum(z.votes) as "Total_votes",
rank() over (partition by countryname order by sum(z.votes) desc) as ranking
from zomata_main2 z join zomata_country c on z.countrycode=c.countryid group by c.countryname,z.cuisines)
select countryname,cuisines,total_votes from ranked_cuisines where ranking=1 order by total_votes desc;

/*Price buckets*/
select case
			when converted_currency between 0 and 100 then "Low_price"
			when converted_currency between 101 and 200 then "average_price"
			when converted_currency between 201 and 300 then "High_Price"
			when converted_currency between 301 and 400 then "Very_high"
			when converted_currency between 401 and 500 then "Extremly_high"
			end as "Price_buckets",count(converted_currency) as "Count",restaurantid from zomata_main2 group by price_buckets,restaurantid;
	
    
    
/*Rating buckets*/
 select case 
           when rating between 1 and 2.5 then "Average"
           when rating between 2.6 and 3.5 then "Good"
           when rating between 3.6 and 4.5 then "Very_good"
           when rating between 4.6 and 5 then "Excellent" end as "rating_buckets",count(rating) as "Rating_Count",restaurantid
           from zomata_main2 group by rating_buckets,restaurantid;



/*Percentage of Resturants based on "Has_Table_booking"*/
 select restaurantid,Has_Table_booking,count(*) as count,
round(count(*) * 100/(select count(*) from zomata_main2),2) as Percentage from zomata_main2 
group by has_table_booking,restaurantid;

/*Percentage of Restaurants based on "Has_online_delivery"*/
select restaurantid,Has_online_delivery,count(*) as count,
round(count(*) * 100/(select count(*) from zomata_main2),2) as Percentage from zomata_main2 
group by has_online_delivery,restaurantid;


/*restaurants by votes*/
select c.countryname,z.restaurantname,sum(z.votes) as "Total_votes" from zomata_main2 z join zomata_country c on z.countrycode=c.countryid 
group by c.countryname,z.restaurantname order by sum(z.votes) desc;


































alter table zomata_main2 add column dates text;

update zomata_main2 set dates=concat(year(datekey_opening),"-",month(datekey_opening),"-",day(datekey_opening)) where dates is null;
select dates from zomata_main2;
alter table zomata_main2 modify dates date;

create table bridg_table as select distinct dates from zomata_main2;






