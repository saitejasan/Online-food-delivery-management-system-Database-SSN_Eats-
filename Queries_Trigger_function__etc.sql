ALTER TABLE public.orderdetails
ADD COLUMN totaltime integer;

SELECT * FROM orderdetails;


CREATE OR REPLACE FUNCTION update_totaltime()
RETURNS TRIGGER AS $$
BEGIN
    NEW.totaltime := NEW.preparationtime + NEW.deliverytime;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_totaltime_trigger
BEFORE INSERT OR UPDATE ON public.orderdetails
FOR EACH ROW
EXECUTE FUNCTION update_totaltime();

UPDATE orderdetails
set preparationtime=30, deliverytime=106
WHERE orderdetailid = 1;


CREATE OR REPLACE FUNCTION update_restaurant_address(
    p_restaurant_id INTEGER,
    p_new_address VARCHAR(50),
    p_new_city VARCHAR(50),
    p_new_state VARCHAR(30),
    p_new_zip BIGINT,
    p_new_phone VARCHAR(20)
) RETURNS VOID AS $$
BEGIN
    -- Update the restaurant's address information
    UPDATE public.restaurants
    SET
        address = p_new_address,
        city = p_new_city,
        state = p_new_state,
        zip = p_new_zip,
        phone = p_new_phone
    WHERE
        restaurantid = p_restaurant_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_restaurant_address(
    1, '120 Meyer Road', 'Amherst', 'New York', 14226, '716-520-4225'
);


CREATE OR REPLACE VIEW aff_items
AS
SELECT R.RestaurantName, M.itemname, M.price, A.city
FROM menuitems M JOIN restaurant_items RI 
	ON M.itemid=RI.itemid JOIN restaurants R
	ON R.restaurantid=RI.restaurantid JOIN addresses A
	ON R.aid=A.aid
WHERE M.price <= 20
ORDER BY M.price;

SELECT * FROM aff_items;
