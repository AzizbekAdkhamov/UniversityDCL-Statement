CREATE USER rentaluser WITH PASSWORD 'rentaluser123';

GRANT CONNECT ON DATABASE "dvdrental" TO rentaluser;

GRANT SELECT ON customer TO rentaluser;

CREATE ROLE rental;

GRANT rental TO rentaluser;


GRANT INSERT, UPDATE ON TABLE rental TO rental;

INSERT INTO rental (customer_id , staff_id) VALUES (2626,55);

UPDATE rental SET customer_id = 4 WHERE rental_id = 3;

DO $$ 
DECLARE
    role_name text;
    cust_id int := 1; 
    v_first_name text;
    v_last_name text;
BEGIN
    SELECT first_name, last_name INTO v_first_name, v_last_name
    FROM customer
    WHERE customer_id = cust_id;
    IF (SELECT COUNT(*) FROM payment WHERE customer_id = cust_id) > 0 AND
       (SELECT COUNT(*) FROM rental WHERE customer_id = cust_id) > 0 THEN       
        role_name := 'client_' || REPLACE(MARY, ' ', '_') || '_' || REPLACE(SMITH, ' ', '_');
        EXECUTE 'CREATE ROLE ' || role_name;

        EXECUTE 'GRANT CONNECT ON DATABASE dvd_rental TO ' || role_name;
        EXECUTE 'GRANT USAGE ON SCHEMA public TO ' || role_name;
        EXECUTE 'GRANT SELECT ON TABLE rental TO ' || role_name || ' WHERE customer_id = ' || 1;
        EXECUTE 'GRANT SELECT ON TABLE payment TO ' || role_name || ' WHERE customer_id = ' || 1;
    END IF;
END $$;
