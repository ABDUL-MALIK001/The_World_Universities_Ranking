-- 1. Top 10 Countries with the highest number of universities on the ranking.
SELECT TOP 10 Country, MAX(C_Countries) AS MAX_COUNTRY
FROM (
		SELECT Country, COUNT(Country) AS C_Countries
		FROM
			TWUR2016_2024
		GROUP BY
			Country
	) AS COUNTRY_COUNT
GROUP BY
	Country
ORDER BY
	MAX_COUNTRY DESC;


-- 2. Find the universities with Top 10 Student population in total
SELECT 
	TOP 10 Name, Country, SUM(Student_Population) AS S_SUM
FROM 
	TWUR2016_2024
GROUP BY
	Name, Country
ORDER BY 
	S_SUM DESC;

-- 3. Find the universities with Top 10 Student population in 2024 in United Kingdom
SELECT 
	TOP 10 Name, Country, SUM(Student_Population) AS S_SUM
FROM 
	TWUR2016_2024
WHERE
	C_Year = 2024 AND Country = 'United Kingdom'
GROUP BY
	Name, Country
ORDER BY 
	S_SUM DESC;


-- 4. Total Number of students in each year and countries
SELECT Country, SUM(Student_Population) AS Total_Student_Population
FROM
	TWUR2016_2024
GROUP BY
	Country;

SELECT C_Year, SUM(Student_Population) AS Total_Student_Population
FROM
	TWUR2016_2024
GROUP BY
	C_Year;


-- 5. Universities with the highest Student population in Nigeria in 2024
SELECT Name, SUM(Student_Population) AS Total_Student_Population
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria' AND C_Year = 2024
GROUP BY
	Name
ORDER BY
	Total_Student_Population DESC;


-- 6. Year with the highest number of students
SELECT C_Year, SUM(Student_Population) AS Total_Student_Population
FROM
	TWUR2016_2024
GROUP BY
	C_Year
ORDER BY
	Total_Student_Population DESC;

-- 7. Universities with First to three Rank between 2022 and 2024
SELECT C_Rank, Name, C_Year
FROM
	TWUR2016_2024
WHERE
	C_Rank BETWEEN 1 AND 3
AND
	C_Year BETWEEN 2022 AND 2024;

-- 8. Name and country with the highest number of student in 2024
SELECT Name, Country, SUM(Student_Population) AS POP_SUM
FROM
	TWUR2016_2024
WHERE
	C_Year = 2024
GROUP BY
	Name, Country
HAVING
	SUM(Student_Population) = (
								SELECT MAX(POP_SUM) AS MAX_POP
								FROM 
									(
										SELECT Name, Country, SUM(Student_Population) AS POP_SUM
										FROM
											TWUR2016_2024
										WHERE
											C_Year = 2024
										GROUP BY
											Name, Country
									) AS MAXIMUM
								);

-- 9. University that was mentioned in the ranking more than three times in Nigeria in Descending Order.
SELECT Name, COUNT(C_Rank) AS RANK_COUNT
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria'
GROUP BY
	Name
HAVING
	COUNT(C_Rank) > 3
ORDER BY
	RANK_COUNT DESC;

-- 10. University that was mentioned in the ranking every year (2016 to 2024) in Singapore
SELECT Name, Country, COUNT(C_Rank) AS RANK_COUNT
FROM
	TWUR2016_2024
WHERE
	Country = 'Singapore'
GROUP BY
	Name, Country
HAVING
	COUNT(C_Rank) = 9
ORDER BY
	Name ASC;

-- 11. Top 5 Countries with more universities on the ranking every year 
SELECT TOP 5 Country, Count(Country) AS C_COUNT
FROM
	(
	SELECT Name, Country, COUNT(C_Rank) AS RANK_COUNT
	FROM
		TWUR2016_2024
	GROUP BY
		Name, Country
	HAVING
		COUNT(C_Rank) = 9
	) AS SUBQU
GROUP BY
	Country
ORDER BY
	C_COUNT DESC;

-- End analysis on Ranking, Country and Population

-- International Students, Staff, Overall score Analysis
-- 1. University and Country with the highest number of International Students in the World
SELECT Name, Country, International_Students
FROM
	TWUR2016_2024
WHERE
	International_Students = (SELECT MAX(International_Students)
								FROM
									TWUR2016_2024);

-- 2. University and Country with the highest number of International Students in the United Arab Emirates in 2024
SELECT Name, Country, International_Students
FROM
	TWUR2016_2024
WHERE
	Country = 'United Arab Emirates' AND C_Year = 2024 AND
	International_Students = (SELECT MAX(International_Students)
								FROM
									TWUR2016_2024
								WHERE
									Country = 'United Arab Emirates' AND C_Year = 2024);

-- 3. University with the highest Students to Staff Ratio
SELECT Name, Country, ROUND(Students_to_Staff_Ratio,2) AS Students_to_Staff_Ratio
FROM
	TWUR2016_2024
WHERE
	Students_to_Staff_Ratio = (SELECT MAX(Students_to_Staff_Ratio) AS RATIO_MAX
								FROM
									TWUR2016_2024);

-- 4. University with the highest Students to Staff Ratio in United States
SELECT Name, Students_to_Staff_Ratio, C_Year
FROM
	TWUR2016_2024
WHERE
	Country = 'United States' AND
	Students_to_Staff_Ratio = (SELECT MAX(Students_to_Staff_Ratio) AS RATIO_MAX
								FROM
									TWUR2016_2024
								WHERE
									Country = 'United States');

-- 5. Total number of staffs in the world
SELECT ROUND(SUM(Student_Population/Students_to_Staff_Ratio),0) AS TOTAL_NO_STAFF
FROM
	TWUR2016_2024;


-- 6. Total number of staffs in Nigeria in 2024
SELECT CAST(SUM(Student_Population/Students_to_Staff_Ratio) AS INT) AS TOTAL_NO_STAFF_NIGERIA
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria' AND C_Year = 2024;

-- 7. Highest universities staffs in Nigeria
SELECT Name, ROUND(SUM(Student_Population/Students_to_Staff_Ratio),0) AS NO_STAFF
FROM
	TWUR2016_2024
GROUP BY
	Name
HAVING
	SUM(Student_Population/Students_to_Staff_Ratio) = (
														SELECT Max(NO_STAFF) AS MAX_STAFF
														FROM 
															(
															SELECT Name, SUM(Student_Population/Students_to_Staff_Ratio) AS NO_STAFF
															FROM
																TWUR2016_2024
															WHERE
																Country = 'Nigeria'
															GROUP BY
																Name
															) AS Nigeria_Staffs
														);
---OR

SELECT Name, ROUND(NO_STAFF,0) AS STAFF_NUMBER
FROM (
		SELECT Name, SUM(Student_Population / Students_to_Staff_Ratio) AS NO_STAFF
		FROM
			TWUR2016_2024
		WHERE
			Country = 'Nigeria'
		GROUP BY 
			Name
	) AS SUBSQUERY
WHERE NO_STAFF = (
					SELECT MAX(NO_STAFF) AS MAX_STAFF
					FROM (
							SELECT SUM(Student_Population / Students_to_Staff_Ratio) AS NO_STAFF
							FROM 
								TWUR2016_2024
							WHERE
								Country = 'Nigeria'
							GROUP BY
								Name
						) AS SUBSQUERY
				);

-- 8. University with the highest overall score in world
SELECT Name, CAST(Overall_Score AS INT) AS Overall_Score
FROM
	TWUR2016_2024
WHERE
	Overall_Score = (
					SELECT MAX(Overall_Score)
					FROM
						TWUR2016_2024
					);

-- 9. University with the highest overall score in Nigeria in 2024
SELECT Name, CAST(Overall_Score AS INT) AS Overall_Score
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria' AND C_Year = 2024
AND
	Overall_Score = (
					SELECT MAX(Overall_Score)
					FROM
						TWUR2016_2024
					WHERE
						Country = 'Nigeria' AND C_Year = 2024
					);

-- 10. Top 3 Univeristy with the highest total overall in the world
SELECT TOP 3 Name, FLOOR(SUM_OVER) AS OVERALL_SCORE
FROM
	(
	SELECT Name, SUM(Overall_Score) AS SUM_OVER
	FROM
		TWUR2016_2024
	GROUP BY
		Name) AS SQUERY
ORDER BY
	SUM_OVER DESC;

-- 11. University with the highest teaching score teaching score in the world
SELECT C_Rank, Name, Country, C_Year
FROM
	TWUR2016_2024
WHERE
	Teaching = (
				SELECT MAX(Teaching)
				FROM
					TWUR2016_2024
				);

-- 12. University with the highest teaching score teaching score in Nigeria
SELECT C_Rank, Name, C_Year
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria'
AND
	Teaching = (
				SELECT MAX(Teaching)
				FROM
					TWUR2016_2024
				WHERE
					Country = 'Nigeria'
				);

-- 13. University and Country with the highest teaching score teaching score or Research Environment in the world
SELECT Name, Country, C_Year, Teaching, Research_Environment
FROM
	TWUR2016_2024
WHERE
	Teaching = (
				SELECT MAX(Teaching)
				FROM
					TWUR2016_2024
				)
OR
	Research_Environment = (
							SELECT MAX(Research_Environment)
							FROM
								TWUR2016_2024
							)
ORDER BY
	Teaching DESC;

-- 14. University and Country with the highest Research Quality with highest Industry Impact in the Nigeria in 2024
(
SELECT Name, Industry_Impact, Research_Quality
FROM
	TWUR2016_2024
WHERE
	C_Year = 2024 AND Country = 'Nigeria'
AND
	Research_Quality = (
							SELECT MAX(Research_Quality)
							FROM
								TWUR2016_2024
							WHERE
								C_Year = 2024 AND Country = 'Nigeria'
						)
)
UNION
(
SELECT Name, Industry_Impact, Research_Quality
FROM
	TWUR2016_2024
WHERE
	C_Year = 2024 AND Country = 'Nigeria'
AND
	Industry_Impact = (
							SELECT MAX(Industry_Impact)
							FROM
								TWUR2016_2024
							WHERE
								C_Year = 2024 AND Country = 'Nigeria'
						)
);

-- 15. Impact of International outlook on the student populations in Nigerian Universities in 2024
SELECT Name, Student_Population, ROUND(International_Outlook,2) AS Intl_Outlook
FROM
	TWUR2016_2024
WHERE
	Country = 'Nigeria' AND C_Year = 2024
ORDER BY
	International_Outlook DESC;


-- 16. Relationship between Students population Total, Highest Population and Average population between 2016 to 2024
SELECT C_Year, SUM(Student_Population) Total_Students, MAX(Student_Population) Max_Students, AVG(Student_Population) Avg_Students
FROM
	TWUR2016_2024
GROUP BY
	C_Year
ORDER BY
	C_Year DESC;

-- End of International Students, Staff, Overall score Analysis




SELECT *
FROM TWUR2016_2024
