
DROP TABLE IF EXISTS Attendance CASCADE;
DROP TABLE IF EXISTS Faculty_Student CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Departments CASCADE;
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS attendance_status CASCADE;


CREATE TYPE user_role AS ENUM ('HOD', 'FACULTY', 'STUDENT');
CREATE TYPE attendance_status AS ENUM ('PRESENT', 'ABSENT', 'LATE');


CREATE TABLE Departments (
    department_id   SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE Users (
    user_id        SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    user_code      VARCHAR(50) NOT NULL UNIQUE,   
    password       VARCHAR(255) NOT NULL,         
    role           user_role NOT NULL,
    department_id  INTEGER REFERENCES Departments(department_id) ON DELETE SET NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE Faculty_Student (
    id          SERIAL PRIMARY KEY,
    faculty_id  INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    student_id  INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE (faculty_id, student_id)
);


CREATE TABLE Attendance (
    attendance_id  SERIAL PRIMARY KEY,
    student_id     INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    faculty_id     INTEGER NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    date           DATE NOT NULL,
    status         attendance_status NOT NULL,
    UNIQUE (student_id, faculty_id, date)
);


CREATE INDEX idx_users_role ON Users(role);
CREATE INDEX idx_users_department ON Users(department_id);
CREATE INDEX idx_attendance_student ON Attendance(student_id);
CREATE INDEX idx_attendance_faculty ON Attendance(faculty_id);
CREATE INDEX idx_attendance_date ON Attendance(date);

INSERT INTO Departments (department_name) VALUES
('Computer Science'),
('Electronics'),
('Mechanical');


INSERT INTO Users (name, user_code, password, role, department_id) VALUES
('Dr. Sharma', 'HOD001', 'hashed_password_1', 'HOD', 1),
('Prof. Mehta', 'FAC001', 'hashed_password_2', 'FACULTY', 1),
('Prof. Iyer', 'FAC002', 'hashed_password_3', 'FACULTY', 2),
('Rahul Verma', 'STU001', 'hashed_password_4', 'STUDENT', 1),
('Anita Singh', 'STU002', 'hashed_password_5', 'STUDENT', 1);

INSERT INTO Faculty_Student (faculty_id, student_id) VALUES
(2, 4),
(2, 5);

INSERT INTO Attendance (student_id, faculty_id, date, status) VALUES
(4, 2, '2026-06-29', 'PRESENT'),
(5, 2, '2026-06-29', 'ABSENT'),
(4, 2, '2026-06-30', 'PRESENT');

