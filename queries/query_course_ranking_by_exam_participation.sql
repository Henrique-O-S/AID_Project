SELECT 
    y.year AS examYear,
    e.examDesc AS examDescription,
    c.name AS courseName,
    COUNT(*) AS numStudents,
    RANK() OVER (PARTITION BY y.year, e.examDesc ORDER BY COUNT(*) DESC) AS rank_position
FROM 
    Results r
JOIN 
    Courses c ON r.courseId = c.courseId
JOIN 
    Exams e ON r.examId = e.examId
JOIN 
    Years y ON r.yearId = y.yearId
GROUP BY 
    y.year, e.examDesc, c.name
ORDER BY 
    y.year, e.examDesc, rank_position;

