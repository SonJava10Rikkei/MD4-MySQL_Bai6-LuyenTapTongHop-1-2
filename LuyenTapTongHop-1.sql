create database Bai6LuyenTap;
use Bai6LuyenTap;

create table Students(
StudentID int not null auto_increment primary key,
StudentName varchar(50) not null,
Age int,
Email varchar(100)

);

create table Classes(
ClassID int not null auto_increment primary key,
ClassName varchar(50)

);

create table Subjects(
SubjectID int not null auto_increment primary key,
SubjectName varchar(50)

);


create table ClassStudent(
StudentID int not null,
ClassID int not null,
primary key(StudentID, ClassID),
foreign key (StudentID) references Students(StudentID),
foreign key (ClassID) references Classes(ClassID)
);

create table Marks(
Mark int not null,
SubjectID int not null,
StudentID int not null,
FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID),
FOREIGN KEY (StudentID) REFERENCES Students (StudentID)
);

-- Thêm dữ liệu

insert into Students(StudentName, Age, Email) values
('Nguyen Quang An', 18, 'an@yahoo.com'),
('Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
('Nguyen Van Quyen', 19, 'quyen'),
('Phan Thanh Binh', 25, 'binh@com'),
('Nguyen Van Tai EM', 30, 'taiem@sport.vn')
;

insert into Classes(ClassName) values
('C0706L'),
('C0708G')
;

insert into ClassStudent(StudentID, ClassID) values
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2)
;

insert into Subjects(SubjectName) values
('SQL'),
('Java'),
('C'),
('Visual Basic')
;


insert into Marks(Mark, SubjectID, StudentID) values 
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4)
;

-- 1. Hien thi danh sach tat ca cac hoc vien 
select * from Students;

-- 2. Hien thi danh sach tat ca cac mon hoc
select * from Subjects;

-- 3. Tinh diem trung binh 
select avg(Mark) as DiemCaLop from Marks;
select m.StudentID, s.StudentName, avg(m.Mark) as DiemTBSV
from Marks as m
join Students as s on s.StudentID = m.StudentID
group by m.StudentID
;

-- 4. Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select SubjectName , max(Mark) as maxMask from Subjects
inner join marks on Subjects.SubjectID = Marks.SubJectID;

-- 5. Danh so thu tu cua diem theo chieu giam
select row_number() over (order by mark desc) as 'STT', Mark from Marks;

select row_number() over (order by mark desc) as 'STT', students.studentId, students.studentName, mark, subjectName, className from students
inner join marks on students.studentId = marks.studentId
inner join subjects on marks.subjectId = subjects.subjectId
inner join classStudent on students.studentId = classStudent.StudentId
inner join classes on  classes.classId = classStudent.classId
;

-- 6. Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table Subjects
modify column SubjectName varchar(255);

-- 7. Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE Subjects SET SubjectName = CONCAT('Day la mon hoc ', SubjectName);

-- 8. Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
alter table Students add constraint age check(age between 15 and 55);

-- 9. Loai bo tat ca quan he giua cac bang
-- Tắt khóa ngoại
set foreign_key_checks = 0;
-- Bật khóa ngoạimport table from
set foreign_key_checks = 1;

-- 10. Xoa hoc vien co StudentID la 1
-- trước khi xóa cần bật tắt khóa ngoại không thì cần xóa dữ liệu ở các bảng có các trường liên quan đến nó 
select * from Students;
select * from Marks;
delete from Students where StudentID = 1;

-- 11. Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table Students
add status bit default 1;

-- 12. Cap nhap gia tri Status trong bang Student thanh 0
 update students set status = 0;