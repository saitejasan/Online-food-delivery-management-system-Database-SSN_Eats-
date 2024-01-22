WITH inserted_addresses AS (
    INSERT INTO addresses (address, city, state, zip)
    SELECT address, city, state, zip FROM deliverypartners
    RETURNING aid, address, city, state, zip
)
UPDATE deliverypartners
SET aid = inserted_addresses.aid
FROM inserted_addresses
WHERE deliverypartners.address = inserted_addresses.address
AND deliverypartners.city = inserted_addresses.city
AND deliverypartners.state = inserted_addresses.state
AND deliverypartners.zip = inserted_addresses.zip;


WITH inserted_addresses AS (
    INSERT INTO addresses (address, city, state, zip)
    SELECT address, city, state, zip FROM users
    RETURNING aid, address, city, state, zip
)
UPDATE users
SET aid = inserted_addresses.aid
FROM inserted_addresses
WHERE users.address = inserted_addresses.address
AND users.city = inserted_addresses.city
AND users.state = inserted_addresses.state
AND users.zip = inserted_addresses.zip;


WITH inserted_addresses AS (
    INSERT INTO addresses (address, city, state, zip)
    SELECT address, city, state, zip FROM owners
    RETURNING aid, address, city, state, zip
)
UPDATE owners
SET aid = inserted_addresses.aid
FROM inserted_addresses
WHERE owners.address = inserted_addresses.address
AND owners.city = inserted_addresses.city
AND owners.state = inserted_addresses.state
AND owners.zip = inserted_addresses.zip;


WITH inserted_addresses AS (
    INSERT INTO addresses (address, city, state, zip)
    SELECT address, city, state, zip FROM restaurants
    RETURNING aid, address, city, state, zip
)
UPDATE restaurants
SET aid = inserted_addresses.aid
FROM inserted_addresses
WHERE restaurants.address = inserted_addresses.address
AND restaurants.city = inserted_addresses.city
AND restaurants.state = inserted_addresses.state
AND restaurants.zip = inserted_addresses.zip;