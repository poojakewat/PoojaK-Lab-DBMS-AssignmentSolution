1: Create tables

Create Database if not exists `order-directory` ;
use `order-directory`;

create table if not exists `supplier`(
`SUPP_ID` int primary key,
`SUPP_NAME` varchar(50) ,
`SUPP_CITY` varchar(50),
`SUPP_PHONE` varchar(10)
);

CREATE TABLE IF NOT EXISTS `customer` (
`CUS_ID` INT NOT NULL,
`CUS_NAME` VARCHAR(20) NULL DEFAULT NULL,
`CUS_PHONE` VARCHAR(10),
`CUS_CITY` varchar(30) ,
`CUS_GENDER` CHAR,
PRIMARY KEY (`CUS_ID`));

CREATE TABLE IF NOT EXISTS `category` (
`CAT_ID` INT NOT NULL,
`CAT_NAME` VARCHAR(20) NULL DEFAULT NULL,
PRIMARY KEY (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product` (
`PRO_ID` INT NOT NULL,
`PRO_NAME` VARCHAR(20) NULL DEFAULT NULL,
`PRO_DESC` VARCHAR(60) NULL DEFAULT NULL,
`CAT_ID` INT NOT NULL,
PRIMARY KEY (`PRO_ID`),
FOREIGN KEY (`CAT_ID`) REFERENCES category (`CAT_ID`)
);

CREATE TABLE IF NOT EXISTS `product_details` (
`PROD_ID` INT NOT NULL,
`PRO_ID` INT NOT NULL,
`SUPP_ID` INT NOT NULL,
`PROD_PRICE` INT NOT NULL,
PRIMARY KEY (`PROD_ID`),
FOREIGN KEY (`PRO_ID`) REFERENCES product (`PRO_ID`),
FOREIGN KEY (`SUPP_ID`) REFERENCES supplier(`SUPP_ID`)
);

CREATE TABLE IF NOT EXISTS `order` (
`ORD_ID` INT NOT NULL,
`ORD_AMOUNT` INT NOT NULL,
`ORD_DATE` DATE,
`CUS_ID` INT NOT NULL,
`PROD_ID` INT NOT NULL,
PRIMARY KEY (`ORD_ID`),
FOREIGN KEY (`CUS_ID`) REFERENCES customer(`CUS_ID`),
FOREIGN KEY (`PROD_ID`) REFERENCES product_details(`PROD_ID`)
);


CREATE TABLE IF NOT EXISTS `rating` (
`RAT_ID` INT NOT NULL,
`CUS_ID` INT NOT NULL,
`SUPP_ID` INT NOT NULL,
`RAT_RATSTARS` INT NOT NULL,
PRIMARY KEY (`RAT_ID`),
FOREIGN KEY (`SUPP_ID`) REFERENCES supplier (`SUPP_ID`),
FOREIGN KEY (`CUS_ID`) REFERENCES customer(`CUS_ID`)
);

==================================================================================================================

2: Insert the following data in the table created above

insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');


INSERT INTO `CUSTOMER` VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO `CUSTOMER` VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO `CUSTOMER` VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO `CUSTOMER` VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO `CUSTOMER` VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO `CATEGORY` VALUES( 1,"BOOKS");
INSERT INTO `CATEGORY` VALUES(2,"GAMES");
INSERT INTO `CATEGORY` VALUES(3,"GROCERIES");
INSERT INTO `CATEGORY` VALUES (4,"ELECTRONICS");
INSERT INTO `CATEGORY` VALUES(5,"CLOTHES");
 
  
INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);
  
  
INSERT INTO PRODUCT_DETAILS VALUES(1,1,2,1500);
INSERT INTO PRODUCT_DETAILS VALUES(2,3,5,30000);
INSERT INTO PRODUCT_DETAILS VALUES(3,5,1,3000);
INSERT INTO PRODUCT_DETAILS VALUES(4,2,3,2500);
INSERT INTO PRODUCT_DETAILS VALUES(5,4,1,1000);

INSERT INTO `ORDER` VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO `ORDER` VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO `ORDER` VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO `ORDER` VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO `ORDER` VALUES(30,3500,"2021-08-16",4,3);
    
INSERT INTO `RATING` VALUES(1,2,2,4);
INSERT INTO `RATING` VALUES(2,3,4,3);
INSERT INTO `RATING` VALUES(3,5,1,5);
INSERT INTO `RATING` VALUES(4,1,3,2);
INSERT INTO `RATING` VALUES(5,4,5,4);

==================================================================================================================

3 : Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.

SELECT c.cus_gender,COUNT(c.cus_id) AS COUNT FROM customer AS c INNER JOIN `order` AS o ON c.cus_id=o.cus_id WHERE o.ord_amount>=3000 GROUP BY c.cus_gender ;

4 : Display all the orders along with the product name ordered by a customer having Customer_Id=2.

SELECT o.*,pr.pro_id,pr.pro_nameFROM product pr INNER JOIN 
product_details p ON pr.pro_id=p.pro_id
INNER JOIN `order` o ON p.prod_id=o.prod_id WHERE o.cus_id=2;

5 : Display the Supplier details who can supply more than one product.

SELECT s.* FROM supplier AS s INNER JOIN product_details AS pd ON s.supp_id = pd.supp_id GROUP BY pd.supp_id HAVING COUNT(pd.supp_id) > 1;

6 : Find the category of the product whose order amount is minimum.

SELECT c.* FROM category c INNER JOIN product p 
ON c.cat_id=p.cat_id INNER JOIN product_details pr 
ON p.pro_id = pr.pro_id INNER JOIN `order` o ON pr.prod_id = o.prod_id 
WHERE o.ord_amount = (SELECT MIN(ord_amount) FROM `order`);

7 : Display the Id and Name of the Product ordered after “2021-10-05”.

select j.pro_name,j.pro_id from `order` o inner join product_details p on p.prod_id = o.prod_id inner join product j on p.pro_id=j.pro_id where o.ord_date > '2021-10-5';
            
8 : Print the top 3 supplier name and id and their rating on the basis of their rating along
with the customer name who has given the rating.

SELECT supplier.supp_id, supplier.supp_name, customer.cus_name, rating.rat_ratstars FROM supplier INNER JOIN rating ON supplier.supp_id=rating.supp_id INNER JOIN customer ON rating.cus_id = customer.cus_id ORDER BY rating.rat_ratstars DESC LIMIT 3;

9 : Display customer name and gender whose names start or end with character 'A'.

select c.CUS_NAME,c.CUS_GENDER from customer C where c.CUS_NAME like 'A%' or c.CUS_NAME like '%A';

10 : Display the total order amount of the male customers.

select sum(o.ORD_AMOUNT) as TOTAL_AMOUNT from `order` o inner join customer c on o.CUS_ID = c.CUS_ID and c.CUS_GENDER='M';

11 : Display all the Customers left outer join with the orders.

select * from customer c left outer join `order` o on o.CUS_ID = c.CUS_ID;

12 :  Create a stored procedure to display the Rating for a Supplier if any along with the
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average
Supplier” else “Supplier should not be considered”

call supplier_rating();

CREATE DEFINER=`root`@`localhost` PROCEDURE `supplier_rating`()
BEGIN
select s.supp_id,s.supp_name,r.rat_ratstars, 
case
when r.rat_ratstars > 4 then 'Genuine Supplier'
when r.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end
as verdict from supplier s inner join rating r on s.supp_id = r.supp_id;
END

========================================================================================================