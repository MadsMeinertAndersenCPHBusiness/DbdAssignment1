DROP SEQUENCE IF EXISTS petsequence;
DROP TABLE IF EXISTS Pets_Caretakers;
DROP TABLE IF EXISTS DOG_DATA CASCADE;
DROP TABLE IF EXISTS CAT_DATA CASCADE;
DROP TABLE IF EXISTS PET_DATA CASCADE;
DROP TABLE IF EXISTS Caretakers;
DROP TABLE IF EXISTS Vets CASCADE;
DROP TABLE IF EXISTS Addresses CASCADE;
DROP TABLE IF EXISTS Cities;
DROP TYPE IF EXISTS species;

CREATE SEQUENCE PetSequence;
CREATE TYPE species as enum (
	'CAT',
	'DOG'
);
CREATE TABLE IF NOT EXISTS Cities (
	city_code int PRIMARY KEY,
	name varchar(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS Addresses (
	address_id SERIAL PRIMARY KEY,
	street varchar(100) NOT NULL,
	city_code int REFERENCES Cities NOT NULL
);
CREATE TABLE IF NOT EXISTS Vets (
	vet_cvr char(8) PRIMARY KEY,
	name varchar(80) NOT NULL,
	address_id INT REFERENCES Addresses NOT NULL
);
Create TABLE IF NOT EXISTS PET_DATA (
	id SERIAL PRIMARY KEY,
	name varchar(80) NOT NULL,
	age int NOT NULL,
	vet_cvr char(8) REFERENCES Vets NOT NULL
);
CREATE TABLE IF NOT EXISTS CAT_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	lifeCount int DEFAULT(9)
);
CREATE TABLE IF NOT EXISTS DOG_DATA (
	id SERIAL PRIMARY KEY REFERENCES PET_DATA,
	barkPitch char(2)
);
CREATE TABLE IF NOT EXISTS Caretakers (
	id SERIAL PRIMARY KEY,
	name varchar(80) NOT NULL,
	address_id INT REFERENCES Addresses NOT NULL
);
CREATE TABLE IF NOT EXISTS Pets_Caretakers (
	caretaker_id SERIAL REFERENCES Caretakers (id) ON DELETE CASCADE,
	pet_id SERIAL REFERENCES PET_DATA (id) ON DELETE CASCADE,
	CONSTRAINT pet_product_pkey PRIMARY KEY (caretaker_id, pet_id)
);

/* VIEWS */
CREATE OR REPLACE VIEW CATS AS SELECT P.*, C.lifeCount FROM PET_DATA AS P JOIN CAT_DATA as C on P.id = C.id;
CREATE OR REPLACE VIEW DOGS AS SELECT P.*, D.barkPitch FROM PET_DATA AS P JOIN DOG_DATA as D on P.id = D.id;

CREATE OR REPLACE VIEW PETS AS	SELECT P.*, C.lifeCount, D.barkPitch FROM PET_DATA as P 
	LEFT OUTER JOIN CAT_DATA as C on P.id = C.id
	LEFT OUTER JOIN DOG_DATA as D on P.id = D.id; 


-- INSERT CAT PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_CAT (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	lifeCount INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_CAT AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO CAT_DATA (id, lifeCount) SELECT id, lifeCount FROM NEW_CAT;  
END; $$;


-- INSERT DOG PROCEDURE --
CREATE OR REPLACE PROCEDURE INSERT_DOG (
 	name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8),
	barkPitch CHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN  
  WITH NEW_DOG AS(
  	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr) RETURNING id
  )
  INSERT INTO DOG_DATA (id, barkPitch) SELECT id, barkPitch FROM NEW_DOG;  
END; $$;

create or replace procedure INSERT_PET (
name VARCHAR(80),
 	age INTEGER,
	vet_cvr VARCHAR(8)
	)
	LANGUAGE plpgsql
AS $$
BEGIN  
	INSERT INTO PET_DATA(name, age, vet_cvr) VALUES (name, age, vet_cvr);
	END; $$;



DO $$
BEGIN
  CREATE ROLE username WITH LOGIN password 'password';
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role username -- it already exists';
END
$$;

grant select 
on cats, dogs, pets, pet_data 
to username;

grant insert 
on cat_data, dog_data, pet_data
to username;

grant usage, select on sequence pet_data_id_seq to username;

grant all on procedure INSERT_CAT, INSERT_DOG, INSERT_PET
to username;

/* DATA INSERT */
INSERT INTO Cities(city_code, name) VALUES ('1234', 'Hundested');
INSERT INTO Addresses(street, city_code) VALUES ('Street 123', 1234);
INSERT INTO Addresses(street, city_code) VALUES ('Street 456', 1234);
INSERT INTO Vets(vet_cvr, name, address_id) VALUES ('12345678', 'Dr. Ebsen', '1');

call INSERT_PET('Taylor', 4, '12345678');

CALL INSERT_CAT('Bobby', 2, '12345678', 2);
CALL INSERT_CAT('Kitty', 7, '12345678', 6);
CALL INSERT_CAT('Rosa', 2, '12345678', 3);
CALL INSERT_CAT('Tigger', 4, '12345678', 7);
CALL INSERT_CAT('Tiger', 8, '12345678', 1);
CALL INSERT_CAT('Max', 1, '12345678', 4);
CALL INSERT_CAT('Smokey', 12, '12345678', 9);

CALL INSERT_DOG('Sam', 11, '12345678', 'C4');
CALL INSERT_DOG('Bella', 6, '12345678', 'C2');
CALL INSERT_DOG('Charlie', 4, '12345678', 'B5');
CALL INSERT_DOG('Luna', 5, '12345678', 'A3');
CALL INSERT_DOG('Lucy', 9, '12345678', 'D2');
CALL INSERT_DOG('Bailey', 5, '12345678', 'E1');
CALL INSERT_DOG('Max', 7, '12345678', 'F6');

insert into pet_data(name, age, vet_cvr ) values ('Bello', 4, '12345678');
insert into pet_data(name, age, vet_cvr ) values ('Molly', 5, '12345678');
insert into pet_data(name, age, vet_cvr ) values('Coco', 3, '12345678');
insert into pet_data(name, age, vet_cvr ) values ('Ruby', 67, '12345678');
insert into pet_data(name, age, vet_cvr ) values ('Daisy', 13, '12345678');
insert into pet_data(name, age, vet_cvr ) values ('Frankie', 51, '12345678');
insert into pet_data(name, age, vet_cvr ) values ('Jack', 41, '12345678');

INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_1', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_2', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_3', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_4', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_5', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_6', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_7', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_8', '1');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_9', '2');
INSERT INTO Caretakers(name, address_id) VALUES ('Caretaker_10', '1');

INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,1);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,3);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (1,7);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (2,2);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (3,10);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (4,8);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (6,11);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (6,13);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (7,5);
INSERT INTO Pets_Caretakers(caretaker_id, pet_id) VALUES (9,15);



