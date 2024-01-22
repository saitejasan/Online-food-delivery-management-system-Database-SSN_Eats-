SELECT * FROM orderdetails;

CREATE UNIQUE INDEX index_OD_ID
on orderdetails (orderdetailid);

CREATE UNIQUE INDEX index_Order_ID
on orders (orderid);

SELECT O.orderid, R.restaurantname AS Restaurant, DP.firstname AS Delivery_Partner, OD.totaltime
FROM orderdetails OD JOIN Orders O ON OD.orderid=O.orderid
JOIN DeliveryPartners DP ON O.dpid=DP.dpid
JOIN Restaurants R ON O.restaurantid=R.restaurantid
WHERE OD.totaltime >= 120 AND OD.orderdetailid=9999;

DROP INDEX index_OD_ID;
DROP INDEX index_Order_ID;