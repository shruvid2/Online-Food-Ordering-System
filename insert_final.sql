\c h8

Alter Table RESTAURANT drop constraint restaurant_main_rid_fkey;
--add col in citems
ALTER TABLE CITEMS ADD COLUMN ciqty int default 1;
ALTER TABLE CART ADD COLUMN total_price float default 0;
--triggers
create function update_price() RETURNS trigger as $$ BEGIN
UPDATE CART SET total_price = total_price + NEW.Ciprice * NEW.ciqty WHERE Cart_id = NEW.Ccart_id;
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
CREATE FUNCTION reduce_price() RETURNS trigger as $$
BEGIN
UPDATE CART SET total_price = total_price - OLD.Ciprice*OLD.ciqty WHERE Cart_id = OLD.Ccart_id; 
RETURN OLD;
END;
$$
LANGUAGE 'plpgsql';
-- Creating triggers
CREATE TRIGGER insert_summary AFTER INSERT ON citems FOR EACH
ROW
EXECUTE PROCEDURE update_price();
CREATE TRIGGER delete_summary BEFORE DELETE ON citems FOR
EACH ROW
EXECUTE PROCEDURE reduce_price();
---MAIN TABLE INSERTIONS
--coupon
INSERT INTO COUPON VALUES('ugsdkabue',150,'2021-12-01 23:10:00',700);
INSERT INTO COUPON VALUES('uhdfiugfa',100,'2021-12-01 23:10:00',500);
INSERT INTO COUPON VALUES('ugsdkfhu9',50,'2021-12-01 23:10:00',300);
INSERT INTO COUPON VALUES('ugsdrhyiq',120,'2021-12-01 23:10:00',700);
INSERT INTO COUPON VALUES('oeyrkjnai',160,'2022-02-01 23:10:00',600);
INSERT INTO COUPON VALUES('uehuhroie',99,'2022-02-01 23:10:00',1000);
INSERT INTO COUPON VALUES('ieioiqdiw',75,'2022-12-01 23:10:00',300);
INSERT INTO COUPON VALUES('qwiehndwu',25,'2021-12-01 23:10:00',600);
INSERT INTO COUPON VALUES('nxcoidhir',60,'2021-11-01 23:10:00',500);
INSERT INTO COUPON VALUES('uicoidhir',200,'2021-10-29 23:10:00',800);

--transaction
INSERT INTO TRANSACTION_ VALUES(1,2000,'COD');
INSERT INTO TRANSACTION_ VALUES(2,2500,'UPI');
INSERT INTO TRANSACTION_ VALUES(3,3000,'UPI');
INSERT INTO TRANSACTION_ VALUES(4,4000,'CARD');
INSERT INTO TRANSACTION_ VALUES(5,1000,'UPI');
INSERT INTO TRANSACTION_ VALUES(6,700,'CARD');
INSERT INTO TRANSACTION_ VALUES(7,600,'COD');
INSERT INTO TRANSACTION_ VALUES(8,1600,'UPI');
INSERT INTO TRANSACTION_ VALUES(9,200,'CARD');
INSERT INTO TRANSACTION_ VALUES(10,1600,'COD');

--delivery person
INSERT INTO DELIVERY_PERSON VALUES(0,'Dummy','Dummy','5','true',100.20,4.2,'Dummy');
INSERT INTO DELIVERY_PERSON VALUES(1,'Suresh','Rai','6789564738','true',100.20,4.2,'Rajajinagar, Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(2,'Smriti','Tilak','9087653784','true',101.01,4.3,'Shivajinagar,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(3,'Sara','Pai','9090653784','true',099.03,4.5,'Shivajinagar,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(4,'Mukesh','Singh','9997653784','true',097.09,4.6,'M G Road,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(5,'Abhinav','Y','9087908784','true',102.04,3.3,'jayanagar,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(6,'Geetha','Anand','9087965745','true',097.12,4.8,'J P Nagar,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(7,'Adhitya','Suresh','9000965745','true',098.10,4.0,'Chruch Street,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(8,'Rohan','K','9087992345','true',096.11,3.9,'J P Nagar,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(9,'Keshav','Kumar','9087235745','true',097.12,4.5,'Netkallappa Circle,Bangalore');
INSERT INTO DELIVERY_PERSON VALUES(10,'Ankush','S J','9087000745','true',099.04,4.6,'Whitefield,Bangalore');

--customer
INSERT INTO CUSTOMER VALUES(1,'Manognya','Singuru','1-467/56(4),2nd street,M G Road,Bangalore','9835678234','manogyna@gmail.com');
INSERT INTO CUSTOMER VALUES(2,'Smriti','Tilak','123-38/45(13),5th cross,Basavangudi,Bangalore','9871237456','smruthi@gmail.com');
INSERT INTO CUSTOMER VALUES(3,'Shruvi','D','1-105/18(15),1st main ,2nd cross,Maroli,Bangalore','6366298767','shruvi@gmail.com');
INSERT INTO CUSTOMER VALUES(4,'Ross','Geller','2-908/23(45),4th cross,Malleshwaram,Bangalore','9807654321','ross@gmail.com');
INSERT INTO CUSTOMER VALUES(5,'Monica','G','8-23/12(7),9th cross,H S R Layput,Bangalore','9807659321','monica@gmail.com');
INSERT INTO CUSTOMER VALUES(6,'Rachel','Green','21-34/3(5),7th cross,Jayanagar,Bangalore','9437654321','rachel@gmail.com');
INSERT INTO CUSTOMER VALUES(7,'Joey','Tribiyani','16-8/19(4),5th cross,J P Nagar,Bangalore','9807654987','joey@gmail.com');
INSERT INTO CUSTOMER VALUES(8,'Chandler','Bing','9-8/3(16),8th cross,Whitefield,Bangalore','9065654321','chandler@gmail.com');
INSERT INTO CUSTOMER VALUES(9,'Ramesh','shetty','1-906/25(15),1st cross,Nelamangala,Bangalore','9873456723','ramesh@gmail.com');
INSERT INTO CUSTOMER VALUES(10,'arjun','Singh','12-89/5(1),5th cross,R R Nagar,Bangalore','9899956723','arjun@gmail.com');

--RESTAURANT
INSERT INTO RESTAURANT VALUES(1, 'Dominos', '9393939393',
'Ground Floor, 183, Old Outer Ring Rd, opp. Bangalore Development Authority Complex, 3rd Block, BDA Layout, 2nd Block, Naagarabhaavi, Bengaluru, Karnataka 560072',
'Italian', 4.0, 1);
INSERT INTO RESTAURANT VALUES(2, 'Dominos', '9393939392',
'Kemapura Dakale (Agrahara), XXI division, Bangalore city corporation, Nagarabhavi Main Rd, Govindaraja Nagar Ward, Prashant Nagar, Vijayanagar, Bengaluru, Karnataka 560079',
'Italian', 3.9, 1);
INSERT INTO RESTAURANT VALUES(3, 'Meghana Foods', '9393456921',
'52, 1st Floor, 33rd Cross Rd, near Cafe Coffee Day, 4th Block, Jayanagar, Bengaluru, Karnataka 560011',
'Andhra style', 4.3, 3);
INSERT INTO RESTAURANT VALUES(4, 'Meghana Foods', '9393456969',
'1st Cross Road, 124, 1st A Cross Rd, near Jyoti Nivas College, KHB Colony, 5th Block, Koramangala, Bengaluru, Karnataka 560095',
'Andhra style', 4.1, 3);
INSERT INTO RESTAURANT VALUES(5, 'Mainland China', '9343529202',
'14, Church St, Shanthala Nagar, Ashok Nagar, Bengaluru, Karnataka 560001',
'Chinese', 4.1, 5);
INSERT INTO RESTAURANT VALUES(6, 'Mainland China', '9343529201',
'4032, 100 Feet Road, next to Domlur Flyover, HAL 2nd Stage, Indiranagar, Bengaluru, Karnataka 560038',
'Chinese', 3.5, 5);
INSERT INTO RESTAURANT VALUES(7, 'The Punjabi Rasoi', '9343529320',
'311, 100 Feet Rd, Indira Nagar 1st Stage, Stage 1, Indiranagar, Bengaluru, Karnataka 560038',
'Punjabi', 4.1, 7);
INSERT INTO RESTAURANT VALUES(8, 'The Punjabi Rasoi', '9343525463',
'#26, KHB Main Road, Kaveri Nagar, Opp.IIBS Collage, R T Nagar, Bengaluru, Karnataka 560032',
'Punjabi', 3.5, 7);
INSERT INTO RESTAURANT VALUES(9, 'The Punjabi Rasoi', '9343529561',
'3rd floor Food court Orion Mall, Dr Rajkumar Rd, Bengaluru, Karnataka 560010',
'Chinese', 3.2, 7);

INSERT INTO MENU VALUES('Margherita Pizza', 1, 99, 'Main Course', 'Classic delight with 100% real mozzarella cheese');
INSERT INTO MENU VALUES('Veg Extravaganza', 1, 249, 'Main Course', 'Black olives, capsicum, onion, grilled mushroom, corn, tomato, jalapeno & extra cheese');
INSERT INTO MENU VALUES('Cheese n Corn', 1, 169, 'Main Course', 'A delectable combination of sweet & juicy golden corn');
INSERT INTO MENU VALUES('Potato Cheese Shots', 1, 70, 'Appetizer', 'Crisp and golden outside, flavorful burst of cheese, potato & spice inside');
INSERT INTO MENU VALUES('Veg Parcel', 1, 39, 'Appetizer', 'Snacky bites! Pizza rolls with paneer & creamy harissa sauce');
INSERT INTO MENU VALUES('Red Velvet Lava Cake', 1, 129, 'Dessert', 'A truly indulgent experience with sweet and rich red velvet cake');
INSERT INTO MENU VALUES('Brownie Fantasy', 1, 59, 'Dessert', 'Sweet Temptation! Hot Chocolate Brownie drizzled with chocolate fudge sauce');
INSERT INTO MENU VALUES('Pepsi(500 mL)', 1, 60, 'Beverages', 'Sparkling and Refreshing Beverage');

INSERT INTO MENU VALUES('Margherita Pizza', 2, 99, 'Main Course', 'Classic delight with 100% real mozzarella cheese');
INSERT INTO MENU VALUES('Veg Extravaganza', 2, 249, 'Main Course', 'Black olives, capsicum, onion, grilled mushroom, corn, tomato, jalapeno & extra cheese');
INSERT INTO MENU VALUES('Cheese n Corn', 2, 169, 'Main Course', 'A delectable combination of sweet & juicy golden corn');
INSERT INTO MENU VALUES('Potato Cheese Shots', 2, 70, 'Appetizer', 'Crisp and golden outside, flavorful burst of cheese, potato & spice inside');
INSERT INTO MENU VALUES('Veg Parcel', 2, 39, 'Appetizer', 'Snacky bites! Pizza rolls with paneer & creamy harissa sauce');
INSERT INTO MENU VALUES('Red Velvet Lava Cake', 2, 129, 'Dessert', 'A truly indulgent experience with sweet and rich red velvet cake');
INSERT INTO MENU VALUES('Brownie Fantasy', 2, 59, 'Dessert', 'Sweet Temptation! Hot Chocolate Brownie drizzled with chocolate fudge sauce');
INSERT INTO MENU VALUES('Pepsi(500 mL)', 2, 60, 'Beverages', 'Sparkling and Refreshing Beverage');

INSERT INTO MENU VALUES('Chilly Gobi', 3, 245, 'Appetizer', 'Pure vegetarian crunchy and spicy Gobi');
INSERT INTO MENU VALUES('Gobi 65', 3, 245, 'Appetizer', 'Crisp and delicious Gobi 65');
INSERT INTO MENU VALUES('Aloo Dum Biriyani', 3, 245, 'Main Course', 'Slow cooked dum biriyani made with basmati rice!');
INSERT INTO MENU VALUES('Paneer Biriyani', 3, 290, 'Main Course', 'Paneer biriyani made with basmati rice!');
INSERT INTO MENU VALUES('Mushroom Biriyani', 3, 290, 'Main Course', 'Mushroom, onion, tomato, spices and basmati rice');
INSERT INTO MENU VALUES('Jeera Rice', 3, 190, 'Main Course', 'Refreshing cumin rice');
INSERT INTO MENU VALUES('Vanilla Icecream', 3, 40, 'Dessert', 'Creamy vanilla ice cream');
INSERT INTO MENU VALUES('Coca-Cola', 3, 40, 'Beverages', 'Sparkling and Refreshing Beverage');

INSERT INTO MENU VALUES('Chilly Gobi', 4, 245, 'Appetizer', 'Pure vegetarian crunchy and spicy Gobi');
INSERT INTO MENU VALUES('Gobi 65', 4, 245, 'Appetizer', 'Crisp and delicious Gobi 65');
INSERT INTO MENU VALUES('Aloo Dum Biriyani', 4, 245, 'Main Course', 'Slow cooked dum biriyani made with basmati rice!');
INSERT INTO MENU VALUES('Paneer Biriyani', 4, 290, 'Main Course', 'Paneer biriyani made with basmati rice!');
INSERT INTO MENU VALUES('Mushroom Biriyani', 4, 290, 'Main Course', 'Mushroom, onion, tomato, spices and basmati rice');
INSERT INTO MENU VALUES('Jeera Rice', 4, 190, 'Main Course', 'Refreshing cumin rice');
INSERT INTO MENU VALUES('Vanilla Icecream', 4, 40, 'Dessert', 'Creamy vanilla ice cream');
INSERT INTO MENU VALUES('Coca-Cola', 4, 40, 'Beverages', 'Sparkling and Refreshing Beverage');

INSERT INTO MENU VALUES('Crispy chilli potatoes', 5, 445, 'Appetizer', 'Handcut Potatoes Fried, Crisp And Tossed In A Chilli Sauce.');
INSERT INTO MENU VALUES('Sichuan Chilli Babycorn', 5, 475, 'Appetizer', 'Crisp fried babycorn tossed with in house sichuan sauce.');
INSERT INTO MENU VALUES('Crispy Lotus Stem With Curry Leave And Black Pepper', 5, 495, 'Appetizer', 'Lotus stem rounds tossed with curry leaves and black pepper.');
INSERT INTO MENU VALUES('Vegetable Dumplings In Chilli Soya', 5, 445, 'Main Course', 'Vegetable And Corn Kernel Dumplings Deep Fried Tossed With Fresh Chillies And Soy.');
INSERT INTO MENU VALUES('Seasonal Vegetables In Smoked Chilli Sauce', 5, 495, 'Main Course', 'A smokey flavoured fusion of dry roasted chillies, seasonal vegetables and water chestnuts.');
INSERT INTO MENU VALUES('Exotic Vegetables In Black Pepper Sauce', 5, 525, 'Main Course', 'Babycorn, broccoli, asparagus, water chestnuts, fresh mushrooms and greens tossed with fresh black pepper, chillies and soy.');
INSERT INTO MENU VALUES('Honey Noodles With Almond Flakes', 5, 220, 'Dessert', 'Crispy Flat Noodles tossed in Honey & Almond Flakes');
INSERT INTO MENU VALUES('Hot Chocolate Rolls', 5, 235, 'Dessert', 'Crispy Spring Rolls, stuffed with Gooey Chocolate');

INSERT INTO MENU VALUES('Crispy chilli potatoes', 6, 445, 'Appetizer', 'Handcut Potatoes Fried, Crisp And Tossed In A Chilli Sauce.');
INSERT INTO MENU VALUES('Sichuan Chilli Babycorn', 6, 475, 'Appetizer', 'Crisp fried babycorn tossed with in house sichuan sauce.');
INSERT INTO MENU VALUES('Crispy Lotus Stem With Curry Leave And Black Pepper', 6, 495, 'Appetizer', 'Lotus stem rounds tossed with curry leaves and black pepper.');
INSERT INTO MENU VALUES('Vegetable Dumplings In Chilli Soya', 6, 445, 'Main Course', 'Vegetable And Corn Kernel Dumplings Deep Fried Tossed With Fresh Chillies And Soy.');
INSERT INTO MENU VALUES('Seasonal Vegetables In Smoked Chilli Sauce', 6, 495, 'Main Course', 'A smokey flavoured fusion of dry roasted chillies, seasonal vegetables and water chestnuts.');
INSERT INTO MENU VALUES('Exotic Vegetables In Black Pepper Sauce', 6, 525, 'Main Course', 'Babycorn, broccoli, asparagus, water chestnuts, fresh mushrooms and greens tossed with fresh black pepper, chillies and soy.');
INSERT INTO MENU VALUES('Honey Noodles With Almond Flakes', 6, 220, 'Dessert', 'Crispy Flat Noodles tossed in Honey & Almond Flakes');
INSERT INTO MENU VALUES('Hot Chocolate Rolls', 6, 235, 'Dessert', 'Crispy Spring Rolls, stuffed with Gooey Chocolate');

INSERT INTO MENU VALUES('Golden Thali', 7, 239, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Palak Paneer+Paneer Butter Masala+Veg Pulao+2 Butter Kulcha+Raita+Papad+Buttermilk');
INSERT INTO MENU VALUES('Punjabi Thali', 7, 169, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Chana Masala/Rajma+Plain Rice+2 Tawa Roti/2 Tandoori Roti+Papad+Raita');
INSERT INTO MENU VALUES('Jain Thali', 7, 189, 'Main Course', 'Dal+Paneer Butter Masala/Sev Tomato+Jeera Rice+2 Tawa Roti/2 Tandoori Roti+Papad +Raita');
INSERT INTO MENU VALUES('Special Thali', 7, 198, 'Main Course', 'Dal+Paneer Butter Masala+Aloo Gobi/Bhindi+Jeera Rice+2 Paratha+Papad+Raita ');
INSERT INTO MENU VALUES('Grilled Masala Chaap, Dal Makhani & Rice Bowl', 7, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Grilled Pudina Chaap, Dal Makhani & Rice Bowl', 7, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Gulab Jamub', 7, 99, 'Dessert', 'Delicious Gulab Jamun soaked in sugar syrup');
INSERT INTO MENU VALUES('Sweet Mango Lassi', 7, 89, 'Beverages', 'Mango lassi made with 100% natural mango pulp');
INSERT INTO MENU VALUES('Masala Butter Milk', 7, 79, 'Beverages', 'Spicy chilled buttermilk');

INSERT INTO MENU VALUES('Golden Thali', 8, 239, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Palak Paneer+Paneer Butter Masala+Veg Pulao+2 Butter Kulcha+Raita+Papad+Buttermilk');
INSERT INTO MENU VALUES('Punjabi Thali', 8, 169, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Chana Masala/Rajma+Plain Rice+2 Tawa Roti/2 Tandoori Roti+Papad+Raita');
INSERT INTO MENU VALUES('Jain Thali', 8, 189, 'Main Course', 'Dal+Paneer Butter Masala/Sev Tomato+Jeera Rice+2 Tawa Roti/2 Tandoori Roti+Papad +Raita');
INSERT INTO MENU VALUES('Special Thali', 8, 198, 'Main Course', 'Dal+Paneer Butter Masala+Aloo Gobi/Bhindi+Jeera Rice+2 Paratha+Papad+Raita ');
INSERT INTO MENU VALUES('Grilled Masala Chaap, Dal Makhani & Rice Bowl', 8, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Grilled Pudina Chaap, Dal Makhani & Rice Bowl', 8, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Gulab Jamub', 8, 99, 'Dessert', 'Delicious Gulab Jamun soaked in sugar syrup');
INSERT INTO MENU VALUES('Sweet Mango Lassi', 8, 89, 'Beverages', 'Mango lassi made with 100% natural mango pulp');
INSERT INTO MENU VALUES('Masala Butter Milk', 8, 79, 'Beverages', 'Spicy chilled buttermilk');

INSERT INTO MENU VALUES('Golden Thali', 9, 239, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Palak Paneer+Paneer Butter Masala+Veg Pulao+2 Butter Kulcha+Raita+Papad+Buttermilk');
INSERT INTO MENU VALUES('Punjabi Thali', 9, 169, 'Main Course', 'Dal+Aloo Gobi/Bhindi+Chana Masala/Rajma+Plain Rice+2 Tawa Roti/2 Tandoori Roti+Papad+Raita');
INSERT INTO MENU VALUES('Jain Thali', 9, 189, 'Main Course', 'Dal+Paneer Butter Masala/Sev Tomato+Jeera Rice+2 Tawa Roti/2 Tandoori Roti+Papad +Raita');
INSERT INTO MENU VALUES('Special Thali', 9, 198, 'Main Course', 'Dal+Paneer Butter Masala+Aloo Gobi/Bhindi+Jeera Rice+2 Paratha+Papad+Raita ');
INSERT INTO MENU VALUES('Grilled Masala Chaap, Dal Makhani & Rice Bowl', 9, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Grilled Pudina Chaap, Dal Makhani & Rice Bowl', 9, 209.40, 'Appetizer', 'Small portion gravy served with jeera rice in a bowl topped with chefs special delicious starters of your choice.');
INSERT INTO MENU VALUES('Gulab Jamub', 9, 99, 'Dessert', 'Delicious Gulab Jamun soaked in sugar syrup');
INSERT INTO MENU VALUES('Sweet Mango Lassi', 9, 89, 'Beverages', 'Mango lassi made with 100% natural mango pulp');
INSERT INTO MENU VALUES('Masala Butter Milk', 9, 79, 'Beverages', 'Spicy chilled buttermilk');

INSERT INTO ORDER_ VALUES(1, 2, 3);
INSERT INTO ORDER_ VALUES(2, 1, 3);
INSERT INTO ORDER_ VALUES(3, 7, 1);
INSERT INTO ORDER_ VALUES(4, 5, 2);
INSERT INTO ORDER_ VALUES(5, 4, 5);
INSERT INTO ORDER_ VALUES(6, 6, 5);
INSERT INTO ORDER_ VALUES(7, 3, 6);
INSERT INTO ORDER_ VALUES(8, 9, 7);
INSERT INTO ORDER_ VALUES(9, 8, 1);

INSERT INTO CART VALUES(1, 1);
INSERT INTO CART VALUES(2, 2);
INSERT INTO CART VALUES(3, 3);
INSERT INTO CART VALUES(4, 4);
INSERT INTO CART VALUES(5, 5);
INSERT INTO CART VALUES(6, 6);
INSERT INTO CART VALUES(7, 7);
INSERT INTO CART VALUES(8, 8);
INSERT INTO CART VALUES(9, 9);

INSERT INTO ITEMS VALUES('Chilly Gobi', 245, 1);
INSERT INTO ITEMS VALUES('Jeera Rice', 190, 1);
INSERT INTO ITEMS VALUES('Vanilla Icecream', 40, 2);
INSERT INTO ITEMS VALUES('Margherita Pizza', 99, 3);
INSERT INTO ITEMS VALUES('Veg Parcel', 39, 4);
INSERT INTO ITEMS VALUES('Exotic Vegetables In Black Pepper Sauce', 525, 5);
INSERT INTO ITEMS VALUES('Hot Chocolate Rolls', 235, 6);
INSERT INTO ITEMS VALUES('Sichuan Chilli Babycorn', 475, 7);
INSERT INTO ITEMS VALUES('Jain Thali', 189, 8);
INSERT INTO ITEMS VALUES('Cheese n Corn', 245, 6);

--CITEMS
INSERT INTO CITEMS VALUES('Chilly Gobi', 245, 1);
INSERT INTO CITEMS VALUES('Jeera Rice', 190, 1);
INSERT INTO CITEMS VALUES('Vanilla Icecream', 40, 2);
INSERT INTO CITEMS VALUES('Margherita Pizza', 99, 3);
INSERT INTO CITEMS VALUES('Veg Parcel', 39, 4);
INSERT INTO CITEMS VALUES('Exotic Vegetables In Black Pepper Sauce', 525, 5);
INSERT INTO CITEMS VALUES('Hot Chocolate Rolls', 235, 6);
INSERT INTO CITEMS VALUES('Sichuan Chilli Babycorn', 475, 7);
INSERT INTO CITEMS VALUES('Jain Thali', 189, 8);

--ORDERS
INSERT INTO ORDERS VALUES(1, 5);
INSERT INTO ORDERS VALUES(2, 6);
INSERT INTO ORDERS VALUES(2, 1);
INSERT INTO ORDERS VALUES(3, 4);
INSERT INTO ORDERS VALUES(4, 5);
INSERT INTO ORDERS VALUES(3, 2);
INSERT INTO ORDERS VALUES(5, 1);
INSERT INTO ORDERS VALUES(3, 6);
INSERT INTO ORDERS VALUES(5, 6);


--MAKES
INSERT INTO MAKES VALUES(3, 1, 1, '2021-10-01 19:10:25');
INSERT INTO MAKES VALUES(4, 2, 2, '2021-09-20 12:10:04');
INSERT INTO MAKES VALUES(3, 3, 3, '2021-06-22 07:05:05');
INSERT INTO MAKES VALUES(9, 4, 4, '2021-08-21 17:23:25');
INSERT INTO MAKES VALUES(3, 5, 5, '2021-09-17 22:25:30');
INSERT INTO MAKES VALUES(5, 6, 6, '2021-09-05 05:23:15');
INSERT INTO MAKES VALUES(2, 7, 7, '2020-10-28 16:46:50');
INSERT INTO MAKES VALUES(3, 8, 8, '2020-12-12 17:12:18');
INSERT INTO MAKES VALUES(5, 9, 9, '2021-01-01 16:44:25');


--APPLIES_ON
INSERT INTO APPLIES_ON VALUES(4, 2, 'ugsdkabue');
INSERT INTO APPLIES_ON VALUES(2, 5, 'uhdfiugfa');
INSERT INTO APPLIES_ON VALUES(2, 6, 'ugsdkfhu9');
INSERT INTO APPLIES_ON VALUES(3, 4, 'ugsdrhyiq');
INSERT INTO APPLIES_ON VALUES(2, 9, 'oeyrkjnai');
INSERT INTO APPLIES_ON VALUES(5, 2, 'uehuhroie');
INSERT INTO APPLIES_ON VALUES(5, 5, 'ieioiqdiw');
INSERT INTO APPLIES_ON VALUES(2, 5, 'qwiehndwu');
INSERT INTO APPLIES_ON VALUES(4, 3, 'nxcoidhir');
INSERT INTO APPLIES_ON VALUES(5, 7, 'uicoidhir');

--Add passwords to each of the users
ALTER TABLE CUSTOMER ADD COLUMN cpassword varchar(20);
ALTER TABLE DELIVERY_PERSON ADD COLUMN dpassword varchar(20);
ALTER TABLE RESTAURANT ADD COLUMN rpassword varchar(20);

UPDATE CUSTOMER SET cpassword = 'c1' WHERE cid = 1;
UPDATE CUSTOMER SET cpassword = 'c2' WHERE cid = 2;
UPDATE CUSTOMER SET cpassword = 'c3' WHERE cid = 3;
UPDATE CUSTOMER SET cpassword = 'c4' WHERE cid = 4;
UPDATE CUSTOMER SET cpassword = 'c5' WHERE cid = 5;
UPDATE CUSTOMER SET cpassword = 'c6' WHERE cid = 6;
UPDATE CUSTOMER SET cpassword = 'c7' WHERE cid = 7;
UPDATE CUSTOMER SET cpassword = 'c8' WHERE cid = 8;
UPDATE CUSTOMER SET cpassword = 'c9' WHERE cid = 9;
UPDATE CUSTOMER SET cpassword = 'c10' WHERE cid = 10;

UPDATE DELIVERY_PERSON SET dpassword = 'd1' WHERE did = 1;
UPDATE DELIVERY_PERSON SET dpassword = 'd2' WHERE did = 2;
UPDATE DELIVERY_PERSON SET dpassword = 'd3' WHERE did = 3;
UPDATE DELIVERY_PERSON SET dpassword = 'd4' WHERE did = 4;
UPDATE DELIVERY_PERSON SET dpassword = 'd5' WHERE did = 5;
UPDATE DELIVERY_PERSON SET dpassword = 'd6' WHERE did = 6;
UPDATE DELIVERY_PERSON SET dpassword = 'd7' WHERE did = 7;
UPDATE DELIVERY_PERSON SET dpassword = 'd8' WHERE did = 8;
UPDATE DELIVERY_PERSON SET dpassword = 'd9' WHERE did = 9;
UPDATE DELIVERY_PERSON SET dpassword = 'd10' WHERE did = 10;

UPDATE RESTAURANT SET rpassword = 'r1' WHERE rid = 1;
UPDATE RESTAURANT SET rpassword = 'r2' WHERE rid = 2;
UPDATE RESTAURANT SET rpassword = 'r3' WHERE rid = 3;
UPDATE RESTAURANT SET rpassword = 'r4' WHERE rid = 4;
UPDATE RESTAURANT SET rpassword = 'r5' WHERE rid = 5;
UPDATE RESTAURANT SET rpassword = 'r6' WHERE rid = 6;
UPDATE RESTAURANT SET rpassword = 'r7' WHERE rid = 7;
UPDATE RESTAURANT SET rpassword = 'r8' WHERE rid = 8;
UPDATE RESTAURANT SET rpassword = 'r9' WHERE rid = 9;

--add column for qty in items and citems
ALTER TABLE ITEMS ADD COLUMN iqty int default 1;

--add column for number of reviews in restaurants and delivery person
ALTER TABLE RESTAURANT ADD COLUMN rreviews int default 1;
ALTER TABLE DELIVERY_PERSON ADD COLUMN dreviews int default 1;
--add review column
ALTER TABLE DELIVERY_PERSON ADD COLUMN REMARKS VARCHAR(20);
UPDATE DELIVERY_PERSON SET REMARKS = 
CASE
WHEN  Drating > 4 AND Drating <= 5 THEN 'EXPERT'
WHEN  Drating > 3 AND Drating <= 4 THEN 'PROFICIENT'
WHEN  Drating > 2 AND Drating <= 3 THEN 'COMPETENT'
WHEN  Drating > 1 AND Drating <= 2 THEN 'SATISFACTORY'
WHEN  Drating >= 0 AND Drating <= 1 THEN 'NOVICE'
END;


Alter Table RESTAURANT add constraint restaurant_main_rid_fkey FOREIGN KEY (Main_rid) REFERENCES  RESTAURANT(Rid);
	








