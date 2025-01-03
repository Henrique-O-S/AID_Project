SELECT 
    y.year AS examYear,
    e.examDesc AS examName,
    d.name AS districtName,
    AVG(sr.avgClassification) AS avgDistrictScore,
    SUM(sr.numStudents) AS totalStudents,
    RANK() OVER (PARTITION BY y.year, e.examDesc ORDER BY AVG(sr.avgClassification) DESC) AS rank_position
FROM 
    SchoolResults sr
JOIN 
    Schools s ON sr.schoolId = s.schoolId
JOIN 
    Districts d ON s.districtId = d.districtId
JOIN 
    Exams e ON sr.examId = e.examId
JOIN 
    Years y ON sr.yearId = y.yearId
GROUP BY 
    y.year, e.examDesc, d.name
ORDER BY 
    y.year, e.examDesc, rank_position;


