WITH YearlyScores AS (
    SELECT 
        sr.schoolId,
        sr.examId,
        y.year,
        AVG(sr.avgClassification) AS avgScore
    FROM 
        SchoolResults sr
    JOIN 
        Years y ON sr.yearId = y.yearId
    GROUP BY 
        sr.schoolId, sr.examId, y.year
)
SELECT 
    s.name AS schoolName,
    d.name AS districtName,
    e.examDesc AS examName,
    ys1.year AS year1,
    ys2.year AS year2,
    ys2.avgScore - ys1.avgScore AS scoreImprovement
FROM 
    YearlyScores ys1
JOIN 
    YearlyScores ys2 
    ON ys1.schoolId = ys2.schoolId 
    AND ys1.examId = ys2.examId
    AND ys2.year = ys1.year + 1
JOIN 
    Schools s ON ys1.schoolId = s.schoolId
JOIN 
    Districts d ON s.districtId = d.districtId
JOIN 
    Exams e ON ys1.examId = e.examId
ORDER BY 
    scoreImprovement DESC
LIMIT 10;


