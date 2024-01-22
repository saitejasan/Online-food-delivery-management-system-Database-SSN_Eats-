SELECT u.userid, u.firstname, u.lastname, SUM(mi.price) as total_amount
FROM orders o
JOIN orderdetails od ON o.orderid = od.orderid
JOIN menuitems mi ON od.itemid = mi.itemid
JOIN users u ON o.userid = u.userid
GROUP BY u.userid, u.firstname, u.lastname;
   
SELECT r.restaurantid, r.restaurantname, AVG(od.preparationtime) as avg_preparation_time, AVG(od.totaltime) as avg_total_time
FROM orders o
JOIN orderdetails od ON o.orderid = od.orderid
JOIN restaurants r ON o.restaurantid = r.restaurantid
GROUP BY r.restaurantid, r.restaurantname;

SELECT mi.itemid, mi.itemname, COUNT(*) as total_orders
FROM orderdetails od
JOIN menuitems mi ON od.itemid = mi.itemid
GROUP BY mi.itemid, mi.itemname
ORDER BY total_orders DESC
LIMIT 5;

CREATE INDEX IF NOT EXISTS index_orders_userid ON orders (userid);
CREATE INDEX IF NOT EXISTS index_orders_restaurantid ON orders (restaurantid);
CREATE INDEX IF NOT EXISTS index_orderdetails_orderid ON orderdetails (orderid);
CREATE INDEX IF NOT EXISTS index_orderdetails_itemid ON orderdetails (itemid);


