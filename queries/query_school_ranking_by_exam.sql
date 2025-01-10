SELECT 
    y.year AS yearValue, 
    e.examDesc AS examName,
    s.name AS schoolName,
    d.name AS districtName,
    sr.avgClassification AS averageScore,
    RANK() OVER (PARTITION BY sr.yearId, sr.examId ORDER BY sr.avgClassification DESC) AS rank_position
FROM 
    SchoolResults sr
JOIN 
    Schools s ON sr.schoolId = s.schoolId
JOIN 
    Districts d ON s.districtId = d.districtId
JOIN 
    Exams e ON sr.examId = e.examId
JOIN 
    Years y ON sr.yearId = y.yearId;
