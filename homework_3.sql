SELECT userid, movieid, 
        ((rating 
        - MIN(rating) OVER (PARTITION BY userid))
        /(MAX(rating) OVER (PARTITION BY userid)
        - MIN(rating) OVER (PARTITION BY userid))) as normed_rating,
        AVG(rating) OVER (PARTITION BY userid) as avg_rating
    FROM (
        SELECT DISTINCT userid, movieid, rating
            FROM movie.ratings
            --WHERE userId <> 0
            LIMIT 1000
    ) as sample
    ORDER BY userid DESC, avg_rating DESC LIMIT 30;