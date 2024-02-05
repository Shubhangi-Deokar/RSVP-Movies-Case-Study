USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?



Select count(*) from Movie;
-- Number of rows = 7997

Select count(*) from Genre;
-- Number of rows = 14662

Select count(*) from Ratings;
-- Number of rows = 7997

Select count(*) from Director_mapping;
-- Number of rows = 3867

Select count(*) from Names;
-- Number of rows = 25735

Select count(*) from Role_mapping;
-- Number of rows = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Using Case statements counting the number of nulls in each column
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie;

-- Ans:-- This columns have Null values -- Country = 20, worlwide_gross_income = 3724, languages = 194 and production_company = 528.



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year
Select year, count(title) as number_of_movies
from Movie
Group by year;

-- Highest number of movies released in 2017 which is 3052

-- Number of movies released each month
Select Month(date_published) as month_num, 
count(title) as number_of_movies
from Movie
Group by month_num
Order by month_num;

-- *The highest number of movies is produced in the month of March.


-- So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 

-- We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

Select count(DISTINCT id) as number_of_movies, year
from Movie
where (country like '%INDIA%' or country like '%USA%')
and year = 2019;

--  USA and India produced 1059 movies in the year 2019. 


-- /*Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

Select DISTINCT genre
from genre;

-- DISTINCT keyword used to find unique records. 13 genres are present in data set.



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

Select count(m.id) as number_of_movies, genre
from Movie as m
Inner Join genre as g
where g.movie_id = m.id
GROUP BY  genre
ORDER BY  number_of_movies DESC limit 1 ;

-- 4285 drama genre were produced overall

-- /* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
-- But wait, it is too early to decide. A movie can belong to two or more genres. 
-- So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

With Movies_having_one_genre
	As (Select movie_id
		from genre
        Group by movie_id
        Having Count(Distinct genre) = 1)
Select Count(*) as Movies_having_one_genre
from Movies_having_one_genre;

-- /* There are 3289 movies which has only one genre associated with them.

 
-- Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

Select g.genre, avg(m.duration) as avg_duration
from movie as m
Inner join genre as g
on g.movie_id = m.id
Group by genre
Order by avg_duration desc;

-- Action genre has 112.8829 mins duration.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_table AS
		  ( SELECT genre,
				   Count(movie_id) AS movie_count ,
				   Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
           FROM genre                                 
           GROUP BY genre )
SELECT *
FROM genre_table 
WHERE  genre = "THRILLER" ;

-- The rank of 'thriller' genre is 3 with movie count = 1484



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Use Min and Max function

Select Min(avg_rating) as Min_avg_rating,
	   Max(avg_rating) as Max_avg_rating,
       Min(total_votes) as Min_total_votes,
       Max(total_votes) as Max_total_votes,
       Min(median_rating) as Min_median_rating,
       Max(median_rating) as Max_median_rating
from ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

Select title, avg_rating,
	   Rank() over (order by avg_rating desc) as movie_rank
from ratings as r
Inner join movie as m
On m.id = r.movie_id
limit 10;


-- /*At rank 1 there are two movies Kirket and Love in Kilnerry with avg rating 10.*/

-- So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
-- Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

Select median_rating, count(movie_id) as Movie_Count
from ratings
Group by median_rating
Order by Movie_Count desc ;

/*2257 movies are with median rating 7. Movies with a median rating of 7 is highest in number.
 Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

With production_house_of_hit_movies
     AS (Select M.production_company,
                Count(R.movie_id) AS MOVIE_COUNT,
                Rank() OVER( ORDER BY Count(R.movie_id) DESC ) AS PROD_COMPANY_RANK
         From   ratings AS R
                Inner Join movie AS M
				ON M.id = R.movie_id
         Where  avg_rating > 8
                AND production_company IS NOT NULL
         Group By production_company)
Select *
From  production_house_of_hit_movies
Where prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live has rank = 1 and highest no of hit movies = 3


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

Select g.genre, count(m.id) as Movie_Count
from movie as m
	Inner join genre as g
	On M.id = g.Movie_id
	Inner Join ratings as r
	On M.id = r.Movie_id
Where year = 2017
	  and month(date_published) = 3
      and country like '%USA%'
      and total_votes > 1000
Group by genre
Order by Movie_Count desc;

-- 24 Drama movies released in March 2017 in USA with more than 1000 votes.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

Select title,
       avg_rating,
       genre
From  movie As M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
Where avg_rating > 8
       and title LIKE 'THE%'	
Order by avg_rating desc;

-- /*The Brighton Miracle has the highest avg rating of 9.5.*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

Select median_rating, Count(id) as Total_Movies
from Movie as M
Inner Join ratings as R
On M.id = R.movie_id
Where median_rating = 8 And date_published between '2018-04-01' And '2019-04-01'
Group by median_rating;

/*There are 361 Movies released between 1 April 2018 and 1 April 2019 with median rating = 8.*/

-- Now, let's see the popularity of movies in different languages.

-- Q17. Do German language movies get more votes than Italian language movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Type your code below:

Select languages, sum(total_votes) as Votes
from Movie as M
Inner Join Ratings as R
On M.id = R.Movie_id
Where languages =  'Italian' or languages = 'German'
Group by languages;


-- Italian language movies get more votes (100653) than German language Movies (79384).


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

Select 
		Sum(Case 
			When name is Null then 1 
            else 0 End) as name_nulls,
		Sum(Case 
			When height is Null then 1 
            else 0 End) as height_nulls,
		Sum(Case 
			When date_of_birth is Null then 1 
            else 0 End) as date_of_birth_nulls,
		Sum(Case 
			When known_for_movies is Null then 1 
            else 0 End) as known_for_movies_nulls
from names;

/*height, date of birth, known for movies columns have Null values. There are no Null value in the column 'name'.*/



-- The director is the most important person in a movie crew. 
-- Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

With top_3_genres As
(		   SELECT genre,
				   Count(m.id) As movie_count ,
				   Rank() Over(Order by Count(m.id) desc) As genre_rank
           From movie As m
		   Inner Join genre As g
				ON g.movie_id = m.id
			Inner Join ratings AS r
				ON r.movie_id = m.id
           Where avg_rating > 8
           Group by genre )
Select n.Name As director_name ,
	   Count(d.movie_id) As movie_count
From director_mapping  As d
Inner Join  genre G
using (movie_id)
Inner Join names As n
On n.id = d.name_id
Inner Join top_3_genres
using (genre)
Inner Join  ratings
using (movie_id)
Where avg_rating > 8
Group by NAME
Order by movie_count desc 
limit 3 ;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. */

-- Now, let’s find out the top two actors.

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT N.name AS actor_name,
       Count(movie_id) AS movie_count
FROM role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R 
			   USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;

/* The top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal*/



-- RSVP Movies plans to partner with other global production houses. 
-- Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

Select production_company,
	   Sum(total_votes) As vote_count,
	   Rank() Over(Order by Sum(total_votes) desc) As prod_comp_rank
From movie As m
	Inner Join ratings As r
	On r.movie_id = m.id
Group by production_company 
limit 3;

/*Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox, Warner Bros. Yes Marvel Studios rules the movie world.*/



-- So, these are the top three production houses based on the number of votes received by the movies they have produced.

-- Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
-- RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
-- Let’s find who these actors could be.

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- To resolve error code 1055.

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT n.name AS actor_name,
	   r.total_votes as total_votes,
       COUNT(r.movie_id) as movie_count,
	   ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) AS actor_avg_rating, 
       RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) DESC) AS actor_rank
FROM names as n
INNER JOIN role_mapping as rm
ON n.id = rm.name_id
INNER JOIN ratings as r
ON rm.movie_id = r.movie_id
INNER JOIN movie as m
ON m.id = r.movie_id
WHERE rm.category="actor" AND m.country="India"
GROUP BY n.name
HAVING COUNT(r.movie_id) >= 5;

-- OR

WITH actor_ratings AS
(
SELECT 
	n.name as actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(
		SUM(r.avg_rating*r.total_votes)
        /
		SUM(r.total_votes)
			,2) AS actor_avg_rating
FROM
	names AS n
		INNER JOIN
	role_mapping AS a
		ON n.id=a.name_id
			INNER JOIN
        movie AS m
			ON a.movie_id = m.id
				INNER JOIN
            ratings AS r
				ON m.id=r.movie_id
WHERE category = 'actor' AND LOWER(country) like '%india%'
GROUP BY actor_name
)
SELECT *,
	RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM
	actor_ratings
WHERE movie_count>=5;

/* At first position Vijay Sethupathi with average rating 8.42. Top actor is Vijay Sethupathi*/


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name,
	   r.total_votes as total_votes,
       COUNT(r.movie_id) as movie_count,
	   ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) AS actress_avg_rating, 
       RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) DESC) AS actress_rank
FROM names as n
INNER JOIN role_mapping as rm
ON n.id = rm.name_id
INNER JOIN ratings as r
ON rm.movie_id = r.movie_id
INNER JOIN movie as m
ON m.id = r.movie_id
WHERE rm.category="actress" AND m.languages like '%Hindi%' AND m.country="India"
GROUP BY n.name
HAVING COUNT(r.movie_id) >= 3
limit 5;

/* Taapsee Pannu is at rank 1 with average rating 7.74 and movie count = 3 followed by Kriti Sanon.*/


-- Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies
     AS (SELECT DISTINCT title, avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies; 


 
-- Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
	   ROUND(AVG(duration),2) AS avg_duration,
       SUM(AVG(duration)) OVER(ORDER BY genre) AS running_total_duration,
	   AVG(AVG(duration)) OVER(ORDER BY genre) AS moving_avg_duration
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre
AS (SELECT genre,
           COUNT(movie_id) as movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3),
top5_movie
AS (SELECT genre, YEAR,
		   title as movie_name,
           worlwide_gross_income,
DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN(SELECT genre FROM top3_genre)
)
SELECT *
FROM top5_movie
WHERE movie_rank<=5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_companies
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
				ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank() over(ORDER BY movie_count DESC) AS prod_comp_rank
FROM   top_production_companies
LIMIT 2; 

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name as actress_name, 
	   SUM(total_votes) As total_votes,
       COUNT(rm.movie_id) As movie_count, 
       Round(Sum(avg_rating * total_votes)/Sum(total_votes),2) As actress_avg_rating,
	   RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) As actress_rank
FROM names as n
INNER JOIN role_mapping as rm
ON n.id = rm.name_id
INNER JOIN ratings as r
ON r.movie_id = rm.movie_id
INNER JOIN genre as g
ON g.movie_id = r.movie_id
WHERE category="actress" AND avg_rating>8 AND g.genre="Drama"
GROUP BY name
LIMIT 3;

-- Parvathy Thiruvothu, Susan Brown, Amanda Lawrence are the top 3 actresses based on number of Super Hit movies.  



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(SELECT     d.name_id,
			NAME,
            d.movie_id,
            duration,
			r.avg_rating,
			total_votes,
			m.date_published,
			Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM       director_mapping As d
           INNER JOIN names                                                                                 AS n
           ON n.id = d.name_id
           INNER JOIN movie AS m
           ON m.id = d.movie_id
           INNER JOIN ratings AS r
           ON r.movie_id = m.id ), top_director_summary AS
(SELECT *, Datediff(next_date_published, date_published) AS date_difference
FROM   next_date_published_summary )
SELECT   name_id AS director_id,
         NAME AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





