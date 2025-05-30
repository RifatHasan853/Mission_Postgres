-- Active: 1747575335856@@127.0.0.1@5432@conservation_db

-- Table for rangers information
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
    
);

-- Table for species information
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50) NOT NULL
);

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');
-- Table for sighting records
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER NOT NULL,
    species_id INTEGER NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT,
    
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
    FOREIGN KEY (species_id) REFERENCES species(species_id)
);
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

--1.Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');


--2️⃣ Count unique species ever sighted.

SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Find all sightings where the location includes "Pass"
 SELECT * FROM sightings WHERE location  LIKE '%Pass%'; 

 --4️⃣ List each ranger's name and their total number of sightings.

SELECT r.name , COUNT(s.sighting_id) AS total_sightings
 FROM rangers r 
 INNER JOIN sightings s ON r.ranger_id=s.ranger_id GROUP BY name;

 --5️⃣ List species that have never been sighted.

 SELECT common_name
FROM species s
WHERE NOT EXISTS (
    SELECT species_id
    FROM sightings si
    WHERE si.species_id = s.species_id

);


--6️⃣ Show the most recent 2 sightings.

SELECT 

sp.common_name,
si.sighting_time,
r.name  
FROM sightings si 
JOIN species sp ON si.species_id=sp.species_id
JOIN  rangers r ON si.ranger_id=r.ranger_id
ORDER BY
si.sighting_time DESC
LIMIT 2;



--7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
set conservation_status='Historic'
WHERE extract(YEAR FROM discovery_date)<1800;

SELECT * from species;

--8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

-- Create the function
CREATE OR REPLACE FUNCTION get_time_of_day(timestamp_value TIMESTAMP)
RETURNS TEXT AS $$
DECLARE
    hour_of_day INT;
BEGIN
    hour_of_day := EXTRACT(HOUR FROM timestamp_value);
    
    RETURN CASE
        WHEN hour_of_day < 12 THEN 'Morning'
        WHEN hour_of_day < 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END;
END;
$$ LANGUAGE plpgsql;

-- Use the function in your query
SELECT 
    sighting_id,
    get_time_of_day(sighting_time) AS time_of_day
FROM sightings;


--9️⃣ Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id 
    FROM sightings
);
