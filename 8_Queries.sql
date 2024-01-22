INSERT INTO addresses 
	VALUES (3999, '36 Custer St', 'Buffalo', 'New York', 14221)

INSERT INTO users 
	VALUES (1001, 'Sai Teja', 'Sankarneni', 24, 'Male', 'saiteja@google.jp', '716-520-4225', 3999)
  
SELECT * FROM addresses WHERE aid=3999;

SELECT * FROM users WHERE userid=1001;

UPDATE orderdetails
set preparationtime=53, deliverytime=22
WHERE orderdetailid = 1;

SELECT * FROM orderdetails WHERE orderdetailid=1;

UPDATE users
set firstname='Nishant', lastname='Varma', age=24
WHERE userid = 1001;

SELECT * FROM users WHERE userid=1001;

DELETE FROM users 
WHERE userid=1001;

SELECT * FROM users WHERE userid=1001;

DELETE FROM addresses
WHERE aid=3999;


SELECT U.firstname AS User_FirstName, R.restaurantname, I.itemname, O.ordernumber
FROM Users U JOIN Orders O ON U.userid=O.userid
	JOIN Restaurant_Items RI ON O.Restaurantid=RI.Restaurantid
	JOIN Restaurants R ON R.Restaurantid=RI.Restaurantid
	JOIN MenuItems I ON RI.itemid=I.itemid;


SELECT I.itemname AS Costliest_Dish, R.restaurantname AS RestaurantName, MAX(I.price) as price
FROM Restaurants R JOIN Restaurant_Items RI ON RI.restaurantid=R.restaurantid
	JOIN MenuItems I ON RI.itemid=I.itemid
GROUP BY I.itemname, R.restaurantname
HAVING R.restaurantname LIKE 'B%';

SELECT restaurantname FROM Restaurants
where RestaurantName IN (SELECT R.restaurantname FROM Restaurants R
				JOIN Restaurant_items RI ON RI.restaurantid=R.restaurantid
				JOIN MenuItems I ON RI.itemid=I.itemid ORDER BY I.price LIMIT 5);
				

SELECT U.firstName || ',' || U.Lastname AS CustomerName,
	O.ordernumber, R.restaurantname, D.firstName || ',' || D.Lastname AS DeliveryPartner_Name
FROM Users U JOIN Orders O ON U.userid=O.userid
	JOIN Orderdetails OD ON O.orderid=OD.orderid
	JOIN DeliveryPartners D ON D.dpid=O.dpid
	JOIN Restaurants R ON R.restaurantid=O.restaurantid
WHERE OD.totaltime BETWEEN 60 and 120
ORDER BY CustomerName;