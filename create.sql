CREATE TABLE IF NOT EXISTS public.addresses
(
    aid integer NOT NULL DEFAULT nextval('addresses_aid_seq'::regclass),
    address character varying(50) COLLATE pg_catalog."default",
    city character varying(50) COLLATE pg_catalog."default",
    state character varying(50) COLLATE pg_catalog."default",
    zip bigint,
    CONSTRAINT addresses_pkey PRIMARY KEY (aid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.addresses
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.deliverypartners
(
    dpid integer NOT NULL,
    type character varying(50) COLLATE pg_catalog."default",
    username character varying(50) COLLATE pg_catalog."default",
    password character varying(50) COLLATE pg_catalog."default",
    firstname character varying(50) COLLATE pg_catalog."default",
    lastname character varying(50) COLLATE pg_catalog."default",
    age integer,
    email character varying(50) COLLATE pg_catalog."default",
    mobile character varying(20) COLLATE pg_catalog."default",
    ssn character varying(20) COLLATE pg_catalog."default",
    sex character varying(20) COLLATE pg_catalog."default",
    aid integer,
    CONSTRAINT deliverypartners_pkey PRIMARY KEY (dpid),
    CONSTRAINT deliverypartners_aid_fkey FOREIGN KEY (aid)
        REFERENCES public.addresses (aid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.deliverypartners
    OWNER to postgres;
	

CREATE TABLE IF NOT EXISTS public.menuitems
(
    itemid integer NOT NULL,
    itemname character varying(50) COLLATE pg_catalog."default",
    price numeric,
    type character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT menuitems_pkey PRIMARY KEY (itemid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.menuitems
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.orders
(
    orderid integer NOT NULL,
    ordernumber character varying(50) COLLATE pg_catalog."default",
    restaurantid integer,
    userid integer,
    dpid integer,
    CONSTRAINT orders_pkey PRIMARY KEY (orderid),
    CONSTRAINT orders_dpid_fkey FOREIGN KEY (dpid)
        REFERENCES public.deliverypartners (dpid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT orders_restaurantid_fkey FOREIGN KEY (restaurantid)
        REFERENCES public.restaurants (restaurantid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT orders_userid_fkey FOREIGN KEY (userid)
        REFERENCES public.users (userid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orders
    OWNER to postgres;
	

CREATE TABLE IF NOT EXISTS public.orderdetails
(
    orderdetailid integer NOT NULL,
    orderid integer,
    itemid integer,
    preparationtime integer,
    deliverytime integer,
    totaltime integer,
    CONSTRAINT orderdetails_pkey PRIMARY KEY (orderdetailid),
    CONSTRAINT orderdetails_itemid_fkey FOREIGN KEY (itemid)
        REFERENCES public.menuitems (itemid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT orderdetails_orderid_fkey FOREIGN KEY (orderid)
        REFERENCES public.orders (orderid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orderdetails
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.owners
(
    ownerid integer NOT NULL,
    firstname character varying(50) COLLATE pg_catalog."default",
    lastname character varying(50) COLLATE pg_catalog."default",
    gender character varying(20) COLLATE pg_catalog."default",
    mobile character varying(50) COLLATE pg_catalog."default",
    email character varying(50) COLLATE pg_catalog."default",
    aid integer,
    CONSTRAINT owners_pkey PRIMARY KEY (ownerid),
    CONSTRAINT owners_aid_fkey FOREIGN KEY (aid)
        REFERENCES public.addresses (aid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.owners
    OWNER to postgres;
	
	
CREATE TABLE IF NOT EXISTS public.restaurant_items
(
    restaurantid integer NOT NULL,
    itemid integer NOT NULL,
    CONSTRAINT restaurant_items_pkey PRIMARY KEY (restaurantid, itemid),
    CONSTRAINT restaurant_items_itemid_fkey FOREIGN KEY (itemid)
        REFERENCES public.menuitems (itemid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT restaurant_items_restaurantid_fkey FOREIGN KEY (restaurantid)
        REFERENCES public.restaurants (restaurantid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.restaurant_items
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS public.restaurants
(
    restaurantid integer NOT NULL,
    ownerid integer,
    restaurantname character varying(50) COLLATE pg_catalog."default",
    phone character varying(20) COLLATE pg_catalog."default",
    aid integer,
    CONSTRAINT restaurants_pkey PRIMARY KEY (restaurantid),
    CONSTRAINT restaurants_aid_fkey FOREIGN KEY (aid)
        REFERENCES public.addresses (aid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT restaurants_ownerid_fkey FOREIGN KEY (ownerid)
        REFERENCES public.owners (ownerid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.restaurants
    OWNER to postgres;	


CREATE TABLE IF NOT EXISTS public.users
(
    userid integer NOT NULL,
    firstname character varying(50) COLLATE pg_catalog."default",
    lastname character varying(50) COLLATE pg_catalog."default",
    age integer,
    sex character varying(20) COLLATE pg_catalog."default",
    email character varying(50) COLLATE pg_catalog."default",
    mobile character varying(20) COLLATE pg_catalog."default",
    aid integer,
    CONSTRAINT users_pkey PRIMARY KEY (userid),
    CONSTRAINT users_aid_fkey FOREIGN KEY (aid)
        REFERENCES public.addresses (aid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.users
    OWNER to postgres;