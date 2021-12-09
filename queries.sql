SELECT Dishname AS DISHES_IN_R1
FROM MENU, RESTAURANT
WHERE Mrid = Rid AND Rid = 1;
--2
SELECT Ocid AS CUSTOMER_ID, COUNT(*) AS NUMBER_OF_ORDERS 
FROM ORDERS
GROUP BY Ocid;
--3
/*ALTER TABLE APPLIES_ON DROP CONSTRAINT applies_on_acode_fkey; 
ALTER TABLE APPLIES_ON ADD CONSTRAINT applies_on_acode_fkey FOREIGN key (Acode) REFERENCES COUPON(Code) ON DELETE SET NULL;*/
SELECT * 
FROM COUPON
WHERE NOW() > Exp_date;
--4
SELECT Rid, Rname
FROM RESTAURANT GROUP BY Rating;
--5
SELECT Oid_, Did, Dfname, Dlname
FROM DELIVERY_PERSON, ORDER_
WHERE Did = Odid;

--c1
ALTER TABLE DELIVERY_PERSON ADD COLUMN REMARKS VARCHAR(20);
UPDATE DELIVERY_PERSON SET REMARKS = 
CASE
WHEN  Drating > 4 AND Drating <= 5 THEN 'EXPERT'
WHEN  Drating > 3 AND Drating <= 4 THEN 'PROFICIENT'
WHEN  Drating > 2 AND Drating <= 3 THEN 'COMPETENT'
WHEN  Drating > 1 AND Drating <= 2 THEN 'SATISFACTORY'
WHEN  Drating >= 0 AND Drating <= 1 THEN 'NOVICE'
END; 

--C2
SELECT fname AS customer_name, Cphone as customer_phone, CAddress as customer_address, Rname as restaurant_name, Rphone as restaurant_phone, Raddress as restaurant_address
FROM (RESTAURANT JOIN (ORDER_ JOIN (CUSTOMER JOIN MAKES ON Cid = Mcid) ON Oid_ = Moid) ON Rid = Orid)
WHERE Odid = 1;
--c3
SELECT Cid, Fname
FROM CUSTOMER 
EXCEPT (SELECT Cid, FNAME FROM CUSTOMER, ORDERS WHERE Cid = Ocid);
--C4
SELECT Oid_, SUM(Iprice) as TOTAL_PRICE
FROM ORDER_ JOIN ITEMS ON Oid_ = Ioid 
GROUP BY Oid_;
--C5

/*INSERT INTO CITEMS(Ciname, Ciprice) 
SELECT Dishname, Mprice
FROM RESTAURANT JOIN MENU ON RID = MRID
WHERE Rid = 1 AND Dishname = 'Veg Extravaganza', ; */
CREATE OR REPLACE VIEW ORDER_TOTAL 
AS SELECT Oid_, SUM(Iprice) as TOTAL_PRICE
FROM ORDER_ JOIN ITEMS ON Oid_ = Ioid 
GROUP BY Oid_;
WITH TEMP(AVERAGE) AS
(SELECT AVG(TOTAL_PRICE) FROM ORDER_TOTAL) 
    SELECT Oid_, TOTAL_PRICE
    FROM ORDER_TOTAL, TEMP
    WHERE ORDER_TOTAL.TOTAL_PRICE > TEMP.AVERAGE;



    CREATE USER ADMIN WITH PASSWORD 'ADMIN' CREATEDB;
--delivery person
CREATE OR REPLACE VIEW DELIVERY1 AS
SELECT fname AS customer_name, Cphone as customer_phone, CAddress as customer_address, Rname as restaurant_name, Rphone as restaurant_phone, Raddress as restaurant_address
FROM (RESTAURANT JOIN (ORDER_ JOIN (CUSTOMER JOIN MAKES ON Cid = Mcid) ON Oid_ = Moid) ON Rid = Orid)
WHERE Odid = 1;
CREATE OR REPLACE VIEW DELIVERY2 AS
SELECT fname AS customer_name, Cphone as customer_phone, CAddress as customer_address, Rname as restaurant_name, Rphone as restaurant_phone, Raddress as restaurant_address
FROM (RESTAURANT JOIN (ORDER_ JOIN (CUSTOMER JOIN MAKES ON Cid = Mcid) ON Oid_ = Moid) ON Rid = Orid)
WHERE Odid = 2;
--customer
CREATE or REPLACE VIEW customer1 as 
select fname, lname, cphone, CAddress, Email
from customer
where cid = 1;
--RESTAURANT
CREATE or REPLACE VIEW RESTAURANT1 as 
select Rname, Rphone, Cuisine, Raddress
from RESTAURANT
where Rid = 1;

