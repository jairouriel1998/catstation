/*
Notas del desarrollador: 
    Este script sql está basado en el diagrama de catstation que se 
    encuentra adjunto en esta misma carpeta, el sistema fue desarrollado
    meramente con fines de aprendizaje y se desea mantener bajo los terminos
    de opensource para que cualquier individuo pueda hacer uso del mismo con
    los fines que este desee, por lo que el desarrollador está excento de 
    cualquier implementación del mismo por parte de un tercero para los 
    fines que sean.

    Se recomienda únicamente usar como ejemplo.

                                                        Atte: Jairo Medrano




Developer Notes:
    This sql script is based on the catstation diagram that is
    find attached in this same folder, the system was developed
    merely for learning purposes and you want to keep under the terms
    opensource so that any individual can use it with
    the purposes that are desired, so the developer is excellent at
    any implementation thereof by a third party for
    fines that are.

    It is recommended only use as an example.

                                                        Atte: Jairo Medrano



                      /^--^\     /^--^\     /^--^\
                      \____/     \____/     \____/
                     /      \   /      \   /      \
                    |        | |        | |        |
                     \__  __/   \__  __/   \__  __/
|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |
| | | | | | | | | | | | / / | | |\ \| | | | | |/ /| | | | | | | | | | | |
| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |
################    Made with 💙 by Jairo Medrano      ###################
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |


*/

-- Creacion de la base de datos | Create database
Create database catstation_database
On primary
( name = catstation_database_M,
  filename='C:\DATA\catstation_database.mdf',
  size = 20 MB,
  maxsize= 100 MB,
  filegrowth=20%)
log on
( name = catstation_database_L,
  filename='C:\DATA\catstation_database.ldf',
  size = 10 MB,
  maxsize= 60 MB,
  filegrowth=5)



-- Creacion de tablas independientes y de campos multivalorados
-- Create independent and multivalorated tables

-- Tabla empleados | employees table

CREATE TABLE employees(
    emp_code INT IDENTITY(1,1),
    emp_firstname VARCHAR(20) NOT NULL,
    emp_middlename VARCHAR(20),
    emp_lastname VARCHAR(20) NOT NULL,
    emp_secondlastname VARCHAR(20),
    emp_ssn VARCHAR(20),
    emp_id VARCHAR(20) NOT NULL,
    emp_birthday DATE NOT NULL,
    emp_entrydate DATE,
    emp_egressdate DATE,
    emp_contracttype VARCHAR(20),
    emp_egresscause VARCHAR(50),
    emp_salary DECIMAL(7,2),
    emp_position VARCHAR(30),
    emp_address VARCHAR(50),
    emp_gender CHAR(1),
    PRIMARY KEY(emp_code)
)

CREATE TABLE employees_phones(
    emp_code INT NOT NULL,
    emp_phone VARCHAR(12),
    PRIMARY KEY(emp_code, emp_phone),
    FOREIGN KEY(emp_code) REFERENCES employees(emp_code)
)

CREATE TABLE employees_emails(
    emp_code INT NOT NULL,
    emp_emails VARCHAR(50),
    PRIMARY KEY(emp_code, emp_emails),
    FOREIGN KEY(emp_code) REFERENCES employees(emp_code)
)


-- Tabla proveedores | providers table

CREATE TABLE providers(
    prov_code INT IDENTITY(1,1),
    prov_name VARCHAR(30),
    prov_supplycenter VARCHAR(50),
    PRIMARY KEY(prov_code)
)

-- Tablas dependientes y campos multivalorados
-- Dependent and multivalorated tables 

-- Tabla estacion de servicios | service station table

CREATE TABLE service_station(
    station_code INT IDENTITY(1,1),
    station_idname VARCHAR(30),
    station_startdate DATE,
    station_address VARCHAR(50),
    station_operationlog VARCHAR(50),
    station_city VARCHAR(20),
    station_department VARCHAR(20),
    PRIMARY KEY(station_code)
)

Select * FROM service_station

CREATE TABLE service_station_phones(
    station_code INT NOT NULL,
    station_phone VARCHAR(12),
    PRIMARY KEY(station_code, station_phone),
    FOREIGN KEY(station_code) REFERENCES service_station(station_code)
)


-- Tabla cisternas | cisterns table

CREATE TABLE cisterns(
    cis_code INT IDENTITY(1,1),
    cis_litercapacity DECIMAL(7,2),
    cis_feetdiameter DECIMAL(7,2),
    cis_currentlevel DECIMAL(7,2),
    cis_fueltype VARCHAR(12),
    cis_lastsupply DATE,
    cis_literfuelprice DECIMAL(7,2),
    assigned_station_code INT,
    PRIMARY KEY(cis_code),
    FOREIGN KEY(assigned_station_code) REFERENCES service_station(station_code)
)

-- tabla bombas | fuel dispensers table

CREATE TABLE fuel_dispensers(
    dispenser_code INT IDENTITY(1,1),
    dispenser_currentstate VARCHAR(30),
    assigned_cistern_code INT,
    PRIMARY KEY(dispenser_code),
    FOREIGN KEY(assigned_cistern_code) REFERENCES cisterns(cis_code)
)

-- tabla ventas | sales table

CREATE TABLE sales(
    sale_code INT IDENTITY(1,1),
    sale_datetime DATETIME DEFAULT GETDATE(),
    sale_liters_sold DECIMAL(7,2) NOT NULL,
    sale_amount DECIMAL(7,2),
    emp_sale_code INT,
    dispenser_sale_code INT,
    PRIMARY KEY(sale_code),
    FOREIGN KEY(emp_sale_code) REFERENCES employees(emp_code),
    FOREIGN KEY(dispenser_sale_code) REFERENCES fuel_dispensers(dispenser_code)
)


-- Tablas intermedias | intermediate tables

-- Tabla de asignacion de empleados | employees assignment table

CREATE TABLE station_assignment_employee(
    assignment_code INT IDENTITY(1,1),
    assignment_startdate DATE,
    assignment_enddate DATE,
    emp_assignment_code INT,
    station_assignment_code INT,
    workday VARCHAR(15),
    PRIMARY KEY(assignment_code),
    FOREIGN KEY(emp_assignment_code) REFERENCES employees(emp_code),
    FOREIGN KEY(station_assignment_code) REFERENCES service_station(station_code)
)


-- Tabla de abasteciemientos de cisternas | cisterns supply table 

CREATE TABLE cisterns_supply(
    supply_code INT IDENTITY(1,1),
    supply_literquantity DECIMAL(7,2),
    supply_date DATE DEFAULT GETDATE(),
    supply_amount DECIMAL(7,2),
    supply_prov_code INT,
    supply_cistern_code INT,
    PRIMARY KEY(supply_code),
    FOREIGN KEY(supply_prov_code) REFERENCES providers(prov_code),
    FOREIGN KEY(supply_cistern_code) REFERENCES cisterns(cis_code)
)


-- Tabla de usuarios | Users table

CREATE TABLE users(
    user_code INT IDENTITY(1,1),
    user_name VARCHAR(45),
    user_nickname VARCHAR(20),
    password VARCHAR(100),
    user_type VARCHAR(10),
    PRIMARY KEY(user_code)
)

alter table users add user_nickname VARCHAR(20)
insert into users(user_name, user_nickname, password, user_type) VALUES('Jairo Medrano', 'jairin', '0512', 'admin')
select * from users
-- Tabla Historial | History table

CREATE TABLE history(
    his_code INT IDENTITY(1,1),
    user_code INT,
    table_name VARCHAR(45),
    operation VARCHAR(20),
    op_description VARCHAR(100),
    PRIMARY KEY(his_code),
    FOREIGN KEY(user_code) REFERENCES users(user_code)
)


-- Procedimientos almacenados | storage procedure
-- Insercion de datos | data insertion


-- insertar empleado | insert employee 
CREATE PROCEDURE insertEmployee
    @emp_firstname VARCHAR(20),
    @emp_middlename VARCHAR(20),
    @emp_lastname VARCHAR(20),
    @emp_secondlastname VARCHAR(20),
    @emp_ssn VARCHAR(20),
    @emp_id VARCHAR(20),
    @emp_birthday DATE,
    @emp_entrydate DATE,
    @emp_egressdate DATE,
    @emp_contracttype VARCHAR(20),
    @emp_egresscause VARCHAR(50),
    @emp_salary MONEY,
    @emp_position VARCHAR(30),
    @emp_address VARCHAR(50),
    @emp_gender CHAR(1)
AS INSERT INTO employees(
    emp_firstname,
    emp_middlename,
    emp_lastname,
    emp_secondlastname,
    emp_ssn,
    emp_id,
    emp_birthday,
    emp_entrydate,
    emp_egressdate,
    emp_contracttype,
    emp_egresscause,
    emp_salary,
    emp_position,
    emp_address,
    emp_gender
) VALUES (
    @emp_firstname,
    @emp_middlename,
    @emp_lastname,
    @emp_secondlastname,
    @emp_ssn,
    @emp_id,
    @emp_birthday,
    @emp_entrydate,
    @emp_egressdate,
    @emp_contracttype,
    @emp_egresscause,
    @emp_salary,
    @emp_position,
    @emp_address,
    @emp_gender
)

-- insertar usuario | insert user
-- (don't finish)
CREATE PROCEDURE insertUsers(
    @user_name VARCHAR(45),
    @password VARCHAR(100),
    @user_type VARCHAR(10),
)

-- insertar estacion de servicio | insert service station_address
CREATE PROCEDURE insertServiceStation
    @station_idname VARCHAR(30),
    @station_startdate DATE,
    @station_address VARCHAR(50),
    @station_operationlog VARCHAR(50),
    @station_city VARCHAR(20),
    @station_department VARCHAR(20)
AS INSERT INTO service_station(
    station_idname,    
    station_startdate,
    station_address,
    station_operationlog,
    station_city,
    station_department
)VALUES(
    @station_idname,
    @station_startdate,
    @station_address,
    @station_operationlog,
    @station_city,
    @station_department
)

-- cisternas | cisterns
CREATE PROCEDURE insertCistern
    @cis_litercapacity DECIMAL(7,2),
    @cis_feetdiameter DECIMAL(7,2),
    @cis_currentlevel DECIMAL(7,2),
    @cis_fueltype VARCHAR(12),
    @cis_lastsupply DATE,
    @cis_literfuelprice DECIMAL(7,2),
    @assigned_station_code INT
AS INSERT INTO cisterns(
    cis_litercapacity,
    cis_feetdiameter,
    cis_currentlevel,
    cis_fueltype,
    cis_lastsupply,
    cis_literfuelprice,
    assigned_station_code
)VALUES(
    @cis_litercapacity,
    @cis_feetdiameter,
    @cis_currentlevel,
    @cis_fueltype,
    @cis_lastsupply,
    @cis_literfuelprice,
    @assigned_station_code
)


-- dispensadores de combustible | fuel dispenser
CREATE PROCEDURE insertDispenser
    @dispenser_currentstate VARCHAR(30),
    @assigned_cistern_code INT
AS INSERT INTO fuel_dispensers(
    dispenser_currentstate,
    assigned_cistern_code
)VALUES(
    @dispenser_currentstate,
    @assigned_cistern_code
)


CREATE PROCEDURE insertSale


-- incertando datos | Data insertion

-- estacion de servicio | service station_address
EXEC insertServiceStation 'Canflores', '05-18-2018', 'Col: el hato de en medio', 'T2526', 'Tegucigalpa', 'Francisco Morazán'
EXEC insertServiceStation 'Andreos', '05-10-2017', 'El araujo', 'T2526', 'Tegucigalpa', 'Francisco Morazán'
EXEC insertServiceStation 'Canflores', '05-11-2001', 'Madre Concepcion ', 'T2526', 'Tegucigalpa', 'Francisco Morazán'


-- empleados | employees 
EXEC insertEmployee 'Julio','Cesar','Canales','Rios','T521', '0802199402616', '05-28-1994', '02-02-2017', '05-05-2018', 'Temporal', 'Fin de contrato', 12000, 'Admin. de Proyectos', 'Col. San Vicente del Ocotal', 'M' 


-- cisternas | cisterns
EXEC insertCistern '11000', '500', '2000', 'DIESEL', '02-22-19', '28.50', '1'


--dispensador | fuel dispenser
EXEC insertDispenser 'Funcional', '1'

select * from sales

-- SELECT CONVERT(VARCHAR(10), GETDATE(), 108)

-- vistas | views
--vista de ventas | sales views
CREATE VIEW viewSales AS
SELECT sale_code, sale_datetime, sale_liters_sold, dispenser_sale_code, CONCAT(emp_firstname, ' ', emp_lastname) AS emp_name, cis_fueltype, cis_literfuelprice, station_idname, CONCAT(station_city,' ',station_department, ' ',station_address ) AS station_address, (sale_liters_sold * cis_literfuelprice) AS sale_amount FROM sales S INNER JOIN employees E on S.emp_sale_code = E.emp_code 
INNER JOIN fuel_dispensers D on S.dispenser_sale_code = D.dispenser_code INNER JOIN
cisterns C on C.cis_code = D.assigned_cistern_code INNER JOIN service_station SE
on SE.station_code = C.assigned_station_code

select * from viewSales

select * from service_station
DROP VIEW viewServiceStations
CREATE VIEW viewServiceStations AS
select station_code, station_idname, CONVERT(varchar, station_startdate, 110) AS station_initdate, station_address, station_operationlog, station_city, station_department FROM service_station