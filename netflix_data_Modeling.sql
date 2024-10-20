
alter TABLE master.netflix_raw 
modify show_id varchar(10) NOT NULL Primary key,
modify type varchar(10),
modify title varchar(125),
modify director varchar(225),
modify cast varchar(800),
modify country varchar(150),
modify date_added varchar(100),
modify release_year int,
modify rating varchar(10),
modify duration varchar(20),
modify listed_in varchar(100),
modify description varchar(300) ; 
  
 SELECT * FROM master.netflix_raw
where type = 'TV Show'
order by date_added;

select *
from master.netflix_raw
where type is NULL; 

select distinct type
from master.netflix_raw; 

select *
from master.netflix_raw
where title is NULL; 

select *
from master.netflix_raw
where director is NULL
order by title;

select count(*)
from master.netflix_raw
where cast is NULL; 

select *
from master.netflix_raw
where country is null; 

select *
from master.netflix_raw
where date_added is null;

select *
from master.netflix_raw
where release_year is NULL;

select *
from master.netflix_raw
where rating is NULL; 

SELECT DISTINCT RATING
FROM MASTER.netflix_raw;

select *
from master.netflix_raw
where DURATION is NULL; 
select *
from master.netflix_raw
where listed_in is NULL;

SELECT DISTINCT listed_In
FROM MASTER.netflix_raw
order by listed_in;