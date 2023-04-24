-- Tạo bảng --
-- create database sales_management;
create table customer (
cID varchar(4) 				primary key,
cName varchar (30)			not null,
cAddress varchar(40),
cBirthday datetime,	
cPhone varchar(15)			
);

create table employee (
eID varchar(4)				primary key,
eName varchar(20)			not null,
eGender bit					not null,
eAddress varchar(50)		not null,
eBirthday datetime			not null,
ePhone varchar(15),
eMail varchar(50),
ePOB varchar(20)			not null,
eFDOW datetime,
eMNGID varchar(4)
);

create table supplier (
supID varchar(5)			primary key,
supName varchar(50)			not null,
supAddress varchar(50)		not null,
supPhone varchar(15)		not null,
supMail varchar(30)			not null,
supWeb varchar(30)
);

create table product_type (
tID varchar(4)				primary key,
tName varchar(30)			not null,
tNote varchar(100)			not null
);

create table product (
pID varchar(4)				primary key,
tID varchar(4),
pName varchar(150)			not null,
pUnit varchar(10)			not null,
pNote varchar(100)			
);

create table import_form (
iID varchar(5)				primary key,
eID varchar(4),
supID varchar(5),
iDate datetime				not null,
iNote varchar(100)
);

create table import_form_detail (
pID varchar(4),
iID varchar(5),
iQuantity smallint			not null default(0) check (iQuantity>=0),
iPrice real					not null check (iPrice>=0)
);

create table export_form (
exID varchar(5)				primary key,
eID varchar(5)				not null,
cID varchar(4) 				not null,
sellDate datetime			not null,
exNote varchar(100)
);

create table export_form_detail (
exID varchar(5),
pID varchar(4),
exQuantity smallint			not null check (exQuantity>0),
exPrice real				not null check (exPrice>0)	
);


-- Bài 2: Dùng câu lệnh ALTER để thêm rằng buộc khóa ngoại cho các bảng
alter table export_form add foreign key (cID) references customer (cID);
alter table export_form add foreign key (eID) references employee (eID);

alter table export_form_detail add foreign key (exID) references export_form (exID);
alter table export_form_detail add foreign key (pID) references product (pID);
alter table export_form_detail add primary key (exID, pID);

alter table import_form add foreign key (supID) references supplier (supID);
alter table import_form add foreign key (eID) references employee (eID);

alter table import_form_detail add foreign key (iID) references import_form (iID);
alter table import_form_detail add foreign key (pID) references product (pID);
alter table import_form_detail add primary key (iID, pID);

alter table product add foreign key (tID) references product_type(tID);


-- Nhập dữ liệu bảng --
use sales_management_advance;
insert into product_type values 
("TP01", "Phone", "smart phone"),
("TP02", "computer", "case");
insert into product values 
("P001","TP01","Samsung galaxy S29","pieces","new"),
("P002","TP02","Dell inspiron","pieces","new"),
("P003","TP01","Iphone 15","pieces","new"),
("P004","TP02","LG 1996","pieces","new");
insert into supplier values 
("SP001","VanCom","HaiPhong","1111111111","van@gmail.com",null),
("SP002","VuongCom","HaNoi","99999999999","vuong@gmail.com",null);
insert into employee values 
("E001", "Yen", 0, "PhuXuyen","1992-4-02", null,null, "HN",null,null),
("E002", "Chuan", 1, "NamDinh","1992-4-02", null,null, "ND",null,null),
("E003", "Thu", 0, "YenBai","2000-9-11", null,null, "YB",null,null);
insert into import_form values 
("IF001","E001","SP001","2023-4-21",null),
("IF002","E002","SP002","2023-4-21",null);
insert into import_form_detail values 
("P001","IF001", 2, 1000),
("P002", "IF002", 2, 5000);
insert into customer values 
("C001","Son den", null, null, null),
("C002","Son do", null, null, null);
insert into export_form values 
("EX001","E003","C001","2023-4-21",null),
("EX002","E001","C002","2023-4-21",null);
insert into export_form_detail values 
("EX001","P003", 3, 10000),
("EX002", "P004", 3, 25000);

-- Bài 4: Dùng lệnh UPDATE cập nhật dữ liệu các bảng
-- Cập nhật thông tin -- 
update customer set cPhone = "0919072219" where cID = "C002";
update employee set eAddress = "HN" where eID = "E001";

-- Bài 5: Dùng lệnh DELETE xóa dữ liệu các bảng
-- Xóa dữ liệu -- 
update customer set cPhone = "0919072219" where cID = "C002";
update employee set eAddress = "HN" where eID = "E001";


-- Bài 6: Dùng lệnh SELECT lấy dữ liệu từ các bảng
-- 6.1 Liệt kê thông tin nhân viên trong cửa hàng, sắp xếp theo tuổi -- 
select e.eID, e.eName, e.eGender, e.eBirthday, e.eAddress, e.ePhone, 
concat(year(now())-year(eBirthday)) as "age" from employee e order by concat(year(now())-year(eBirthday)) asc;

-- 6.2 Liệt kê các hóa đơn nhập hàng trong tháng 6/2018 -- 
insert into import_form values 
("IF003","E001","SP001","2018-6-21",null);
insert into import_form_detail values 
("P003","IF003", 2, 2000);
select i.iID, i.eid, e.ename, s.supname, i.idate, i.inote
from ((import_form i
join employee e on i.eid = e.eid)
join supplier s on i.supid = s.supid)
where i.idate like "2018-06-%";

-- 6.3 Liệt kê tất cả sản phẩm có đơn vị tính là chai, gồm tất cả thông tin về sản phẩm -- 
insert into product_type values 
("TP03", "Juice", "good juice");
insert into product values 
("P005","TP03","Orange Juice","bottle","new");
select * from product where product.pUnit = "bottle";

-- 6.4 Liệt kê chi tiết nhập hàng trong tháng hiện hành gồm thông tin: số phiếu nhập, mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính, số lượng, giánhập, thành tiền.
select i.iID, ifd.pid, p.pname, p.tid, p.punit, ifd.iquantity, ifd.iprice, concat(ifd.iquantity * ifd.iprice) as Total
from ((import_form_detail ifd
join import_form i on i.iID = ifd.iID)
join product p on ifd.pid = p.pid)
where i.iDate like "2023-04-%";

-- 6.5 Liệt kê các nhà cung cấp có giao dịch mua bán trong tháng hiện hành, gồm thông tin: mã nhà cung cấp, họ tên nhà cung cấp, địa chỉ, số điện thoại, email, số phiếu nhập, ngày nhập. Sắp xếp thứ tự theo ngày nhập hàng.
select import_form.supID, supplier.supName, supplier.supAddress, supplier.supPhone, supplier.supMail, import_form.iID, import_form.iDate
from import_form join supplier on supplier.supID = import_form.supID where month(curdate()) = month(import_form.iDate) order by date(import_form.iDate);

-- 6.6 Liệt kê chi tiết hóa đơn bán hàng trong 6 tháng đầu năm 2018 gồm thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm,đơn vị tính, số lượng, giá bán, doanh thu
insert into export_form values 
("EX003","E001","C001","2018-4-21",null),
("EX004","E002","C002","2018-1-20",null);
insert into export_form_detail values 
("EX003","P004", 5, 12000),
("EX004", "P005", 7, 9000);
select ef.exid, e.ename, ef.selldate, p.pid, p.pname, efd.exquantity, efd.exprice, concat(efd.exquantity*efd.exprice) as Revenue
from (((export_form ef
join employee e on ef.eid = e.eid)
join export_form_detail efd on efd.exid = ef.exid)
join product p on p.pid = efd.pid)
where ef.selldate < "2018-07-01";

-- 6.7 in danh sách khách hàng có ngày sinh nhật trong tháng hiện hành
update customer set cBirthday = "1990-2-4" where cID="C001";
update customer set cBirthday = "1993-4-10" where cID="C002";
select * from customer where month(curdate()) = month(customer.cBirthday);

-- 6.8 Liệt kê các hóa đơn bán hàng từ ngày 15/04/2018 đến 15/05/2018 gồm các thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu
select ef.exid, e.ename, ef.selldate, p.pid, p.pname, p.punit, efd.exquantity, efd.exprice, concat(efd.exquantity*efd.exprice) as Revenue
from (((export_form ef
join employee e on ef.eid = e.eid)
join export_form_detail efd on ef.exid = efd.exid)
join product p on efd.pid = p.pid)
where ef.selldate between "2018-04-15" and "2018-05-15";

-- 6.9 Liệt kê các hóa đơn mua hàng theo từng khách hàng, gồm các thông tin: số phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá.
select export_form.cID, customer.cName, export_form_detail.exID, export_form_detail.exPrice, export_form.sellDate from export_form
join export_form_detail on export_form_detail.exID = export_form.exID
join customer on customer.cID = export_form.cID;

-- 6.10 Cho biết tổng số chai nước xả vải Comfort đã bán trong 6 tháng đầu năm 2018. Thông tin hiển thị: tổng số lượng.
insert into product_type values 
("TP04", "Washing Powder", "Washing Powder");
insert into product values 
("P006","TP04","Comfort","bottle","new");
insert into export_form values 
("EX005","E001","C001","2018-4-20",null),
("EX006","E002","C002","2018-2-10",null);
insert into export_form_detail values 
("EX005","P006", 5, 8888),
("EX006", "P006", 7, 9000);
select sum(efd.exquantity) as "Total"
from export_form_detail efd
join product p on efd.pid = p.pid
where p.pname = "comfort";

-- 6.11 Tổng kết doanh thu theo từng khách hàng theo tháng, gồm các thông tin: tháng, mã khách hàng, tên khách hàng, địa chỉ, tổng tiền.
select ef.cID, c.cName, c.cAddress, month(ef.sellDate) as "month", sum(efd.exQuantity*efd.exPrice) as "Total Revenue"
from export_form  ef
join export_form_detail efd on efd.exID=ef.exID
join customer c on c.cID = ef.cID
group by c.cName, month(ef.sellDate);

-- 6.12 Thống kê tổng số lượng sản phẩm đã bán theo từng tháng trong năm, gồm thông tin: năm, tháng, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số lượng
select year(ef.selldate) as "Year", month(ef.selldate) as "Month", p.pid, p.punit, sum(efd.exquantity) as "Total Amount"
from export_form ef
join export_form_detail efd on ef.exid = efd.exid
join product p on p.pid = efd.pid
group by month(ef.selldate);

-- 6.13 Thống kê doanh thu bán hàng trong trong 6 tháng đầu năm 2018, thông tin hiển thị gồm: tháng, doanh thu.
insert into export_form values 
("EX007","E001","C001","2018-6-21",null),
("EX008","E002","C002","2018-6-20",null);
insert into export_form_detail values 
("EX007","P005", 5, 50),
("EX008", "P006", 7, 100);
select month(export_form.sellDate) as "month", sum(export_form_detail.exQuantity*export_form_detail.exPrice) as "Total Revenue"
from export_form
join export_form_detail on export_form_detail.exID=export_form.exID 
where month(export_form.sellDate) = 06 and year(export_form.sellDate) = 2018;

-- 6.14 Liệt kê các hóa đơn bán hàng của tháng 5 và tháng 6 năm 2018, gồm các thông tin: số phiếu, ngày bán, họ tên nhân viên bán hàng, họ tên khách hàng, tổng trị giá.
select ef.exid, ef.selldate, e.ename, c.cname, sum(efd.exquantity*efd.exprice) as "Total"
from export_form ef
join export_form_detail efd on efd.exid = ef.exid
join employee e on e.eid = ef.eid
join customer c on c.cid = ef.cid
where (month(ef.selldate) between 5 and 6) and year(ef.selldate) = 2018;

-- 6.15 Cuối ngày, nhân viên tổng kết các hóa đơn bán hàng trong ngày, thông tin gồm: số phiếu xuất, mã khách hàng, tên khách hàng, họ tên nhân viên bán hàng, ngày bán, trị giá.
select ef.exID, ef.cID,c.cName, e.eName, ef.sellDate, efd.exPrice
from export_form ef
join customer c on c.cID = ef.cID
join employee e on e.eID = ef.eID
join export_form_detail efd on efd.exID = ef.exID group by ef.sellDate;

-- 6.16 Thống kê doanh số bán hàng theo từng nhân viên, gồm thông tin: mã nhân viên, họ tên nhân viên, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số lượng.
select e.eid, e.ename, p.pid, p.pname, p.punit, sum(efd.exquantity) as "Total amount"
from export_form ef
join employee e on e.eid = ef.eid
join export_form_detail efd on efd.exid = ef.exid
join product p on p.pid = efd.pid
group by e.ename, p.pid;

-- 6.17 Liệt kê các hóa đơn bán hàng cho khách vãng lai (KH01) trong quý 2/2018, thông tin gồm số phiếu xuất, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị tính, số lượng, đơn giá, thành tiền.
select efd.exID, ef.sellDate, efd.pID, p.pName, p.pUnit, efd.exQuantity, efd.exPrice, concat(efd.exQuantity*efd.exPrice) as "Revenue"
from export_form_detail efd
join export_form ef on efd.exID = ef.exID
join product p on p.pID = efd.pID where (month(ef.sellDate) between 4 and 6) and (year(ef.sellDate) = 2018);

-- 6.18 Liệt kê các sản phẩm chưa bán được trong 6 tháng đầu năm 2018, thông tin gồm: mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính. 
insert into product values 
("P007","TP04","Omo","bottle","new");
select p.pid, p.pname, pt.tname, p.punit
from product p
join product_type pt on p.tid = pt.tid
where (not exists (select export_form_detail.pid from export_form_detail where p.pid = export_form_detail.pid));

-- 6.19 Liệt kê danh sách nhà cung cấp không giao dịch mua bán với cửa hàng trong quý 2/2018, gồm thông tin: mã nhà cung cấp, tên nhà cung cấp, địa chỉ, số điện thoại. 
insert into supplier values 
("SP003","YenCom","Hanoi","1111111111","yen@gmail.com",null),
("SP004","ThuCom","Yenbai","99999999999","thu@gmail.com",null);
select s.supID, s.supName, s.supAddress, s.supPhone
from supplier s
where not exists (select s.supID from supplier join import_form where import_form.supID = s.supID);

-- 6.20 Cho biết khách hàng có tổng trị giá đơn hàng lớn nhất trong 6 tháng đầu năm 2018.
select c.cid, c.cname, sum(efd.exPrice * efd.exQuantity) as Order_value
from customer c
join export_form ef on c.cid = ef.cID
join export_form_detail efd on efd.exID = ef.exid
where (month(ef.sellDate) between 1 and 6) and year(ef.selldate) = 2018 
group by c.cID
order by Order_value DESC
limit 1;

-- 6.21 Cho biết mã khách hàng và số lượng đơn đặt hàng của mỗi khách hàng
select export_form.cID, count(export_form.exID) from export_form
join customer on export_form.cID = customer.cID 
group by export_form.cID;

-- 6.22 Cho biết mã nhân viên, tên nhân viên, tên khách hàng kể cả những nhân viên không đại diện bán hàng
insert into employee values 
("E004", "Ha", 0, "PhuTho","2004-12-02", null,null, "PT",null,null);
select concat_ws("-", e.eid, e.ename) as Employee_info, c.cName
from employee e
left join export_form ef on e.eid = ef.eid
left join customer c on ef.cid = c.cid;

-- 6.23 Cho biết số lượng nhân viên nam, số lượng nhân viên nữ
select employee.eGender, count(employee.eGender) from employee
group by employee.eGender;


-- 6.24 Cho biết mã nhân viên, tên nhân viên, số năm làm việc của những nhân viên có thâm niên cao nhất.
UPDATE employee SET eFDOW = '2021-01-01' WHERE (eID = 'E001');
UPDATE employee SET eFDOW = '2022-05-01' WHERE (eID = 'E002');
UPDATE employee SET eFDOW = '2020-04-10' WHERE (eID = 'E003');
UPDATE employee SET eFDOW = '2020-04-10' WHERE (eID = 'E004');
select e.eid, e.ename, concat(2023-year(e.efdow)) as Seniority, e.eFDOW
from employee e
where e.eFDOW = (select min(efdow) from employee);

-- 6.25 Hãy cho biết họ tên của những nhân viên đã đến tuổi về hưu (nam:60 tuổi, nữ: 55 tuổi)
insert into employee values 
("E005", "Minh", 1, "VanPhu","1963-10-30", null,null, "HN",null,null);
insert into employee values
("E006", "Ngân", 0, "HaNoi","1966-5-02", null,null, "HN",null,null);
select employee.eName from employee where ((year(now())-year(eBirthday))>=60) or ((year(now())-year(eBirthday))>=55);

-- 6.26 Hãy cho biết họ tên của nhân viên và năm về hưu của họ.
select e.ename, concat(if(e.egender=0,55,60) - (2023-  year(e.ebirthday))) as YOW_Remaining
from employee e;

/* 6.27 Cho biết tiền thưởng tết dương lịch của từng nhân viên. Biết rằng - thâm 
niên <1 năm thưởng 200.000 - 1 năm <= thâm niên < 3 năm thưởng 
400.000 - 3 năm <= thâm niên < 5 năm thưởng 600.000 - 5 năm <= thâm 
niên < 10 năm thưởng 800.000 - thâm niên >= 10 năm thưởng 1.000.000*/

update employee set employee.eFDOW = "2018-06-10" where employee.eID = "E001";
update employee set employee.eFDOW = "2020-08-30" where employee.eID = "E002";
update employee set employee.eFDOW = "2010-11-01" where employee.eID = "E003";
update employee set employee.eFDOW = "2008-05-23" where employee.eID = "E004";
update employee set employee.eFDOW = "2012-01-05" where employee.eID = "E005";

alter table employee add bonus float;
update employee set employee.bonus =
CASE WHEN (year(now())-year(eFDOW)) < 1 THEN 200000
WHEN (year(now())-year(eFDOW)) < 3 THEN 400000
WHEN (year(now())-year(eFDOW)) < 5 THEN 600000
WHEN (year(now())-year(eFDOW)) < 10 THEN 800000
ELSE 1000000
END;
select employee.eName,employee.bonus from employee group by employee.eName;

-- 6.28 Cho biết những sản phẩm thuộc ngành hàng mỹ phẩm
insert into product_type values 
("TP06", "Cosmetic", "skin care");
insert into product values 
("P010","TP06","SKII Toner","bottle","new"),
("P011","TP06","Obagi Serum","bottle","new");
select *
from product p
where p.tID = "TP06";


-- 6.29 Cho biết những sản phẩm thuộc ngành hàng quần áo
insert into product_type values 
("TP05", "Clothes", "T-Shirt");
insert into product values 
("P008","TP05","H&M White Shirt","pieces","new"),
("P009","TP05","ZARA Sweater","pieces","new");
select *
from product p
where p.tID = "TP05";

-- 6.30 Cho biết số lượng sản phẩm loại quần áo 
select count(p.pid) as Number_Of_Product
from product p
where p.tID = "TP05";

-- 6.31 Cho biết số lượng sản phẩm loại mỹ phẩm
select count(p.pid) as Number_Of_Product
from product p
where p.tID = "TP06";

-- 6.32 Cho biết số lượng sản phẩm theo từng loại sản phẩm 
select p.tID as "Type", count(p.pid) as Number_Of_Product
from product p
group by p.tid;