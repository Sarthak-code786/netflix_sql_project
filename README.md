# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix_analysis;
create table netflix_analysis (
		show_id	varchar(20),
		typess varchar(50),
		title  varchar(150),
		director varchar(208),
		casts	varchar(1000),
		country	varchar(150),
        date_added	varchar(100),
		release_year	int,
		rating	varchar(50),
		duration	varchar(50),
		listed_in	varchar(150),
		descriptions varchar(250)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    typess, COUNT(show_id) AS total_content
FROM
    netflix_analysis
GROUP BY typess;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT
    typess,
    rating
    FROM
    (
	SELECT
		typess,
        rating,
        count(*),
        RANK() OVER(PARTITION BY typess ORDER BY count(*) DESC) AS ranking
	FROM netflix_analysis
    GROUP BY typess, rating) AS t1
    WHERE ranking=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'Movie' AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    SUBSTRING_INDEX(country, ',', 1) AS new_country,
    COUNT(show_id) AS total_content
FROM
    netflix_analysis
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'Movie'
ORDER BY SUBSTRING_INDEX(duration, ' ', 1) DESC;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
    *
FROM
    (SELECT 
        *, SUBSTRING_INDEX(director, ',', 1) AS director_name
    FROM
        netflix_analysis) AS t1
WHERE
    director_name = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    typess = 'TV Show'
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    SUBSTRING_INDEX(listed_in, ',', 1) AS genre,
    COUNT(*) AS total_content
FROM
    netflix_analysis
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT 
    *
FROM
    netflix_analysis
WHERE
    casts LIKE '%Salman Khan%'
        AND release_year > YEAR(CURDATE()) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings:** Understanding the most common ratings provides insight into the content's target audience.
Geographical Insights:** The top countries and India's average content releases highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Sarthak Mehrotra

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and connect with me

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/sarthak-mehrotra-8584bb20a/)
- **X**: [Join our community to learn and grow together](https://x.com/SarthakMeh766)

Thank you and I look forward to connecting with you!
