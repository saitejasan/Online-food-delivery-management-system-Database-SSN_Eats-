SELECT * FROM Restaurants;
SELECT * FROM Owners;
SELECT * FROM Reviews;
SELECT * FROM OrderDetails;
SELECT * FROM DeliveryPartners;
SELECT * FROM Users;
SELECT * FROM MenuItems;


CREATE TABLE Restaurants(
    RestaurantID INT,
    OwnerID INT,
    ItemID INT,
    RestaurantName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(30),
    zip bigint,
    Phone VARCHAR(20)
);
ALTER TABLE Restaurants ADD PRIMARY KEY (RestaurantID);
ALTER TABLE Restaurants ADD FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID);
ALTER TABLE Restaurants ADD FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID);


CREATE TABLE Owners(
    OwnerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender VARCHAR(50),
    Mobile VARCHAR(50),
    Email VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip BIGINT
)
ALTER TABLE Owners ADD PRIMARY KEY (OwnerID);


CREATE TABLE Reviews(
	ReviewID INT,
	OrderID INT,
	DeliveryRating INT,
	FoodRating INT
);
ALTER TABLE Reviews add primary key (ReviewID);
ALTER TABLE Reviews ADD FOREIGN KEY (OrderID) REFERENCES OrderDetails(OrderID);


CREATE TABLE OrderDetails(
	OrderID INT,
	OrderNumber VARCHAR(50),
	RestaurantID INT,
	UserID INT,
	DpID INT,
	PreparationTime INT,
	DeliveryTime INT
);
ALTER TABLE OrderDetails add primary key (OrderID);
ALTER TABLE OrderDetails ADD FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID);
ALTER TABLE OrderDetails ADD FOREIGN KEY (DPID) REFERENCES DeliveryPartners(DpID);
ALTER TABLE OrderDetails ADD FOREIGN KEY (UserID) REFERENCES Users(UserID);


CREATE TABLE MenuItems(
	ItemID INT,
	ItemName VARCHAR(50),
	Price numeric,
	Type VARCHAR(20)
);
ALTER TABLE MenuItems add primary key (ItemID);


CREATE TABLE Users(
	UserID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Age INT,
	Sex VARCHAR(20),
	Email VARCHAR(50),
	Mobile VARCHAR(20),
	Address VARCHAR(50),
	City VARCHAR(50),
	State VARCHAR(20),
	Zip BIGINT
);
ALTER TABLE Users ADD PRIMARY KEY (UserID);


CREATE TABLE DeliveryPartners(
	DpID INT,
	Type VARCHAR(50),
	Username VARCHAR(50),
	Password VARCHAR(50),
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Age INT,
	Email VARCHAR(50),
	Mobile VARCHAR(20),
	SSN VARCHAR(20),
	Sex VARCHAR(20),
	Address VARCHAR(50),
	City VARCHAR(50),
	State VARCHAR(50),
	Zip BIGINT
);
ALTER TABLE DeliveryPartners ADD PRIMARY KEY (DpID);


SELECT * From 