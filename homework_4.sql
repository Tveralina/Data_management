DROP TABLE IF EXISTS movie.content_genres;
DROP TABLE IF EXISTS movie.data_table;

CREATE TABLE movie.content_genres
(
    movieid BIGINT,
    genre VARCHAR(128)
);

\COPY movie.content_genres FROM '/usr/share/data_store/raw_data/genres.csv' DELIMITER ',' CSV HEADER

SELECT * FROM movie.content_genres LIMIT 100;

SELECT movieid, rating
    FROM (
        SELECT rt.movieid, avg(rating) AS rating, count(userid)
            FROM movie.ratings AS rt
            LEFT JOIN movie.content_genres AS cg ON cg.movieid = rt.movieid
            WHERE cg.genre IS NOT NULL
            GROUP BY rt.movieid
    ) AS s2
    WHERE count > 50
    ORDER BY rating DESC, movieid
    LIMIT 150;
    
WITH s3 AS (
    SELECT movieid, rating
    FROM (
        SELECT rt.movieid, avg(rating) AS rating, count(userid)
            FROM movie.ratings AS rt
            LEFT JOIN movie.content_genres AS cg ON cg.movieid = rt.movieid
            WHERE cg.genre IS NOT NULL
            GROUP BY rt.movieid
    ) AS s2
    WHERE count > 50
    ORDER BY rating DESC, movieid
    LIMIT 150
)

SELECT sss4.movieid, sss4.rating, cg.genre
    INTO movie.data_table
    FROM s3 AS sss4
    LEFT JOIN movie.content_genres AS cg ON sss4.movieid = cg.movieid
    ORDER BY sss4.rating DESC;

SELECT * FROM movie.data_table;

\COPY (SELECT * FROM movie.data_table) TO '/usr/share/data_store/raw_data/top_rated_tags.csv' WITH CSV HEADER DELIMITER AS E'\t';