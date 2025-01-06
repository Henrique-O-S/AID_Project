SELECT 
    y.year,
    sr.examId,
    e.examDesc,
    SUM(sr.numStudents) AS totalParticipants,
    SUM(sr.numApproved) AS totalApproved,
    (SUM(sr.numApproved) * 100.0 / SUM(sr.numStudents)) AS approvalRate
FROM 
    SchoolResults sr
JOIN 
    Exams e ON sr.examId = e.examId
JOIN 
    Years y ON sr.yearId = y.yearId
GROUP BY 
    y.year, sr.examId, e.examDesc
ORDER BY 
    approvalRate DESC;
