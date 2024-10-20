-- Performing data modeling & cleanning on Netflix Raw Data

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

select *
from master.netflix_raw;

/*handiling foreign characters*/
select distinct title
from master.netflix_raw; 

/* removing duplicates*/
select show_id, count(*) as num_of_repetition
from master.netflix_raw
group by show_id
having count(*) > 1; 
/** all show id is unique. It can use as Primary key. */

with cte1 as (
select title, type, count(*) as num_of_rep
from master.netflix_raw
group by upper(title), type
having count(*) > 1 )
select n1.*
from master.netflix_raw n1 inner join cte1 c1 on n1.title= c1.title
order by n1.title; 

/* duplicate records:Sin senos sí hay paraíso, Veronica, Love in a Puff, Esperando la carroza **/

/** Now we need to delete duplicate records from Netflix_raw table  **/
with cte1 as (
select title, type, row_number() over (partition by title, type order by title) as rn, show_id
from master.netflix_raw)
delete from master.netflix_raw
where show_id in (
select show_id
from cte1
where rn > 1); 

select count(*)
from master.netflix_raw;

/*** Breaking listed_in column into multiple rows and store as table genre table for analysis purpose ***/ 
create table master.genre_by_show
with recursive
  input as (
        select show_id, listed_in as names
        from master.netflix_raw
    ),
  recurs as (
        select show_id, 1 as pos, names as remain, substring_index( names, ',', 1 ) as name1
          from input
      union all
        select show_id, pos + 1, substring( remain, char_length( name1 ) + 2 ),
            substring_index( substring( remain, char_length( name1 ) + 2 ), ',', 1 )
          from recurs
          where char_length( remain ) > char_length( name1 )
    )
    select show_id , pos, trim(name1) as genre 
    from recurs
    order by show_id, pos;
    ; 
    
/*** breaking multiple director from same title into multiple rows and save as director table **/
create table master.director_by_show
with recursive
  input as (
        select show_id, director as directors
        from master.netflix_raw
    ),
  recurs as (
        select show_id, 1 as pos, directors as remain, substring_index( directors, ',', 1 ) as director
          from input
      union all
        select show_id, pos + 1, substring( remain, char_length( director ) + 2 ),
            substring_index( substring( remain, char_length(director ) + 2 ), ',', 1 )
          from recurs
          where char_length( remain ) > char_length( director )
    )
    select show_id , pos, trim(director) as director
    from recurs
    order by show_id, pos;
    
create table master.country_by_show
with recursive
  input as (
        select show_id, country as  countries
        from master.netflix_raw
    ),
  recurs as (
        select show_id, 1 as pos, countries as remain, substring_index( countries, ',', 1 ) as country
          from input
      union all
        select show_id, pos + 1, substring( remain, char_length( country ) + 2 ),
            substring_index( substring( remain, char_length(country ) + 2 ), ',', 1 )
          from recurs
          where char_length( remain ) > char_length( country )
    )
    
    select show_id , pos, trim(country) as country
    from recurs
    order by show_id, pos;
  
  select  show_id, country
  from master.country_by_show
  where country is NULL; 
  
  /** Replacing NULL values with correct country name by assuming director's names are unique globally. **/
  insert into master.country_by_show (show_id, pos,country)
  select show_id, 1 as pos, m.country 
  from master.netflix_raw n
  inner join (
  select distinct director , country,
  row_number() over (partition by director order by director) as rn
  from master.netflix_raw
  where country is not NULL and director is not NULL 
  group by director, country
  order by director) as m on m.director = n.director
  where rn = 1 and n.country is NULL
  ;
  
  /** Successfully inserted country name for those reocrds where country is null for 148 show_ids **/
  
  /** Need to delete Null records where country record replace **/
  delete from master.country_by_show
  where  show_Id in (
select show_id
-- show_id, 1 as pos, m.country 
  from master.netflix_raw n
  inner join (
  select distinct director , country,
  row_number() over (partition by director order by director) as rn
  from master.netflix_raw
  where country is not NULL and director is not NULL 
  group by director, country
  order by director) as m on m.director = n.director
  where rn = 1 and n.country is NULL ) and country is NULL
  ;

/** successfully deleted duplicate show_id records where Country is NULL. **/

select *
from master.netflix_raw
where duration is NULL; 
/** now, there are 3 records where Duration is NULL
  duration value populated in rating. Update duration values correctly wherever its null
 **/
update master.netflix_raw 
set duration = rating
 where duration is NULL; 
 
 /** I am trying to analyze what is possible rating for those 3 records **/
 /** common for 3 records-  director Louis C.K., type=  movie, country = United states
**/

select *
from master.netflix_raw
where country = 'United States' and type= 'Movie' and listed_in like '%Comedies%' ; 
/** there is nothing common based on above information **/


-- drop columns director , listed_in,country
alter table master.netflix_raw
drop director, 
drop listed_in,
drop country ; 

select *
from master.netflix_raw; 





