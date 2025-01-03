SELECT 
    y.year AS examYear,
    e.examDesc AS examName,
    r.sex,
    CASE 
        WHEN r.age < 18 THEN 'Under 18'
        WHEN r.age BETWEEN 18 AND 21 THEN '18-21'
        ELSE 'Over 21' 
    END AS ageGroup,
    AVG(r.examClassification) AS avgExamScore,
    COUNT(*) AS numStudents
FROM 
    Results r
JOIN 
    Exams e ON r.examId = e.examId
JOIN 
    Years y ON r.yearId = y.yearId
GROUP BY 
    y.year, e.examDesc, r.sex, ageGroup
ORDER BY 
    y.year, e.examDesc, ageGroup, r.sex;

