
## 🎬 IMDB Top 1000 Movies – SQL Analysis Project

### 📁 Dataset Source

The dataset used in this project was sourced from Kaggle: [IMDb Dataset of Top 1000 Movies and TV Shows](https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows). It contains information about 1000 top-rated movies and TV shows including attributes like title, genre, rating, runtime, director, stars, votes, gross earnings, and more.

---

## 📊 Dataset Overview

The cleaned dataset used for analysis is named **`movies_cleaned`**. It includes the following key features:

| Column           | Description                                 |
|------------------|---------------------------------------------|
| `movies_title`   | Title of the movie or TV show               |
| `released_year`  | Year of release (cleaned as integer)        |
| `certificate`    | Movie certificate (e.g., U, PG, A)          |
| `runtime_min`    | Runtime in minutes                          |
| `genre`          | Genre(s) of the movie                       |
| `imdb_rating`    | IMDb user rating (converted to float)       |
| `meta_score`     | MetaCritic score (converted to integer)     |
| `director`       | Name of the director                        |
| `star1` to `star4` | Main cast members                         |
| `no_of_votes`    | Number of IMDb votes (converted to bigint)  |
| `gross`          | Gross earnings in USD (converted to bigint) |

It includes key attributes such as:

* Movie Title  
* Release Year  
* Certificate  
* Runtime  
* Genre  
* IMDb Rating  
* Meta Score  
* Director and Cast  
* Gross Earnings  
* Number of Votes  

---

### 🧹 Data Cleaning Summary

* Removed commas from numeric fields like `gross` and `no_of_votes`  
* Converted appropriate columns to numeric types: `gross`, `no_of_votes`, `meta_score`, `imdb_rating`, and `runtime`  
* Extracted numeric runtime and created a new column `runtime_min`  
* Renamed `series_title` to `movies_title`  
* Removed irrelevant columns like `poster_link` and `overview`  
* Handled nulls and cleaned non-numeric values in `released_year`  
* Manually verified visual duplicates (e.g., Drishyam remake)  
* One `NULL` value retained in `released_year` for completeness  

The final cleaned table is named `movies_cleaned`.

---

## 🔍 Exploring the Dataset

The project includes **39 SQL queries** ranging from basic to advanced, grouped into different categories:

### Basic Statistics & Filters

* Max, min, average of IMDb rating, gross, runtime, votes  
* Filter movies by year, genre, director, runtime, and rating  
* Count movies with specific certificates (e.g., "U")  

### Intermediate Analysis

* Group by certificate, genre, director, decade  
* Find most frequent genres and directors  
* Calculate gross per year, top-voted movies, most released years  
* Find top N movies per metric (rating, runtime, gross)  

### Advanced Techniques

* Window functions like `ROW_NUMBER()`, `RANK()`, `LAG()`, `LEAD()`, `FIRST_VALUE()`  
* Cumulative calculations and quartile bucketing  
* CTEs to calculate longest movies per genre, rating difference, top voted by decade  
* View creation for highest grossing movie per year  

---

## 📝 Sample Highlights

* Top 10 directors with 5+ movies  
* Movies with above-average runtime or rating  
* Compare Drama vs Non-Drama average ratings  
* Movies with second highest gross/IMDB rating  
* Bucket high-rated movies into gross quartiles  
* Get previous and next movie’s gross for each title  

---

## 📌 How to Use

* Import the dataset into PostgreSQL  
* Run the cleaning steps provided to create the `movies_cleaned` table  
* Explore the 39 SQL queries for learning or analytics  
* Use SELECT, GROUP BY, CTE, and window functions as needed  

---


### 1. Show Max, Min and Avg imdb rating.
```sql
SELECT 
     MAX(imdb_rating) AS max_imdb_rating,
	 MIN(imdb_rating) AS min_imdb_rating,
	 ROUND(AVG(imdb_rating)::numeric,2)AS avg_imdb_rating
FROM movies_cleaned;
```
-- Output --

| max_imdb_rating | min_imdb_rating | avg_imdb_rating |
|-----------------|-----------------|-----------------|
| 9.3             | 7.6             | 7.95            |


### 2. Show Max, Min and Avg gross
```sql
SELECT 
     MAX(gross) AS max_gross,
	 MIN(gross) AS min_gross,
	 ROUND(AVG(gross)::numeric,2)AS avg_gross
FROM movies_cleaned;
```
-- Output --

| max_gross | min_gross | avg_gross     |
|-----------|-----------|---------------|
| 936662225 | 1305      | 68034750.87   |


### 3. Show Max, Min and Avg no_of_votes
```sql
SELECT 
     MAX(no_of_votes) AS max_no_of_votes,
	 MIN(no_of_votes) AS min_no_of_votes,
	 ROUND(AVG(no_of_votes)::numeric,0)AS avg_no_of_votes
FROM movies_cleaned;
```
-- Output --

| max_no_of_votes | min_no_of_votes | avg_no_of_votes |
|------------------|------------------|------------------|
| 2343110          | 25088            | 273693           |


### 4. Show Max, Min and Avg runtime.
```sql
SELECT 
     MAX(runtime_min) AS max_runtime_min,
	 MIN(runtime_min) AS min_runtime_min,
	 ROUND(AVG(runtime_min)::numeric,2)AS avg_runtime_min
FROM movies_cleaned;
```
-- Output --

| max_runtime_min | min_runtime_min | avg_runtime_min |
|------------------|------------------|------------------|
| 321              | 45               | 122.89           |


###  5.  Show a sample of 5 movies released after 2010.
```sql
SELECT *
FROM movies_cleaned
WHERE released_year >2010 
ORDER BY released_year
LIMIT 5;
```
-- Output --

| movies_title                                   | released_year | certificate | genre                        | imdb_rating | meta_score | director          | star1            | star2           | star3           | star4             | no_of_votes | gross       | runtime_min |
|-----------------------------------------------|----------------|-------------|------------------------------|-------------|------------|-------------------|------------------|------------------|------------------|--------------------|--------------|-------------|-------------|
| Warrior                                        | 2011           | UA          | Action, Drama, Sport         | 8.2         | 71         | Gavin O'Connor    | Tom Hardy        | Nick Nolte       | Joel Edgerton    | Jennifer Morrison  | 435950       | 13657115    | 140         |
| Zindagi Na Milegi Dobara                      | 2011           | U           | Comedy, Drama                | 8.1         |            | Zoya Akhtar       | Hrithik Roshan   | Farhan Akhtar    | Abhay Deol       | Katrina Kaif        | 67927        | 3108485     | 155         |
| Jodaeiye Nader az Simin                       | 2011           | PG-13       | Drama                        | 8.3         | 95         | Asghar Farhadi    | Payman Maadi     | Leila Hatami     | Sareh Bayat      | Shahab Hosseini     | 220002       | 7098492     | 123         |
| The Intouchables                              | 2011           | UA          | Biography, Comedy, Drama     | 8.5         | 57         | Olivier Nakache   | Éric Toledano    | François Cluzet  | Omar Sy          | Anne Le Ny          | 760360       | 13182281    | 112         |
| Harry Potter and the Deathly Hallows: Part 2  | 2011           | UA          | Adventure, Drama, Fantasy    | 8.1         | 85         | David Yates       | Daniel Radcliffe | Emma Watson      | Rupert Grint     | Michael Gambon      | 764493       | 381011219   | 130         |


### 6. Show all movies with an IMDb rating greater than 9.
```sql
SELECT * 
FROM movies_cleaned
WHERE imdb_rating > 9 ;
```
-- Output --

| movies_title            | released_year | certificate | genre         | imdb_rating | meta_score | director             | star1          | star2           | star3         | star4           | no_of_votes | gross      | runtime_min |
|-------------------------|----------------|-------------|---------------|-------------|------------|----------------------|----------------|------------------|----------------|------------------|--------------|------------|-------------|
| The Shawshank Redemption | 1994           | A           | Drama         | 9.3         | 80         | Frank Darabont       | Tim Robbins    | Morgan Freeman   | Bob Gunton     | William Sadler   | 2343110      | 28341469   | 142         |
| The Godfather           | 1972           | A           | Crime, Drama  | 9.2         | 100        | Francis Ford Coppola | Marlon Brando  | Al Pacino        | James Caan     | Diane Keaton     | 1620367      | 134966411  | 175         |


### 7. Show a sample of 3 movies where the genre contains "Drama".
```SQL
SELECT * 
FROM movies_cleaned
WHERE genre ILIKE '%Drama%'
LIMIT 3;
```
-- Output --
| movies_title         | released_year | certificate | genre                    | imdb_rating | meta_score | director            | star1          | star2           | star3           | star4              | no_of_votes | gross      | runtime_min |
|----------------------|----------------|-------------|---------------------------|-------------|------------|---------------------|----------------|------------------|------------------|---------------------|--------------|------------|-------------|
| PK                   | 2014           | UA          | Comedy, Drama, Musical    | 8.1         |            | Rajkumar Hirani     | Aamir Khan     | Anushka Sharma   | Sanjay Dutt      | Boman Irani          | 163061       | 10616104   | 153         |
| La haine             | 1995           | UA          | Crime, Drama              | 8.1         |            | Mathieu Kassovitz   | Vincent Cassel | Hubert Koundé    | Saïd Taghmaoui   | Abdel Ahmed Ghili    | 150345       | 309811     | 98          |
| Blade Runner 2049   | 2017           | UA          | Action, Drama, Mystery    | 8.0         | 81         | Denis Villeneuve    | Harrison Ford  | Ryan Gosling     | Ana de Armas     | Dave Bautista        | 461823       | 92054159   | 164         |


### 8. Show a sample of 3 movies directed by Christopher Nolan.
```sql
SELECT * 
FROM movies_cleaned
WHERE director = 'Christopher Nolan'
LIMIT 3;
```

-- Output --

| movies_title     | released_year | certificate | genre                     | imdb_rating | meta_score | director           | star1               | star2                 | star3               | star4             | no_of_votes | gross      | runtime_min |
|------------------|----------------|-------------|----------------------------|-------------|------------|--------------------|----------------------|------------------------|----------------------|--------------------|--------------|------------|-------------|
| The Dark Knight  | 2008           | UA          | Action, Crime, Drama       | 9.0         | 84         | Christopher Nolan  | Christian Bale       | Heath Ledger          | Aaron Eckhart        | Michael Caine      | 2303232      | 534858444  | 152         |
| Inception        | 2010           | UA          | Action, Adventure, Sci-Fi  | 8.8         | 74         | Christopher Nolan  | Leonardo DiCaprio    | Joseph Gordon-Levitt  | Elliot Page          | Ken Watanabe       | 2067042      | 292576195  | 148         |
| Interstellar     | 2014           | UA          | Adventure, Drama, Sci-Fi   | 8.6         | 74         | Christopher Nolan  | Matthew McConaughey  | Anne Hathaway         | Jessica Chastain     | Mackenzie Foy      | 1512360      | 188020017  | 169         |


### 9. Count how many movies have a certificate of "U"
```sql
SELECT COUNT(*)
FROM movies_cleaned 
WHERE certificate = 'U';
```
-- Output --

There are 234 movies with a certificate of "U".


### 10. List top 5 movies by IMDb rating
```SQL
SELECT *
FROM movies_cleaned 
ORDER BY imdb_rating DESC
LIMIT 5;
```
-- Output --

| movies_title               | released_year | certificate | genre               | imdb_rating | meta_score | director             | star1            | star2           | star3           | star4            | no_of_votes | gross      | runtime_min |
|---------------------------|----------------|-------------|---------------------|-------------|------------|----------------------|------------------|------------------|------------------|------------------|-------------|------------|-------------|
| The Shawshank Redemption  | 1994           | A           | Drama               | 9.3         | 80         | Frank Darabont       | Tim Robbins      | Morgan Freeman   | Bob Gunton       | William Sadler   | 2343110     | 28341469   | 142         |
| The Godfather             | 1972           | A           | Crime, Drama        | 9.2         | 100        | Francis Ford Coppola | Marlon Brando    | Al Pacino        | James Caan       | Diane Keaton     | 1620367     | 134966411  | 175         |
| The Godfather: Part II    | 1974           | A           | Crime, Drama        | 9           | 90         | Francis Ford Coppola | Al Pacino        | Robert De Niro   | Robert Duvall    | Diane Keaton     | 1129952     | 57300000   | 202         |
| The Dark Knight           | 2008           | UA          | Action, Crime, Drama| 9           | 84         | Christopher Nolan    | Christian Bale   | Heath Ledger     | Aaron Eckhart    | Michael Caine    | 2303232     | 534858444  | 152         |
| 12 Angry Men              | 1957           | U           | Crime, Drama        | 9           | 96         | Sidney Lumet         | Henry Fonda      | Lee J. Cobb      | Martin Balsam    | John Fiedler     | 689845      | 4360000    | 96          |


### 11.Get top 3 movies with runtime over 150 minutes 
```sql
SELECT *
FROM movies_cleaned 
WHERE runtime_min > 150 
ORDER BY runtime_min DESC
LIMIT 3;
```

-- Output --

| movies_title           | released_year | certificate | genre                    | imdb_rating | meta_score | director         | star1             | star2           | star3               | star4           | no_of_votes | gross      | runtime_min |
|------------------------|----------------|-------------|---------------------------|-------------|------------|------------------|-------------------|------------------|----------------------|------------------|-------------|------------|-------------|
| Gangs of Wasseypur     | 2012           | A           | Action, Comedy, Crime     | 8.2         | 89         | Anurag Kashyap   | Manoj Bajpayee    | Richa Chadha     | Nawazuddin Siddiqui | Tigmanshu Dhulia | 82365       | NULL       | 321         |
| Hamlet                 | 1996           | PG-13       | Drama                     | 7.7         | NULL       | Kenneth Branagh  | Kenneth Branagh   | Julie Christie   | Derek Jacobi         | Kate Winslet     | 35991       | 4414535    | 242         |
| Gone with the Wind     | 1939           | U           | Drama, History, Romance   | 8.1         | 97         | Victor Fleming   | George Cukor      | Sam Wood         | Clark Gable          | Vivien Leigh     | 290074      | 198676459  | 238         |
Wood         | Clark Gable          | Vivien Leigh     | 290074      | 198676459  | 238         |

### 12. Show the first 3 movies (alphabetically) that have missing gross earnings.
```sql 
SELECT *
FROM movies_cleaned 
WHERE gross IS NULL
ORDER BY movies_title ASC
LIMIT 3;
```
-- Output --

| movies_title              | released_year | certificate | genre                         | imdb_rating | meta_score | director        | star1            | star2             | star3            | star4             | no_of_votes | gross | runtime_min |
|---------------------------|----------------|-------------|-------------------------------|-------------|------------|------------------|-------------------|--------------------|-------------------|-------------------|-------------|-------|-------------|
| A Wednesday               | 2008           | UA          | Action, Crime, Drama          | 8.1         | NULL       | Neeraj Pandey    | Anupam Kher        | Naseeruddin Shah   | Jimmy Sheirgill   | Aamir Bashir       | 73891       | NULL  | 104         |
| Aguirre, der Zorn Gottes | 1972           | NULL        | Action, Adventure, Biography  | 7.9         | NULL       | Werner Herzog    | Klaus Kinski       | Ruy Guerra         | Helena Rojo       | Del Negro          | 52397       | NULL  | 95          |
| Airlift                  | 2016           | UA          | Drama, History                | 8.0         | NULL       | Raja Menon       | Akshay Kumar       | Nimrat Kaur        | Kumud Mishra      | Prakash Belawadi   | 52897       | NULL  | 130         |

### 13. Which 10 directors have made the most movies in the dataset?
```	sql
SELECT director ,COUNT(*) AS movies_count
FROM movies_cleaned 
GROUP BY director
ORDER BY movies_count DESC
LIMIT 10;
```
-- Output --

| director           | movie_count |
|--------------------|-------------|
| Alfred Hitchcock   | 14          |
| Steven Spielberg   | 13          |
| Hayao Miyazaki     | 11          |
| Martin Scorsese    | 10          |
| Akira Kurosawa     | 10          |
| Billy Wilder       | 9           |
| Woody Allen        | 9           |
| Stanley Kubrick    | 9           |
| David Fincher      | 8           |
| Clint Eastwood     | 8           |


### 14. Year with the most movie releases
```sql
SELECT released_year ,COUNT(*) AS movie_release_count
FROM movies_cleaned 
GROUP BY released_year
ORDER BY  movie_release_count DESC
LIMIT 1;
```
-- Output --

| released_year | movie_release_count |
|---------------|---------------------|
| 2014          | 32                  |


### 15. Which 5 years had the highest total box office gross?
```	sql
	
SELECT released_year ,SUM(gross) AS gross_count_per_year
FROM movies_cleaned 
WHERE gross IS NOT NULL
GROUP BY released_year
ORDER BY gross_count_per_year DESC
LIMIT 5;
```
-- Output --

| released_year | gross_count_per_year |
|---------------|----------------------|
| 2009          | 2,937,170,585        |
| 2014          | 2,755,629,221        |
| 2018          | 2,607,757,362        |
| 2016          | 2,595,557,425        |
| 2012          | 2,542,616,037        |

### 16. Top 5 most voted movies	
```sql
SELECT *
FROM movies_cleaned 
ORDER BY no_of_votes DESC
LIMIT 5
```
-- Output --

| movies_title             | released_year | certificate | genre                   | imdb_rating | meta_score | director           | star1             | star2             | star3              | star4            | no_of_votes | gross       | runtime_min |
|--------------------------|----------------|-------------|--------------------------|--------------|-------------|---------------------|--------------------|--------------------|---------------------|------------------|--------------|-------------|--------------|
| The Shawshank Redemption | 1994           | A           | Drama                   | 9.3          | 80          | Frank Darabont      | Tim Robbins        | Morgan Freeman     | Bob Gunton          | William Sadler   | 2343110      | 28341469    | 142          |
| The Dark Knight          | 2008           | UA          | Action, Crime, Drama    | 9            | 84          | Christopher Nolan   | Christian Bale     | Heath Ledger       | Aaron Eckhart       | Michael Caine    | 2303232      | 534858444   | 152          |
| Inception                | 2010           | UA          | Action, Adventure, Sci-Fi | 8.8        | 74          | Christopher Nolan   | Leonardo DiCaprio  | Joseph Gordon-Levitt | Elliot Page        | Ken Watanabe     | 2067042      | 292576195   | 148          |
| Fight Club               | 1999           | A           | Drama                   | 8.8          | 66          | David Fincher       | Brad Pitt          | Edward Norton      | Meat Loaf           | Zach Grenier     | 1854740      | 37030102    | 139          |
| Pulp Fiction             | 1994           | A           | Crime, Drama            | 8.9          | 94          | Quentin Tarantino   | John Travolta      | Uma Thurman        | Samuel L. Jackson   | Bruce Willis     | 1826188      | 107928762   | 1


### 17. Number of unique certificates
```SQL
SELECT COUNT(DISTINCT certificate)
FROM movies_cleaned 
WHERE certificate IS NOT NULL;
```
-- Output --

There are 16 unique certificates

### 18. Most frequent genres (as-is, not normalized)
```sql
SELECT genre, COUNT(*) AS genre_count
FROM movies_cleaned 
WHERE genre IS NOT NULL
GROUP BY genre 
ORDER BY genre_count DESC
LIMIT 5;
```
-- Output --

| genre                    | genre_count |
|--------------------------|-------------|
| Drama                    | 85          |
| Drama, Romance           | 37          |
| Comedy, Drama            | 35          |
| Comedy, Drama, Romance   | 31          |
| Action, Crime, Drama     | 30          |


### 19.Which 5 movie certificates have the highest average Meta Score?
```sql
SELECT certificate, ROUND(AVG(meta_score)::numeric,2) AS avg_meta_score
FROM movies_cleaned 
WHERE certificate IS NOT NULL AND meta_score IS NOT NULL
GROUP BY certificate
ORDER BY avg_meta_score DESC
LIMIT 5;
```
-- Output --

| certificate | avg_meta_score |
|-------------|----------------|
| Approved    | 88.00          |
| Passed      | 87.28          |
| TV-PG       | 86.67          |
| G           | 86.10          |
| PG          | 82.97          |


### 20.How many movies were released in each decade? Show the 5 most recent decades.
```sql
SELECT FLOOR(released_year/10)*10 AS decade, COUNT(*) AS movie_count
FROM movies_cleaned 
WHERE released_year IS NOT NULL
GROUP BY decade 
ORDER BY movie_count DESC
LIMIT 5;
```
-- Output --

| decade | movie_count |
|--------|-------------|
| 2010   | 242         |
| 2000   | 237         |
| 1990   | 150         |
| 1980   | 89          |
| 1970   | 76          |


### 21. Which are the top-rated movies across different genres based on IMDb rating? Show the top 5 among them
```sql
SELECT movies_title, genre, imdb_rating
FROM (
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY genre ORDER BY imdb_rating DESC) AS movie_rank
	FROM movies_cleaned
) AS ranked_movies
WHERE movie_rank = 1
ORDER BY imdb_rating DESC
LIMIT 5;
```
-- Output --

| movies_title                                     | genre                            | imdb_rating |
|--------------------------------------------------|----------------------------------|-------------|
| The Shawshank Redemption                         | Drama                            | 9.3         |
| The Godfather                                    | Crime, Drama                     | 9.2         |
| The Dark Knight                                  | Action, Crime, Drama             | 9.0         |
| The Lord of the Rings: The Return of the King    | Action, Adventure, Drama         | 8.9         |
| Schindler's List                                 | Biography, Drama, History        | 8.9         |


### 22. Which movie has the second highest total gross earnings?
```sql
SELECT movies_title, gross
FROM movies_cleaned
ORDER BY gross 
OFFSET 1
LIMIT 1;
```
-- Output --

| movies_title                | gross |
|----------------------------|-------|
| Knockin' on Heaven's Door | 3296  |


###  23.List the first 5 movies whose runtime is above the average runtime.
```sql
SELECT movies_title, runtime_min
FROM movies_cleaned
WHERE runtime_min > (
    SELECT AVG(runtime_min)
    FROM movies_cleaned
    WHERE runtime_min IS NOT NULL
)
ORDER BY runtime_min DESC
LIMIT 5;
```
-- Output --

| movies_title                 | runtime_min |
|-----------------------------|-------------|
| Gangs of Wasseypur          | 321         |
| Hamlet                      | 242         |
| Gone with the Wind          | 238         |
| Once Upon a Time in America | 229         |
| Lawrence of Arabia          | 228         |


### 24.Show the top 5 movies ranked by gross earnings within their genres.
```sql
SELECT movies_title, gross,
RANK () OVER(PARTITION BY genre ORDER BY gross DESC) AS genre_rank
FROM movies_cleaned
LIMIT 5;
```
-- Output --

| movies_title                          | gross      | genre_rank |
|--------------------------------------|------------|-------------|
| The Dark Knight Rises                | 448139099  | 1           |
| Raiders of the Lost Ark              | 248159971  | 2           |
| Batman Begins                        | 206852432  | 3           |
| Indiana Jones and the Last Crusade   | 197171806  | 4           |
| First Blood                          | 47212904   | 5           |



### 25. Show the first 10 rows of movies with their cumulative gross earnings grouped by release year.
```SQL
SELECT released_year,  movies_title, gross,  SUM(COALESCE(gross, 0)) 
OVER(PARTITION BY released_year ORDER BY movies_title) AS cum_gross
FROM movies_cleaned
WHERE released_year IS NOT NULL AND gross IS NOT NULL
ORDER BY released_year, movies_title
LIMIT 10;
```
-- Output --


| released_year | movies_title                      | gross    | cum_gross |
|---------------|-----------------------------------|----------|------------|
| 1921          | The Kid                           | 5450000  | 5450000    |
| 1924          | Sherlock Jr.                      | 977375   | 977375     |
| 1925          | Bronenosets Potemkin              | 50970    | 50970      |
| 1925          | The Gold Rush                     | 5450000  | 5500970    |
| 1926          | The General                       | 1033895  | 1033895    |
| 1927          | Metropolis                        | 1236166  | 1236166    |
| 1927          | Sunrise: A Song of Two Humans     | 539540   | 1775706    |
| 1928          | La passion de Jeanne d'Arc        | 21877    | 21877      |
| 1930          | All Quiet on the Western Front    | 3270000  | 3270000    |
| 1931          | City Lights                       | 19181    | 19181      |


###  26. Find percentile rank of each movie by gross.
```sql
SELECT movies_title,
ROUND(PERCENT_RANK() OVER(ORDER BY gross )::numeric *100,2) AS percentile_rank 
FROM movies_cleaned
LIMIT 10;
```
-- Output --
| movies_title               | percentile_rank |
|----------------------------|-----------------|
| Adams æbler               | 0.00            |
| Knockin' on Heaven's Door | 0.10            |
| Mr. Nobody                | 0.20            |
| Dead Man's Shoes          | 0.30            |
| Ajeossi                   | 0.40            |
| Udaan                     | 0.50            |
| Tropa de Elite            | 0.60            |
| All About Eve             | 0.70            |
| Dev.D                     | 0.80            |
| Dial M for Murder         | 0.90            |


### 27. Compare the average IMDb rating of movies released before and after 2000
```sql
SELECT 
 CASE 
     WHEN released_year < 2000 THEN 'Before 2000'
	 ELSE 'After 2000'
	END AS released_era, 
	 ROUND(AVG(imdb_rating)::numeric, 2) AS avg_rating 
FROM movies_cleaned
WHERE released_year IS NOT NULL AND imdb_rating IS NOT NULL
GROUP BY released_era;
```
-- Output --

| released_era | avg_rating |
|--------------|------------|
| After 2000   | 7.91       |
| Before 2000  | 7.98       |


### 28. Show top 10 directors who have directed 5 or more movies
```sql
SELECT director, COUNT(*) AS movie_count
FROM movies_cleaned
WHERE director IS NOT NULL
GROUP BY director
HAVING COUNT(*) >= 5
ORDER BY movie_count DESC
LIMIT 10;
```
-- Output --

| director           | movie_count |
|--------------------|-------------|
| Alfred Hitchcock   | 14          |
| Steven Spielberg   | 13          |
| Hayao Miyazaki     | 11          |
| Akira Kurosawa     | 10          |
| Martin Scorsese    | 10          |
| Woody Allen        | 9           |
| Billy Wilder       | 9           |
| Stanley Kubrick    | 9           |
| Clint Eastwood     | 8           |
| Christopher Nolan  | 8           |

### 29.Find 5 pairs of movies released in the same year with the same certificate
```sql
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
```
-- Output --

| movie_1                        | movie_2                               | released_year | certificate |
|--------------------------------|----------------------------------------|----------------|-------------|
| La passion de Jeanne d'Arc     | The Circus                             | 1928           | Passed      |
| Frankenstein                   | M - Eine Stadt sucht einen Mörder      | 1931           | Passed      |
| Mr. Smith Goes to Washington   | Stagecoach                             | 1939           | Passed      |
| Gone with the Wind             | The Wizard of Oz                       | 1939           | U           |
| His Girl Friday                | The Great Dictator                     | 1940           | Passed      |

### 30. Find 5 movie pairs by the same director with IMDb rating difference > 1
```sql
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
```
-- Output --

| director               | movie_1                  | movie_2                   | rating_1 | rating_2 | rating_diff |
|------------------------|---------------------------|----------------------------|----------|----------|--------------|
| Francis Ford Coppola   | The Godfather             | The Godfather: Part III   | 9.2      | 7.6      | 1.60         |
| Francis Ford Coppola   | The Godfather: Part II    | The Godfather: Part III   | 9.0      | 7.6      | 1.40         |
| Francis Ford Coppola   | The Conversation          | The Godfather             | 7.8      | 9.2      | 1.40         |
| Sidney Lumet           | 12 Angry Men              | The Verdict               | 9.0      | 7.7      | 1.30         |
| Sidney Lumet           | 12 Angry Men              | Serpico                   | 9.0      | 7.7      | 1.30         |


### 31. Get top 3 longest movies per genre with rating greater than 8.7
```sql
WITH long_high_rated AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY genre ORDER BY runtime_min DESC) AS rnk
    FROM movies_cleaned
    WHERE imdb_rating> 8.7
)
SELECT movies_title, genre, imdb_rating, runtime_min
FROM long_high_rated
WHERE rnk <= 3;
```
-- Output --

| movies_title                                      | genre                          | imdb_rating | runtime_min |
|--------------------------------------------------|--------------------------------|-------------|--------------|
| The Lord of the Rings: The Return of the King    | Action, Adventure, Drama       | 8.9         | 201          |
| The Lord of the Rings: The Fellowship of the Ring| Action, Adventure, Drama       | 8.8         | 178          |
| Inception                                         | Action, Adventure, Sci-Fi      | 8.8         | 148          |
| The Dark Knight                                   | Action, Crime, Drama           | 9.0         | 152          |
| Schindler's List                                  | Biography, Drama, History      | 8.9         | 195          |
| The Godfather: Part II                            | Crime, Drama                   | 9.0         | 202          |
| The Godfather                                     | Crime, Drama                   | 9.2         | 175          |
| Pulp Fiction                                      | Crime, Drama                   | 8.9         | 154          |
| The Shawshank Redemption                          | Drama                          | 9.3         | 142          |
| Fight Club                                        | Drama                          | 8.8         | 139          |
| Forrest Gump                                      | Drama, Romance                 | 8.8         | 142          |
| Il buono, il brutto, il cattivo                   | Western                        | 8.8         | 161          |


### 32.Find the movie(s) with the second highest IMDb rating
```sql
SELECT movies_title, imdb_rating
FROM movies_cleaned
WHERE imdb_rating = (
			SELECT DISTINCT imdb_rating
			FROM movies_cleaned 
			ORDER BY imdb_rating DESC
			OFFSET 1
			LIMIT 1
);
```
-- Output --

| movies_title  | imdb_rating |
|---------------|-------------|
| The Godfather | 9.2         |

### 33. Classify movies with IMDb rating > 8.6 into 4 gross-based quartiles and label them as 'Very High', 'High', 'Medium', or 'Low'. Show title, rating, gross, and label.
```sql
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
```
-- Output --

| movies_title                                     | imdb_rating | gross      | gross_bucket_list   |
|--------------------------------------------------|-------------|------------|----------------------|
| The Dark Knight                                  | 9.0         | 534858444  | Very High Gross      |
| The Lord of the Rings: The Return of the King    | 8.9         | 377845905  | Very High Gross      |
| The Lord of the Rings: The Two Towers            | 8.7         | 342551365  | Very High Gross      |
| Forrest Gump                                     | 8.8         | 330252182  | Very High Gross      |
| The Lord of the Rings: The Fellowship of the Ring| 8.8         | 315544750  | Very High Gross      |
| Inception                                        | 8.8         | 292576195  | High Gross           |
| Star Wars: Episode V - The Empire Strikes Back   | 8.7         | 290475067  | High Gross           |
| The Matrix                                       | 8.7         | 171479930  | High Gross           |
| The Godfather                                    | 9.2         | 134966411  | High Gross           |
| One Flew Over the Cuckoo's Nest                  | 8.7         | 112000000  | High Gross           |
| Pulp Fiction                                     | 8.9         | 107928762  | Medium Gross         |
| Schindler's List                                 | 8.9         | 96898818   | Medium Gross         |
| The Godfather: Part II                           | 9.0         | 57300000   | Medium Gross         |
| Goodfellas                                       | 8.7         | 46836394   | Medium Gross         |
| Fight Club                                       | 8.8         | 37030102   | Low Gross            |
| The Shawshank Redemption                         | 9.3         | 28341469   | Low Gross            |
| Il buono, il brutto, il cattivo                  | 8.8         | 6100000    | Low Gross            |
| 12 Angry Men                                     | 9.0         | 4360000    | Low Gross            |


###  34. 34.Show each movie's gross with previous and next movie’s gross by release year (top 5 by title).
```sql
SELECT 
      movies_title,
	  gross,
LAG(gross) OVER(ORDER BY released_year) AS prev_gross,
LEAD(gross) OVER(ORDER BY released_year) AS next_gross
FROM movies_cleaned
ORDER BY movies_title ASC
LIMIT 5;
```

-- Output --

| movies_title             | gross      | prev_gross | next_gross |
|--------------------------|------------|------------|-------------|
| (500) Days of Summer     | 32391374   | 120540719  |             |
| 12 Angry Men             | 4360000    |            | 17570324    |
| 12 Years a Slave         | 56671993   | 274092705  | 26947624    |
| 1917                     | 159227644  | 335451311  | 349555      |
| 2001: A Space Odyssey    | 56954992   | 33395426   |             |


### 36. Show movies with the longest and shortest runtime in each genre (top 5 rows). Show title, genre, runtime, and both movie names.
```sql
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
```
-- Output --

| movies_title                  | genre    | runtime_min | longest_movie                | shortest_movie               |
|-------------------------------|----------|-------------|------------------------------|------------------------------|
| Per qualche dollaro in più    | Western  | 132         | Once Upon a Time in the West | Per qualche dollaro in più   |
| The Outlaw Josey Wales        | Western  | 135         | Once Upon a Time in the West | Per qualche dollaro in più   |
| Il buono, il brutto, il cattivo | Western  | 161         | Once Upon a Time in the West | Per qualche dollaro in più |
| Once Upon a Time in the West  | Western  | 165         | Once Upon a Time in the West | Per qualche dollaro in più   |
| Wait Until Dark              | Thriller | 108         | Wait Until Dark              | Wait Until Dark               |


### 37. 37. Create or replace a view for the highest grossing movie per year
```sql
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
```
-- Output --

| movies_title   | released_year | gross    |
|----------------|----------------|----------|
| The Kid        | 1921           | 5450000  |
| Sherlock Jr.   | 1924           | 977375   |
| The Gold Rush  | 1925           | 5450000  |
| The General    | 1926           | 1033895  |
| Metropolis     | 1927           | 1236166  |

### 38.Compare avg rating of Drama vs Non-Drama movies
```sql
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
```
-- Output --

| category  | avg_rating |
|-----------|------------|
| Non_Drama | 7.95       |
| Drama     | 7.96       |


### 39. Get the top 3 most voted movies per decade and display the first 6 results.
```sql
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
```
-- Output --

| movies_title       | released_year | no_of_votes | decade | vote_rank |
|--------------------|----------------|-------------|--------|------------|
| Metropolis         | 1927           | 159992      | 1920   | 1          |
| The Kid            | 1921           | 113314      | 1920   | 2          |
| The Gold Rush      | 1925           | 101053      | 1920   | 3          |
| The Wizard of Oz   | 1939           | 371379      | 1930   | 1          |
| Gone with the Wind | 1939           | 290074      | 1930   | 2          |
| Modern Times       | 1936           | 217881      | 1930   | 3          |


	
     "# imdb-sql-analysis-postgresql" 
