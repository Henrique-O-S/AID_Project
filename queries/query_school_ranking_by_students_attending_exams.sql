SELECT 
    y.year AS examYear,
    s.name AS schoolName,
    d.name AS districtName,
    COUNT(*) AS numStudents,
    RANK() OVER (PARTITION BY y.year ORDER BY COUNT(*) DESC) AS rank_position
FROM 
    Results r
JOIN 
    Schools s ON r.schoolId = s.schoolId
JOIN 
    Districts d ON s.districtId = d.districtId
JOIN 
    Years y ON r.yearId = y.yearId
GROUP BY 
    y.year, s.name, d.name
ORDER BY 
    y.year, rank_position;