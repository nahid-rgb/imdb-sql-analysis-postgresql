DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
    Poster_Link TEXT,
    Series_Title TEXT,
    Released_Year TEXT,
    Certificate TEXT,
    Runtime TEXT,
    Genre TEXT,
    IMDB_Rating TEXT,
    Overview TEXT,
    Meta_score TEXT,
    Director TEXT,
    Star1 TEXT,
    Star2 TEXT,
    Star3 TEXT,
    Star4 TEXT,
    No_of_Votes TEXT,
    Gross TEXT
);

-- Dataset exported from kaggle => https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows


-- Data Cleaning Steps
-- -------------------

Create a cleaned copy of the original table
DROP TABLE IF EXISTS movies_cleaned;

CREATE TABLE movies_cleaned AS
SELECT * FROM movies;

-- Remove commas from numeric fields
UPDATE movies_cleaned
SET 
    gross = REPLACE(gross, ',', ''),
    no_of_votes = REPLACE(no_of_votes, ',', '');

-- Convert numeric columns to proper data types
ALTER TABLE movies_cleaned
ALTER COLUMN gross TYPE BIGINT USING NULLIF(gross, '')::BIGINT,
ALTER COLUMN no_of_votes TYPE BIGINT USING NULLIF(no_of_votes, '')::BIGINT,
ALTER COLUMN meta_score TYPE INT USING NULLIF(meta_score, '')::INT,
ALTER COLUMN imdb_rating TYPE FLOAT USING NULLIF(imdb_rating, '')::FLOAT;

-- Convert text columns to VARCHAR
ALTER TABLE movies_cleaned
ALTER COLUMN certificate TYPE VARCHAR(15),
ALTER COLUMN genre TYPE VARCHAR(100),
ALTER COLUMN director TYPE VARCHAR(100),
ALTER COLUMN star1 TYPE VARCHAR(100),
ALTER COLUMN star2 TYPE VARCHAR(100),
ALTER COLUMN star3 TYPE VARCHAR(100),
ALTER COLUMN star4 TYPE VARCHAR(100),
ALTER COLUMN poster_link TYPE VARCHAR(300),
ALTER COLUMN overview TYPE VARCHAR(1000);

-- Rename column and set VARCHAR
ALTER TABLE movies_cleaned
RENAME COLUMN series_title TO movies_title;

ALTER TABLE movies_cleaned
ALTER COLUMN movies_title TYPE VARCHAR(200);

-- Extract numeric runtime into runtime_min
ALTER TABLE movies_cleaned
ADD COLUMN runtime_min INT;

UPDATE movies_cleaned
SET runtime_min = NULLIF(regexp_replace(runtime, '\D', '', 'g'), '')::INT;

-- Drop original runtime column
ALTER TABLE movies_cleaned
DROP COLUMN runtime;

-- Handle non-numeric released_year values
UPDATE movies_cleaned
SET released_year = NULL
WHERE released_year NOT SIMILAR TO '[0-9]{4}';

-- Convert released_year to INT
ALTER TABLE movies_cleaned
ALTER COLUMN released_year TYPE INT USING released_year::INT;


-- Drop unused text columns that are not relevant for SQL-based analysis.
ALTER TABLE movies_cleaned 
DROP COLUMN poster_link,
DROP COLUMN overview;

SELECT * FROM movies_cleaned;


-- Checking duplicate 
SELECT movies_title, released_year, COUNT(*)
FROM movies_cleaned 
GROUP BY movies_title, released_year
HAVING COUNT(*)>1;  -- No duplicates found 


SELECT movies_title ,COUNT(*)
FROM movies_cleaned 
GROUP BY movies_title
HAVING COUNT(*)>1; -- 2 duplicates 

-- but they are remake of Drishyam so no duplicates
SELECT *
FROM movies_cleaned
WHERE movies_title IN (
  SELECT movies_title
  FROM movies_cleaned
  GROUP BY movies_title
  HAVING COUNT(*) > 1
)
ORDER BY movies_title, released_year;



-- query start from here 
SELECT * FROM movies_cleaned;

-- 1. Show Max, Min and Avg imdb rating.
SELECT 
     MAX(imdb_rating) AS max_imdb_rating,
	 MIN(imdb_rating) AS min_imdb_rating,
	 ROUND(AVG(imdb_rating)::numeric,2)AS avg_imdb_rating
FROM movies_cleaned;

--  2. Show Max, Min and Avg gross
SELECT 
     MAX(gross) AS max_gross,
	 MIN(gross) AS min_gross,
	 ROUND(AVG(gross)::numeric,2)AS avg_gross
FROM movies_cleaned;



--  3. Show Max, Min and Avg no_of_votes
SELECT 
     MAX(no_of_votes) AS max_no_of_votes,
	 MIN(no_of_votes) AS min_no_of_votes,
	 ROUND(AVG(no_of_votes)::numeric,0)AS avg_no_of_votes
FROM movies_cleaned;

-- 4. Show Max, Min and Avg runtime.
SELECT 
     MAX(runtime_min) AS max_runtime_min,
	 MIN(runtime_min) AS min_runtime_min,
	 ROUND(AVG(runtime_min)::numeric,2)AS avg_runtime_min
FROM movies_cleaned;


-- 5.  Show a sample of 5 movies released after 2010.
SELECT *
FROM movies_cleaned
WHERE released_year >2010 
ORDER BY released_year
LIMIT 5;


-- 6. Show all movies with an IMDb rating greater than 9.
SELECT * 
FROM movies_cleaned
WHERE imdb_rating > 9 ;


-- 7. Show a sample of 3 movies where the genre contains "Drama".
SELECT * 
FROM movies_cleaned
WHERE genre ILIKE '%Drama%'
LIMIT 3;

-- 8. Show a sample of 3 movies directed by Christopher Nolan.
SELECT * 
FROM movies_cleaned
WHERE director = 'Christopher Nolan'
LIMIT 3;

-- 9. Count how many movies have a certificate of "U"
SELECT COUNT(*)
FROM movies_cleaned 
WHERE certificate = 'U';


-- 10. List top 5 movies by IMDb rating
SELECT *
FROM movies_cleaned 
ORDER BY imdb_rating DESC
LIMIT 5;


-- 11.Get top 3 movies with runtime over 150 minutes 
SELECT *
FROM movies_cleaned 
WHERE runtime_min > 150 
ORDER BY runtime_min DESC
LIMIT 3;

-- 12. Show the first 3 movies (alphabetically) that have missing gross earnings.
SELECT *
FROM movies_cleaned 
WHERE gross IS NULL
ORDER BY movies_title ASC
LIMIT 3;

-- 13. Which 10 directors have made the most movies in the dataset?
SELECT director ,COUNT(*) AS movies_count
FROM movies_cleaned 
GROUP BY director
ORDER BY movies_count DESC
LIMIT 10;

-- 14. Year with the most movie releases
SELECT released_year ,COUNT(*) AS movie_release_count
FROM movies_cleaned 
GROUP BY released_year
ORDER BY  movie_release_count DESC
LIMIT 1;

-- 15. Which 5 years had the highest total box office gross?

/*SELECT *
FROM 
	(SELECT released_year ,SUM(gross) AS gross_count_per_year
	FROM movies_cleaned 
	GROUP BY released_year
	ORDER BY gross_count_per_year DESC) AS subquery
WHERE  gross_count_per_year IS NOT NULL;
	*/
	
SELECT released_year ,SUM(gross) AS gross_count_per_year
FROM movies_cleaned 
WHERE gross IS NOT NULL
GROUP BY released_year
ORDER BY gross_count_per_year DESC
LIMIT 5;

-- 16. Top 5 most voted movies	
SELECT *
FROM movies_cleaned 
ORDER BY no_of_votes DESC
LIMIT 5;


-- 17. Number of unique certificates
SELECT COUNT(DISTINCT certificate)
FROM movies_cleaned 
WHERE certificate IS NOT NULL;

-- 18. Most frequent genres (as-is, not normalized)
SELECT genre, COUNT(*) AS genre_count
FROM movies_cleaned 
WHERE genre IS NOT NULL
GROUP BY genre 
ORDER BY genre_count DESC
LIMIT 5;


-- 19.Which 5 movie certificates have the highest average Meta Score?
SELECT certificate, ROUND(AVG(meta_score)::numeric,2) AS avg_meta_score
FROM movies_cleaned 
WHERE certificate IS NOT NULL AND meta_score IS NOT NULL
GROUP BY certificate
ORDER BY avg_meta_score DESC
LIMIT 5;


-- 20.How many movies were released in each decade? Show the 5 most recent decades..
SELECT FLOOR(released_year/10)*10 AS decade, COUNT(*) AS movie_count
FROM movies_cleaned 
WHERE released_year IS NOT NULL
GROUP BY decade 
ORDER BY movie_count DESC
LIMIT 5;

-- 21. Which are the top-rated movies across different genres based on IMDb rating? Show the top 5 among them
SELECT movies_title, genre, imdb_rating
FROM (
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY genre ORDER BY imdb_rating DESC) AS movie_rank
	FROM movies_cleaned
) AS ranked_movies
WHERE movie_rank = 1
ORDER BY imdb_rating DESC
LIMIT 5;


-- 22. Which movie has the second highest total gross earnings?
SELECT movies_title, gross
FROM movies_cleaned
ORDER BY gross 
OFFSET 1
LIMIT 1;


-- 23.List the first 5 movies whose runtime is above the average runtime.
SELECT movies_title, runtime_min
FROM movies_cleaned
WHERE runtime_min > (
    SELECT AVG(runtime_min)
    FROM movies_cleaned
    WHERE runtime_min IS NOT NULL
)
ORDER BY runtime_min DESC
LIMIT 5;


-- 24.Show the top 5 movies ranked by gross earnings within their genres.
SELECT movies_title, gross,
RANK () OVER(PARTITION BY genre ORDER BY gross DESC) AS genre_rank
FROM movies_cleaned
LIMIT 5;

-- 25. Show the first 10 rows of movies with their cumulative gross earnings grouped by release year.
SELECT released_year,  movies_title, gross,  SUM(COALESCE(gross, 0)) 
OVER(PARTITION BY released_year ORDER BY movies_title) AS cum_gross
FROM movies_cleaned
WHERE released_year IS NOT NULL AND gross IS NOT NULL
ORDER BY released_year, movies_title
LIMIT 10;

-- 26.Calculate the percentile rank of each movie based on gross earnings and show the first 10 results.
SELECT movies_title,
ROUND(PERCENT_RANK() OVER(ORDER BY gross )::numeric *100,2) AS percentile_rank 
FROM movies_cleaned
LIMIT 10;



SELECT * 
FROM movies_cleaned;

-- 27. Compare the average IMDb rating of movies released before and after 2000
SELECT 
 CASE 
     WHEN released_year < 2000 THEN 'Before 2000'
	 ELSE 'After 2000'
	END AS released_era, 
	 ROUND(AVG(imdb_rating)::numeric, 2) AS avg_rating 
FROM movies_cleaned
WHERE released_year IS NOT NULL AND imdb_rating IS NOT NULL
GROUP BY released_era;


-- 28. Show top 10 directors who have directed 5 or more movies
SELECT director, COUNT(*) AS movie_count
FROM movies_cleaned
WHERE director IS NOT NULL
GROUP BY director
HAVING COUNT(*) >= 5
ORDER BY movie_count DESC
LIMIT 10;


-- 29.Find 5 pairs of movies released in the same year with the same certificate
SELECT 
      m1.movies_title AS movie_1,
	  m2.movies_title AS movie_2, 
	  m1.released_year, 
	  m1.certificate
FROM movies_cleaned AS m1
JOIN movies_cleaned AS m2
     ON m1.released_year = m2.released_year
	AND m1.certificate = m2.certificate 
	AND m1.movies_title < m2.movies_title
WHERE m1.certificate IS NOT NULL
ORDER BY m1.released_year
LIMIT 5;


-- 30. Find 5 movie pairs by the same director with IMDb rating difference > 1
SELECT 
      m1.director,
      m1.movies_title AS movie_1,
      m2.movies_title AS movie_2, 
      m1.imdb_rating AS rating_1,
      m2.imdb_rating AS rating_2,
      ROUND(ABS(m1.imdb_rating - m2.imdb_rating)::numeric, 2) AS rating_diff
FROM movies_cleaned AS m1
JOIN movies_cleaned AS m2
     ON m1.director = m2.director
    AND m1.movies_title < m2.movies_title
WHERE m1.movies_title IS NOT NULL
  AND m2.movies_title IS NOT NULL
  AND ROUND(ABS(m1.imdb_rating - m2.imdb_rating)::numeric, 2) > 1
ORDER BY rating_diff DESC
LIMIT 5;

 -- 31. Get top 3 longest movies per genre with rating greater than 8.7
WITH long_high_rated AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY genre ORDER BY runtime_min DESC) AS rnk
    FROM movies_cleaned
    WHERE imdb_rating> 8.7
)
SELECT movies_title, genre, imdb_rating, runtime_min
FROM long_high_rated
WHERE rnk <= 3;


-- 32.Find the movie(s) with the second highest IMDb rating
SELECT movies_title, imdb_rating
FROM movies_cleaned
WHERE imdb_rating = (
			SELECT DISTINCT imdb_rating
			FROM movies_cleaned 
			ORDER BY imdb_rating DESC
			OFFSET 1
			LIMIT 1
);

-- 33. Classify movies with IMDb rating > 8.6 into 4 gross-based quartiles and label them as 'Very High', 'High', 'Medium', or 'Low'. Show title, rating, gross, and label.

WITH gross_buckets AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY gross DESC) AS buckets
    FROM movies_cleaned
    WHERE gross IS NOT NULL AND imdb_rating > 8.6
)

SELECT 
    movies_title,
    imdb_rating,
    gross,
    CASE 
        WHEN buckets = 1 THEN 'Very High Gross'
        WHEN buckets = 2 THEN 'High Gross'
        WHEN buckets = 3 THEN 'Medium Gross'
        WHEN buckets = 4 THEN 'Low Gross' 
    END AS gross_bucket_list	
FROM gross_buckets;

-- 34. Show each movie's gross with previous and next movie’s gross by release year (top 5 by title).

SELECT 
      movies_title,
	  gross,
LAG(gross) OVER(ORDER BY released_year) AS prev_gross,
LEAD(gross) OVER(ORDER BY released_year) AS next_gross
FROM movies_cleaned
ORDER BY movies_title ASC
LIMIT 5;

-- 35. First & Last movie by runtime per genre 	  
SELECT movies_title, genre, runtime_min,
       FIRST_VALUE(movies_title) OVER (PARTITION BY genre ORDER BY runtime_min DESC) AS longest_movie,
       LAST_VALUE(movies_title) OVER (PARTITION BY genre ORDER BY runtime_min DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS shortest_movie
FROM movies_cleaned
;  
-- 36. Show movies with the longest and shortest runtime in each genre (top 5 rows). Show title, genre, runtime, and both movie names.
SELECT 
    movies_title,
    genre,
    runtime_min,
FIRST_VALUE(movies_title) OVER (PARTITION BY genre ORDER BY runtime_min DESC) AS longest_movie,
LAST_VALUE(movies_title)  OVER (PARTITION BY genre ORDER BY runtime_min DESC
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS shortest_movie
FROM movies_cleaned
WHERE runtime_min IS NOT NULL
ORDER BY genre DESC
LIMIT 5;

-- 37. Create or replace a view for the highest grossing movie per year
CREATE OR REPLACE VIEW highest_gross_per_year AS
SELECT * 
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY released_year ORDER BY gross DESC) AS rnk
	FROM movies_cleaned
	WHERE released_year IS NOT NULL AND gross IS NOT NULL
) AS subq
WHERE rnk =1;

-- Preview: Show 5 sample rows from the view
SELECT movies_title, released_year, gross
FROM highest_gross_per_year
LIMIT 5;

-- 38.Compare avg rating of Drama vs Non-Drama movies
WITH genre_rating AS (
SELECT 
      CASE 
	      WHEN genre ILIKE 'Drama%'THEN 'Drama'
		  ELSE 'Non_Drama'
		 END AS category,
		 ROUND(AVG(imdb_rating)::numeric,2)AS avg_rating
FROM movies_cleaned
GROUP BY category 
)
SELECT * FROM genre_rating;

-- 39.Get the top 3 most voted movies per decade and display the first 6 results.
WITH ranked_movies AS (
  SELECT 
    movies_title, 
    released_year, 
    no_of_votes,
    FLOOR(released_year / 10) * 10 AS decade,
DENSE_RANK() OVER (PARTITION BY FLOOR(released_year / 10) * 10 ORDER BY no_of_votes DESC) AS vote_rank
FROM movies_cleaned
WHERE released_year IS NOT NULL
)
SELECT * 
FROM ranked_movies
WHERE vote_rank <= 3
ORDER BY decade, vote_rank
LIMIT 6;
