SELECT 
    *
FROM
    netflix_db.netflix_analysis;

-- 15 Business Problems & Solutions

SELECT 
    typess, COUNT(show_id) AS total_content
FROM
    netflix_analysis
GROUP BY typess;

-- 2. Find the most common rating for movies and TV shows
	select
    typess,
    rating
    from
    (
	select
		typess,
        rating,
        count(*),
        rank() over(partition by typess order by count(*) desc) as ranking
	from netflix_analysis
    group by typess, rating) as t1
    where ranking=1;

-- 3. List all movies released in a specific year (e.g., 2020)
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'Movie' AND release_year = 2020;
-- 4. Find the top 5 countries with the most content on Netflix
	SELECT 
    SUBSTRING_INDEX(country, ',', 1) AS new_country,
    COUNT(show_id) AS total_content
FROM
    netflix_analysis
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
    
-- 5. Identify the longest movie
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'Movie'
ORDER BY SUBSTRING_INDEX(duration, ' ', 1) DESC;

-- 6. Find content added in the last 5 years
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
        
        
-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	SELECT 
    *
FROM
    (SELECT 
        *, SUBSTRING_INDEX(director, ',', 1) AS director_name
    FROM
        netflix_analysis) AS t1
WHERE
    director_name = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'TV Show'
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 9. Count the number of content items in each genre
	SELECT 
    SUBSTRING_INDEX(listed_in, ',', 1) AS genre,
    COUNT(*) AS total_content
FROM
    netflix_analysis
GROUP BY 1;

-- 10.Find each year and the average numbers of content release in India on netflix. And return top 5 year with highest avg content release!
	SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(COUNT(show_id) / (SELECT 
                    COUNT(show_id)
                FROM
                    netflix_analysis
                WHERE
                    country = 'India') * 100,
            2) AS avg_release
FROM
    netflix_analysis
WHERE
    country = 'India'
GROUP BY country , release_year
ORDER BY avg_release DESC
LIMIT 5;




-- 11. List all movies that are documentaries
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    listed_in LIKE '%Documentaries';
-- 12. Find all content without a director
		SELECT 
    *
FROM
    netflix_analysis
WHERE
    director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
	SELECT 
    *
FROM
    netflix_analysis
WHERE
    casts LIKE '%Salman Khan%'
        AND release_year > YEAR(CURDATE()) - 10;
    
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
	SELECT 
    SUBSTRING_INDEX(casts, ',', 1) AS actor,
    COUNT(typess) AS total_movies
FROM
    netflix_analysis
WHERE
    country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
	
-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT 
    category, typess, COUNT(*) AS content_count
FROM
    (SELECT 
        *,
            CASE
                WHEN
                    descriptions LIKE '%kill%'
                        OR descriptions LIKE '%violence%'
                THEN
                    'Bad'
                ELSE 'Good'
            END AS category
    FROM
        netflix_analysis) AS categorized_content
GROUP BY category , typess
ORDER BY typess;


