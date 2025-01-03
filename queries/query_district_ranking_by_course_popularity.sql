SELECT 
    y.year AS examYear,
    c.name AS courseName,
    d.name AS districtName,
    COUNT(*) AS numStudents,
    RANK() OVER (PARTITION BY y.year, c.name ORDER BY COUNT(*) DESC) AS rank_position
FROM 
    Results r
JOIN 
    Schools s ON r.schoolId = s.schoolId
JOIN 
    Districts d ON s.districtId = d.districtId
JOIN 
    Courses c ON r.courseId = c.courseId
JOIN 
    Years y ON r.yearId = y.yearId
GROUP BY 
    y.year, c.name, d.name
ORDER BY 
    y.year, c.name, rank_position;


