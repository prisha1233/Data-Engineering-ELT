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
    select show_id , pos, name1 
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
    select show_id , pos, directordirector_by_show
    from recurs
    order by show_id, pos;
    ; 

