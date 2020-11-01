SELECT 'ФИО: Тверкаева Алина Энверовна';

-- 1.1) Простые выборки: запрос на вывод 10 записей из таблицы ratings
SELECT * FROM movie.ratings LIMIT 10;

-- 1.2) Простые выборки: таблица links
-- Запрос на вывод записей, у которых imdbid оканчивается на "42" и поле 100 < movieid < 1000
SELECT * FROM movie.links
     WHERE imdbid LIKE '%42' AND movieid >100 AND movieid <1000;

-- 2.1) Сложные выборки JOIN: запрос mdbId, которым ставили рейтинг 5
 SELECT imdbid FROM movie.links
     INNER JOIN movie.ratings ON movie.ratings.movieid = movie.links.movieid
     WHERE movie.ratings.rating = 5
     LIMIT 10;

-- 3.1) Аггрегация данных - базовые статистики: 
-- Фильмы без оценки отсутствуют.
-- Запрос: количество фильмов с оценкой менее 2
SELECT COUNT(rating) AS movies_count_less_2
    FROM movie.ratings
    WHERE rating < 2

-- 3.2) Аггрегация данных - базовые статистики:
-- Запрос на вывод top-10 пользователей, у который средний рейтинг выше 3.5
SELECT userid, AVG(rating) AS avg_ratings
    FROM movie.ratings
    GROUP BY userid
    HAVING AVG(rating) > 3.5
    ORDER BY avg_ratings DESC
    LIMIT 10;

-- 4.1) Иерархические запросы
SELECT imdbid
    FROM movie.links
    WHERE movieid IN
    (
        SELECT movieid
            FROM movie.ratings
            GROUP BY movieid
            HAVING AVG(rating) > 3.5
            LIMIT 10
    );

-- 4.2) Иерархические запросы
WITH user_ratings_more_10 AS
    (
        SELECT AVG(rating) AS avg_rating
            FROM movie.ratings
            GROUP BY userid
            HAVING COUNT(rating) > 10
    )

SELECT AVG(avg_rating)
    FROM user_ratings_more_10
