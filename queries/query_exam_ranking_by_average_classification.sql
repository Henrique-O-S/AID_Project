SELECT 
    y.year AS examYear,
    e.examDesc AS examDescription,
    e.exam AS examCode,
    AVG(r.examClassification) AS avgExamScore,
    RANK() OVER (PARTITION BY y.year ORDER BY AVG(r.examClassification) DESC) AS rank_position
FROM 
    Results r
JOIN 
    Exams e ON r.examId = e.examId
JOIN 
    Years y ON r.yearId = y.yearId
GROUP BY 
    y.year, e.examDesc, e.exam
ORDER BY 
    y.year, rank_position;
