-- Creating the database 
CREATE DATABASE spotify;

-- uploaded .csv file through sqlalchemy 
USE spotify;

-- EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT(artist)) FROM spotify;

SELECT COUNT(DISTINCT(album)) FROM spotify;

SELECT DISTINCT(album) FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify 
WHERE duration_min = 0;

DELETE FROM spotify 
WHERE duration_min = 0;

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT Track,Stream FROM spotify
WHERE Stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT Album,Artist FROM spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(Comments) AS all_comments FROM spotify
WHERE LOWER(Licensed) = 'true';

-- 4. Find all tracks that belong to the album type single.
SELECT * FROM spotify 
WHERE album_type = 'single';

-- 5. Count the total number of tracks by each artist.
SELECT artist,COUNT(*) AS total_songs FROM spotify
GROUP BY artist;

-- 6. Calculate the average danceability of tracks in each album.
SELECT Album,AVG(danceability) AS avg_danceablity 
FROM spotify
GROUP BY Album;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT DISTINCT Track, Energy
FROM spotify
ORDER BY Energy DESC LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT Track, 
SUM(Views) AS total_views,
SUM(Likes) AS total_likes 
FROM spotify
WHERE LOWER(official_video) = 'true'
GROUP BY Track
ORDER BY total_likes DESC ;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT Album,Track, SUM(Views) AS total_views 
FROM spotify
GROUP BY Album,Track
ORDER BY total_views DESC ;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM (SELECT Track,
COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY Track) AS T1
WHERE streamed_on_spotify > streamed_on_youtube
AND
streamed_on_youtube != 0;

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT * FROM (SELECT Artist,Track,Views,
DENSE_RANK() OVER(PARTITION BY Artist ORDER BY Views DESC) AS ranking
FROM spotify) AS rankwise_tracks 
WHERE ranking <=3;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT Artist,Track,Liveness 
FROM spotify 
WHERE Liveness > (SELECT AVG(Liveness) FROM spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH CTE AS(
SELECT Album,
MAX(Energy) AS max_energy,
MIN(Energy) AS min_energy
FROM spotify
GROUP BY Album
)
SELECT Album,  max_energy - min_energy AS difference
FROM CTE 
ORDER BY difference ASC