
/*1  for each director count the no of movies and tv shows created by them in separate columns 
for directors who have created tv shows and movies both */

select d.director, 
count(distinct case when type= 'Movie' then n.show_id end) as No_of_Movies, 
count(distinct case when type= 'TV Show' then n.show_id end) as No_of_TV_Shows
from master.netflix_raw n inner join master.director_by_show d
on n.show_id = d.show_id
where director is not NULL
group by d.director
having No_of_Movies > 0 and No_of_TV_Shows > 0
order by d.director ;


-- 2 which country has highest number of comedy movies
select country, count(g.show_id) as num_of_comedy_movies
from master.genre_by_show g inner join master.country_by_show c on  g.show_id = c.show_id
where genre ='Comedies'
group by country
order by num_of_comedy_movies desc
limit 1; 

-- 3 for each year (as per date added to netflix), which director has maximum number of movies released
With cte1 as (
select year(str_To_date(date_added, '%M%d,%Y')) as year_release, d.director ,count(n.show_id) as no_of_movies, 
row_number() over (partition by year(str_To_date(date_added, '%M%d,%Y')) order by count(n.show_id) desc ) as rn
from master.netflix_raw n inner join master.director_by_show d on n.show_id = d.show_id 
where director is not null and 
type= 'Movie' and date_added is not NULL

group by year(str_To_date(date_added, '%M%d,%Y')), d.director
order by year(str_To_date(date_added, '%M%d,%Y')) desc, no_of_movies desc)
select year_release, director, no_of_movies
from cte1 
where rn = 1

order by year_release;

-- 4 what is average duration of movies in each genre
select genre, round(AVG(cast(replace(duration, ' min','')AS UNSIGNED)),2) as avg_duration
from master.genre_by_show g
inner join master.netflix_raw n on g.show_id = n.show_id
where type = 'Movie'
group by genre
order by genre; 

-- 5  find the list of directors who have created horror and comedy movies both.
-- display director names along with number of comedy and horror movies directed by them 
select director, 
count(distinct case when genre= 'Comedies' then show_id end) as no_of_comedies_movie_directed,
count(distinct case when genre= 'Horror Movies' then show_id end) as no_of_horror_movie_directed
from(
select g.show_id, genre, director
from master.genre_by_show g inner join master.director_by_show d on g.show_id = d.show_id
where genre in ('Comedies', 'Horror Movies') and director is not NULL
order by director) as t
group by director
having no_of_comedies_movie_directed > 0 and no_of_horror_movie_directed > 0  ; 
