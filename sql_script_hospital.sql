-- Create Database

create database hospital;
use hospital;

-- CREATING DEPARTMENT TABLES 

create table departments (
	departmentID int auto_increment primary key,
    departmentName varchar(50) not null
);

-- CREATING DOCTOR TABLE

create table doctor
(
	doctorID int auto_increment primary key,
    doctorName varchar(50) not null ,
    Specialization varchar(50) ,
    Role varchar(50),
    departmentID int,
    foreign key (departmentID) references departments(departmentID)
);

-- CREATING PATIENT TABLE

create table patients (
	patientid int auto_increment primary key,
    patientName varchar(50),
    DateOfBirth date,
    gender varchar(1),
    phone varchar(13),
    CONSTRAINT chk_gender CHECK (gender IN ('m', 'f', 'o'))
);

-- CREATING APPOINTMENTS TABLE

create table Appointments (
	AppointmentID int auto_increment primary key,
	patientid int,
    doctorid int ,
    AppointmentTime datetime,
    AppointmentStatus varchar(30),
    check (AppointmentStatus in ('Scheduled','Cancelled','Completed')),
    foreign key (patientid) references patients(patientid),
    foreign key (doctorid) references doctor(doctorID)
);

-- CREATING PRESCRIPTIONS TABLE

create table prescriptions (
	PrescriptionID int auto_increment primary key,
    AppointmentID int,
    Medication varchar(100),
    Dosage varchar(100),
    foreign key (AppointmentID) references Appointments(AppointmentID)
);

-- CREATING BILLING TABLE

create table Bills (
	BillID int auto_increment primary key,
    AppointmentID int,
    Amount decimal(10,2),
    Paid tinyint(1),
    BillDate datetime default current_timestamp,
    foreign key (AppointmentID) references Appointments(AppointmentID)
);

-- CREATING LABREPORT TABLE 

create table LabReports (
	Reportid int auto_increment primary key,
    AppointmentID int,
    ReportData varchar(100),
    CreatedAt datetime default current_timestamp,
    foreign key (AppointmentID) references Appointments(AppointmentID)
);
    
    

-- INSERTIONING DATABASE
select * FROM hospital_data;
select `Departments.DepartmentID` from hospital_data;  
select concat('select',group_concat(concat('`',COLUMN_NAME,'`')),'from hospital_data') 
from INFORMATION_SCHEMA.COLUMNS 
where table_schema ='hospital'
and table_name = 'hospital_data'
and column_name like 'labreports.%' ;   --

-- departments

insert into departments(departmentID,departmentName)
select`Departments.DepartmentID`,`Departments.Name`
from hospital_data
where `Departments.DepartmentID`<>'' ;

select*from departments;

-- Doctor

insert into Doctor(departmentID,doctorID,doctorName,Role,Specialization)
select`Doctors.DepartmentID`,`Doctors.DoctorID`,`Doctors.Name`,`Doctors.Role`,`Doctors.Specialization` 
from hospital_data
where `Doctors.DepartmentID`<>'' ;

select*from doctor;

-- Patients
insert into patients(patientid,patientName, DateOfBirth , gender,  phone)
select 
	`Patients.PatientID`,
    `Patients.Name`,
	str_to_date(`Patients.DateOfBirth`,'%d-%m-%Y'),
    `Patients.Gender`,`Patients.Phone`
from hospital_data
where `Patients.PatientID` <> '';

select*from patients;

-- appointments 

insert into appointments(AppointmentID,AppointmentTime,doctorid,patientid,AppointmentStatus)
select `Appointments.AppointmentID`,
	str_to_date(`Appointments.AppointmentTime`,'%d-%m-%Y %h:%i'),
    `Appointments.DoctorID`,
    `Appointments.PatientID`,
    `Appointments.Status`
from hospital_data
where `Appointments.AppointmentID` <>'';

select * from appointments;

 -- prescriptions
 
insert into  prescriptions(AppointmentID, PrescriptionID, Dosage, Medication)
select `Prescriptions.AppointmentID`,
	`Prescriptions.PrescriptionID`,
	`Prescriptions.Dosage`,
    `Prescriptions.Medication`
from hospital_data
where `Prescriptions.AppointmentID` <> '';

 select * from prescriptions;
 
 -- bills
 
insert into bills(BillID,Amount, AppointmentID ,BillDate ,Paid)
select `Bills.BillID`,`Bills.Amount`,`Bills.AppointmentID`,
str_to_date(`Bills.BillDate`,'%Y-%m-%d %H:%i:%s'),`Bills.Paid` 
from hospital_data
where `Bills.AppointmentID` <> '';

select * from bills;

-- labreports 

insert into labreports(AppointmentID , CreatedAt, ReportData , Reportid)
select `LabReports.AppointmentID`,`LabReports.CreatedAt`,`LabReports.ReportData`,`LabReports.ReportID`
from hospital_data
where  `LabReports.AppointmentID` <> '' ;



-- check_new_appointment are valid or not 

DELIMITER $$
create trigger check_new_appointment 
before insert on appointments 
for each row
BEGIN
	if New.AppointmentTime < NOW() 
		then signal sqlstate '19001'
		set message_text = "error ";
	end if;
    
    if exists (
        select * from appointments  
        where doctorid=NEW.doctorid
		and appointmenttime=NEW.appointmenttime
		and  AppointmentStatus in ('Scheduled')
	)
	then signal sqlstate '19001'
    set message_text= 'Error: Doctor Already has an appointment  at this time';
    end if ;
end $$
DELIMITER ;

insert into appointments(AppointmentID,AppointmentTime,doctorid,patientid,AppointmentStatus)
values(12230,'2024-02-29 06:39:00',1,2,'complet');

insert into appointments(AppointmentID,AppointmentTime,doctorid,patientid,AppointmentStatus)
values(12230,'2026-11-27 06:39:00',1,2,'Scheduled');

-- CREDENTIALS DATA ACCESS SYSTEM 

DELIMITER $$
CREATE PROCEDURE 
view_doc_data(
			in input_username varchar(100) ,
            in input_password varchar(100)
            ) 
begin
	declare doc_id int;
    declare doc_role varchar(100);
    declare doc_dept int;
    
-- CHECK CREDENTIALS OF THE DOCTOR

    select doctor_id into doc_id 
    from doctor_credentials 
    where user_name = input_username 
    and password = input_password;
    
    -- GET ROLE AND DEPARTMENT  FROM DOCTORS TABLE
    
    select Role,departmentID 
    into doc_role,doc_dept 
    from doctor 
    where doctorid = doc_id;
    
	-- SHOW APPROPRIATE PATIENTS DATA.
    IF doc_role='senior' 
    then  
    select d.doctorid,p.patientid,p.patientName,
		p.gender, a.AppointmentTime,prc.Medication,lr.ReportData 
	from appointments as a 
    inner join patients as p on a.patientid=p.patientid
    join doctor as d on d.doctorID=a.doctorid
    left join prescriptions as prc on prc.AppointmentID=a.AppointmentID
    left join labreports as lr on lr.AppointmentID=a.AppointmentID
    where d.departmentID=doc_dept ;
    
    ELSE
    
	select p.patientid,p.patientName,p.gender,
		a.AppointmentTime,prc.Medication,lr.ReportData
    from appointments as a 
	inner join patients as p on a.patientid=p.patientid
	left join prescriptions as prc on prc.AppointmentID=a.AppointmentID
    left join labreports as lr on lr.AppointmentID=a.AppointmentID
    where A.doctorid=doc_id ;
    
    END IF;
 
END $$
DELIMITER ;

-- DROP PROCEDURE view_doc_data;
call view_doc_data('doctor1', 'W3jzIANG');
call view_doc_data('doctor4', 'ic0pFSn0');

drop procedure  VIEW_DOCTOR_DAT ;
 
 
 
-- STORE PROSECUER MONTHLY REVANUE



DELIMITER $$
Create procedure monthly_revenue(IN in_year int,IN in_month int)
BEGIN
	select De.departmentName AS department,
    SUM(b.Amount) as total_revenue
    from bills as b
    inner join appointments as a on b.AppointmentID=a.AppointmentID
    inner join doctor as d on d.doctorID=a.doctorid
    inner join departments as de on de.departmentID=d.departmentID
    where year(b.BillDate)=in_year and month(b.BillDate) = in_month

    group by de.departmentName ;
    
end $$
DELIMITER ;


call  monthly_revenue(2025,6);

 
 
 
 
 
 