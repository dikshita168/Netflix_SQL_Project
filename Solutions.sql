-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

SELECT type , COUNT(*) AS total_content
FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows
SELECT * FROM netflix ;

SELECT 
	type, 
	rating

	(
	SELECT 
	type ,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS ranking
FROM netflix
GROUP BY 1,2 
) AS t1
WHERE ranking =1

SELECT 
	type,
	rating,
	COUNT(*) AS rating_count	
FROM netflix
GROUP BY type,rating  
--ORDER BY 3 DESC

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix;

SELECT *
FROM netflix
WHERE type='Movie' AND release_year = 2020


	
--4. Find the top 5 countries with the most content on Netflix

SELECT country,COUNT(country) AS country_count
FROM netflix
GROUP BY country 
ORDER BY country_count DESC
LIMIT (5)
	
--5. Identify the longest movie

SELECT * FROM netflix;

SELECT *
FROM netflix
WHERE 
	type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix)

	
--6. Find content added in the last 5 years
SELECT *		
FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'
FROM netflix
	
--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
	
--8. List all TV shows with more than 5 seasons
SELECT *	
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric > 5

	
--9. Count the number of content items in each genre
SELECT listed_in,COUNT(*) 	
FROM netflix
GROUP BY 
	listed_in
ORDER BY 
	COUNT(*) DESC


SELECT 
	 UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	 COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT * FROM netflix

SELECT  
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country= 'India')::numeric * 100,2) AS avg_content
FROM netflix
WHERE country='India' 
GROUP BY 1
	
	



	
--11. List all movies that are documentaries
	
SELECT * 
	FROM netflix
WHERE 
	listed_in ILIKE '%documentaries%'
	
--12. Find all content without a director

SELECT * 
	FROM netflix
WHERE 
	director IS NULL


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE 
	casts ILIKE '%salman khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10 


	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT * FROM netflix
	
SELECT 
	
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) AS total_content
	
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY total_content DESC
LIMIT 10
	
	
--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT * FROM netflix 

with new_table AS (
SELECT *,
	CASE
	WHEN description ILIKE '%kill%' OR
		 description ILIKE '%violence%' THEN 'Bad Content'
	ELSE 'Good Content'
	END category
FROM netflix
)

SELECT 
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY category





		  





