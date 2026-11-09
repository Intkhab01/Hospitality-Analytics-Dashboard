use project;

select count(*) from fact_bookings;  -- # count(*) '134590'

select * from fact_bookings;

select sum(revenue_realized) Total_revenue from fact_bookings; -- # Total_revenue '1708771229'
select sum(revenue_realized) Total_revenue from fact_bookings
where booking_status<>"cancelled";   -- 1509587905

select sum(revenue_realized)/count(booking_id) from fact_bookings
where booking_status<>"cancelled";   -- 14921.2998
 select sum(revenue_realized)/count(booking_id) from fact_bookings; -- '12696.1233'

select count(*) from fact_bookings;

-- 	Q1. city_wise revenue
select city,sum(revenue_realized) Revenue from 
dim_hotel d inner join fact_bookings f
on d.property_id=f.property_id
where booking_status in("no show","checked out")
group by city
order by revenue desc;

-- Q2 property_wise revenue
select h.PROperty_name,sum(f.revenue_realized)
from dim_hotel h join fact_bookings f
on h.property_id=f.property_id
where booking_status in("no show","checked out")
group by h.property_name
order by property_name desc;

-- Q3 category_wise revenue
select h.category,sum(f.revenue_realized)
from dim_hotel h join fact_bookings f
on h.property_id=f.property_id
 where booking_status in("no show","checked out")
group by h.category
order by category desc;

-- Q4 Day_type_wise revenue
select day_type,sum(revenue_realized)
from dim_date d join fact_bookings f
on d.new_date=f.checkout_date
where booking_status in("no show","checked out")
group by day_type
order by day_type desc;

-- monthly revenue
select month,`month name`,sum(revenue_realized)
from dim_date d inner join fact_bookings f
on d.new_date=f.checkout_date
where booking_status in("no show","checked out")
group by month,`month name`
order by month desc;

-- Result Q6 room class wise revenue
select r.room_class,sum(f.revenue_realized) Total_revenue
from dim_rooms r join fact_bookings f
on r.room_id=f.room_category
where booking_status in("no show","checked out")
group by room_class
order by Total_revenue desc;

 
create or replace view Total_revenue_view as select sum(revenue_realized) total_revenue  from fact_bookings
where booking_status<>"cancelled";
create view Total_bookings_view as select count(successful_bookings) total_bookings from fact_aggregated_bookings;
select * from total_revenue_view;
select * from total_booking;

select
(select count(*) from fact_bookings
where booking_status="checked out")*100.0/count(*) as 'checkout%' from fact_bookings;

select round(count(case when booking_status="checked out" then 1 end)*100.0/count(*),2)checked_out_pct from fact_bookings;

select booking_status,total_bookings,round(total_bookings*100.0/sum(total_bookings) over(),2)booking_status_pct
 from(
select booking_status,count(*)total_bookings from fact_bookings
group by booking_status)t
group by booking_status;

create view	Total_no_show as
select count(*) no_show from fact_bookings
where booking_status="no show";

create view Total_cancelled_bookings as
select count(*) Cancelled from fact_bookings
where booking_status="cancelled";

create view Total_checked_out as
select count(*) Total_checked_out from fact_bookings
where booking_status="checked out";

create or replace view checked_out_percentage as
select(count(case when booking_status="checked out" then 1 end)*100.0)/
count(*) as 'checked_out_%' from fact_bookings;

create or replace view cancellation_percentage as
select (count(case when booking_status="cancelled" then 1 end)*100.0)/
count(*) as 'cancellation%' from fact_bookings;

create or replace view no_show_percentage as
select(count(case when booking_status="no show" then 1 end)*100.0)/
count(*) as "no_show%" from fact_bookings;

-- create view average_rating as
select  round(avg(ratings_given),2)from fact_bookings
where ratings_given>0;

-- create view Total_capacity as
select sum(capacity) from fact_aggregated_bookings;

create view occupancy_percentage as
select round(sum(successful_bookings)*100.0/sum(capacity),2)as "occupancy%" from fact_aggregated_bookings;

create view Total_successfull_bookings as
select sum(successful_bookings) from fact_aggregated_bookings;

select booking_platform  ,count(*) Total_bookings,
concat(round(count(*) *100.0 / sum(count(*)) over(),2),"%") as "booking%"
from fact_bookings
group by booking_platform
order by total_bookings desc;

select room_class,count(*),count(*)*100.0/sum(count(*)) over() from dim_rooms 
join fact_bookings on fact_bookings.room_category=dim_rooms.room_id
group by room_class
order by room_class desc;

select sum(revenue_realized)/count(*) from fact_bookings;

select booking_status,count(*)*100.0/sum(
count(*)) over() from fact_bookings
group by booking_status;

select booking_status,concat(round(count(*)*100.0/sum(
count(*)) over(),2),"%") from fact_bookings
group by booking_status;

select * from dim_rooms;
select * from fact_bookings;

select booking_status,sum(revenue_realized) from fact_bookings
group by booking_status;

create view project_view as
select h.city,h.property_name,h.category,
r.room_class,r.room_id,d.new_date,d.day_type,d.`day name`as day_name,d.`month name`as month_name,d.`week no`,
f.booking_date,f.booking_platform,f.ratings_given,f.booking_status,
f.revenue_realized,f.payment_method,f.country,f.booking_channel,f.cancellation_reason
from dim_hotel h inner join fact_bookings f on f.property_id=h.property_id 
join dim_rooms r on r.room_id=f.room_category
join dim_date d on d.new_date = f.check_in_date;

create view project_view1 as
select capacity,successful_bookings,room_category from fact_aggregated_bookings;

select sum(revenue_realized) from fact_bookings  where booking_status in ("no show","checked out");

select cancellation_reason ,count(*) Total_bookings,
concat(round(count(*) *100.0 / sum(count(*)) over(),2),"%") as "cancellation%"
from fact_bookings
where cancellation_reason not in('')
group by cancellation_reason
order by total_bookings desc;











