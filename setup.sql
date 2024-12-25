DROP DATABASE IF EXISTS `enesNEW`;
CREATE DATABASE IF NOT EXISTS `enesNEW`;
USE `enesNEW`;

CREATE TABLE tblEscolasJoined as SELECT * FROM enes2014.tblEscolas UNION SELECT * FROM enes2013.tblEscolas;
CREATE TABLE tblCursosJoined as SELECT * FROM enes2014.tblCursos UNION SELECT * FROM enes2013.tblCursos;
CREATE TABLE tblSubTiposJoined as SELECT * FROM enes2014.tblCursosSubTipos UNION SELECT * FROM enes2013.tblCursosSubTipos;

SET SQL_SAFE_UPDATES = 0;

DELETE n1 FROM tblEscolasJoined n1, tblEscolasJoined n2 WHERE n1.Descr != n2.Descr AND n1.Escola = n2.Escola;
DELETE n1 FROM tblCursosJoined n1, tblCursosJoined n2 WHERE n1.Descr != n2.Descr AND n1.Curso = n2.Curso;
DELETE n1 FROM tblSubTiposJoined n1, tblSubTiposJoined n2 WHERE n1.Descr != n2.Descr AND n1.SubTipo = n2.SubTipo;

SET SQL_SAFE_UPDATES = 1;




CREATE TABLE PubPriv (
    pubPrivId INT PRIMARY KEY AUTO_INCREMENT,
    pubPriv VARCHAR(3) UNIQUE KEY,
    pubPrivDesc VARCHAR(255)
);
INSERT INTO PubPriv (pubPriv, pubPrivDesc) SELECT * FROM enes2014.tblCodsPubPriv;

CREATE TABLE Districts (
    districtId INT PRIMARY KEY AUTO_INCREMENT,
    district INT UNIQUE,
    name VARCHAR(255)
);

INSERT INTO Districts (district, name) SELECT * FROM enes2014.tblCodsDistrito;

CREATE TABLE Municipalities (
    municipalityId INT PRIMARY KEY AUTO_INCREMENT,
    municipality INT,
    name VARCHAR(255),
    districtId INT
);

INSERT INTO Municipalities (districtId, municipality, name ) SELECT * FROM enes2014.tblCodsConcelho;


CREATE TABLE Schools (
    schoolId INT PRIMARY KEY AUTO_INCREMENT,
    school INT UNIQUE,
    name VARCHAR(255),
    pubPrivId INT,
    pubPriv VARCHAR(3),
    pubPrivDesc VARCHAR(255),
    municipalityId INT,
    municipality INT,
    municipalityName VARCHAR(255),
    districtId INT,
    district INT,
    districtName VARCHAR(255)
);
INSERT INTO Schools (school, name, pubPrivId, pubPriv, pubPrivDesc, municipalityId, municipality, municipalityName, districtId, district, districtName) 
SELECT
    e.Escola,
    e.Descr,
    pp.pubPrivId,
    pp.pubPriv,
    pp.pubPrivDesc,
    m.municipalityId,
    m.municipality,
    m.name,
    d.districtId,
    d.district,
    d.name
FROM tblEscolasJoined e
LEFT JOIN PubPriv pp ON e.PubPriv = pp.pubPriv
LEFT JOIN Municipalities m ON e.Distrito = m.districtId AND e.Concelho = m.municipality
LEFT JOIN Districts d ON e.Distrito = d.district;


CREATE TABLE CourseTypes (
    courseTypeId INT PRIMARY KEY AUTO_INCREMENT,
    courseType VARCHAR(1) UNIQUE,
    courseTypeDesc VARCHAR(255),
    courseTypeStartYear INT,
    courseTypeEndYear INT,
    courseTypeOrder INT
);

INSERT INTO CourseTypes (courseType, courseTypeDesc, courseTypeStartYear, courseTypeEndYear, courseTypeOrder) SELECT * FROM enes2014.tblCursosTipos;

CREATE TABLE CourseSubTypes (
    courseSubTypeId INT PRIMARY KEY AUTO_INCREMENT,
    courseSubType VARCHAR(3) UNIQUE,
    courseSubTypeDesc VARCHAR(255),
    courseTypeId VARCHAR(1)
);

INSERT INTO CourseSubTypes (courseTypeId,courseSubType, courseSubTypeDesc) 
SELECT * FROM tblSubTiposJoined;


CREATE TABLE Courses (
   courseId INT PRIMARY KEY AUTO_INCREMENT,
   course VARCHAR(255) UNIQUE,
   name VARCHAR(255),
   courseSubTypeId INT,
   courseSubType VARCHAR(255),
   courseSubTypeDesc VARCHAR(255),
   courseTypeId INT,
   courseType VARCHAR(255),
   courseTypeDesc VARCHAR(255),
   courseTypeStartYear INT,
   courseTypeEndYear INT,
   courseTypeOrder INT
);

INSERT INTO Courses (course, name, courseSubTypeId, courseSubType, courseSubTypeDesc, courseTypeId, courseType, courseTypeDesc, courseTypeStartYear, courseTypeEndYear, courseTypeOrder)
SELECT
    c.Curso,
    c.Descr,
    cst.courseSubTypeId,
    cst.courseSubType,
    cst.courseSubTypeDesc,
    ct.courseTypeId,
    ct.courseType,
    ct.courseTypeDesc,
    ct.courseTypeStartYear,
    ct.courseTypeEndYear,
    ct.courseTypeOrder
FROM tblCursosJoined c
LEFT JOIN CourseSubTypes cst ON c.SubTipo = cst.courseSubType
LEFT JOIN CourseTypes ct ON c.TpCurso = ct.courseType;


CREATE TABLE Exams (
 examId INT PRIMARY KEY AUTO_INCREMENT,
 exam VARCHAR(3) UNIQUE,
 examDesc VARCHAR(255) 
);

INSERT INTO Exams (exam, examDesc) SELECT * FROM enes2014.tblExames;

CREATE TABLE Years (
 yearId INT PRIMARY KEY AUTO_INCREMENT,
 year INT UNIQUE
);

INSERT INTO Years (year) VALUES (2013), (2014);

CREATE TABLE Results (
    schoolId INT REFERENCES Schools(schoolId),
    examId INT REFERENCES Exams(examId),
    courseId INT REFERENCES Courses(courseId),
    yearId INT REFERENCES Years(yearId),
    phase integer,
    forApproval varchar(1),
    isIntern varchar(1),
    forImprovement varchar(1),
    forAdmission varchar(1),
    hasIntern varchar(1),
    sex varchar(1),
    age INT,
    cif INT,
    examClassification INT,
    cfd INT
);

INSERT INTO Results (schoolId, examId, courseId, yearId, phase, forApproval, isIntern, forImprovement, forAdmission, hasIntern, sex, age, cif, examClassification, cfd)
SELECT
    s.schoolId,
    e.examId,
    c.courseId,
    2,
    r.Fase,
    r.ParaAprov,
    r.Interno,
    r.ParaMelhoria,
    r.ParaIngresso,
    r.TemInterno,
    r.Sexo,
    r.Idade,
    r.CIF,
    r.Class_Exam,
    r.CFD
FROM enes2014.tblHomologa_2014 r
LEFT JOIN Schools s ON r.Escola = s.school
LEFT JOIN Exams e ON r.Exame = e.exam
LEFT JOIN Courses c ON r.Curso = c.course

INSERT INTO Results (schoolId, examId, courseId, yearId, phase, forApproval, isIntern, forImprovement, forAdmission, hasIntern, sex, age, cif, examClassification, cfd)
SELECT
    s.schoolId,
    e.examId,
    c.courseId,
    1,
    r.Fase,
    r.ParaAprov,
    r.Interno,
    r.ParaMelhoria,
    r.ParaIngresso,
    r.TemInterno,
    r.Sexo,
    r.Idade,
    r.CIF,
    r.Class_Exam,
    r.CFD
FROM enes2013.tblHomologa_2013 r
LEFT JOIN Schools s ON r.Escola = s.school
LEFT JOIN Exams e ON r.Exame = e.exam
LEFT JOIN Courses c ON r.Curso = c.course