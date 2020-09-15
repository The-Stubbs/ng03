--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ng03; Type: SCHEMA; Schema: -; Owner: exileng
--

CREATE SCHEMA ng03;


ALTER SCHEMA ng03 OWNER TO exileng;

--
-- Name: battle_result; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.battle_result AS (
	alliancetag character varying,
	owner_id integer,
	owner_name character varying,
	fleet_id integer,
	fleet_name character varying,
	shipid integer,
	shipcategory smallint,
	shiplabel character varying,
	count integer,
	lost integer,
	killed integer,
	mod_shield smallint,
	mod_handling smallint,
	mod_tracking_speed smallint,
	mod_damage smallint,
	won boolean,
	attacked boolean,
	relation1 smallint,
	relation2 smallint
);


ALTER TYPE ng03.battle_result OWNER TO exileng;

--
-- Name: galaxy_info; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.galaxy_info AS (
	id integer,
	open_since timestamp without time zone,
	protected_until timestamp without time zone,
	recommended integer
);


ALTER TYPE ng03.galaxy_info OWNER TO exileng;

--
-- Name: invasion_result; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.invasion_result AS (
	result smallint,
	soldiers_total integer,
	soldiers_lost integer,
	def_scientists_total integer,
	def_scientists_lost integer,
	def_soldiers_total integer,
	def_soldiers_lost integer,
	def_workers_total integer,
	def_workers_lost integer
);


ALTER TYPE ng03.invasion_result OWNER TO exileng;

--
-- Name: research_status; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.research_status AS (
	userid integer,
	researchid integer,
	category smallint,
	name character varying,
	label character varying,
	description character varying,
	rank integer,
	cost_credits integer,
	levels smallint,
	level smallint,
	status integer,
	total_time integer,
	total_cost integer,
	remaining_time integer,
	expiration_time integer,
	researchable boolean,
	buildings_requirements_met boolean,
	planet_elements_requirements_met boolean
);


ALTER TYPE ng03.research_status OWNER TO exileng;

--
-- Name: resource_price; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.resource_price AS (
	buy_ore real,
	buy_hydrocarbon real,
	sell_ore real,
	sell_hydrocarbon real
);


ALTER TYPE ng03.resource_price OWNER TO exileng;

--
-- Name: training_price; Type: TYPE; Schema: ng03; Owner: exileng
--

CREATE TYPE ng03.training_price AS (
	scientist_ore smallint,
	scientist_hydrocarbon smallint,
	scientist_credits smallint,
	soldier_ore smallint,
	soldier_hydrocarbon smallint,
	soldier_credits smallint
);


ALTER TYPE ng03.training_price OWNER TO exileng;

--
-- Name: admin_create_fleet(integer, character varying, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_create_fleet(integer, character varying, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: OwnerId

-- Param2: Fleet Name

-- Param3: PlanetId (Null if unknown)

-- Param4: DestPlanetId (Null if no movement)

-- Param5: FleetSize (0=small, 4=big with invasion gm_fleets)

DECLARE

	fleet_id int4;

BEGIN

	IF $3 IS NULL AND $4 IS NULL THEN

		RETURN -1;

	END IF;

	IF ($5 < 0 OR $5 > 15) AND ($5 <> 99) THEN

		RETURN -1;

	END IF;

	fleet_id := nextval('gm_fleets_id_seq');

	INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since, speed)

	VALUES(fleet_id, $1, $3, $2, now(), 800);

	IF $5 = 0 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 20+int4(random()*20));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 10+int4(random()*10));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 10+int4(random()*10));

	END IF;

	IF $5 = 1 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 20+int4(random()*20));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 80+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 50+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 20+int4(random()*20));

	END IF;

	IF $5 = 2 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 100+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 100+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 60+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 100+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 30+int4(random()*30));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 30+int4(random()*30));

		/* UPDATE gm_fleets SET

			cargo_workers=5000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 3 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 100+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 100+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 200+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 50+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 150+int4(random()*100));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 200+int4(random()*100));

		/* UPDATE gm_fleets SET

			cargo_workers=20000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 4 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 200+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 200+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 404, 500+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 300+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 504, 500+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 105, 30+int4(random()*40));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 106, int4(random()*300));

		/* UPDATE gm_fleets SET

			cargo_soldiers=50000,

			cargo_workers=50000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 5 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 200+int4(random()*2000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 200+int4(random()*2000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 200+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 200+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 200+int4(random()*600));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 200+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 200+int4(random()*800));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 404, 500+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 300+int4(random()*800));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 504, 500+int4(random()*700));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 105, 30+int4(random()*70));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 106, int4(random()*300));

		/* UPDATE gm_fleets SET

			cargo_soldiers=50000,

			cargo_workers=50000

		WHERE id=fleet_id; */

	END IF;

	-- 200k

	IF $5 = 6 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 200+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 200+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 200+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 404, 500+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 300+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 504, 500+int4(random()*300));

		/* UPDATE gm_fleets SET

			cargo_soldiers=50000,

			cargo_workers=50000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 7 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 1200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 1200+int4(random()*1000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 300+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 300+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 300+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 300+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 400+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 404, 700+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 500+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 504, 1000+int4(random()*300));

		/* UPDATE gm_fleets SET

			cargo_soldiers=50000,

			cargo_workers=50000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 8 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 5200+int4(random()*2000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 5200+int4(random()*2000));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 301, 800+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 302, 800+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 304, 1200+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 401, 1000+int4(random()*300));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 402, 600+int4(random()*200));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 404, 1000+int4(random()*500));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 501, 1200+int4(random()*800));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 504, 2000+int4(random()*1000));

		/* UPDATE gm_fleets SET

			cargo_soldiers=50000,

			cargo_workers=50000

		WHERE id=fleet_id; */

	END IF;

	-- cargo gm_fleets

	IF $5 = 10 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 50+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 50+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 102, 10+int4(random()*10));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 103, 10+int4(random()*10));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 121, 5+int4(random()*10));

		/* UPDATE gm_fleets SET

			cargo_ore=100000,

			cargo_hydrocarbon=100000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 11 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 80+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 80+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 102, 30+int4(random()*30));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 103, 30+int4(random()*30));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 121, 5+int4(random()*10));

		/* UPDATE gm_fleets SET

			cargo_ore=200000,

			cargo_hydrocarbon=200000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 12 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 201, 80+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 202, 80+int4(random()*50));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 102, 60+int4(random()*40));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 103, 100+int4(random()*60));

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 121, 10+int4(random()*20));

		/* UPDATE gm_fleets SET

			cargo_ore=300000,

			cargo_hydrocarbon=300000

		WHERE id=fleet_id; */

	END IF;

	IF $5 = 13 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 950, 5);

	END IF;

	-- fleet with a probe

	IF $5 = 15 THEN

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 100, 1);

	END IF;

	IF $4 IS NOT NULL THEN

		UPDATE gm_fleets SET

			dest_planetid = $4,

			action_start_time = now(),

			action_end_time = now() + (64800 * 1000.0/speed) * INTERVAL '1 second',

			engaged = false,

			action = 1,

			idle_since = null

		WHERE id=fleet_id;

	END IF;

	RETURN fleet_id;

END;$_$;


ALTER FUNCTION ng03.admin_create_fleet(integer, character varying, integer, integer, integer) OWNER TO exileng;

--
-- Name: admin_create_special_galaxies(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_create_special_galaxies(_fromgalaxy integer, _togalaxy integer) RETURNS void
    LANGUAGE plpgsql
    AS $$-- create a galaxy without market

DECLARE

	g int4; 

	s int4;

	p int4;

	fl int2;

	sp int2;

	-- abundance of ore, hydrocarbon

	pore int2;

	phydrocarbon int2;

	t int2;

	planettype int2;

	i int4;

	specialplanets int2[];

	sectorvalue float;

	sectorplanets int2;

	sectorfloor int4;

	sectorspace int4;

	galaxyplanets int4;

BEGIN

	FOR g IN _fromgalaxy.._togalaxy LOOP

		RAISE NOTICE 'Populating galaxy %', g;

		INSERT INTO gm_galaxies(id, visible, has_merchants, allow_new_players) VALUES(g, true, false, false);

		galaxyplanets := 0;

		FOR s IN 1..99 LOOP

			--sectorvalue := (6-0.55*sqrt(power(5.5-(s%10), 2) + power(5.5-(s/10 + 1), 2)))*20;

			sectorvalue := 130 - 3*LEAST(tool_compute_distance(s, 13, 23, 13), tool_compute_distance(s, 13, 28, 13), tool_compute_distance(s, 13, 73, 13), tool_compute_distance(s, 13, 78, 13));

			sectorplanets := 25;

			FOR i IN 1..10 LOOP specialplanets[i] := int2(30*random()); END LOOP;

			FOR p IN 1..25 LOOP

				FOR i IN 1..10 LOOP

					IF specialplanets[i] = p THEN

						sectorplanets := sectorplanets - 1;

						EXIT;

					END IF;

				END LOOP;

			END LOOP;

			IF s=45 OR s=46 OR s=55 OR s=56 THEN sectorplanets := sectorplanets - 1; END IF;

			--RAISE NOTICE 'Sector % : %,%', s, sectorvalue, sectorplanets;

			sectorvalue := sectorvalue*25/sectorplanets;

			FOR p IN 1..25 LOOP

				planettype := 1; -- normal planet

				FOR i IN 1..10 LOOP

					IF specialplanets[i] = p THEN

						planettype := int2(100*random());

						IF planettype < 98 THEN

							planettype := 0;	-- empty space

						ELSEIF random() < 0.5 THEN

							planettype := 3;	-- asteroid with auto-spawn of ore in orbit

						ELSE

							planettype := 4;	-- star with auto-spawn of hydrocarbon in orbit

						END IF;						

/*

						-- no spawning resources near the center of galaxies

						IF (planettype = 3 OR planettype = 4) AND (6-0.55*sqrt(power(5.5-(s%10), 2) + power(5.5-(s/10 + 1), 2))) > 4.5 THEN

							planettype := 1;

						END IF;*/

						EXIT;

					END IF;

				END LOOP;

				-- reserve these planets to put merchants on them

				IF p = 13 AND (s=23 OR s=28 OR s=73 OR s=78) THEN

					planettype := 1;

				END IF;

				-- planet in the very center of a galaxy are always empty

				IF (s=45 AND p=25) OR (s=46 AND p=21) OR (s=55 AND p=5) OR (s=56 AND p=1) THEN planettype := 0; END IF;

				-- floor/space and random ore/hydrocarbon abundancy

				fl := int2(1.1*((sectorvalue*2/3) + random()*sectorvalue/3));

				WHILE fl > 200 LOOP

					fl := fl - 4;

				END LOOP;

				IF fl < 90 THEN

					sp := int2(20+random()*20);

				ELSEIF fl < 100 THEN

					sp := int2(15+random()*20);

				ELSE

					sp := int2(10+random()*15);

				END IF;

				t := int2(80+random()*100 + sectorvalue / 5);

				pore := int2(LEAST(35+random()*(t-47), t));

				phydrocarbon := t - pore;

				IF random() > 0.6 THEN

					t := phydrocarbon;

					phydrocarbon := pore;

					pore := t;

				END IF;

				IF planettype = 0 THEN	-- empty space

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0);

				ELSEIF planettype = 1 THEN	-- normal planet

					galaxyplanets := galaxyplanets + 1;

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, fl, sp, fl, sp, pore, phydrocarbon, pore, phydrocarbon);

					IF fl > 170 AND random() < 0.5 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 95, 1);

					END IF;

					IF fl > 120 AND random() < 0.05 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 96, 1);

					END IF;

					IF fl > 65 AND random() < 0.02 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 94, 1);

					END IF;

					IF fl > 65 AND random() < 0.01 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 90, 1);

					END IF;

				ELSEIF planettype = 3 THEN	-- spawn ore

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 42000+10000*random(), 0);

				ELSE	-- spawn hydrocarbon

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42000+10000*random());

				END IF;

			END LOOP;

		END LOOP;

		RAISE NOTICE 'creating pirates';

/*

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 6) FROM gm_planets WHERE galaxy=g AND planet_floor >= 95 AND planet_floor < 140 AND ownerid IS NULL;

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 7) FROM gm_planets WHERE galaxy=g AND planet_floor >= 140 AND planet_floor < 180 AND ownerid IS NULL;

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 8) FROM gm_planets WHERE galaxy=g AND planet_floor >= 180 AND ownerid IS NULL;

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 5) FROM gm_planets WHERE galaxy=g AND planet_floor = 0 AND ownerid IS NULL;

		UPDATE gm_fleets SET attackonsight=true WHERE ownerid=1 AND NOT attackonsight;

*/

		UPDATE gm_galaxies SET

			planets=(SELECT count(*) FROM gm_planets WHERE galaxy=g AND planet_floor > 0),

			protected_until = now()

		WHERE id=g;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.admin_create_special_galaxies(_fromgalaxy integer, _togalaxy integer) OWNER TO exileng;

--
-- Name: admin_create_starting_galaxies(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_create_starting_galaxies(_fromgalaxy integer, _togalaxy integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	g int4; 

	s int4;

	p int4;

	fl int2;

	sp int2;

	-- abundance of ore, hydrocarbon

	pore int2;

	phydrocarbon int2;

	t int2;

	planettype int2;

	i int4;

	specialplanets int2[];

	sectorvalue float;

	sectorplanets int2;

	sectorfloor int4;

	sectorspace int4;

	galaxyplanets int4;

BEGIN

	FOR g IN _fromgalaxy.._togalaxy LOOP

		RAISE NOTICE 'Populating galaxy %', g;

		INSERT INTO gm_galaxies(id, visible) VALUES(g,true);

		galaxyplanets := 0;

		FOR s IN 1..99 LOOP

			sectorvalue := (6-0.55*sqrt(power(5.5-(s%10), 2) + power(5.5-(s/10 + 1), 2)))*20;

			sectorplanets := 25;

			FOR i IN 1..10 LOOP specialplanets[i] := int2(50*random()); END LOOP;

			FOR p IN 1..25 LOOP

				FOR i IN 1..10 LOOP

					IF specialplanets[i] = p THEN

						sectorplanets := sectorplanets - 1;

						EXIT;

					END IF;

				END LOOP;

			END LOOP;

			IF s=45 OR s=46 OR s=55 OR s=56 THEN sectorplanets := sectorplanets - 1; END IF;

			--RAISE NOTICE 'Sector % : %,%', s, sectorvalue, sectorplanets;

			sectorvalue := sectorvalue*25/sectorplanets;

			FOR p IN 1..25 LOOP

				planettype := 1; -- normal planet

				FOR i IN 1..10 LOOP

					IF specialplanets[i] = p THEN

						planettype := int2(100*random());

						IF planettype < 92 THEN

							planettype := 0;	-- empty space

						ELSEIF planettype <= 98 THEN

							planettype := 3;	-- asteroid with auto-spawn of ore in orbit

						ELSE

							planettype := 4;	-- star with auto-spawn of hydrocarbon in orbit

						END IF;						

						-- no spawning resources near the center of galaxies

						IF (planettype = 3 OR planettype = 4) AND (6-0.55*sqrt(power(5.5-(s%10), 2) + power(5.5-(s/10 + 1), 2))) > 4.5 THEN

							planettype := 1;

						END IF;

						EXIT;

					END IF;

				END LOOP;

				-- reserve these planets to put merchants on them

				IF p = 13 AND (s=23 OR s=28 OR s=73 OR s=78) THEN

					planettype := 1;

				END IF;

				-- planet in the very center of a galaxy are always empty

				IF (s=45 AND p=25) OR (s=46 AND p=21) OR (s=55 AND p=5) OR (s=56 AND p=1) THEN planettype := 0; END IF;

				-- floor/space and random ore/hydrocarbon abundancy

				IF s <= 10 OR s >= 90 OR s % 10 = 0 OR s % 10 = 1 THEN

					IF planettype = 3 OR planettype = 4 THEN

						planettype := 0;	-- empty space

					END IF;

					fl := 80;

					sp := 10;

					pore := 60;

					phydrocarbon := 60;

				ELSE

					fl := int2((sectorvalue*2/3) + random()*sectorvalue/3);

					WHILE fl < 80 LOOP

						fl := fl + 4;

					END LOOP;

					WHILE fl > 155 LOOP

						fl := fl - 4;

					END LOOP;

					IF fl < 90 THEN

						sp := int2(20+random()*20);

					ELSEIF fl < 100 THEN

						sp := int2(15+random()*20);

					ELSE

						sp := int2(10+random()*15);

					END IF;

					t := int2(80+random()*100 + sectorvalue / 5);

					IF fl > 70 AND fl < 85 THEN

						t := (t * 1.3)::integer;

					END IF;

					pore := int2(LEAST(35+random()*(t-47), t));

					phydrocarbon := t - pore;

					IF random() > 0.6 THEN

						t := phydrocarbon;

						phydrocarbon := pore;

						pore := t;

					END IF;

				END IF;

				IF planettype = 0 THEN	-- empty space

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0);

				ELSEIF planettype = 1 THEN	-- normal planet

					galaxyplanets := galaxyplanets + 1;

					INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon)

					VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, fl, sp, fl, sp, pore, phydrocarbon, pore, phydrocarbon);

					IF fl > 120 AND random() < 0.01 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 96, 1);

					END IF;

					IF fl > 65 AND random() < 0.001 THEN

						INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

						VALUES((g-1)*25*99 + (s-1)*25 + p, 90, 1);

					END IF;

				ELSEIF planettype = 3 THEN	-- spawn ore

					IF s = 34 OR s = 35 OR s = 36 OR s = 37 OR s = 44 OR s = 47 OR s = 54 OR s = 57 OR s = 64 OR s = 65 OR s = 66 OR s = 67 THEN

						INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

						VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 22000+5000*random(), 0);

					ELSE

						INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

						VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 13000+4000*random(), 0);

					END IF;

				ELSE	-- spawn hydrocarbon

					IF s = 34 OR s = 35 OR s = 36 OR s = 37 OR s = 44 OR s = 47 OR s = 54 OR s = 57 OR s = 64 OR s = 65 OR s = 66 OR s = 67 THEN

						INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

						VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22000+5000*random());

					ELSE

						INSERT INTO gm_planets(id, galaxy, sector, planet, planet_floor, planet_space, floor, space, planet_pct_ore, planet_pct_hydrocarbon, pct_ore, pct_hydrocarbon, spawn_ore, spawn_hydrocarbon)

						VALUES((g-1)*25*99 + (s-1)*25 + p, g, s, p, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13000+4000*random());

					END IF;

				END IF;

				IF s % 10 = 0 OR s % 10 = 1 OR s <= 10 OR s > 90 THEN

					UPDATE gm_planets SET

						min_security_level=1

					WHERE id=(g-1)*25*99 + (s-1)*25 + p;

				ELSEIF s % 10 = 2 OR s % 10 = 9 OR s <= 20 OR s > 80 THEN

					UPDATE gm_planets SET

						min_security_level=2

					WHERE id=(g-1)*25*99 + (s-1)*25 + p;

				END IF;

			END LOOP;

		END LOOP;

		RAISE NOTICE 'Galaxy %, planets: %', g, galaxyplanets;

		RAISE NOTICE 'creating merchant planets';

/*

		s := int2(1+49*random());

		PERFORM sp_admin_create_merchants(galaxy, sector, planet) FROM gm_planets WHERE galaxy=g AND sector=s;

		s := int2(51+48*random());

		PERFORM sp_admin_create_merchants(galaxy, sector, planet) FROM gm_planets WHERE galaxy=g AND sector=s;

*/

		PERFORM admin_create_merchants(g, 23, 13);

		PERFORM admin_create_merchants(g, 28, 13);

		PERFORM admin_create_merchants(g, 73, 13);

		PERFORM admin_create_merchants(g, 78, 13);

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 1) FROM gm_planets WHERE galaxy=g AND planet_floor > 95 AND planet_floor <= 120 AND ownerid IS NULL;

		PERFORM admin_create_fleet(1, 'Les fossoyeurs', id, null, 2) FROM gm_planets WHERE galaxy=g AND planet_floor > 120 AND ownerid IS NULL;

		UPDATE gm_fleets SET attackonsight=true WHERE ownerid=1 AND NOT attackonsight;

		UPDATE gm_galaxies SET

			planets=(SELECT count(*) FROM gm_planets WHERE galaxy=g AND planet_floor > 0),

			protected_until = null

		WHERE id=g;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.admin_create_starting_galaxies(_fromgalaxy integer, _togalaxy integer) OWNER TO exileng;

--
-- Name: admin_execute_processes(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_execute_processes() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_item record;

	start timestamp;

BEGIN

	FOR r_item IN

		SELECT *

		FROM dt_processes

		WHERE last_runtime+run_every < now() AND enabled

	LOOP

		start := to_timestamp(timeofday(), 'Dy Mon DD HH24:MI:SS.US YYYY');

		BEGIN

			EXECUTE 'SELECT ' || r_item.procedure;

			UPDATE dt_processes SET

				last_runtime = now(),

				last_result = null,

				last_executiontimes = (to_timestamp(timeofday(), 'Dy Mon DD HH24:MI:SS.US YYYY')-start) || last_executiontimes[0:9]

			WHERE procedure = r_item.procedure;

		EXCEPTION

			WHEN OTHERS THEN

				UPDATE dt_processes SET

					last_result = SQLERRM,

					last_executiontimes = (to_timestamp(timeofday(), 'Dy Mon DD HH24:MI:SS.US YYYY')-start) || last_executiontimes[0:9]

				WHERE procedure = r_item.procedure;

				INSERT INTO gm_log_process_errors(procedure, error) VALUES(r_item.procedure, SQLERRM);

		END;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.admin_execute_processes() OWNER TO exileng;

--
-- Name: admin_send_mail(integer, integer, smallint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_send_mail(_user_id integer, _msg_id integer, _lcid smallint) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

	r_msg record;

BEGIN

	SELECT INTO r_msg

		subject, body, sender

	FROM dt_mails

	WHERE id=_msg_id AND lcid=_lcid;

	IF NOT FOUND THEN

		SELECT INTO r_msg

			subject, body, sender

		FROM dt_mails

		WHERE id=_msg_id LIMIT 1;

		IF NOT FOUND THEN

			RETURN 1;

		END IF;

	END IF;

	INSERT INTO gm_mails(ownerid, owner, sender, subject, body)

	VALUES(_user_id, (SELECT login FROM gm_profiles WHERE id=_user_id), r_msg.sender, r_msg.subject, r_msg.body);

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.admin_send_mail(_user_id integer, _msg_id integer, _lcid smallint) OWNER TO exileng;

--
-- Name: admin_send_mail(integer, integer, smallint, character varying, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.admin_send_mail(_user_id integer, _msg_id integer, _lcid smallint, _param1 character varying, _param2 character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE

	r_msg record;

BEGIN

	SELECT INTO r_msg

		subject, body, sender

	FROM dt_mails

	WHERE id=_msg_id AND lcid=_lcid;

	IF NOT FOUND THEN

		SELECT INTO r_msg

			subject, body, sender

		FROM dt_mails

		WHERE id=_msg_id LIMIT 1;

		IF NOT FOUND THEN

			RETURN 1;

		END IF;

	END IF;

	INSERT INTO gm_mails(ownerid, owner, sender, subject, body)

	VALUES(_user_id, (SELECT login FROM gm_profiles WHERE id=_user_id), r_msg.sender, r_msg.subject, replace(replace(r_msg.body, '$1', _param1), '$2', _param2));

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.admin_send_mail(_user_id integer, _msg_id integer, _lcid smallint, _param1 character varying, _param2 character varying) OWNER TO exileng;

--
-- Name: internal_alliance_check_for_leader(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_alliance_check_for_leader(_allianceid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

BEGIN

	SELECT INTO r_user id, alliance_rank

	FROM gm_profiles

	WHERE alliance_id=_allianceid

	ORDER BY alliance_rank, alliance_joined LIMIT 1;

	IF FOUND AND r_user.alliance_rank <> 0 THEN

		-- promote this user as the new alliance leader

		UPDATE gm_profiles SET

			alliance_rank = 0

		WHERE id=r_user.id AND alliance_id=_allianceid;

	ELSEIF NOT FOUND THEN

		-- if no members are part of this alliance then delete the alliance

		DELETE FROM gm_alliances WHERE id=_allianceid;

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_alliance_check_for_leader(_allianceid integer) OWNER TO exileng;

--
-- Name: internal_alliance_get_nap_location_sharing(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_alliance_get_nap_location_sharing(integer, integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $_$SELECT share_locs FROM gm_alliance_naps WHERE allianceid1=$2 AND allianceid2=$1;$_$;


ALTER FUNCTION ng03.internal_alliance_get_nap_location_sharing(integer, integer) OWNER TO exileng;

--
-- Name: internal_alliance_get_value(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_alliance_get_value(_alliance_id integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	rec record;

BEGIN

	SELECT INTO rec

		sum(score) AS score, count(1) AS members

	FROM gm_profiles

	WHERE alliance_id = _alliance_id AND privilege > -10;

	RETURN COALESCE((rec.score * (1 + 0.02*rec.members))::bigint, 0);

END;$$;


ALTER FUNCTION ng03.internal_alliance_get_value(_alliance_id integer) OWNER TO exileng;

--
-- Name: internal_alliance_get_war_cost(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_alliance_get_war_cost(_target_alliance_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

	_value integer;

BEGIN

	SELECT INTO _value

		sum(internal_alliance_get_value(allianceid1))

	FROM gm_alliance_wars

	WHERE allianceid2 = _target_alliance_id;

	RETURN GREATEST(0, _value*static_alliance_war_cost_coeff())::integer;

END;$$;


ALTER FUNCTION ng03.internal_alliance_get_war_cost(_target_alliance_id integer) OWNER TO exileng;

--
-- Name: internal_alliance_is_at_war(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_alliance_is_at_war(_alliance_id integer) RETURNS boolean
    LANGUAGE sql
    AS $_$SELECT count(*) > 2

FROM gm_alliance_wars

WHERE (allianceid1=$1) OR (allianceid2=$1);$_$;


ALTER FUNCTION ng03.internal_alliance_is_at_war(_alliance_id integer) OWNER TO exileng;

--
-- Name: internal_battle_add_fleet(integer, integer, integer, integer, integer, integer, integer, boolean, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_battle_add_fleet(_battleid integer, _ownerid integer, _fleetid integer, _mod_shield integer, _mod_handling integer, _mod_tracking_speed integer, _mod_damage integer, _attackonsight boolean, _won boolean) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	_battle_fleet_id int8;

	r_user record;

BEGIN

	_battle_fleet_id := nextval('gm_battle_fleets_id_seq');

	SELECT INTO r_user login, (SELECT tag FROM gm_alliances WHERE id=gm_profiles.alliance_id) AS alliancetag FROM gm_profiles WHERE id=_ownerid;

	INSERT INTO gm_battle_fleets(id, battleid, alliancetag, owner_id, owner_name, fleet_id, fleet_name, mod_shield, mod_handling, mod_tracking_speed, mod_damage, attackonsight, won)

	VALUES(_battle_fleet_id, _battleid, r_user.alliancetag, _ownerid, r_user.login, _fleetid, (SELECT name FROM gm_fleets WHERE id=_fleetid), 

		_mod_shield, _mod_handling, _mod_tracking_speed, _mod_damage,

		_attackonsight, _won);

	RETURN _battle_fleet_id;

END;$$;


ALTER FUNCTION ng03.internal_battle_add_fleet(_battleid integer, _ownerid integer, _fleetid integer, _mod_shield integer, _mod_handling integer, _mod_tracking_speed integer, _mod_damage integer, _attackonsight boolean, _won boolean) OWNER TO exileng;

--
-- Name: internal_battle_create(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_battle_create(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: planetid where battle happened

DECLARE

	battleid int4;

BEGIN

	battleid := nextval('gm_battles_id_seq');

	INSERT INTO gm_battles(id, planetid, rounds, key) VALUES(battleid, $1, $2, tool_generate_key());

	RETURN battleid;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN -1;

	WHEN UNIQUE_VIOLATION THEN

		RETURN internal_battle_create($1, $2);

END;$_$;


ALTER FUNCTION ng03.internal_battle_create(integer, integer) OWNER TO exileng;

--
-- Name: internal_battle_get_result(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_battle_get_result(integer, integer, integer) RETURNS SETOF ng03.battle_result
    LANGUAGE sql
    AS $_$-- Param1: BattleId

-- Param2: UserId

-- Param3: UserId

SELECT *

FROM (SELECT alliancetag, owner_id, owner_name, fleet_id, fleet_name, shipid, dt_ships.category AS shipcategory, dt_ships.label AS shiplabel, before, before-after AS lost, killed, 

	gm_battle_fleets.mod_shield, gm_battle_fleets.mod_handling, gm_battle_fleets.mod_tracking_speed, gm_battle_fleets.mod_damage, won, attackonsight,

	CASE

		WHEN owner_id=$2 THEN int2(2) 

		ELSE COALESCE((SELECT relation FROM gm_battle_relations WHERE battleid=$1 AND ((user1=$2 AND user2=owner_id) OR (user1=owner_id AND user2=$2))), int2(-1))

	END,

	CASE

		WHEN owner_id=$3 THEN int2(2) 

		ELSE COALESCE((SELECT relation FROM gm_battle_relations WHERE battleid=$1 AND ((user1=$3 AND user2=owner_id) OR (user1=owner_id AND user2=$3))), int2(-1))

	END AS friend

	FROM gm_battle_fleets

		INNER JOIN gm_battle_fleet_ships ON (gm_battle_fleets.id = gm_battle_fleet_ships.fleetid)

		INNER JOIN dt_ships ON (dt_ships.id=gm_battle_fleet_ships.shipid)

	WHERE battleid=$1) AS t

ORDER BY -friend, upper(owner_name), upper(fleet_name), fleet_id, shipcategory, shipid;$_$;


ALTER FUNCTION ng03.internal_battle_get_result(integer, integer, integer) OWNER TO exileng;

--
-- Name: internal_chat_replace_banned_words(character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_chat_replace_banned_words(_line character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE

	res varchar;

	r_bans record;

BEGIN

	res := _line;

	FOR r_bans IN

		SELECT regexp, replace_by

		FROM dt_banned_chat_words

	LOOP

		res := regexp_replace(res, r_bans.regexp, r_bans.replace_by, 'ig');

	END LOOP;

	RETURN res;

END;$$;


ALTER FUNCTION ng03.internal_chat_replace_banned_words(_line character varying) OWNER TO exileng;

--
-- Name: internal_commander_get_fleet_bonus_efficiency(bigint, real); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_commander_get_fleet_bonus_efficiency(_ships bigint, _bonus real) RETURNS real
    LANGUAGE plpgsql IMMUTABLE
    AS $$DECLARE

	_eff real;

BEGIN

	IF _ships < 20000 THEN

		RETURN _bonus;

	END IF;

	IF _bonus < 1.0 THEN

		RETURN _bonus;

	END IF;

	_eff := GREATEST(0.0, 1.0 - (_ships - 20000.0) / 180000.0);

	RETURN 1.0 + (_bonus - 1.0) * _eff;

END;$$;


ALTER FUNCTION ng03.internal_commander_get_fleet_bonus_efficiency(_ships bigint, _bonus real) OWNER TO exileng;

--
-- Name: internal_commander_get_prestige_cost_to_train(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_commander_get_prestige_cost_to_train(_userid integer, _commanderid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

	r_commander record;

BEGIN

	SELECT INTO r_commander 

		(1+salary_increases) * 2000 * GREATEST(0.1, date_part('epoch', salary_last_increase + static_commander_promotion_delay() - now()) / date_part('epoch', static_commander_promotion_delay()))  AS prestige

	FROM gm_commanders

	WHERE ownerid=_userid AND id=_commanderid;

	RETURN r_commander.prestige::integer;

END;$$;


ALTER FUNCTION ng03.internal_commander_get_prestige_cost_to_train(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: internal_commander_promote(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_commander_promote(_userid integer, _commanderid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE

	r_commander record;

BEGIN

	UPDATE gm_commanders SET

		salary_increases = salary_increases + 1,

		salary_last_increase = now(),

		points = points + 1

	WHERE id = _commanderid AND ownerid=_userid

	RETURNING INTO r_commander id, ownerid, name;

	IF FOUND THEN

		INSERT INTO gm_profile_reports(ownerid, type, subtype, commanderid, data)

		VALUES(r_commander.ownerid, 3, 20, r_commander.id, '{commander:' || tool_quote(r_commander.name) || '}');

		RETURN true;

	ELSE

		RETURN false;

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_commander_promote(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: internal_commander_update_salary(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_commander_update_salary(_userid integer, _commanderid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

	r_commanders record;

BEGIN

	UPDATE gm_commanders SET

		salary = 5000 + 

			(mod_production_ore-1.0)*10000 +

			(mod_production_hydrocarbon-1.0)*10000 +

			(mod_production_energy-1.0)*10000 +

			(mod_production_workers-1.0)*10000 +

			(mod_fleet_speed-1.0)*50000 +

			(mod_fleet_shield-1.0)*50000 +

			(mod_fleet_handling-1.0)*20000 +

			(mod_fleet_tracking_speed-1.0)*20000 +

			(mod_fleet_damage-1.0)*50000 +

			(mod_fleet_signature-1.0)*20000 +

			(mod_construction_speed_buildings-1.0)*20000 +

			(mod_construction_speed_ships-1.0)*50000

	WHERE ownerid=_userid AND id=_commanderid AND salary > 0

	RETURNING INTO r_commanders salary;

	IF FOUND THEN

		RETURN r_commanders.salary;

	ELSE

		RETURN 0;

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_commander_update_salary(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: internal_fleet_destroy_ship(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_destroy_ship(integer, integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: FleetId

-- Param2: ShipId

-- Param3: Quantity

DECLARE

	fleet record;

	ship record;

	cargo_lost int4;

	cargo_unused int4;

	new_cargo_capacity int4;

	p float;

	lost_ore int4;

	lost_hydrocarbon int4; 

	lost_scientists int4;

	lost_soldiers int4;

	lost_workers int4;

	tmp int4;

BEGIN

	-- retrieve fleet cargo info

	SELECT INTO fleet

		planetid,

		cargo_capacity, 

		cargo_ore+cargo_hydrocarbon+cargo_scientists+cargo_soldiers+cargo_workers AS cargo_used,

		cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers

	FROM gm_fleets

	WHERE id=$1 FOR UPDATE;

	cargo_unused := fleet.cargo_capacity - fleet.cargo_used;

	lost_ore := 0;

	lost_hydrocarbon := 0;

	lost_scientists := 0;

	lost_soldiers := 0;

	lost_workers := 0;

	-- there is something, we will have to compute how much is lost when we remove the ships

	SELECT INTO ship

		cost_ore, cost_hydrocarbon, capacity

	FROM dt_ships

	WHERE id=$2;

	-- check if there is something in the fleet cargo

	IF fleet.cargo_used > 0 THEN

		cargo_lost := ship.capacity*$3;

		cargo_lost := cargo_lost - cargo_unused;

		--RAISE NOTICE 'cargo lost: %', cargo_lost;

		IF cargo_lost > 0 THEN

			new_cargo_capacity := fleet.cargo_used - cargo_lost;

			--RAISE NOTICE 'new cargo: %', new_cargo_capacity;

			IF new_cargo_capacity = 0 THEN

				lost_ore := fleet.cargo_ore;

				lost_hydrocarbon := fleet.cargo_hydrocarbon;

				lost_scientists := fleet.cargo_scientists;

				lost_soldiers := fleet.cargo_soldiers;

				lost_workers := fleet.cargo_workers;

			ELSE

				-- compute percent of cargo lost

				p := 1.0 - (new_cargo_capacity / fleet.cargo_used);

				WHILE cargo_lost > 0 LOOP

					-- lost ore

					tmp := int4((random()*p)*(fleet.cargo_ore-lost_ore));

					tmp := LEAST(tmp, cargo_lost);

					lost_ore := lost_ore + tmp;

					cargo_lost := cargo_lost - tmp;

					--RAISE NOTICE 'ore %', lost_ore;

					-- lost hydrocarbon

					tmp := int4((random()*p)*(fleet.cargo_hydrocarbon-lost_hydrocarbon));

					tmp := LEAST(tmp, cargo_lost);

					lost_hydrocarbon := lost_hydrocarbon + tmp;

					cargo_lost := cargo_lost - tmp;

					--RAISE NOTICE 'hydro %', lost_hydrocarbon;

					-- lost scientists

					tmp := int4((random()*p)*(fleet.cargo_scientists-lost_scientists));

					tmp := LEAST(tmp, cargo_lost);

					lost_scientists := lost_scientists + tmp;

					cargo_lost := cargo_lost - tmp;

					-- lost soldiers

					tmp := int4((random()*p)*(fleet.cargo_soldiers-lost_soldiers));

					tmp := LEAST(tmp, cargo_lost);

					lost_soldiers := lost_soldiers + tmp;

					cargo_lost := cargo_lost - tmp;

					-- lost workers

					tmp := int4((random()*p)*(fleet.cargo_workers-lost_workers));

					tmp := LEAST(tmp, cargo_lost);

					lost_workers := lost_workers + tmp;

					cargo_lost := cargo_lost - tmp;

					--EXIT;

				END LOOP;

			END IF;

			--RAISE NOTICE 'cargo: % - lost: %', fleet.cargo_ore, lost_ore;

			UPDATE gm_fleets SET

				cargo_ore = cargo_ore - lost_ore,

				cargo_hydrocarbon = cargo_hydrocarbon - lost_hydrocarbon,

				cargo_scientists = cargo_scientists - lost_scientists,

				cargo_soldiers = cargo_soldiers - lost_soldiers,

				cargo_workers = cargo_workers - lost_workers

			WHERE id=$1;

		END IF;

	END IF;

	UPDATE gm_fleet_ships SET 

		quantity = GREATEST(0, quantity - $3)

	WHERE fleetid=$1 AND shipid=$2;

	UPDATE gm_planets SET

		orbit_ore = orbit_ore + lost_ore + int4(ship.cost_ore*$3*(0.35+0.10*random())),

		orbit_hydrocarbon = orbit_hydrocarbon + lost_hydrocarbon + int4(ship.cost_hydrocarbon*$3*(0.25+0.05*random()))

	WHERE id=fleet.planetid;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_fleet_destroy_ship(integer, integer, integer) OWNER TO exileng;

--
-- Name: internal_fleet_next_waypoint(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_next_waypoint(integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: FleetId

DECLARE

	r_fleet record;

	r_waypoint record;

	i int2;

BEGIN

	SELECT INTO r_fleet next_waypointid, action_end_time, planetid

	FROM gm_fleets

	WHERE ownerid=$1 AND id=$2 /*AND NOT engaged*/;

	IF NOT FOUND OR r_fleet.next_waypointid IS NULL OR r_fleet.action_end_time IS NOT NULL THEN

		-- fleet not found

		RETURN;

	END IF;

	-- retrieve info about the next waypoint

	SELECT INTO r_waypoint

		routeid, next_waypointid, "action", planetid, ore, hydrocarbon, scientists, soldiers, workers, waittime

	FROM gm_fleet_route_waypoints AS r

	WHERE r.id=r_fleet.next_waypointid;

	IF r_waypoint.action = 1 THEN

		-- move

		i := user_fleet_move($1, $2, r_waypoint.planetid);

		IF i <> 0 AND i <> -2 THEN

			--RAISE NOTICE 'move %/% to % : %', $1, $2, r_waypoint.planetid, i;

			-- not enough money or any other error

			-- make fleet wait a few minutes and retry later

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '10 minutes',

				next_waypointid = r_fleet.next_waypointid

			WHERE ownerid=$1 AND id=$2;

			RETURN;

		END IF;

	ELSEIF r_waypoint.action = 2 THEN

		-- recycle

		i := user_fleet_start_recycling($1, $2);

		IF i <> 0 THEN

			-- make fleet wait a few seconds and continue later

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '5 second'

			WHERE ownerid=$1 AND id=$2;

		END IF;

	ELSEIF r_waypoint.action = 0 THEN

		-- transfer resources

		PERFORM user_fleet_transfer_resources($1, $2, r_waypoint.ore, r_waypoint.hydrocarbon, r_waypoint.scientists, r_waypoint.soldiers, r_waypoint.workers);

		--RAISE NOTICE 'transfer % % % : %', $2, r_waypoint.ore, r_waypoint.hydrocarbon, i;

		-- Make the fleet wait xx minutes after this action

		IF r_waypoint.next_waypointid IS NOT NULL THEN

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '2 minutes'

			WHERE ownerid=$1 AND id=$2;

		END IF;

	ELSEIF r_waypoint.action = 4 THEN

		-- wait

		UPDATE gm_fleets SET

			action = 4,

			action_start_time = now(),

			action_end_time = now() + r_waypoint.waittime * INTERVAL '1 second',

			idle_since = now()

		WHERE ownerid=$1 AND id=$2;

	ELSEIF r_waypoint.action = 5 THEN

		-- invade

		i := user_fleet_invade($1, $2, 1000000);

		--RAISE NOTICE 'invade : %', i;

		-- Make the fleet wait xx minutes after this action

		IF r_waypoint.next_waypointid IS NOT NULL THEN

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '2 minutes'

			WHERE ownerid=$1 AND id=$2;

		END IF;

	ELSEIF r_waypoint.action = 6 THEN

		-- plunder planet resource

		i := sp_plunder_planet($1, $2);

		-- Make the fleet wait xx minutes after this action

		IF r_waypoint.next_waypointid IS NOT NULL THEN

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '2 minutes'

			WHERE ownerid=$1 AND id=$2;

		END IF;

	ELSEIF r_waypoint.action = 9 THEN

		IF r_waypoint.waittime IS NULL THEN

			r_waypoint.waittime := 8*60*60;

		END IF;

		-- go in hyperspace (null planet)

		UPDATE gm_fleets SET

			action = 1,

			action_start_time = now(),

			action_end_time = now() + r_waypoint.waittime * INTERVAL '1 second',

			dest_planetid=null,

			idle_since = now()

		WHERE ownerid=$1 AND id=$2;

	ELSEIF r_waypoint.action = -1 THEN

		PERFORM internal_planet_delete(r_fleet.planetid);

		-- Make the fleet wait xx minutes after this action

		IF r_waypoint.next_waypointid IS NOT NULL THEN

			UPDATE gm_fleets SET

				action = 4,

				action_start_time = now(),

				action_end_time = now() + INTERVAL '2 minutes'

			WHERE ownerid=$1 AND id=$2;

		END IF;

	END IF;

	UPDATE gm_fleet_routes SET last_used=now() WHERE id=r_waypoint.routeid;

	UPDATE gm_fleets SET

		next_waypointid=r_waypoint.next_waypointid

	WHERE ownerid=$1 AND id=$2;

END;$_$;


ALTER FUNCTION ng03.internal_fleet_next_waypoint(integer, integer) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_disappear(bigint, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_disappear(_routeid bigint, _seconds integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action", waittime)

	VALUES(waypointid, _routeid, 9, _seconds);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_disappear(_routeid bigint, _seconds integer) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_loadall(bigint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_loadall(_routeid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action", ore, hydrocarbon, scientists, soldiers, workers)

	VALUES(waypointid, _routeid, 0, 99999999, 99999999, 99999999, 99999999, 99999999);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_loadall(_routeid bigint) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_move(bigint, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_move(_routeid bigint, _planetid integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action", planetid)

	VALUES(waypointid, _routeid, 1, _planetid);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_move(_routeid bigint, _planetid integer) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_recycling(bigint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_recycling(_routeid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action")

	VALUES(waypointid, _routeid, 2);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_recycling(_routeid bigint) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_unloadall(bigint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_unloadall(_routeid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action", ore, hydrocarbon, scientists, soldiers, workers)

	VALUES(waypointid, _routeid, 0, -999999999, -999999999, -999999999, -999999999, -999999999);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_unloadall(_routeid bigint) OWNER TO exileng;

--
-- Name: internal_fleet_route_add_wait(bigint, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_route_add_wait(_routeid bigint, _seconds integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$DECLARE

	waypointid int8;

BEGIN

	waypointid := nextval('gm_fleet_route_waypoints_id_seq');

	INSERT INTO gm_fleet_route_waypoints(id, routeid, "action", waittime)

	VALUES(waypointid, _routeid, 4, _seconds);

	RETURN waypointid;

END;$$;


ALTER FUNCTION ng03.internal_fleet_route_add_wait(_routeid bigint, _seconds integer) OWNER TO exileng;

--
-- Name: internal_fleet_update_bonuses(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_update_bonuses(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$-- param1: Fleetid

DECLARE

	r_mod record;

	r_user record;

	r_fleet record;

BEGIN

	SELECT INTO r_fleet ownerid, commanderid, size-leadership AS size FROM gm_fleets WHERE id=$1;

	IF NOT FOUND THEN

		RETURN FALSE;

	END IF;

	-- special ships bonus

	SELECT INTO r_mod

		float8_mult(1.0 + mod_speed) AS speed,

		float8_mult(1.0 + mod_shield) AS shield,

		float8_mult(1.0 + mod_handling) AS handling,

		float8_mult(1.0 + mod_tracking_speed) AS tracking_speed,

		float8_mult(1.0 + mod_damage) AS damage,

		float8_mult(1.0 + mod_signature) AS signature,

		float8_mult(1.0 + mod_recycling) AS recycling

	FROM gm_fleet_ships

		INNER JOIN dt_ships ON dt_ships.id=gm_fleet_ships.shipid

	WHERE fleetid=$1;

	-- user research bonus

	SELECT INTO r_user

		mod_fleet_speed,

		mod_fleet_shield,

		mod_fleet_handling,

		mod_fleet_tracking_speed,

		mod_fleet_damage,

		mod_fleet_signature,

		mod_recycling

	FROM gm_profiles

	WHERE id=r_fleet.ownerid;

	-- commander bonus if any is assigned

	IF r_fleet.commanderid IS NOT NULL THEN

		SELECT INTO r_user

			r_user.mod_fleet_speed * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_speed) AS mod_fleet_speed,

			r_user.mod_fleet_shield * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_shield) AS mod_fleet_shield,

			r_user.mod_fleet_handling * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_handling) AS mod_fleet_handling,

			r_user.mod_fleet_tracking_speed * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_tracking_speed) AS mod_fleet_tracking_speed,

			r_user.mod_fleet_damage * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_damage) AS mod_fleet_damage,

			r_user.mod_fleet_signature * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_fleet_signature) AS mod_fleet_signature,

			r_user.mod_recycling * internal_commander_get_fleet_bonus_efficiency(r_fleet.size, mod_recycling) AS mod_recycling

		FROM gm_commanders

		WHERE id=r_fleet.commanderid;

	END IF;

	UPDATE gm_fleets SET

		mod_speed = 100*r_mod.speed*r_user.mod_fleet_speed,

		mod_shield = 100*r_mod.shield*r_user.mod_fleet_shield,

		mod_handling = 100*r_mod.handling*r_user.mod_fleet_handling,

		mod_tracking_speed = 100*r_mod.tracking_speed*r_user.mod_fleet_tracking_speed,

		mod_damage = 100*r_mod.damage*r_user.mod_fleet_damage,

		mod_recycling = r_mod.recycling*r_user.mod_recycling,

		mod_signature = r_mod.signature*r_user.mod_fleet_signature,

		signature = int4(real_signature/(r_mod.signature*r_user.mod_fleet_signature))

	WHERE id = $1;

	RETURN TRUE;

END;$_$;


ALTER FUNCTION ng03.internal_fleet_update_bonuses(integer) OWNER TO exileng;

--
-- Name: internal_fleet_update_data(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_update_data(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Update gm_fleets cargo capacity, signature, number of ships, max speed 

-- and if it is attackonsight (gm_fleets of only cargo are defensive only)

-- Param1: fleet id

DECLARE

	FleetExists bool;

BEGIN

	FleetExists := internal_fleet_update_stats($1);

	-- Update the fleet before trying to delete it so that constraints are checked

	IF FleetExists THEN

		PERFORM internal_fleet_update_bonuses($1);

	END IF;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_fleet_update_data(integer) OWNER TO exileng;

--
-- Name: internal_fleet_update_stats(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_fleet_update_stats(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$-- Param1: FleetId

DECLARE

	rec record;

BEGIN

	-- action 10 prevents update of the fleet stats (mainly used in merge)

	PERFORM 1 FROM gm_fleets WHERE id=$1 AND action<>10;

	IF NOT FOUND THEN

		RETURN FALSE;

	END IF;

	SELECT INTO rec

		COALESCE(sum(int8(dt_ships.weapon_ammo)*int8(dt_ships.weapon_turrets)*int8(dt_ships.weapon_power)), 0) as firepower,

		COALESCE(sum(int8(dt_ships.capacity)*int8(gm_fleet_ships.quantity)), 0) as capacity,

		COALESCE(sum(dt_ships.signature*gm_fleet_ships.quantity), 0) as signature,

		COALESCE(sum(CASE WHEN dt_ships.weapon_power > 0 THEN int8(dt_ships.signature)*int8(gm_fleet_ships.quantity) ELSE 0 END), 0) as military_signature,

		COALESCE(sum(dt_ships.recycler_output*gm_fleet_ships.quantity), 0) as recycler_output,

		COALESCE(sum(dt_ships.droppods*gm_fleet_ships.quantity), 0) as droppods,

		COALESCE(sum(dt_ships.long_distance_capacity*gm_fleet_ships.quantity), 0) as long_distance_capacity,

		COALESCE(sum(gm_fleet_ships.quantity), 0) as count,

		COALESCE(min(speed), 0) as speed,

		COALESCE(int8(sum(int8(cost_ore)*quantity)*static_ore_score() + sum(int8(cost_hydrocarbon)*quantity)*static_hydro_score() + sum(int8(cost_credits)*quantity) + sum(int8(crew)*quantity)*static_crew_score()), 0) as score,

		COALESCE(sum(int8(dt_ships.upkeep)*gm_fleet_ships.quantity), 0) as upkeep,

		COALESCE(max(required_vortex_strength), 0) as required_vortex_strength,

		COALESCE(sum(dt_ships.leadership*gm_fleet_ships.quantity), 0) AS leadership

	FROM gm_fleet_ships

		INNER JOIN dt_ships ON (gm_fleet_ships.shipid = dt_ships.id)

	WHERE gm_fleet_ships.fleetid = $1;

	UPDATE gm_fleets SET

		cargo_capacity = int4(rec.capacity),

		signature = int4(rec.signature*mod_signature),

		military_signature = rec.military_signature,

		real_signature = rec.signature,

		size = rec.count,

		speed = rec.speed,

		attackonsight = attackonsight AND rec.firepower > 0,

		firepower = rec.firepower,

		recycler_output = rec.recycler_output,

		droppods = rec.droppods,

		long_distance_capacity = rec.long_distance_capacity,

		score = rec.score,

		upkeep = rec.upkeep,

		required_vortex_strength = rec.required_vortex_strength,

		leadership = rec.leadership

	WHERE id = $1;

	IF rec.count = 0 THEN

		DELETE FROM gm_fleets WHERE id = $1;

	END IF;

	RETURN rec.count > 0;

END;$_$;


ALTER FUNCTION ng03.internal_fleet_update_stats(integer) OWNER TO exileng;

--
-- Name: internal_planet_can_build_on(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_can_build_on(integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql STABLE
    AS $_$-- Param1: PlanetId

-- Param2: BuildingId

-- Param3: OwnerId

BEGIN

/*

	PERFORM 1

	FROM gm_planet_buildings

	WHERE planetid=$1 AND buildingid=$2

	AND quantity + (SELECT int4(COALESCE(sum(*), 0)) FROM gm_planet_building_pendings WHERE planetid=$1 AND buildingid=$2) >= (SELECT construction_maximum FROM dt_buildings WHERE id=$2);

*/

	PERFORM 1

	WHERE COALESCE((SELECT quantity FROM gm_planet_buildings WHERE planetid=$1 AND buildingid=$2), 0) +

		COALESCE((SELECT count(id) FROM gm_planet_building_pendings WHERE planetid=$1 AND buildingid=$2), 0) >= (SELECT construction_maximum FROM dt_buildings WHERE id=$2);

	IF FOUND THEN

		-- maximum buildings of this type reached

		RETURN 1;

	END IF;

	PERFORM 1

	FROM dt_building_building_reqs 

	WHERE buildingid = $2 AND (required_buildingid NOT IN (SELECT buildingid FROM gm_planet_buildings WHERE planetid=$1 AND (quantity > 1 OR (quantity >= 1 AND destroy_datetime IS NULL))));

	IF FOUND THEN

		-- buildings requirements not met

		RETURN 2;

	END IF;

	PERFORM 1

	FROM dt_building_research_reqs

	WHERE buildingid = $2 AND (required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=$3 AND level >= required_researchlevel));

	IF FOUND THEN

		-- research requirements not met

		RETURN 3;

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.internal_planet_can_build_on(integer, integer, integer) OWNER TO exileng;

--
-- Name: internal_planet_check_for_battle(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_check_for_battle(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$-- Param1: PlanetId

BEGIN

	--RETURN FALSE;

	/*

	PERFORM 1

	FROM gm_fleets f

		INNER JOIN gm_fleets f2 ON (f.ownerid <> f2.ownerid AND (f.action <> -1 AND f.action <> 1 OR f.engaged) AND (f2.action <> -1 AND f2.action <> 1 OR f2.engaged))

	WHERE f.planetid = $1 AND f2.planetid=$1 AND ((internal_profile_get_relation(f.ownerid, f2.ownerid) = -2 AND (f.military_signature > 0 OR f2.military_signature > 0)) OR (internal_profile_get_relation(f.ownerid, f2.ownerid) IN (-2,-1) AND (f.attackonsight OR f2.attackonsight)))

	LIMIT 1

	FOR UPDATE;*/

	PERFORM 1

	FROM (SELECT DISTINCT ON (ownerid, action, military_signature > 0, engaged, attackonsight) * FROM gm_fleets WHERE planetid = $1) AS f

		INNER JOIN (SELECT DISTINCT ON (ownerid, action, military_signature > 0, engaged, attackonsight) * FROM gm_fleets WHERE planetid = $1) AS f2 ON (f.ownerid <> f2.ownerid AND (f.action <> -1 AND f.action <> 1 OR f.engaged) AND (f2.action <> -1 AND f2.action <> 1 OR f2.engaged))

	--WHERE ((f.military_signature > 0 OR f2.military_signature > 0) AND internal_profile_get_relation(f.ownerid, f2.ownerid) = -2) OR ((f.attackonsight OR f2.attackonsight) AND internal_profile_get_relation(f.ownerid, f2.ownerid) IN (-2,-1))

	WHERE (f.military_signature > 0 OR f2.military_signature > 0) AND (internal_profile_get_relation(f.ownerid, f2.ownerid) = -2 OR ((f.attackonsight OR f2.attackonsight) AND internal_profile_get_relation(f.ownerid, f2.ownerid) = -1))

	LIMIT 1;

	IF FOUND THEN

		--UPDATE gm_fleets SET engaged = false WHERE planetid=$1;

		UPDATE gm_fleets SET engaged = true/*, action=0*/ WHERE planetid=$1 AND action <> -1 AND action <> 1;

		UPDATE gm_planets SET next_battle = now() + '5 minutes' WHERE id=$1 AND next_battle IS NULL;

		RETURN TRUE;

	ELSE

		UPDATE gm_fleets SET engaged = false, action=4, action_end_time=now() WHERE engaged AND action=0 AND planetid=$1;

		UPDATE gm_fleets SET engaged = false WHERE engaged AND planetid=$1;

		UPDATE gm_planets SET next_battle = null WHERE id=$1 AND next_battle IS NOT NULL;

		RETURN FALSE;

	END IF;

END;$_$;


ALTER FUNCTION ng03.internal_planet_check_for_battle(integer) OWNER TO exileng;

--
-- Name: internal_planet_delete(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_delete(_planetid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN

	PERFORM internal_planet_reset(_planetid);

	UPDATE gm_planets SET

		floor = 0,

		planet_floor = 0,

		space = 0,

		planet_space = 0,

		spawn_ore = (40000 * (1.0 + random()))::integer,

		spawn_hydrocarbon = (40000 * (1.0 + random()))::integer

	WHERE id=_planetid;

END;$$;


ALTER FUNCTION ng03.internal_planet_delete(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_destroy_ships(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_destroy_ships(_planet_id integer, _ship_id integer, _quantity integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	total int8;

	q int4;

BEGIN

	IF _ship_id = 999 THEN

		RETURN;

	END IF;

	q := LEAST(int4(1 + (0.75+0.20*random())*_quantity), _quantity);

	UPDATE gm_planet_ships SET

		quantity = quantity - q

	WHERE planetid = _planet_id AND shipid = _ship_id AND quantity >= q;

	IF NOT FOUND THEN

		RETURN;

	END IF;

	SELECT INTO total (int8(q) * int8(dt_ships.cost_ore)) / 1000

	FROM dt_ships

	WHERE id=_ship_id;

	IF FOUND THEN

		INSERT INTO gm_planet_ships(planetid, shipid, quantity)

		VALUES(_planet_id, 999, total);

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_planet_destroy_ships(_planet_id integer, _ship_id integer, _quantity integer) OWNER TO exileng;

--
-- Name: internal_planet_find_nearest(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_find_nearest(integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $_$-- Param1: PlanetId from where to search

DECLARE

	r_planet record;

	res int4;

BEGIN

	SELECT INTO r_planet galaxy, sector, planet FROM gm_planets WHERE id=$1;

	SELECT INTO res id

	FROM gm_planets

	WHERE galaxy=r_planet.galaxy AND floor > 0 AND space > 0

	ORDER BY tool_compute_distance(sector,planet,r_planet.sector,r_planet.planet) ASC

	LIMIT 1;

	IF FOUND THEN

		RETURN res;

	END IF;

	RETURN -1;

END;$_$;


ALTER FUNCTION ng03.internal_planet_find_nearest(integer) OWNER TO exileng;

--
-- Name: internal_planet_find_nearest(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_find_nearest(integer, integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $_$-- Param1: UserId

-- Param2: PlanetId from where to search

DECLARE

	r_planet record;

	res int4;

BEGIN

	SELECT INTO r_planet galaxy, sector, planet FROM gm_planets WHERE id=$2;

	SELECT INTO res id

	FROM gm_planets

	WHERE ownerid=$1 AND galaxy=r_planet.galaxy AND floor > 0 AND space > 0

	ORDER BY tool_compute_distance(sector,planet,r_planet.sector,r_planet.planet) ASC

	LIMIT 1;

	IF FOUND THEN

		RETURN res;

	END IF;

	-- otherwise try to return an uninhabited planet

	SELECT INTO res id

	FROM gm_planets

	WHERE ownerid IS NULL AND galaxy=r_planet.galaxy AND NOT sector IN (0, 1,2,3,4,5,6,7,8,9, 10, 11, 20, 21, 30, 31, 40, 41, 50, 51, 60, 61, 70, 71, 80, 81, 90, 91)

	ORDER BY tool_compute_distance(sector,planet,r_planet.sector,r_planet.planet) ASC

	LIMIT 1;

	IF FOUND THEN

		RETURN res;

	END IF;

	RETURN -1;

END;$_$;


ALTER FUNCTION ng03.internal_planet_find_nearest(integer, integer) OWNER TO exileng;

--
-- Name: dt_buildings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.dt_buildings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.dt_buildings_id_seq OWNER TO exileng;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dt_buildings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_buildings (
    id integer DEFAULT nextval('ng03.dt_buildings_id_seq'::regclass) NOT NULL,
    category smallint DEFAULT 1 NOT NULL,
    name character varying(32) DEFAULT 'name'::character varying NOT NULL,
    label character varying(64) DEFAULT 'label'::character varying NOT NULL,
    description text DEFAULT 'description here'::text NOT NULL,
    cost_ore integer DEFAULT 0 NOT NULL,
    cost_hydrocarbon integer DEFAULT 0 NOT NULL,
    cost_credits integer DEFAULT 0 NOT NULL,
    workers integer DEFAULT 0 NOT NULL,
    energy_consumption integer DEFAULT 0 NOT NULL,
    energy_production integer DEFAULT 0 NOT NULL,
    floor smallint DEFAULT 1 NOT NULL,
    space smallint DEFAULT 0 NOT NULL,
    production_ore integer DEFAULT 0 NOT NULL,
    production_hydrocarbon integer DEFAULT 0 NOT NULL,
    storage_ore integer DEFAULT 0 NOT NULL,
    storage_hydrocarbon integer DEFAULT 0 NOT NULL,
    storage_workers integer DEFAULT 0 NOT NULL,
    construction_maximum smallint DEFAULT 1 NOT NULL,
    construction_time integer DEFAULT 3600 NOT NULL,
    destroyable boolean DEFAULT true NOT NULL,
    mod_production_ore real DEFAULT 0 NOT NULL,
    mod_production_hydrocarbon real DEFAULT 0 NOT NULL,
    mod_production_energy real DEFAULT 0 NOT NULL,
    mod_production_workers real DEFAULT 0 NOT NULL,
    mod_construction_speed_buildings real DEFAULT 0 NOT NULL,
    mod_construction_speed_ships real DEFAULT 0 NOT NULL,
    storage_scientists integer DEFAULT 0 NOT NULL,
    storage_soldiers integer DEFAULT 0 NOT NULL,
    radar_strength smallint DEFAULT 0 NOT NULL,
    radar_jamming smallint DEFAULT 0 NOT NULL,
    is_planet_element boolean DEFAULT false NOT NULL,
    can_be_disabled boolean DEFAULT false NOT NULL,
    training_scientists integer DEFAULT 0 NOT NULL,
    training_soldiers integer DEFAULT 0 NOT NULL,
    maintenance_factor smallint DEFAULT 1 NOT NULL,
    security_factor smallint DEFAULT 1 NOT NULL,
    sandworm_activity smallint DEFAULT 0 NOT NULL,
    seismic_activity smallint DEFAULT 0 NOT NULL,
    production_credits integer DEFAULT 0 NOT NULL,
    production_credits_random integer DEFAULT 0 NOT NULL,
    mod_research_effectiveness real DEFAULT 0 NOT NULL,
    energy_receive_antennas smallint DEFAULT 0 NOT NULL,
    energy_send_antennas smallint DEFAULT 0 NOT NULL,
    construction_time_exp_per_building real DEFAULT 1 NOT NULL,
    storage_energy integer DEFAULT 0 NOT NULL,
    buildable boolean DEFAULT false NOT NULL,
    lifetime integer DEFAULT 0 NOT NULL,
    active_when_destroying boolean DEFAULT false NOT NULL,
    upkeep integer DEFAULT 0 NOT NULL,
    cost_energy integer DEFAULT 0 NOT NULL,
    use_planet_production_pct boolean DEFAULT true NOT NULL,
    production_exp_per_building real,
    consumption_exp_per_building real,
    vortex_strength integer DEFAULT 0 NOT NULL,
    production_prestige integer DEFAULT 0 NOT NULL,
    cost_prestige integer DEFAULT 0 NOT NULL,
    mod_planet_need_ore real DEFAULT 0 NOT NULL,
    mod_planet_need_hydrocarbon real DEFAULT 0 NOT NULL,
    bonus_planet_need_ore integer DEFAULT 0 NOT NULL,
    bonus_planet_need_hydrocarbon integer DEFAULT 0 NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    invasion_defense integer DEFAULT 0 NOT NULL,
    parked_ships_capacity integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.dt_buildings OWNER TO exileng;

--
-- Name: internal_planet_get_available_buildings(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_get_available_buildings(integer) RETURNS SETOF ng03.dt_buildings
    LANGUAGE sql STABLE
    AS $_$-- param1: user id

	-- list all buildings that can be built

	-- a building can be built if it meet the requirement :

	-- if it depends on other buildings, these buildings must be built on the planet

	-- if it depends on gm_profile_researches, these gm_profile_researches must be done

	SELECT DISTINCT *

	FROM dt_buildings

	WHERE buildable AND

	(

	NOT EXISTS

		(SELECT required_buildingid

		FROM dt_building_building_reqs 

		WHERE (buildingid = dt_buildings.id) AND (required_buildingid NOT IN (SELECT buildingid FROM gm_planets, gm_planet_buildings WHERE gm_planets.id = gm_planet_buildings.planetid AND gm_planets.ownerid = $1)))

	AND

	NOT EXISTS

		(SELECT required_researchid, required_researchlevel

		FROM dt_building_research_reqs 

		WHERE (buildingid = dt_buildings.id) AND (required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=$1 AND level >= required_researchlevel)))

	)

	OR (SELECT count(*) FROM gm_planet_buildings INNER JOIN gm_planets ON (gm_planets.id=gm_planet_buildings.planetid) WHERE ownerid=$1 AND gm_planet_buildings.buildingid=dt_buildings.id LIMIT 1) > 0

	ORDER BY category, id;$_$;


ALTER FUNCTION ng03.internal_planet_get_available_buildings(integer) OWNER TO exileng;

--
-- Name: dt_ships_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.dt_ships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.dt_ships_id_seq OWNER TO exileng;

--
-- Name: dt_ships; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_ships (
    id integer DEFAULT nextval('ng03.dt_ships_id_seq'::regclass) NOT NULL,
    category smallint DEFAULT 1,
    name character varying(32) NOT NULL,
    label character varying(64) DEFAULT 'label'::character varying NOT NULL,
    description text DEFAULT 'description'::text NOT NULL,
    cost_ore integer DEFAULT 0 NOT NULL,
    cost_hydrocarbon integer DEFAULT 0 NOT NULL,
    cost_credits integer DEFAULT 0 NOT NULL,
    workers integer DEFAULT 0 NOT NULL,
    crew smallint DEFAULT 10 NOT NULL,
    capacity integer DEFAULT 1 NOT NULL,
    construction_time integer DEFAULT 180 NOT NULL,
    maximum smallint DEFAULT 0 NOT NULL,
    hull integer DEFAULT 100 NOT NULL,
    shield integer DEFAULT 0 NOT NULL,
    weapon_power smallint DEFAULT 0 NOT NULL,
    weapon_ammo smallint DEFAULT 0 NOT NULL,
    weapon_tracking_speed smallint DEFAULT 0 NOT NULL,
    weapon_turrets smallint DEFAULT 0 NOT NULL,
    signature smallint DEFAULT 0 NOT NULL,
    speed integer DEFAULT 1000 NOT NULL,
    handling smallint DEFAULT 10 NOT NULL,
    buildingid integer,
    recycler_output integer DEFAULT 0 NOT NULL,
    droppods smallint DEFAULT 0 NOT NULL,
    long_distance_capacity smallint DEFAULT 0 NOT NULL,
    buildable boolean DEFAULT false NOT NULL,
    required_shipid integer,
    new_shipid integer,
    mod_speed real DEFAULT 0 NOT NULL,
    mod_shield real DEFAULT 0 NOT NULL,
    mod_handling real DEFAULT 0 NOT NULL,
    mod_tracking_speed real DEFAULT 0 NOT NULL,
    mod_damage real DEFAULT 0 NOT NULL,
    mod_signature real DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 0 NOT NULL,
    protection integer DEFAULT 0 NOT NULL,
    upkeep integer DEFAULT 0 NOT NULL,
    cost_energy integer DEFAULT 0 NOT NULL,
    weapon_dmg_em smallint DEFAULT 0 NOT NULL,
    weapon_dmg_explosive smallint DEFAULT 0 NOT NULL,
    weapon_dmg_kinetic smallint DEFAULT 0 NOT NULL,
    weapon_dmg_thermal smallint DEFAULT 0 NOT NULL,
    resist_em smallint DEFAULT 0 NOT NULL,
    resist_explosive smallint DEFAULT 0 NOT NULL,
    resist_kinetic smallint DEFAULT 0 NOT NULL,
    resist_thermal smallint DEFAULT 0 NOT NULL,
    tech smallint DEFAULT 0 NOT NULL,
    prestige_reward integer DEFAULT 0 NOT NULL,
    credits_reward integer DEFAULT 0 NOT NULL,
    cost_prestige integer DEFAULT 0 NOT NULL,
    built_per_batch integer DEFAULT 1 NOT NULL,
    bounty integer DEFAULT 0 NOT NULL,
    required_vortex_strength integer DEFAULT 0 NOT NULL,
    leadership integer DEFAULT 0 NOT NULL,
    can_be_parked boolean DEFAULT true NOT NULL,
    required_jump_capacity integer DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.dt_ships OWNER TO exileng;

--
-- Name: internal_planet_get_available_ships(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_get_available_ships(integer) RETURNS SETOF ng03.dt_ships
    LANGUAGE sql STABLE
    AS $_$-- param1: user id

	-- list all ships that can be built

	-- a ship can be built if it meet the requirement :

	-- if it depends on gm_profile_researches, these gm_profile_researches must be done

	SELECT DISTINCT *

	FROM dt_ships

	WHERE

	buildable and NOT EXISTS

		(SELECT required_researchid, required_researchlevel

		FROM dt_ship_research_reqs 

		WHERE (shipid = dt_ships.id) AND (required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=$1 AND level >= required_researchlevel)))

	ORDER BY category, id;$_$;


ALTER FUNCTION ng03.internal_planet_get_available_ships(integer) OWNER TO exileng;

--
-- Name: internal_planet_get_blocus_strength(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_get_blocus_strength(_planetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	r_planet record;

BEGIN

	-- check if it hasn't been computed already

	SELECT INTO r_planet ownerid, blocus_strength FROM gm_planets WHERE id=$1;

	IF FOUND AND r_planet.blocus_strength IS NOT NULL THEN

		RETURN r_planet.blocus_strength;

	END IF;

	IF NOT FOUND THEN

		RETURN 0;

	END IF;

	-- compute how many enemy military gm_fleets there are near this planet

	SELECT INTO r_planet

		int4(sum(military_signature) / 100) AS blocus_strength

	FROM gm_fleets

	WHERE planetid=$1 AND attackonsight AND action <> -1 AND action <> 1 AND firepower > 0 AND NOT EXISTS(SELECT 1 FROM vw_gm_friends WHERE userid=r_planet.ownerid AND friend=gm_fleets.ownerid);

	IF r_planet.blocus_strength IS NULL THEN

		r_planet.blocus_strength := 0;

	END IF;

	-- update planet blocus strength

	UPDATE gm_planets SET

		blocus_strength = r_planet.blocus_strength

	WHERE id=$1;

	RETURN r_planet.blocus_strength;

END;$_$;


ALTER FUNCTION ng03.internal_planet_get_blocus_strength(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_get_name(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_get_name(_userid integer, _planetid integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

BEGIN

	SELECT INTO r_planet ownerid, name, galaxy, sector FROM gm_planets WHERE id=_planetid;

	IF r_planet.ownerid = _userid THEN

		RETURN r_planet.name;

	END IF;

	IF internal_profile_get_relation(r_planet.ownerid, _userid) >= 0 THEN

		RETURN internal_profile_get_name(r_planet.ownerid);

	END IF;

	IF internal_profile_get_sector_radar_strength(_userid, r_planet.galaxy, r_planet.sector) > 0 THEN

		RETURN internal_profile_get_name(r_planet.ownerid);

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.internal_planet_get_name(_userid integer, _planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_get_profile_id(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_get_profile_id(integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$-- return the ownerid of given planet id

-- Param1: planet id

SELECT ownerid FROM gm_planets WHERE id=$1 LIMIT 1;$_$;


ALTER FUNCTION ng03.internal_planet_get_profile_id(integer) OWNER TO exileng;

--
-- Name: internal_planet_next_ship_pending(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_next_ship_pending(_planetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: planet id

DECLARE

	r_planet record;

	r_pending record;

	r_ship record;

	to_wait interval;

	p_id int4;

BEGIN

	LOOP

	BEGIN

		-- check if any ship is being built/recycled

		PERFORM 1

		FROM gm_planet_ship_pendings

		WHERE planetid=_planetid AND end_time IS NOT NULL;

		IF FOUND THEN

			RETURN 0;

		END IF;

		-- remove shipyard_next_continue timestamp

		UPDATE gm_planets SET

			shipyard_next_continue = NULL

		WHERE id=_planetid AND NOT shipyard_suspended;

		IF NOT FOUND THEN

			RETURN 0;

		END IF;

		-- select next ship to build/recycle from pending list

		SELECT INTO r_pending

			id, shipid, quantity, recycle, take_resources

		FROM gm_planet_ship_pendings

		WHERE planetid=_planetid AND end_time IS NULL

		ORDER BY start_time, id LIMIT 1 FOR UPDATE;

		IF FOUND THEN

			SELECT INTO r_ship

				construction_time, cost_ore, cost_hydrocarbon, cost_energy, 0 AS cost_credits, crew, required_shipid, cost_prestige

			FROM vw_gm_planet_ships

			WHERE planetid=_planetid AND id=r_pending.shipid;

			IF r_pending.recycle THEN

				r_ship.construction_time := int4(static_planet_ship_recycling_coeff() * r_ship.construction_time);

				UPDATE gm_planet_ships SET

					quantity = quantity - 1

				WHERE planetid=_planetid AND shipid=r_pending.shipid AND quantity >= 1;

				IF NOT FOUND THEN

					RAISE EXCEPTION 'no ship to recycle';

				END IF;

			ELSEIF r_pending.take_resources THEN

				PERFORM internal_planet_update_production_date(_planetid);

				SELECT INTO r_planet ownerid,

					ore, ore_production, ore_capacity,

					hydrocarbon, hydrocarbon_production, hydrocarbon_capacity,

					energy, energy_production - energy_consumption AS energy_production, energy_capacity,

					workers, workers_busy, workers_capacity, mod_production_workers

				FROM gm_planets

				WHERE id=_planetid;

				IF r_planet.ore >= r_ship.cost_ore AND r_planet.hydrocarbon >= r_ship.cost_hydrocarbon AND r_planet.energy >= r_ship.cost_energy AND (r_planet.workers-r_planet.workers_busy) >= r_ship.crew THEN

					UPDATE gm_planets SET

						ore=ore - r_ship.cost_ore,

						hydrocarbon=hydrocarbon - r_ship.cost_hydrocarbon,

						energy=energy - r_ship.cost_energy,

						workers=workers - r_ship.crew

					WHERE id=_planetid;

					IF r_ship.cost_credits > 0 OR r_ship.cost_prestige > 0 THEN

						UPDATE gm_profiles SET

							credits=credits-r_ship.cost_credits,

							prestige_points=prestige_points-r_ship.cost_prestige

						WHERE id=r_planet.ownerid AND prestige_points >= r_ship.cost_prestige;

						IF NOT FOUND THEN

							RAISE EXCEPTION 'Not enough prestige';

						END IF;

					END IF;

				ELSE

					to_wait := INTERVAL '-1 hour';

					IF (r_planet.ore < r_ship.cost_ore AND r_planet.ore_production > 0) THEN

						to_wait := GREATEST(to_wait, (float8(r_ship.cost_ore) - r_planet.ore) / r_planet.ore_production * INTERVAL '1 hour');

					END IF;

					IF (r_planet.hydrocarbon < r_ship.cost_hydrocarbon AND r_planet.hydrocarbon_production > 0) THEN

						to_wait := GREATEST(to_wait, (float8(r_ship.cost_hydrocarbon) - r_planet.hydrocarbon) / r_planet.hydrocarbon_production * INTERVAL '1 hour');

					END IF;

					IF (r_planet.energy < r_ship.cost_energy AND r_planet.energy_production > 0) THEN

						to_wait := GREATEST(to_wait, (float8(r_ship.cost_energy) - r_planet.energy) / r_planet.energy_production * INTERVAL '1 hour');

					END IF;

					IF r_planet.workers < r_ship.crew AND r_planet.workers*r_planet.mod_production_workers/100 > 0 THEN

						to_wait := GREATEST(to_wait, (float8(r_ship.crew) - r_planet.workers) / (r_planet.workers*r_planet.mod_production_workers/100) * INTERVAL '1 hour');

					END IF;

					IF to_wait = INTERVAL '-1 hour' THEN

						to_wait := INTERVAL '24 hours';

					END IF;

					UPDATE gm_planets SET shipyard_next_continue = now() + to_wait WHERE id=_planetid;

					RETURN 0;

				END IF;

				IF r_ship.required_shipid IS NOT NULL THEN

					UPDATE gm_planet_ships SET

						quantity = quantity - 1

					WHERE planetid=_planetid AND shipid=r_ship.required_shipid AND quantity >= 1;

					IF NOT FOUND THEN

						RAISE EXCEPTION 'not enough required ship';

					END IF;

				END IF;

			END IF;

			-- extract one ship from the pending ship list

			IF r_pending.quantity > 1 THEN

				UPDATE gm_planet_ship_pendings SET quantity = quantity - 1 WHERE id=r_pending.id;

			ELSE

				DELETE FROM gm_planet_ship_pendings WHERE id=r_pending.id;

			END IF;

			-- insert the ship to be built/recycled into the pending list

			SELECT INTO p_id COALESCE(min(id)-1, 1) FROM gm_planet_ship_pendings;

			IF FOUND AND p_id > 0 THEN

				BEGIN

					INSERT INTO gm_planet_ship_pendings(id, planetid, shipid, start_time, end_time, recycle)

					VALUES(p_id, _planetid, r_pending.shipid, now(), now() + r_ship.construction_time * INTERVAL '1 second', r_pending.recycle);

				EXCEPTION

					WHEN OTHERS THEN

						p_id := 0;

				END;

			END IF;

			IF p_id <= 0 THEN

				INSERT INTO gm_planet_ship_pendings(planetid, shipid, start_time, end_time, recycle)

				VALUES(_planetid, r_pending.shipid, now(), now() + r_ship.construction_time * INTERVAL '1 second', r_pending.recycle);

			END IF;

		END IF;

		RETURN 0;

	EXCEPTION

		WHEN RAISE_EXCEPTION THEN

			PERFORM user_planet_ship_cancel(_planetid, r_pending.id);

		WHEN CHECK_VIOLATION THEN

			--UPDATE gm_planets SET shipyard_next_continue=

			RETURN 0;

	END;

	END LOOP;

END;$$;


ALTER FUNCTION ng03.internal_planet_next_ship_pending(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_next_training(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_next_training(_planetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: planet id

DECLARE

	r_pending record;

	r_training record;

	r_planet record;

BEGIN

	LOOP

	BEGIN

		-- check if any training is being done

		SELECT INTO r_training

			COALESCE(sum(scientists), 0) AS scientists,

			COALESCE(sum(soldiers), 0) AS soldiers

		FROM gm_planet_trainings

		WHERE planetid=_planetid AND end_time IS NOT NULL;

		IF FOUND AND r_training.scientists > 0 AND r_training.soldiers > 0 THEN

			RETURN 0;

		END IF;

		-- retrieve how much we can train every "batch"

		SELECT INTO r_planet

			GREATEST(0, LEAST(scientists_capacity-scientists, training_scientists)) AS training_scientists,

			GREATEST(0, LEAST(soldiers_capacity-soldiers, training_soldiers)) AS training_soldiers

		FROM gm_planets

		WHERE id=_planetid;

		IF r_training.scientists = 0 THEN

			-- delete any scientists we have to train in queue if we can't train them

			IF r_planet.training_scientists = 0 THEN

				PERFORM user_planet_training_cancel(_planetid, id)

				FROM gm_planet_trainings

				WHERE planetid=_planetid AND scientists > 0;

			ELSE

				-- see how many scientists there are to train

				SELECT INTO r_pending

					id, scientists

				FROM gm_planet_trainings

				WHERE planetid=_planetid AND end_time IS NULL AND scientists > 0

				ORDER BY start_time LIMIT 1 FOR UPDATE;

				IF FOUND THEN

					IF r_pending.scientists > r_planet.training_scientists THEN

						UPDATE gm_planet_trainings SET

							scientists = GREATEST(0, scientists - r_planet.training_scientists)

						WHERE id=r_pending.id;

						r_pending.scientists := r_planet.training_scientists;

					ELSE

						DELETE FROM gm_planet_trainings WHERE id=r_pending.id;

					END IF;

					-- insert the training to be done into the pending list

					INSERT INTO gm_planet_trainings(planetid, scientists, start_time, end_time)

					VALUES(_planetid, r_pending.scientists, now(), now() + INTERVAL '1 hour');

				END IF;

			END IF;

		END IF;

		IF r_training.soldiers = 0 THEN

			-- delete any soldiers we have to train in queue if we can't train them

			IF r_planet.training_soldiers = 0 THEN

				PERFORM user_planet_training_cancel(_planetid, id)

				FROM gm_planet_trainings

				WHERE planetid=_planetid AND soldiers > 0;

			ELSE

				-- see how many soldiers there are to train

				SELECT INTO r_pending

					id, soldiers

				FROM gm_planet_trainings

				WHERE planetid=_planetid AND end_time IS NULL AND soldiers > 0

				ORDER BY start_time LIMIT 1 FOR UPDATE;

				IF FOUND THEN

					IF r_pending.soldiers > r_planet.training_soldiers THEN

						UPDATE gm_planet_trainings SET

							soldiers = GREATEST(0, soldiers - r_planet.training_soldiers)

						WHERE id=r_pending.id;

						r_pending.soldiers := r_planet.training_soldiers;

					ELSE

						DELETE FROM gm_planet_trainings WHERE id=r_pending.id;

					END IF;

					-- insert the training to be done into the pending list

					INSERT INTO gm_planet_trainings(planetid, soldiers, start_time, end_time)

					VALUES(_planetid, r_pending.soldiers, now(), now() + INTERVAL '1 hour');

				END IF;

			END IF;

		END IF;

		RETURN 0;

	EXCEPTION

		WHEN RAISE_EXCEPTION THEN

			PERFORM user_planet_training_cancel(_planetid, r_pending.id);

	END;

	END LOOP;

END;$$;


ALTER FUNCTION ng03.internal_planet_next_training(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_reset(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_reset(integer) RETURNS void
    LANGUAGE sql
    AS $_$-- Param1: PlanetId

DELETE FROM gm_planet_building_pendings WHERE planetid=$1;

DELETE FROM gm_planet_ship_pendings WHERE planetid=$1;

DELETE FROM gm_planet_energy_transfers WHERE planetid=$1 OR target_planetid=$1;

UPDATE gm_planets SET

	name = '',

	ore = 0,

	hydrocarbon = 0,

	workers = 0,

	workers_busy = 0,

	scientists = 0,

	soldiers = 0,

	ore_production = 0,

	hydrocarbon_production = 0,

	production_lastupdate = now(),

	colonization_datetime = NULL,

	buy_ore=0,

	buy_hydrocarbon=0

WHERE id = $1;

DELETE FROM gm_planet_buildings USING dt_buildings

WHERE (planetid = $1) AND buildingid = dt_buildings.id AND NOT dt_buildings.is_planet_element;

DELETE FROM gm_planet_ships WHERE planetid=$1;

UPDATE gm_planets SET

	ownerid = null,

	commanderid = null

WHERE id = $1;$_$;


ALTER FUNCTION ng03.internal_planet_reset(integer) OWNER TO exileng;

--
-- Name: internal_planet_start_electromagnetic_storm(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_start_electromagnetic_storm(integer, integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Add an electromagnetic storm to the planet

-- Param1: UserId (if null, planet owner is taken)

-- Param2: PlanetId

-- Param3: Duration in hours (if null, random duration is computed)

DECLARE

	duration int4;

	planet_ownerid int4;

BEGIN

	IF $3 IS NULL THEN

		duration := int4((8 + random()*3.5)*3600);

	ELSE

		duration := $3*3600;

	END IF;

	-- insert the special building

	INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

	VALUES($2, 91, 1, now()+duration*INTERVAL '1 second');

	IF $1 IS NULL THEN

		SELECT INTO planet_ownerid ownerid FROM gm_planets WHERE id=$2;

	ELSE

		planet_ownerid := $1;

	END IF;

	-- UPDATE planet last_catastrophe

	UPDATE gm_planets SET last_catastrophe = now() WHERE id = $2;

	-- UPDATE user last_catastrophe

	IF planet_ownerid IS NOT NULL THEN

		UPDATE gm_profiles SET last_catastrophe = now() WHERE id = planet_ownerid;

	END IF;

	-- create the begin and end gm_profile_reports

	IF planet_ownerid IS NOT NULL THEN

		INSERT INTO gm_profile_reports(datetime, ownerid, type, subtype, planetid) VALUES(now(), planet_ownerid, 7, 10, $2);

		INSERT INTO gm_profile_reports(datetime, ownerid, type, subtype, planetid) VALUES(now()+duration*INTERVAL '1 second', planet_ownerid, 7, 11, $2);

	END IF;

END;$_$;


ALTER FUNCTION ng03.internal_planet_start_electromagnetic_storm(integer, integer, integer) OWNER TO exileng;

--
-- Name: internal_planet_stop_all_buildings(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_stop_all_buildings(integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: PlanetId

DECLARE

	r_planet record;

BEGIN

	PERFORM user_planet_building_cancel($1, $2, buildingid)

	FROM gm_planet_building_pendings

	WHERE planetid=$2;

--	SELECT INTO r_planet scientists, workers, workers_busy FROM gm_planets WHERE id=$2;

--	RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

	UPDATE gm_planet_buildings SET

		destroy_datetime=NULL

	WHERE planetid=$2 AND NOT (SELECT lifetime > 0 OR is_planet_element OR NOT buildable FROM dt_buildings WHERE id=buildingid);

	PERFORM internal_planet_update_data($2);

--	SELECT INTO r_planet scientists, workers, workers_busy FROM gm_planets WHERE id=$2;

--	RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_planet_stop_all_buildings(integer, integer) OWNER TO exileng;

--
-- Name: internal_planet_stop_all_ships(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_stop_all_ships(_userid integer, _planetid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

-- Param2: PlanetId

BEGIN

	PERFORM user_planet_ship_cancel(_planetid, id)

	FROM gm_planet_ship_pendings

	WHERE planetid=_planetid;

	RETURN;

END;$$;


ALTER FUNCTION ng03.internal_planet_stop_all_ships(_userid integer, _planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_update_building_pendings_time(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_update_building_pendings_time(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: PlanetId

DECLARE

	total_time int4;

	r_pending gm_planet_building_pendings;

	pct float8;

BEGIN

	-- when a buildings speed bonus change, construction times have to be recalculated

	-- update buildings construction time

	FOR r_pending IN

		SELECT * FROM gm_planet_building_pendings WHERE planetid=$1 FOR UPDATE

	LOOP

		-- compute percentage of building done

		IF r_pending.end_time > r_pending.start_time THEN

			pct := date_part('epoch', r_pending.end_time - now()) / date_part('epoch', r_pending.end_time - r_pending.start_time);

		ELSE

			pct := 1;

		END IF;

		-- retrieve building time

		SELECT INTO total_time int4(construction_time)

		FROM vw_gm_planet_buildings WHERE planetid=$1 AND id=r_pending.buildingid;

		UPDATE gm_planet_building_pendings SET start_time=now()-((1-pct)*total_time*INTERVAL '1 second'), end_time = now() + pct*total_time*INTERVAL '1 second' WHERE id=r_pending.id;

	END LOOP;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_planet_update_building_pendings_time(integer) OWNER TO exileng;

--
-- Name: internal_planet_update_data(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_update_data(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- update planet data

-- param1: planet id

DECLARE

	r_pending record;

	r_pending_ship record;

	r_commander record;

	r_buildings record;

	r_research record;

	r_planet record;

	r_energy_received record;

	r_energy_sent record;

	b_production_ore real;

	b_production_hydrocarbon real;

	b_production_energy real;

	b_production_workers real;

	b_building_construction_speed real;

	b_ship_construction_speed real;

	b_research_effectiveness real;

	mod_energy float;

	energy_produced int4;

	energy_used int4;

BEGIN

	SELECT INTO r_planet

		ownerid,

		commanderid,

		int8(LEAST(energy + (energy_production-energy_consumption) * date_part('epoch', now()-production_lastupdate)/3600.0, energy_capacity)) AS energy,

		pct_ore,

		pct_hydrocarbon

	FROM gm_planets

	WHERE id=$1 AND NOT production_frozen;

	IF NOT FOUND THEN

		--RAISE NOTICE 'internal_planet_update_data : planet % not found', $1;

		RETURN;

	END IF;

	-- compute how much floor, space, energy is used by buildings being built

	SELECT INTO r_pending

		COALESCE( sum( CASE WHEN floor > 0 THEN floor ELSE 0 END ), 0) AS floor,

		COALESCE( sum( CASE WHEN space > 0 THEN space ELSE 0 END ), 0) AS space,

		COALESCE( sum( energy_consumption ), 0) AS energy_consumption,

		COALESCE( sum( workers ), 0) AS workers,

		COALESCE( sum(cost_ore)*static_ore_score() + sum(cost_hydrocarbon)*static_hydro_score() + sum(cost_credits), 0) AS score

	FROM gm_planet_building_pendings

		LEFT JOIN dt_buildings ON (gm_planet_building_pendings.buildingid = dt_buildings.id)

	WHERE gm_planet_building_pendings.planetid=$1;

	-- how many workers and energy is used by ships being built

	SELECT INTO r_pending_ship

		COALESCE( sum( workers ), 0) AS workers

	FROM gm_planet_ship_pendings

		LEFT JOIN dt_ships ON (gm_planet_ship_pendings.shipid = dt_ships.id)

	WHERE gm_planet_ship_pendings.planetid=$1 AND NOT end_time IS NULL;

	-- compute how much floor, space, energy is used by buildings and

	-- capacities of ore, hydrocarbon, energy and workers and

	-- production of ore, hydrocarbon and energy

	-- retrieve also the buildings mods (bonus)

	SELECT INTO r_buildings

		COALESCE( sum( cost_ore*quantity)*static_ore_score() + sum(cost_hydrocarbon*quantity)*static_hydro_score(), 0) AS score,

		COALESCE( sum( CASE WHEN destroy_datetime IS NOT NULL THEN workers / 2 ELSE 0 END ), 0) AS busy_workers, -- when destroying a building, half the workers are needed

		COALESCE( sum( quantity * CASE WHEN floor > 0 THEN floor ELSE 0 END ), 0) AS floor,

		COALESCE( sum( quantity * CASE WHEN space > 0 THEN space ELSE 0 END ), 0) AS space,

		COALESCE( sum( quantity * CASE WHEN floor < 0 THEN -floor ELSE 0 END ), 0) AS floor_bonus,

		COALESCE( sum( quantity * CASE WHEN space < 0 THEN -space ELSE 0 END ), 0) AS space_bonus,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_ore ), 0) AS storage_ore,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_hydrocarbon ), 0) AS storage_hydrocarbon,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_energy ), 0) AS storage_energy,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_workers ), 0) AS storage_workers,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_scientists ), 0) AS storage_scientists,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * storage_soldiers ), 0) AS storage_soldiers,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * energy_production ), 0) AS energy_production,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * production_ore * CASE WHEN use_planet_production_pct THEN r_planet.pct_ore/100.0 ELSE 1 END), 0) AS production_ore,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * production_hydrocarbon * CASE WHEN use_planet_production_pct THEN r_planet.pct_hydrocarbon/100.0 ELSE 1 END), 0) AS production_hydrocarbon,

		COALESCE( sum( tool_compute_factor(consumption_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled*0.95)) * energy_consumption ), 0) AS energy_consumption,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_production_ore ) AS mod_production_ore,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_production_hydrocarbon ) AS mod_production_hydrocarbon,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_production_energy ) AS mod_production_energy,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_production_workers ) AS mod_production_workers,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_construction_speed_buildings ) AS mod_construction_speed_buildings,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_construction_speed_ships ) AS mod_construction_speed_ships,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_research_effectiveness ) AS mod_research_effectiveness,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * radar_strength ), 0) AS radar_strength,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * radar_jamming ), 0) AS radar_jamming,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled*0.95) * workers * maintenance_factor ), 0)/100 AS maintenanceworkers,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled*0.95) * workers * security_factor ), 0)/100 AS securitysoldiers,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * training_scientists ), 0) AS training_scientists,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * training_soldiers ), 0) AS training_soldiers,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * sandworm_activity ), 0) AS sandworm_activity,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * seismic_activity ), 0) AS seismic_activity,

		COALESCE( max( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * vortex_strength ), 0) AS vortex_strength,

		COALESCE( min( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * vortex_strength ), 0) AS vortex_jammer,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * production_credits ), 0) AS production_credits,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * production_credits_random ), 0) AS production_credits_random,

		COALESCE( sum( tool_compute_factor(production_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled)) * production_prestige ), 0) AS production_prestige,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * energy_receive_antennas ), 0) AS energy_receive_antennas,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * energy_send_antennas ), 0) AS energy_send_antennas,

		COALESCE( sum( tool_compute_factor(consumption_exp_per_building, GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled*0.95)) * upkeep ), 0) AS upkeep,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_planet_need_ore ) AS mod_planet_need_ore,

		float8_mult( 1.0 + GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * mod_planet_need_hydrocarbon ) AS mod_planet_need_hydrocarbon,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * bonus_planet_need_ore ), 0) AS bonus_planet_need_ore,

		COALESCE( sum( GREATEST(0, CASE WHEN destroy_datetime IS NULL OR active_when_destroying THEN quantity ELSE quantity-1 END - disabled) * bonus_planet_need_hydrocarbon ), 0) AS bonus_planet_need_hydrocarbon

	FROM gm_planet_buildings

		INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid = dt_buildings.id)

	WHERE gm_planet_buildings.planetid=$1;

	-- retrieve energy received from other planets

	SELECT INTO r_energy_received

		COALESCE(sum(effective_energy), 0) as quantity

	FROM gm_planet_energy_transfers

	WHERE target_planetid=$1 AND enabled;

	-- retrieve energy sent to other planets

	SELECT INTO r_energy_sent

		COALESCE(sum(energy), 0) as quantity

	FROM gm_planet_energy_transfers

	WHERE planetid=$1 AND enabled;

	-- retrieve commander bonus

	SELECT INTO r_commander

		mod_production_ore,

		mod_production_hydrocarbon,

		mod_production_energy,

		mod_production_workers,

		mod_construction_speed_buildings,

		mod_construction_speed_ships,

		mod_research_effectiveness

	FROM gm_commanders

	WHERE id=r_planet.commanderid;

	IF NOT FOUND THEN

		r_commander.mod_production_ore := 1.0;

		r_commander.mod_production_hydrocarbon := 1.0;

		r_commander.mod_production_energy := 1.0;

		r_commander.mod_production_workers := 1.0;

		r_commander.mod_construction_speed_buildings := 1.0;

		r_commander.mod_construction_speed_ships := 1.0;

		r_commander.mod_research_effectiveness := 1.0;

	END IF;

	-- retrieve research modifiers

	SELECT INTO r_research

		mod_production_ore,

		mod_production_hydrocarbon,

		mod_production_energy,

		mod_production_workers,

		mod_construction_speed_buildings,

		mod_construction_speed_ships,

		mod_research_effectiveness,

		mod_planet_need_ore,

		mod_planet_need_hydrocarbon

	FROM gm_profiles

	WHERE id=r_planet.ownerid;

	IF NOT FOUND THEN

		r_research.mod_production_ore := 1.0;

		r_research.mod_production_hydrocarbon := 1.0;

		r_research.mod_production_energy := 1.0;

		r_research.mod_production_workers := 1.0;

		r_research.mod_construction_speed_buildings := 1.0;

		r_research.mod_construction_speed_ships := 1.0;

		r_research.mod_research_effectiveness := 1.0;

		r_research.mod_planet_need_ore := 1.0;

		r_research.mod_planet_need_hydrocarbon := 1.0;

	END IF;

	-- compute energy bonus

	b_production_energy := r_commander.mod_production_energy * r_research.mod_production_energy * r_buildings.mod_production_energy;

	energy_produced := int4(r_buildings.energy_production * b_production_energy + r_energy_received.quantity);

	energy_used := int4(r_pending.energy_consumption + r_buildings.energy_consumption + r_energy_sent.quantity);

	IF r_planet.energy <= 100 THEN

		IF energy_used > energy_produced AND r_energy_sent.quantity > 0 THEN

			UPDATE gm_planet_energy_transfers SET

				enabled = false

			WHERE planetid=$1 AND target_planetid=(SELECT target_planetid FROM gm_planet_energy_transfers WHERE planetid=$1 AND enabled ORDER BY activation_datetime DESC LIMIT 1);

			PERFORM internal_planet_update_data($1);

			RETURN;

		END IF;

	END IF;

	-- compute a modifier according to energy, if not enough energy is produced then production is reduced

	IF (energy_produced = energy_used) OR (r_planet.energy > 100) THEN

		mod_energy := 1.0;	-- it can be 0 prod and 0 usage

	ELSE

		mod_energy := 1.0 * energy_produced / GREATEST(energy_used, 1);

	END IF;

	IF mod_energy > 1.0 THEN

		mod_energy := 1.0;

	ELSEIF mod_energy < 0.001 THEN

		mod_energy := 0.001;

	END IF;

	-- compute bonus to apply to the planet

	b_production_ore := COALESCE(mod_energy * r_research.mod_production_ore * r_buildings.mod_production_ore * r_commander.mod_production_ore, 1.0);

	b_production_hydrocarbon := COALESCE(mod_energy * r_buildings.mod_production_hydrocarbon * r_research.mod_production_hydrocarbon * r_commander.mod_production_hydrocarbon, 1.0);

	b_production_workers := COALESCE(mod_energy * GREATEST(5, 10*r_research.mod_production_workers * r_buildings.mod_production_workers * r_commander.mod_production_workers), 1.0);

	IF mod_energy < 1.0 THEN

		-- constructions and research get a bigger malus when lacking energy : -10% at least

		mod_energy := GREATEST(mod_energy - 0.1, 0.001);

	END IF;

	b_building_construction_speed := COALESCE(GREATEST(mod_energy * r_buildings.mod_construction_speed_buildings * r_research.mod_construction_speed_buildings * r_commander.mod_construction_speed_buildings, 1.0), 1.0);

	b_ship_construction_speed := COALESCE(GREATEST(mod_energy * r_buildings.mod_construction_speed_ships * r_research.mod_construction_speed_ships * r_commander.mod_construction_speed_ships, 1.0), 1.0);

	b_research_effectiveness := COALESCE(GREATEST(mod_energy * r_buildings.mod_research_effectiveness * r_research.mod_research_effectiveness * r_commander.mod_research_effectiveness, 1.0), 1.0);

	IF NOT internal_planet_update_production_date($1) THEN

		RETURN;

	END IF;

	-- update planet capacities

	UPDATE gm_planets SET

		ore_capacity = r_buildings.storage_ore,

		hydrocarbon_capacity = r_buildings.storage_hydrocarbon,

		energy_capacity = r_buildings.storage_energy,

		workers_capacity = r_buildings.storage_workers,

		workers_busy = r_pending.workers + r_pending_ship.workers + r_buildings.busy_workers,

		production_percent = GREATEST(0, LEAST(1.1, 1.0*workers / GREATEST(1.0,r_buildings.maintenanceworkers)-buildings_dilapidation/10000.0)),

		ore_production_raw = int4(r_buildings.production_ore),

		hydrocarbon_production_raw = int4(r_buildings.production_hydrocarbon),

		ore_production= int4(GREATEST(0, LEAST(1.1, 1.0*workers / GREATEST(1.0,r_buildings.maintenanceworkers)-buildings_dilapidation/10000.0)) * r_buildings.production_ore * b_production_ore),

		hydrocarbon_production= int4(GREATEST(0, LEAST(1.1, 1.0*workers / GREATEST(1.0,r_buildings.maintenanceworkers)-buildings_dilapidation/10000.0)) * r_buildings.production_hydrocarbon * b_production_hydrocarbon),

		energy_consumption = energy_used,

		energy_production = energy_produced,

		mod_production_ore = 100*b_production_ore,

		mod_production_hydrocarbon = 100*b_production_hydrocarbon,

		mod_production_energy = 100*b_production_energy,

		mod_production_workers = CASE WHEN recruit_workers THEN b_production_workers ELSE 0 END,

		mod_construction_speed_buildings = 100*b_building_construction_speed,

		mod_construction_speed_ships = 100*b_ship_construction_speed,

		mod_research_effectiveness = 1000*b_research_effectiveness,

		floor_occupied = r_pending.floor + r_buildings.floor,

		space_occupied = r_pending.space + r_buildings.space,

		floor = planet_floor + int2(r_buildings.floor_bonus),

		space = planet_space + int2(r_buildings.space_bonus),

		scientists_capacity = r_buildings.storage_scientists,

		soldiers_capacity = r_buildings.storage_soldiers,

		radar_strength = GREATEST(0, int4(mod_energy*r_buildings.radar_strength)),

		radar_jamming = int4(mod_energy*r_buildings.radar_jamming),

		score = int8(r_buildings.score + r_pending.score),

		workers_for_maintenance = r_buildings.maintenanceworkers,

		soldiers_for_security = r_buildings.securitysoldiers,

		training_scientists = r_buildings.training_scientists,

		training_soldiers = r_buildings.training_soldiers,

		sandworm_activity = r_buildings.sandworm_activity,

		seismic_activity = r_buildings.seismic_activity,

		credits_production = int4(mod_energy * r_buildings.production_credits/24.0),

		credits_random_production = int4(mod_energy * r_buildings.production_credits_random/24.0),

		production_prestige = r_buildings.production_prestige,

		energy_receive_antennas = r_buildings.energy_receive_antennas,

		energy_send_antennas = r_buildings.energy_send_antennas,

		upkeep = r_buildings.upkeep,

		vortex_strength = planet_vortex_strength + r_buildings.vortex_strength + LEAST(0, r_buildings.vortex_jammer),

		next_planet_update = CASE WHEN energy > 0 AND energy_used > energy_produced THEN now() + 1.0*energy / (energy_used - energy_produced) * INTERVAL '1 hour' ELSE Null END,

		planet_need_ore = LEAST(500000, (LEAST(2.0, r_research.mod_planet_need_ore) * r_buildings.bonus_planet_need_ore * GREATEST(0, r_buildings.mod_planet_need_ore))::integer),

		planet_need_hydrocarbon = LEAST(500000, (LEAST(2.0, r_research.mod_planet_need_ore) * r_buildings.bonus_planet_need_hydrocarbon * GREATEST(0, r_buildings.mod_planet_need_hydrocarbon))::integer)

	WHERE id=$1;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_planet_update_data(integer) OWNER TO exileng;

--
-- Name: internal_planet_update_orbitting_fleets_recycling_percent(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_update_orbitting_fleets_recycling_percent(_planetid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_fleets record;

BEGIN

	-- retrieve total recycling capacity of gm_fleets orbiting this _planetid

	SELECT INTO r_fleets sum(recycler_output) as total_recyclers_output

	FROM gm_fleets

	WHERE planetid=_planetid AND action=2;

	UPDATE gm_fleets SET

		recycler_percent = 1.0 * recycler_output / r_fleets.total_recyclers_output

	WHERE planetid=_planetid AND action=2;

	RETURN;

END;$$;


ALTER FUNCTION ng03.internal_planet_update_orbitting_fleets_recycling_percent(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_update_production_date(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_update_production_date(_planetid integer) RETURNS boolean
    LANGUAGE plpgsql STRICT
    AS $$-- Param1: PlanetId

BEGIN

	--RAISE NOTICE '%', _planetid;

	UPDATE gm_planets SET

		ore = int4(LEAST(ore + ore_production * date_part('epoch', now()-production_lastupdate)/3600.0, ore_capacity)),

		hydrocarbon = int4(LEAST(hydrocarbon + hydrocarbon_production * date_part('epoch', now()-production_lastupdate)/3600.0, hydrocarbon_capacity)),

		energy = int4(GREATEST(0, LEAST(energy + (energy_production-energy_consumption) * date_part('epoch', now()-production_lastupdate)/3600.0, energy_capacity))),

		workers = int4(LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity)),

		production_percent = GREATEST(0, LEAST(1.1, 1.0* int4(LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity)) / GREATEST(1.0,workers_for_maintenance)-buildings_dilapidation/10000.0)),

		ore_production = int4(GREATEST(0, LEAST(1.1, 1.0* int4(LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity)) / GREATEST(1.0,workers_for_maintenance)-buildings_dilapidation/10000.0)) * ore_production_raw * mod_production_ore / 100.0),

		hydrocarbon_production = int4(GREATEST(0, LEAST(1.1, 1.0* int4(LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity)) / GREATEST(1.0,workers_for_maintenance)-buildings_dilapidation/10000.0)) * hydrocarbon_production_raw * mod_production_hydrocarbon / 100.0),

		previous_buildings_dilapidation = buildings_dilapidation,

		planet_stock_ore = int4(GREATEST(static_merchant_stock_min(), LEAST(static_merchant_stock_max(), planet_stock_ore - planet_need_ore * date_part('epoch', now()-production_lastupdate)/3600.0))),

		planet_stock_hydrocarbon = int4(GREATEST(static_merchant_stock_min(), LEAST(static_merchant_stock_max(), planet_stock_hydrocarbon - planet_need_hydrocarbon * date_part('epoch', now()-production_lastupdate)/3600.0))),

		production_lastupdate = now()

	WHERE id=_planetid AND not production_frozen;

	IF NOT FOUND THEN

		-- planet not found or likely to be frozen

		RETURN false;

	END IF;

	RETURN TRUE;

END;$$;


ALTER FUNCTION ng03.internal_planet_update_production_date(_planetid integer) OWNER TO exileng;

--
-- Name: internal_planet_update_ship_pendings_time(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_planet_update_ship_pendings_time(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: PlanetId

DECLARE

	total_time int4;

	r_pending record;

	pct float8;

BEGIN

	-- update buildings construction time

	FOR r_pending IN

		SELECT id, shipid, start_time, end_time, remaining_time

		FROM vw_gm_planet_ship_pendings

		WHERE planetid=$1 AND end_time IS NOT NULL

	LOOP

		-- compute percentage of research done

		pct := date_part('epoch', r_pending.end_time - now()) / date_part('epoch', r_pending.end_time - r_pending.start_time);

		-- retrieve building time

		SELECT INTO total_time int4(construction_time)

		FROM vw_gm_planet_ships WHERE planetid=$1 AND id=r_pending.shipid;

		UPDATE gm_planet_ship_pendings SET start_time=now()-((1-pct)*total_time*INTERVAL '1 second'), end_time = now() + pct*total_time*INTERVAL '1 second' WHERE id=r_pending.id;

	END LOOP;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_planet_update_ship_pendings_time(integer) OWNER TO exileng;

--
-- Name: internal_profile_apply_alliance_tax(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_apply_alliance_tax(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Apply the taxes on the given credits, return the credits - the taxes if any

-- Do not use the returned value directly, store it in a var before using it in a query

-- Param1: UserId

-- Param2: Credits

DECLARE

	r_user record;

	taxes int4;

	remaining_credits int4;

BEGIN

	SELECT INTO r_user login, alliance_id, tax

	FROM gm_profiles

		INNER JOIN gm_alliances ON (gm_alliances.id=gm_profiles.alliance_id)

	WHERE gm_profiles.id=$1 AND gm_profiles.planets > 1 FOR UPDATE;

	IF FOUND THEN

		taxes := int4($2*(r_user.tax / 1000.0));

		remaining_credits := $2 - taxes;

		IF taxes > 0 THEN

			UPDATE gm_alliances SET credits=credits+taxes WHERE id=r_user.alliance_id;

			UPDATE gm_profiles SET alliance_taxes_paid=alliance_taxes_paid + taxes WHERE id=$1;

			INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, source, type)

			VALUES(r_user.alliance_id, $1, taxes, r_user.login, 1);

			RETURN remaining_credits;

		END IF;

	END IF;

	RETURN $2;

END;$_$;


ALTER FUNCTION ng03.internal_profile_apply_alliance_tax(integer, integer) OWNER TO exileng;

--
-- Name: internal_profile_check_for_new_commanders(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_check_for_new_commanders(_userid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	r_commanders record;

	max_commanders int2;

	x int2;

	_commanders_loyalty int2;

	extra_points int2;

	cost int2;

BEGIN

	-- retrieve the gm_commanders loyalty

	SELECT INTO _commanders_loyalty commanders_loyalty FROM gm_profiles WHERE id=_userid;

	IF _commanders_loyalty <= 90 THEN

		RETURN 0;

	END IF;

	-- delete old gm_commanders to be able to propose new gm_commanders

	DELETE FROM gm_commanders WHERE ownerid=_userid AND recruited IS NULL AND added < NOW()-INTERVAL '3 days';

	-- retrieve how many gm_commanders the player has and how many should be proposed to player

	SELECT INTO r_commanders

		int4(COALESCE(count(recruited), 0)) AS commanders_recruited,

		int4(COALESCE(count(*)-count(recruited), 0)) AS commanders_proposed

	FROM gm_commanders

	WHERE ownerid=_userid;

	-- retrieve max gm_commanders the player can manage

	SELECT INTO max_commanders mod_commanders FROM gm_profiles WHERE id=_userid;

	-- compute how many gm_commanders we have to propose to the player

	max_commanders := 1 + max_commanders - r_commanders.commanders_recruited - r_commanders.commanders_proposed;

	WHILE max_commanders > 0 AND _commanders_loyalty > 90 LOOP

		PERFORM 1 FROM gm_commanders WHERE ownerid=_userid AND salary=0;

		IF NOT FOUND THEN

			INSERT INTO gm_commanders(ownerid, points, salary)

			VALUES(_userid, 14, 0);

		ELSE

			x := int2(random()*100);

			extra_points := int2(x / 33);

			cost := 5000 + extra_points*(600+extra_points*50);

			x := int2(random()*100);

			IF x < 75 THEN

				INSERT INTO gm_commanders(ownerid, points, salary)

				VALUES(_userid, 10+extra_points, cost);

			ELSEIF x < 80 THEN

				INSERT INTO gm_commanders(ownerid, points, salary, mod_production_ore)

				VALUES(_userid, 10+extra_points, cost, 1.0 + 0.01*int2(random()*2));

			ELSEIF x < 85 THEN

				INSERT INTO gm_commanders(ownerid, points, salary, mod_production_hydrocarbon)

				VALUES(_userid, 10+extra_points, cost, 1.0 + 0.01*int2(random()*2));

			ELSEIF x < 90 THEN

				INSERT INTO gm_commanders(ownerid, points, salary, mod_construction_speed_buildings)

				VALUES(_userid, 10+extra_points, cost, 1.0 + 0.05*int2(random()*2));

			ELSEIF x < 95 THEN

				INSERT INTO gm_commanders(ownerid, points, salary, mod_construction_speed_ships)

				VALUES(_userid, 10+extra_points, cost, 1.0 + 0.05*int2(random()*2));

			ELSE

				INSERT INTO gm_commanders(ownerid, points, salary, mod_fleet_shield, mod_fleet_handling, mod_fleet_tracking_speed)

				VALUES(_userid, 10+extra_points, cost, 1.0 + 0.02*int2(random()*2), 1.0 + 0.05*int2(random()*2), 1.0 + 0.05*int2(random()*2));

			END IF;

		END IF;

		_commanders_loyalty := _commanders_loyalty - 15;

		max_commanders := max_commanders - 1;

	END LOOP;

	PERFORM internal_commander_update_salary(_userid, id) FROM gm_commanders WHERE ownerid=_userid;

	-- store the new value of commanders_loyalty

	UPDATE gm_profiles SET commanders_loyalty = _commanders_loyalty WHERE id=_userid;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.internal_profile_check_for_new_commanders(_userid integer) OWNER TO exileng;

--
-- Name: connectinfo; Type: TYPE; Schema: static; Owner: exileng
--

CREATE TYPE ng03.connectinfo AS (
	id integer,
	privilege integer,
	lastplanetid integer,
	resets integer
);


ALTER TYPE ng03.connectinfo OWNER TO exileng;

--
-- Name: internal_profile_connect(integer, integer, inet, character varying, character varying, bigint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_connect(_userid integer, _lcid integer, _address inet, _forwarded character varying, _browser character varying, _browserid bigint)  RETURNS SETOF ng03.connectinfo
    LANGUAGE plpgsql
    AS $_$-- connect to a user

--  param1: userid

--  param2: connection LCID

--  param3: connection address

DECLARE

	result ng03.connectinfo;

	r_users record;

	t timestamp;

	other_userid int4;

	connection_id int8;

BEGIN

	SELECT INTO r_users

	*

	FROM gm_profiles

	WHERE id=_userid

	LIMIT 1;

	IF FOUND THEN

		r_users.password := '';

		t := now();

		UPDATE gm_profile_connections SET

			disconnected = LEAST(t, r_users.lastactivity+INTERVAL '1 minutes')

		WHERE userid=r_users.id AND disconnected IS NULL;

		-- update lastlogin column

		UPDATE gm_profiles SET lastlogin=t, lastactivity=t WHERE id=r_users.id AND privilege <> -1;

		r_users.lastlogin := t;

		r_users.lastactivity := t;

	ELSE

		-- create the user

		INSERT INTO gm_profiles(id, lcid, regaddress)

		VALUES(_userid, _lcid, _address);

		-- return user row

		SELECT INTO r_users

		*

		FROM gm_profiles

		WHERE id=_userid

		LIMIT 1;

	END IF;

	result.id = r_users.id;

	result.privilege = r_users.privilege;

	result.lastplanetid = r_users.lastplanetid;

	result.resets = r_users.resets;

	RETURN NEXT result;

	connection_id := nextval('gm_profile_connections_id_seq');

	-- save clients address/brower info

	INSERT INTO gm_profile_connections(id, userid, address, forwarded_address, browser, browserid)

	VALUES(connection_id, r_users.id, _address, substr(_forwarded, 1, 64), substr(_browser, 1, 128), _browserid);

	-- add multiaccount warnings

	IF r_users.privilege = 0 THEN

		INSERT INTO gm_log_multi_warnings(id, withid)

			SELECT DISTINCT ON (userid) connection_id, id

			FROM gm_profile_connections

			WHERE datetime > now()-INTERVAL '30 minutes' AND address=sp__atoi($3) AND userid <> _userid;

	END IF;

END;$_$;


ALTER FUNCTION ng03.internal_profile_connect(_userid integer, _lcid integer, _address inet, _forwarded character varying, _browser character varying, _browserid bigint) OWNER TO exileng;

--
-- Name: internal_profile_create_fleet_route(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_create_fleet_route(integer, character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: Route name

DECLARE

	routeid int4;

BEGIN

	routeid := nextval('gm_fleet_routes_id_seq');

	IF $2 IS NULL THEN

		INSERT INTO gm_fleet_routes(id, ownerid, name) VALUES(routeid, $1, 'r_' || routeid);

	ELSE

		INSERT INTO gm_fleet_routes(id, ownerid, name) VALUES(routeid, $1, $2);

	END IF;

	RETURN routeid;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN -1;

	WHEN UNIQUE_VIOLATION THEN

		RETURN internal_profile_create_fleet_route($1, $2);

END;$_$;


ALTER FUNCTION ng03.internal_profile_create_fleet_route(integer, character varying) OWNER TO exileng;

--
-- Name: internal_profile_create_fleet_route_recycle_move(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_create_fleet_route_recycle_move(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$-- Create a route to recycle resources then move to a planet

-- Param1: PlanetId

DECLARE

	route_id int8;

	waypoint_id int8;

BEGIN

	-- create route

	route_id := internal_profile_create_fleet_route(null, null);

	waypoint_id := internal_fleet_route_add_recycling(route_id);

	PERFORM internal_fleet_route_add_move(route_id, $1);

	RETURN waypoint_id;

END;$_$;


ALTER FUNCTION ng03.internal_profile_create_fleet_route_recycle_move(integer) OWNER TO exileng;

--
-- Name: internal_profile_create_fleet_route_unload_move(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_create_fleet_route_unload_move(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$-- Create a route to unload resources then move to a planet

-- Param1: PlanetId

DECLARE

	route_id int8;

	waypoint_id int8;

BEGIN

	-- create route

	route_id := internal_profile_create_fleet_route(null, null);

	waypoint_id := internal_fleet_route_add_unloadall(route_id);

	PERFORM internal_fleet_route_add_move(route_id, $1);

	RETURN waypoint_id;

END;$_$;


ALTER FUNCTION ng03.internal_profile_create_fleet_route_unload_move(integer) OWNER TO exileng;

--
-- Name: internal_profile_delete(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_delete(integer) RETURNS void
    LANGUAGE sql
    AS $_$-- Param1: Userid

-- remove the player from his alliance to assign a new leader or delete the alliance

UPDATE gm_profiles SET alliance_id=null WHERE id=$1;

-- delete player gm_commanders, gm_profile_research_pendings

DELETE FROM gm_commanders WHERE ownerid=$1;

DELETE FROM gm_profile_research_pendings WHERE userid=$1;

-- give player planets to the lost worlds

UPDATE gm_planets SET commanderid=null, ownerid=2 WHERE ownerid=$1;

-- delete player account

DELETE FROM gm_profiles WHERE id=$1;$_$;


ALTER FUNCTION ng03.internal_profile_delete(integer) OWNER TO exileng;

--
-- Name: internal_profile_get_addressees(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_addressees(integer) RETURNS SETOF character varying
    LANGUAGE sql
    AS $_$-- return the list of addressee names

-- param1: id

SELECT login

FROM gm_mail_addressees INNER JOIN gm_profiles ON gm_mail_addressees.addresseeid = gm_profiles.id

WHERE ownerid=$1

ORDER BY upper(login);$_$;


ALTER FUNCTION ng03.internal_profile_get_addressees(integer) OWNER TO exileng;

--
-- Name: internal_profile_get_alliance_leaving_cost(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_alliance_leaving_cost(_userid integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE

	r_fleets record;

	r_ships_parked record;

	r_user record;

BEGIN

	RETURN 0;

	/*

	SELECT INTO r_user COALESCE(planets, 0) AS planets FROM gm_profiles WHERE id=_userid;

	SELECT INTO r_fleets COALESCE(sum(real_signature), 0) AS signature FROM gm_fleets WHERE ownerid=_userid;

	SELECT INTO r_ships_parked

		COALESCE(sum(signature*quantity), 0) AS signature

	FROM gm_planet_ships

		INNER JOIN gm_planets ON gm_planets.id = gm_planet_ships.planetid

		INNER JOIN dt_ships ON dt_ships.id = gm_planet_ships.shipid

	WHERE ownerid=$1;

	RETURN int4(r_user.planets*(r_user.planets / 4.0)*1000) + r_fleets.signature + r_ships_parked.signature;

*/

END;$_$;


ALTER FUNCTION ng03.internal_profile_get_alliance_leaving_cost(_userid integer) OWNER TO exileng;

--
-- Name: internal_profile_get_galaxies_info(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_galaxies_info(_user_id integer) RETURNS SETOF ng03.galaxy_info
    LANGUAGE plpgsql
    AS $$DECLARE

	r_info galaxy_info;

	r_galaxy record;

	r_user record;

BEGIN

	SELECT INTO r_user *

	FROM gm_profiles

	WHERE id=_user_id;

	IF NOT FOUND THEN

		r_user.regdate = now();

	END IF;

	FOR r_galaxy IN

		SELECT id, 

			(protected_until - static_galaxy_protection_delay()) AS open_since,

			protected_until,

			( SELECT count(DISTINCT gm_planets.ownerid) FROM gm_planets WHERE gm_planets.galaxy = gm_galaxies.id) AS players,

			colonies, planets

		FROM gm_galaxies

		WHERE allow_new_players --AND protected_until IS NOT NULL

		ORDER BY id

	LOOP

		r_info.id = r_galaxy.id;

		r_info.open_since = r_galaxy.open_since;

		r_info.protected_until = r_galaxy.protected_until;

		r_info.recommended := -1;	-- -1: cant be chosen

		PERFORM 1

		FROM gm_planets

			INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

		WHERE ownerid IS NULL AND (gm_galaxies.id = r_galaxy.id) AND (planet % 2 = 0) AND

			(sector % 10 = 0 OR sector % 10 = 1 OR sector <= 10 OR sector > 90) AND

			planet_floor > 0 AND planet_space > 0 AND allow_new_players

		LIMIT 1;

		IF FOUND THEN

			IF (r_galaxy.protected_until IS NULL AND r_user.regdate > now() - INTERVAL '2 weeks') OR (now() > r_galaxy.protected_until) OR (now() > r_galaxy.open_since + (r_galaxy.open_since - r_user.regdate) ) THEN

				IF r_galaxy.players > 400 OR r_galaxy.colonies > 0.66*r_galaxy.planets THEN

					r_info.recommended := 0;

				ELSEIF r_galaxy.players < 50 OR r_galaxy.protected_until IS NULL OR r_galaxy.protected_until > now() THEN

					r_info.recommended := 2;

				ELSE

					r_info.recommended := 1;

				END IF;

				RETURN NEXT r_info;

			END IF;

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_galaxies_info(_user_id integer) OWNER TO exileng;

--
-- Name: internal_profile_get_galaxy_planets(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_galaxy_planets(_galaxyid integer, _userid integer) RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planets record;

	r_user record;

	result varchar;

BEGIN

	result := '';

	-- retrieve player alliance info and rights

	SELECT INTO r_user

		gm_profiles.alliance_id, gm_profiles.security_level, gm_alliance_ranks.leader OR gm_alliance_ranks.can_use_alliance_radars AS see_alliance

	FROM gm_profiles

		LEFT JOIN gm_alliance_ranks ON (gm_alliance_ranks.rankid = gm_profiles.alliance_rank AND gm_alliance_ranks.allianceid = gm_profiles.alliance_id)

	WHERE id=_userid;

	FOR r_planets IN

		SELECT CASE

			WHEN warp_to IS NOT NULL OR vortex_strength > 0 THEN 7	-- vortex

			WHEN ownerid=_userid THEN 4				-- player planet

			WHEN gm_profiles.alliance_id=r_user.alliance_id AND r_user.see_alliance THEN 3	-- ally planet

			WHEN privilege=-50 OR (allianceid1 IS NOT NULL AND gm_alliance_naps.share_locs AND r_user.see_alliance) OR (ownerid IS NOT NULL AND gm_profiles.security_level <> r_user.security_level) THEN 2	-- friend/NAP planet

			WHEN spawn_ore > 0 THEN 5				-- resource ore

			WHEN spawn_hydrocarbon > 0 THEN 6			-- resource hydrocarbon

			WHEN planet_floor > 0 AND ownerid IS NULL THEN 1	-- uninhabited planet

			WHEN planet_floor = 0 THEN 8	-- empty/nothing

			ELSE 0 END AS t						-- enemy planet

		FROM gm_planets

			LEFT JOIN gm_profiles ON ownerid = gm_profiles.id

			LEFT JOIN gm_alliance_naps ON (allianceid1 = gm_profiles.alliance_id AND allianceid2 = r_user.alliance_id)

		WHERE galaxy=_galaxyid

		ORDER BY gm_planets.id

	LOOP

		result := result || r_planets.t;

	END LOOP;

	RETURN result;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_galaxy_planets(_galaxyid integer, _userid integer) OWNER TO exileng;

--
-- Name: internal_profile_get_hydro_recycling_coeff(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_hydro_recycling_coeff(_userid integer) RETURNS real
    LANGUAGE plpgsql STABLE
    AS $$DECLARE

	res float4;

BEGIN

	SELECT INTO res 0.40+mod_recycling/100.0 FROM gm_profiles WHERE id=_userid;

	IF res IS NULL THEN

		RETURN 0.40;

	ELSE

		RETURN res;

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_hydro_recycling_coeff(_userid integer) OWNER TO exileng;

--
-- Name: internal_profile_get_name(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_name(integer) RETURNS character varying
    LANGUAGE sql STABLE
    AS $_$SELECT login FROM gm_profiles WHERE id=$1;$_$;


ALTER FUNCTION ng03.internal_profile_get_name(integer) OWNER TO exileng;

--
-- Name: internal_profile_get_ore_recycling_coeff(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_ore_recycling_coeff(_userid integer) RETURNS real
    LANGUAGE plpgsql STABLE
    AS $$DECLARE

	res float4;

BEGIN

	SELECT INTO res 0.45+mod_recycling/100.0 FROM gm_profiles WHERE id=_userid;

	IF res IS NULL THEN

		RETURN 0.45;

	ELSE

		RETURN res;

	END IF;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_ore_recycling_coeff(_userid integer) OWNER TO exileng;

--
-- Name: internal_profile_get_relation(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_relation(integer, integer) RETURNS smallint
    LANGUAGE plpgsql STABLE
    AS $_$-- 2 = player

-- 1 = ally

-- 0 = nap

-- -1 = undefined

-- -2 = war

DECLARE

	r_user1 record;

	r_user2 record;

BEGIN

	-- if one player is null then return -3 : neutral

	IF ($1 IS NULL) OR ($2 IS NULL) THEN

		RETURN -3;

	END IF;

	-- return 2 for same player

	IF $1 = $2 THEN

		RETURN 2;

	END IF;

	-- Make merchants napped with everybody, their ID is 3

	IF $1 = 3 OR $2 = 3 THEN

		RETURN 0;

	END IF;

	-- retrieve gm_alliances of the 2 players

	SELECT INTO r_user1 alliance_id, security_level FROM gm_profiles WHERE id=$1;

	SELECT INTO r_user2 alliance_id, security_level FROM gm_profiles WHERE id=$2;

	IF r_user1.security_level <> r_user2.security_level THEN

		RETURN 0;

	END IF;

	-- return 1 for same alliance, 0 for NAPs

	IF r_user1.alliance_id = r_user2.alliance_id THEN

		RETURN 1;

	ELSE

		PERFORM 1 FROM gm_alliance_wars WHERE ((allianceid1 = r_user1.alliance_id AND allianceid2 = r_user2.alliance_id) OR (allianceid1 = r_user2.alliance_id AND allianceid2 = r_user1.alliance_id)) AND can_fight < now();

		IF FOUND THEN

			RETURN -2;

		END IF;

		PERFORM allianceid1 FROM gm_alliance_naps WHERE allianceid1 = r_user1.alliance_id AND allianceid2 = r_user2.alliance_id;

		IF FOUND THEN

			RETURN 0;

		END IF;

	END IF;

	RETURN -1;

END;$_$;


ALTER FUNCTION ng03.internal_profile_get_relation(integer, integer) OWNER TO exileng;

--
-- Name: internal_profile_get_research_cost(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_research_cost(integer, integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$-- Param1: UserId

-- Param2: ResearchId

SELECT int4((SELECT mod_research_cost FROM gm_profiles WHERE id=$1) * cost_credits * power(2.35, 5-levels + COALESCE((SELECT level FROM gm_profile_researches WHERE researchid = dt_researches.id AND userid=$1), 0)))

FROM dt_researches

WHERE id=$2;$_$;


ALTER FUNCTION ng03.internal_profile_get_research_cost(integer, integer) OWNER TO exileng;

--
-- Name: internal_profile_get_research_time(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_research_time(_userid integer, _rank integer, _levels integer, _level integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$-- Param1: UserId

-- Param2: ResearchRank

-- Param3: ResearchLevels

-- Param4: ResearchLevel

DECLARE

	result int4;

	scientist_planets int4;

	scientist_total numeric;

	research_rank int4;

BEGIN

	SELECT INTO scientist_planets int4(count(*)-1) FROM gm_planets WHERE ownerid=_userid AND scientists > 0;

	SELECT INTO scientist_total 100 + COALESCE(sum(GREATEST(scientists-scientist_planets*5, scientists*5/100.0)*mod_research_effectiveness/1000.0), 0) FROM gm_planets WHERE ownerid=_userid AND scientists > 0;

	research_rank := _rank;

	IF research_rank > 0 THEN

/*

		SELECT INTO result

			int4((SELECT (100+mod_research_time)/100.0 FROM gm_profiles WHERE id=_userid)*(3600 + 3.6/log(6,

			int4( 

				100 + sum( GREATEST( 0, scientists - (SELECT 5*(count(*)-1) FROM gm_planets WHERE ownerid=_userid and scientists > 0) ) ) )

			) * 800 * _rank * power(3.4+ GREATEST(-0.05, _rank-sum(scientists)/1500.0)/10.0, 5-_levels+COALESCE(_level, 0))))

		FROM gm_planets WHERE ownerid=_userid;

*/

		result := int4((SELECT (100+mod_research_time)/100.0 FROM gm_profiles WHERE id=_userid)*(3600 + 

			3.6/log(4+research_rank, scientist_total) * 800 * research_rank * power(3.4+ GREATEST(-0.05, research_rank-scientist_total/(research_rank*500.0))/10.0, 5-_levels+_level)));

	ELSE

		research_rank := -_rank;

		IF _level >= 16 THEN

			research_rank := research_rank + 5;

		ELSEIF _level >= 13 THEN

			research_rank := research_rank + 4;

		ELSEIF _level >= 10 THEN

			research_rank := research_rank + 3;

		ELSEIF _level >= 7 THEN

			research_rank := research_rank + 2;

		END IF;

/*

		SELECT INTO result

			int4((SELECT (100+mod_research_time)/100.0 FROM gm_profiles WHERE id=_userid)*(3600 + 3.6/log(6,

			int4( 

				100 + sum( GREATEST( 0, scientists - (SELECT 5*(count(*)-1) FROM gm_planets WHERE ownerid=_userid and scientists > 0) ) ) )

			) * 800 * (-research_rank) * power(3.4+ GREATEST(-0.05, (-research_rank)-sum(scientists)/1500.0)/10.0, 4)))

		FROM gm_planets WHERE ownerid=_userid;

*/

		result := int4((SELECT (100+mod_research_time)/100.0 FROM gm_profiles WHERE id=_userid)*(3600 + 

			3.6/log(6, scientist_total) * 800 * research_rank * power(3.4+ GREATEST(-0.05, research_rank-scientist_total/1500.0)/10.0, 4)));

	END IF;

	RETURN int4(result * static_time_coeff());

END;$$;


ALTER FUNCTION ng03.internal_profile_get_research_time(_userid integer, _rank integer, _levels integer, _level integer) OWNER TO exileng;

--
-- Name: internal_profile_get_researches_status(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_researches_status(integer) RETURNS SETOF ng03.research_status
    LANGUAGE sql STABLE
    AS $_$-- list gm_profile_researches and their status for userid $1

-- Param1: user id

SELECT $1, dt_researches.id, dt_researches.category, dt_researches.name, dt_researches.label, dt_researches.description, dt_researches.rank, dt_researches.cost_credits, dt_researches.levels,

	COALESCE((SELECT level FROM gm_profile_researches WHERE researchid = dt_researches.id AND userid=gm_profiles.id), int2(0)) AS level,

	(SELECT int4(date_part('epoch', end_time-now())) FROM gm_profile_research_pendings WHERE researchid = dt_researches.id AND userid=gm_profiles.id) AS status,

	internal_profile_get_research_time(gm_profiles.id, rank, levels, CASE WHEN expiration IS NULL THEN COALESCE((SELECT level FROM gm_profile_researches WHERE researchid = dt_researches.id AND userid=gm_profiles.id), 0) ELSE 0 END) AS total_time,

	internal_profile_get_research_cost(gm_profiles.id, dt_researches.id) AS total_cost,

	(SELECT int4(date_part('epoch', expires-now())) FROM gm_profile_researches WHERE researchid = dt_researches.id AND userid = gm_profiles.id) AS remaining_time,

	int4(date_part('epoch', expiration)) AS expiration_time,

	NOT EXISTS

	(SELECT 1

	FROM dt_research_research_reqs

	WHERE (researchid = dt_researches.id) AND (required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=gm_profiles.id AND level >= required_researchlevel))),

	NOT EXISTS

	(SELECT 1

	FROM dt_research_building_reqs

	WHERE (researchid = dt_researches.id) AND (required_buildingid NOT IN 

		(SELECT gm_planet_buildings.buildingid

		FROM gm_planets

			LEFT JOIN gm_planet_buildings ON (gm_planets.id = gm_planet_buildings.planetid)

		WHERE gm_planets.ownerid=gm_profiles.id

		GROUP BY gm_planet_buildings.buildingid

		HAVING sum(gm_planet_buildings.quantity) >= required_buildingcount))),

	NOT EXISTS

	(SELECT 1

	FROM dt_research_building_reqs

	WHERE (researchid = dt_researches.id) AND (SELECT is_planet_element FROM dt_buildings WHERE id=dt_research_building_reqs.required_buildingid) = true AND (required_buildingid NOT IN 

		(SELECT gm_planet_buildings.buildingid

		FROM gm_planets

			LEFT JOIN gm_planet_buildings ON (gm_planets.id = gm_planet_buildings.planetid)

		WHERE gm_planets.ownerid=gm_profiles.id

		GROUP BY gm_planet_buildings.buildingid

		HAVING sum(gm_planet_buildings.quantity) >= required_buildingcount)))

FROM gm_profiles, dt_researches

WHERE rank <> 0 and gm_profiles.id=$1

ORDER BY category, dt_researches.id;$_$;


ALTER FUNCTION ng03.internal_profile_get_researches_status(integer) OWNER TO exileng;

--
-- Name: internal_profile_get_resource_price(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_resource_price(_userid integer, _galaxyid integer) RETURNS ng03.resource_price
    LANGUAGE plpgsql STABLE
    AS $_$-- Param1: userid

-- Param2: galaxy id

DECLARE

	p resource_price;

BEGIN

	p := internal_profile_get_resource_price($1, $2, false);

	RETURN p;

END;$_$;


ALTER FUNCTION ng03.internal_profile_get_resource_price(_userid integer, _galaxyid integer) OWNER TO exileng;

--
-- Name: internal_profile_get_resource_price(integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_resource_price(_userid integer, _galaxyid integer, _stableprices boolean) RETURNS ng03.resource_price
    LANGUAGE plpgsql STABLE
    AS $_$-- Param1: userid

-- Param2: galaxy id

DECLARE

	p resource_price;

	r_user record;

	r_gal record;

	perc_ore real;

	perc_hydrocarbon real;

BEGIN

	p.sell_ore := 120.0;

	p.sell_hydrocarbon := 160.0;

	IF NOT _stableprices THEN

		SELECT INTO r_gal

			traded_ore,

			traded_hydrocarbon

		FROM gm_galaxies

		WHERE id=$2;

		IF FOUND THEN

			p.sell_ore := LEAST(200, GREATEST(80, 200.0 - power(GREATEST(r_gal.traded_ore, 1), 0.95) / 10000000.0));

			p.sell_hydrocarbon := LEAST(200, GREATEST(80, 200.0 - power(GREATEST(r_gal.traded_hydrocarbon, 1), 0.95) / 10000000.0));

		END IF;

	END IF;

	p.buy_ore := (p.sell_ore+5) * 1.2;

	p.buy_hydrocarbon := (p.sell_hydrocarbon+5) * 1.2;

	SELECT INTO r_user

		mod_merchant_buy_price, mod_merchant_sell_price

	FROM gm_profiles

	WHERE id=$1;

	IF FOUND THEN

		p.buy_ore := p.buy_ore * r_user.mod_merchant_buy_price;

		p.buy_hydrocarbon := p.buy_hydrocarbon * r_user.mod_merchant_buy_price;

		p.sell_ore := p.sell_ore * r_user.mod_merchant_sell_price;

		p.sell_hydrocarbon := p.sell_hydrocarbon * r_user.mod_merchant_sell_price;

	END IF;

	p.buy_ore := round(p.buy_ore::numeric, 2);

	p.buy_hydrocarbon := round(p.buy_hydrocarbon::numeric, 2);

	p.sell_ore := round(p.sell_ore::numeric, 2);

	p.sell_hydrocarbon := round(p.sell_hydrocarbon::numeric, 2);

	RETURN p;

END;$_$;


ALTER FUNCTION ng03.internal_profile_get_resource_price(_userid integer, _galaxyid integer, _stableprices boolean) OWNER TO exileng;

--
-- Name: internal_profile_get_sector_radar_strength(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_sector_radar_strength(_userid integer, _galaxy integer, _sector integer) RETURNS smallint
    LANGUAGE plpgsql STABLE
    AS $$-- Param1: UserID

-- Param2: Galaxy

-- Param3: Sector

DECLARE

	str smallint;

	r_user record;

BEGIN

	-- retrieve player alliance info and rights

	SELECT INTO r_user

		gm_profiles.alliance_id, gm_profiles.security_level, gm_alliance_ranks.leader OR gm_alliance_ranks.can_use_alliance_radars AS see_alliance

	FROM gm_profiles

		INNER JOIN gm_alliance_ranks ON (gm_alliance_ranks.rankid = gm_profiles.alliance_rank AND gm_alliance_ranks.allianceid = gm_profiles.alliance_id)

	WHERE id=_userid;

	IF r_user.see_alliance THEN

		SELECT INTO str

			COALESCE(max(radar_strength), int2(0))

		FROM gm_planets

		WHERE galaxy=_galaxy AND sector=_sector AND ownerid IS NOT NULL AND EXISTS(SELECT 1 FROM vw_gm_friend_radars WHERE friend=ownerid AND userid=_userid);

	ELSE

		SELECT INTO str

			COALESCE(max(radar_strength), int2(0))

		FROM gm_planets

		WHERE galaxy=_galaxy AND sector=_sector AND ownerid = _userid;

	END IF;

	RETURN str;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_sector_radar_strength(_userid integer, _galaxy integer, _sector integer) OWNER TO exileng;

--
-- Name: internal_profile_get_training_price(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_get_training_price(integer) RETURNS ng03.training_price
    LANGUAGE plpgsql IMMUTABLE
    AS $$-- Param1: UserID

DECLARE

	price training_price;

BEGIN

	price.scientist_ore := 10;

	price.scientist_hydrocarbon := 20;

	price.scientist_credits := 20;

	price.soldier_ore := 5;

	price.soldier_hydrocarbon := 15;

	price.soldier_credits := 10;

	RETURN price;

END;$$;


ALTER FUNCTION ng03.internal_profile_get_training_price(integer) OWNER TO exileng;

--
-- Name: internal_profile_log_activity(integer, character varying, bigint); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_log_activity(integer, character varying, bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: Userid

-- Param2: IP address

-- Param3: browserid

DECLARE

	addr int8;

	loggedsince timestamp;

BEGIN

	UPDATE gm_profiles SET

		lastactivity=now()/*,

		requests=requests+1*/

	WHERE id=$1 AND (lastactivity < now()-INTERVAL '5 minutes');-- OR lastaddress <> addr OR lastbrowserid <> $3);

/*

	SELECT INTO loggedsince lastlogin FROM gm_profiles WHERE id=$1;

	IF $1 < 100 THEN

		RETURN;

	END IF;

	BEGIN

		INSERT INTO gm_log_connection_warnings(datetime, userid1, userid2)

			SELECT date_trunc('hour', now()), $1, id

			FROM gm_profiles

			WHERE id >= 100 AND id <> $1 AND now() > lastactivity AND lastactivity > loggedsince AND lastaddress=addr AND lastbrowserid = $3;

	EXCEPTION

		WHEN UNIQUE_VIOLATION THEN

	END;

*/

END;$_$;


ALTER FUNCTION ng03.internal_profile_log_activity(integer, character varying, bigint) OWNER TO exileng;

--
-- Name: internal_profile_reset_commanders(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_reset_commanders(_user_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$DECLARE

	r_user record;

BEGIN

	DELETE FROM gm_commanders WHERE ownerid=$1;

	SELECT INTO r_user login, orientation FROM gm_profiles WHERE id=$1;

	IF NOT FOUND THEN

		RETURN;

	END IF;

	IF r_user.orientation = 2 THEN

		INSERT INTO gm_commanders(ownerid, recruited, points, mod_fleet_shield, mod_fleet_handling, mod_fleet_tracking_speed, mod_fleet_damage)

		VALUES($1, now(), 10, 1.10, 1.10, 1.10, 1.10);

	ELSE

		INSERT INTO gm_commanders(ownerid, recruited, points, mod_fleet_shield, mod_fleet_handling, mod_fleet_tracking_speed, mod_fleet_damage)

		VALUES($1, now(), 15, 1.0, 1.0, 1.0, 1.0);

	END IF;

END;$_$;


ALTER FUNCTION ng03.internal_profile_reset_commanders(_user_id integer) OWNER TO exileng;

--
-- Name: internal_profile_transfer_credits(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_transfer_credits(_from integer, _to integer, _credits integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: From User

-- Param2: To User

-- Param3: credits

DECLARE

	r_from record;

	r_to record;

BEGIN

	-- remove credits from the sender

	UPDATE gm_profiles SET credits = credits - $3 WHERE id=_from AND credits - $3 >= 0 RETURNING login INTO r_from;

	IF NOT FOUND THEN

		RETURN -1;

	END IF;

	UPDATE gm_profiles SET credits = credits + $3 WHERE id=_to RETURNING login INTO r_to;

	--SELECT sp_log_credits($1, -$3, 'Transfer money to ' || r_to.login);

	INSERT INTO gm_log_profile_actions(userid, credits_delta, to_user)

	VALUES(_from, -_credits, _to);

	INSERT INTO gm_log_money_transfers(senderid, sendername, toid, toname, credits)

	VALUES(_from, r_from.login, $2, r_to.login, _credits);

	INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, credits, data)

	VALUES(_to, 5, 2, _from, _credits, '{from:' || tool_quote(r_from.login) || ', credits:' || _credits || '}');

	RETURN 0;

EXCEPTION

	WHEN restrict_violation THEN

		RETURN -1;

END;$_$;


ALTER FUNCTION ng03.internal_profile_transfer_credits(_from integer, _to integer, _credits integer) OWNER TO exileng;

--
-- Name: internal_profile_update_data(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_update_data(_userid integer, _hour integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Update player planets conditions

-- Param1: UserId

-- Param2: Hour

DECLARE

	r_commanders record;

	r_fleets record;

	r_fleets_in_position record; -- gm_fleets near enemy planets

	r_ships_parked record;

	r_planets record;

	r_research record;

	r_user record;

BEGIN

	-- set dilapidation to -1 if was set to 0 to prevent updates of the planet

	UPDATE gm_planets SET

		buildings_dilapidation = -1

	WHERE ownerid = $1 AND buildings_dilapidation = 0;

	-- "damage"/"repair" buildings

	UPDATE gm_planets SET

		buildings_dilapidation = LEAST(10000, workers_for_maintenance, GREATEST(0, buildings_dilapidation + int4((100.0*(workers_for_maintenance- LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity) ))/workers_for_maintenance) ) )

	WHERE ownerid = $1 AND workers_for_maintenance > 0 AND ((LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity) < workers_for_maintenance) OR (LEAST(workers * power(1.0+mod_production_workers/1000.0, LEAST(date_part('epoch', now()-production_lastupdate)/3600.0, 1500)), workers_capacity) > workers_for_maintenance AND buildings_dilapidation > 0));

	-- update planet production

	PERFORM internal_planet_update_production_date(id)

	FROM gm_planets

	WHERE ownerid = $1 AND buildings_dilapidation >= 0 AND previous_buildings_dilapidation <> buildings_dilapidation;

	-- update mood/control on players planets

	UPDATE gm_planets SET

		mood=LEAST(120, GREATEST(0, mood + CASE WHEN soldiers > 0 AND soldiers*250 >= workers + scientists THEN 2 ELSE -1 END + CASE WHEN commanderid IS NOT NULL THEN 1 ELSE 0 END) )

	WHERE ownerid = $1;

	-- upkeep

	-- upkeep of ships_parked

	SELECT INTO r_ships_parked

		COALESCE(sum(dt_ships.upkeep*quantity), 0) AS upkeep

	FROM gm_planet_ships

		INNER JOIN gm_planets ON gm_planets.id = gm_planet_ships.planetid

		INNER JOIN dt_ships ON dt_ships.id = gm_planet_ships.shipid

	WHERE ownerid=$1;

	-- upkeep of gm_fleets

	SELECT INTO r_fleets

		COALESCE(sum(cargo_scientists), 0) AS scientists,

		COALESCE(sum(cargo_soldiers), 0) AS soldiers,

		COALESCE(sum(gm_fleets.upkeep), 0) AS upkeep

	FROM gm_fleets

		LEFT JOIN gm_planets ON (gm_planets.id = gm_fleets.planetid AND gm_fleets.dest_planetid IS NULL)

	WHERE gm_fleets.ownerid=$1 AND (gm_planets.ownerid IS NULL OR gm_planets.ownerid=$1 OR EXISTS(SELECT 1 FROM vw_gm_friends WHERE userid=$1 AND friend=gm_planets.ownerid) );

	-- upkeep of gm_fleets in position near enemy planets

	SELECT INTO r_fleets_in_position

		COALESCE(sum(cargo_scientists), 0) AS scientists,

		COALESCE(sum(cargo_soldiers), 0) AS soldiers,

		COALESCE(sum(gm_fleets.upkeep), 0) AS upkeep

	FROM gm_fleets

		LEFT JOIN gm_planets ON (gm_planets.id = gm_fleets.planetid AND gm_fleets.dest_planetid IS NULL)

	WHERE gm_fleets.ownerid=$1 AND gm_planets.ownerid IS NOT NULL AND gm_planets.ownerid <> $1 AND gm_planets.floor > 0 AND NOT EXISTS(SELECT 1 FROM vw_gm_friends WHERE userid=$1 AND friend=gm_planets.ownerid);

	-- upkeep of planets

	SELECT INTO r_planets

		COALESCE(sum(scientists), 0) AS scientists,

		COALESCE(sum(soldiers), 0) AS soldiers,

		count(*) AS count,

		sum(upkeep) as upkeep

	FROM gm_planets

	WHERE ownerid=$1 AND planet_floor > 0;

	-- upkeep of gm_commanders

	SELECT INTO r_commanders

		COALESCE(sum(salary), 0) AS salary

	FROM gm_commanders

	WHERE ownerid=$1 AND recruited <= NOW();

	UPDATE gm_profiles SET

		commanders_loyalty = LEAST(100, commanders_loyalty + 1),

		upkeep_commanders = upkeep_commanders + r_commanders.salary * mod_upkeep_commanders_cost/24.0,

		upkeep_scientists = upkeep_scientists + (r_fleets.scientists + r_fleets_in_position.scientists + r_planets.scientists) * static_scientist_upkeep() * mod_upkeep_scientists_cost/24.0,

		upkeep_soldiers = upkeep_soldiers + (r_fleets.soldiers + r_fleets_in_position.soldiers + r_planets.soldiers) * static_soldier_upkeep() * mod_upkeep_soldiers_cost/24.0,

		upkeep_ships = upkeep_ships + r_fleets.upkeep * static_fleet_ship_upkeep() * mod_upkeep_ships_cost/24.0,

		upkeep_ships_in_position = upkeep_ships_in_position + r_fleets_in_position.upkeep * static_orbitting_fleet_ship_upkeep() * mod_upkeep_ships_cost/24.0,

		upkeep_ships_parked = upkeep_ships_parked + r_ships_parked.upkeep * static_planet_ship_upkeep() * mod_upkeep_ships_cost/24.0,

		upkeep_planets = upkeep_planets + r_planets.upkeep * mod_upkeep_planets_cost/24.0

	WHERE id=$1;

	IF _hour = 0 THEN

		UPDATE gm_profiles SET

			production_prestige = COALESCE((SELECT sum(production_prestige) FROM gm_planets WHERE ownerid=gm_profiles.id), 0)

		WHERE id=$1;

		SELECT INTO r_user

			upkeep_commanders,

			upkeep_planets,

			upkeep_scientists,

			upkeep_ships,

			upkeep_ships_in_position,

			upkeep_ships_parked,

			upkeep_soldiers,

			production_prestige,

			mod_prestige_from_buildings,

			credits_produced,

			score_visibility = 2 AND score_visibility_last_change < now() - INTERVAL '1 day' AS score_visible

		FROM gm_profiles

		WHERE id=$1;

		UPDATE gm_profiles SET

			credits = credits + credits_produced - (upkeep_commanders + upkeep_planets + upkeep_scientists + upkeep_ships + upkeep_ships_in_position + upkeep_ships_parked + upkeep_soldiers),

			upkeep_last_cost = upkeep_commanders + upkeep_planets + upkeep_scientists + upkeep_ships + upkeep_ships_in_position + upkeep_ships_parked + upkeep_soldiers,

			upkeep_commanders = 0,

			upkeep_planets = 0,

			upkeep_scientists = 0,

			upkeep_ships = 0,

			upkeep_ships_in_position = 0,

			upkeep_ships_parked = 0,

			upkeep_soldiers = 0,

			prestige_points = prestige_points + (production_prestige * mod_prestige_from_buildings)::integer,

			score_prestige = score_prestige + production_prestige,

			credits_produced = 0

		WHERE id=$1;

		r_user.production_prestige := (r_user.mod_prestige_from_buildings*r_user.production_prestige)::integer;

		-- increase r_user.production_prestige by 10% if score is visible

		IF r_user.score_visible THEN

			r_user.production_prestige := (1.1*r_user.production_prestige)::integer;

		END IF;

		INSERT INTO gm_profile_reports(ownerid, type, subtype, upkeep_commanders, upkeep_planets, upkeep_scientists, upkeep_ships, upkeep_ships_in_position, upkeep_ships_parked, upkeep_soldiers, credits, scientists, soldiers, data)

		VALUES($1, 3, 10, r_user.upkeep_commanders, r_user.upkeep_planets, r_user.upkeep_scientists, r_user.upkeep_ships, r_user.upkeep_ships_in_position, r_user.upkeep_ships_parked, r_user.upkeep_soldiers, r_user.upkeep_commanders + r_user.upkeep_scientists + r_user.upkeep_soldiers + r_user.upkeep_ships + r_user.upkeep_ships_in_position + r_user.upkeep_ships_parked + r_user.upkeep_planets, r_user.production_prestige, r_user.credits_produced,

		'{upkeep_commanders:' || r_user.upkeep_commanders || ',upkeep_planets:' || r_user.upkeep_planets || ',upkeep_scientists:' || r_user.upkeep_scientists || ',upkeep_soldiers:' || r_user.upkeep_soldiers || ',upkeep_ships:' || r_user.upkeep_ships || ',upkeep_ships_in_position:' || r_user.upkeep_ships_in_position || ',upkeep_ships_parked:' || r_user.upkeep_ships_parked || ',credits:' || r_user.upkeep_commanders + r_user.upkeep_scientists + r_user.upkeep_soldiers + r_user.upkeep_ships + r_user.upkeep_ships_in_position + r_user.upkeep_ships_parked + r_user.upkeep_planets || '}');

		--INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, shipid, quantity)

		--VALUES(r_user.id, -count*r_ship.cost_credits, $1, $2, count);

	END IF;

	-- check bankruptcy

	SELECT INTO r_user credits, credits_bankruptcy FROM gm_profiles WHERE id=$1;

	IF r_user.credits < 0 THEN

		UPDATE gm_profiles SET

			credits_bankruptcy = credits_bankruptcy - 1

		WHERE id=$1 AND credits < 0;

		IF FOUND THEN

			IF r_user.credits_bankruptcy = 120 THEN

				PERFORM 1 FROM gm_profile_reports WHERE ownerid=$1 AND type=7 AND subtype=95 AND datetime > NOW() - INTERVAL '1 day';

				IF NOT FOUND THEN

					INSERT INTO gm_profile_reports(ownerid, type, subtype) VALUES($1, 7, 95);

				END IF;

			ELSEIF r_user.credits_bankruptcy = 72 THEN

				PERFORM 1 FROM gm_profile_reports WHERE ownerid=$1 AND type=7 AND subtype=96 AND datetime > NOW() - INTERVAL '1 day';

				IF NOT FOUND THEN

					INSERT INTO gm_profile_reports(ownerid, type, subtype) VALUES($1, 7, 96);

				END IF;

			ELSEIF r_user.credits_bankruptcy = 36 THEN

				PERFORM 1 FROM gm_profile_reports WHERE ownerid=$1 AND type=7 AND subtype=97 AND datetime > NOW() - INTERVAL '1 day';

				IF NOT FOUND THEN

					INSERT INTO gm_profile_reports(ownerid, type, subtype) VALUES($1, 7, 97);

				END IF;

			ELSEIF r_user.credits_bankruptcy = 24 THEN

				PERFORM 1 FROM gm_profile_reports WHERE ownerid=$1 AND type=7 AND subtype=98 AND datetime > NOW() - INTERVAL '1 day';

				IF NOT FOUND THEN

					INSERT INTO gm_profile_reports(ownerid, type, subtype) VALUES($1, 7, 98);

				END IF;

			ELSEIF r_user.credits_bankruptcy = 1 THEN

				-- player is now bankrupt, lose his planets, stop gm_profile_researches

				UPDATE gm_planets SET

					production_lastupdate=now(),

					ownerid=2,

					recruit_workers=true

				WHERE ownerid=$1;

				DELETE FROM gm_profile_research_pendings WHERE userid=$1;

			END IF;

		END IF;

	ELSE

		UPDATE gm_profiles SET

			credits_bankruptcy = credits_bankruptcy + 1

		WHERE id=$1 AND credits_bankruptcy < static_profile_bankruptcy_hours() ;

	END IF;

END;$_$;


ALTER FUNCTION ng03.internal_profile_update_data(_userid integer, _hour integer) OWNER TO exileng;

--
-- Name: internal_profile_update_modifiers(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_update_modifiers(_userid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_research record;

BEGIN

	SELECT INTO r_research

		float8_mult( 1.0 + mod_production_ore * level ) AS mod_production_ore,

		float8_mult( 1.0 + mod_production_hydrocarbon * level ) AS mod_production_hydrocarbon,

		float8_mult( 1.0 + mod_production_energy * level ) AS mod_production_energy,

		float8_mult( 1.0 + mod_production_workers * level )AS mod_production_workers,

		float8_mult( 1.0 + mod_construction_speed_buildings * level ) AS mod_construction_speed_buildings,

		float8_mult( 1.0 + mod_construction_speed_ships * level ) AS mod_construction_speed_ships,

		float8_mult( 1.0 + mod_fleet_damage * level ) AS mod_fleet_damage,

		float8_mult( 1.0 + mod_fleet_speed * level ) AS mod_fleet_speed,

		float8_mult( 1.0 + mod_fleet_shield * level ) AS mod_fleet_shield,

		float8_mult( 1.0 + mod_fleet_handling * level ) AS mod_fleet_handling,

		float8_mult( 1.0 + mod_fleet_tracking_speed * level ) AS mod_fleet_tracking_speed,

		float8_mult( 1.0 + mod_fleet_energy_capacity * level ) AS mod_fleet_energy_capacity,

		float8_mult( 1.0 + mod_fleet_energy_usage * level ) AS mod_fleet_energy_usage,

		float8_mult( 1.0 + mod_fleet_signature * level ) AS mod_fleet_signature,

		float8_mult( 1.0 + mod_merchant_buy_price * level ) AS mod_merchant_buy_price,

		float8_mult( 1.0 + mod_merchant_sell_price * level ) AS mod_merchant_sell_price,

		float8_mult( 1.0 + mod_merchant_speed * level ) AS mod_merchant_speed,

		float8_mult( 1.0 + mod_upkeep_commanders_cost * level ) AS mod_upkeep_commanders_cost,

		float8_mult( 1.0 + mod_upkeep_planets_cost * level ) AS mod_upkeep_planets_cost,

		float8_mult( 1.0 + mod_upkeep_scientists_cost * level ) AS mod_upkeep_scientists_cost,

		float8_mult( 1.0 + mod_upkeep_soldiers_cost * level ) AS mod_upkeep_soldiers_cost,

		float8_mult( 1.0 + mod_upkeep_ships_cost * level ) AS mod_upkeep_ships_cost,

		float8_mult( 1.0 + mod_research_cost * level ) AS mod_research_cost,

		float8_mult( 1.0 + mod_research_time * level ) AS mod_research_time,

		float8_mult( 1.0 + mod_recycling * level ) AS mod_recycling,

		COALESCE( sum( mod_planets * level ), 0) AS mod_planets,

		COALESCE( sum( mod_commanders * level ), 0) AS mod_commanders,

		float8_mult( 1.0 + mod_research_effectiveness * level ) AS mod_research_effectiveness,

		float8_mult( 1.0 + mod_energy_transfer_effectiveness * level ) AS mod_energy_transfer_effectiveness,

		float8_mult( 1.0 + mod_prestige_from_buildings * level ) AS mod_prestige_from_buildings,

		float8_mult( 1.0 + mod_prestige_from_ships * level ) AS mod_prestige_from_ships,

		float8_mult( 1.0 + mod_planet_need_ore * level ) AS mod_planet_need_ore,

		float8_mult( 1.0 + mod_planet_need_hydrocarbon * level ) AS mod_planet_need_hydrocarbon,

		float8_mult( 1.0 + modf_bounty * level ) AS modf_bounty

	FROM gm_profile_researches

		INNER JOIN dt_researches ON (gm_profile_researches.researchid = dt_researches.id)

	WHERE userid = _userid;

	UPDATE gm_profiles SET

		mod_production_ore = r_research.mod_production_ore,

		mod_production_hydrocarbon = r_research.mod_production_hydrocarbon,

		mod_production_energy = r_research.mod_production_energy,

		mod_production_workers = r_research.mod_production_workers,

		mod_construction_speed_buildings = r_research.mod_construction_speed_buildings,

		mod_construction_speed_ships = r_research.mod_construction_speed_ships,

		mod_fleet_damage = r_research.mod_fleet_damage,

		mod_fleet_speed = r_research.mod_fleet_speed,

		mod_fleet_shield = r_research.mod_fleet_shield,

		mod_fleet_handling = r_research.mod_fleet_handling,

		mod_fleet_tracking_speed = r_research.mod_fleet_tracking_speed,

		mod_fleet_energy_capacity = r_research.mod_fleet_energy_capacity,

		mod_fleet_energy_usage = r_research.mod_fleet_energy_usage,

		mod_fleet_signature = r_research.mod_fleet_signature,

		mod_merchant_buy_price = r_research.mod_merchant_buy_price,

		mod_merchant_sell_price = r_research.mod_merchant_sell_price,

		mod_merchant_speed = r_research.mod_merchant_speed,

		mod_upkeep_commanders_cost = r_research.mod_upkeep_commanders_cost,

		mod_upkeep_planets_cost = r_research.mod_upkeep_planets_cost,

		mod_upkeep_scientists_cost = r_research.mod_upkeep_scientists_cost,

		mod_upkeep_soldiers_cost = r_research.mod_upkeep_soldiers_cost,

		mod_upkeep_ships_cost = r_research.mod_upkeep_ships_cost,

		mod_research_cost = r_research.mod_research_cost,

		mod_research_time = r_research.mod_research_time,

		mod_recycling = r_research.mod_recycling,

		mod_planets = r_research.mod_planets,

		mod_commanders = r_research.mod_commanders,

		mod_research_effectiveness = r_research.mod_research_effectiveness,

		mod_energy_transfer_effectiveness = r_research.mod_energy_transfer_effectiveness,

		mod_prestige_from_buildings = r_research.mod_prestige_from_buildings,

		mod_prestige_from_ships = r_research.mod_prestige_from_ships,

		mod_planet_need_ore = r_research.mod_planet_need_ore,

		mod_planet_need_hydrocarbon = r_research.mod_planet_need_hydrocarbon,

		modf_bounty = r_research.modf_bounty

	WHERE id=_userid;

END;$$;


ALTER FUNCTION ng03.internal_profile_update_modifiers(_userid integer) OWNER TO exileng;

--
-- Name: internal_profile_update_research_pendings_time(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.internal_profile_update_research_pendings_time(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

DECLARE

	research record;

	r_pending gm_profile_research_pendings;

	pct float8;

BEGIN

	FOR r_pending IN

		SELECT * FROM gm_profile_research_pendings WHERE userid=$1

	LOOP

		-- compute percentage of research done

		pct := date_part('epoch', r_pending.end_time - now()) / date_part('epoch', r_pending.end_time - r_pending.start_time);

		-- retrieve research time

		SELECT INTO research total_time

		FROM internal_profile_get_researches_status($1)

		WHERE researchid=r_pending.researchid AND researchable;

		-- if not found then no more research can be done

		IF research.total_time IS NOT NULL THEN

			UPDATE gm_profile_research_pendings SET start_time=now()-((1-pct)*research.total_time*INTERVAL '1 second'), end_time = now() + pct*research.total_time*INTERVAL '1 second' WHERE id=r_pending.id;

		ELSE

			DELETE FROM gm_profile_research_pendings WHERE id=r_pending.id;

		END IF;

	END LOOP;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.internal_profile_update_research_pendings_time(integer) OWNER TO exileng;

--
-- Name: process_alliance_cleanings(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_alliance_cleanings() RETURNS void
    LANGUAGE sql
    AS $$DELETE FROM gm_alliance_invitations WHERE (declined AND replied < now()-INTERVAL '1 days') OR (created < now()-INTERVAL '7 days');

DELETE FROM gm_alliance_nap_offers WHERE (declined AND replied < now()-INTERVAL '1 days') OR (created < now()-INTERVAL '7 days');

-- delete gm_alliances that have no more members

DELETE FROM gm_alliances WHERE NOT EXISTS(SELECT 1 FROM gm_profiles WHERE alliance_id=gm_alliances.id LIMIT 1);$$;


ALTER FUNCTION ng03.process_alliance_cleanings() OWNER TO exileng;

--
-- Name: process_alliance_leavings(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_alliance_leavings(_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

BEGIN

	FOR r_user IN

		SELECT id

		FROM gm_profiles

		WHERE leave_alliance_datetime IS NOT NULL AND leave_alliance_datetime <= now()

		ORDER BY leave_alliance_datetime

		LIMIT _count

	LOOP

		UPDATE gm_profiles SET

			alliance_id = NULL,

			leave_alliance_datetime = NULL

		WHERE id=r_user.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_alliance_leavings(_count integer) OWNER TO exileng;

--
-- Name: process_alliance_nap_breakings(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_alliance_nap_breakings(_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_nap record;

BEGIN

	FOR r_nap IN 

		SELECT allianceid1, allianceid2

		FROM gm_alliance_naps

		WHERE break_on IS NOT NULL AND break_on <= now()

		ORDER BY break_on

		LIMIT _count

	LOOP

		DELETE FROM gm_alliance_naps

		WHERE allianceid1 = r_nap.allianceid1 AND allianceid2=r_nap.allianceid2;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_alliance_nap_breakings(_count integer) OWNER TO exileng;

--
-- Name: process_alliance_tributes(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_alliance_tributes(_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_tribute record;

BEGIN

	FOR r_tribute IN 

		SELECT t.allianceid, t.target_allianceid, t.credits, 

			'[' || gm_alliances.tag || '] ' || gm_alliances.name AS a_name,

			'[' || target.tag || '] ' || target.name AS target_name

		FROM gm_alliance_tributes t

			INNER JOIN gm_alliances ON (gm_alliances.id=t.allianceid)

			INNER JOIN gm_alliances AS target ON (target.id=t.target_allianceid)

		WHERE next_transfer <= now()

		ORDER BY next_transfer

		LIMIT _count

	LOOP

		UPDATE gm_alliances SET

			credits = credits - r_tribute.credits

		WHERE id=r_tribute.allianceid AND credits >= r_tribute.credits;

		IF FOUND THEN

			INSERT INTO gm_alliance_wallet_logs(allianceid, credits, destination, type)

			VALUES(r_tribute.allianceid, -r_tribute.credits, r_tribute.target_name, 20);

			UPDATE gm_alliances SET

				credits = credits + r_tribute.credits

			WHERE id=r_tribute.target_allianceid;

			INSERT INTO gm_alliance_wallet_logs(allianceid, credits, source, type)

			VALUES(r_tribute.target_allianceid, r_tribute.credits, r_tribute.a_name, 20);

		ELSE

			UPDATE gm_alliance_tributes SET

				next_transfer = date_trunc('day'::text, now()) + '1 day'::interval

			WHERE allianceid=r_tribute.allianceid AND target_allianceid=r_tribute.target_allianceid;			

			-- warn the alliance leader that the tribute could not be paid

			INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid, credits) 

			SELECT id, 1, 50, r_tribute.target_allianceid, r_tribute.credits

			FROM gm_profiles

				INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

			WHERE alliance_id=r_tribute.allianceid AND (r.leader OR r.can_create_nap);

			-- warn the target alliance leaders that the tribute was not paid

			INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid, credits)

			SELECT id, 1, 51, r_tribute.allianceid, r_tribute.credits

			FROM gm_profiles

				INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

			WHERE alliance_id=r_tribute.target_allianceid AND (r.leader OR r.can_create_nap);

		END IF;

		UPDATE gm_alliance_tributes SET

			next_transfer = date_trunc('day'::text, now()) + '1 day'::interval

		WHERE allianceid=r_tribute.allianceid AND target_allianceid=r_tribute.target_allianceid;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_alliance_tributes(_count integer) OWNER TO exileng;

--
-- Name: process_alliance_war_endings(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_alliance_war_endings(_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_war record;

BEGIN

	FOR r_war IN 

		SELECT allianceid1, allianceid2

		FROM gm_alliance_wars

		WHERE cease_fire_requested IS NOT NULL AND cease_fire_expire <= now()

		ORDER BY cease_fire_expire

		LIMIT _count

	LOOP

		UPDATE gm_alliance_wars SET

			cease_fire_requested = NULL,

			cease_fire_expire = NULL

		WHERE allianceid1 = r_war.allianceid1 AND allianceid2=r_war.allianceid2;

	END LOOP;

	FOR r_war IN 

		SELECT allianceid1, allianceid2

		FROM gm_alliance_wars

		WHERE next_bill IS NOT NULL AND next_bill < now()

		ORDER BY next_bill

		LIMIT _count

	LOOP

		DELETE FROM gm_alliance_wars WHERE allianceid1=r_war.allianceid1 AND allianceid2=r_war.allianceid2;

		INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid)

		SELECT id, 1, 62, r_war.allianceid1

		FROM gm_profiles

			INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

		WHERE alliance_id=r_war.allianceid2 AND (r.leader OR r.can_create_nap);	

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_alliance_war_endings(_count integer) OWNER TO exileng;

--
-- Name: process_commander_promotions(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_commander_promotions() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_commander record;

BEGIN

	FOR r_commander IN

		SELECT id, ownerid, name

		FROM gm_commanders

		WHERE salary_last_increase < now()-INTERVAL '2 week' AND random() < 0.1

	LOOP

		PERFORM internal_commander_promote(r_commander.ownerid, r_commander.id);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_commander_promotions() OWNER TO exileng;

--
-- Name: process_daily_cleaning(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_daily_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_profiles SET credits=1000000 WHERE id < 100;

	DELETE FROM gm_alliance_reports WHERE datetime < now() - INTERVAL '2 weeks';

	-- remove alliance wallet journal entries older than a month

	DELETE FROM gm_alliance_wallet_logs WHERE datetime < now() - INTERVAL '2 weeks';

	DELETE FROM gm_profile_reports WHERE datetime < now() - INTERVAL '2 weeks';

	DELETE FROM gm_mails WHERE datetime < now() - INTERVAL '2 month';

	-- remove IP addresses older than 3 months

	DELETE FROM gm_profile_connections WHERE datetime < now() - INTERVAL '3 months';

	-- remove gm_profiles expenses older than 2 weeks

	DELETE FROM gm_log_profile_actions WHERE datetime < now() - INTERVAL '2 week';

	DELETE FROM log_failed_logins WHERE datetime < now()-INTERVAL '2 week';

	DELETE FROM gm_log_server_errors WHERE datetime < now()-INTERVAL '1 week';

	DELETE FROM gm_log_notices WHERE datetime < now()-INTERVAL '1 week';

	DELETE FROM gm_log_markets WHERE datetime < now()-INTERVAL '2 months';

	DELETE FROM gm_profiles_newemails WHERE expiration < now();

	-- clean chats

	DELETE FROM gm_chat_lines WHERE datetime < now()-INTERVAL '2 weeks';

	DELETE FROM gm_chats WHERE id > 0 AND NOT public AND name IS NOT NULL AND (SELECT count(1) FROM gm_profile_chats WHERE chatid=gm_chats.id) = 0;

	DELETE FROM gm_chat_online_profiles WHERE lastactivity < now() - INTERVAL '15 minutes';

	-- destroy lost gm_fleets

	PERFORM user_fleet_leave(2, id) FROM gm_fleets WHERE ownerid=2 AND idle_since < now() - INTERVAL '1 day';

	DELETE FROM gm_fleets WHERE planetid is null AND dest_planetid is null AND idle_since < now() - INTERVAL '1 week' AND action = 0;

	UPDATE gm_fleets SET action=4 WHERE action = 2 and recycler_output = 0;

	UPDATE gm_profiles SET

		planets = 0

	WHERE planets > 0 AND NOT EXISTS(SELECT 1 FROM gm_planets WHERE ownerid=gm_profiles.id LIMIT 1);

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_daily_cleaning() OWNER TO exileng;

--
-- Name: process_fleet_movings(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_fleet_movings(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_fleet record;

BEGIN

	-- gm_fleets movements

	FOR r_fleet IN 

		SELECT gm_fleets.ownerid, gm_fleets.id, gm_fleets.name, gm_fleets.dest_planetid, gm_fleets.action, gm_planets.ownerid AS dest_planet_ownerid, gm_planets.production_frozen,

			gm_planets.galaxy, gm_planets.sector, gm_planets.planet, military_signature

		FROM gm_fleets

			LEFT JOIN gm_planets ON gm_planets.id=gm_fleets.dest_planetid

		WHERE (action=1 OR action=-1) AND NOT gm_fleets.engaged AND gm_fleets.action_end_time <= now() + _precision

		ORDER BY gm_fleets.action_end_time LIMIT _count

	LOOP

		-- gm_profile_reports

		IF r_fleet.action <> -1 AND r_fleet.ownerid <> 3 AND r_fleet.dest_planetid IS NOT NULL THEN

			-- send a report to owner to notify that his gm_fleets arrived at destination

			INSERT INTO gm_profile_reports(ownerid, type, fleetid, fleet_name, planetid, data) 

			VALUES(r_fleet.ownerid, 4, r_fleet.id, r_fleet.name, r_fleet.dest_planetid, '{fleet:{id:' || r_fleet.id || ',name:' || tool_quote(r_fleet.name) || '},planet:{id:' || r_fleet.dest_planetid || ',g:' || r_fleet.galaxy || ',s:' || r_fleet.sector || ',p:' || r_fleet.planet || ',owner:' || COALESCE(tool_quote(internal_profile_get_name(r_fleet.dest_planet_ownerid)), 'null') || '}}');

			IF r_fleet.dest_planet_ownerid <> r_fleet.ownerid THEN

				-- send a report to planet owner to notify that a fleet arrived near his planet

				INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, fleet_name, planetid, data)

				VALUES(r_fleet.dest_planet_ownerid, 4, 3, r_fleet.ownerid, r_fleet.name, r_fleet.dest_planetid, '{fleet:{owner:"' || internal_profile_get_name(r_fleet.ownerid) || '"},planet:{id:' || r_fleet.dest_planetid || ',g:' || r_fleet.galaxy || ',s:' || r_fleet.sector || ',p:' || r_fleet.planet || ',owner:' || COALESCE(tool_quote(internal_profile_get_name(r_fleet.dest_planet_ownerid)), 'null') || '}}');

			END IF;

		END IF;

		-- update fleet

		UPDATE gm_fleets SET

			planetid = dest_planetid,

			dest_planetid = NULL,

			action_start_time = NULL,

			action_end_time = NULL,

			action = 0,

			idle_since=now()

		WHERE id=r_fleet.id;

/*

		IF r_fleet.ownerid <> r_fleet.dest_planet_ownerid AND r_fleet.production_frozen THEN

			-- make enemy/ally/friend gm_fleets to go elsewhere if the planet is frozen/in holidays

			PERFORM user_fleet_move(r_fleet.ownerid, r_fleet.id, internal_planet_find_nearest(r_fleet.ownerid, r_fleet.dest_planetid));

			--INSERT INTO gm_log_server_errors(details) VALUES('user_fleet_move(' || r_fleet.ownerid || ', ' || r_fleet.id || ', ' || 'internal_planet_find_nearest(' || r_fleet.ownerid || ', ' || r_fleet.dest_planet_ownerid || ')');

		END IF;

*/

		-- make battle starts 1 minute later if a military fleet of 10k arrives

		IF r_fleet.action = 1 AND r_fleet.military_signature > 5000 THEN

			UPDATE gm_planets SET

				next_battle=now() + LEAST(r_fleet.military_signature/10000.0, 5) * INTERVAL '1 minute'

			WHERE id=r_fleet.dest_planetid AND next_battle IS NOT NULL AND next_battle < now() + LEAST(r_fleet.military_signature/10000.0, 5) * INTERVAL '1 minute';

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_fleet_movings(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_fleet_recyclings(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_fleet_recyclings(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$/*

DECLARE

	r_fleet record;

	remaining_space int4;

	max_recycled int4;

	rec_ore int4;

	rec_hydrocarbon int4;

	rec_subtype int2;	-- subtype for report (1=recycling stopped because cargo is full, 2=because there's nothing anymore)

BEGIN

	FOR r_fleet IN 

		SELECT gm_fleets.ownerid, gm_fleets.id, gm_fleets.name, gm_fleets.planetid, gm_fleets.recycler_output / 6 AS recycler_output, 

			cargo_capacity-cargo_ore-cargo_hydrocarbon-cargo_workers-cargo_scientists-cargo_soldiers AS cargo_free,

			orbit_ore, orbit_hydrocarbon, mod_recycling AS mod_recycling,

			spawn_ore, spawn_hydrocarbon

		FROM gm_fleets

			INNER JOIN gm_planets ON (gm_fleets.planetid = gm_planets.id)

		WHERE action=2 AND action_end_time <= now() + _precision

		ORDER BY action_end_time LIMIT _count

	LOOP

		max_recycled := LEAST(r_fleet.cargo_free, int4(r_fleet.recycler_output * r_fleet.mod_recycling));

		-- recyclers always recycle half ore half hydrocarbon

		rec_ore := LEAST(max_recycled / 2, r_fleet.orbit_ore);

		rec_hydrocarbon = LEAST(max_recycled / 2, r_fleet.orbit_hydrocarbon);

		-- if there's a lack of a resource then get more of the other resource

		remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

		IF remaining_space > 0 THEN

			IF r_fleet.orbit_ore > rec_ore THEN

				rec_ore := LEAST(rec_ore + remaining_space, r_fleet.orbit_ore);

				remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			END IF;

			IF r_fleet.orbit_hydrocarbon > rec_hydrocarbon THEN

				rec_hydrocarbon := LEAST(rec_hydrocarbon + remaining_space, r_fleet.orbit_hydrocarbon);

				remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			END IF;

			-- remaining_space contains the capacity of the recyclers that have found nothing to recycle

			-- so if it is > 0 then it means we have nothing to recycle anymore or the cargo is full

		END IF;

		IF (remaining_space > 0 AND r_fleet.spawn_ore = 0 AND r_fleet.spawn_hydrocarbon = 0) OR (r_fleet.cargo_free <= rec_ore + rec_hydrocarbon) THEN

			-- there's nothing to recycle anymore or cargo is full

			UPDATE gm_fleets SET

				action_start_time = NULL,

				action_end_time = NULL,

				action=0,

				cargo_ore = cargo_ore + rec_ore,

				cargo_hydrocarbon = cargo_hydrocarbon + rec_hydrocarbon

			WHERE id=r_fleet.id;

			IF remaining_space = 0 THEN

				rec_subtype := 1;

			ELSE

				rec_subtype := 2;

			END IF;

			INSERT INTO gm_profile_reports(ownerid, type, subtype, fleetid, fleet_name, planetid, data)

			VALUES(r_fleet.ownerid, 4, rec_subtype, r_fleet.id, r_fleet.name, r_fleet.planetid, '{fleet:{id:' || r_fleet.id || '}}');

		ELSE

			-- continue recycling

			UPDATE gm_fleets SET

				action_start_time = now(),

				action_end_time = now()+INTERVAL '10 minutes',

				cargo_ore = cargo_ore + rec_ore,

				cargo_hydrocarbon = cargo_hydrocarbon + rec_hydrocarbon

			WHERE id=r_fleet.id;

		END IF;

		-- remove resources from planet orbit

		UPDATE gm_planets SET

			orbit_ore = GREATEST(0, orbit_ore - rec_ore),

			orbit_hydrocarbon = GREATEST(0, orbit_hydrocarbon - rec_hydrocarbon)

		WHERE id=r_fleet.planetid;

	END LOOP;

	RETURN;

END;

*/

DECLARE

	r_fleet record;

	remaining_space int4;

	max_recycled int4;

	produced int4;

	rec_ore int4;

	rec_hydrocarbon int4;

	rec_subtype int2;	-- subtype for report (1=recycling stopped because cargo is full, 2=because there's nothing anymore)

BEGIN

	FOR r_fleet IN 

		SELECT gm_fleets.ownerid, gm_fleets.id, gm_fleets.name, gm_fleets.planetid, gm_fleets.recycler_output / 6 AS recycler_output, 

			cargo_capacity-cargo_ore-cargo_hydrocarbon-cargo_workers-cargo_scientists-cargo_soldiers AS cargo_free,

			orbit_ore, orbit_hydrocarbon, mod_recycling,

			spawn_ore, spawn_hydrocarbon, recycler_percent

		FROM gm_fleets

			INNER JOIN gm_planets ON (gm_fleets.planetid = gm_planets.id)

		WHERE action=2 AND action_end_time <= now() + _precision

		ORDER BY action_end_time LIMIT _count

	LOOP

		max_recycled := LEAST(r_fleet.cargo_free, int4(r_fleet.recycler_output /* * r_fleet.mod_recycling*/));

		--------------------------------

		-- RECYCLE resources in orbit --

		--------------------------------

		-- recyclers always recycle half ore half hydrocarbon

		rec_ore := LEAST(max_recycled / 2, r_fleet.orbit_ore);

		rec_hydrocarbon = LEAST(max_recycled / 2, r_fleet.orbit_hydrocarbon);

		-- if there's a lack of a resource then get more of the other resource

		remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

		IF remaining_space > 0 THEN

			IF r_fleet.orbit_ore > rec_ore THEN

				rec_ore := LEAST(rec_ore + remaining_space, r_fleet.orbit_ore);

				remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			END IF;

			IF r_fleet.orbit_hydrocarbon > rec_hydrocarbon THEN

				rec_hydrocarbon := LEAST(rec_hydrocarbon + remaining_space, r_fleet.orbit_hydrocarbon);

				remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			END IF;

			-- remaining_space is the capacity of the recyclers that have not found anything to recycle

			-- so if it is > 0 then it means we have nothing to recycle anymore from this location

		END IF;

		-- remove resources from planet orbit

		IF rec_ore > 0 OR rec_hydrocarbon > 0 THEN

			UPDATE gm_planets SET

				orbit_ore = GREATEST(0, orbit_ore - int4(rec_ore /* r_fleet.mod_recycling*/)),

				orbit_hydrocarbon = GREATEST(0, orbit_hydrocarbon - int4(rec_hydrocarbon /* r_fleet.mod_recycling*/))

			WHERE id=r_fleet.planetid;

		END IF;

		-------------------------------------------

		-- RECYCLE resources from resource field --

		-------------------------------------------

		IF remaining_space > 0 AND (r_fleet.spawn_ore > 0 OR r_fleet.spawn_hydrocarbon > 0) THEN

			--RAISE NOTICE '%', remaining_space;

			produced := int4(r_fleet.spawn_ore * r_fleet.recycler_percent * 0.2);

			rec_ore := rec_ore + LEAST(remaining_space, produced);

			remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			--RAISE NOTICE '%', remaining_space;

			produced := int4(r_fleet.spawn_hydrocarbon * r_fleet.recycler_percent * 0.2);

			rec_hydrocarbon := rec_hydrocarbon + LEAST(remaining_space, produced);

			remaining_space := max_recycled - rec_ore - rec_hydrocarbon;

			--RAISE NOTICE '%', remaining_space;

		END IF;

		IF (remaining_space > 0 AND r_fleet.spawn_ore = 0 AND r_fleet.spawn_hydrocarbon = 0) OR (r_fleet.cargo_free <= rec_ore + rec_hydrocarbon) THEN

			-- there's nothing to recycle anymore or cargo is full

			UPDATE gm_fleets SET

				action_start_time = NULL,

				action_end_time = NULL,

				idle_since = now(),

				action = 0,

				cargo_ore = cargo_ore + rec_ore,

				cargo_hydrocarbon = cargo_hydrocarbon + rec_hydrocarbon

			WHERE id=r_fleet.id;

			PERFORM internal_planet_update_orbitting_fleets_recycling_percent(r_fleet.planetid);

			IF remaining_space = 0 THEN

				rec_subtype := 1;

			ELSE

				rec_subtype := 2;

			END IF;

			INSERT INTO gm_profile_reports(ownerid, type, subtype, fleetid, fleet_name, planetid)

			VALUES(r_fleet.ownerid, 4, rec_subtype, r_fleet.id, r_fleet.name, r_fleet.planetid);

		ELSE

			-- continue recycling

			UPDATE gm_fleets SET

				action_start_time = now(),

				action_end_time = now() + INTERVAL '10 minutes' / mod_recycling,

				cargo_ore = cargo_ore + rec_ore,

				cargo_hydrocarbon = cargo_hydrocarbon + rec_hydrocarbon

			WHERE id=r_fleet.id;

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_fleet_recyclings(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_fleet_route_cleaning(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_fleet_route_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_route record;

BEGIN

	FOR r_route IN 

		SELECT id

		FROM gm_fleet_routes

		WHERE ownerid is null AND last_used < now()-INTERVAL '1 day' AND NOT EXISTS( SELECT 1 FROM gm_fleets INNER JOIN gm_fleet_route_waypoints ON (gm_fleet_route_waypoints.id=gm_fleets.next_waypointid) WHERE gm_fleet_route_waypoints.routeid=gm_fleet_routes.id )

		LIMIT 50

	LOOP

		DELETE FROM gm_fleet_routes WHERE id=r_route.id;

	END LOOP;

END;$$;


ALTER FUNCTION ng03.process_fleet_route_cleaning() OWNER TO exileng;

--
-- Name: process_fleet_waitings(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_fleet_waitings() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_fleet record;

BEGIN

	-- gm_fleets waiting

	FOR r_fleet IN 

		SELECT gm_fleets.id

		FROM gm_fleets

		WHERE action=4 AND gm_fleets.action_end_time <= now()+INTERVAL '3 seconds'

		ORDER BY gm_fleets.action_end_time LIMIT 10

	LOOP

		-- update fleet

		UPDATE gm_fleets SET

			action_start_time = NULL,

			action_end_time = NULL,

			action = 0

		WHERE id=r_fleet.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_fleet_waitings() OWNER TO exileng;

--
-- Name: process_galaxy_market_price(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_galaxy_market_price() RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_galaxies SET

		price_ore = LEAST(200, GREATEST(50, 200 - power(GREATEST(1, traded_ore), 0.95) / 10000000.0)),

		price_hydrocarbon = LEAST(200, GREATEST(50, 200 - power(GREATEST(1, traded_hydrocarbon), 0.95) / 10000000.0)),

		traded_ore = COALESCE(traded_ore - 200.0 * power(200.0 / LEAST(200, GREATEST(50, 200.0 - power(GREATEST(1, traded_ore), 0.95) / 10000000.0)), 2) * 

						(SELECT GREATEST(0.5, (count(*) / 1200.0)) * sum(200.0 / gm_planets.floor)

						FROM gm_planets

							INNER JOIN gm_profiles ON (gm_planets.ownerid=gm_profiles.id)

						WHERE gm_planets.galaxy=gm_galaxies.id AND gm_planets.ownerid > 100 AND gm_planets.score > 0 AND floor > 0 AND gm_profiles.lastlogin - gm_profiles.regdate > INTERVAL '2 days' AND gm_profiles.lastlogin > now() - INTERVAL '2 weeks'), 0),

		traded_hydrocarbon = COALESCE(traded_hydrocarbon - 200.0 * power(200.0 / LEAST(200, GREATEST(50, 200.0 - power(GREATEST(1, traded_hydrocarbon), 0.95) / 10000000.0)), 2) * 

						(SELECT GREATEST(0.5, (count(*) / 1200.0)) * sum(200.0 / gm_planets.floor)

						FROM gm_planets

							INNER JOIN gm_profiles ON (gm_planets.ownerid=gm_profiles.id)

						WHERE gm_planets.galaxy=gm_galaxies.id AND gm_planets.ownerid > 100 AND gm_planets.score > 0 AND floor > 0 AND gm_profiles.lastlogin - gm_profiles.regdate > INTERVAL '2 days' AND gm_profiles.lastlogin > now() - INTERVAL '2 weeks'), 0);

END;$$;


ALTER FUNCTION ng03.process_galaxy_market_price() OWNER TO exileng;

--
-- Name: process_lottery(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_lottery() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_contestant record;

	_total bigint;

	_winner bigint;

	_fleet_id integer;

BEGIN

	BEGIN

		LOCK TABLE gm_profiles, gm_mails;

		SELECT INTO _total sum(credits)

		FROM gm_mails

		WHERE ownerid=3 AND read_date IS NULL AND gm_mails.credits > 0;

		_winner := (random() * _total)::bigint;

		FOR r_contestant IN

			SELECT senderid, lcid, login, sum(gm_mails.credits) AS credits

			FROM gm_mails

				INNER JOIN gm_profiles ON (gm_profiles.id = gm_mails.senderid)

			WHERE ownerid=3 AND read_date IS NULL AND gm_mails.credits > 0 AND planets > 0

			GROUP BY senderid, lcid, login

			ORDER BY random()

		LOOP

			IF _winner >= 0 AND _winner < r_contestant.credits THEN

				PERFORM admin_send_mail(r_contestant.senderid, 11, r_contestant.lcid, r_contestant.credits::character varying, '');

				_fleet_id := nextval('gm_fleets_id_seq');

				INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since, speed)

				VALUES(_fleet_id, r_contestant.senderid, null, 'Gros lot', now(), 800);

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(_fleet_id, 605, 1);

				UPDATE gm_fleets SET

					dest_planetid = (SELECT id FROM gm_planets WHERE ownerid=r_contestant.senderid ORDER BY blocus_strength ASC, score DESC LIMIT 1),

					action_start_time = now(),

					action_end_time = now() + INTERVAL '8 hours',

					engaged = false,

					action = 1,

					idle_since = null

				WHERE id=_fleet_id;

				INSERT INTO ng03.users_successes(user_id, success_id, universe_id)

				VALUES(r_contestant.senderid, 4, const_universe_id());

			ELSE

				PERFORM admin_send_mail(r_contestant.senderid, 10, r_contestant.lcid, r_contestant.credits::character varying, '');

			END IF;

			_winner := _winner - r_contestant.credits;

		END LOOP;

		UPDATE gm_mails SET

			read_date = now()

		WHERE ownerid=3;

		PERFORM admin_send_mail(id, 12, lcid)

		FROM gm_profiles

		WHERE privilege = 0 AND login is not null;

	EXCEPTION

		WHEN NO_DATA_FOUND THEN

			-- nothing, just need to have a when clause

	END;

END;$$;


ALTER FUNCTION ng03.process_lottery() OWNER TO exileng;

--
-- Name: process_merchant_contracts(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_merchant_contracts() RETURNS void
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

DECLARE

	r_player record;

	r_user record;

	r_research record;

BEGIN

	FOR r_player IN

		SELECT username, sum(ore_sold) + sum(hydrocarbon_sold) as total_sold

		FROM gm_log_markets

		WHERE datetime > now()-interval '1 week'-- AND ore_sold > 0 and hydrocarbon_sold > 0

		GROUP BY username

		ORDER BY total_sold DESC

		LIMIT 20

	LOOP

		SELECT INTO r_user id, lcid

		FROM gm_profiles

		WHERE login=r_player.username;

		IF FOUND THEN

			SELECT INTO r_research expires < now() as expired FROM gm_profile_researches WHERE userid=r_user.id AND researchid=5;

			IF FOUND THEN

				IF r_research.expired THEN

					PERFORM admin_send_mail(r_user.id, 3, r_user.lcid);

					UPDATE gm_profile_researches SET

						expires=now()+INTERVAL '7 days'

					WHERE userid=r_user.id AND researchid=5;

				END IF;

			ELSE

				PERFORM admin_send_mail(r_user.id, 2, r_user.lcid);

				INSERT INTO gm_profile_researches(userid, researchid, expires)

				VALUES(r_user.id, 5, now()+INTERVAL '7 days');

				PERFORM internal_profile_update_modifiers(r_user.id);

			END IF;

		END IF;

	END LOOP;

	FOR r_player IN

		SELECT userid

		FROM gm_profile_researches

		WHERE researchid=5 AND expires IS NOT NULL AND expires < now()

	LOOP

		DELETE FROM gm_profile_researches WHERE userid=r_player.userid AND researchid=5;

		PERFORM admin_send_mail(r_player.userid, 4, (SELECT lcid FROM gm_profiles WHERE id=r_player.userid));

		PERFORM internal_profile_update_modifiers(r_player.userid);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_merchant_contracts() OWNER TO exileng;

--
-- Name: process_merchant_fleet_cleaning(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_merchant_fleet_cleaning() RETURNS void
    LANGUAGE sql
    AS $$UPDATE gm_fleets SET

	action=1, 

	action_end_time = now() + '3 hours',

	dest_planetid = null,

	engaged=false

WHERE ownerid=3 AND ((action=0 AND planetid IS NOT NULL AND next_waypointid IS NULL) OR (action <> 0 AND engaged AND action_end_time < now()));$$;


ALTER FUNCTION ng03.process_merchant_fleet_cleaning() OWNER TO exileng;

--
-- Name: process_merchant_unloadings(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_merchant_unloadings() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_market record;

	r_prices resource_price;

	total_ore int4;

	total_hydrocarbon int4;

	cr int4;

	price int4;

	_ore int4;

	_hydro int4;

BEGIN

	-- process when a player unload resources directly on a merchant planet

	FOR r_market IN 

		SELECT r.id, r.planetid, r.userid, r.ore, r.hydrocarbon, r.scientists, r.soldiers, r.workers, gm_planets.galaxy, gm_planets.sector, gm_profiles.login

		FROM gm_profile_reports r

			INNER JOIN gm_planets ON (gm_planets.id=r.planetid)

			INNER JOIN gm_profiles ON (gm_profiles.id=r.userid)

		WHERE r.ownerid=3 AND r.type=5 AND r.subtype=1 AND r.read_date IS NULL

		LIMIT 5 FOR UPDATE

	LOOP

		r_prices := internal_profile_get_resource_price(r_market.userid, r_market.galaxy);

/*

		_ore := r_market.ore;

		_hydro := r_market.hydrocarbon;

		WHILE ore > 0 OR hydro > 0 LOOP

			ore := GREATEST(0, ore - 10000000);

			hydro := GREATEST(0, hydro - 10000000);

		END LOOP;*/

		-- compute sale price

		total_ore := int4(r_market.ore/1000.0 * r_prices.sell_ore);

		total_hydrocarbon := int4(r_market.hydrocarbon/1000.0 * r_prices.sell_hydrocarbon);

		price := GREATEST(0, int4(total_ore + total_hydrocarbon + r_market.scientists * 25 + r_market.soldiers * 14 + r_market.workers * 0.01) - 20);

		cr := internal_profile_apply_alliance_tax(r_market.userid, price);

		UPDATE gm_profiles SET credits=credits+cr WHERE id=r_market.userid;

		INSERT INTO gm_profile_reports(ownerid, type, subtype, credits, ore, hydrocarbon, scientists, soldiers, workers)

		VALUES(r_market.userid, 5, 3, price, r_market.ore, r_market.hydrocarbon, r_market.scientists, r_market.soldiers, r_market.workers);

		INSERT INTO gm_log_markets(ore_sold,hydrocarbon_sold,scientists_sold,soldiers_sold,workers_sold,credits,username)

		VALUES(r_market.ore, r_market.hydrocarbon, r_market.scientists, r_market.soldiers, r_market.workers, price, r_market.login);

		-- update galaxy traded wares quantity

		UPDATE gm_galaxies SET

			traded_ore = traded_ore + r_market.ore,

			traded_hydrocarbon = traded_hydrocarbon + r_market.hydrocarbon

		WHERE id=r_market.galaxy;

		-- reset planet resources to default values

		UPDATE gm_planets SET ore=0, hydrocarbon=0, scientists=0, soldiers=0, workers=100000 WHERE id=r_market.planetid;

		-- set the gm_profile_reports as read

		UPDATE gm_profile_reports SET read_date=now() WHERE id=r_market.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_merchant_unloadings() OWNER TO exileng;

--
-- Name: process_planet_abandons(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_abandons() RETURNS void
    LANGUAGE plpgsql
    AS $$-- make some planets owned by lost nations join players empires

DECLARE

	r_planet record;

	r_user record;

BEGIN

	-- select a planet to abandon

	SELECT INTO r_planet id, galaxy, sector, planet

	FROM gm_planets

	WHERE ownerid=2 AND production_lastupdate < now()-INTERVAL '1 week' AND random() < 0.1

	ORDER BY random()

	LIMIT 1;

	IF NOT FOUND THEN

		RETURN;

	END IF;

	PERFORM internal_planet_reset(r_planet.id);

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_abandons() OWNER TO exileng;

--
-- Name: process_planet_bonuses(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_bonuses() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

	i int2;

	time int4;

BEGIN

	-- BAD ISSUE with random() makes it returns always the same random() value for each joined row

	FOR r_planet IN

		SELECT * FROM

		(SELECT p.id, p.ownerid, random() * gm_profiles.planets * 2 as rand, ore_production, hydrocarbon_production, workers, workers_capacity

		FROM vw_gm_planets p

			JOIN gm_profiles ON (gm_profiles.id = p.ownerid AND gm_profiles.privilege=0)

		WHERE p.ownerid > 100 AND planets <= 20 AND not production_frozen

		OFFSET 0) as t

		where t.rand < 0.05

	LOOP

		i := int2(random()*2);

		-- baby boom : 50

		-- ore bonus : 51

		-- hydrocarbon bonus : 52

		IF i = 0 AND false THEN

			-- only allow baby boom for planets with workers space and with at least 1000 workers

			IF (r_planet.workers_capacity - r_planet.workers < r_planet.workers_capacity / 3) OR (r_planet.workers < 1000) THEN

				RETURN;

			END IF;

			PERFORM 1 FROM gm_planet_buildings WHERE planetid = r_planet.id AND buildingid = 50;

			IF FOUND THEN

				RETURN;

			END IF;

			-- insert the baby boom building

			INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

			VALUES(r_planet.id, 50, 1);

		ELSEIF i = 1 AND r_planet.ore_production > 0 THEN

			-- check that there is not already a ore bonus building

			PERFORM 1 FROM gm_planet_buildings WHERE planetid = r_planet.id AND buildingid = 51;

			IF FOUND THEN

				RETURN;

			END IF;

			-- compute how long the bonus will remain in minutes

			time := int4(60 * 100000.0 / (r_planet.ore_production+1));

			IF time > 48*60 THEN

				time := int4(48*60 + random()*6*60);

			END IF;

			-- insert the bonus building

			INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

			VALUES(r_planet.id, 51, 1, now()+time*INTERVAL '1 minute');

			-- insert the gm_profile_reports

			INSERT INTO gm_profile_reports(ownerid, planetid, type, subtype)

			VALUES(r_planet.ownerid, r_planet.id, 7, 52);

			INSERT INTO gm_profile_reports(ownerid, planetid, type, subtype, datetime)

			VALUES(r_planet.ownerid, r_planet.id, 7, 53, now()+time*INTERVAL '1 minute');

		ELSEIF i = 2 AND r_planet.hydrocarbon_production > 0 THEN

			-- check that there is not already a hydrocarbon bonus building

			PERFORM 1 FROM gm_planet_buildings WHERE planetid = r_planet.id AND buildingid = 52;

			IF FOUND THEN

				RETURN;

			END IF;

			-- compute how long the bonus will remain in minutes

			time := int4(60 * 100000.0 / r_planet.hydrocarbon_production+1);

			IF time > 48*60 THEN

				time := int4(48*60 + random()*6*60);

			END IF;

			-- insert the bonus building

			INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

			VALUES(r_planet.id, 52, 1, now()+time*INTERVAL '1 minute');

			-- insert the gm_profile_reports

			INSERT INTO gm_profile_reports(ownerid, planetid, type, subtype)

			VALUES(r_planet.ownerid, r_planet.id, 7, 54);

			INSERT INTO gm_profile_reports(ownerid, planetid, type, subtype, datetime)

			VALUES(r_planet.ownerid, r_planet.id, 7, 55, now()+time*INTERVAL '1 minute');

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_bonuses() OWNER TO exileng;

--
-- Name: process_planet_building_destructions(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_building_destructions(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_building record;

BEGIN

	FOR r_building IN

		SELECT planetid, buildingid, cost_ore, cost_hydrocarbon

		FROM gm_planet_buildings

			INNER JOIN dt_buildings ON (dt_buildings.id = gm_planet_buildings.buildingid)

		WHERE destroy_datetime IS NOT NULL AND destroy_datetime < now()+_precision

		ORDER BY destroy_datetime

		LIMIT _count

	LOOP

		UPDATE gm_planet_buildings SET

			quantity=quantity-1, destroy_datetime=NULL

		WHERE planetid=r_building.planetid AND buildingid=r_building.buildingid AND destroy_datetime IS NOT NULL AND destroy_datetime <= now()+_precision;

		IF FOUND THEN

			-- abandon planets that have no buildings owned by a player (not is_planet_element or building is being destroyed=deployed radar for instance)

			PERFORM 1

			FROM gm_planet_buildings

				INNER JOIN dt_buildings ON (gm_planet_buildings.buildingid=dt_buildings.id)

			WHERE planetid=r_building.planetid AND (NOT is_planet_element OR destroy_datetime IS NOT NULL);

			IF NOT FOUND THEN

				UPDATE gm_planets SET

					ownerid=null,

					name=''

				WHERE id=r_building.planetid;

			ELSE

				UPDATE gm_planets SET

					ore = ore + r_building.cost_ore*0.3,

					hydrocarbon = hydrocarbon + r_building.cost_hydrocarbon*0.3

				WHERE id=r_building.planetid;

			END IF;

		END IF;

	END LOOP;

END;$$;


ALTER FUNCTION ng03.process_planet_building_destructions(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_planet_building_pendings(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_building_pendings() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_pending record;

	r_building record;

BEGIN

	FOR r_pending IN

		SELECT p.id, p.planetid, p.buildingid, p."loop", gm_planets.ownerid

		FROM gm_planet_building_pendings p

			INNER JOIN gm_planets ON (gm_planets.id=p.planetid)

		WHERE p.end_time <= now()+INTERVAL '3 seconds'

		ORDER BY p.end_time LIMIT 25 FOR UPDATE

	LOOP

		SELECT INTO r_building cost_ore, cost_hydrocarbon, lifetime

		FROM dt_buildings

		WHERE id=r_pending.buildingid;

		UPDATE gm_profiles SET

			score_buildings=score_buildings + r_building.cost_ore + r_building.cost_hydrocarbon

		WHERE id=r_pending.ownerid;

		-- delete building from pending list

		DELETE FROM gm_planet_building_pendings WHERE id=r_pending.id;

		-- insert the building to the planet buildings

		INSERT INTO gm_planet_buildings(planetid, buildingid) VALUES(r_pending.planetid, r_pending.buildingid);

		IF r_building.lifetime > 0 THEN

			UPDATE gm_planet_buildings SET

				destroy_datetime = now() + r_building.lifetime*INTERVAL '1 second'

			WHERE planetid=r_pending.planetid AND buildingid=r_pending.buildingid;

		END IF;

		IF r_pending.ownerid IS NOT NULL THEN

			-- add a report 301 but with a datetime that is 7 days old to prevent it from appearing to the player

			INSERT INTO gm_profile_reports(datetime, read_date, ownerid, type, subtype, planetid, buildingid)

			VALUES(now(), now()-INTERVAL '1 month', r_pending.ownerid, 3, 1, r_pending.planetid, r_pending.buildingid);

		END IF;

		IF r_pending."loop" THEN

			PERFORM user_planet_building_start(r_pending.planetid, r_pending.buildingid, r_pending."loop");

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_building_pendings() OWNER TO exileng;

--
-- Name: process_planet_electromagnetic_storms(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_electromagnetic_storms() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

	q int4;

	maxstorms float;

BEGIN

	FOR r_planet IN

		SELECT p.id, p.ownerid, planets

		FROM gm_planets AS p

			INNER JOIN gm_profiles AS u ON (u.id = p.ownerid AND p.ownerid > 100)

		WHERE planet_floor > 0 AND (random() < 0.00005) AND NOT production_frozen AND (u.privilege=0) AND (u.planets > 5) AND (p.last_catastrophe < now()-INTERVAL '48 hours') FOR UPDATE

	LOOP

		-- check that we did not put an electromagnetic storm for this user less than 6 hours ago

		--PERFORM 1 FROM gm_profiles WHERE id=r_planet.ownerid AND last_catastrophe < now()-INTERVAL '6 hours';

		SELECT INTO q COALESCE(sum(quantity), 0)

		FROM gm_planet_buildings

			INNER JOIN gm_planets ON gm_planets.id=gm_planet_buildings.planetid

		WHERE gm_planets.ownerid=r_planet.ownerid AND buildingid=91;

		-- limit to max 10% of player planets

		maxstorms := r_planet.planets / 10.0;

		IF r_planet.planets > 50 THEN

			-- add 1 more planet every 10 owned planets

			maxstorms := maxstorms + int4((r_planet.planets-50)/10);

		END IF;

		IF q < maxstorms THEN

			PERFORM internal_planet_start_electromagnetic_storm(r_planet.ownerid, r_planet.id, null);

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_electromagnetic_storms() OWNER TO exileng;

--
-- Name: process_planet_laboratory_accidents(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_laboratory_accidents() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

	p float;

BEGIN

	-- make laboratory explosions more likely to happen between 22:00 and 8:00

	p := Extract(hour from now());

	IF p >= 22 OR p <= 8 THEN

		p := 0.03;

	ELSE

		p := 0.015;

	END IF;

	FOR r_planet IN

		SELECT id, ownerid, 1.0*scientists*LEAST(0.5, 1.0*(workers_for_maintenance-workers)/(1.0+workers_for_maintenance)) AS scientists

		FROM vw_gm_planets

		WHERE ownerid > 100 AND not production_frozen AND scientists > 20 AND random() < 1.0*(1.0+workers_for_maintenance-workers)/(1.0+workers_for_maintenance)*p+0.00001 AND last_catastrophe < now()-INTERVAL '6 hours' FOR UPDATE

	LOOP

		CONTINUE WHEN r_planet.scientists < 1;

		-- kill some scientists

		UPDATE gm_planets SET

			scientists = scientists - r_planet.scientists,

			last_catastrophe = now()

		WHERE id=r_planet.id;

		-- create a report

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, scientists)

		VALUES(r_planet.ownerid, 7, 23, r_planet.id, r_planet.scientists);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_laboratory_accidents() OWNER TO exileng;

--
-- Name: process_planet_production(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_production(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

BEGIN

	FOR r_planet IN

		SELECT id, ownerid

		FROM gm_planets

		WHERE next_planet_update <= now() + _precision AND NOT production_frozen

		ORDER BY next_planet_update

		LIMIT _count

	LOOP

		--PERFORM internal_planet_update_production_date(r_planet.id);

		PERFORM internal_planet_update_data(r_planet.id);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_production(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_planet_purchases(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_purchases() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_market record;

	r_prices resource_price;

	r_planet record;

	x float;

	b bool;

	forgot_ore int4;

	forgot_hydro int4;

	cr int4;

	price int4;

BEGIN

	FOR r_market IN

		SELECT m.planetid, m.ore, m.hydrocarbon, m.credits, ownerid, gm_profiles.planets

		FROM gm_market_purchases AS m

			INNER JOIN gm_planets ON (m.planetid=gm_planets.id)

			LEFT JOIN gm_profiles ON (gm_planets.ownerid=gm_profiles.id)

		WHERE delivery_time <= now() LIMIT 50 FOR UPDATE OF m,gm_planets

	LOOP

		DELETE FROM gm_market_purchases WHERE planetid=r_market.planetid;

		CONTINUE WHEN r_market.ownerid IS NULL;

		UPDATE gm_planets SET

			ore=LEAST(ore_capacity, ore+r_market.ore),

			hydrocarbon=LEAST(hydrocarbon_capacity, hydrocarbon+r_market.hydrocarbon)

		WHERE id=r_market.planetid;

		INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, planetid, ore, hydrocarbon, credits)

		VALUES(r_market.ownerid, 5, 1, 3, r_market.planetid, r_market.ore, r_market.hydrocarbon, r_market.credits);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_purchases() OWNER TO exileng;

--
-- Name: process_planet_riots(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_riots() RETURNS void
    LANGUAGE plpgsql
    AS $$-- Riots happen if workers+scientists < soldiers*100 with a small probability

DECLARE

	r_planet record;

	p float;

	pop float;

BEGIN

	--RETURN;

	-- make riots more likely to happen between 18:00 and 22:00

	p := Extract(hour from now());

	IF p >= 18 AND p <= 24 THEN

		p := 0.005;

	ELSE

		p := 0.0025;

	END IF;

	-- theft is workers+scientists / 1000 percent

	FOR r_planet IN

		SELECT id, ownerid, scientists, soldiers, workers, ore, hydrocarbon, mood

		FROM vw_gm_planets

		WHERE planet_floor > 0 AND ownerid > 100 AND not production_frozen AND last_catastrophe < now()-INTERVAL '4 hours' AND mood < 60 AND random() < (1.0 + workers + scientists + (60-mood)*500 - soldiers*250)/(1.0+workers + scientists)*p

	LOOP

		PERFORM internal_planet_stop_all_buildings(r_planet.ownerid, r_planet.id);

		PERFORM internal_planet_update_data(r_planet.id);

		pop := (r_planet.workers + r_planet.scientists - r_planet.soldiers*100)/1000.0;

		r_planet.scientists := LEAST(r_planet.scientists, int4(r_planet.scientists * pop/100.0/6.0));

		r_planet.soldiers := LEAST(r_planet.soldiers, int4(r_planet.soldiers * pop/100.0/8.0));

		r_planet.workers := LEAST(r_planet.workers, int4(r_planet.workers * (pop/100.0/5.0)));

		r_planet.ore := LEAST(r_planet.ore, int4(r_planet.ore * (0.2 + (pop+100-r_planet.mood)/100.0)));

		r_planet.hydrocarbon := LEAST(r_planet.hydrocarbon, int4(r_planet.hydrocarbon * (0.2+(pop+100-r_planet.mood)/100.0)));

		-- kill people & steal resources from planet 

		UPDATE gm_planets SET

			scientists = GREATEST(0, scientists - r_planet.scientists),

			soldiers = GREATEST(0, soldiers - r_planet.soldiers),

			workers = workers - r_planet.workers,

			ore = GREATEST(0, ore - r_planet.ore),

			hydrocarbon = GREATEST(0, hydrocarbon - r_planet.hydrocarbon),

			last_catastrophe = now(),

			mood = GREATEST(0, mood - 15)

		WHERE id=r_planet.id;

		UPDATE gm_planets SET

			mood = GREATEST(0, mood - 2)

		WHERE ownerid=r_planet.ownerid AND mood > 80;

		-- create gm_profile_reports

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, ore, hydrocarbon)

		VALUES(r_planet.ownerid, 7, 20, r_planet.id, r_planet.ore, r_planet.hydrocarbon);

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, scientists, soldiers, workers)

		VALUES(r_planet.ownerid, 7, 21, r_planet.id, r_planet.scientists, r_planet.soldiers, r_planet.workers);

	END LOOP;

	-- make planets with low mood/workers declare their independance

	FOR r_planet IN

		SELECT gm_ai_watched_planets.planetid AS id, gm_planets.ownerid

		FROM gm_ai_watched_planets

			INNER JOIN gm_planets ON (gm_planets.id=gm_ai_watched_planets.planetid)

		WHERE watched_since < now() - INTERVAL '6 days' AND random() < 0.005

	LOOP

		PERFORM internal_planet_stop_all_buildings(r_planet.ownerid, r_planet.id);

		PERFORM internal_planet_update_data(r_planet.id);

		-- give planet to independent nations

		PERFORM user_planet_leave(r_planet.ownerid, r_planet.id);

		-- create gm_profile_reports

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid)

		VALUES(r_planet.ownerid, 7, 25, r_planet.id);

		DELETE FROM gm_ai_watched_planets WHERE planetid=r_planet.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_riots() OWNER TO exileng;

--
-- Name: process_planet_robberies(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_robberies() RETURNS void
    LANGUAGE plpgsql
    AS $$-- Steal resources from planets that have less than (workers+scientists)/100 soldiers

DECLARE

	r_planet record;

	p float;

	pop float;

	moodloss int4;

BEGIN

	--RETURN;

	-- make thefts more likely to happen between 0:00 and 6:00

	p := Extract(hour from now());

	IF p >= 0 AND p <= 6 THEN

		p := 0.05;

	ELSE

		p := 0.02;

	END IF;

	-- theft probability is workers+scientists / 1000 percent

	FOR r_planet IN

		SELECT v.id, v.ownerid, v.workers, v.scientists, v.soldiers, v.ore, v.hydrocarbon, v.mood

		FROM vw_gm_planets AS v

			INNER JOIN gm_profiles ON (gm_profiles.id=v.ownerid AND gm_profiles.privilege=0)

		WHERE planet_floor > 0 AND v.ownerid > 100 AND planets > 2 AND random() < planets/100.0 AND not production_frozen AND v.last_catastrophe < now()-INTERVAL '5 hours' AND v.mood < 90 AND random() < (1.0+v.workers + v.scientists + (90-v.mood)*100.0 - v.soldiers*250)/(1.0+v.workers + v.scientists)*p

		ORDER BY Random()

		LIMIT 40

	LOOP

		pop := GREATEST(0, (r_planet.workers + r_planet.scientists - r_planet.soldiers*100)/1000.0);

		--RAISE NOTICE '%',r_planet.id;

		CONTINUE WHEN r_planet.workers + r_planet.scientists < 2000 OR r_planet.workers + r_planet.scientists < r_planet.soldiers*100;

		--RAISE NOTICE 'robberies on %',r_planet.id;

		PERFORM internal_planet_update_production_date(r_planet.id);

		r_planet.ore := LEAST(r_planet.ore, int4(r_planet.ore * (0.2 + (pop+100-r_planet.mood)/300.0)));

		r_planet.hydrocarbon := LEAST(r_planet.hydrocarbon, int4(r_planet.hydrocarbon * (0.2+(pop+100-r_planet.mood)/300.0)));

		IF r_planet.soldiers*100 >= r_planet.workers + r_planet.scientists THEN

			moodloss := 3; -- only lose 3 points of mood if we had enough soldiers

		ELSE

			moodloss := 12;

		END IF;

		-- steal resources from planet

		UPDATE gm_planets SET

			ore = GREATEST(0, ore - r_planet.ore),

			hydrocarbon = GREATEST(0, hydrocarbon - r_planet.hydrocarbon),

			last_catastrophe = now(),

			mood = GREATEST(0, mood - moodloss)

		WHERE id=r_planet.id;

		-- create a report

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, ore, hydrocarbon)

		VALUES(r_planet.ownerid, 7, 20, r_planet.id, r_planet.ore, r_planet.hydrocarbon);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_robberies() OWNER TO exileng;

--
-- Name: process_planet_sales(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_sales(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_market record;

	r_prices resource_price;

	r_planet record;

	x float;

	b bool;

	forgot_ore int4;

	forgot_hydro int4;

	cr int4;

	price int4;

BEGIN

	FOR r_market IN

		SELECT m.planetid, m.ore, m.hydrocarbon, m.credits, ownerid, gm_profiles.planets

		FROM gm_market_sales AS m

			INNER JOIN gm_planets ON (m.planetid=gm_planets.id)

			LEFT JOIN gm_profiles ON (gm_planets.ownerid=gm_profiles.id)

		WHERE sale_time <= now() + _precision

		LIMIT _count

		FOR UPDATE OF m,gm_planets

	LOOP

		DELETE FROM gm_market_sales WHERE planetid=r_market.planetid;

		CONTINUE WHEN r_market.ownerid IS NULL;

		b := r_market.planets > 3;

		x := random();

		IF b AND (x < 0.002) THEN

			-- catastrophie : merchants ships were destroyed caused by an engine malfunction

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, ore, hydrocarbon, credits)

			VALUES(r_market.ownerid, 7, 0, r_market.planetid, r_market.ore, r_market.hydrocarbon, r_market.credits);

		ELSEIF b AND (x < 0.004) THEN

			-- catastrophie : merchants ships were destroyed by pirates

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, ore, hydrocarbon, credits)

			VALUES(r_market.ownerid, 7, 1, r_market.planetid, r_market.ore, r_market.hydrocarbon, r_market.credits);

		ELSE

			cr := internal_profile_apply_alliance_tax(r_market.ownerid, r_market.credits - (r_market.credits / 2));

			UPDATE gm_profiles SET credits = credits + cr WHERE id=r_market.ownerid;

			IF x < 0.016 AND (r_market.ore + r_market.hydrocarbon > 10000) THEN

				-- catastrophie (for the merchant) : merchants ships forgot some resources

				forgot_ore := int4(r_market.ore * random()/10.0);

				forgot_hydro := int4(r_market.hydrocarbon * random()/10.0);

				IF forgot_ore < 500 THEN

					forgot_ore := 0;

				END IF;

				IF forgot_hydro < 500 THEN

					forgot_hydro := 0;

				END IF;

				IF forgot_ore > 0 AND forgot_hydro > 0 THEN

					INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, ore, hydrocarbon)

					VALUES(r_market.ownerid, 7, 2, r_market.planetid, forgot_ore, forgot_hydro);

					UPDATE gm_planets SET ore=ore+forgot_ore, hydrocarbon=hydrocarbon+forgot_hydro WHERE id=r_market.planetid AND ownerid=r_market.ownerid;

				END IF;

			END IF;

			INSERT INTO gm_profile_reports(ownerid, type, planetid, ore, hydrocarbon, credits)

			VALUES(r_market.ownerid, 5, r_market.planetid, r_market.ore, r_market.hydrocarbon, r_market.credits);

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_sales(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_planet_sandworm_attacks(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_sandworm_attacks() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

	r_building record;

BEGIN

	-- sandworm

	FOR r_planet IN

		SELECT v.id, v.ownerid

		FROM gm_planets AS v

			INNER JOIN gm_profiles ON (gm_profiles.id=v.ownerid AND gm_profiles.privilege=0)

		WHERE v.ownerid > 100 AND sandworm_activity > 0 AND random() < 0.5*sandworm_activity/10000.0 AND not production_frozen

		ORDER BY random()

		LIMIT 40

	LOOP

		FOR r_building IN

			SELECT buildingid

			FROM gm_planet_buildings

				INNER JOIN dt_buildings ON (dt_buildings.id = gm_planet_buildings.buildingid)

			WHERE planetid=r_planet.id AND random() > 0.75 AND buildingid >= 100 AND dt_buildings.floor > 0

			ORDER BY random()

		LOOP

			IF user_planet_building_destroy(r_planet.ownerid, r_planet.id, r_building.buildingid) = 0 THEN

				-- mood loss of 20 points

				UPDATE gm_planets SET

					mood=GREATEST(0, mood-20),

					buildings_dilapidation=LEAST(10000, buildings_dilapidation+1000)

				WHERE id=r_planet.id;

				-- create a report

				INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, buildingid)

				VALUES(r_planet.ownerid, 7, 91, r_planet.id, r_building.buildingid);

				EXIT;

			END IF;

		END LOOP;

	END LOOP;

	-- seism

	FOR r_planet IN

		SELECT v.id, v.ownerid, v.workers

		FROM gm_planets AS v

			INNER JOIN gm_profiles ON (gm_profiles.id=v.ownerid AND gm_profiles.privilege=0)

		WHERE v.ownerid > 100 AND seismic_activity > 0 AND random() < 0.5*seismic_activity/10000.0 AND not production_frozen

		ORDER BY random()

		LIMIT 40

	LOOP

		FOR r_building IN

			SELECT buildingid

			FROM gm_planet_buildings

				INNER JOIN dt_buildings ON (dt_buildings.id = gm_planet_buildings.buildingid)

			WHERE planetid=r_planet.id AND random() > 0.75 AND buildingid >= 100 AND dt_buildings.floor > 0

			ORDER BY random()

		LOOP

			IF user_planet_building_destroy(r_planet.ownerid, r_planet.id, r_building.buildingid) = 0 THEN

				-- mood loss of 100 points

				UPDATE gm_planets SET

					mood=GREATEST(0, mood-100),

					buildings_dilapidation=LEAST(10000, buildings_dilapidation+6000),

					planet_stock_ore=static_merchant_stock_min(),

					planet_stock_hydrocarbon=static_merchant_stock_min()

				WHERE id=r_planet.id;

				r_planet.workers := LEAST(r_planet.workers, int4(LEAST(0.5, random()) * r_planet.workers));

				UPDATE gm_planets SET

					workers = workers - r_planet.workers

				WHERE id=r_planet.id;

				-- create a report

				INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, buildingid, workers)

				VALUES(r_planet.ownerid, 7, 90, r_planet.id, r_building.buildingid, r_planet.workers);

				EXIT;

			END IF;

		END LOOP;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_sandworm_attacks() OWNER TO exileng;

--
-- Name: process_planet_ship_pendings(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_ship_pendings(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_pending record;

	r_user record;

BEGIN

	FOR r_pending IN

		SELECT gm_planet_ship_pendings.id, planetid, shipid, ownerid, 

			COALESCE(dt_ships.new_shipid, shipid) as newshipid, 

			(dt_ships.cost_ore + dt_ships.cost_hydrocarbon) AS ship_value,

			recycle,

			dt_ships.cost_ore,

			dt_ships.cost_hydrocarbon

		FROM gm_planet_ship_pendings

			INNER JOIN gm_planets ON (gm_planets.id=gm_planet_ship_pendings.planetid)

			INNER JOIN dt_ships ON (dt_ships.id=gm_planet_ship_pendings.shipid)

		WHERE end_time <= now() + _precision

		ORDER BY end_time

		LIMIT _count

		FOR UPDATE OF gm_planet_ship_pendings

	LOOP

		IF r_pending.recycle THEN

			UPDATE gm_planets SET

				ore = ore + r_pending.cost_ore * internal_profile_get_ore_recycling_coeff(gm_planets.ownerid),

				hydrocarbon = hydrocarbon + r_pending.cost_hydrocarbon * internal_profile_get_hydro_recycling_coeff(gm_planets.ownerid)

			WHERE id=r_pending.planetid;

			DELETE FROM gm_planet_ship_pendings WHERE id=r_pending.id;

		ELSE

			UPDATE gm_profiles SET

				score_ships=score_ships + r_pending.ship_value

			WHERE id=r_pending.ownerid

			RETURNING INTO r_user id, lcid, tutorial_first_ship_built, tutorial_first_colonisation_ship_built;

			-- add built ship to planet ships list

			INSERT INTO gm_planet_ships(planetid, shipid) VALUES(r_pending.planetid, r_pending.newshipid);

			DELETE FROM gm_planet_ship_pendings WHERE id=r_pending.id;

			-- tutorial first ship

			IF NOT r_user.tutorial_first_ship_built THEN

				PERFORM admin_send_mail(r_user.id, 6, r_user.lcid);

				UPDATE gm_profiles SET tutorial_first_ship_built=true WHERE id=r_user.id;

			END IF;

			-- tutorial first colonisation ship

			IF NOT r_user.tutorial_first_colonisation_ship_built AND r_pending.newshipid = 150 THEN

				PERFORM admin_send_mail(r_user.id, 7, r_user.lcid);

				UPDATE gm_profiles SET tutorial_first_colonisation_ship_built=true WHERE id=r_user.id;

			END IF;

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_ship_pendings(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_planet_shipyard_waitings(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_shipyard_waitings(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

BEGIN

	FOR r_planet IN

		SELECT id

		FROM gm_planets

		WHERE shipyard_next_continue < now()+_precision AND NOT production_frozen

		ORDER BY shipyard_next_continue

		LIMIT _count

	LOOP

		PERFORM internal_planet_next_ship_pending(r_planet.id);

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_shipyard_waitings(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_planet_trainings(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_planet_trainings(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_pending record;

BEGIN

	FOR r_pending IN

		SELECT t.id, t.planetid, t.scientists, t.soldiers, ownerid

		FROM gm_planet_trainings t

			INNER JOIN gm_planets ON (gm_planets.id=t.planetid)

		WHERE end_time <= now()+_precision

		ORDER BY end_time LIMIT _count FOR UPDATE

	LOOP

		BEGIN

			UPDATE gm_planets SET

				scientists = scientists + r_pending.scientists,

				soldiers = soldiers + r_pending.soldiers

			WHERE id=r_pending.planetid;

		EXCEPTION

			WHEN CHECK_VIOLATION THEN

				IF r_pending.scientists > 0 THEN

					PERFORM user_planet_training_cancel(planetid,id) FROM gm_planet_trainings WHERE planetid=r_pending.planetid AND scientists > 0 AND end_time IS NULL;

				ELSE

					PERFORM user_planet_training_cancel(planetid,id) FROM gm_planet_trainings WHERE planetid=r_pending.planetid AND soldiers > 0 AND end_time IS NULL;

				END IF;

				PERFORM user_planet_training_cancel(r_pending.planetid,r_pending.id);

		END;

		DELETE FROM gm_planet_trainings WHERE id=r_pending.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_planet_trainings(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_profile_bounties(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_bounties(_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_bounty record;

BEGIN

	FOR r_bounty IN

		SELECT userid, bounty

		FROM gm_profile_bounties

		WHERE reward_time <= now()

		LIMIT _count

	LOOP

		IF r_bounty.bounty > 0 THEN

			UPDATE gm_profiles SET

				credits=credits+r_bounty.bounty

			WHERE id=r_bounty.userid;

			INSERT INTO gm_profile_reports(ownerid, type, subtype, credits)

			VALUES(r_bounty.userid, 2, 20, r_bounty.bounty);

		END IF;

		DELETE FROM gm_profile_bounties

		WHERE userid=r_bounty.userid;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_profile_bounties(_count integer) OWNER TO exileng;

--
-- Name: process_profile_credit_production(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_credit_production(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

BEGIN

	FOR r_planet IN

		SELECT id, ownerid, credits_updates, credits_total, int4(credits_production + credits_random_production * random()) AS credits

		FROM gm_planets

		WHERE ownerid IS NOT NULL AND credits_next_update < now()-_precision AND (credits_production > 0 OR credits_random_production > 0) AND not production_frozen

		ORDER BY credits_next_update

		LIMIT _count

	LOOP

		UPDATE gm_profiles SET

			credits_produced = credits_produced + r_planet.credits_total + r_planet.credits

		WHERE id=r_planet.ownerid;

		UPDATE gm_planets SET

			credits_total=0,

			credits_updates=0,

			credits_next_update=credits_next_update+INTERVAL '1 hour'

		WHERE id=r_planet.id;

/*		IF r_planet.credits_updates >= 23 THEN

			UPDATE gm_profiles SET

				credits = credits + r_planet.credits_total + r_planet.credits

			WHERE id=r_planet.ownerid;

			INSERT INTO gm_profile_reports(ownerid, type, subtype, credits, planetid)

			VALUES(r_planet.ownerid, 5, 10, r_planet.credits_total + r_planet.credits, r_planet.id);

			UPDATE gm_planets SET

				credits_total=0,

				credits_updates=0,

				credits_next_update=credits_next_update+INTERVAL '1 hour'

			WHERE id=r_planet.id;

		ELSE

			UPDATE gm_planets SET

				credits_total=credits_total+r_planet.credits, 

				credits_updates=credits_updates+1,

				credits_next_update=credits_next_update+INTERVAL '1 hour'

			WHERE id=r_planet.id;

		END IF;*/

	END LOOP;

END;$$;


ALTER FUNCTION ng03.process_profile_credit_production(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_profile_deletions(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_deletions() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_users record;

BEGIN

	-- delete accounts that are marked for deletion or the user didn't log in after 72 hours of registration

	FOR r_users IN 

		SELECT id

		FROM gm_profiles

		WHERE (privilege > -50 AND privilege < 100 AND ((deletion_date <= now()) OR (orientation = 0 and regdate <= now()-INTERVAL '72 hours')) ) OR

			(privilege = -1 AND lastlogin <= now() - INTERVAL '1 month') OR

			(privilege = 0 AND lastlogin <= now() - INTERVAL '1 month')

		LIMIT 20

		FOR UPDATE

	LOOP

		PERFORM internal_profile_delete(r_users.id);

	END LOOP;

	-- abandon planets of players that do not play anymore after 3 weeks

	-- and new players after 2 days of inactivity

	FOR r_users IN 

		SELECT id

		FROM gm_profiles

		WHERE privilege=0 AND orientation <> 0 AND planets > 0 AND (

			lastlogin <= now()-INTERVAL '3 weeks' /*OR

			(lastlogin - regdate < interval '2 days' AND lastlogin < now() - interval '2 days')*/

			)

		LIMIT 20

		FOR UPDATE

	LOOP

		PERFORM internal_planet_reset(id)

		FROM gm_planets

		WHERE ownerid=r_users.id;

	END LOOP;

	-- abandon planets of banned players after 2 weeks

	FOR r_users IN

		SELECT id

		FROM gm_profiles

		WHERE privilege = -1 AND lastlogin <= now()-INTERVAL '2 weeks' AND planets > 0

		LIMIT 10

		FOR UPDATE

	LOOP

		PERFORM internal_planet_reset(id)

		FROM gm_planets

		WHERE ownerid=r_users.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_profile_deletions() OWNER TO exileng;

--
-- Name: process_profile_holidays(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_holidays() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

BEGIN

	--return;

	FOR r_user IN 

		SELECT userid, end_time-now() AS duration

		FROM gm_profile_holidays

		WHERE NOT activated AND start_time <= now() FOR UPDATE

	LOOP

		UPDATE gm_profile_holidays SET activated=true WHERE userid=r_user.userid;

		-- set user in holidays

		UPDATE gm_profiles SET privilege=-2 WHERE id=r_user.userid AND privilege=0;

		IF FOUND THEN

			-- add 14 days to buildings

			UPDATE gm_planet_building_pendings SET end_time=end_time + r_user.duration WHERE end_time IS NOT NULL AND planetid IN (SELECT id FROM gm_planets WHERE ownerid=r_user.userid);

			-- add 14 days to ships

			UPDATE gm_planet_ship_pendings SET end_time=end_time + r_user.duration WHERE end_time IS NOT NULL AND planetid IN (SELECT id FROM gm_planets WHERE ownerid=r_user.userid);

			-- add 14 days to research

			UPDATE gm_profile_research_pendings SET end_time=end_time + r_user.duration WHERE userid=r_user.userid;

			-- update all ressources before freezing the production

			PERFORM internal_planet_update_production_date(id) FROM gm_planets WHERE ownerid=r_user.userid;

			-- suspend all planets productions

			UPDATE gm_planets SET

				ore_production=0, 

				hydrocarbon_production=0,

				credits_production=0,

				credits_random_production=0,

				production_prestige=0,

				mod_production_workers=0,

				radar_strength=0,

				radar_jamming=0,

				production_frozen=true

			WHERE planet_floor > 0 AND planet_space > 0 AND ownerid=r_user.userid AND NOT EXISTS(SELECT 1 FROM gm_fleets WHERE (firepower > 0) AND internal_profile_get_relation(ownerid, gm_planets.ownerid) < 0 AND ((planetid=gm_planets.id AND action <> -1 AND action <> 1) OR (dest_planetid=gm_planets.id AND action = 1 AND action_end_time < now()+INTERVAL '1 day')) );

			UPDATE gm_planet_energy_transfers SET

				enabled = false

			WHERE planetid IN (SELECT id FROM gm_planets WHERE ownerid=r_user.userid);

			-- make enemy/ally/friend gm_fleets to go elsewhere

			PERFORM gm_planets.id, user_fleet_move(gm_fleets.ownerid, gm_fleets.id, internal_planet_find_nearest(gm_fleets.ownerid, gm_planets.id))

			FROM gm_planets

				INNER JOIN gm_fleets ON (gm_fleets.action <> -1 AND gm_fleets.action <> 1 AND gm_fleets.planetid=gm_planets.id AND gm_fleets.ownerid <> gm_planets.ownerid)

			WHERE production_frozen AND gm_planets.ownerid=r_user.userid;

		END IF;

		-- cancel movements of all player gm_fleets

		--PERFORM user_fleet_cancel_moving(ownerid, id, true) FROM gm_fleets WHERE ownerid=r_user.userid;

	END LOOP;

	FOR r_user IN 

		SELECT userid

		FROM gm_profile_holidays

		WHERE activated AND end_time <= now() FOR UPDATE

	LOOP

		-- resume all planets productions

		UPDATE gm_planets SET production_lastupdate=now(), production_frozen=false WHERE ownerid=r_user.userid AND production_frozen;

		PERFORM internal_planet_update_data(id) FROM gm_planets WHERE ownerid=r_user.userid;

		-- remove user from holidays mode

		UPDATE gm_profiles SET privilege=0, last_holidays = now(), lastlogin=now(), lastactivity=now() WHERE id=r_user.userid AND privilege=-2;

		DELETE FROM gm_profile_holidays WHERE userid=r_user.userid;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_profile_holidays() OWNER TO exileng;

--
-- Name: process_profile_research_pendings(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_research_pendings() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	r_pending record;

	r_planet gm_planets;

	research_value int8;

BEGIN

	FOR r_pending IN

		SELECT userid, researchid, expires

		FROM gm_profile_researches

		WHERE expires IS NOT NULL AND expires <= now()+INTERVAL '3 seconds'

		ORDER BY expires

		LIMIT 5 FOR UPDATE

	LOOP

		DELETE FROM gm_profile_researches WHERE userid=r_pending.userid AND researchid=r_pending.researchid;

		PERFORM internal_profile_update_modifiers(r_pending.userid);

		-- update all energy transfers from the player's planets

		UPDATE gm_planet_energy_transfers SET

			energy = energy

		WHERE planetid IN (SELECT id FROM gm_planets WHERE ownerid=r_pending.userid);

		-- update all planets

		PERFORM internal_planet_update_data(id)

		FROM gm_planets

		WHERE ownerid=r_pending.userid;

		-- update all gm_fleets

		PERFORM internal_fleet_update_bonuses(id)

		FROM gm_fleets

		WHERE ownerid=r_pending.userid;

	END LOOP;

	FOR r_pending IN

		SELECT gm_profile_research_pendings.id, userid, researchid, looping, expiration

		FROM gm_profile_research_pendings

			INNER JOIN dt_researches ON (dt_researches.id=gm_profile_research_pendings.researchid)

		WHERE end_time <= now()+INTERVAL '3 seconds'

		ORDER BY end_time LIMIT 10 FOR UPDATE

	LOOP

		-- delete pending research

		DELETE FROM gm_profile_research_pendings WHERE id=r_pending.id;

		-- add the terminated research

		INSERT INTO gm_profile_researches(userid, researchid, level) VALUES(r_pending.userid, r_pending.researchid, 1);

		IF r_pending.expiration IS NOT NULL THEN

			UPDATE gm_profile_researches SET

				level = 1,

				expires = now() + r_pending.expiration

			WHERE userid=r_pending.userid AND researchid=r_pending.researchid;

		END IF;

		-- retrieve the score of the terminated research

		SELECT INTO research_value

			int8(COALESCE(

				sum( cost_credits * rank * power(2.35, 5-levels + level) )

			, 0)) AS score

		FROM gm_profile_researches

			INNER JOIN dt_researches ON (gm_profile_researches.researchid = dt_researches.id)

		WHERE userid = r_pending.userid;

		-- update score

		UPDATE gm_profiles SET

			score_research=research_value

		WHERE id=r_pending.userid;

		INSERT INTO gm_profile_reports(ownerid, type, researchid, data)

		VALUES(r_pending.userid, 3, r_pending.researchid, '{researchid:' || r_pending.researchid || '}');

		PERFORM internal_profile_update_modifiers(r_pending.userid);

		-- update all energy transfers from the player's planets

		UPDATE gm_planet_energy_transfers SET

			energy = energy

		WHERE planetid IN (SELECT id FROM gm_planets WHERE ownerid=r_pending.userid);

		-- update all planets

		PERFORM internal_planet_update_data(id)

		FROM gm_planets

		WHERE ownerid=r_pending.userid;

		-- update all gm_fleets

		PERFORM internal_fleet_update_bonuses(id)

		FROM gm_fleets

		WHERE ownerid=r_pending.userid;

		IF r_pending.looping THEN

			PERFORM user_research_start(r_pending.userid, r_pending.researchid, r_pending.looping);

		END IF;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_profile_research_pendings() OWNER TO exileng;

--
-- Name: process_profile_score(interval, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_profile_score(_precision interval, _count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

DECLARE

	r_player record;

	r_unusedships record;

	r_fleets record;

	r_planets record;

BEGIN

	FOR r_player IN

		SELECT id

		FROM gm_profiles

		WHERE (privilege=-2 OR privilege>=0) AND score_next_update < now()+_precision

		LIMIT _count

		FOR UPDATE

	LOOP

		-- compute score of unused ships

		SELECT INTO r_unusedships

			int8(COALESCE(

				sum(int8(quantity)*cost_ore)*static_ore_score() + sum(int8(quantity)*cost_hydrocarbon)*static_hydro_score() + sum(int8(quantity)*cost_credits) + sum(crew*quantity)*static_crew_score()

			, 0)) AS score

		FROM gm_planet_ships

			INNER JOIN gm_planets ON gm_planets.id = gm_planet_ships.planetid

			INNER JOIN dt_ships ON dt_ships.id = gm_planet_ships.shipid

		WHERE ownerid=r_player.id AND dt_ships.upkeep > 0;

		-- compute score of ships in gm_fleets

		SELECT INTO r_fleets

			int8(COALESCE(sum(score) + sum(cargo_scientists)*static_scientist_score() + sum(cargo_soldiers)*static_soldier_score(), 0)) AS score

		FROM gm_fleets

		WHERE ownerid=r_player.id;

		-- compute score of planets resources

		-- each planet is worth 1000 points

		SELECT INTO r_planets

			int8(COALESCE(

				sum(score) + count(1)*1000 + sum(ore_production)*10*static_ore_score() + sum(hydrocarbon_production)*10*static_hydro_score() + sum(scientists)*static_scientist_score() + sum(soldiers)*static_soldier_score() + sum(credits_production)*10 + sum(credits_random_production)/2.0*10

			, 0)) AS score

		FROM gm_planets

		WHERE ownerid=r_player.id;

		-- save score

		UPDATE gm_profiles SET

			previous_score = score,

			score = int4((r_unusedships.score + r_fleets.score + r_planets.score + score_research)/1000 + log(1.05, GREATEST(1, credits))),

			score_next_update = DEFAULT

		WHERE id=r_player.id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_profile_score(_precision interval, _count integer) OWNER TO exileng;

--
-- Name: process_rogue_patrolling_fleets(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_rogue_patrolling_fleets() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	fleet_id int4;

	fleet_route int8;

	fleet_wp int8;

	r_planet record;

	military_sig int8;

	sectorvalue float8;

	r_fleet record;

	galaxy_count integer;

BEGIN

	FOR r_planet IN

		SELECT gm_planets.id, gm_planets.sector

		FROM gm_planets

			INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

		WHERE (spawn_ore = 0 AND spawn_hydrocarbon = 0) AND (planet_floor = 0 AND planet_space = 0) AND gm_galaxies.protected_until < now() AND random() < 0.0001

		--WHERE gm_planets.id=tool_compute_planet_id(25,45,25)

	LOOP

		sectorvalue := (sqrt(static_galaxy_width(1)+static_galaxy_height(1)) - 0.8 * sqrt(power(static_galaxy_width(1)/2.0 - (r_planet.sector % static_galaxy_height(1)), 2) + power(static_galaxy_height(1)/2.0 - (r_planet.sector/static_galaxy_width(1) + 1), 2))) * 20;

		--CONTINUE WHEN sectorvalue <= 10;

		PERFORM 1 FROM gm_fleets WHERE ownerid=1 AND (planetid=r_planet.id OR dest_planetid=r_planet.id);

		IF NOT FOUND THEN

			SELECT INTO military_sig sum(military_signature) FROM gm_fleets WHERE planetid=r_planet.id AND ownerid > 100;

			CONTINUE WHEN random() > sectorvalue*1000 / (military_sig+1);

			fleet_id := nextval('gm_fleets_id_seq');

			--RAISE NOTICE 'create fleet %', fleet_id;

			INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since, speed)

			VALUES(fleet_id, 1, null, 'Les fossoyeurs', now(), 800);

			IF sectorvalue < 60 THEN

				IF random() < 0.15 THEN

					-- obliterator

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 951, sectorvalue+int4(random()*10));

				ELSE

					sectorvalue := sectorvalue*2.0;

				END IF;

				IF random() < 0.75 THEN

					-- mower

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 952, sectorvalue*20+int4(random()*100));

				ELSE

					sectorvalue := sectorvalue*2.0;

				END IF;

				IF random() < 0.75 THEN

					-- escorter

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 954, sectorvalue*15+int4(random()*75));

				ELSE

					sectorvalue := sectorvalue*2.0;

				END IF;

				-- multigun corvette

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 955, sectorvalue*20+int4(random()*100));

				-- rogue recycler

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 960, 9+int4(random()*4));

			ELSE

				IF military_sig > 100000 THEN

					sectorvalue := sectorvalue * 1.5;

				END IF;

				IF random() < 0.35 THEN

					-- obliterator

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 951, int4(sectorvalue*2.5+int4(random()*10)));

				ELSE

					sectorvalue := sectorvalue*3.0;

				END IF;

				IF random() < 0.75 THEN

					-- mower

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 952, sectorvalue*20+int4(random()*100));

				ELSE

					sectorvalue := sectorvalue*2.0;

				END IF;

				IF random() < 0.75 THEN

					-- escorter

					INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

					VALUES(fleet_id, 954, sectorvalue*15+int4(random()*75));

				ELSE

					sectorvalue := sectorvalue*2.0;

				END IF;

				-- multigun corvette

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 955, sectorvalue*20+int4(random()*100));

				-- rogue recycler

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 960, 15+int4(random()*5));

			END IF;

			fleet_route := internal_profile_create_fleet_route(null, null);

			fleet_wp := internal_fleet_route_add_move(fleet_route, r_planet.id);

			PERFORM internal_fleet_route_add_wait(fleet_route, int4(9*60*60));

			PERFORM internal_fleet_route_add_wait(fleet_route, int4((6*random())*60*60));

			PERFORM internal_fleet_route_add_recycling(fleet_route);

			IF random() > 0.5 THEN

				PERFORM internal_fleet_route_add_wait(fleet_route, int4((6+2*random())*60*60));

			END IF;

			PERFORM internal_fleet_route_add_disappear(fleet_route, 8*60*60);

			UPDATE gm_fleets SET attackonsight = true, next_waypointid=fleet_wp WHERE id=fleet_id;

			PERFORM internal_fleet_next_waypoint(1, fleet_id);

			RAISE NOTICE 'fleet created % toward %', fleet_id, r_planet.id;

		END IF;

	END LOOP;

	SELECT INTO galaxy_count (count(1)/10)::integer FROM gm_galaxies;

	-- check all idle gm_fleets

	FOR r_fleet IN

		SELECT planetid, galaxy, sector

		FROM gm_fleets

			INNER JOIN gm_planets ON gm_planets.id=gm_fleets.planetid

		WHERE gm_fleets.ownerid > 100 AND military_signature < 2000 AND idle_since < now()-interval '2 weeks' AND NOT planetid IN (34,35,36,37,44,45,46,47,54,55,56,57,64,65,66,67) AND NOT production_frozen

		ORDER BY random()

		LIMIT galaxy_count

	LOOP

		fleet_id := admin_create_fleet(1, 'Les fossoyeurs', null, r_fleet.planetid, 0);

		fleet_route := internal_profile_create_fleet_route(null, null);

		fleet_wp := internal_fleet_route_add_wait(fleet_route, 0);

		RAISE NOTICE 'patrol fleet created % toward %', fleet_id, r_fleet.planetid;

		FOR r_planet IN

			SELECT gm_planets.id

			FROM gm_planets

			WHERE id <> r_fleet.planetid AND (ownerid IS NULL OR planet_floor=0) AND galaxy = r_fleet.galaxy AND sector IN (r_fleet.sector, r_fleet.sector+10, r_fleet.sector-10) AND EXISTS(SELECT 1 FROM gm_fleets WHERE ownerid > 100 AND planetid=gm_planets.id AND military_signature < 2000 AND idle_since <= now()-interval '2 weeks') AND NOT production_frozen

			ORDER BY random()

			LIMIT 20

		LOOP

			PERFORM internal_fleet_route_add_move(fleet_route, r_planet.id);

		END LOOP;

		PERFORM internal_fleet_route_add_disappear(fleet_route, 8*60*60);

		UPDATE gm_fleets SET attackonsight = true, next_waypointid=fleet_wp WHERE id=fleet_id;

	END LOOP;

	RETURN;

END;$$;


ALTER FUNCTION ng03.process_rogue_patrolling_fleets() OWNER TO exileng;

--
-- Name: process_rogue_rushing_fleets(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.process_rogue_rushing_fleets() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

	fleet_id int4;

	fleet_route int8;

	fleet_wp int8;

	r_planet record;

	military_sig int8;

BEGIN

	FOR r_planet IN

		SELECT gm_planets.id

		FROM gm_planets

			INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

		WHERE (spawn_ore > 0 OR spawn_hydrocarbon > 0) AND gm_galaxies.protected_until < now() AND random() < 0.01

	LOOP

		PERFORM 1 FROM gm_fleets WHERE ownerid=1 AND planetid=r_planet.id OR dest_planetid=r_planet.id;

		IF NOT FOUND THEN

			SELECT INTO military_sig sum(military_signature) FROM gm_fleets WHERE planetid=r_planet.id;

			CONTINUE WHEN military_sig > 10000;

			fleet_id := nextval('gm_fleets_id_seq');

			INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since, speed)

			VALUES(fleet_id, 1, null, 'Les fossoyeurs', now(), 800);

			IF military_sig < 2000 THEN

				-- escorter

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 954, 80+int4(random()*50));

				-- rogue recycler

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 960, 5+int4(random()*3));

			ELSEIF military_sig < 5000 THEN

				-- mower

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 952, 200+int4(random()*100));

				-- escorter

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 954, 100+int4(random()*75));

				-- rogue recycler

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 960, 9+int4(random()*4));

			ELSE

				-- mower

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 952, 50+int4(random()*50));

				-- escorter

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 954, 250+int4(random()*100));

				-- rogue recycler

				INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

				VALUES(fleet_id, 960, 15+int4(random()*5));

			END IF;

			fleet_route := internal_profile_create_fleet_route(null, null);

			fleet_wp := internal_fleet_route_add_move(fleet_route, r_planet.id);

			PERFORM internal_fleet_route_add_recycling(fleet_route);

			IF random() > 0.5 THEN

				PERFORM internal_fleet_route_add_wait(fleet_route, int4((2*random())*60*60));

			END IF;

			PERFORM internal_fleet_route_add_disappear(fleet_route, 8*60*60);

			UPDATE gm_fleets SET attackonsight = true, next_waypointid=fleet_wp WHERE id=fleet_id;

			PERFORM internal_fleet_next_waypoint(1, fleet_id);

			--RAISE NOTICE 'create fleet % toward %',fleet_id,r_planet.id;

		END IF;

	END LOOP;

END;$$;


ALTER FUNCTION ng03.process_rogue_rushing_fleets() OWNER TO exileng;

--
-- Name: static_alliance_joining_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_alliance_joining_delay() RETURNS interval
    LANGUAGE sql IMMUTABLE
    AS $$SELECT INTERVAL '8 hours';$$;


ALTER FUNCTION ng03.static_alliance_joining_delay() OWNER TO exileng;

--
-- Name: static_alliance_leaving_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_alliance_leaving_delay() RETURNS interval
    LANGUAGE sql
    AS $$SELECT INTERVAL '24 hours';$$;


ALTER FUNCTION ng03.static_alliance_leaving_delay() OWNER TO exileng;

--
-- Name: static_alliance_simultaneous_leaving_max(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_alliance_simultaneous_leaving_max() RETURNS smallint
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int2(3);$$;


ALTER FUNCTION ng03.static_alliance_simultaneous_leaving_max() OWNER TO exileng;

--
-- Name: static_alliance_war_cost_coeff(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_alliance_war_cost_coeff() RETURNS double precision
    LANGUAGE sql
    AS $$SELECT 0.08::double precision;$$;


ALTER FUNCTION ng03.static_alliance_war_cost_coeff() OWNER TO exileng;

--
-- Name: static_alliance_war_starting_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_alliance_war_starting_delay() RETURNS interval
    LANGUAGE sql
    AS $$SELECT INTERVAL '24 hours';$$;


ALTER FUNCTION ng03.static_alliance_war_starting_delay() OWNER TO exileng;

--
-- Name: static_commander_promotion_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_commander_promotion_delay() RETURNS interval
    LANGUAGE sql IMMUTABLE
    AS $$SELECT INTERVAL '2 weeks'$$;


ALTER FUNCTION ng03.static_commander_promotion_delay() OWNER TO exileng;

--
-- Name: static_commander_upkeep_coeff(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_commander_upkeep_coeff() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(1);$$;


ALTER FUNCTION ng03.static_commander_upkeep_coeff() OWNER TO exileng;

--
-- Name: static_crew_score(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_crew_score() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(0.1);$$;


ALTER FUNCTION ng03.static_crew_score() OWNER TO exileng;

--
-- Name: static_fleet_ship_upkeep(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_fleet_ship_upkeep() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(1);$$;


ALTER FUNCTION ng03.static_fleet_ship_upkeep() OWNER TO exileng;

--
-- Name: static_galaxy_height(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_galaxy_height(_galaxyid integer) RETURNS smallint
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int2(10);$$;


ALTER FUNCTION ng03.static_galaxy_height(_galaxyid integer) OWNER TO exileng;

--
-- Name: static_galaxy_protection_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_galaxy_protection_delay() RETURNS interval
    LANGUAGE sql
    AS $$SELECT INTERVAL '3 month';$$;


ALTER FUNCTION ng03.static_galaxy_protection_delay() OWNER TO exileng;

--
-- Name: static_galaxy_width(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_galaxy_width(_galaxyid integer) RETURNS smallint
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int2(10);$$;


ALTER FUNCTION ng03.static_galaxy_width(_galaxyid integer) OWNER TO exileng;

--
-- Name: static_hydro_score(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_hydro_score() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(1.0);$$;


ALTER FUNCTION ng03.static_hydro_score() OWNER TO exileng;

--
-- Name: static_merchant_stock_max(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_merchant_stock_max() RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int4(90000000);$$;


ALTER FUNCTION ng03.static_merchant_stock_max() OWNER TO exileng;

--
-- Name: static_merchant_stock_min(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_merchant_stock_min() RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int4(-35000000);$$;


ALTER FUNCTION ng03.static_merchant_stock_min() OWNER TO exileng;

--
-- Name: static_orbitting_fleet_ship_upkeep(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_orbitting_fleet_ship_upkeep() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(4);$$;


ALTER FUNCTION ng03.static_orbitting_fleet_ship_upkeep() OWNER TO exileng;

--
-- Name: static_ore_score(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_ore_score() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(1.0);$$;


ALTER FUNCTION ng03.static_ore_score() OWNER TO exileng;

--
-- Name: static_planet_invasion_delay(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_planet_invasion_delay() RETURNS interval
    LANGUAGE sql IMMUTABLE
    AS $$SELECT INTERVAL '5 minutes';$$;


ALTER FUNCTION ng03.static_planet_invasion_delay() OWNER TO exileng;

--
-- Name: static_planet_ship_recycling_coeff(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_planet_ship_recycling_coeff() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT 0.05::real;$$;


ALTER FUNCTION ng03.static_planet_ship_recycling_coeff() OWNER TO exileng;

--
-- Name: static_planet_ship_upkeep(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_planet_ship_upkeep() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(0.8);$$;


ALTER FUNCTION ng03.static_planet_ship_upkeep() OWNER TO exileng;

--
-- Name: static_profile_bankruptcy_hours(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_profile_bankruptcy_hours() RETURNS smallint
    LANGUAGE sql IMMUTABLE
    AS $$SELECT int2(168);$$;


ALTER FUNCTION ng03.static_profile_bankruptcy_hours() OWNER TO exileng;

--
-- Name: static_scientist_score(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_scientist_score() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(60);$$;


ALTER FUNCTION ng03.static_scientist_score() OWNER TO exileng;

--
-- Name: static_scientist_upkeep(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_scientist_upkeep() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(2);$$;


ALTER FUNCTION ng03.static_scientist_upkeep() OWNER TO exileng;

--
-- Name: static_soldier_score(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_soldier_score() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(50);$$;


ALTER FUNCTION ng03.static_soldier_score() OWNER TO exileng;

--
-- Name: static_soldier_upkeep(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_soldier_upkeep() RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float4(1);$$;


ALTER FUNCTION ng03.static_soldier_upkeep() OWNER TO exileng;

--
-- Name: static_time_coeff(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.static_time_coeff() RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$SELECT float8(0.1);$$;


ALTER FUNCTION ng03.static_time_coeff() OWNER TO exileng;

--
-- Name: tool_compute_building_building_time(integer, real, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_building_building_time(_time integer, _exp real, _buildings_built integer, _mod_speed integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$DECLARE

	t int4;

	mod float4;

BEGIN

	t := int4(_time * power(_exp, COALESCE(_buildings_built, 0)));

	IF _mod_speed > 100 AND t > 172800 THEN -- 172800 = 2 days

		mod := 100.0 + (_mod_speed-100.0) * 172800.0/t;

	ELSE

		mod := _mod_speed;

	END IF;

	--RAISE NOTICE '%,%,%,%', _time,_buildings_built, _mod_speed, mod;

	RETURN int4(LEAST(10*t, t * 100.0/mod));

END;$$;


ALTER FUNCTION ng03.tool_compute_building_building_time(_time integer, _exp real, _buildings_built integer, _mod_speed integer) OWNER TO exileng;

--
-- Name: tool_compute_distance(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_distance(integer, integer, integer, integer) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE
    AS $_$-- Compute travel distance between 2 galaxy points (sector/planet)

-- Param1: Sector1

-- Param2: Planet1

-- Param3: Sector2

-- Param4: Planet2

BEGIN

	IF $1 <> $3 THEN

		-- compute travel distance between the 2 sectors

		RETURN 6*sqrt(( ($1-1)/10 - ($3-1)/10 )^2 + ( ($1-1)%10 - ($3-1)%10 )^2);

	ELSE

		-- compute travel distance between the 2 planets

		-- distance between 0 (min) and around 5.65 (max)

		RETURN sqrt(( ($2-1)/5 - ($4-1)/5 )^2 + ( ($2-1)%5 - ($4-1)%5 )^2);

	END IF;

END;$_$;


ALTER FUNCTION ng03.tool_compute_distance(integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: tool_compute_factor(real, real); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_factor(_exp real, _quantity real) RETURNS real
    LANGUAGE plpgsql IMMUTABLE
    AS $$BEGIN

	IF _exp IS NULL THEN

		RETURN _quantity;

	ELSEIF _quantity <= 0 THEN

		RETURN 0;

	ELSE

		RETURN power(_exp, _quantity-1);

	END IF;

END;$$;


ALTER FUNCTION ng03.tool_compute_factor(_exp real, _quantity real) OWNER TO exileng;

--
-- Name: tool_compute_market_price(real, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_market_price(_base_price real, _planet_stock integer) RETURNS real
    LANGUAGE plpgsql STABLE
    AS $$BEGIN

	IF _planet_stock > 0 THEN

		RETURN _base_price * 0.95 * (1.0 - 0.40 *_planet_stock / static_merchant_stock_max());

	ELSE

		RETURN _base_price * 0.95 * (1.0 + 0.35 *_planet_stock / static_merchant_stock_min());

	END IF;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.tool_compute_market_price(_base_price real, _planet_stock integer) OWNER TO exileng;

--
-- Name: tool_compute_planet_id(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_planet_id(integer, integer, integer) RETURNS integer
    LANGUAGE sql
    AS $_$-- Param1: galaxy

-- Param2: sector

-- Param3: planet

SELECT ($1-1)*25*99 + ($2-1)*25 + $3;$_$;


ALTER FUNCTION ng03.tool_compute_planet_id(integer, integer, integer) OWNER TO exileng;

--
-- Name: tool_compute_planets_upkeep(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_planets_upkeep(integer) RETURNS real
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT float4(860 + 40*GREATEST(0,$1) + 80*GREATEST(0,$1-5) + 120*GREATEST(0,$1-10) + 188*GREATEST(0,$1-15));$_$;


ALTER FUNCTION ng03.tool_compute_planets_upkeep(integer) OWNER TO exileng;

--
-- Name: tool_compute_prestige_cost_for_new_planet(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_compute_prestige_cost_for_new_planet(_planets integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$BEGIN

	RETURN 0;

/*	IF _planets < 5 THEN

		RETURN 0;

	END IF;

*/

END;$$;


ALTER FUNCTION ng03.tool_compute_prestige_cost_for_new_planet(_planets integer) OWNER TO exileng;

--
-- Name: tool_generate_commander_name(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_generate_commander_name() RETURNS character varying
    LANGUAGE sql
    AS $$SELECT (SELECT name FROM dt_commander_firstnames ORDER BY random() LIMIT 1) || ' ' || (SELECT name FROM dt_commander_lastnames ORDER BY random() LIMIT 1);$$;


ALTER FUNCTION ng03.tool_generate_commander_name() OWNER TO exileng;

--
-- Name: tool_generate_key(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_generate_key() RETURNS character varying
    LANGUAGE sql
    AS $$SELECT substring(md5(int2(random()*1000) || chr(int2(65+random()*25)) || chr(int2(65+random()*25)) || date_part('epoch', now()) || chr(int2(65+random()*25)) || chr(int2(65+random()*25))) from 4 for 8);$$;


ALTER FUNCTION ng03.tool_generate_key() OWNER TO exileng;

--
-- Name: tool_get_first_sector_planet(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_get_first_sector_planet(integer, integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ($1-1)*25*99 + ($2-1)*25 + 1;$_$;


ALTER FUNCTION ng03.tool_get_first_sector_planet(integer, integer) OWNER TO exileng;

--
-- Name: tool_get_last_sector_planet(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_get_last_sector_planet(integer, integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT ($1-1)*25*99 + ($2-1)*25 + 25;$_$;


ALTER FUNCTION ng03.tool_get_last_sector_planet(integer, integer) OWNER TO exileng;

--
-- Name: tool_quote(character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.tool_quote(_value character varying) RETURNS character varying
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT COALESCE('"' || $1 || '"', '""');$_$;


ALTER FUNCTION ng03.tool_quote(_value character varying) OWNER TO exileng;

--
-- Name: trigger_alliance_wallet_logs_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_alliance_wallet_logs_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	r record;

	id int4;

BEGIN

	--LOCK gm_alliance_wallet_logs IN ACCESS EXCLUSIVE MODE;

	SELECT INTO r

		type, userid, description, destination, groupid

	FROM gm_alliance_wallet_logs

	WHERE allianceid=NEW.allianceid

	ORDER BY datetime DESC

	LIMIT 1;

	IF FOUND THEN

		IF r.type IS DISTINCT FROM NEW.type OR

		   r.userid IS DISTINCT FROM NEW.userid OR

		   r.description IS DISTINCT FROM NEW.description OR

		   r.destination IS DISTINCT FROM NEW.destination THEN

			id := r.groupid+1;

		ELSE

			id := r.groupid;

		END IF;

	ELSE

		id := 0;

	END IF;

	NEW.groupid := id;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_alliance_wallet_logs_before() OWNER TO exileng;

--
-- Name: trigger_chat_online_profiles_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_chat_online_profiles_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	_chatid int4;

BEGIN

/*

	-- if chatid = 0 then post to the alliance gm_chats

	IF NEW.chatid = 0 THEN

		SELECT INTO _chatid chatid

		FROM gm_profiles

			INNER JOIN gm_alliances ON (gm_alliances.id = gm_profiles.alliance_id)

		WHERE gm_profiles.id=NEW.userid;

		IF FOUND THEN

			NEW.chatid := _chatid;

		ELSE

			RETURN NULL;

		END IF;

	END IF;

*/

	UPDATE gm_chat_online_profiles SET

		lastactivity = now()

	WHERE chatid=NEW.chatid AND userid=NEW.userid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_chat_online_profiles_before() OWNER TO exileng;

--
-- Name: trigger_chats_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_chats_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	_chatid int4;

BEGIN

	-- if chatid = 0 then post to the alliance gm_chats

	IF NEW.chatid = 0 THEN

		SELECT INTO _chatid chatid

		FROM gm_alliances 

		WHERE id = NEW.allianceid;

		IF FOUND THEN

			NEW.chatid := _chatid;

			UPDATE gm_chat_online_profiles SET

				lastactivity = now()

			WHERE chatid=NEW.chatid AND userid=NEW.userid;

			IF NOT FOUND THEN

				INSERT INTO gm_chat_online_profiles(chatid, userid) VALUES(NEW.chatid, NEW.userid);

			END IF;

			NEW.message := internal_chat_replace_banned_words(NEW.message);

			RETURN NEW;

		ELSE

			RETURN NULL;

		END IF;

	END IF;

	PERFORM 1

	FROM gm_profile_chats

		INNER JOIN gm_chats ON (gm_chats.id=gm_profile_chats.chatid AND (gm_chats.password='' OR gm_chats.password = gm_profile_chats.password))

	WHERE userid = NEW.userid AND chatid = NEW.chatid;

	IF FOUND THEN

		UPDATE gm_chat_online_profiles SET

			lastactivity = now()

		WHERE chatid=NEW.chatid AND userid=NEW.userid;

		IF NOT FOUND THEN

			INSERT INTO gm_chat_online_profiles(chatid, userid) VALUES(NEW.chatid, NEW.userid);

		END IF;

		NEW.message := internal_chat_replace_banned_words(NEW.message);

		RETURN NEW;

	ELSE

		RETURN NULL;	-- user cant write to this gm_chats

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_chats_before() OWNER TO exileng;

--
-- Name: trigger_fleet_route_waypoints_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_fleet_route_waypoints_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	-- a new waypoint has been append to a route, assign the "next_waypointid" of the last waypoint of the given routeid

	UPDATE gm_fleet_route_waypoints SET

		next_waypointid = NEW.id

	WHERE id = (SELECT max(id) FROM gm_fleet_route_waypoints WHERE routeid=NEW.routeid AND id < NEW.id);

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_fleet_route_waypoints_after() OWNER TO exileng;

--
-- Name: trigger_fleet_ships_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_fleet_ships_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF (TG_OP = 'DELETE') THEN

		PERFORM internal_fleet_update_data(OLD.fleetid);

	ELSEIF (TG_OP = 'INSERT') THEN

		PERFORM internal_fleet_update_data(NEW.fleetid);

	ELSEIF (TG_OP = 'UPDATE') AND ( OLD.quantity != NEW.quantity ) THEN

		IF NEW.quantity < 0 THEN

			RAISE EXCEPTION 'Quantity is negative';

		ELSEIF NEW.quantity = 0 THEN

			DELETE FROM gm_fleet_ships WHERE fleetid=NEW.fleetid AND shipid=NEW.shipid AND quantity=0;

			RETURN NULL; -- trigger will be called again for DELETE

		END IF;

		PERFORM internal_fleet_update_data(OLD.fleetid);

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_fleet_ships_after() OWNER TO exileng;

--
-- Name: trigger_fleet_ships_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_fleet_ships_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_fleet_ships SET quantity = quantity + NEW.quantity WHERE fleetid=NEW.fleetid AND shipid=NEW.shipid;

	IF FOUND OR NEW.quantity = 0 THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_fleet_ships_before() OWNER TO exileng;

--
-- Name: trigger_fleets_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_fleets_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	CheckBattle bool;

	ContinueRoute bool;

	r_from record;

	r_to record;

	travel_distance float;

	pct float8;

BEGIN

	CheckBattle := true;

	ContinueRoute := false;

	IF (TG_OP = 'DELETE') THEN

		UPDATE gm_planets SET

			blocus_strength=NULL

		WHERE id=OLD.planetid AND blocus_strength IS NOT NULL;

		RETURN OLD;

	END IF;

	IF (NEW.size = 0) /*OR (NEW.planetid IS NULL AND NEW.dest_planetid IS NULL)*/ THEN

		-- if fleet is being created/modified, planetid & dest_planetid are null

		RETURN NULL;

	END IF;

	-- only check for gm_battles if gm_fleets (behavior or planetid) change or if it is an insert

	IF (TG_OP = 'UPDATE') THEN

		IF OLD.action <> 0 AND NEW.action = 0 AND NEW.military_signature > 0 THEN

			UPDATE gm_planets SET

				blocus_strength=NULL

			WHERE id=NEW.planetid AND blocus_strength IS NOT NULL;

		END IF;

		-- when speed decreases, compute new fleet action_end_time

		IF (OLD.action = NEW.action) AND (NEW.action = 1 OR NEW.action = -1) THEN

			IF NEW.mod_speed < OLD.mod_speed THEN

				SELECT INTO r_from galaxy, sector, planet FROM gm_planets WHERE id=NEW.planetid;

				IF FOUND THEN

					SELECT INTO r_to galaxy, sector, planet FROM gm_planets WHERE id=NEW.dest_planetid;

					IF FOUND THEN

						IF r_from.galaxy = r_to.galaxy THEN

							travel_distance := tool_compute_distance(r_from.sector, r_from.planet, r_to.sector, r_to.planet);

							IF NEW.action_end_time > NEW.action_start_time THEN

								pct := date_part('epoch', now() - NEW.action_start_time) / date_part('epoch', NEW.action_end_time - NEW.action_start_time);

							ELSE

								pct := 1;

							END IF;

							UPDATE gm_fleets SET

								action_end_time = GREATEST(action_end_time, action_start_time + pct * travel_distance * 3600 * 1000.0/(NEW.speed*OLD.mod_speed/100.0) * INTERVAL '1 second' + (1-pct)*travel_distance * 3600 * 1000.0/(NEW.speed*NEW.mod_speed/100.0) * INTERVAL '1 second')

							WHERE id=NEW.id;

						END IF;

					END IF;

				END IF;

			END IF;

		END IF;

		IF (OLD.action <> 0 OR OLD.engaged) AND NOT NEW.engaged AND NEW.action=0 AND NEW.next_waypointid IS NOT NULL THEN

			ContinueRoute := true;

		END IF;

		IF OLD.planetid = NEW.planetid AND OLD.attackonsight = NEW.attackonsight AND OLD.size = NEW.size THEN

			CheckBattle := false;

		END IF;

		-- don't check anything for gm_fleets that cancels their travel

		IF NOT OLD.engaged AND (NEW.action=-1 OR NEW.action=1) THEN

			CheckBattle := false;

		END IF;

	END IF;

	IF CheckBattle THEN

		PERFORM internal_planet_check_for_battle(NEW.planetid);

	END IF;

	IF ContinueRoute THEN

		PERFORM internal_fleet_next_waypoint(NEW.ownerid, NEW.id);

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_fleets_after() OWNER TO exileng;

--
-- Name: trigger_log_profile_actions_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_log_profile_actions_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

BEGIN

	IF NEW.userid < 100 THEN

		RETURN NULL;

	END IF;

	SELECT INTO r_user credits, lastlogin FROM gm_profiles WHERE id=NEW.userid;

	IF NOT FOUND THEN

		RAISE EXCEPTION 'unknown userid';

	END IF;

	IF NEW.credits IS NULL THEN

		NEW.credits := r_user.credits;

	END IF;

	NEW.login := r_user.lastlogin;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_log_profile_actions_before() OWNER TO exileng;

--
-- Name: trigger_mail_ignorees_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_mail_ignorees_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	c int4;

BEGIN

	-- check if this entry isn't duplicate but do not raise an exception

	SELECT count(*) INTO c FROM gm_mail_addressees WHERE ownerid=NEW.ownerid AND addresseeid=NEW.addresseeid LIMIT 1;

	IF FOUND AND c > 0 THEN

		-- do not add the entry

		UPDATE gm_mail_addressees SET created=now() WHERE ownerid=NEW.ownerid AND addresseeid=NEW.addresseeid;

		RETURN NULL;

	END IF;

	-- limit to 10 entries per user

	SELECT count(*) INTO c FROM gm_mail_addressees WHERE ownerid=NEW.ownerid;

	if FOUND AND c >= 10 THEN

		DELETE FROM gm_mail_addressees

		WHERE ownerid=NEW.ownerid AND 

			id IN

			(SELECT id

			FROM gm_mail_addressees 

			WHERE ownerid=NEW.ownerid

			ORDER BY created ASC

			LIMIT 1);

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_mail_ignorees_before() OWNER TO exileng;

--
-- Name: trigger_mails_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_mails_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF NEW.ownerid IS NULL AND NEW.senderid IS NULL THEN

		DELETE FROM gm_mails WHERE id= NEW.id;

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_mails_after() OWNER TO exileng;

--
-- Name: trigger_planet_building_pendings_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_building_pendings_before() RETURNS trigger
    LANGUAGE plpgsql STABLE
    AS $$BEGIN

	IF internal_planet_can_build_on(NEW.planetid, NEW.buildingid, (SELECT ownerid FROM gm_planets WHERE id=NEW.planetid)) <> 0 THEN

		RAISE EXCEPTION 'max buildings reached or requirements not met';

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planet_building_pendings_before() OWNER TO exileng;

--
-- Name: trigger_planet_buildings_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_buildings_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF (TG_OP = 'DELETE') THEN

		PERFORM internal_planet_update_data(OLD.planetid);

		PERFORM 1 FROM gm_planet_buildings WHERE planetid=OLD.planetid LIMIT 1;

		IF NOT FOUND THEN

			UPDATE gm_planets SET ownerid=null WHERE id=OLD.planetid;

		END IF;

	ELSEIF (TG_OP = 'INSERT') THEN

		PERFORM internal_planet_update_data(NEW.planetid);

	ELSEIF (TG_OP = 'UPDATE') THEN

		IF (OLD.quantity <> NEW.quantity) OR ( OLD.destroy_datetime IS DISTINCT FROM NEW.destroy_datetime) OR (OLD.disabled <> NEW.disabled) THEN

			IF NEW.quantity = 0 THEN

				-- it will call this trigger again for our DELETE so there's no need to update the planet ourself

				DELETE FROM gm_planet_buildings WHERE planetid=NEW.planetid AND buildingid=NEW.buildingid AND quantity=0;

			ELSE

				PERFORM internal_planet_update_data(OLD.planetid);

			END IF;

		END IF;

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_planet_buildings_after() OWNER TO exileng;

--
-- Name: trigger_planet_buildings_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_buildings_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_planet_buildings SET quantity = quantity + NEW.quantity WHERE planetid=NEW.planetid AND buildingid=NEW.buildingid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_planet_buildings_before() OWNER TO exileng;

--
-- Name: trigger_planet_energy_transfers_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_energy_transfers_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF (TG_OP = 'DELETE') THEN

		PERFORM internal_planet_update_data(OLD.planetid);

		PERFORM internal_planet_update_data(OLD.target_planetid);

	ELSE

		--PERFORM internal_planet_update_data(NEW.planetid);

		PERFORM internal_planet_update_data(NEW.target_planetid);

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planet_energy_transfers_after() OWNER TO exileng;

--
-- Name: trigger_planet_energy_transfers_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_energy_transfers_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet1 record;

	r_planet2 record;

	effectiveness float8;

	distance float8;

BEGIN

	-- compute effective energy transferred according to planet distance and planet owner transfer energy effectiveness

	IF (TG_OP <> 'DELETE') THEN

		SELECT INTO r_planet1 galaxy, sector, planet, ownerid FROM gm_planets WHERE id=NEW.planetid;

		IF NOT FOUND THEN

			NEW.effective_energy := 0;

			RETURN NEW;

		END IF;

		SELECT INTO r_planet2 galaxy, sector, planet FROM gm_planets WHERE id=NEW.target_planetid;

		IF NOT FOUND THEN

			NEW.effective_energy := 0;

			RETURN NEW;

		END IF;

		SELECT INTO effectiveness mod_energy_transfer_effectiveness FROM gm_profiles WHERE id=r_planet1.ownerid;

		IF NOT FOUND THEN

			effectiveness := 0.0;

		END IF;

		IF r_planet1.galaxy <> r_planet2.galaxy THEN

			distance := 200;

		ELSE

			distance := tool_compute_distance(r_planet1.sector, r_planet1.planet, r_planet2.sector, r_planet2.sector);

		END IF;

		effectiveness := LEAST(1.0, GREATEST(0.0, effectiveness/2.0 * 100.0 / GREATEST(1, distance)));

		NEW.energy := LEAST(NEW.energy, 250000);

		NEW.effective_energy := int4(NEW.energy * effectiveness);

	END IF;

	IF (TG_OP = 'INSERT') THEN

		UPDATE gm_planets SET energy_receive_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND target_planetid=NEW.target_planetid)+1 WHERE id=NEW.target_planetid;

		UPDATE gm_planets SET energy_send_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND planetid=NEW.planetid)+1 WHERE id=NEW.planetid;

		NEW.activation_datetime := NOW();

	ELSEIF (TG_OP = 'UPDATE') THEN

		IF OLD.planetid <> NEW.planetid OR OLD.target_planetid <> NEW.target_planetid THEN

			RETURN OLD;

		END IF;

		IF NOT OLD.enabled AND NEW.enabled THEN

			--UPDATE gm_planets SET energy_receive_links=energy_receive_links+1 WHERE id=NEW.target_planetid;

			--UPDATE gm_planets SET energy_send_links=energy_send_links+1 WHERE id=NEW.planetid;

			UPDATE gm_planets SET energy_receive_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND target_planetid=NEW.target_planetid)+1 WHERE id=NEW.target_planetid;

			UPDATE gm_planets SET energy_send_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND planetid=NEW.planetid)+1 WHERE id=NEW.planetid;

			NEW.activation_datetime := NOW();

		END IF;

		IF OLD.enabled AND NOT NEW.enabled THEN

			--UPDATE gm_planets SET energy_receive_links=energy_receive_links-1 WHERE id=NEW.target_planetid;

			--UPDATE gm_planets SET energy_send_links=energy_send_links-1 WHERE id=NEW.planetid;

			UPDATE gm_planets SET energy_receive_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND target_planetid=NEW.target_planetid)-1 WHERE id=NEW.target_planetid;

			UPDATE gm_planets SET energy_send_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND planetid=NEW.planetid)-1 WHERE id=NEW.planetid;

		END IF;

	ELSEIF (TG_OP = 'DELETE') THEN

		IF OLD.enabled THEN

			--UPDATE gm_planets SET energy_receive_links=energy_receive_links-1 WHERE id=OLD.target_planetid;

			--UPDATE gm_planets SET energy_send_links=energy_send_links-1 WHERE id=OLD.planetid;

			UPDATE gm_planets SET energy_receive_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND target_planetid=OLD.target_planetid)-1 WHERE id=OLD.target_planetid;

			UPDATE gm_planets SET energy_send_links=(SELECT count(1) FROM gm_planet_energy_transfers WHERE enabled AND planetid=OLD.planetid)-1 WHERE id=OLD.planetid;

		END IF;

		RETURN OLD;

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planet_energy_transfers_before() OWNER TO exileng;

--
-- Name: trigger_planet_ship_pendings_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_ship_pendings_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	-- if a ship that was being built is removed then 

	-- continue building another ship from the pending list

	IF OLD.end_time IS NOT NULL THEN

		PERFORM internal_planet_next_ship_pending(OLD.planetid);

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_planet_ship_pendings_after() OWNER TO exileng;

--
-- Name: trigger_planet_ship_pendings_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_ship_pendings_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	c int4;

	r_ship record;

BEGIN

	IF NEW.recycle THEN

		RETURN NEW;

	END IF;

	-- prevent inserting a ship if the player doesn't have the requirements

	-- raise an exception in this case

	SELECT INTO r_ship

		new_shipid

	FROM dt_ships

	WHERE id = NEW.shipid AND buildable;

	IF NOT FOUND THEN

		RAISE EXCEPTION 'this ship doestn''t exist or can''t be built';

	END IF;

	PERFORM 1

	FROM dt_ship_building_reqs 

	WHERE shipid = COALESCE(r_ship.new_shipid, NEW.shipid) AND required_buildingid NOT IN (SELECT buildingid FROM gm_planet_buildings WHERE planetid=NEW.planetid);

	IF FOUND THEN

		RAISE EXCEPTION 'buildings requirements not met';

	END IF;

	PERFORM 1

	FROM dt_ship_research_reqs

	WHERE shipid = COALESCE(r_ship.new_shipid, NEW.shipid) AND required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=(SELECT ownerid FROM gm_planets WHERE id=NEW.planetid LIMIT 1) AND level >= required_researchlevel);

	IF FOUND THEN

		RAISE EXCEPTION 'research requirements not met';

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planet_ship_pendings_before() OWNER TO exileng;

--
-- Name: trigger_planet_ships_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_ships_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	IF NEW.quantity <= 0 THEN

		DELETE FROM gm_planet_ships WHERE planetid = OLD.planetid AND shipid = OLD.shipid;

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planet_ships_after() OWNER TO exileng;

--
-- Name: trigger_planet_ships_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_ships_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_planet_ships SET quantity = quantity + NEW.quantity WHERE planetid=NEW.planetid AND shipid=NEW.shipid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_planet_ships_before() OWNER TO exileng;

--
-- Name: trigger_planet_trainings_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planet_trainings_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	-- if a training that was being done is removed then 

	-- continue another training from the pending list

	IF OLD.end_time IS NOT NULL THEN

		PERFORM internal_planet_next_training(OLD.planetid);

	END IF;

	RETURN NULL;

END;$$;


ALTER FUNCTION ng03.trigger_planet_trainings_after() OWNER TO exileng;

--
-- Name: trigger_planets_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planets_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	c int4;

BEGIN

	IF NEW.ownerid IS NOT NULL THEN

		IF OLD.mod_construction_speed_buildings <> NEW.mod_construction_speed_buildings THEN

			PERFORM internal_planet_update_building_pendings_time(NEW.id);

		END IF;

		IF OLD.mod_construction_speed_ships <> NEW.mod_construction_speed_ships THEN

			PERFORM internal_planet_update_ship_pendings_time(NEW.id);

		END IF;

	END IF;

	IF OLD.ownerid IS DISTINCT FROM NEW.ownerid THEN

		-- add or remove the planet from gm_ai_planets table if the new owner is a player or a computer

		PERFORM 1 FROM gm_profiles WHERE id=NEW.ownerid AND privilege <= -100;

		IF FOUND THEN

			PERFORM 1 FROM gm_ai_planets WHERE planetid=NEW.id;

			IF NOT FOUND THEN

				INSERT INTO gm_ai_planets(planetid) VALUES(NEW.id);

			END IF;

		ELSE

			DELETE FROM gm_ai_planets WHERE planetid=NEW.id;

			-- destroy ships if planet lost from another real player

			IF OLD.ownerid IS NOT NULL THEN

				PERFORM internal_planet_destroy_ships(planetid, shipid, quantity) FROM gm_planet_ships WHERE planetid = NEW.id;

			END IF;

		END IF;

		DELETE FROM gm_ai_watched_planets WHERE planetid=NEW.id;

		-- delete all the energy transfers from this planet

		DELETE FROM gm_planet_energy_transfers WHERE planetid = NEW.id;

		-- reset buy orders

		UPDATE gm_planets SET buy_ore=0, buy_hydrocarbon=0 WHERE id=OLD.id;

		-- update production of prestige for the old ownerid

		IF OLD.ownerid IS NOT NULL THEN

			UPDATE gm_profiles SET production_prestige = COALESCE((SELECT sum(production_prestige) FROM gm_planets WHERE ownerid=gm_profiles.id), 0) WHERE id=OLD.ownerid;

		END IF;

	END IF;

	IF OLD.production_prestige <> NEW.production_prestige THEN

		-- update production of prestige for the new ownerid

		UPDATE gm_profiles SET production_prestige = COALESCE((SELECT sum(production_prestige) FROM gm_planets WHERE ownerid=gm_profiles.id), 0) WHERE id=NEW.ownerid;

	END IF;

	IF (NEW.ownerid IS NOT NULL) AND (OLD.commanderid IS DISTINCT FROM NEW.commanderid) THEN

		PERFORM internal_planet_update_data(NEW.id);

	ELSEIF (OLD.scientists <> NEW.scientists) OR (OLD.ownerid IS DISTINCT FROM NEW.ownerid) THEN

		IF NEW.planet_floor > 0 AND NEW.planet_space > 0 THEN

			IF OLD.ownerid IS NOT NULL THEN

				PERFORM internal_profile_update_research_pendings_time(OLD.ownerid);

				IF NEW.ownerid IS DISTINCT FROM OLD.ownerid THEN

					-- update old owner planet count

					UPDATE gm_profiles SET planets=planets-1 WHERE id=OLD.ownerid;

					UPDATE gm_profiles SET noplanets_since=now() WHERE id=OLD.ownerid AND planets=0;

					UPDATE gm_galaxies SET colonies=colonies-1 WHERE id=OLD.galaxy;

				END IF;

			END IF;

			IF NEW.ownerid IS DISTINCT FROM OLD.ownerid THEN

				IF NEW.ownerid IS NULL THEN

					PERFORM internal_planet_reset(NEW.id);

				ELSE

					INSERT INTO gm_profile_reports(ownerid, type, planetid, data)

					VALUES(NEW.ownerid, 6, NEW.id, '{planet:{id:' || NEW.id || ',owner:' || tool_quote(internal_profile_get_name(NEW.ownerid)) || ',g:' || NEW.galaxy || ',s:' || NEW.sector || ',p:' || NEW.planet || '}}');

					PERFORM internal_profile_update_research_pendings_time(NEW.ownerid);

					-- update new owner planet count

					UPDATE gm_profiles SET planets=planets+1, noplanets_since=null WHERE id=NEW.ownerid;

					UPDATE gm_galaxies SET colonies=colonies+1 WHERE id=NEW.galaxy;

					UPDATE gm_galaxies SET protected_until=now()+static_galaxy_protection_delay() WHERE id=NEW.galaxy AND protected_until IS NULL;

					-- 

					UPDATE gm_planets SET

						last_catastrophe = now()+INTERVAl '48 hours',

						commanderid = NULL,

						mood = 0,

						production_frozen=false

					WHERE id=NEW.id;

				END IF;

				-- add an entry in the gm_log_planet_owners journal

				BEGIN

					INSERT INTO gm_log_planet_owners(planetid, ownerid, newownerid) VALUES(NEW.id, OLD.ownerid, NEW.ownerid);

				EXCEPTION

					WHEN FOREIGN_KEY_VIOLATION THEN

						RETURN NEW;

				END;

			END IF;

		END IF;

	END IF;

/*

	IF NEW.shipyard_next_continue IS NOT NULL AND NOT NEW.shipyard_suspended AND 

		(OLD.ore < NEW.ore OR OLD.hydrocarbon < NEW.hydrocarbon OR OLD.energy < NEW.energy OR OLD.workers < NEW.workers OR OLD.ore_production <> NEW.ore_production OR OLD.hydrocarbon_production <> NEW.hydrocarbon_production OR OLD.energy_production <> NEW.energy_production OR OLD.energy_consumption <> NEW.energy_consumption OR OLD.mod_production_workers <> NEW.mod_production_workers OR OLD.workers_busy <> NEW.workers_busy) THEN

		UPDATE gm_planets SET shipyard_next_continue = now()+INTERVAL '2 seconds' WHERE id=NEW.id;

	--	NEW.shipyard_next_continue := now()+INTERVAL '5 seconds';

	--	RAISE NOTICE 'shipyard: %', NEW.id;

	END IF;

*/

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planets_after() OWNER TO exileng;

--
-- Name: trigger_planets_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_planets_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	NEW.ore := LEAST(NEW.ore, NEW.ore_capacity);

	NEW.hydrocarbon := LEAST(NEW.hydrocarbon, NEW.hydrocarbon_capacity);

	NEW.workers := LEAST(NEW.workers, NEW.workers_capacity);

	NEW.energy := GREATEST(0, LEAST(NEW.energy, NEW.energy_capacity));

	NEW.mood = GREATEST(0, NEW.mood);

	NEW.orbit_ore := LEAST(2000000000, NEW.orbit_ore);

	NEW.orbit_hydrocarbon := LEAST(2000000000, NEW.orbit_hydrocarbon);

	IF OLD.ownerid IS DISTINCT FROM NEW.ownerid THEN

		NEW.production_frozen := false;

		NEW.blocus_strength := NULL;

	END IF;

	IF OLD.ownerid IS NULL AND NEW.ownerid IS NOT NULL THEN

		NEW.colonization_datetime := now();

	END IF;

	IF NEW.shipyard_next_continue IS NOT NULL AND NOT NEW.shipyard_suspended AND 

		(OLD.ore < NEW.ore OR OLD.hydrocarbon < NEW.hydrocarbon OR OLD.energy < NEW.energy OR OLD.workers < NEW.workers OR OLD.ore_production <> NEW.ore_production OR OLD.hydrocarbon_production <> NEW.hydrocarbon_production OR OLD.energy_production <> NEW.energy_production OR OLD.energy_consumption <> NEW.energy_consumption OR OLD.mod_production_workers <> NEW.mod_production_workers OR OLD.workers_busy <> NEW.workers_busy) THEN

		NEW.shipyard_next_continue := now()+INTERVAL '5 seconds';

	END IF;

	IF (OLD.credits_production <= 0 AND OLD.credits_random_production <=0) AND (NEW.credits_production > 0 OR NEW.credits_random_production > 0) THEN

		NEW.credits_next_update := NOW();

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_planets_before() OWNER TO exileng;

--
-- Name: trigger_profile_bounties_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_bounties_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_profile_bounties SET

		bounty = bounty + NEW.bounty,

		reward_time = DEFAULT

	WHERE userid=NEW.userid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_profile_bounties_before() OWNER TO exileng;

--
-- Name: trigger_profile_kills_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_kills_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_profiles SET

		prestige_points = prestige_points + int4(NEW.killed*(SELECT prestige_reward FROM dt_ships WHERE id=NEW.shipid) * (100+mod_prestige)/100.0),

		score_prestige = score_prestige + NEW.killed*(SELECT prestige_reward FROM dt_ships WHERE id=NEW.shipid)

	WHERE id=NEW.userid;

	INSERT INTO gm_profile_bounties(userid, bounty)

	VALUES(NEW.userid, NEW.killed * (SELECT bounty FROM dt_ships WHERE id=NEW.shipid));

	UPDATE gm_profile_kills SET

		killed = killed + NEW.killed,  

		lost = lost + NEW.lost

	WHERE userid=NEW.userid AND shipid=NEW.shipid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_profile_kills_before() OWNER TO exileng;

--
-- Name: trigger_profile_reports_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_reports_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	cnt int4;

	aid int4;

BEGIN

	SELECT count(*) INTO cnt FROM gm_profile_reports WHERE ownerid = NEW.ownerid AND type=NEW.type;

	-- keep always 50 gm_profile_reports and gm_profile_reports not older than 2 days old to avoid report flooding

	cnt := cnt - 50;

	IF cnt > 0 THEN

		DELETE FROM gm_profile_reports WHERE id IN (SELECT id FROM gm_profile_reports WHERE ownerid=NEW.ownerid AND type=NEW.type AND datetime < now() - INTERVAL '2 days' ORDER BY datetime LIMIT cnt);

	END IF;

/*

	PERFORM 1 FROM gm_profile_reports WHERE userid=NEW.ownerid AND type=NEW.type AND subtype=NEW.subtype;

	IF FOUND THEN

		INSERT INTO reports_queue(ownerid, "type", subtype, datetime, battleid, fleetid, fleet_name, planetid, researchid, ore, hydrocarbon, scientists, soldiers, workers, credits, allianceid, userid, invasionid, spyid, commanderid, buildingid, description, planet_name, planet_relation, planet_ownername, data)

		VALUES(NEW.ownerid, NEW.type, NEW.subtype, NEW.datetime, NEW.battleid, NEW.fleetid, NEW.fleet_name, NEW.planetid, NEW.researchid, NEW.ore, NEW.hydrocarbon, NEW.scientists, NEW.soldiers, NEW.workers, NEW.credits, NEW.allianceid, NEW.userid, NEW.invasionid, NEW.spyid, NEW.commanderid, NEW.buildingid, NEW.description, NEW.planet_name, NEW.planet_relation, NEW.planet_ownername, NEW.data);

	END IF;*/

	IF NEW.type = 2 OR NEW.type = 8 THEN

		SELECT INTO aid alliance_id FROM gm_profiles WHERE id=NEW.ownerid;

		IF aid IS NOT NULL THEN

			IF NEW.type = 2 AND NEW.battleid IS NOT NULL THEN

				PERFORM 1 FROM gm_alliance_reports WHERE ownerallianceid=aid AND "type"=2 AND battleid=NEW.battleid;

				IF FOUND THEN

					RETURN NEW;

				END IF;

			END IF;

			INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, "type", subtype, datetime, battleid, fleetid, fleet_name, planetid, researchid, ore, hydrocarbon, scientists, soldiers, workers, credits, allianceid, userid, invasionid, spyid, commanderid, buildingid, description, planet_name, planet_relation, planet_ownername, data)

			VALUES(aid, NEW.ownerid, NEW.type, NEW.subtype, NEW.datetime, NEW.battleid, NEW.fleetid, NEW.fleet_name, NEW.planetid, NEW.researchid, NEW.ore, NEW.hydrocarbon, NEW.scientists, NEW.soldiers, NEW.workers, NEW.credits, NEW.allianceid, NEW.userid, NEW.invasionid, NEW.spyid, NEW.commanderid, NEW.buildingid, NEW.description, NEW.planet_name, NEW.planet_relation, NEW.planet_ownername, NEW.data);

		END IF;

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_profile_reports_after() OWNER TO exileng;

--
-- Name: trigger_profile_reports_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_reports_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	r_planet record;

BEGIN

	IF NEW.planetid IS NOT NULL THEN

		SELECT INTO r_planet ownerid, name FROM gm_planets WHERE id=NEW.planetid;

		IF FOUND THEN

			NEW.planet_relation := internal_profile_get_relation(r_planet.ownerid, NEW.ownerid);

			NEW.planet_ownername := internal_profile_get_name(r_planet.ownerid);

			IF NEW.planet_relation = 2 THEN

				NEW.planet_name := r_planet.name;

			ELSE

				NEW.planet_name := NEW.planet_ownername;

			END IF;

		END IF;

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_profile_reports_before() OWNER TO exileng;

--
-- Name: trigger_profile_research_pendings_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_research_pendings_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$-- check that requirements are met before being able to add a research to the pending gm_profile_researches

BEGIN

	PERFORM id

	FROM dt_researches

	WHERE id=NEW.researchid AND

		NOT EXISTS

		(SELECT required_buildingid

		FROM dt_research_building_reqs 

		WHERE (researchid = NEW.researchid) AND (required_buildingid NOT IN 

			(SELECT gm_planet_buildings.buildingid

			FROM gm_planets LEFT JOIN gm_planet_buildings ON (gm_planets.id = gm_planet_buildings.planetid)

			WHERE gm_planets.ownerid=NEW.userid

			GROUP BY gm_planet_buildings.buildingid

			HAVING sum(gm_planet_buildings.quantity) >= required_buildingcount)))

	AND

		NOT EXISTS

		(SELECT required_researchid, required_researchlevel

		FROM dt_research_research_reqs

		WHERE (researchid = NEW.researchid) AND (required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=NEW.userid AND level >= required_researchlevel)));

	IF NOT FOUND THEN

		RAISE EXCEPTION 'Requirements not met.';

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_profile_research_pendings_before() OWNER TO exileng;

--
-- Name: trigger_profile_researches_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profile_researches_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	UPDATE gm_profile_researches SET level = level + 1 WHERE userid=NEW.userid AND researchid=NEW.researchid;

	IF FOUND THEN

		RETURN NULL;

	ELSE

		RETURN NEW;

	END IF;

END;$$;


ALTER FUNCTION ng03.trigger_profile_researches_before() OWNER TO exileng;

--
-- Name: trigger_profiles_after(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profiles_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	left_alliance bool;

BEGIN

	left_alliance := False;

	IF (TG_OP = 'DELETE') THEN

		left_alliance := true;

	ELSEIF (OLD.alliance_id IS DISTINCT FROM NEW.alliance_id) AND (OLD.alliance_id IS NOT NULL) THEN

		left_alliance := true;

	ELSEIF (OLD.alliance_rank = 0 AND NEW.alliance_rank > 0) THEN

		PERFORM internal_alliance_check_for_leader(OLD.alliance_id);

	END IF;

	IF left_alliance THEN

		-- remove user contributed combat score from alliance score_combat

		UPDATE gm_alliances SET score_combat = score_combat - OLD.alliance_score_combat WHERE id=OLD.alliance_id;

		DELETE FROM gm_alliance_money_requests WHERE allianceid=OLD.alliance_id AND userid=OLD.id;

		PERFORM internal_alliance_check_for_leader(OLD.alliance_id);

	END IF;

	RETURN OLD;

END;$$;


ALTER FUNCTION ng03.trigger_profiles_after() OWNER TO exileng;

--
-- Name: trigger_profiles_before(); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.trigger_profiles_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

BEGIN

    -- During deletion

	DELETE FROM gm_commanders WHERE ownerid=OLD.id;

	DELETE FROM gm_profile_research_pendings WHERE userid=OLD.id;

	UPDATE gm_planets SET commanderid=null, ownerid=2 WHERE ownerid=OLD.id AND score >= 80000;

	UPDATE gm_planets SET commanderid=null, ownerid=NULL WHERE ownerid=OLD.id;

	-- user is game over

	IF OLD.planets > 0 AND NEW.planets = 0 THEN

		-- make him leave his alliance

		NEW.alliance_id := NULL;

		-- give his gm_fleets to a npc

		UPDATE gm_fleets SET ownerid=2, attackonsight=false, uid=nextval('npc_fleet_uid_seq') WHERE ownerid=OLD.id;

	END IF;

	IF OLD.login <> NEW.login THEN

		DELETE FROM gm_mail_ignorees WHERE ignored_userid = NEW.id;

		UPDATE gm_alliance_reports SET userid=null WHERE userid = NEW.id;

		UPDATE gm_profile_reports SET userid=null WHERE userid = NEW.id;

	END IF;

	-- update the player protection

	IF NEW.protection_enabled THEN

		IF NEW.protection_colonies_to_unprotect > 0 AND NEW.colonies > protection_colonies_to_unprotect THEN

			NEW.protection_enabled := false;

		END IF;

	END IF;

	-- user leaves his alliance

	IF (OLD.alliance_id IS DISTINCT FROM NEW.alliance_id) AND (OLD.alliance_id IS NOT NULL) AND (OLD.alliance_joined IS NOT NULL) THEN

		INSERT INTO gm_log_profile_alliances(userid, alliance_tag, alliance_name, joined, "left", taxes_paid, credits_given, credits_taken)

		SELECT OLD.id, tag, name, OLD.alliance_joined, now(), OLD.alliance_taxes_paid, OLD.alliance_credits_given, OLD.alliance_credits_taken FROM gm_alliances WHERE id=OLD.alliance_id;

		-- reset the stats, ranks .. of the player

		NEW.alliance_score_combat := 0;

		NEW.alliance_left := now() + static_alliance_joining_delay();

		NEW.alliance_rank := 100;

		NEW.alliance_joined := now();

		NEW.alliance_taxes_paid := 0;

		NEW.alliance_credits_given := 0;

		NEW.alliance_credits_taken := 0;

	END IF;

	IF OLD.score_visibility <> NEW.score_visibility THEN

		NEW.score_visibility_last_change := now();

	END IF;

	IF NEW.score_visibility = 2 AND NEW.score_visibility_last_change < now() - INTERVAL '1 day' AND NEW.prestige_points - OLD.prestige_points > 0 THEN

		NEW.prestige_points := OLD.prestige_points + (1.1*(NEW.prestige_points - OLD.prestige_points))::integer;

		NEW.score_prestige := OLD.score_prestige + (1.1*(NEW.score_prestige - OLD.score_prestige))::integer;

	END IF;

	IF NEW.prestige_points_refund - OLD.prestige_points_refund > 0 THEN

		NEW.prestige_points := NEW.prestige_points + (NEW.prestige_points_refund - OLD.prestige_points_refund);

	END IF;

	RETURN NEW;

END;$$;


ALTER FUNCTION ng03.trigger_profiles_before() OWNER TO exileng;

--
-- Name: user_alliance_create(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_create("UserId" integer, "AllianceName" character varying, "AllianceTag" character varying, "AllianceDescription" character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	_allianceid int4;

	_chatid int8;

BEGIN

	-- check that user is not in an alliance and that he can create an alliance

	PERFORM id FROM gm_profiles WHERE id=$1 AND alliance_id IS NULL AND (alliance_left IS NULL OR alliance_left < now());

	IF NOT FOUND THEN

		-- The user either doesn't exist, is already in an alliance or can't create an alliance for now

		RETURN -1;

	END IF;

	-- create the alliance

	BEGIN

		-- try to get the money first to prevent any further queries in case the user doesn't have enough money

		-- raise a check_violation if the player have not enough money

		UPDATE gm_profiles SET credits=credits-10000 WHERE id=$1 AND credits >= 10000;

		IF NOT FOUND THEN

			RETURN -4; -- not enough money

		END IF;

		-- delete gm_alliances with no members that conflict with the chosen names/tags

		DELETE FROM gm_alliances 

		WHERE (upper(name) = upper($2) OR upper(tag) = upper($3)) AND (SELECT count(*) FROM gm_profiles WHERE alliance_id=gm_alliances.id) = 0;

		-- retrieve an alliance id

		_allianceid := nextval('gm_alliances_id_seq');

		-- create gm_chats cannal for the alliance

		_chatid := nextval('gm_chats_id_seq');

		INSERT INTO gm_chats(id) VALUES(_chatid);

		INSERT INTO gm_alliances(id, name, tag, description, chatid)

		VALUES(_allianceid, $2, upper($3), $4, _chatid);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, members_displayed, can_manage_description, can_manage_announce, can_see_members_info, can_order_other_fleets, can_use_alliance_radars)

		VALUES(_allianceid, 0, 'Responsable', true, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, can_see_members_info)

		VALUES(_allianceid, 10, 'Trésorier', false, true, true, true, true, true, true, true, true, true, false, true);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, can_see_members_info)

		VALUES(_allianceid, 20, 'Ambassadeur', false, true, true, true, true, true, true, false, false, true, false, true);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, can_see_members_info)

		VALUES(_allianceid, 30, 'Officier recruteur', false, true, true, false, false, true, true, false, false, false, false, true);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, can_see_members_info)

		VALUES(_allianceid, 40, 'Officier', false, false, false, false, false, true, true, false, false, false, false, true);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default)

		VALUES(_allianceid, 50, 'Membre', false, false, false, false, false, true, false, false, false, false, false);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, enabled)

		VALUES(_allianceid, 60, 'Grade #7', false, false, false, false, false, false, false, false, false, false, false, false);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, enabled)

		VALUES(_allianceid, 70, 'Grade #8', false, false, false, false, false, false, false, false, false, false, false, false);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default, enabled)

		VALUES(_allianceid, 80, 'Grade #9', false, false, false, false, false, false, false, false, false, false, false, false);

		INSERT INTO gm_alliance_ranks(allianceid, rankid, label, leader, can_invite_player, can_kick_player, can_create_nap, can_break_nap, can_ask_money, can_see_reports, can_accept_money_requests, can_change_tax_rate, can_mail_alliance, is_default)

		VALUES(_allianceid, 100, 'Novice', false, false, false, false, false, false, false, false, false, false, true);

		UPDATE gm_profiles SET

			alliance_id=_allianceid,

			alliance_rank=0,

			alliance_joined=now(),

			alliance_left=null

		WHERE id=$1;

		-- declare war

		PERFORM user_alliance_war_create(1, upper($3));

		PERFORM user_alliance_war_create(2, upper($3));

		RETURN _allianceid;

	EXCEPTION

		WHEN UNIQUE_VIOLATION THEN

			PERFORM id FROM gm_alliances WHERE upper(name)=upper($2);

			-- it is either a duplicate name or tag

			IF FOUND THEN

				-- duplicate name

				RETURN -2;

			ELSE

				-- duplicate tag

				RETURN -3;

			END IF;

	END;

END;$_$;


ALTER FUNCTION ng03.user_alliance_create("UserId" integer, "AllianceName" character varying, "AllianceTag" character varying, "AllianceDescription" character varying) OWNER TO exileng;

--
-- Name: user_alliance_give_money(integer, integer, character varying, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_give_money(integer, integer, character varying, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Transfer money from player wallet to alliance wallet if credits > 0

-- Param1: UserId

-- Param2: Credits

-- Param3: Description

-- Param4: Type of transfer (0=gift, 1=tax, 2=player left alliance, 3=money request accepted)

DECLARE

	r_user record;

BEGIN

	IF $2 = 0 THEN

		RETURN 0;

	END IF;

	SELECT INTO r_user login, alliance_id FROM gm_profiles WHERE id=$1;

	IF NOT FOUND OR r_user.alliance_id IS NULL  THEN

		RETURN 1;

	END IF;

	BEGIN

		IF $2 > 0 THEN

			INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, source, type)

			VALUES(r_user.alliance_id, $1, $2, $3, r_user.login, $4);

		ELSE

			INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, destination, type)

			VALUES(r_user.alliance_id, $1, $2, $3, r_user.login, $4);

		END IF;

		IF $2 > 0 THEN

			UPDATE gm_profiles SET alliance_credits_given = alliance_credits_given + $2 WHERE id=$1;

		ELSE

			UPDATE gm_profiles SET alliance_credits_taken = alliance_credits_taken - $2 WHERE id=$1;

		END IF;

		--PERFORM sp_log_credits($1, -$2, 'Transfer money to alliance');

		INSERT INTO gm_log_profile_actions(userid, credits_delta, to_alliance)

		VALUES($1, -$2, r_user.alliance_id);

		IF $4 = 0 THEN

			-- check if has enough credits only for gifts, keep paying taxes on sales

			UPDATE gm_profiles SET credits=credits-$2 WHERE id=$1 AND credits >= $2;

			IF NOT FOUND THEN

				RAISE EXCEPTION 'not enough credits';

			END IF;

		ELSE

			UPDATE gm_profiles SET credits=credits-$2 WHERE id=$1;

		END IF;

		UPDATE gm_alliances SET credits = credits + $2 WHERE id=r_user.alliance_id;

		IF NOT FOUND THEN

			RAISE EXCEPTION 'alliance not found';

		END IF;

	EXCEPTION

		WHEN RAISE_EXCEPTION THEN

			RETURN 2;

	END;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_give_money(integer, integer, character varying, integer) OWNER TO exileng;

--
-- Name: user_alliance_invitation_accept(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_invitation_accept(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: Alliance tag

DECLARE

	r_alliance record;

	r_user record;

	_members int4;

	_rankid int2;

BEGIN

	-- find the alliance id for the given tag

	SELECT INTO r_alliance

		id, max_members, tag, name

	FROM gm_alliances

	WHERE upper(tag)=upper($2);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 1;

	END IF;

	-- check that there is an invitation from this alliance for this player

	PERFORM allianceid

	FROM gm_alliance_invitations

	WHERE allianceid=r_alliance.id AND userid=_userid AND NOT declined;

	IF NOT FOUND THEN

		-- no invitations issued from this alliance

		RETURN 2;

	END IF;

	-- check that max members count is not reached

	SELECT INTO _members count(1) FROM gm_profiles WHERE alliance_id=r_alliance.id;

	IF _members >= r_alliance.max_members THEN

		-- max members count reached

		RETURN 4;

	END IF;

	SELECT INTO _rankid rankid FROM gm_alliance_ranks WHERE allianceid=r_alliance.id AND enabled AND is_default ORDER BY rankid DESC LIMIT 1;

	IF NOT FOUND THEN

		SELECT INTO _rankid rankid FROM gm_alliance_ranks WHERE allianceid=r_alliance.id AND enabled ORDER BY rankid DESC LIMIT 1;

		IF NOT FOUND THEN

			RETURN 1;

		END IF;

	END IF;

	UPDATE gm_profiles SET

		alliance_id = r_alliance.id,

		alliance_rank = _rankid,

		alliance_joined = now(),

		alliance_left = null

	WHERE id=_userid AND alliance_id IS NULL AND (alliance_left IS NULL OR alliance_left < now())

	RETURNING login INTO r_user;

	IF NOT FOUND THEN

		-- player is already in an alliance

		RETURN 3;

	END IF;

	-- remove invitation

	DELETE FROM gm_alliance_invitations WHERE allianceid=r_alliance.id AND userid=_userid;

	-- add a report that the player accepted the invitation

	INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, data)

	VALUES(r_alliance.id, $1, 1, 30, '{player:' || tool_quote(r_user.login) || '}');

	-- add a report that the player joined this alliance

	INSERT INTO gm_profile_reports(ownerid, type, subtype, data)

	VALUES($1, 1, 40, '{alliance:{tag:' || tool_quote(r_alliance.tag) || ',name:' || tool_quote(r_alliance.name) || '}}');

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_invitation_accept(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_invitation_create(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_invitation_create(_userid integer, _invited_user character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: name of user invited

DECLARE

	r_user record;

	r_inviteduser record;

	has_unprotected_planets boolean;

BEGIN

	-- check that the player $1 can invite

	SELECT INTO r_user

		alliance_id, login, gm_alliances.tag, gm_alliances.name

	FROM gm_profiles

		INNER JOIN gm_alliances ON (gm_alliances.id=gm_profiles.alliance_id)

	WHERE gm_profiles.id=_userid AND (SELECT can_invite_player FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- if alliance only has planets in protected galaxies then can't invite gm_profiles in other galaxies

	PERFORM 1

	FROM gm_profiles

		INNER JOIN gm_planets ON (gm_planets.ownerid = gm_profiles.id)

		INNER JOIN gm_galaxies ON (gm_galaxies.id = gm_planets.galaxy)

	WHERE alliance_id = r_user.alliance_id AND protected_until < now();

	has_unprotected_planets := FOUND;

	-- retrieve id of the invited player

	SELECT INTO r_inviteduser

		id,

		login,

		(SELECT count(DISTINCT galaxy) FROM gm_planets WHERE ownerid=gm_profiles.id) AS galaxies,

		(SELECT galaxy FROM gm_planets WHERE ownerid=gm_profiles.id LIMIT 1) AS galaxy

	FROM gm_profiles

	WHERE upper(login)=upper(_invited_user);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF NOT has_unprotected_planets THEN

		-- allow only gm_profiles in the same galaxy

		PERFORM 1

		FROM gm_profiles

			INNER JOIN gm_planets ON (gm_planets.ownerid = gm_profiles.id)

		WHERE alliance_id = r_user.alliance_id AND gm_planets.galaxy <> r_inviteduser.galaxy;

		IF FOUND THEN

			RETURN 6;

		END IF;

	END IF;

	IF r_inviteduser.galaxies = 1 THEN

		PERFORM 1

		FROM gm_galaxies

		WHERE id=r_inviteduser.galaxy AND protected_until > now();

		IF FOUND THEN

			-- trying to invite a nation in a protected galaxy

			-- check that all planets of the alliance are in the same galaxy of the invited nation

			PERFORM 1

			FROM gm_profiles

				INNER JOIN gm_planets ON (gm_planets.ownerid = gm_profiles.id)

			WHERE alliance_id = r_user.alliance_id AND gm_planets.galaxy <> r_inviteduser.galaxy;

			IF FOUND THEN

				RETURN 6;

			END IF;

		END IF;

	END IF;

	-- check that the invited player is not already a member of this alliance

	PERFORM id

	FROM gm_profiles

	WHERE id=r_inviteduser.id AND alliance_id = r_user.alliance_id;

	IF FOUND THEN

		RETURN 3;

	END IF;

	BEGIN

		INSERT INTO gm_alliance_invitations(allianceid, userid, recruiterid)

		VALUES(r_user.alliance_id, r_inviteduser.id, _userid);

		INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid, userid, data)

		VALUES(r_inviteduser.id, 1, 0, r_user.alliance_id, _userid, '{by:' || tool_quote(r_user.login) || ',alliance:{tag:' || tool_quote(r_user.tag) || ',name:' || tool_quote(r_user.name) || '}}');

		-- add an invitation notice to user alliance

		INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, invited_username, data)

		VALUES(r_user.alliance_id, _userid, 1, 20, r_inviteduser.login, '{by:' || tool_quote(r_user.login) || ',invited:' || tool_quote(r_inviteduser.login) || '}');

		RETURN 0;

	EXCEPTION

		WHEN FOREIGN_KEY_VIOLATION THEN

			RETURN 4;

		WHEN UNIQUE_VIOLATION THEN

			RETURN 5;

	END;

END;$_$;


ALTER FUNCTION ng03.user_alliance_invitation_create(_userid integer, _invited_user character varying) OWNER TO exileng;

--
-- Name: user_alliance_invitation_decline(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_invitation_decline(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

-- Param2: Alliance tag

DECLARE

	r_alliance record;

	r_user record;

BEGIN

	SELECT INTO r_user

		id, login

	FROM gm_profiles

	WHERE id=_userid;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO r_alliance

		id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 1;

	END IF;

	-- check that there is an invitation from this alliance for this player

	UPDATE gm_alliance_invitations SET

		declined=true,

		replied=now()

	WHERE allianceid=r_alliance.id AND userid=_userid AND NOT declined AND replied IS NULL;

	IF NOT FOUND THEN

		-- no invitations issued from this alliance

		RETURN 2;

	END IF;

	-- add a report that the player declined the invitation

	INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, data)

	VALUES(r_alliance.id, _userid, 1, 22, '{player:' || tool_quote(r_user.login) || '}');

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_invitation_decline(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_kick_member(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_kick_member(_userid integer, _kicked_user character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: Name of who to kick from the alliance

DECLARE

	r_user record;	-- info on the "kicker"

	r_kicked record;	-- info on the "kicked player"

	leave_count integer;

	ttl interval;	-- time it will take the player to leave alliance

BEGIN

	-- check that the player $1 can kick

	SELECT INTO r_user

		gm_profiles.id, login, alliance_id, alliance_rank, gm_alliances.tag, gm_alliances.name

	FROM gm_profiles

		INNER JOIN gm_alliances ON (gm_alliances.id=alliance_id)

	WHERE gm_profiles.id=_userid AND (SELECT can_kick_player FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	BEGIN

	/*

		-- check that no more than static_alliance_simultaneous_leaving_max() are already leaving the alliance

		SELECT INTO leave_count

			count(1)

		FROM gm_profiles

		WHERE alliance_id=r_user.alliance_id AND leave_alliance_datetime IS NOT NULL;

		IF leave_count >= static_alliance_simultaneous_leaving_max() THEN

			RETURN 9;

		END IF;*/

		PERFORM 1 FROM gm_alliances WHERE id=r_user.alliance_id AND last_kick > now()-INTERVAL '24 hours';

		IF FOUND THEN

			RETURN 9;

		END IF;

		-- if alliance is at war, time to leave alliance is 3 times longer

		IF internal_alliance_is_at_war(r_user.alliance_id) THEN

			ttl := 7*static_alliance_leaving_delay();

		ELSE

			ttl := static_alliance_leaving_delay();

		END IF;

		-- remove user from the alliance

		UPDATE gm_profiles SET

			--alliance_id=null,

			leave_alliance_datetime=now() + ttl

		WHERE upper(login)=upper(_kicked_user) AND alliance_id=r_user.alliance_id AND alliance_rank > r_user.alliance_rank AND leave_alliance_datetime IS NULL

		RETURNING id, login, internal_profile_get_alliance_leaving_cost(id) as price INTO r_kicked;

		IF NOT FOUND THEN

			RETURN 2;

		END IF;

		IF r_kicked.price > 0 THEN

			UPDATE gm_alliances SET credits=credits-r_kicked.price WHERE id=r_user.alliance_id;

		END IF;

		UPDATE gm_alliances SET last_kick=now() WHERE id=r_user.alliance_id;

		-- add a report that the player was kicked

		INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, userid, credits, data)

		VALUES(r_user.alliance_id, r_kicked.id, 1, 32, r_user.id, r_kicked.price, '{by:' || tool_quote(r_user.login) || ',player:' || tool_quote(r_kicked.login) || '}');

		INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, source, type)

		VALUES(r_user.alliance_id, r_user.id, -r_kicked.price, '', r_kicked.login, 5);

		INSERT INTO gm_profile_reports(ownerid, type, subtype, data)

		VALUES(r_kicked.id, 1, 42, '{by:' || tool_quote(r_user.login) || ',alliance:{tag:' || tool_quote(r_user.tag) || ',name:' || tool_quote(r_user.name) || '}}');

		RETURN 0;

	EXCEPTION

		WHEN CHECK_VIOLATION THEN -- not enough money

			RETURN 3;

	END;

END;$_$;


ALTER FUNCTION ng03.user_alliance_kick_member(_userid integer, _kicked_user character varying) OWNER TO exileng;

--
-- Name: user_alliance_leave(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_leave(_userid integer, _cost integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: charges cost

DECLARE

	r_user record;

	leave_count integer;

	ttl interval;

BEGIN

	SELECT INTO r_user

		login, alliance_id, gm_alliances.tag, gm_alliances.name

	FROM gm_profiles

		INNER JOIN gm_alliances ON (gm_alliances.id=gm_profiles.alliance_id)

	WHERE gm_profiles.id=_userid AND alliance_id IS NOT NULL;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

/*

	-- check that no more than static_alliance_simultaneous_leaving_max() are already leaving the alliance

	SELECT INTO leave_count

		count(1)

	FROM gm_profiles

	WHERE alliance_id=r_user.alliance_id AND leave_alliance_datetime IS NOT NULL;

	IF leave_count >= static_alliance_simultaneous_leaving_max() THEN

		RETURN 9;

	END IF;

*/

	INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, source, type)

	VALUES(r_user.alliance_id, _userid, 0, '', r_user.login, 2);

	-- add a report that the player is leaving the alliance

	INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, data)

	VALUES(r_user.alliance_id, _userid, 1, 31, '{player:' || tool_quote(r_user.login) || '}');

	-- add a report to the user gm_profile_reports that he is leaving

	INSERT INTO gm_profile_reports(ownerid, type, subtype, data)

	VALUES(_userid, 1, 41, '{alliance:{tag:' || tool_quote(r_user.tag) || ',name:' || tool_quote(r_user.name) || '}}');

	IF _cost > 0 THEN

		INSERT INTO gm_log_profile_actions(userid, credits_delta, leave_alliance)

		VALUES($1, -_cost, r_user.alliance_id);

	END IF;

	-- if alliance is at war, time to leave alliance is 3 times longer

	IF internal_alliance_is_at_war(r_user.alliance_id) THEN

		ttl := 7*static_alliance_leaving_delay();

	ELSE

		ttl := static_alliance_leaving_delay();

	END IF;

	UPDATE gm_profiles SET

		--alliance_id=null,

		credits=credits-_cost,

		leave_alliance_datetime=now() + ttl

	WHERE id=_userid AND leave_alliance_datetime IS NULL;

	RETURN 0;

EXCEPTION

	WHEN CHECK_VIOLATION THEN

		RETURN 1;

END;$_$;


ALTER FUNCTION ng03.user_alliance_leave(_userid integer, _cost integer) OWNER TO exileng;

--
-- Name: user_alliance_money_request_accept(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_money_request_accept(_userid integer, _money_requestid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

-- Param2: money request Id

DECLARE

	r_user record;

	r_request record;

BEGIN

	SELECT INTO r_user

		alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_accept_money_requests FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found

		RETURN 1;

	END IF;

	SELECT INTO r_request

		userid, credits, description

	FROM gm_alliance_money_requests

	WHERE id=_money_requestid AND allianceid=r_user.alliance_id;

	BEGIN

		DELETE FROM gm_alliance_money_requests WHERE id=_money_requestid AND allianceid=r_user.alliance_id;

		IF user_alliance_give_money(r_request.userid, -r_request.credits, r_request.description, 3) <> 0 THEN

			RAISE EXCEPTION 'not enough money';

		END IF;

		RETURN 0;

	EXCEPTION

		WHEN RAISE_EXCEPTION THEN

			RETURN 1;

	END;

END;$$;


ALTER FUNCTION ng03.user_alliance_money_request_accept(_userid integer, _money_requestid integer) OWNER TO exileng;

--
-- Name: user_alliance_money_request_create(integer, integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_money_request_create(_userid integer, _credits integer, _reason character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: Money

-- Param3: Description

DECLARE

	r_user record;

	had_request bool;

BEGIN

	-- find the alliance id of the user and check if he can accept NAPs for his alliance

	SELECT INTO r_user

		login, alliance_id, alliance_rank

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_ask_money FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank) AND (now()-game_started > INTERVAL '2 weeks');

	IF NOT FOUND THEN

		-- user not found

		RETURN 1;

	END IF;

	-- delete the previous request if he already had one

	DELETE FROM gm_alliance_money_requests WHERE allianceid=r_user.alliance_id AND userid=$1;

	had_request := FOUND;

	IF $2 > 0 THEN

		INSERT INTO gm_alliance_money_requests(allianceid, userid, credits, description)

		VALUES(r_user.alliance_id, $1, $2, $3);

		-- notify leader/treasurer : send them a report

		IF had_request THEN

			INSERT INTO gm_profile_reports(ownerid, "type", subtype, credits, description, userid, data)

			SELECT id, 1, 11, $2, $3, $1, '{player:' || tool_quote(r_user.login) || ',credits:' || _credits || ',reason:' || tool_quote(_reason) || '}' FROM gm_profiles WHERE alliance_id=r_user.alliance_id AND alliance_rank <= 1;

		ELSE

			INSERT INTO gm_profile_reports(ownerid, "type", subtype, credits, description, userid, data)

			SELECT id, 1, 10, $2, $3, $1, '{player:' || tool_quote(r_user.login) || ',credits:' || _credits || ',reason:' || tool_quote(_reason) || '}' FROM gm_profiles WHERE alliance_id=r_user.alliance_id AND alliance_rank <= 1;

		END IF;

	ELSE

		IF had_request THEN

			INSERT INTO gm_profile_reports(ownerid, "type", subtype, userid, data)

			SELECT id, 1, 12, $1, '{player:' || tool_quote(r_user.login) || '}' FROM gm_profiles WHERE alliance_id=r_user.alliance_id AND alliance_rank <= 1;

		END IF;

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_money_request_create(_userid integer, _credits integer, _reason character varying) OWNER TO exileng;

--
-- Name: user_alliance_money_request_decline(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_money_request_decline(_userid integer, _money_requestid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

-- Param2: money request Id

DECLARE

	r_user record;

BEGIN

	SELECT INTO r_user alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_accept_money_requests FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found

		RETURN 1;

	END IF;

	UPDATE gm_alliance_money_requests SET

		result=false

	WHERE id=_money_requestid AND allianceid=r_user.alliance_id;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_money_request_decline(_userid integer, _money_requestid integer) OWNER TO exileng;

--
-- Name: user_alliance_nap_break(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_break(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	r_nap record;

	aid int4;

	targetaid int4;

	aguarantee int4;

BEGIN

	-- find the alliance id of the user and check if he can break NAPs for his alliance

	SELECT INTO aid alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_break_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to break the NAP

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO targetaid id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	-- retrieve the NAP conditions

	SELECT INTO r_nap break_interval

	FROM gm_alliance_naps

	WHERE allianceid1=aid AND allianceid2=targetaid LIMIT 1;

	IF NOT FOUND THEN

		-- no NAPs found

		RETURN 3;

	END IF;

	UPDATE gm_alliance_naps SET

		break_on=now() + r_nap.break_interval

	WHERE break_on IS NULL AND ((allianceid1=aid AND allianceid2=targetaid) or (allianceid1=targetaid AND allianceid2=aid));

	IF FOUND THEN

		-- warn the target alliance leaders that this alliance broke the NAP

		INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid)

		SELECT id, 1, 71, aid

		FROM gm_profiles

			INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

		WHERE alliance_id=targetaid AND (r.leader OR r.can_create_nap);	

	END IF;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_nap_break(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_nap_offer_accept(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_offer_accept(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	r_user record;

	fromaid int4;

	offer record;

	c int4;

BEGIN

	-- find the alliance id of the user and check if he can accept NAPs for his alliance

	SELECT INTO r_user

		alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to accept the NAP

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO fromaid id

	FROM gm_alliances

	WHERE upper(tag) = upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	-- check if there is a NAP request from "fromaid" to "aid" and retrieve the guarantees

	SELECT INTO offer break_interval

	FROM gm_alliance_nap_offers

	WHERE allianceid=fromaid AND targetallianceid=r_user.alliance_id AND NOT declined;

	IF NOT FOUND THEN

		-- no requests issued from the named alliance $2

		RETURN 3;

	END IF;

	-- check if there is a WAR between "fromaid" and "aid"

	PERFORM 1

	FROM gm_alliance_wars

	WHERE (allianceid1=fromaid AND allianceid2=r_user.alliance_id) OR (allianceid2=fromaid AND allianceid1=r_user.alliance_id);

	IF FOUND THEN

		RETURN 4;

	END IF;

	-- check number of naps

	SELECT INTO c count(*)

	FROM gm_alliance_naps

	WHERE allianceid1=r_user.alliance_id;

	IF c >= 15 THEN

		RETURN 5;

	END IF;

	SELECT INTO c count(*)

	FROM gm_alliance_naps

	WHERE allianceid2=fromaid;

	IF c >= 15 THEN

		RETURN 5;

	END IF;

	INSERT INTO gm_alliance_naps(allianceid1, allianceid2, break_interval)

	VALUES(r_user.alliance_id, fromaid, offer.break_interval);

	INSERT INTO gm_alliance_naps(allianceid1, allianceid2, break_interval)

	VALUES(fromaid, r_user.alliance_id, offer.break_interval);

	DELETE FROM gm_alliance_nap_offers

	WHERE allianceid=fromaid AND targetallianceid=r_user.alliance_id;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_offer_accept(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_nap_offer_cancel(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_offer_cancel(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: tag of alliance

-- Param3: hours to break the nap

DECLARE

	r_user record;

	invitedallianceid int4;

BEGIN

	-- check that the player $1 can request a NAP

	SELECT INTO r_user id, alliance_id

	FROM gm_profiles

	WHERE id=$1 AND (SELECT leader OR can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve id of the invited alliance

	SELECT id INTO invitedallianceid

	FROM gm_alliances

	WHERE upper(tag)=upper($2);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF r_user.alliance_id = invitedallianceid THEN

		RETURN 2;

	END IF;

	DELETE FROM gm_alliance_nap_offers WHERE allianceid=r_user.alliance_id AND targetallianceid=invitedallianceid;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_offer_cancel(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_nap_offer_create(integer, character varying, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_offer_create(_userid integer, _alliance_tag character varying, _hours integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: tag of alliance

-- Param3: hours to break the nap

DECLARE

	r_user record;

	invitedallianceid int4;

BEGIN

	-- check that the player $1 can request a NAP

	SELECT INTO r_user id, alliance_id

	FROM gm_profiles

	WHERE id=$1 AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve id of the invited alliance

	SELECT id INTO invitedallianceid

	FROM gm_alliances

	WHERE upper(tag)=upper($2);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF r_user.alliance_id = invitedallianceid THEN

		RETURN 2;

	END IF;

	-- check that there is not already a NAP between the 2 gm_alliances

	PERFORM 1

	FROM gm_alliance_naps

	WHERE allianceid1=invitedallianceid AND allianceid2 = r_user.alliance_id;

	IF FOUND THEN

		RETURN 3;

	END IF;

	-- check that there is not already a NAP request from the target alliance

	PERFORM 1

	FROM gm_alliance_nap_offers

	WHERE allianceid=invitedallianceid AND targetallianceid = r_user.alliance_id AND NOT declined;

	IF FOUND THEN

		RETURN 4;

	END IF;

	BEGIN

		INSERT INTO gm_alliance_nap_offers(allianceid, targetallianceid, recruiterid, break_interval)

		VALUES(r_user.alliance_id, invitedallianceid, r_user.id, GREATEST(0, LEAST(72, _hours))*INTERVAL '1 hour');

		RETURN 0;

	EXCEPTION

		WHEN FOREIGN_KEY_VIOLATION THEN

			RETURN 5;

		WHEN UNIQUE_VIOLATION THEN

			RETURN 6;

	END;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_offer_create(_userid integer, _alliance_tag character varying, _hours integer) OWNER TO exileng;

--
-- Name: user_alliance_nap_offer_decline(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_offer_decline(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	aid int4;

	fromaid int4;

	aguarantee int4;

BEGIN

	-- find the alliance id of the user and check if he can decline NAPs on behalf of his alliance

	SELECT INTO aid

		alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to accept the NAP

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO fromaid

		id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	-- update the NAP request from "fromaid" and "aid"

	UPDATE gm_alliance_nap_offers SET

		declined=true,

		replied=now()

	WHERE allianceid=fromaid AND targetallianceid=aid AND NOT declined;

	IF NOT FOUND THEN

		-- no requests issued from the named alliance $2

		RETURN 3;

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_offer_decline(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_nap_toggle_loc_sharing(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_toggle_loc_sharing(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: tag of target alliance

DECLARE

	user record;

	targetallianceid int4;

BEGIN

	-- check that the player $1 can request a NAP

	SELECT INTO user id, alliance_id

	FROM gm_profiles

	WHERE id=$1 AND (SELECT leader OR can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve id of the target alliance

	SELECT INTO targetallianceid

		id

	FROM gm_alliances

	WHERE upper(tag)=upper($2);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF user.alliance_id = targetallianceid THEN

		RETURN 2;

	END IF;

	UPDATE gm_alliance_naps SET

		share_locs = NOT share_locs

	WHERE allianceid1=user.alliance_id AND allianceid2=targetallianceid;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_toggle_loc_sharing(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_nap_toggle_radar_sharing(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_nap_toggle_radar_sharing(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: tag of target alliance

DECLARE

	user record;

	targetallianceid int4;

BEGIN

	-- check that the player $1 can request a NAP

	SELECT INTO user id, alliance_id

	FROM gm_profiles

	WHERE id=$1 AND (SELECT leader OR can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve id of the target alliance

	SELECT INTO targetallianceid

		id

	FROM gm_alliances

	WHERE upper(tag)=upper($2);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF user.alliance_id = targetallianceid THEN

		RETURN 2;

	END IF;

	UPDATE gm_alliance_naps SET

		share_radars = NOT share_radars

	WHERE allianceid1=user.alliance_id AND allianceid2=targetallianceid;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_nap_toggle_radar_sharing(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_set_tax(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_set_tax(_userid integer, _new_tax integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: Tax rates for 1000 credits (eg. 200 for 1000 = 2% tax rates)

DECLARE

	r_user record;

	r_alliance record;

BEGIN

	-- check tax limits

	IF ($2 < 0) OR ($2 > 100) OR ($2 % 5 <> 0) THEN

		RETURN 2;

	END IF;

	-- find the alliance id of the user and check if he can accept NAPs for his alliance

	SELECT INTO r_user

		login, alliance_id

	FROM gm_profiles

	WHERE id=$1 AND (SELECT can_change_tax_rate FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to set the tax rates

		RETURN 1;

	END IF;

	SELECT INTO r_alliance

		id, tax

	FROM gm_alliances

	WHERE id=r_user.alliance_id;

	UPDATE gm_alliances SET

		tax=_new_tax

	WHERE id=r_user.alliance_id AND tax <> _new_tax;

	IF FOUND THEN

		INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, destination, type)

		VALUES(r_user.alliance_id, $1, 0, _new_tax, r_user.login, 4);

		INSERT INTO gm_alliance_reports(ownerallianceid, ownerid, type, subtype, data)

		VALUES(r_user.alliance_id, _userid, 1, 33, '{from:' || r_alliance.tax/10.0 || ',to:' || _new_tax/10.0 || ',by:' || tool_quote(r_user.login) || '}');

		INSERT INTO gm_profile_reports(ownerid, type, subtype, data)

		SELECT id, 1, 33, '{from:' || r_alliance.tax/10.0 || ',to:' || _new_tax/10.0 || ',by:' || tool_quote(r_user.login) || '}' FROM gm_profiles WHERE alliance_id=r_alliance.id;

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_alliance_set_tax(_userid integer, _new_tax integer) OWNER TO exileng;

--
-- Name: user_alliance_tribute_cancel(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_tribute_cancel(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	aid int4;

	targetaid int4;

	aguarantee int4;

BEGIN

	-- find the alliance id of the user and check if he can cease wars for his alliance

	SELECT INTO aid alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_break_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to cease the war

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO targetaid id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	DELETE FROM gm_alliance_tributes

	WHERE allianceid=aid AND target_allianceid=targetaid;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_tribute_cancel(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_tribute_create(integer, character varying, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_tribute_create(_userid integer, _alliance_tag character varying, _credits integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	aid int4;

	targetaid int4;

	aguarantee int4;

BEGIN

	IF _credits <= 0 THEN

		RETURN 1;

	END IF;

	-- find the alliance id of the user and check if he can create NAPs for his alliance

	SELECT INTO aid alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to declare war

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO targetaid

		id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	PERFORM 1

	FROM gm_profiles

		INNER JOIN gm_planets ON (gm_planets.ownerid = gm_profiles.id)

		INNER JOIN gm_galaxies ON (gm_galaxies.id = gm_planets.galaxy)

	WHERE alliance_id = targetaid AND protected_until > now();

	IF FOUND THEN

		-- target alliance only has protected planets

		-- check that the alliance setting up the tribute is in the same galaxy

		PERFORM 1

		FROM gm_planets n1

			INNER JOIN gm_profiles u1 ON (u1.id = n1.ownerid)

		WHERE u1.alliance_id=aid AND n1.galaxy IN (SELECT DISTINCT galaxy 

								FROM gm_planets

									INNER JOIN gm_profiles ON (gm_profiles.id=gm_planets.ownerid)

								WHERE gm_profiles.alliance_id=targetaid)

		LIMIT 1;

		IF NOT FOUND THEN

			RETURN 4;

		END IF;

	END IF;

	PERFORM 1

	FROM gm_alliance_tributes

	WHERE allianceid=aid AND target_allianceid=targetaid;

	IF FOUND THEN

		RETURN 3;

	END IF;

	INSERT INTO gm_alliance_tributes(allianceid, target_allianceid, credits)

	VALUES(aid, targetaid, _credits);

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_tribute_create(_userid integer, _alliance_tag character varying, _credits integer) OWNER TO exileng;

--
-- Name: user_alliance_war_create(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_war_create(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	r_user record;

	r_target record;

	result int4;

BEGIN

	-- find the alliance id of the user and check if he can declare wars for his alliance

	SELECT INTO r_user

		id, privilege, alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to declare war

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO r_target id, tag

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	IF r_target.id = r_user.alliance_id THEN

		RETURN 2;

	END IF;

	PERFORM 1

	FROM gm_alliance_naps

	WHERE (allianceid1=r_user.alliance_id AND allianceid2=r_target.id) OR (allianceid1=r_target.id AND allianceid2=r_user.alliance_id);

	IF FOUND THEN

		-- there is a nap between the gm_alliances

		RETURN 4;

	END IF;

	PERFORM 1

	FROM gm_alliance_wars

	WHERE (allianceid1=r_user.alliance_id AND allianceid2=r_target.id) OR (allianceid2=r_user.alliance_id AND allianceid1=r_target.id);

	IF FOUND THEN

		RETURN 3;

	END IF;

	IF r_user.privilege > -100 THEN

		INSERT INTO gm_alliance_wars(allianceid1, allianceid2, can_fight)

		VALUES(r_user.alliance_id, r_target.id, now()/* + (SELECT count(1) FROM gm_profiles WHERE alliance_id=r_target.id) * INTERVAL '1 hour'*/);

		-- pay bill now

		result := user_alliance_war_extend(_userid, r_target.tag);

		IF result <> 0 THEN

			-- if bill could not be paid, remove the war

			DELETE FROM gm_alliance_wars WHERE allianceid1=r_user.alliance_id AND allianceid2=r_target.id;

			RETURN result;

		END IF;

	ELSE

		-- declare npc war

		INSERT INTO gm_alliance_wars(allianceid1, allianceid2, next_bill, can_fight)

		VALUES(r_user.alliance_id, r_target.id, null, now());

	END IF;

	-- warn the target alliance leaders that this alliance declared the war

	INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid)

	SELECT id, 1, 60, r_user.alliance_id

	FROM gm_profiles

		INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

	WHERE alliance_id=r_target.id AND (r.leader OR r.can_create_nap);

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_war_create(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_war_extend(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_war_extend(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	aid int4;

	r_target record;

	aguarantee int4;

	war_cost int4;

BEGIN

	-- find the alliance id of the user and check if he can pay wars for his alliance

	SELECT INTO aid alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_create_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to pay the war

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO r_target id, tag, name

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	PERFORM 1 FROM gm_alliance_wars WHERE allianceid1=aid AND allianceid2=r_target.id AND next_bill < now() + INTERVAL '1 week';

	IF NOT FOUND THEN

		-- prevent paying more than 1 week

		RETURN 1;

	END IF;

	BEGIN

		war_cost := internal_alliance_get_war_cost(r_target.id);

		UPDATE gm_alliances SET credits=credits-war_cost WHERE id=aid AND credits >= war_cost;

		IF FOUND THEN

			UPDATE gm_alliance_wars SET next_bill=next_bill+INTERVAL '1 week' WHERE allianceid1=aid AND allianceid2=r_target.id;

			INSERT INTO gm_alliance_wallet_logs(allianceid, userid, credits, description, source, type)

			VALUES(aid, _userid, -war_cost, '', r_target.name, 12);

		ELSE

			RETURN 9;

		END IF;

	EXCEPTION

		WHEN RAISE_EXCEPTION THEN

			RETURN 1;

	END;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_war_extend(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_alliance_war_stop(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_alliance_war_stop(_userid integer, _alliance_tag character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	aid int4;

	targetaid int4;

	aguarantee int4;

BEGIN

	-- find the alliance id of the user and check if he can stop wars for his alliance

	SELECT INTO aid alliance_id

	FROM gm_profiles

	WHERE id=_userid AND (SELECT can_break_nap FROM gm_alliance_ranks WHERE allianceid=alliance_id AND rankid=alliance_rank);

	IF NOT FOUND THEN

		-- user not found or doesn't have the rights to stop the war

		RETURN 1;

	END IF;

	-- find the alliance id for the given tag

	SELECT INTO targetaid id

	FROM gm_alliances

	WHERE upper(tag)=upper(_alliance_tag);

	IF NOT FOUND THEN

		-- alliance tag not found

		RETURN 2;

	END IF;

	DELETE FROM gm_alliance_wars WHERE allianceid1=aid AND allianceid2=targetaid;

	IF FOUND THEN

		-- warn the user alliance leaders that he stopped the war

		INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid, userid)

		SELECT id, 1, 63, targetaid, _userid

		FROM gm_profiles

			INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

		WHERE alliance_id=aid AND (r.leader OR r.can_create_nap);	

		-- warn the target alliance leaders that this alliance stopped the war

		INSERT INTO gm_profile_reports(ownerid, type, subtype, allianceid)

		SELECT id, 1, 62, aid

		FROM gm_profiles

			INNER JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

		WHERE alliance_id=targetaid AND (r.leader OR r.can_create_nap);	

	END IF;

	RETURN 0;

END;$$;


ALTER FUNCTION ng03.user_alliance_war_stop(_userid integer, _alliance_tag character varying) OWNER TO exileng;

--
-- Name: user_chat_join(character varying, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_chat_join(_name character varying, _password character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE

	r_chat record;

	chatid int4;

BEGIN

	SELECT INTO r_chat id, name, password

	FROM gm_chats

	WHERE upper(name)=upper(_name);

	IF NOT FOUND THEN

		chatid := nextval('gm_chats_id_seq');

		INSERT INTO gm_chats(id, name, password) VALUES(chatid, _name, _password);

		RETURN chatid;

	ELSE

		IF r_chat.id < 0 THEN

			RETURN -1;

		END IF;

		IF r_chat.password <> '' AND r_chat.password <> _password THEN

			RETURN -2;

		END IF;

	END IF;

	RETURN r_chat.id;

END;$$;


ALTER FUNCTION ng03.user_chat_join(_name character varying, _password character varying) OWNER TO exileng;

--
-- Name: user_commander_assign(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_commander_assign(integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- param1: UserId

-- param2: CommanderId

-- param3: planetid

-- param4: fleetid

BEGIN

	-- check that the commander belongs to the player

	PERFORM id FROM gm_commanders WHERE ownerid=$1 AND id=$2 AND recruited <= now();

	IF NOT FOUND THEN

		RETURN 1;	-- commander not found

	END IF;

	IF $3 IS NOT NULL AND $4 IS NOT NULL THEN

		RETURN 2;

	END IF;

	-- remove the commander from any planets

	UPDATE gm_planets SET

		commanderid=null

	WHERE commanderid=$2;

	-- remove the commander from any gm_fleets

	UPDATE gm_fleets SET

		commanderid=null

	WHERE commanderid=$2 AND action=0 AND NOT engaged;

	PERFORM id FROM gm_fleets WHERE commanderid=$2;

	IF FOUND THEN

		RAISE EXCEPTION 'comander busy in a fleet';

	END IF;

	-- assign new planet

	IF $3 IS NOT NULL THEN

		UPDATE gm_planets SET

			commanderid=$2

		WHERE ownerid=$1 AND id=$3;

	END IF;

	-- assign new fleet

	IF $4 IS NOT NULL THEN

		UPDATE gm_fleets SET

			commanderid=$2

		WHERE ownerid=$1 AND id=$4;

	END IF;

	-- update the gm_fleets of the player

	PERFORM internal_fleet_update_bonuses(id)

	FROM gm_fleets

	WHERE ownerid=$1;

	RETURN 0;

EXCEPTION

	WHEN CHECK_VIOLATION THEN

		RETURN 3;

	WHEN RAISE_EXCEPTION THEN

		-- a commander is currently busy and can't be changed

		RETURN 4;

END;$_$;


ALTER FUNCTION ng03.user_commander_assign(integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_commander_engage(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_commander_engage(_userid integer, _commanderid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	commanders_max int2;

	commanders_engaged int2;

BEGIN

	-- retrieve max gm_commanders

	SELECT INTO commanders_max

		mod_commanders

	FROM gm_profiles

	WHERE id=_userid;

	IF NOT FOUND THEN

		RETURN 2;	-- player doesn't exist ?

	END IF;

	-- retrieve number of gm_commanders working for the player

	SELECT INTO commanders_engaged

		int2(count(*))

	FROM gm_commanders

	WHERE ownerid=_userid AND recruited <= now();

	IF commanders_engaged >= commanders_max THEN

		RETURN 3;	-- max gm_commanders reached

	END IF;

	UPDATE gm_commanders SET recruited=now() WHERE ownerid=_userid AND id=_commanderid AND recruited IS NULL;

	IF FOUND THEN

		-- pay the commander

		UPDATE gm_profiles SET credits=credits-(SELECT salary FROM gm_commanders WHERE ownerid=_userid AND id=_commanderid) WHERE id=_userid;

		RETURN 0;	-- ok

	ELSE

		RETURN 1;	-- commander not found

	END IF;

END;$$;


ALTER FUNCTION ng03.user_commander_engage(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: user_commander_fire(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_commander_fire(_userid integer, _commanderid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$BEGIN

	DELETE FROM gm_commanders WHERE can_be_fired AND ownerid=_userid AND id=_commanderid AND recruited <= now();

	UPDATE gm_profiles SET commanders_loyalty = commanders_loyalty - 30 WHERE id=_userid;

	IF FOUND THEN

		RETURN 0;

	ELSE

		RETURN 1;

	END IF;

END;$$;


ALTER FUNCTION ng03.user_commander_fire(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: user_commander_rename(integer, integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_commander_rename(_userid integer, _commanderid integer, _name character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$BEGIN

	IF char_length(_name) < 4 THEN

		RETURN 1;

	END IF;

	UPDATE gm_commanders SET name=_name WHERE ownerid=_userid AND id=_commanderid AND recruited <= now();

	IF FOUND THEN

		RETURN 0;

	ELSE

		RETURN 1;

	END IF;

END;$$;


ALTER FUNCTION ng03.user_commander_rename(_userid integer, _commanderid integer, _name character varying) OWNER TO exileng;

--
-- Name: user_commander_train(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_commander_train(_userid integer, _commanderid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$DECLARE

	prestige int;

BEGIN

	-- check commander can be trained

	PERFORM 1 FROM gm_commanders WHERE ownerid=_userid AND id=_commanderid AND last_training <= now()-interval '1 day';

	IF NOT FOUND THEN

		RETURN false;

	END IF;

	-- retrieve training cost

	prestige := internal_commander_get_prestige_cost_to_train(_userid, _commanderid);

	-- remove prestige points

	UPDATE gm_profiles SET prestige_points = prestige_points - prestige WHERE id=_userid AND prestige_points >= prestige;

	IF NOT FOUND THEN

		RETURN false;

	END IF;

	-- promote

	UPDATE gm_commanders SET last_training=now() WHERE ownerid=_userid AND id=_commanderid AND last_training <= now()-interval '1 day' AND salary_increases < 20;

	IF FOUND THEN

		RETURN internal_commander_promote(_userid, _commanderid);

	ELSE

		RETURN false;

	END IF;

END;$$;


ALTER FUNCTION ng03.user_commander_train(_userid integer, _commanderid integer) OWNER TO exileng;

--
-- Name: user_fleet_cancel_moving(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_cancel_moving(integer, integer) RETURNS void
    LANGUAGE sql
    AS $_$-- Param1: UserId

-- Param2: FleetId

UPDATE gm_fleets SET

	planetid=dest_planetid,

	dest_planetid=planetid,

	action_start_time = now()-(action_end_time-now()),

	action_end_time = now()+(now()-action_start_time),

	action = -1,

	next_waypointid = null

WHERE ownerid=$1 AND id=$2 AND action=1 AND not engaged AND planetid IS NOT NULL AND int4(date_part('epoch', now()-action_start_time)) < GREATEST(100/(speed*mod_speed/100.0)*3600, 120);$_$;


ALTER FUNCTION ng03.user_fleet_cancel_moving(integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_cancel_moving(integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_cancel_moving(integer, integer, boolean) RETURNS void
    LANGUAGE sql
    AS $_$-- Param1: UserId

-- Param2: FleetId

-- Param3: Force the fleet to come back even if can't be called back normally

UPDATE gm_fleets SET

	planetid=dest_planetid,

	dest_planetid=planetid,

	action_start_time = now()-(action_end_time-now()),

	action_end_time = now()+(now()-action_start_time),

	action = -1,

	next_waypointid = null

WHERE ownerid=$1 AND id=$2 AND action=1 AND not engaged AND planetid IS NOT NULL AND ($3 OR int4(date_part('epoch', now()-action_start_time)) < GREATEST(100/(speed*mod_speed/100.0)*3600, 120));$_$;


ALTER FUNCTION ng03.user_fleet_cancel_moving(integer, integer, boolean) OWNER TO exileng;

--
-- Name: user_fleet_cancel_recycling(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_cancel_recycling(integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: FleetId

BEGIN

	UPDATE gm_fleets SET

		action_start_time = NULL,

		action_end_time = NULL,

		action = 0,

		next_waypointid = NULL

	WHERE ownerid=$1 AND id=$2 AND action=2;

	-- update recycler percent of all remaining gm_fleets recycling

	IF FOUND THEN

		PERFORM internal_planet_update_orbitting_fleets_recycling_percent((SELECT planetid FROM gm_fleets WHERE ownerid=$1 AND id=$2));

	END IF;

	RETURN;

END;$_$;


ALTER FUNCTION ng03.user_fleet_cancel_recycling(integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_cancel_waiting(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_cancel_waiting(_ownerid integer, _fleetid integer) RETURNS void
    LANGUAGE sql
    AS $_$-- user_fleet_cancel_waiting

UPDATE gm_fleets SET

	action_start_time = NULL,

	action_end_time = NULL,

	action = 0,

	next_waypointid = NULL

WHERE ownerid=$1 AND id=$2 AND action=4;$_$;


ALTER FUNCTION ng03.user_fleet_cancel_waiting(_ownerid integer, _fleetid integer) OWNER TO exileng;

--
-- Name: user_fleet_category_assign(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_category_assign(_userid integer, _fleetid integer, _oldcategoryid integer, _newcategoryid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN

	UPDATE gm_fleets SET categoryid=$4 WHERE ownerid=$1 AND id=$2 AND categoryid=$3;

	RETURN FOUND;

END;$_$;


ALTER FUNCTION ng03.user_fleet_category_assign(_userid integer, _fleetid integer, _oldcategoryid integer, _newcategoryid integer) OWNER TO exileng;

--
-- Name: user_fleet_category_create(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_category_create(_userid integer, _label character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	cat smallint;

BEGIN

	-- retrieve the new category id

	SELECT INTO cat COALESCE(max(category)+1, 1) FROM gm_profile_fleet_categories WHERE userid=$1;

	INSERT INTO gm_profile_fleet_categories(userid, category, label)

	VALUES($1, cat, $2);

	RETURN cat;

END;$_$;


ALTER FUNCTION ng03.user_fleet_category_create(_userid integer, _label character varying) OWNER TO exileng;

--
-- Name: user_fleet_category_delete(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_category_delete(_userid integer, _categoryid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN

	DELETE FROM gm_profile_fleet_categories WHERE userid=$1 AND category=$2;

	RETURN FOUND;

END;$_$;


ALTER FUNCTION ng03.user_fleet_category_delete(_userid integer, _categoryid integer) OWNER TO exileng;

--
-- Name: user_fleet_category_rename(integer, integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_category_rename(_userid integer, _categoryid integer, _label character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN

	UPDATE gm_profile_fleet_categories SET label=$3 WHERE userid=$1 AND category=$2;

	RETURN FOUND;

END;$_$;


ALTER FUNCTION ng03.user_fleet_category_rename(_userid integer, _categoryid integer, _label character varying) OWNER TO exileng;

--
-- Name: user_fleet_create(integer, integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_create(integer, integer, character varying) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$-- Create a new fleet, it is possible to create a fleet anywhere

-- Param1: owner id

-- Param2: planet id

-- Param3: fleet name

DECLARE

	fleet_id int4;

BEGIN

	fleet_id := nextval('gm_fleets_id_seq');

	PERFORM 1

	FROM gm_fleets

	WHERE ownerid=$1

	HAVING count(*) > (SELECT mod_fleets FROM gm_profiles WHERE id=$1);

	IF FOUND THEN

		RETURN -3;

	END IF;

	INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since)

	VALUES(fleet_id, $1, $2, $3, now());

	PERFORM internal_fleet_update_bonuses(fleet_id);

	RETURN fleet_id;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN -1;

	WHEN UNIQUE_VIOLATION THEN

		RETURN -2;

END;$_$;


ALTER FUNCTION ng03.user_fleet_create(integer, integer, character varying) OWNER TO exileng;

--
-- Name: user_fleet_create(integer, integer, character varying, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_create(integer, integer, character varying, boolean) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$-- Create a new fleet, it is possible to create a fleet anywhere

-- Param1: owner id

-- Param2: planet id

-- Param3: fleet name

-- Param4: bypass fleet count limitation

DECLARE

	fleet_id int4;

BEGIN

	fleet_id := nextval('gm_fleets_id_seq');

	IF NOT $4 THEN

		PERFORM 1

		FROM gm_fleets

		WHERE ownerid=$1

		HAVING count(*) > (SELECT mod_fleets FROM gm_profiles WHERE id=$1);

		IF FOUND THEN

			RETURN -3;

		END IF;

	END IF;

	INSERT INTO gm_fleets(id, ownerid, planetid, name, idle_since)

	VALUES(fleet_id, $1, $2, $3, now());

	PERFORM internal_fleet_update_bonuses(fleet_id);

	RETURN fleet_id;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN -1;

	WHEN UNIQUE_VIOLATION THEN

		RETURN -2;

END;$_$;


ALTER FUNCTION ng03.user_fleet_create(integer, integer, character varying, boolean) OWNER TO exileng;

--
-- Name: user_fleet_deploy(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_deploy(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: Userid

-- Param2: Fleetid

-- Param3: Shipid

DECLARE

	fleet_planetid int4;

	ship_building record;

	r_planet record;

	r_user record;

	x float;

	maxcolonizations bool;

BEGIN

	maxcolonizations := false;

	-- check that the fleet belongs to the given user and retrieve the planetid where the fleet is

	SELECT planetid INTO fleet_planetid 

	FROM gm_fleets 

	WHERE ownerid=$1 AND id=$2 AND NOT engaged AND dest_planetid IS NULL LIMIT 1;

	IF NOT FOUND THEN

		-- doesn't exist, engaged, dest_planet is not null (moving) or doesn't belong to the user

		RETURN -1;

	END IF;

	-- check that the ship exists in the given fleet and retrieve the buildingid and crew

	SELECT INTO ship_building buildingid AS id, dt_ships.crew, dt_buildings.lifetime

	FROM gm_fleet_ships

		INNER JOIN dt_ships ON (gm_fleet_ships.shipid = dt_ships.id)

		INNER JOIN dt_buildings ON (dt_ships.buildingid = dt_buildings.id)

	WHERE fleetid=$2 AND shipid=$3;

	IF NOT FOUND THEN

		RETURN -2;

	END IF;

	-- check that the planet where the fleet is, belongs to the given user or to nobody

	SELECT INTO r_planet id, ownerid, planet_floor, planet_space, vortex_strength FROM gm_planets WHERE id=fleet_planetid;

	IF NOT (FOUND AND (r_planet.ownerid IS NULL OR r_planet.ownerid=$1 OR internal_profile_get_relation(r_planet.ownerid, $1) >= -1)) THEN

--	IF NOT (FOUND AND (r_planet.ownerid IS NULL OR r_planet.ownerid=$1 OR sp_is_ally(r_planet.ownerid, $1))) THEN

		-- forbidden to install on this planet

		RETURN -3;

	END IF;

	-- forbid to install buildings with a lifetime on a real planet that is not owned by someone

	IF ship_building.lifetime > 0 AND r_planet.ownerid IS NULL AND (r_planet.planet_floor > 0 OR r_planet.planet_space > 0) THEN

		-- forbidden to install on this planet

		RETURN -3;

	END IF;

	IF internal_planet_can_build_on(fleet_planetid, ship_building.id, COALESCE(r_planet.ownerid, $1)) <> 0 /*OR r_planet.vortex_strength > 5*/ THEN

		-- max buildings reached or requirements not met

		RETURN -5;

	END IF;

	-- check if can colonize planet only if floor > 0 and space > 0 (if floor = 0 and space = 0 then it is not counted as a planet)

	IF r_planet.ownerid IS NULL AND r_planet.planet_floor > 0 AND r_planet.planet_space > 0 THEN

		PERFORM 1 FROM gm_profiles WHERE id=$1 AND planets < max_colonizable_planets AND planets < mod_planets;

		IF NOT FOUND THEN

			-- player has too many planets

			RETURN -7;

		END IF;

		-- check if there are enemy gm_fleets nearby

		PERFORM 1 FROM gm_fleets WHERE planetid=fleet_planetid AND firepower > 0 AND internal_profile_get_relation(ownerid, $1) < -1 AND action <> -1 AND action <> 1;

		IF FOUND THEN

			RETURN -8;

		END IF;

	END IF;

	-- verifications ok, start building

	BEGIN

		-- set the player as the owner

		UPDATE gm_planets SET

			name=internal_profile_get_name($1),

			ownerid = $1,

			recruit_workers=true,

			mood = 100

		WHERE id=fleet_planetid AND ownerid IS NULL;

		IF NOT FOUND THEN

			-- planet already belongs to the player, try to unload the crew

		ELSE

			maxcolonizations := true;

			UPDATE gm_profiles SET remaining_colonizations=remaining_colonizations-1 WHERE id=$1;

			maxcolonizations := false;

		END IF;

		IF ship_building.lifetime > 0 THEN

			UPDATE gm_planet_buildings SET

				destroy_datetime = now()+ship_building.lifetime*INTERVAL '1 second'

			WHERE planetid=r_planet.id AND buildingid = ship_building.id;

			IF NOT FOUND THEN

				INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

				VALUES(fleet_planetid, ship_building.id, 1, now()+ship_building.lifetime*INTERVAL '1 second');

			END IF;

		ELSE

			-- insert the deployed building on the planet

			INSERT INTO gm_planet_buildings(planetid, buildingid, quantity)

			VALUES(fleet_planetid, ship_building.id, 1);

			PERFORM internal_planet_update_data(fleet_planetid);

			-- add the ship crew to the planet workers

			UPDATE gm_planets SET

				workers = LEAST(workers_capacity, workers+ship_building.crew)

			WHERE id=fleet_planetid;

		END IF;

		PERFORM internal_planet_update_data(fleet_planetid);

		UPDATE gm_fleet_ships SET

			quantity = quantity - 1

		WHERE fleetid=$2 AND shipid=$3;

		RETURN fleet_planetid;

	EXCEPTION

		-- check violation in case not enough resources, money or space/floor

		WHEN CHECK_VIOLATION THEN

			IF maxcolonizations THEN

				RETURN -7;

			ELSE

				RETURN -4;

			END IF;

		-- raised exception when building/research not met or maximum reached

		WHEN RAISE_EXCEPTION THEN

			RETURN -5;

		-- already building this type of building

		WHEN UNIQUE_VIOLATION THEN

			RETURN -6;

	END;

END;$_$;


ALTER FUNCTION ng03.user_fleet_deploy(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_invade(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_invade(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: FleetId

-- Param3: Number of drop pods

DECLARE

	r_fleet record;

	r_planet record;

	can_take_planet bool;

	lost int4;

	def_lost int4;

	r_lost_ship record;

	lost_droppods int4;

	result invasion_result;

	invasion_id int4;

	_data character varying;

BEGIN

	lost_droppods := 0;

	result.result := 0;

	result.soldiers_total := 0;

	result.soldiers_lost := 0;

	result.def_soldiers_total := -1;

	result.def_soldiers_lost := 0;

	result.def_scientists_total := -1;

	result.def_scientists_lost := 0;

	result.def_workers_total := -1;

	result.def_workers_lost := 0;

	IF $3 <= 0 THEN

		result.result := -1;

		RETURN -1;

	END IF;

	-- retrieve fleet info and the fleet cargo

	SELECT INTO r_fleet

		id, name,

		planetid,

		LEAST(LEAST(cargo_soldiers, $3), droppods) AS soldiers

	FROM gm_fleets

	WHERE ownerid=$1 AND id=$2 AND dest_planetid IS NULL AND not engaged AND now()-idle_since > static_planet_invasion_delay() FOR UPDATE;

	IF NOT FOUND THEN

		-- can't invade : fleet either moving or fleet not found

		result.result := -2;

		RETURN -2;

	END IF;

	-- check if there are enemy gm_fleets nearby

	PERFORM 1 FROM gm_fleets WHERE planetid=r_fleet.planetid AND firepower > 0 AND internal_profile_get_relation(ownerid, $1) < 0 AND action <> -1 AND action <> 1;

	IF FOUND THEN

		RETURN -5;

	END IF;

	IF r_fleet.soldiers <= 0 THEN

		result.result := -1;

		RETURN -1;

	END IF;

	PERFORM internal_planet_update_data(r_fleet.planetid);

	-- check the planet relation with the owner of the fleet

	SELECT INTO r_planet

		gm_planets.ownerid, gm_planets.name,

		gm_planets.scientists, gm_planets.soldiers, gm_planets.workers, gm_planets.workers_busy,

		internal_profile_get_relation($1, gm_planets.ownerid) AS relation,

		protection_enabled OR now() < protection_datetime AS is_protected,

		production_frozen,

		alliance_id

	FROM gm_planets

		INNER JOIN gm_profiles ON (gm_profiles.id = gm_planets.ownerid)

	WHERE gm_planets.id=r_fleet.planetid AND planet_floor > 0 AND planet_space > 0;

	IF NOT FOUND OR r_planet.relation = -3 OR r_planet.relation > 0 THEN

		-- can't invade : planet not found or planet is friend or neutral (uninhabited)

		result.result := -3;

		RETURN -3;

	END IF;

	IF r_planet.is_protected OR r_planet.production_frozen THEN

		-- can't invade : the player is protected for 2 weeks or the planet is frozen (holidays)

		result.result := -4;

		RETURN -4;

	END IF;

	IF r_planet.relation <> -2 AND r_planet.alliance_id IS NOT NULL THEN

		result.result := -3;

		RETURN -3;

	END IF;

	result.soldiers_total := r_fleet.soldiers;

	result.def_soldiers_total := r_planet.soldiers;

	result.def_workers_total := r_planet.workers;

	result.def_scientists_total := r_planet.scientists;

	-- start invasion

	-- remove used soldiers

	UPDATE gm_fleets SET

		cargo_soldiers = cargo_soldiers - result.soldiers_total

	WHERE ownerid=$1 AND id=$2;

	-- compute how many soldiers were shot down

	--lost_droppods

	result.soldiers_lost := lost_droppods;

	WHILE lost_droppods > 0

	LOOP

		SELECT INTO r_lost_ship

			fleetid, shipid, quantity, capacity, droppods

		FROM gm_fleet_ships

			INNER JOIN dt_ships ON (dt_ships.id = gm_fleet_ships.shipid)

		WHERE fleetid = r_fleet.id AND droppods > 0

		ORDER BY droppods;

		IF FOUND THEN

			r_lost_ship.quantity := LEAST(r_lost_ship.quantity, ceil(lost_droppods / r_lost_ship.droppods)::integer);

			PERFORM internal_fleet_destroy_ship(r_fleet.id, r_lost_ship.shipid, r_lost_ship.quantity);

		END IF;

		lost_droppods := lost_droppods - r_lost_ship.quantity * r_lost_ship.droppods;

	END LOOP;

	IF result.soldiers_lost < result.soldiers_total THEN

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_soldiers_total*8 / 4, result.soldiers_total);

		-- compute how many soldiers defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 8, result.def_soldiers_total);

		result.soldiers_lost := lost;

		result.def_soldiers_lost := def_lost;

	END IF;

	--RAISE NOTICE '% %', def_lost, lost;

	IF result.soldiers_lost < result.soldiers_total THEN

		PERFORM internal_planet_stop_all_ships(r_planet.ownerid, r_fleet.planetid);

		-- retrieve updated number of workers

		SELECT INTO r_planet

			ownerid, name,

			scientists, LEAST(workers, workers_capacity) AS workers, workers_busy

		FROM gm_planets

		WHERE id=r_fleet.planetid;

		--RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

		result.def_workers_total := r_planet.workers;

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_workers_total*2 / 4, result.soldiers_total-result.soldiers_lost);

		-- compute how many workers defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 2, result.def_workers_total);

		IF def_lost >= r_planet.workers-r_planet.workers_busy THEN

			PERFORM internal_planet_stop_all_buildings(r_planet.ownerid, r_fleet.planetid);

		END IF;

		-- retrieve updated number of workers

		SELECT INTO r_planet

			ownerid, name,

			scientists, workers, workers_busy

		FROM gm_planets

		WHERE id=r_fleet.planetid;

		--RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

		result.soldiers_lost := result.soldiers_lost + lost;

		result.def_workers_lost := def_lost;

	END IF;

	IF result.soldiers_lost < result.soldiers_total THEN

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_scientists_total*1 / 4, result.soldiers_total-result.soldiers_lost);

		-- compute how many scientists defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 1, result.def_scientists_total);

		result.soldiers_lost := result.soldiers_lost + lost;

		result.def_scientists_lost := def_lost;

	END IF;

	invasion_id := nextval('gm_invasions_id_seq');

	INSERT INTO gm_invasions(id, planet_id, planet_name, attacker_name, defender_name, attacker_succeeded, soldiers_total, soldiers_lost, def_scientists_total,

				def_scientists_lost, def_soldiers_total, def_soldiers_lost, def_workers_total, def_workers_lost)

	VALUES(invasion_id, r_fleet.planetid, r_planet.name, internal_profile_get_name($1), internal_profile_get_name(r_planet.ownerid), (result.soldiers_lost < result.soldiers_total), 

		result.soldiers_total, result.soldiers_lost, result.def_scientists_total, result.def_scientists_lost, result.def_soldiers_total, result.def_soldiers_lost, result.def_workers_total, result.def_workers_lost

		);

	--RAISE NOTICE '% % %', result.def_soldiers_lost, result.def_scientists_lost, result.def_workers_lost;

	-- update planet soldiers, scientists and workers

	UPDATE gm_planets SET

		soldiers = soldiers - result.def_soldiers_lost,

		scientists = scientists - result.def_scientists_lost,

		workers = workers - result.def_workers_lost,

		next_training_datetime = now()+INTERVAL '30 minutes'

	WHERE id=r_fleet.planetid;

	SELECT INTO can_take_planet

		planets < mod_planets

	FROM gm_profiles

	WHERE id=$1;

	SELECT INTO r_planet

		id, ownerid, galaxy, sector, planet

	FROM gm_planets

	WHERE id=r_fleet.planetid;

	_data := '{invasionid:' || invasion_id || ', planet:{id:' || r_planet.id || ',g:' || r_planet.galaxy || ',s:' || r_planet.sector || ',p:' || r_planet.planet || ',owner:' || COALESCE(tool_quote(internal_profile_get_name(r_planet.ownerid)), 'null') || '}}';

	-- planet captured only if at least 1 soldier remain

	IF result.soldiers_lost < result.soldiers_total THEN

		-- planet captured

		-- send a "planet lost" report to the defender

		INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, planetid, invasionid, data)

		VALUES(r_planet.ownerid, 2, 10, $1, r_fleet.planetid, invasion_id, _data);

		IF r_planet.ownerid > 100 THEN

			UPDATE gm_galaxies SET

				traded_ore = traded_ore + 100000,

				traded_hydrocarbon = traded_hydrocarbon + 100000

			WHERE id=r_planet.galaxy;

		END IF;

		IF NOT can_take_planet THEN

			-- give planet to lost nations directly

			UPDATE gm_planets SET

				ownerid = 2,

				recruit_workers=true

			WHERE id=r_fleet.planetid;

			-- send a "planet enemies killed" report to the attacker

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

			VALUES($1, 2, 13, r_fleet.planetid, invasion_id, _data);

		ELSE

			UPDATE gm_planets SET

				ownerid = $1,

				recruit_workers=true,

				name=internal_profile_get_name($1)

			WHERE id=r_fleet.planetid;

			-- send a "planet taken" report to the attacker

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

			VALUES($1, 2, 14, r_fleet.planetid, invasion_id, _data);

		END IF;

	ELSE

		-- send a "planet defended" report to the defender

		INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, planetid, invasionid, data)

		VALUES(r_planet.ownerid, 2, 11, $1, r_fleet.planetid, invasion_id, _data);

		-- send a "planet invasion failed" report to the attacker

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

		VALUES($1, 2, 12, r_fleet.planetid, invasion_id, _data);

	END IF;

	UPDATE gm_fleets SET

		cargo_soldiers = cargo_soldiers + result.soldiers_total - result.soldiers_lost

	WHERE ownerid=$1 AND id=$2;

	-- reset idle_since of all gm_fleets orbiting the planet

	UPDATE gm_fleets SET

		idle_since = now()

	WHERE planetid=r_fleet.planetid AND action <> -1 AND action <> 1;

	RETURN invasion_id;

END;$_$;


ALTER FUNCTION ng03.user_fleet_invade(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_invade(integer, integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_invade(integer, integer, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: FleetId

-- Param3: Number of drop pods

-- Param4: Take planet possession

DECLARE

	r_fleet record;

	r_planet record;

	can_take_planet bool;

	lost int4;

	def_lost int4;

	r_lost_ship record;

	lost_droppods int4;

	result invasion_result;

	invasion_id int4;

	_data character varying;

BEGIN

	lost_droppods := 0;

	result.result := 0;

	result.soldiers_total := 0;

	result.soldiers_lost := 0;

	result.def_soldiers_total := -1;

	result.def_soldiers_lost := 0;

	result.def_scientists_total := -1;

	result.def_scientists_lost := 0;

	result.def_workers_total := -1;

	result.def_workers_lost := 0;

	IF $3 <= 0 THEN

		result.result := -1;

		RETURN -1;

	END IF;

	-- retrieve fleet info and the fleet cargo

	SELECT INTO r_fleet

		id, name,

		planetid,

		LEAST(LEAST(cargo_soldiers, $3), droppods) AS soldiers

	FROM gm_fleets

	WHERE ownerid=$1 AND id=$2 AND dest_planetid IS NULL AND not engaged AND now()-idle_since > static_planet_invasion_delay() FOR UPDATE;

	IF NOT FOUND THEN

		-- can't invade : fleet either moving or fleet not found

		result.result := -2;

		RETURN -2;

	END IF;

	-- check if there are enemy gm_fleets nearby

	PERFORM 1 FROM gm_fleets WHERE planetid=r_fleet.planetid AND firepower > 0 AND internal_profile_get_relation(ownerid, $1) < 0 AND action <> -1 AND action <> 1;

	IF FOUND THEN

		RETURN -5;

	END IF;

	IF r_fleet.soldiers <= 0 THEN

		result.result := -1;

		RETURN -1;

	END IF;

	PERFORM internal_planet_update_data(r_fleet.planetid);

	-- check the planet relation with the owner of the fleet

	SELECT INTO r_planet

		gm_planets.ownerid, gm_planets.name,

		gm_planets.scientists, gm_planets.soldiers, gm_planets.workers, gm_planets.workers_busy,

		internal_profile_get_relation($1, gm_planets.ownerid) AS relation,

		protection_enabled OR now() < protection_datetime AS is_protected,

		production_frozen,

		alliance_id

	FROM gm_planets

		INNER JOIN gm_profiles ON (gm_profiles.id = gm_planets.ownerid)

	WHERE gm_planets.id=r_fleet.planetid AND planet_floor > 0 AND planet_space > 0;

	IF NOT FOUND OR r_planet.relation = -3 OR r_planet.relation > 0 THEN

		-- can't invade : planet not found or planet is friend or neutral (uninhabited)

		result.result := -3;

		RETURN -3;

	END IF;

	IF r_planet.is_protected OR r_planet.production_frozen THEN

		-- can't invade : the player is protected for 2 weeks or the planet is frozen (holidays)

		result.result := -4;

		RETURN -4;

	END IF;

	IF r_planet.relation <> -2 AND r_planet.alliance_id IS NOT NULL THEN

		result.result := -3;

		RETURN -3;

	END IF;

	result.soldiers_total := r_fleet.soldiers;

	result.def_soldiers_total := r_planet.soldiers;

	result.def_workers_total := r_planet.workers;

	result.def_scientists_total := r_planet.scientists;

	-- start invasion

	-- remove used soldiers

	UPDATE gm_fleets SET

		cargo_soldiers = cargo_soldiers - result.soldiers_total

	WHERE ownerid=$1 AND id=$2;

	-- compute how many soldiers were shot down

	--lost_droppods

	result.soldiers_lost := lost_droppods;

	WHILE lost_droppods > 0

	LOOP

		SELECT INTO r_lost_ship

			fleetid, shipid, quantity, capacity, droppods

		FROM gm_fleet_ships

			INNER JOIN dt_ships ON (dt_ships.id = gm_fleet_ships.shipid)

		WHERE fleetid = r_fleet.id AND droppods > 0

		ORDER BY droppods;

		IF FOUND THEN

			r_lost_ship.quantity := LEAST(r_lost_ship.quantity, ceil(lost_droppods / r_lost_ship.droppods)::integer);

			PERFORM internal_fleet_destroy_ship(r_fleet.id, r_lost_ship.shipid, r_lost_ship.quantity);

		END IF;

		lost_droppods := lost_droppods - r_lost_ship.quantity * r_lost_ship.droppods;

	END LOOP;

	IF result.soldiers_lost < result.soldiers_total THEN

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_soldiers_total*8 / 4, result.soldiers_total);

		-- compute how many soldiers defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 8, result.def_soldiers_total);

		result.soldiers_lost := lost;

		result.def_soldiers_lost := def_lost;

	END IF;

	--RAISE NOTICE '% %', def_lost, lost;

	IF result.soldiers_lost < result.soldiers_total THEN

		PERFORM internal_planet_stop_all_ships(r_planet.ownerid, r_fleet.planetid);

		-- retrieve updated number of workers

		SELECT INTO r_planet

			ownerid, name,

			scientists, LEAST(workers, workers_capacity) AS workers, workers_busy

		FROM gm_planets

		WHERE id=r_fleet.planetid;

		--RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

		result.def_workers_total := r_planet.workers;

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_workers_total*2 / 4, result.soldiers_total-result.soldiers_lost);

		-- compute how many workers defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 2, result.def_workers_total);

		IF def_lost >= r_planet.workers-r_planet.workers_busy THEN

			PERFORM internal_planet_stop_all_buildings(r_planet.ownerid, r_fleet.planetid);

		END IF;

		-- retrieve updated number of workers

		SELECT INTO r_planet

			ownerid, name,

			scientists, workers, workers_busy

		FROM gm_planets

		WHERE id=r_fleet.planetid;

		--RAISE NOTICE '% % %', r_planet.scientists, r_planet.workers, r_planet.workers_busy;

		result.soldiers_lost := result.soldiers_lost + lost;

		result.def_workers_lost := def_lost;

	END IF;

	IF result.soldiers_lost < result.soldiers_total THEN

		-- compute how many soldiers attacker lost

		lost := LEAST(result.def_scientists_total*1 / 4, result.soldiers_total-result.soldiers_lost);

		-- compute how many scientists defender lost

		def_lost := LEAST((result.soldiers_total-result.soldiers_lost)*4 / 1, result.def_scientists_total);

		result.soldiers_lost := result.soldiers_lost + lost;

		result.def_scientists_lost := def_lost;

	END IF;

	invasion_id := nextval('gm_invasions_id_seq');

	INSERT INTO gm_invasions(id, planet_id, planet_name, attacker_name, defender_name, attacker_succeeded, soldiers_total, soldiers_lost, def_scientists_total,

				def_scientists_lost, def_soldiers_total, def_soldiers_lost, def_workers_total, def_workers_lost)

	VALUES(invasion_id, r_fleet.planetid, r_planet.name, internal_profile_get_name($1), internal_profile_get_name(r_planet.ownerid), (result.soldiers_lost < result.soldiers_total), 

		result.soldiers_total, result.soldiers_lost, result.def_scientists_total, result.def_scientists_lost, result.def_soldiers_total, result.def_soldiers_lost, result.def_workers_total, result.def_workers_lost

		);

	--RAISE NOTICE '% % %', result.def_soldiers_lost, result.def_scientists_lost, result.def_workers_lost;

	-- update planet soldiers, scientists and workers

	UPDATE gm_planets SET

		soldiers = soldiers - result.def_soldiers_lost,

		scientists = scientists - result.def_scientists_lost,

		workers = workers - result.def_workers_lost,

		next_training_datetime = now()+INTERVAL '30 minutes'

	WHERE id=r_fleet.planetid;

	SELECT INTO can_take_planet

		planets < mod_planets

	FROM gm_profiles

	WHERE id=$1;

	SELECT INTO r_planet

		id, ownerid, galaxy, sector, planet

	FROM gm_planets

	WHERE id=r_fleet.planetid;

	_data := '{invasionid:' || invasion_id || ', planet:{id:' || r_planet.id || ',g:' || r_planet.galaxy || ',s:' || r_planet.sector || ',p:' || r_planet.planet || ',owner:' || COALESCE(tool_quote(internal_profile_get_name(r_planet.ownerid)), 'null') || '}}';

	-- planet captured only if at least 1 soldier remain

	IF result.soldiers_lost < result.soldiers_total THEN

		-- planet captured

		-- send a "planet lost" report to the defender

		INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, planetid, invasionid, data)

		VALUES(r_planet.ownerid, 2, 10, $1, r_fleet.planetid, invasion_id, _data);

		IF r_planet.ownerid > 100 THEN

			UPDATE gm_galaxies SET

				traded_ore = traded_ore + 100000,

				traded_hydrocarbon = traded_hydrocarbon + 100000

			WHERE id=r_planet.galaxy;

		END IF;

		IF $4 THEN

			PERFORM 1 FROM gm_profiles WHERE prestige_points >= tool_compute_prestige_cost_for_new_planet(planets) AND id=$1;

			IF NOT FOUND THEN

				can_take_planet := false;

			END IF;

		END IF;

		IF NOT can_take_planet OR NOT $4 THEN

			-- give planet to lost nations directly

			UPDATE gm_planets SET

				ownerid = 2,

				recruit_workers=true

			WHERE id=r_fleet.planetid;

			-- send a "planet enemies killed" report to the attacker

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

			VALUES($1, 2, 13, r_fleet.planetid, invasion_id, _data);

		ELSE

			UPDATE gm_profiles SET

				prestige_points = prestige_points - tool_compute_prestige_cost_for_new_planet(planets)

			WHERE id = $1;

			UPDATE gm_planets SET

				ownerid = $1,

				recruit_workers=true,

				name=internal_profile_get_name($1)

			WHERE id=r_fleet.planetid;

			-- send a "planet taken" report to the attacker

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

			VALUES($1, 2, 14, r_fleet.planetid, invasion_id, _data);

		END IF;

	ELSE

		-- send a "planet defended" report to the defender

		INSERT INTO gm_profile_reports(ownerid, type, subtype, userid, planetid, invasionid, data)

		VALUES(r_planet.ownerid, 2, 11, $1, r_fleet.planetid, invasion_id, _data);

		-- send a "planet invasion failed" report to the attacker

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, invasionid, data)

		VALUES($1, 2, 12, r_fleet.planetid, invasion_id, _data);

	END IF;

	UPDATE gm_fleets SET

		cargo_soldiers = cargo_soldiers + result.soldiers_total - result.soldiers_lost

	WHERE ownerid=$1 AND id=$2;

	-- reset idle_since of all gm_fleets orbiting the planet

	UPDATE gm_fleets SET

		idle_since = now()

	WHERE planetid=r_fleet.planetid AND action <> -1 AND action <> 1;

	RETURN invasion_id;

END;$_$;


ALTER FUNCTION ng03.user_fleet_invade(integer, integer, integer, boolean) OWNER TO exileng;

--
-- Name: user_fleet_leave(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_leave(_userid integer, _fleetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$DECLARE

	r_fleet record;

	r_ships record;

	r_user record;

BEGIN

	-- retrieve info on the fleet if it is not moving and not engaged in battle

	-- get planetid, cargo_ore and cargo_hydrocarbon

	SELECT INTO r_fleet

		planetid, cargo_ore, cargo_hydrocarbon

	FROM gm_fleets 

	WHERE id=_fleetid AND ownerid=_userid AND action=0 AND NOT engaged;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve total ore/hydrocarbon used for building the ships

	SELECT INTO r_ships

		sum(quantity*cost_ore) AS ore,

		sum(quantity*cost_hydrocarbon) AS hydrocarbon

	FROM gm_fleet_ships

		INNER JOIN dt_ships ON (id=shipid)

	WHERE fleetid=_fleetid;

	-- retrieve user recycling effectiveness

	SELECT INTO r_user

		mod_recycling

	FROM gm_profiles

	WHERE id=_userid;

	IF NOT FOUND THEN

		RETURN 2;	-- user not found ?

	END IF;

	DELETE FROM gm_fleets WHERE id=_fleetid AND ownerid=_userid;

	-- put ore/hydrocarbon into orbit

	UPDATE gm_planets SET

		orbit_ore = orbit_ore + r_ships.ore*((0.15+0.10*random()) + r_user.mod_recycling/100.0) + r_fleet.cargo_ore,

		orbit_hydrocarbon = orbit_hydrocarbon + r_ships.hydrocarbon*((0.15+0.10*random()) + r_user.mod_recycling/100.0) + r_fleet.cargo_hydrocarbon

	WHERE id=r_fleet.planetid;

	INSERT INTO gm_log_profile_actions(userid, credits_delta, fleetid)

	VALUES(_userid, 999999, $2);

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_leave(_userid integer, _fleetid integer) OWNER TO exileng;

--
-- Name: user_fleet_merge(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_merge(integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Merge the second fleet ($3) to the first one ($2)

--Param1: UserId

--Param2: FleetId 1

--Param3: FleetId 2

DECLARE

	c int4;

	r_fleet record;

BEGIN

	-- check that the 2 gm_fleets are near the same planet

	SELECT INTO r_fleet planetid FROM gm_fleets WHERE id=$2;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	PERFORM 1 FROM gm_fleets WHERE id=$3 AND planetid=r_fleet.planetid;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- check that the 2 gm_fleets belong to the same player, are not engaged and idle (action=0)

	SELECT INTO c count(*) FROM gm_fleets WHERE (id=$2 OR id=$3) AND ownerid=$1 AND action=0 AND NOT engaged;

	IF C <> 2 THEN

		RETURN 1;

	END IF;

	-- set the fleet action to 10 so no updates happen during ships transfer

	UPDATE gm_fleets SET action=10 WHERE ownerid=$1 AND (id=$2 OR id=$3);

	-- add the ships of fleet $3 to fleet $2

	INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		SELECT $2, shipid, quantity FROM gm_fleet_ships WHERE fleetid=$3;

	-- retrieve fleet $3 cargo

	SELECT INTO r_fleet

		cargo_ore, cargo_hydrocarbon, cargo_scientists, cargo_soldiers, cargo_workers, idle_since

	FROM gm_fleets

	WHERE id=$3;

	-- set the action back to 0 for the first fleet ($2)

	UPDATE gm_fleets SET action=0 WHERE ownerid=$1 AND id=$2;

	PERFORM internal_fleet_update_data($2);

	-- add the cargo of fleet $3 to fleet $2

	UPDATE gm_fleets SET

		cargo_ore = cargo_ore + r_fleet.cargo_ore,

		cargo_hydrocarbon = cargo_hydrocarbon + r_fleet.cargo_hydrocarbon,

		cargo_scientists = cargo_scientists + r_fleet.cargo_scientists,

		cargo_soldiers = cargo_soldiers + r_fleet.cargo_soldiers,

		cargo_workers = cargo_workers + r_fleet.cargo_workers,

		idle_since = GREATEST(now(), r_fleet.idle_since)

	WHERE id=$2;

	-- delete the second fleet

	DELETE FROM gm_fleets WHERE id=$3;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_merge(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_move(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_move(_user_id integer, _fleet_id integer, _planet_id integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: user id

-- Param2: fleet id

-- Param3: planet id

DECLARE

	fleet record;

	dest_planet record;

	travel_distance float;

	travel_cost int4;

	travel_time interval;

	vortex_travel_time interval;

	create_residual_vortex integer;

	jumping_sig bigint;

BEGIN

	create_residual_vortex := 0;

	IF _planet_id <= 0 THEN

		-- check planet is valid

		RETURN -1;

	END IF;

	-- get current fleet location, time of next battle and check if the fleet is ready for order

	SELECT INTO fleet

		planetid, p.galaxy, p.sector, p.planet, (p.next_battle-now()) AS nextbattle,

		f.real_signature <= f.long_distance_capacity AS long_distance_travels_ok,

		int4(f.speed*f.mod_speed/100.0) AS speed, f.real_signature, f.firepower, f.military_signature,

		p.vortex_strength, required_vortex_strength, security_level, p.floor = 0 and p.space = 0 AS is_empty

	FROM gm_fleets f

		LEFT JOIN gm_planets p ON (f.planetid = p.id)

		INNER JOIN gm_profiles ON (gm_profiles.id=f.ownerid)

	WHERE f.id=_fleet_id AND f.ownerid=$1 AND f.action=0

	FOR UPDATE OF f, gm_profiles;

	IF NOT FOUND THEN

		RETURN -1;

	END IF;

	IF fleet.speed <= 0 THEN

		RETURN -10;

	END IF;

	-- check if destination = origin planet

	IF _planet_id = fleet.planetid THEN

		RETURN -2;

	END IF;

	-- get destination planet info

	SELECT INTO dest_planet

		gm_planets.id, ownerid, galaxy, sector, planet,

		(SELECT protection_enabled OR now() < protection_datetime FROM gm_profiles WHERE id=gm_planets.ownerid) AS is_protected,

		production_frozen, gm_galaxies.visible, COALESCE(gm_galaxies.protected_until < now(), false) AS can_jump_to,

		vortex_strength, min_security_level, floor = 0 and space = 0 AS is_empty

	FROM gm_planets

		INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

	WHERE gm_planets.id = _planet_id;

	IF NOT FOUND OR (_user_id > 100 AND NOT dest_planet.visible AND dest_planet.ownerid <> _user_id) OR fleet.security_level < dest_planet.min_security_level THEN

		RETURN -3;

	END IF;

	-- In case of galaxy change, check if can jump

	-- Jump is ok if fleet is not around a planet

	IF fleet.planetid IS NOT NULL AND dest_planet.galaxy <> fleet.galaxy THEN

		-- check long distance travel is possible

		IF NOT fleet.long_distance_travels_ok THEN

			RETURN -5;

		END IF;

		-- can only jump to galaxies older than 2 months

		IF NOT dest_planet.can_jump_to THEN

			RETURN -8;

		END IF;

		IF NOT dest_planet.visible THEN

			RETURN -3;

		END IF;

		-- check the fleet jumps from an empty location or from a strong enough vortex

		/*IF NOT fleet.is_empty THEN

			RETURN -7;

		END IF;

		-- check the fleet jumps to a vortex with enough strength

		IF NOT fleet.is_empty THEN

			RETURN -9;

		END IF;*/

	END IF;

	-- can't move to a frozen planet

	IF dest_planet.production_frozen THEN

		RETURN 4;

	END IF;

	-- if player is protected, only allow player's own gm_fleets or unarmed gm_fleets of (alliance and NAP)

	IF dest_planet.is_protected AND internal_profile_get_relation(dest_planet.ownerid, _user_id) < 0 AND fleet.firepower <> 0 THEN

		RETURN -4;

	END IF;

	vortex_travel_time := GREATEST(1, fleet.required_vortex_strength) * INTERVAL '12 hours';

	IF (dest_planet.galaxy <> fleet.galaxy) THEN

		--RAISE NOTICE '1';

		-- normal inter-galaxy jump

		travel_distance := 200.0;

		travel_time := 2*vortex_travel_time;

		IF (fleet.required_vortex_strength <= 1 OR fleet.required_vortex_strength <= fleet.vortex_strength) AND fleet.required_vortex_strength <= dest_planet.vortex_strength THEN

			create_residual_vortex := fleet.planetid;

			fleet.planetid = null;

		ELSE

			-- check if fleet could jump without vortex

			SELECT INTO jumping_sig COALESCE(sum(real_signature), 0)

			FROM gm_fleets

			WHERE dest_planetid = dest_planet.id AND (SELECT galaxy FROM gm_planets WHERE gm_planets.id = gm_fleets.planetid) <> dest_planet.galaxy;

			IF NOT FOUND THEN

				jumping_sig := 0;

			END IF;

			IF fleet.real_signature > 5000 - jumping_sig THEN

				-- too many gm_fleets jumping toward the same point

				RETURN -10;

			END IF;

		END IF;

	ELSE

		--RAISE NOTICE '2';

		-- if fleet is not near a planet, set a fixed travel distance of 12 units

		IF fleet.planetid IS NULL THEN

			travel_distance := 12;

		ELSE

			travel_distance := tool_compute_distance(dest_planet.sector, dest_planet.planet, fleet.sector, fleet.planet);

		END IF;

		travel_time := travel_distance * 3600 * 1000.0/fleet.speed * INTERVAL '1 second'; -- compute travel time

	END IF;

	travel_cost := int4(floor(travel_distance/200.0*fleet.real_signature));

	-- allow to jump if has jumpers, required_vortex_strength <= 1 and out vortex is strong enough

	IF dest_planet.galaxy = fleet.galaxy AND fleet.planetid IS NOT NULL AND fleet.long_distance_travels_ok AND travel_time > vortex_travel_time AND fleet.vortex_strength >= 0 THEN

		-- jumpers capacity ok and jump shorter than default travel time

		IF fleet.required_vortex_strength <= 1 AND fleet.required_vortex_strength <= dest_planet.vortex_strength THEN

			--RAISE NOTICE '3';

			-- fleet can jump from anywhere to a vortex but create a residual vortex

			travel_cost := int4(2*fleet.real_signature);

			travel_time := vortex_travel_time;

			create_residual_vortex := fleet.planetid;

			fleet.planetid = null;

		ELSEIF fleet.required_vortex_strength <= fleet.vortex_strength AND fleet.required_vortex_strength <= dest_planet.vortex_strength THEN

			--RAISE NOTICE '4';

			travel_cost := int4(2*fleet.real_signature);

			travel_time := vortex_travel_time;		

		END IF;

		--RAISE NOTICE '5';

	END IF;

	-- create a residual vortex

	IF fleet.vortex_strength = 0 AND create_residual_vortex <> 0 THEN

		INSERT INTO gm_planet_buildings(planetid, buildingid, quantity, destroy_datetime)

		VALUES(create_residual_vortex, 603, 1, now() + INTERVAL '45 minutes');

	END IF;

	-- Pay travel

	-- free for the 100 special first players (npc)

	IF $1 > 100 THEN

		travel_cost := GREATEST(1, travel_cost);

		INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, fleetid)

		VALUES($1, -travel_cost, dest_planet.id, $2);

		UPDATE gm_profiles SET credits=credits-travel_cost WHERE id=$1;

	END IF;

	-- move fleet

	UPDATE gm_fleets SET

		dest_planetid = dest_planet.id,

		action_start_time = now(),

		action_end_time = now() + travel_time * static_time_coeff() + COALESCE(CASE WHEN engaged AND fleet.nextbattle IS NOT NULL THEN fleet.nextbattle END, INTERVAL '0 second'),

		engaged = engaged AND fleet.nextbattle IS NOT NULL,

		action = 1,

		idle_since = null,

		next_waypointid = null

	WHERE id = $2 AND ownerid=$1;

	IF NOT FOUND THEN

		RETURN -3;

	END IF;

	IF fleet.military_signature > 0 THEN

		UPDATE gm_planets SET blocus_strength = NULL WHERE id=fleet.planetid;

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_move(_user_id integer, _fleet_id integer, _planet_id integer) OWNER TO exileng;

--
-- Name: user_fleet_move(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_move(integer, integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: user id

-- Param2: fleet id

-- Param3: galaxy

-- Param4: sector

-- Param5: planet

BEGIN

	RETURN user_fleet_move($1, $2, tool_compute_planet_id($3, $4, $5));

END;$_$;


ALTER FUNCTION ng03.user_fleet_move(integer, integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_start_recycling(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_start_recycling(_userid integer, _fleetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$-- Param1: UserId

-- Param2: FleetId

DECLARE

	r_fleet record;

BEGIN

	SELECT INTO r_fleet planetid

	FROM gm_fleets

	WHERE ownerid=_userid AND id=_fleetid;

	-- check if a fleet is already recycling at the fleet position

	PERFORM 1 FROM gm_fleets

	WHERE ownerid=_userid AND action=2 AND id <> _fleetid AND planetid=r_fleet.planetid;

	IF FOUND THEN

		RETURN -2;

	END IF;

	-- make the fleet recycle

	UPDATE gm_fleets SET

		action_start_time = now(),

		action_end_time = now() + INTERVAL '10 minutes' / mod_recycling,

		action = 2

	WHERE ownerid=_userid AND id=_fleetid AND action=0 AND not engaged AND recycler_output > 0;

	IF NOT FOUND THEN

		RETURN -1;

	ELSE

		PERFORM internal_planet_update_orbitting_fleets_recycling_percent(r_fleet.planetid);

		RETURN 0;

	END IF;

END;$$;


ALTER FUNCTION ng03.user_fleet_start_recycling(_userid integer, _fleetid integer) OWNER TO exileng;

--
-- Name: user_fleet_transfer_resources(integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_transfer_resources(integer, integer, integer, integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- transfer resources between a fleet and a planet

-- if ore > 0, it means "we take from planet : load into the fleet"

-- if ore < 0, it means "we take from the fleet : unload from the fleet"

-- param1: user id

-- param2: fleet id

-- param3: ore

-- param4: hydrocarbon

-- param5: scientists

-- param6: soldiers

-- param7: workers

DECLARE

	r_fleet record;

	r_planet record;

	t_ore int4;

	t_hydrocarbon int4;

	t_scientists int4;

	t_soldiers int4;

	t_workers int4;

	remaining_space int4;

	tmp int4;

	price integer;

	cr integer;

	do_report boolean;

BEGIN

	-- retrieve fleet info, cargo and lock the fleet and the planet at the same time for update

	SELECT INTO r_fleet

		f.id, f.name, f.ownerid,

		f.planetid, internal_profile_get_relation(f.ownerid, p.ownerid) AS planet_relation,

		f.cargo_ore, f.cargo_hydrocarbon, f.cargo_scientists, f.cargo_soldiers, f.cargo_workers, f.cargo_capacity,

		COALESCE(p.buy_ore, 0) AS buy_ore,

		COALESCE(p.buy_hydrocarbon, 0) AS buy_hydrocarbon

	FROM gm_fleets AS f

		INNER JOIN gm_planets AS p ON (f.planetid=p.id)

	WHERE f.ownerid=$1 AND f.id=$2 AND f.action_end_time IS NULL AND NOT f.engaged FOR UPDATE;

	-- fleet either moving or fleet not found

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- check the planet relation with the owner of the fleet

	IF NOT FOUND OR r_fleet.planet_relation < -1 THEN

		RETURN 2;

	END IF;

	-- update planet resources before trying to add/remove any resources

	PERFORM internal_planet_update_production_date(r_fleet.planetid);

	-- retrieve the max resources that can be taken from planet

	SELECT INTO r_planet

		ownerid,

		ore, ore_capacity,

		hydrocarbon, hydrocarbon_capacity,

		scientists, scientists_capacity,

		soldiers, soldiers_capacity,

		workers-workers_busy AS workers, workers AS totalworkers, workers_capacity, workers_for_maintenance

	FROM gm_planets

	WHERE id=r_fleet.planetid FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 3;

	END IF;

	t_ore := $3;

	t_hydrocarbon := $4;

	t_scientists := $5;

	t_soldiers := $6;

	t_workers := $7;

	-- if we try to load the ship with ore/hydrocarbon, check that there are enough workers

	IF $3 > 0 OR $4 > 0 THEN

		-- check that the planet has enough workers

		PERFORM 1

		FROM vw_gm_planets

		WHERE id=r_fleet.planetid AND workers > workers_for_maintenance / 2;

		-- not found if not enough workers

		IF NOT FOUND THEN

			t_ore := LEAST(0, t_ore);

			t_hydrocarbon := LEAST(0, t_hydrocarbon);

		END IF;

	END IF;

	-- if the planet owner <> fleet owner, it is not possible to load resources (only unload)

	IF r_fleet.planet_relation < 2 THEN

		IF t_ore > 0 THEN t_ore := 0; END IF;

		IF t_hydrocarbon > 0 THEN t_hydrocarbon := 0; END IF;

		IF t_scientists > 0 THEN t_scientists := 0; END IF;

		IF t_soldiers > 0 THEN t_soldiers := 0; END IF;

		IF t_workers > 0 THEN t_workers := 0; END IF;

	END IF;

	--RAISE NOTICE 'ore: %', t_ore;

	--RAISE NOTICE 'hydro: %', t_hydrocarbon;

	-- retrieve the quantities that can be taken from either the planet or the fleet

	IF t_ore > 0 THEN

		--RAISE NOTICE 'ore(planet): %', r_planet.ore;

		t_ore := LEAST(t_ore, r_planet.ore);

	ELSE

		t_ore := -LEAST(-t_ore, r_fleet.cargo_ore);

		--RAISE NOTICE 'ore: %', t_ore;

		-- if it exceed the ore capacity, limit the quantity that will be transfered to planet

		IF r_planet.ore - t_ore > r_planet.ore_capacity THEN

			t_ore := r_planet.ore - r_planet.ore_capacity;

		END IF;

		r_fleet.cargo_ore := r_fleet.cargo_ore + t_ore;

	END IF;

	IF t_hydrocarbon > 0 THEN

		--RAISE NOTICE 'hydro(planet): %', r_planet.hydrocarbon;

		t_hydrocarbon := LEAST(t_hydrocarbon, r_planet.hydrocarbon);

	ELSE

		t_hydrocarbon := -LEAST(-t_hydrocarbon, r_fleet.cargo_hydrocarbon);

		--RAISE NOTICE 'hydro: %', t_hydrocarbon;

		-- if it exceed the hydrocarbon capacity, limit the quantity that will be transfered to planet

		IF r_planet.hydrocarbon - t_hydrocarbon > r_planet.hydrocarbon_capacity THEN

			t_hydrocarbon := r_planet.hydrocarbon - r_planet.hydrocarbon_capacity;

		END IF;

		r_fleet.cargo_hydrocarbon := r_fleet.cargo_hydrocarbon + t_hydrocarbon;

	END IF;

	IF t_scientists > 0 THEN

		t_scientists := LEAST(t_scientists, r_planet.scientists);

	ELSE

		t_scientists := -LEAST(-t_scientists, r_fleet.cargo_scientists);

		-- if it exceed the scientists capacity, limit the quantity that will be transfered to planet

		IF r_planet.scientists - t_scientists > r_planet.scientists_capacity THEN

			t_scientists := r_planet.scientists - r_planet.scientists_capacity;

		END IF;

		r_fleet.cargo_scientists := r_fleet.cargo_scientists + t_scientists;

	END IF;

	IF t_soldiers > 0 THEN

		t_soldiers := LEAST(t_soldiers, r_planet.soldiers);

	ELSE

		t_soldiers := -LEAST(-t_soldiers, r_fleet.cargo_soldiers);

		-- if it exceed the soldiers capacity, limit the quantity that will be transfered to planet

		IF r_planet.soldiers - t_soldiers > r_planet.soldiers_capacity THEN

			t_soldiers := LEAST(0, r_planet.soldiers - r_planet.soldiers_capacity);

		END IF;

		r_fleet.cargo_soldiers := r_fleet.cargo_soldiers + t_soldiers;

	END IF;

	IF t_workers > 0 THEN

		IF r_planet.totalworkers - t_workers <= r_planet.workers_for_maintenance / 2 THEN

			t_workers := GREATEST(0, r_planet.totalworkers - r_planet.workers_for_maintenance / 2 -1);

		END IF;

		t_workers := LEAST(t_workers, GREATEST(0, r_planet.workers));

	ELSE

		t_workers := -LEAST(-t_workers, r_fleet.cargo_workers);

		-- if it exceed the workers capacity, limit the quantity that will be transfered to planet

		IF r_planet.totalworkers - t_workers > r_planet.workers_capacity THEN

			t_workers := r_planet.totalworkers - r_planet.workers_capacity;

		END IF;

		r_fleet.cargo_workers := r_fleet.cargo_workers + t_workers;

	END IF;

/*

	RAISE NOTICE 'id: %', $2;

	RAISE NOTICE 'ore: %', t_ore;

	RAISE NOTICE 'hydro: %', t_hydrocarbon;

*/

	-- store in "remaining_space" the remaining capacity of the fleet

	remaining_space := r_fleet.cargo_capacity - r_fleet.cargo_ore - r_fleet.cargo_hydrocarbon - r_fleet.cargo_scientists - r_fleet.cargo_soldiers - r_fleet.cargo_workers;

	--RAISE NOTICE 'cargo space: %', r_fleet.cargo_soldiers;--remaining_space;

	-- compute the maximum resources that can be loaded according to given cargo space

	IF t_ore > remaining_space THEN

		t_ore := remaining_space;

	END IF;

	IF t_ore > 0 THEN

		remaining_space := remaining_space - t_ore;

	END IF;

	--RAISE NOTICE 'cargo space: %', remaining_space;

	IF t_hydrocarbon > remaining_space THEN

		t_hydrocarbon := remaining_space;

	END IF;

	IF t_hydrocarbon > 0 THEN

		remaining_space := remaining_space - t_hydrocarbon;

	END IF;

	--RAISE NOTICE 'cargo space: %', remaining_space;

	IF t_scientists > remaining_space THEN

		t_scientists := remaining_space;

	END IF;

	IF t_scientists > 0 THEN

		remaining_space := remaining_space - t_scientists;

	END IF;

	--RAISE NOTICE 'cargo space: %', remaining_space;

	IF t_soldiers > remaining_space THEN

		t_soldiers := remaining_space;

	END IF;

	IF t_soldiers > 0 THEN

		remaining_space := remaining_space - t_soldiers;

	END IF;

	--RAISE NOTICE 'cargo space: %', remaining_space;

	IF t_workers > remaining_space THEN

		t_workers := remaining_space;

	END IF;

	IF t_workers > 0 THEN

		remaining_space := remaining_space - t_workers;

	END IF;

	--RAISE NOTICE 'cargo space: %', remaining_space;

	IF t_ore = 0 AND t_hydrocarbon = 0 AND t_scientists = 0 AND t_soldiers = 0 AND t_workers = 0 THEN

		-- no resources to move

		RETURN 4;

	END IF;

	do_report := true;

	IF r_fleet.planet_relation < 2 AND r_planet.ownerid >= 5 AND ((r_fleet.buy_ore > 0 AND t_ore < 0) OR (r_fleet.buy_hydrocarbon > 0 AND t_hydrocarbon < 0)) THEN

		price := GREATEST(0, int4(floor(-t_ore/1000.0 * r_fleet.buy_ore - t_hydrocarbon/1000.0 * r_fleet.buy_hydrocarbon)));

		UPDATE gm_profiles SET credits=credits-price WHERE id=r_planet.ownerid AND credits >= price;

		IF NOT FOUND THEN

			RETURN 9;

		END IF;

		cr := internal_profile_apply_alliance_tax(r_fleet.ownerid, price);

		UPDATE gm_profiles SET credits=credits+cr WHERE id=r_fleet.ownerid;

		INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, credits, ore, hydrocarbon, scientists, soldiers, workers)

		VALUES(r_fleet.ownerid, 5, 4, r_fleet.planetid, price, -t_ore, -t_hydrocarbon, -t_scientists, -t_soldiers, -t_workers);

		INSERT INTO gm_profile_reports(ownerid, type, subtype, fleetid, fleet_name, planetid, ore, hydrocarbon, scientists, soldiers, workers, userid, credits)

		VALUES(r_planet.ownerid, 5, 5, r_fleet.id, r_fleet.name, r_fleet.planetid, -t_ore, -t_hydrocarbon, -t_scientists, -t_soldiers, -t_workers, $1, price);

		do_report := false;

	END IF;

	-- transfer resources on the planet

	UPDATE gm_planets SET

		ore = ore - t_ore,

		hydrocarbon = hydrocarbon - t_hydrocarbon,

		scientists = scientists - t_scientists,

		soldiers = soldiers - t_soldiers,

		workers = workers - t_workers

	WHERE id=r_fleet.planetid;

	-- transfer resources on the fleet

	UPDATE gm_fleets SET

		cargo_ore = cargo_ore + t_ore,

		cargo_hydrocarbon = cargo_hydrocarbon + t_hydrocarbon,

		cargo_scientists = cargo_scientists + t_scientists,

		cargo_soldiers = cargo_soldiers + t_soldiers,

		cargo_workers = cargo_workers + t_workers

	WHERE ownerid=$1 AND id=$2;

	IF do_report AND r_fleet.planet_relation < 2 AND (t_ore < 0 OR t_hydrocarbon < 0 OR t_scientists < 0 OR t_soldiers < 0 OR t_workers < 0) THEN

		INSERT INTO gm_profile_reports(ownerid, type, subtype, fleetid, fleet_name, planetid, ore, hydrocarbon, scientists, soldiers, workers, userid)

		VALUES(r_planet.ownerid, 5, 1, r_fleet.id, r_fleet.name, r_fleet.planetid, -t_ore, -t_hydrocarbon, -t_scientists, -t_soldiers, -t_workers, $1);

	END IF;

	PERFORM internal_planet_update_production_date(r_fleet.planetid);

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_transfer_resources(integer, integer, integer, integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_transfer_ships(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_transfer_ships(integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- transfer ships to a planet

-- param1: user id

-- param2: fleet id

-- param3: ship id

-- param4: quantity

DECLARE

	ships_quantity int4;

	planet_id int4;

BEGIN

	IF $4 <= 0 THEN

		RETURN 0;

	END IF;

	-- check the ship can be parked to planet

	/*PERFORM 1 FROM dt_ships WHERE id=$3 AND can_be_parked;

	IF NOT FOUND THEN

		RETURN 3;

	END IF;*/

	-- retrieve the planetid where the fleet is and if it is not moving and not engaged in battle

	SELECT planetid INTO planet_id 

	FROM gm_fleets 

	WHERE id=$2 AND ownerid=$1 AND action=0 AND NOT engaged;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- check that the planet belongs to the same player

	PERFORM id

	FROM gm_planets

	WHERE id=planet_id AND ownerid=$1;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve the maximum quantity of ships that can be transferred from the fleet

	SELECT INTO ships_quantity quantity 

	FROM gm_fleet_ships

	WHERE fleetid=$2 AND shipid=$3 FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- update or delete ships from fleet

	IF ships_quantity > $4 THEN

		ships_quantity := $4;

		UPDATE gm_fleet_ships SET quantity = quantity - $4 WHERE fleetid=$2 AND shipid=$3;

	ELSE

		DELETE FROM gm_fleet_ships WHERE fleetid=$2 AND shipid=$3;

	END IF;

	-- add ships to the fleet

	--UPDATE gm_fleet_ships SET quantity = quantity + ships_quantity WHERE fleetid=$2 AND shipid=$3;

	--IF NOT FOUND THEN

	INSERT INTO gm_planet_ships(planetid, shipid, quantity) VALUES(planet_id,$3,ships_quantity);

	--END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_transfer_ships(integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_fleet_warp(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_fleet_warp(integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Make a fleet use the vortex/warp gate where the fleet is

-- Param1: UserId

-- Param2: FleetId

DECLARE

	r_fleet record;

	r_planet record;

BEGIN

	-- retrieve fleet info

	SELECT INTO r_fleet

		id, name, planetid

	FROM gm_fleets

	WHERE ownerid=$1 AND id=$2 AND action=0 AND not engaged FOR UPDATE;

	IF NOT FOUND THEN

		-- can't warp : fleet either doing something or fleet not found

		RETURN 1;

	END IF;

	-- retrieve planet info

	SELECT INTO r_planet

		id, warp_to

	FROM gm_planets

	WHERE id=r_fleet.planetid AND warp_to IS NOT NULL;

	IF NOT FOUND THEN

		-- can't warp : there is no vortex/warp gate

		RETURN 2;

	END IF;

	-- make the fleet move

	UPDATE gm_fleets SET

		planetid=null,

		dest_planetid = r_planet.warp_to,

		action_start_time = now(),

		action_end_time = now() + INTERVAL '2 days',

		action = 1,

		idle_since = null

	WHERE ownerid=$1 AND id = $2 AND action=0 AND not engaged;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_fleet_warp(integer, integer) OWNER TO exileng;

--
-- Name: user_mail_ignore(integer, character varying); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_mail_ignore(_userid integer, _ignored_user character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$DECLARE

	ignored_id int4;

BEGIN

	SELECT INTO ignored_id id FROM gm_profiles WHERE upper(login)=upper(_ignored_user) AND privilege < 500;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	INSERT INTO gm_mail_ignorees(userid, ignored_userid)

	VALUES(_userid, ignored_id);

	RETURN 0;

EXCEPTION

	WHEN UNIQUE_VIOLATION THEN

		RETURN 2;

END;$$;


ALTER FUNCTION ng03.user_mail_ignore(_userid integer, _ignored_user character varying) OWNER TO exileng;

--
-- Name: user_mail_send(integer, character varying, character varying, text, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_mail_send(_senderid integer, _to character varying, _subject character varying, _body text, _credits integer, _bbcode boolean) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- user_mail_send

-- add a message to a user message list

-- param1: senderid (from)

-- param2: addressee (to)

-- param3: subject

-- param4: body

-- param5: credits

-- param6: bbcode enabled

DECLARE

	r_from record;

	r_to record;

	cr int4;

	from_name varchar;

BEGIN

	IF $5 < 0 THEN

		cr := 0;

	ELSE

		cr := $5;

	END IF;

	-- retrieve the name from who this message is sent

	SELECT INTO r_from

		login, privilege, alliance_id, alliance_rank, 

		now()-game_started > INTERVAL '2 weeks' AND security_level >= 3 AS can_sendmoney,

		r.can_mail_alliance,

		(SELECT count(DISTINCT galaxy) FROM gm_planets WHERE ownerid=gm_profiles.id) AS galaxies,

		(SELECT galaxy FROM gm_planets WHERE ownerid=gm_profiles.id LIMIT 1) AS galaxy

	FROM gm_profiles

		LEFT JOIN gm_alliance_ranks AS r ON (r.allianceid=gm_profiles.alliance_id AND r.rankid=gm_profiles.alliance_rank)

	WHERE id=$1;

	IF NOT FOUND THEN

		from_name := '';

	ELSE

		from_name := r_from.login;

		-- prevent new gm_profiles from sending money to players

		IF NOT r_from.can_sendmoney THEN

			cr := 0;

		END IF;

	END IF;

	IF $2 = ':all' AND r_from.privilege >= 500 THEN

		INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

		SELECT id, $2, null, from_name, $3, $4, $6 FROM gm_profiles WHERE privilege=0;

		-- add a "sent" message for the admin

		INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

		VALUES(null, $2, $1, from_name, $3, $4, $6);

	ELSEIF $2 = ':admins' THEN

		-- send message to admins

		INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

		SELECT id, $2, null, from_name, $3, $4, $6 FROM gm_profiles WHERE privilege >= 500 AND id <> $1;

		-- add a "sent" message

		INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

		VALUES(null, $2, $1, from_name, $3, $4, $6);

	ELSEIF $2 = ':alliance' THEN

		IF r_from.can_mail_alliance THEN

			INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

			SELECT id, $2, null, from_name, $3, $4, $6 FROM gm_profiles WHERE alliance_id = r_from.alliance_id AND id <> $1;

			-- add a "sent" message

			INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, bbcode)

			VALUES(null, $2, $1, from_name, $3, $4, $6);

		ELSE

			RETURN 10;

		END IF;

	ELSE

		-- retrieve addressee id

		SELECT INTO r_to

			id,

			login, 

			now()-game_started > INTERVAL '2 weeks' AND security_level >= 3 AS can_receivemoney,

			(SELECT count(DISTINCT galaxy) FROM gm_planets WHERE ownerid=gm_profiles.id) AS galaxies,

			(SELECT galaxy FROM gm_planets WHERE ownerid=gm_profiles.id LIMIT 1) AS galaxy

		FROM gm_profiles

		WHERE upper(login)=upper($2) AND (privilege <> -1);

		IF NOT FOUND THEN

			RETURN 2;

		END IF;

		IF cr > 0 THEN

			IF NOT r_to.can_receivemoney THEN

				cr := 0;

			ELSE

				IF r_to.galaxies = 1 AND (r_from.galaxies > 1 OR r_to.galaxy <> r_from.galaxy) THEN

					-- "to" is only on 1 galaxy and sender is either not in same galaxy or in multiple so check if "to" is in a protected galaxy

					PERFORM 1 FROM gm_galaxies WHERE id=r_to.galaxy AND protected_until > now();

					IF FOUND THEN

						cr := 0;

					END IF;

				END IF;

			END IF;

		END IF;

		-- check that we are not sending a message from and to the same person

		IF r_from.privilege < 100 AND $1 = r_to.id THEN

			RETURN 3;

		END IF;

		PERFORM 1 FROM gm_mail_ignorees WHERE userid=r_to.id AND ignored_userid=$1;

		IF FOUND THEN

			UPDATE gm_mail_ignorees SET blocked=blocked+1 WHERE userid=r_to.id AND ignored_userid=$1;

			RETURN 9; -- ignored user

		END IF;

		-- add message to gm_mails table

		INSERT INTO gm_mails(ownerid, owner, senderid, sender, subject, body, datetime, credits, bbcode)

		VALUES(r_to.id, r_to.login, $1, from_name, $3, $4, now(), cr, $6);

		-- add addressee id to gm_mail_addressees table

		IF NOT $1 IS NULL THEN

			INSERT INTO gm_mail_addressees(ownerid, addresseeid) VALUES($1, r_to.id);

		END IF;

		IF cr > 0 AND $1 IS NOT NULL THEN

			IF internal_profile_transfer_credits($1, r_to.id, cr) <> 0 THEN

				RAISE EXCEPTION 'not enough credits';

			END IF;

		END IF;

	END IF;

	RETURN 0;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN 0;

	-- check violation when sender has not enough money

	WHEN RAISE_EXCEPTION THEN

		RETURN 4;

END;$_$;


ALTER FUNCTION ng03.user_mail_send(_senderid integer, _to character varying, _subject character varying, _body text, _credits integer, _bbcode boolean) OWNER TO exileng;

--
-- Name: user_planet_building_cancel(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_building_cancel(integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- cancel the construction of a building on a planet

-- param1: user id

-- param2: planet id

-- param3: building id

DECLARE

	r_building dt_buildings;

	percent float4;

BEGIN

	-- check that the planet belongs to the user

	PERFORM id

	FROM gm_planets

	WHERE ownerid=$1 AND id=$2;

	IF NOT FOUND THEN

		RETURN 5;

	END IF;

	-- retrieve construction percentage of the building

	SELECT INTO percent COALESCE( 1.0 - date_part('epoch', now() - start_time) / date_part('epoch', end_time - start_time) / 2.0, 0)

	FROM gm_planet_building_pendings

	WHERE planetid=$2 AND buildingid=$3 FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	IF percent > 1.0 THEN

		percent := 1.0;

	ELSEIF percent < 0.5 THEN

		percent := 0.5;

	END IF;

	-- retrieve building info

	SELECT INTO r_building * FROM dt_buildings WHERE id=$3 LIMIT 1;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- delete pending building from list

	DELETE FROM gm_planet_building_pendings

	WHERE planetid=$2 AND buildingid=$3;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	PERFORM internal_planet_update_data($2);

	-- give resources back

	UPDATE gm_planets SET

		ore = ore + percent * r_building.cost_ore,

		hydrocarbon = hydrocarbon + percent * r_building.cost_hydrocarbon,

		energy = energy + percent * r_building.cost_energy

	WHERE id=$2;

	UPDATE gm_profiles SET

		credits = credits + percent * r_building.cost_credits,

		prestige_points_refund = prestige_points_refund + (0.95 * percent * r_building.cost_prestige)::integer

	WHERE id=$1;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_building_cancel(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_building_destroy(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_building_destroy(_userid integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Destroying a build is immediate but it requires that we are not already building another building

-- We also need to check that we do not try to destroy a building that other buildings depend on

-- Param1: user id

-- Param2: planet id

-- Param3: building id

DECLARE

	r_building record;

	r_planet record;

	r_user record;

	demolition_time int4;

	c int4;

BEGIN

	-- check the planet ownership and the next_building_destruction

	SELECT INTO r_planet id, workers-workers_busy AS workers, mod_construction_speed_buildings, 

		energy_receive_antennas, energy_receive_links, energy_send_antennas, energy_send_links

	FROM vw_gm_planets

	WHERE ownerid=_userid AND id=$2;-- AND next_building_destruction <= now();

	IF NOT FOUND THEN

		RETURN 5;

	END IF;

	-- check that the building can be destroyed and retrieve how much ore, hydrocarbon it costs

	SELECT INTO r_building

		cost_ore, cost_hydrocarbon, workers, construction_time, construction_time_exp_per_building,

		energy_receive_antennas, energy_send_antennas

	FROM dt_buildings

	WHERE id=$3 AND destroyable AND NOT is_planet_element

	LIMIT 1;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	IF r_building.workers / 2 > r_planet.workers THEN

		RETURN 6;

	END IF;

	-- check receive/send energy links

	IF r_planet.energy_receive_antennas - r_building.energy_receive_antennas < r_planet.energy_receive_links THEN

		RETURN 3;

	END IF;

	IF r_planet.energy_send_antennas - r_building.energy_send_antennas < r_planet.energy_send_links THEN

		RETURN 3;

	END IF;

	-- check that there are no buildings that depends on the building $3 that is going to be destroyed

	PERFORM dt_building_building_reqs.buildingid

	FROM dt_building_building_reqs 

		INNER JOIN gm_planet_buildings ON (gm_planet_buildings.planetid=$2 AND gm_planet_buildings.buildingid = dt_building_building_reqs.buildingid)

		INNER JOIN dt_buildings ON (dt_buildings.id=dt_building_building_reqs.buildingid)

	WHERE required_buildingid = $3 AND quantity > 0 AND dt_buildings.destroyable

	LIMIT 1;

	IF FOUND THEN

		RETURN 3;

	END IF;

	-- check that there are no buildings being built that requires the building we're going to destroy

	PERFORM dt_building_building_reqs.buildingid

	FROM dt_building_building_reqs 

		INNER JOIN gm_planet_building_pendings ON (gm_planet_building_pendings.planetid=$2 AND gm_planet_building_pendings.buildingid = dt_building_building_reqs.buildingid)

		INNER JOIN dt_buildings ON (dt_buildings.id=dt_building_building_reqs.buildingid)

	WHERE required_buildingid = $3 AND dt_buildings.destroyable

	LIMIT 1;

	IF FOUND THEN

		RETURN 3;

	END IF;

	SELECT INTO r_user mod_recycling FROM gm_profiles WHERE id=_userid;

	IF NOT FOUND THEN

		RETURN 5;

	END IF;

	SELECT INTO c quantity-1 FROM gm_planet_buildings WHERE planetid=$2 AND buildingid=$3;

	demolition_time := int4(0.05*tool_compute_building_building_time(r_building.construction_time, r_building.construction_time_exp_per_building, c, r_planet.mod_construction_speed_buildings));

	BEGIN

		INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, buildingid)

		VALUES($1, 1, $2, $3);

		-- set building demolition datetime

		UPDATE gm_planet_buildings SET

			destroy_datetime = now()+demolition_time*INTERVAL '1 second'

		WHERE planetid=$2 AND buildingid=$3 AND destroy_datetime IS NULL;

/*

		IF FOUND THEN

			UPDATE gm_planets SET

				ore = LEAST(ore_capacity, ore + r_building.cost_ore*(0.3 + r_user.mod_recycling/100.0)),

				hydrocarbon = LEAST(hydrocarbon_capacity, hydrocarbon + r_building.cost_hydrocarbon*(0.3 + r_user.mod_recycling/100.0))

			WHERE id=$2;

		END IF;

*/

		RETURN 0;

	EXCEPTION

		WHEN CHECK_VIOLATION THEN

			RETURN 4;

	END;

END;$_$;


ALTER FUNCTION ng03.user_planet_building_destroy(_userid integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_building_start(integer, integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_building_start(integer, integer, integer, boolean) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- begin the construction of a new building on a planet

-- param1: user id

-- param2: planet id

-- param3: building id

-- param4: if should loop constructions

DECLARE

	r_building record;

	r_planet record;

	c int4;

BEGIN

	PERFORM 1 FROM gm_profiles WHERE id=$1 FOR UPDATE;

	SELECT INTO r_planet 

		mod_construction_speed_buildings, energy_production-energy_consumption AS energy_available

	FROM gm_planets

	WHERE id=$2 AND ownerid=$1 FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 5;

	END IF;

	-- retrieve building info

	SELECT INTO r_building

		energy_consumption, cost_ore, cost_hydrocarbon, cost_credits, cost_energy, cost_prestige, construction_time, construction_time_exp_per_building

	FROM dt_buildings

	WHERE id=$3 AND NOT is_planet_element AND buildable;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

--	IF r_building.energy_consumption > 0 AND r_building.energy_consumption > r_planet.energy_available THEN

--		RETURN 2;

--	END IF;

	-- update planet resources before trying to remove any resources

	PERFORM internal_planet_update_production_date($2);

	-- use resources

	BEGIN

		UPDATE gm_planets SET

			ore = ore - r_building.cost_ore,

			hydrocarbon = hydrocarbon - r_building.cost_hydrocarbon,

			energy = energy - r_building.cost_energy

		WHERE id=$2;

		IF r_building.cost_prestige > 0 THEN

			-- remove user prestige points

			UPDATE gm_profiles SET

				prestige_points = prestige_points - r_building.cost_prestige

			WHERE id=$1;

		END IF;

		IF r_building.cost_credits > 0 THEN

			-- remove user credits

			UPDATE gm_profiles SET

				credits = credits - r_building.cost_credits		

			WHERE id=$1;

		END IF;

		INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, buildingid)

		VALUES($1, -r_building.cost_credits, $2, $3);

		IF r_building.construction_time_exp_per_building <> 1.0 THEN

			SELECT INTO c quantity FROM gm_planet_buildings WHERE planetid=$2 AND buildingid=$3;

		ELSE

			c := 0;

		END IF;

		r_building.construction_time := tool_compute_building_building_time(r_building.construction_time, r_building.construction_time_exp_per_building, c, r_planet.mod_construction_speed_buildings);

		-- build the building

		INSERT INTO gm_planet_building_pendings(planetid, buildingid, start_time, end_time, loop)

		VALUES($2, $3, now(), now() + r_building.construction_time * INTERVAL '1 second', $4);

		PERFORM internal_planet_update_data($2);

	EXCEPTION

		-- check violation in case not enough resources, money, space/ground or prestige

		WHEN CHECK_VIOLATION THEN

			RETURN 2;

		-- raised exception when building/research not met or maximum reached or not enough energy

		WHEN RAISE_EXCEPTION THEN

			RETURN 3;

		-- already building this type of building

		WHEN UNIQUE_VIOLATION THEN

			RETURN 4;

	END;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_building_start(integer, integer, integer, boolean) OWNER TO exileng;

--
-- Name: user_planet_buy_ressources(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_buy_ressources(integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Buy resources

-- Param1: User ID

-- Param2: Planet ID

-- Param3: ore

-- Param4: hydrocarbon

DECLARE

	time int4;

	cr numeric;

	fleet_id int8;

	total int4;

	r_planet record;

	prices resource_price;

BEGIN

	IF ($3 < 0) OR ($4 < 0) THEN

		RETURN 1;

	END IF;

	-- check that the planet exists and is owned by the given user

	SELECT INTO r_planet

		galaxy, space, internal_planet_get_blocus_strength($2) >= space AS blocked

	FROM vw_gm_planets

	WHERE ownerid=$1 AND id=$2 AND workers >= workers_for_maintenance / 2 AND (SELECT has_merchants FROM gm_galaxies WHERE id=galaxy);

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- check if enough enemy gm_fleets are orbiting the planet to block the planet

	IF r_planet.blocked THEN

		RETURN 4;

	END IF;

	prices := internal_profile_get_resource_price($1, r_planet.galaxy);

	-- compute how long it will take (from merchants to player planets)

	time := int4((2 - ($3+$4) / 100000.0)*3600);

	IF time < 3600 THEN

		time := 3600;

	END IF;

	time := int4(time + random()*1800);

	total := $3 + $4;

	cr := $3/1000 * prices.buy_ore + $4/1000 * prices.buy_hydrocarbon;

	INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, ore, hydrocarbon)

	VALUES($1, -cr, $2, $3, $4);

	-- pay immediately

	UPDATE gm_profiles SET credits = credits - cr WHERE id = $1 AND credits > cr;

	IF NOT FOUND THEN

		RAISE EXCEPTION 'not enough credits';

	END IF;

	-- insert the purchase to gm_market_purchases table, raise an exception if there's already a sale for the same planet

	INSERT INTO gm_market_purchases(planetid, ore, hydrocarbon, ore_price, hydrocarbon_price, credits, delivery_time)

	VALUES($2, $3, $4, prices.buy_ore, prices.buy_hydrocarbon, cr, now() + time/2.0 * interval '1 second');

	-- insert the sale to the market history

	INSERT INTO gm_log_markets(ore_sold, hydrocarbon_sold, credits, username)

	SELECT -$3, -$4, cr, login FROM gm_profiles WHERE id=$1;

	-- order a merchant fleet to go deposit resources to the planet

	SELECT INTO fleet_id id FROM gm_fleets WHERE ownerid=3 AND action=0 AND cargo_capacity >= total AND cargo_capacity < total+100000 ORDER BY cargo_capacity LIMIT 1 FOR UPDATE;

	-- if no gm_fleets could be sent, create a new one

	IF NOT FOUND THEN

		fleet_id := nextval('gm_fleets_id_seq');

		INSERT INTO gm_fleets(id, uid, ownerid, name, planetid, dest_planetid, action_start_time, action_end_time, action)

		VALUES(fleet_id, nextval('npc_fleet_uid_seq'), 3, 'Flotte marchande', NULL, $2, now(), now()+time/2.0 * interval '1 second', 1);

		-- add merchant ships to the fleet

		INSERT INTO gm_fleet_ships(fleetid, shipid, quantity)

		VALUES(fleet_id, 910, 1+total / (SELECT capacity FROM dt_ships WHERE id=910));

	ELSE

		-- send the merchant fleet

		UPDATE gm_fleets SET

			planetid=NULL,

			dest_planetid=$2,

			action_start_time=now(),

			action_end_time=now()+time/2.0 * interval '1 second',

			action=1

		WHERE id=fleet_id;

	END IF;

	-- update galaxy traded wares quantity

	UPDATE gm_galaxies SET

		traded_ore = traded_ore - $3,

		traded_hydrocarbon = traded_hydrocarbon - $4

	WHERE id=r_planet.galaxy;

	RETURN 0;

EXCEPTION

	WHEN RAISE_EXCEPTION THEN

		RETURN 3;

	WHEN UNIQUE_VIOLATION THEN

		RETURN 4;

END;$_$;


ALTER FUNCTION ng03.user_planet_buy_ressources(integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_dismiss_staff(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_dismiss_staff(integer, integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: PlanetId

-- Param3: scientists to dismiss

-- Param4: soldiers to dismiss

-- Param5: workers to dismiss

BEGIN

	IF $3 < 0 OR $4 < 0 OR $5 < 0 THEN

		RETURN 1;

	END IF;

	PERFORM 1 FROM gm_planets WHERE ownerid=$1 AND id=$2;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	IF $5 > 0 THEN

		PERFORM internal_planet_update_production_date($2);

	END IF;

	UPDATE gm_planets SET

		scientists=GREATEST(0, scientists-$3),

		soldiers=GREATEST(0, soldiers-$4),

		workers=LEAST(workers_capacity, GREATEST(workers_busy, workers - LEAST( GREATEST(0, workers-GREATEST(500, workers_for_maintenance/2)), $5 - LEAST(scientists, $3) - LEAST(soldiers, $4) ) ) )

	WHERE id=$2;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_dismiss_staff(integer, integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_leave(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_leave(_userid integer, _planetid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$BEGIN

	RETURN user_planet_leave(_userid, _planetid, true);

END;$$;


ALTER FUNCTION ng03.user_planet_leave(_userid integer, _planetid integer) OWNER TO exileng;

--
-- Name: user_planet_leave(integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_leave(_userid integer, _planetid integer, _report boolean) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: PlanetId

-- Param3: whether a report is added to player gm_profile_reports

DECLARE

	c int4;

	r_planet record;

	successful boolean;

BEGIN

	SELECT INTO c

		count(*)

	FROM gm_planets

	WHERE ownerid=$1;

	IF NOT FOUND OR c <= 1 THEN

		-- allow to abandon last planet if an enemy fleet is orbiting the planet

		PERFORM 1

		FROM gm_fleets

		WHERE ((planetid=$2 AND action <> -1 AND action <> 1) OR dest_planetid=$2) AND firepower > 0 AND NOT EXISTS(SELECT 1 FROM vw_gm_friends WHERE userid=$1 AND friend=gm_fleets.ownerid);

		-- if no enemy fleet is found, do not allow to abandon the planet

		IF NOT FOUND THEN

			RETURN 1;

		END IF;

	END IF;

	PERFORM 1

	FROM gm_profile_reports

	WHERE planetid=$2 AND type=2 AND SUBTYPE=13 AND invasionid > 0 AND datetime > now()-INTERVAL '1 day';

	IF FOUND THEN

		-- if there was an invasion recently, do not reset number of workers/soldiers

		UPDATE gm_planets SET

			production_lastupdate=now(),

			ownerid=2,

			recruit_workers=true

		WHERE ownerid=$1 AND id=$2/* AND score >= 80000 AND random() > 0.6*/;

	ELSE

		UPDATE gm_planets SET

			workers=GREATEST(workers, workers_capacity / 2),

			soldiers=GREATEST(soldiers, soldiers_capacity / 5),

			production_lastupdate=now(),

			ownerid=2,

			recruit_workers=true

		WHERE ownerid=$1 AND id=$2/* AND score >= 80000 AND random() > 0.6*/;

	END IF;

	successful := FOUND;

	SELECT INTO r_planet

		id, ownerid, galaxy, sector, planet

	FROM gm_planets

	WHERE id=_planetid;

/*

	IF NOT successful THEN

		PERFORM internal_planet_reset($2);

		IF _report THEN

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, data)

			VALUES(_userid, 6, 1, _planetid, '{planet:{owner:' || tool_quote(COALESCE(internal_profile_get_name(_userid), '')) || ',g:' || r_planet.galaxy || ',s:' || r_planet.sector  || ',p:' || r_planet.planet || '}}');

		END IF;

	ELSE*/

		IF _report THEN

			INSERT INTO gm_profile_reports(ownerid, type, subtype, planetid, data)

			VALUES(_userid, 6, 2, _planetid, '{planet:{owner:' || tool_quote(COALESCE(internal_profile_get_name(_userid), '')) || ',g:' || r_planet.galaxy || ',s:' || r_planet.sector  || ',p:' || r_planet.planet || '}}');

		END IF;

	--END IF;

	UPDATE gm_planets SET

		mood=mood-20

	WHERE ownerid=_userid;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_leave(_userid integer, _planetid integer, _report boolean) OWNER TO exileng;

--
-- Name: user_planet_sell_resources(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_sell_resources(_user_id integer, _planet_id integer, _ore integer, _hydro integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Put resources for sale

-- Param1: User ID

-- Param2: Planet ID

-- Param3: ore

-- Param4: hydrocarbon

-- Param5: ore price

-- Param6: hydrocarbon price

DECLARE

	r_user record;

	r_planet record;

	total int4;

	market_prices resource_price;

	ore_quantity integer;

	hydrocarbon_quantity integer;

	ore_price real;

	hydrocarbon_price real;

BEGIN

	IF ($3 < 0) OR ($4 < 0) THEN

		RETURN 1;

	END IF;

	-- check that the planet exists and is owned by the given user

	SELECT INTO r_planet

		id, name, ownerid, galaxy,

		planet_stock_ore, planet_stock_hydrocarbon

	FROM vw_gm_planets

	WHERE ownerid=_user_id AND id=_planet_id;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	PERFORM internal_planet_update_production_date(_planet_id);

	-- retrieve galaxy price for everyone (don't take user price bonus into account)

	market_prices := internal_profile_get_resource_price(0, r_planet.galaxy);

	ore_price := tool_compute_market_price(market_prices.sell_ore, r_planet.planet_stock_ore);

	hydrocarbon_price := tool_compute_market_price(market_prices.sell_hydrocarbon, r_planet.planet_stock_hydrocarbon);

	ore_quantity := LEAST(_ore, 10000000);

	hydrocarbon_quantity := LEAST(_hydro, 10000000);

	-- update resources, raise an exception if not enough resources

	UPDATE gm_planets SET

		ore = ore - ore_quantity,

		hydrocarbon = hydrocarbon - hydrocarbon_quantity,

		planet_stock_ore = planet_stock_ore + ore_quantity,

		planet_stock_hydrocarbon = planet_stock_hydrocarbon + hydrocarbon_quantity

	WHERE id=_planet_id AND ownerid=_user_id;

	-- insert the sale to the market history

	--INSERT INTO gm_log_markets(ore_sold, hydrocarbon_sold, credits, username)

	--SELECT ore_quantity, hydrocarbon_quantity, 0, login FROM gm_profiles WHERE id=_user_id;

	-- update galaxy traded wares quantity

	UPDATE gm_galaxies SET

		traded_ore = (traded_ore + ore_quantity / GREATEST(1.0, LEAST(5.0, 1.0 * market_prices.sell_ore / ore_price)))::bigint,

		traded_hydrocarbon = (traded_hydrocarbon + hydrocarbon_quantity / GREATEST(1.0, LEAST(5.0, 1.0 * market_prices.sell_hydrocarbon / hydrocarbon_price)))::bigint

	WHERE id=r_planet.galaxy;

	-- compute total credits from the sale

	total := (ore_price * ore_quantity/1000 + hydrocarbon_price * hydrocarbon_quantity/1000)::int4;

	total := internal_profile_apply_alliance_tax(_user_id, total);

	UPDATE gm_profiles SET

		credits = credits + total

	WHERE id = _user_id;

	RETURN 0;

EXCEPTION

	WHEN CHECK_VIOLATION THEN

		RETURN 3;

	WHEN UNIQUE_VIOLATION THEN

		RETURN 4;

END;$_$;


ALTER FUNCTION ng03.user_planet_sell_resources(_user_id integer, _planet_id integer, _ore integer, _hydro integer) OWNER TO exileng;

--
-- Name: user_planet_ship_cancel(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_ship_cancel(_planetid integer, _pending_id integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- cancel construction 

-- Param1: Planet id

-- Param2: Id of gm_planet_ship_pendings

DECLARE

	r_pending record;

	r_pending2 record;

	r_ship record;

	percent float4;

BEGIN

	-- retrieve shipid, quantity, percent built if under construction

	SELECT INTO r_pending

		shipid,

		quantity,

		start_time,

		end_time,

		recycle,

		COALESCE( 1.0 - date_part('epoch', now() - start_time) / date_part('epoch', end_time - start_time) / 2.0, 0.98) AS percentage,

		take_resources

	FROM gm_planet_ship_pendings

	WHERE id=$2 AND planetid=$1 AND (NOT recycle OR end_time IS NULL) FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- give back ships that were to be recycled

	IF r_pending.recycle THEN

		DELETE FROM gm_planet_ship_pendings WHERE id=$2 AND planetid=$1;

		IF r_pending.end_time is not null THEN

			INSERT INTO gm_planet_ships(planetid, shipid, quantity)

			VALUES($1, r_pending.shipid, r_pending.quantity);

		END IF;

		RETURN 0;

	END IF;

	IF (NOT r_pending.take_resources) OR (r_pending.end_time IS NOT NULL) THEN

		SELECT INTO r_ship

			cost_ore, cost_hydrocarbon, cost_energy, 0 AS cost_credits, crew, required_shipid, cost_prestige

		FROM dt_ships

		WHERE id=r_pending.shipid;

		IF NOT FOUND THEN

			RETURN 1;

		END IF;

		IF r_pending.end_time IS NOT NULL THEN

			percent := r_pending.percentage;

			IF percent > 1.0 THEN

				percent := 1.0;

			ELSEIF percent < 0.5 THEN

				percent := 0.5;

			END IF;

		ELSE

			percent := 1.0;

		END IF;

		PERFORM internal_planet_update_data($1);

		-- give resources back

		UPDATE gm_planets SET

			ore = ore + LEAST(ore_capacity-ore, int4(percent * r_ship.cost_ore * r_pending.quantity)),

			hydrocarbon = hydrocarbon + LEAST(hydrocarbon_capacity-hydrocarbon, int4(percent * r_ship.cost_hydrocarbon * r_pending.quantity)),

			workers = workers + LEAST(workers_capacity-workers, int4(r_ship.crew) * r_pending.quantity),

			energy = energy + LEAST(energy_capacity-energy, int4(percent * r_ship.cost_energy * r_pending.quantity))

		WHERE id=$1;

		if r_ship.required_shipid IS NOT NULL THEN

			INSERT INTO gm_planet_ships(planetid, shipid, quantity)

			VALUES($1, r_ship.required_shipid, r_pending.quantity);

		END IF;

		IF r_ship.cost_credits > 0 OR r_ship.cost_prestige > 0 THEN

			UPDATE gm_profiles SET

				credits = credits + int4(percent * r_ship.cost_credits * r_pending.quantity),

				prestige_points_refund = prestige_points_refund + int4(r_ship.cost_prestige * percent * 0.95)

			WHERE id=(SELECT ownerid FROM gm_planets WHERE id=$1 LIMIT 1);

		END IF;

	END IF;

	DELETE FROM gm_planet_ship_pendings WHERE id=$2 AND planetid=$1;

	PERFORM internal_planet_next_ship_pending($1);

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_ship_cancel(_planetid integer, _pending_id integer) OWNER TO exileng;

--
-- Name: user_planet_ship_recycle(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_ship_recycle(integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- begin the construction of a new building on a planet

-- param1: planet id

-- param2: ship id

-- param3: number of ships

DECLARE

	r_ship record;

	count int4;

BEGIN

	-- check the user wants to recycle at least 1 ship

	IF $3 <= 0 THEN

		RETURN 0;

	END IF;

	-- retrieve ship info

	SELECT INTO r_ship

		label, crew, cost_ore, cost_hydrocarbon, cost_credits, workers, required_shipid

	FROM dt_ships

	WHERE id=$2;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	BEGIN

		-- get how many ships we can recycle at maximum

		SELECT INTO count quantity FROM gm_planet_ships WHERE planetid=$1 AND shipid=$2;

		count := LEAST(count, $3);

		-- there are no ships to recycle

		IF count < 1 THEN

			RETURN 5;

		END IF;

/*

		-- remove ships

		UPDATE gm_planet_ships SET

			quantity = quantity - count

		WHERE planetid=$1 AND shipid=$2 AND quantity >= count;

		IF NOT FOUND THEN

			RAISE EXCEPTION 'Trying to recycle more ships than available';

		END IF;

*/

		-- queue the order

		INSERT INTO gm_planet_ship_pendings(planetid, shipid, start_time, quantity, recycle)

		VALUES($1, $2, now(), count, true);

		INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, shipid, quantity)

		VALUES(internal_planet_get_profile_id($1), 0, $1, $2, -count);

		PERFORM internal_planet_next_ship_pending($1);

	EXCEPTION

		-- check violation in case not enough resources, money or space/floor

		WHEN CHECK_VIOLATION THEN

			RETURN 2;

		-- raised exception when trying to recycle more ships than available (should not happen)

		WHEN RAISE_EXCEPTION THEN

			RETURN 3;

	END;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_ship_recycle(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_ship_start(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_ship_start(integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$BEGIN

	RETURN user_planet_ship_start($1, $2, $3, true);

END;$_$;


ALTER FUNCTION ng03.user_planet_ship_start(integer, integer, integer) OWNER TO exileng;

--
-- Name: user_planet_ship_start(integer, integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_ship_start(_planetid integer, _shipid integer, _quantity integer, _take_resources boolean) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- begin the construction of a new building on a planet

-- param1: planet id

-- param2: ship id

-- param3: number of constructions

-- param4: if take resources immediately

DECLARE

	r_ship record;

	b_construction_time int2;

	count int4;

	r_user record;

BEGIN

	IF $3 <= 0 THEN

		RETURN 0;

	END IF;

	-- retrieve ship info

	SELECT INTO r_ship

		label, crew, cost_ore, cost_hydrocarbon, cost_credits, workers, required_shipid

	FROM dt_ships

	WHERE id=$2;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	BEGIN

		IF _take_resources THEN

			-- retrieve user id that owns the planetid $1

			SELECT INTO r_user ownerid AS id FROM gm_planets WHERE id=$1 LIMIT 1;

			IF NOT FOUND THEN

				RETURN 1;

			END IF;

			-- update planet resources before trying to remove any resources

			PERFORM internal_planet_update_production_date($1);

			-- get how many ships we can build at maximum

			IF r_ship.crew > 0 THEN

				SELECT LEAST(LEAST(ore / r_ship.cost_ore, hydrocarbon / r_ship.cost_hydrocarbon), (workers-GREATEST(workers_busy,500,workers_for_maintenance/2)-r_ship.workers) / r_ship.crew) INTO count FROM gm_planets WHERE id=$1;

			ELSE

				SELECT LEAST(ore / r_ship.cost_ore, hydrocarbon / r_ship.cost_hydrocarbon) INTO count FROM gm_planets WHERE id=$1;

			END IF;

			-- get how many ships we can build at maximum

			IF r_ship.cost_credits > 0 THEN

				SELECT LEAST(count, credits / r_ship.cost_credits) INTO count FROM gm_profiles WHERE id=r_user.id;

			END IF;

			count := LEAST(count, $3);

			-- limit number of ships buildable to the number of required ship available on the planet

			IF r_ship.required_shipid IS NOT NULL THEN

				SELECT INTO count

					LEAST(count, quantity)

				FROM gm_planet_ships

				WHERE planetid=$1 AND shipid=r_ship.required_shipid;

				IF NOT FOUND THEN

					count := 0;

				END IF;

			END IF;

			-- can't build any ship with the available resources

			IF count < 1 THEN

				RETURN 5;

			END IF;

			-- remove resources

			UPDATE gm_planets SET

				ore = ore - count*r_ship.cost_ore,

				hydrocarbon = hydrocarbon - count*r_ship.cost_hydrocarbon,

				workers = workers - count*r_ship.crew

			WHERE id=$1;

			INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, shipid, quantity)

			VALUES(r_user.id, -count*r_ship.cost_credits, $1, $2, count);

			-- remove user credits

			UPDATE gm_profiles SET

				credits = credits - count*r_ship.cost_credits

			WHERE id=r_user.id;

			IF r_ship.required_shipid IS NOT NULL THEN

				UPDATE gm_planet_ships SET

					quantity = quantity - count

				WHERE planetid=$1 AND shipid=r_ship.required_shipid AND quantity >= count;

				IF NOT FOUND THEN

					RAISE EXCEPTION 'not enough required ship';

				END IF;

			END IF;

		ELSE

			count := _quantity;

		END IF;

		-- queue the ship

		INSERT INTO gm_planet_ship_pendings(planetid, shipid, start_time, quantity, take_resources)

		VALUES($1, $2, now(), count, NOT $4);

		PERFORM internal_planet_next_ship_pending($1);

		PERFORM internal_planet_update_production_date($1);

	EXCEPTION

		-- check violation in case not enough resources, money or space/floor

		WHEN CHECK_VIOLATION THEN

			RETURN 2;

		-- raised exception when building/research not met or maximum reached

		WHEN RAISE_EXCEPTION THEN

			RETURN 3;

		-- already building this type of building

		WHEN UNIQUE_VIOLATION THEN

			RETURN 4;

	END;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_ship_start(_planetid integer, _shipid integer, _quantity integer, _take_resources boolean) OWNER TO exileng;

--
-- Name: user_planet_training_cancel(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_training_cancel(_planetid integer, _trainingid integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- cancel construction 

-- Param1: Planet id

-- Param2: Id of gm_planet_trainings

DECLARE

	r_pending record;

	prices training_price;

	percent float4;

BEGIN

	-- retrieve shipid, quantity, percent built if under construction

	SELECT INTO r_pending

		GREATEST(0, scientists) AS scientists,

		GREATEST(0, soldiers) AS soldiers,

		start_time,

		end_time--,

		--COALESCE( 1.0 - date_part('epoch', now() - start_time) / date_part('epoch', end_time - start_time) / 2.0, 0.98) AS percentage

	FROM gm_planet_trainings

	WHERE id=_trainingid AND planetid=_planetid FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	prices := internal_profile_get_training_price(0);

	DELETE FROM gm_planet_trainings WHERE id=_trainingid AND planetid=_planetid;

/*

	percent := r_pending.percentage;

	IF percent > 1.0 THEN

		percent := 1.0;

	ELSEIF percent < 0.5 THEN

		percent := 0.5;

	END IF;

*/

	percent := 1.0;

	PERFORM internal_planet_update_data(_planetid);

--	RAISE NOTICE '%', int4( (/*prices.scientist_ore * r_pending.scientists*/ + /*prices.soldier_ore */ r_pending.soldiers));

	-- give resources back

	UPDATE gm_planets SET

		ore = LEAST(ore_capacity, ore + int4(percent * (prices.scientist_ore * r_pending.scientists + prices.soldier_ore * r_pending.soldiers) )),

		hydrocarbon = LEAST(hydrocarbon_capacity, hydrocarbon + int4(percent * (prices.scientist_hydrocarbon * r_pending.scientists + prices.soldier_hydrocarbon * r_pending.soldiers) )),

		workers = LEAST(workers_capacity, workers + int4(r_pending.scientists + r_pending.soldiers))

	WHERE id=$1;

	UPDATE gm_profiles SET credits = credits + int4(percent * (prices.scientist_credits * r_pending.scientists + prices.soldier_credits * r_pending.soldiers) )

	WHERE id=(SELECT ownerid FROM gm_planets WHERE id=_planetid LIMIT 1);

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_training_cancel(_planetid integer, _trainingid integer) OWNER TO exileng;

--
-- Name: user_planet_training_start(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_training_start(_userid integer, _planetid integer, _scientists integer, _soldiers integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

-- Param2: PlanetId

-- Param3: number of scientists

-- Param4: number of soldiers

DECLARE

	r_planet record;

	r_user record;

	prices training_price;

	t_scientists int4;

	t_soldiers int4;

	code int2;

BEGIN

	code := 0;

	-- check that the planet belongs to the given userid

	PERFORM 1

	FROM gm_planets

	WHERE id=_planetid AND ownerid=_userid;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- retrieve training price

	prices := internal_profile_get_training_price(_userid);

	PERFORM internal_planet_update_production_date(_planetid);

	-- retrieve player credits

	SELECT INTO r_user credits FROM gm_profiles WHERE id=_userid;

	-- retrieve planet stats

	-- also, retrieve how many scientists/soldiers can be trained every "batch"

	SELECT INTO r_planet

		ore,

		hydrocarbon,

		workers-workers_for_maintenance AS workers,

		training_scientists, training_soldiers

	FROM gm_planets

	WHERE id=_planetid;

	IF r_planet.workers <= 0 THEN

		RETURN 6;	-- no available workers

	END IF;

	--RAISE NOTICE 'sc: %, %, %, %, %', _scientists, r_planet.workers, r_user.credits / prices.scientist_credits, r_planet.ore / prices.scientist_ore, r_planet.hydrocarbon / prices.scientist_hydrocarbon;

	-- limit scientists

	t_scientists := LEAST(_scientists, r_planet.workers, r_user.credits / prices.scientist_credits, r_planet.ore / prices.scientist_ore, r_planet.hydrocarbon / prices.scientist_hydrocarbon);

	IF t_scientists < 0 THEN

		t_scientists := 0;

	ELSEIF _scientists > t_scientists THEN

		code := 4;	-- scientists have been limited in number

	END IF;

	r_user.credits := r_user.credits - t_scientists * prices.scientist_credits;

	r_planet.ore := r_planet.ore - t_scientists * prices.scientist_ore;

	r_planet.hydrocarbon := r_planet.hydrocarbon - t_scientists * prices.scientist_hydrocarbon;

	r_planet.workers := r_planet.workers - t_scientists;

	--RAISE NOTICE 'sol: %, %, %, %, %', _scientists, r_planet.workers, r_user.credits / prices.scientist_credits, r_planet.ore / prices.scientist_ore, r_planet.hydrocarbon / prices.scientist_hydrocarbon;

	-- limit soldiers

	t_soldiers := LEAST(_soldiers, r_planet.workers, r_user.credits / prices.soldier_credits, r_planet.ore / prices.soldier_ore, r_planet.hydrocarbon / prices.soldier_hydrocarbon);

	IF t_soldiers < 0 THEN

		t_soldiers := 0;

	ELSEIF _soldiers > t_soldiers THEN

		code := 4;	-- soldiers have been limited in number

	END IF;

	-- check if it is possible to train scientists

	IF _scientists > 0 AND r_planet.training_scientists = 0 THEN

		t_scientists := 0;

		code := 5;

	END IF;

	-- check if it is possible to train soldiers

	IF _soldiers > 0 AND r_planet.training_soldiers = 0 THEN

		t_soldiers := 0;

		code := 5;

	END IF;

	BEGIN

		UPDATE gm_planets SET

			workers = workers - t_scientists - t_soldiers,

			ore = ore - t_scientists * prices.scientist_ore - t_soldiers * prices.soldier_ore,

			hydrocarbon = hydrocarbon - t_scientists * prices.scientist_hydrocarbon - t_soldiers * prices.soldier_hydrocarbon

		WHERE id=_planetid;

		--PERFORM sp_log_credits($1, -t_price, 'trained ' || t_scientists || ' scientists and ' || t_soldiers || ' soldiers');

		INSERT INTO gm_log_profile_actions(userid, credits_delta, planetid, scientists, soldiers)

		VALUES(_userid, -t_scientists * prices.scientist_credits - t_soldiers * prices.soldier_credits, _planetid, _scientists, _soldiers);

		UPDATE gm_profiles SET credits = credits - t_scientists * prices.scientist_credits - t_soldiers * prices.soldier_credits WHERE id=_userid;

		IF t_scientists > 0 THEN

			INSERT INTO gm_planet_trainings(planetid, scientists)

			VALUES(_planetid, t_scientists);

		END IF;

		IF t_soldiers > 0 THEN

			INSERT INTO gm_planet_trainings(planetid, soldiers)

			VALUES(_planetid, t_soldiers);

		END IF;

		PERFORM internal_planet_next_training(_planetid);

	EXCEPTION

		-- check violation in case not enough resources, money or space/floor

		WHEN CHECK_VIOLATION THEN

			RETURN 2;

	END;

	RETURN code;

END;$_$;


ALTER FUNCTION ng03.user_planet_training_start(_userid integer, _planetid integer, _scientists integer, _soldiers integer) OWNER TO exileng;

--
-- Name: user_planet_transfer_ships(integer, integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_planet_transfer_ships(integer, integer, integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- transfer ships to a fleet

-- param1: user id

-- param2: fleet id

-- param3: ship id

-- param4: quantity

DECLARE

	ships_quantity int4;

	planet_id int4;

BEGIN

	IF $4 <= 0 THEN

		RETURN 0;

	END IF;

	-- retrieve the planetid where the fleet is and if it is not moving and not engaged in battle

	SELECT planetid INTO planet_id 

	FROM gm_fleets 

	WHERE id=$2 AND ownerid=$1 AND action=0 /*AND NOT engaged*/;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- check that the planet belongs to the same player

	PERFORM 1

	FROM gm_planets

	WHERE id=planet_id AND ownerid=$1;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- check that the user has the gm_profile_researches to use this ship

	PERFORM 1

	FROM dt_ship_research_reqs

	WHERE shipid = $3 AND required_researchid NOT IN (SELECT researchid FROM gm_profile_researches WHERE userid=$1 AND level >= required_researchlevel);

	IF FOUND THEN

		RETURN 3;

	END IF;

	-- retrieve the maximum quantity of ships that can be transferred from the planet

	SELECT quantity INTO ships_quantity

	FROM gm_planet_ships

	WHERE planetid=planet_id AND shipid=$3 FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- update or delete ships from planets

	IF ships_quantity > $4 THEN

		ships_quantity := $4;

		UPDATE gm_planet_ships SET quantity = quantity - $4 WHERE planetid=planet_id AND shipid=$3;

	ELSE

		DELETE FROM gm_planet_ships WHERE planetid=planet_id AND shipid=$3;

	END IF;

	-- add ships to the fleet

	--UPDATE gm_fleet_ships SET quantity = quantity + ships_quantity WHERE fleetid=$2 AND shipid=$3;

	--IF NOT FOUND THEN

	INSERT INTO gm_fleet_ships(fleetid, shipid, quantity) VALUES($2,$3,ships_quantity);

	--END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_planet_transfer_ships(integer, integer, integer, integer) OWNER TO exileng;

--
-- Name: user_profile_reset(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_profile_reset(integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- triggered when a new user is added to the gm_profiles table

-- create a new planet with the user login suffixed by a " I"

-- create a building on the new planet of type 1 (colony)

-- create a commander with the user login

DECLARE

	r_user record;

	planet_name text;

	new_planet_id integer;

	lastplanet int4;

	--lastcolonizedplanet int8;

BEGIN

	-- check that the user has no planets

	SELECT INTO r_user id, login, planets, resets, score_research, lcid, resets FROM gm_profiles WHERE id=$1;

	IF NOT FOUND OR r_user.planets > 0 THEN

		-- user already has at least 1 planet

		RETURN 1;

	END IF;

	-- give the gm_fleets to the lost nations

	UPDATE gm_fleets SET ownerid=2 WHERE ownerid=$1;

	-- reset the commander

	PERFORM internal_profile_reset_commanders($1);

	planet_name := r_user.login || ' I';

	LOOP

		BEGIN

			IF $2 = 0 THEN

				SELECT INTO new_planet_id

					gm_planets.id

				FROM gm_planets

					INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

				WHERE --gm_planets.id > lastcolonizedplanet AND

					ownerid IS NULL AND (planet % 2 = 0) AND

					(sector % 10 = 0 OR sector % 10 = 1 OR sector <= 10 OR sector > 90) AND

					colonization_datetime IS NULL AND 

					planet_floor > 0 AND planet_space > 0 AND

					colonies < 1500 AND allow_new_players

				ORDER BY colonies / 50 DESC, random()

				LIMIT 1 FOR UPDATE;

			ELSE

				PERFORM 1 FROM internal_profile_get_galaxies_info($1) WHERE id=$2;

				IF NOT FOUND THEN

					RETURN 4;

				END IF;

				SELECT INTO new_planet_id

					gm_planets.id

				FROM gm_planets

					INNER JOIN gm_galaxies ON (gm_galaxies.id=gm_planets.galaxy)

				WHERE ownerid IS NULL AND (gm_galaxies.id = $2) AND (planet % 2 = 0) AND

					(sector % 10 = 0 OR sector % 10 = 1 OR sector <= 10 OR sector > 90) AND

					planet_floor > 0 AND planet_space > 0 AND allow_new_players

				ORDER BY random()

				LIMIT 1 FOR UPDATE;

			END IF;

			IF NOT FOUND THEN

				-- no available planet found

				RETURN 4;

			END IF;

			-- make enemy/ally/friend gm_fleets to go elsewhere

			PERFORM gm_planets.id, user_fleet_move(gm_fleets.ownerid, gm_fleets.id, internal_planet_find_nearest(gm_fleets.ownerid, gm_planets.id))

			FROM gm_planets

				INNER JOIN gm_fleets ON (gm_fleets.action <> -1 AND gm_fleets.action <> 1 AND gm_fleets.planetid=gm_planets.id AND gm_fleets.ownerid <> gm_planets.ownerid)

			WHERE gm_planets.id=new_planet_id;

			-- reset gm_profile_researches

			DELETE FROM gm_profile_research_pendings WHERE userid=$1;

			--DELETE FROM gm_profile_researches WHERE userid=$1 AND EXISTS(SELECT 1 FROM dt_researches WHERE id=researchid AND (rank > 6 /*OR rank < 0*/));

			--UPDATE gm_profile_researches SET level=GREATEST(level-LEAST(level/3, 3), 1) WHERE userid=$1 AND (SELECT rank FROM dt_researches WHERE id=researchid) < 0;

			INSERT INTO gm_profile_researches(userid, researchid, level)

			SELECT $1, id, defaultlevel FROM dt_researches WHERE defaultlevel > 0 AND NOT EXISTS(SELECT 1 FROM gm_profile_researches WHERE userid=$1 AND researchid=dt_researches.id);

			PERFORM internal_profile_update_modifiers($1);

			-- remove gm_commanders

			--DELETE FROM gm_commanders WHERE ownerid=$1 AND delete_on_reset;

			PERFORM internal_planet_reset(new_planet_id);

			-- setup the planet with some resources

			DELETE FROM gm_planet_ships WHERE planetid=new_planet_id;

			UPDATE gm_planets SET

				name = planet_name,

				ownerid = $1,

				ore = 10000,

				ore_capacity=10000,

				hydrocarbon = 7500,

				hydrocarbon_capacity=10000,

				workers = 10000,

				workers_capacity = 10000,

				scientists=50,

				scientists_capacity=100,

				soldiers=50,

				soldiers_capacity=100

			WHERE id=new_planet_id;

			IF FOUND THEN

				-- add a colony building (id 1)

				INSERT INTO gm_planet_buildings(planetid, buildingid, quantity) VALUES(new_planet_id, 101, 1);

				--BEGIN

					-- add a commander with the name of the player into gm_commanders table

					--INSERT INTO gm_commanders(ownerid, name, can_be_fired, points) VALUES($1, r_user.login, false, 15);

				--EXCEPTION

				--	WHEN UNIQUE_VIOLATION THEN --

				--END;

				-- assign this commander to the first planet of the player

				UPDATE gm_planets SET

					commanderid=(SELECT id FROM gm_commanders WHERE ownerid=$1 LIMIT 1),

					mood=100

				WHERE id=new_planet_id;

			END IF;

			UPDATE gm_profiles SET

				credits = DEFAULT,

				alliance_id = null,

				alliance_rank = 0, 

				alliance_joined = null,

				last_holidays = null,

				protection_enabled = DEFAULT,

				protection_datetime = DEFAULT,

				remaining_colonizations = DEFAULT,

				resets = resets + 1,

				game_started = DEFAULT,

				credits_bankruptcy = DEFAULT,

				upkeep_last_cost = DEFAULT,

				upkeep_commanders = DEFAULT,

				upkeep_planets = DEFAULT,

				upkeep_scientists = DEFAULT,

				upkeep_soldiers = DEFAULT,

				upkeep_ships = DEFAULT,

				upkeep_ships_in_position = DEFAULT,

				upkeep_ships_parked = DEFAULT,

				score = DEFAULT,

				score_prestige = DEFAULT,

				prestige_points = DEFAULT,

				credits_produced = DEFAULT,

				leave_alliance_datetime = NULL

			WHERE id=$1;

			-- reset chats where user is

			DELETE FROM gm_profile_chats WHERE userid=$1;

			DELETE FROM gm_chat_online_profiles WHERE userid=$1;

			DELETE FROM gm_mail_addressees WHERE addresseeid=$1;

			DELETE FROM gm_mail_ignorees WHERE ignored_userid=$1;

			IF r_user.resets = 0 THEN

				PERFORM admin_send_mail($1, 1, r_user.lcid);

				PERFORM admin_send_mail($1, 5, r_user.lcid);

			END IF;

			RETURN 0;

		EXCEPTION

			WHEN UNIQUE_VIOLATION THEN

				RETURN 2;

		END;

	END LOOP;

	-- oops should already have exited the function

	RETURN 3;

END;$_$;


ALTER FUNCTION ng03.user_profile_reset(integer, integer) OWNER TO exileng;

--
-- Name: user_profile_stop_holidays(integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_profile_stop_holidays(integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- Param1: UserId

DECLARE

	remaining_time INTERVAL;

BEGIN

	SELECT INTO remaining_time end_time-now() FROM gm_profile_holidays WHERE userid=$1 AND activated FOR UPDATE;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	IF remaining_time > INTERVAL '0 seconds' THEN

	-- remove remaining_time from buildings

	UPDATE gm_planet_building_pendings SET end_time=end_time-remaining_time WHERE end_time IS NOT NULL AND planetid IN (SELECT id FROM gm_planets WHERE ownerid=$1);

	-- remove remaining_time from ships

	UPDATE gm_planet_ship_pendings SET end_time=end_time-remaining_time WHERE end_time IS NOT NULL AND planetid IN (SELECT id FROM gm_planets WHERE ownerid=$1);

	-- remove remaining_time from research

	UPDATE gm_profile_research_pendings SET end_time=end_time-remaining_time WHERE userid=$1;

	END IF;

	-- resume all planets productions

	UPDATE gm_planets SET production_lastupdate=now(), production_frozen=false WHERE ownerid=$1 AND production_frozen;

	PERFORM internal_planet_update_data(id) FROM gm_planets WHERE ownerid=$1;

	-- remove user from holidays mode

	UPDATE gm_profiles SET privilege=0, last_holidays=now() WHERE id=$1;

	DELETE FROM gm_profile_holidays WHERE userid=$1;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_profile_stop_holidays(integer) OWNER TO exileng;

--
-- Name: user_research_cancel(integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_research_cancel(integer, integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- cancel the construction of a building on a planet

-- param1: user id

-- param2: research id

DECLARE

	rec research_status;

	percent float4;

BEGIN

	-- first, retrieve research percentage

	SELECT COALESCE( 1.0 - date_part('epoch', now() - start_time) / date_part('epoch', end_time - start_time) / 2.0, 0) INTO percent

	FROM gm_profile_research_pendings

	WHERE userid=$1 AND researchid=$2;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	IF percent > 1.0 THEN

		percent := 1.0;

	ELSEIF percent < 0.5 THEN

		percent := 0.5;

	END IF;

	-- retrieve research info

	SELECT INTO rec * FROM internal_profile_get_researches_status($1) WHERE researchid=$2 LIMIT 1;

	IF NOT FOUND THEN

		RETURN 2;

	END IF;

	-- delete pending building from list

	DELETE FROM gm_profile_research_pendings

	WHERE userid=$1 AND researchid=$2;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	-- give money back

	UPDATE gm_profiles SET

		credits = credits + percent * rec.total_cost

	WHERE id=$1;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_research_cancel(integer, integer) OWNER TO exileng;

--
-- Name: user_research_start(integer, integer, boolean); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_research_start(integer, integer, boolean) RETURNS smallint
    LANGUAGE plpgsql
    AS $_$-- begin the research of a technology

-- param1: user id

-- param2: research id

-- param3: if should loop reseaches

DECLARE

	r_research record;

BEGIN

	-- retrieve research info

	SELECT INTO r_research

		label, total_cost, total_time

	FROM internal_profile_get_researches_status($1)

	WHERE researchid=$2 AND (level < levels OR expiration_time IS NOT NULL) AND researchable AND buildings_requirements_met AND status IS NULL;

	IF NOT FOUND THEN

		RETURN 1;

	END IF;

	BEGIN

		--PERFORM sp_log_credits($1, -r_research.total_cost, 'start research: ' || r_research.label);

		INSERT INTO gm_log_profile_actions(userid, credits_delta, researchid)

		VALUES($1, -r_research.total_cost, $2);

		-- subtract the credits

		UPDATE gm_profiles SET

			credits = credits - r_research.total_cost

		WHERE id = $1;

		-- start the research

		INSERT INTO gm_profile_research_pendings(userid, researchid, start_time, end_time, looping)

		VALUES($1, $2, now(), now() + r_research.total_time * INTERVAL '1 seconds', $3);

	EXCEPTION

		-- check violation when not enough money

		WHEN CHECK_VIOLATION THEN

			RETURN 2;

		-- raised exception when building/research not met

		WHEN RAISE_EXCEPTION THEN

			RETURN 3;

		-- when already researching

		WHEN UNIQUE_VIOLATION THEN

			RETURN 4;

	END;

	IF r_research.total_time = 0 THEN

		PERFORM process_profile_research_pendings();

	END IF;

	RETURN 0;

END;$_$;


ALTER FUNCTION ng03.user_research_start(integer, integer, boolean) OWNER TO exileng;

--
-- Name: user_spying_create(integer, integer, integer); Type: FUNCTION; Schema: ng03; Owner: exileng
--

CREATE FUNCTION ng03.user_spying_create(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$-- Create a new intelligence report

-- Param1: owner id

-- Param2: report type

-- - 1 nation infos

-- - 2 gm_fleets infos

-- - 3 planet infos

-- Param3: gm_spyings level

-- - 0 cheap

-- - 1 normal

-- - 2 best

-- - 3 ultra

DECLARE

	spy_id integer;

BEGIN

	spy_id := nextval('gm_spyings_id_seq');

	INSERT INTO gm_spyings(id, userid, date, "type", level, key)

	VALUES(spy_id, $1, now()+interval '1 hour', $2, $3, tool_generate_key() );

	RETURN spy_id;

EXCEPTION

	WHEN FOREIGN_KEY_VIOLATION THEN

		RETURN -1;

	WHEN UNIQUE_VIOLATION THEN

		RETURN user_spying_create($1, $2, $3);

END;$_$;


ALTER FUNCTION ng03.user_spying_create(integer, integer, integer) OWNER TO exileng;

--
-- Name: array_accum(anyelement); Type: AGGREGATE; Schema: ng03; Owner: exileng
--

CREATE AGGREGATE ng03.array_accum(anyelement) (
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}'
);


ALTER AGGREGATE ng03.array_accum(anyelement) OWNER TO exileng;

--
-- Name: float8_mult(double precision); Type: AGGREGATE; Schema: ng03; Owner: exileng
--

CREATE AGGREGATE ng03.float8_mult(double precision) (
    SFUNC = float8mul,
    STYPE = double precision,
    INITCOND = '1.0'
);


ALTER AGGREGATE ng03.float8_mult(double precision) OWNER TO exileng;

--
-- Name: dt_banned_chat_words; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_banned_chat_words (
    regexp character varying NOT NULL,
    replace_by character varying NOT NULL
);


ALTER TABLE ng03.dt_banned_chat_words OWNER TO exileng;

--
-- Name: dt_banned_usernames; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_banned_usernames (
    login character varying NOT NULL
);


ALTER TABLE ng03.dt_banned_usernames OWNER TO exileng;

--
-- Name: dt_building_building_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_building_building_reqs (
    buildingid integer NOT NULL,
    required_buildingid integer NOT NULL
);


ALTER TABLE ng03.dt_building_building_reqs OWNER TO exileng;

--
-- Name: dt_building_research_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_building_research_reqs (
    buildingid integer NOT NULL,
    required_researchid integer NOT NULL,
    required_researchlevel smallint NOT NULL
);


ALTER TABLE ng03.dt_building_research_reqs OWNER TO exileng;

--
-- Name: dt_commander_firstnames; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_commander_firstnames (
    name character varying(16) NOT NULL
);


ALTER TABLE ng03.dt_commander_firstnames OWNER TO exileng;

--
-- Name: dt_commander_lastnames; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_commander_lastnames (
    name character varying(16) NOT NULL
);


ALTER TABLE ng03.dt_commander_lastnames OWNER TO exileng;

--
-- Name: dt_mails; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_mails (
    id integer NOT NULL,
    lcid smallint DEFAULT 1036 NOT NULL,
    subject character varying NOT NULL,
    body character varying NOT NULL,
    sender character varying DEFAULT ''::character varying NOT NULL
);


ALTER TABLE ng03.dt_mails OWNER TO exileng;

--
-- Name: dt_mails_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.dt_mails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.dt_mails_id_seq OWNER TO exileng;

--
-- Name: dt_mails_id_seq; Type: SEQUENCE OWNED BY; Schema: ng03; Owner: exileng
--

ALTER SEQUENCE ng03.dt_mails_id_seq OWNED BY ng03.dt_mails.id;


--
-- Name: dt_processes; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_processes (
    procedure character varying(64) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    last_runtime timestamp without time zone DEFAULT now() NOT NULL,
    run_every interval NOT NULL,
    last_result character varying,
    last_executiontimes interval[] DEFAULT '{00:00:00,00:00:00,00:00:00,00:00:00,00:00:00,00:00:00,00:00:00,00:00:00,00:00:00,00:00:00}'::interval[] NOT NULL
);


ALTER TABLE ng03.dt_processes OWNER TO exileng;

--
-- Name: dt_research_building_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_research_building_reqs (
    researchid integer NOT NULL,
    required_buildingid integer NOT NULL,
    required_buildingcount smallint DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.dt_research_building_reqs OWNER TO exileng;

--
-- Name: dt_research_research_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_research_research_reqs (
    researchid integer NOT NULL,
    required_researchid integer NOT NULL,
    required_researchlevel smallint DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.dt_research_research_reqs OWNER TO exileng;

--
-- Name: dt_researches_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.dt_researches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.dt_researches_id_seq OWNER TO exileng;

--
-- Name: dt_researches; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_researches (
    id integer DEFAULT nextval('ng03.dt_researches_id_seq'::regclass) NOT NULL,
    category smallint DEFAULT 1 NOT NULL,
    name character varying(32) NOT NULL,
    label character varying(64) NOT NULL,
    description text NOT NULL,
    rank integer DEFAULT 1 NOT NULL,
    levels smallint DEFAULT 5 NOT NULL,
    defaultlevel smallint DEFAULT 0 NOT NULL,
    cost_credits integer DEFAULT 0 NOT NULL,
    mod_production_ore real DEFAULT 0 NOT NULL,
    mod_production_hydrocarbon real DEFAULT 0 NOT NULL,
    mod_production_energy real DEFAULT 0 NOT NULL,
    mod_production_workers real DEFAULT 0 NOT NULL,
    mod_construction_speed_buildings real DEFAULT 0 NOT NULL,
    mod_construction_speed_ships real DEFAULT 0 NOT NULL,
    mod_fleet_damage real DEFAULT 0 NOT NULL,
    mod_fleet_speed real DEFAULT 0 NOT NULL,
    mod_fleet_shield real DEFAULT 0 NOT NULL,
    mod_fleet_handling real DEFAULT 0 NOT NULL,
    mod_fleet_tracking_speed real DEFAULT 0 NOT NULL,
    mod_fleet_energy_capacity real DEFAULT 0 NOT NULL,
    mod_fleet_energy_usage real DEFAULT 0 NOT NULL,
    mod_fleet_signature real DEFAULT 0 NOT NULL,
    mod_merchant_buy_price real DEFAULT 0 NOT NULL,
    mod_merchant_sell_price real DEFAULT 0 NOT NULL,
    mod_merchant_speed real DEFAULT 0 NOT NULL,
    mod_upkeep_commanders_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_planets_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_scientists_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_soldiers_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_ships_cost real DEFAULT 0 NOT NULL,
    mod_research_cost real DEFAULT 0 NOT NULL,
    mod_research_time real DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 0 NOT NULL,
    mod_commanders real DEFAULT 0 NOT NULL,
    mod_planets real DEFAULT 0 NOT NULL,
    mod_research_effectiveness real DEFAULT 0 NOT NULL,
    mod_energy_transfer_effectiveness real DEFAULT 0 NOT NULL,
    mod_prestige_from_ships real DEFAULT 0 NOT NULL,
    modf_bounty real DEFAULT 1.0 NOT NULL,
    mod_prestige_from_buildings real DEFAULT 0 NOT NULL,
    mod_planet_need_ore real DEFAULT 0 NOT NULL,
    mod_planet_need_hydrocarbon real DEFAULT 0 NOT NULL,
    mod_fleet_jump_speed real DEFAULT 0 NOT NULL,
    expiration interval
);


ALTER TABLE ng03.dt_researches OWNER TO exileng;

--
-- Name: dt_ship_building_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_ship_building_reqs (
    shipid integer NOT NULL,
    required_buildingid integer NOT NULL
);


ALTER TABLE ng03.dt_ship_building_reqs OWNER TO exileng;

--
-- Name: dt_ship_research_reqs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.dt_ship_research_reqs (
    shipid integer NOT NULL,
    required_researchid integer NOT NULL,
    required_researchlevel smallint NOT NULL
);


ALTER TABLE ng03.dt_ship_research_reqs OWNER TO exileng;

--
-- Name: gm_ai_planets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_ai_planets (
    planetid integer NOT NULL,
    nextupdate timestamp without time zone DEFAULT now() NOT NULL,
    enemysignature integer DEFAULT 0 NOT NULL,
    signaturesent integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_ai_planets OWNER TO exileng;

--
-- Name: gm_ai_watched_planets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_ai_watched_planets (
    planetid integer NOT NULL,
    watched_since timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_ai_watched_planets OWNER TO exileng;

--
-- Name: gm_alliance_invitations; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_invitations (
    allianceid integer NOT NULL,
    userid integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    recruiterid integer,
    declined boolean DEFAULT false NOT NULL,
    replied timestamp without time zone
);


ALTER TABLE ng03.gm_alliance_invitations OWNER TO exileng;

--
-- Name: gm_alliance_money_requests_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_alliance_money_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_alliance_money_requests_id_seq OWNER TO exileng;

--
-- Name: gm_alliance_money_requests; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_money_requests (
    id integer DEFAULT nextval('ng03.gm_alliance_money_requests_id_seq'::regclass) NOT NULL,
    allianceid integer NOT NULL,
    userid integer NOT NULL,
    credits integer NOT NULL,
    description character varying(128) NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    result boolean
);


ALTER TABLE ng03.gm_alliance_money_requests OWNER TO exileng;

--
-- Name: gm_alliance_nap_offers; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_nap_offers (
    allianceid integer NOT NULL,
    targetallianceid integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    recruiterid integer,
    declined boolean DEFAULT false NOT NULL,
    replied timestamp without time zone,
    guarantee integer DEFAULT 0 NOT NULL,
    guarantee_asked integer DEFAULT 0 NOT NULL,
    break_interval interval DEFAULT '24:00:00'::interval NOT NULL
);


ALTER TABLE ng03.gm_alliance_nap_offers OWNER TO exileng;

--
-- Name: gm_alliance_naps; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_naps (
    allianceid1 integer NOT NULL,
    allianceid2 integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    guarantee integer DEFAULT 0 NOT NULL,
    share_locs boolean DEFAULT true NOT NULL,
    share_radars boolean DEFAULT false NOT NULL,
    give_diplomacy_percent smallint DEFAULT 0 NOT NULL,
    break_on timestamp without time zone,
    break_interval interval DEFAULT '24:00:00'::interval NOT NULL
);


ALTER TABLE ng03.gm_alliance_naps OWNER TO exileng;

--
-- Name: gm_alliance_ranks; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_ranks (
    allianceid integer NOT NULL,
    rankid smallint NOT NULL,
    label character varying(32) NOT NULL,
    leader boolean DEFAULT false NOT NULL,
    can_invite_player boolean DEFAULT false NOT NULL,
    can_kick_player boolean DEFAULT false NOT NULL,
    can_create_nap boolean DEFAULT false NOT NULL,
    can_break_nap boolean DEFAULT false NOT NULL,
    can_ask_money boolean DEFAULT false NOT NULL,
    can_see_reports boolean DEFAULT false NOT NULL,
    can_accept_money_requests boolean DEFAULT false NOT NULL,
    can_change_tax_rate boolean DEFAULT false NOT NULL,
    can_mail_alliance boolean DEFAULT false NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    members_displayed boolean DEFAULT false NOT NULL,
    can_manage_description boolean DEFAULT false NOT NULL,
    can_manage_announce boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    can_see_members_info boolean DEFAULT false NOT NULL,
    tax smallint DEFAULT 0 NOT NULL,
    can_order_other_fleets boolean DEFAULT false NOT NULL,
    can_use_alliance_radars boolean DEFAULT false NOT NULL
);


ALTER TABLE ng03.gm_alliance_ranks OWNER TO exileng;

--
-- Name: gm_alliance_reports_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_alliance_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_alliance_reports_id_seq OWNER TO exileng;

--
-- Name: gm_alliance_reports; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_reports (
    id bigint DEFAULT nextval('ng03.gm_alliance_reports_id_seq'::regclass) NOT NULL,
    ownerallianceid integer NOT NULL,
    ownerid integer NOT NULL,
    type smallint NOT NULL,
    subtype smallint DEFAULT 0 NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    read_date timestamp without time zone,
    battleid integer,
    fleetid integer,
    fleet_name character varying(18),
    planetid integer,
    researchid integer,
    ore integer DEFAULT 0 NOT NULL,
    hydrocarbon integer DEFAULT 0 NOT NULL,
    scientists integer DEFAULT 0 NOT NULL,
    soldiers integer DEFAULT 0 NOT NULL,
    workers integer DEFAULT 0 NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    allianceid integer,
    userid integer,
    invasionid integer,
    spyid integer,
    commanderid integer,
    buildingid integer,
    description character varying(128),
    invited_username character varying(20),
    planet_name character varying,
    planet_relation smallint,
    planet_ownername character varying,
    data character varying DEFAULT '{}'::character varying NOT NULL
);


ALTER TABLE ng03.gm_alliance_reports OWNER TO exileng;

--
-- Name: gm_alliance_tributes; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_tributes (
    allianceid integer NOT NULL,
    target_allianceid integer NOT NULL,
    credits integer NOT NULL,
    next_transfer timestamp without time zone DEFAULT (date_trunc('day'::text, now()) + '1 day'::interval) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_alliance_tributes OWNER TO exileng;

--
-- Name: gm_alliance_wallet_logs_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_alliance_wallet_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_alliance_wallet_logs_id_seq OWNER TO exileng;

--
-- Name: gm_alliance_wallet_logs; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_wallet_logs (
    id integer DEFAULT nextval('ng03.gm_alliance_wallet_logs_id_seq'::regclass) NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    allianceid integer NOT NULL,
    userid integer,
    credits integer DEFAULT 0 NOT NULL,
    description character varying(256),
    source character varying(38),
    type smallint DEFAULT 0 NOT NULL,
    destination character varying(38),
    groupid integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_alliance_wallet_logs OWNER TO exileng;

--
-- Name: gm_alliance_wars; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliance_wars (
    allianceid1 integer NOT NULL,
    allianceid2 integer NOT NULL,
    cease_fire_requested integer,
    cease_fire_expire timestamp without time zone,
    created timestamp without time zone DEFAULT now() NOT NULL,
    next_bill timestamp without time zone DEFAULT now(),
    can_fight timestamp without time zone DEFAULT (now() + ng03.static_alliance_war_starting_delay()) NOT NULL
);


ALTER TABLE ng03.gm_alliance_wars OWNER TO exileng;

--
-- Name: gm_alliances_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_alliances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_alliances_id_seq OWNER TO exileng;

--
-- Name: gm_alliances; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_alliances (
    id integer DEFAULT nextval('ng03.gm_alliances_id_seq'::regclass) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    name character varying(32) NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    tag character varying(4) DEFAULT ''::character varying NOT NULL,
    logo_url character varying(255) DEFAULT ''::character varying NOT NULL,
    website_url character varying(255) DEFAULT ''::character varying NOT NULL,
    announce text DEFAULT ''::text NOT NULL,
    max_members integer DEFAULT 30 NOT NULL,
    tax smallint DEFAULT 0 NOT NULL,
    credits bigint DEFAULT 0 NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    previous_score integer DEFAULT 0 NOT NULL,
    score_combat integer DEFAULT 0 NOT NULL,
    defcon smallint DEFAULT 5 NOT NULL,
    chatid integer NOT NULL,
    announce_last_update timestamp without time zone DEFAULT now() NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    last_kick timestamp without time zone DEFAULT now() NOT NULL,
    last_dividends date DEFAULT now() NOT NULL,
    CONSTRAINT alliances_credits_check CHECK ((credits >= 0))
);


ALTER TABLE ng03.gm_alliances OWNER TO exileng;

--
-- Name: gm_battle_fleet_ship_kills; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battle_fleet_ship_kills (
    fleetid bigint NOT NULL,
    shipid integer NOT NULL,
    destroyed_shipid integer DEFAULT 0 NOT NULL,
    count integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_battle_fleet_ship_kills OWNER TO exileng;

--
-- Name: gm_battle_fleet_ships; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battle_fleet_ships (
    fleetid bigint NOT NULL,
    shipid integer NOT NULL,
    before integer DEFAULT 0 NOT NULL,
    after integer DEFAULT 0 NOT NULL,
    killed integer DEFAULT 0 NOT NULL,
    damages integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_battle_fleet_ships OWNER TO exileng;

--
-- Name: gm_battle_fleets_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_battle_fleets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_battle_fleets_id_seq OWNER TO exileng;

--
-- Name: gm_battle_fleets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battle_fleets (
    id bigint DEFAULT nextval('ng03.gm_battle_fleets_id_seq'::regclass) NOT NULL,
    battleid integer NOT NULL,
    owner_id integer,
    owner_name character varying(16) NOT NULL,
    fleet_id integer,
    fleet_name character varying(18) NOT NULL,
    attackonsight boolean DEFAULT true NOT NULL,
    won boolean DEFAULT false NOT NULL,
    mod_shield smallint DEFAULT 0 NOT NULL,
    mod_handling smallint DEFAULT 0 NOT NULL,
    mod_tracking_speed smallint DEFAULT 0 NOT NULL,
    mod_damage smallint DEFAULT 0 NOT NULL,
    alliancetag character varying
);


ALTER TABLE ng03.gm_battle_fleets OWNER TO exileng;

--
-- Name: gm_battle_relations; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battle_relations (
    battleid integer NOT NULL,
    user1 integer NOT NULL,
    user2 integer NOT NULL,
    relation smallint DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.gm_battle_relations OWNER TO exileng;

--
-- Name: gm_battle_ships; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battle_ships (
    battleid integer NOT NULL,
    owner_id integer NOT NULL,
    owner_name character varying(16) NOT NULL,
    fleet_name character varying(18),
    shipid integer NOT NULL,
    before integer DEFAULT 0 NOT NULL,
    after integer DEFAULT 0 NOT NULL,
    killed integer DEFAULT 0 NOT NULL,
    won boolean DEFAULT false NOT NULL,
    damages integer DEFAULT 0 NOT NULL,
    fleet_id integer DEFAULT 0 NOT NULL,
    attacked boolean,
    hull integer DEFAULT 0 NOT NULL,
    shield integer DEFAULT 0 NOT NULL,
    handling integer DEFAULT 0 NOT NULL,
    damage integer DEFAULT 0 NOT NULL,
    tracking integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_battle_ships OWNER TO exileng;

--
-- Name: gm_battles_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_battles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_battles_id_seq OWNER TO exileng;

--
-- Name: gm_battles; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_battles (
    id integer DEFAULT nextval('ng03.gm_battles_id_seq'::regclass) NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    planetid integer NOT NULL,
    rounds smallint DEFAULT 10 NOT NULL,
    key character varying(8) DEFAULT 'key'::character varying NOT NULL
);


ALTER TABLE ng03.gm_battles OWNER TO exileng;

--
-- Name: gm_chat_lines_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_chat_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_chat_lines_id_seq OWNER TO exileng;

--
-- Name: gm_chat_lines; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_chat_lines (
    id bigint DEFAULT nextval('ng03.gm_chat_lines_id_seq'::regclass) NOT NULL,
    chatid integer NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    message character varying(512) NOT NULL,
    action smallint DEFAULT 0,
    login character varying(16) NOT NULL,
    allianceid integer,
    userid integer
);


ALTER TABLE ng03.gm_chat_lines OWNER TO exileng;

--
-- Name: gm_chat_online_profiles; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_chat_online_profiles (
    chatid integer NOT NULL,
    userid integer NOT NULL,
    lastactivity timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_chat_online_profiles OWNER TO exileng;

--
-- Name: gm_chat_profiles; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_chat_profiles (
    channelid integer NOT NULL,
    userid integer NOT NULL,
    joined timestamp without time zone DEFAULT now() NOT NULL,
    lastactivity timestamp without time zone DEFAULT now() NOT NULL,
    rights integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_chat_profiles OWNER TO exileng;

--
-- Name: gm_chats_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_chats_id_seq OWNER TO exileng;

--
-- Name: gm_chats; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_chats (
    id integer DEFAULT nextval('ng03.gm_chats_id_seq'::regclass) NOT NULL,
    name character varying(24),
    password character varying(16) DEFAULT ''::character varying NOT NULL,
    topic character varying(128) DEFAULT ''::character varying NOT NULL,
    public boolean DEFAULT false NOT NULL,
    CONSTRAINT chat_name_check CHECK (((name IS NULL) OR ((name)::text <> ''::text)))
);


ALTER TABLE ng03.gm_chats OWNER TO exileng;

--
-- Name: gm_commanders_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_commanders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_commanders_id_seq OWNER TO exileng;

--
-- Name: gm_commanders; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_commanders (
    id integer DEFAULT nextval('ng03.gm_commanders_id_seq'::regclass) NOT NULL,
    ownerid integer DEFAULT 0 NOT NULL,
    recruited timestamp without time zone,
    name character varying(32) DEFAULT ng03.tool_generate_commander_name() NOT NULL,
    points smallint DEFAULT 10 NOT NULL,
    mod_production_ore real DEFAULT 1.0 NOT NULL,
    mod_production_hydrocarbon real DEFAULT 1.0 NOT NULL,
    mod_production_energy real DEFAULT 1.0 NOT NULL,
    mod_production_workers real DEFAULT 1.0 NOT NULL,
    mod_fleet_damage real DEFAULT 1.0 NOT NULL,
    mod_fleet_speed real DEFAULT 1.0 NOT NULL,
    mod_fleet_shield real DEFAULT 1.0 NOT NULL,
    mod_fleet_handling real DEFAULT 1.0 NOT NULL,
    mod_fleet_tracking_speed real DEFAULT 1.0 NOT NULL,
    mod_fleet_signature real DEFAULT 1.0 NOT NULL,
    mod_construction_speed_buildings real DEFAULT 1.0 NOT NULL,
    mod_construction_speed_ships real DEFAULT 1.0 NOT NULL,
    mod_recycling real DEFAULT 1.0 NOT NULL,
    can_be_fired boolean DEFAULT true NOT NULL,
    salary integer DEFAULT 0 NOT NULL,
    delete_on_reset boolean DEFAULT true NOT NULL,
    added timestamp without time zone DEFAULT now() NOT NULL,
    salary_increases smallint DEFAULT 0 NOT NULL,
    salary_last_increase timestamp without time zone DEFAULT now() NOT NULL,
    mod_research_effectiveness real DEFAULT 1.0 NOT NULL,
    mod_fleet_hull integer DEFAULT 0 NOT NULL,
    last_training timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_commanders OWNER TO exileng;

--
-- Name: gm_fleet_route_waypoints_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_fleet_route_waypoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_fleet_route_waypoints_id_seq OWNER TO exileng;

--
-- Name: gm_fleet_route_waypoints; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_fleet_route_waypoints (
    id bigint DEFAULT nextval('ng03.gm_fleet_route_waypoints_id_seq'::regclass) NOT NULL,
    next_waypointid bigint,
    routeid integer NOT NULL,
    action smallint NOT NULL,
    waittime smallint DEFAULT 0 NOT NULL,
    planetid integer,
    ore integer,
    hydrocarbon integer,
    scientists integer,
    soldiers integer,
    workers integer
);


ALTER TABLE ng03.gm_fleet_route_waypoints OWNER TO exileng;

--
-- Name: gm_fleet_routes_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_fleet_routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_fleet_routes_id_seq OWNER TO exileng;

--
-- Name: gm_fleet_routes; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_fleet_routes (
    id integer DEFAULT nextval('ng03.gm_fleet_routes_id_seq'::regclass) NOT NULL,
    ownerid integer,
    name character varying(32) NOT NULL,
    repeat boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL,
    last_used timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_fleet_routes OWNER TO exileng;

--
-- Name: gm_fleet_ships; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_fleet_ships (
    fleetid integer NOT NULL,
    shipid integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.gm_fleet_ships OWNER TO exileng;

--
-- Name: gm_fleets_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_fleets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_fleets_id_seq OWNER TO exileng;

--
-- Name: gm_fleets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_fleets (
    id integer DEFAULT nextval('ng03.gm_fleets_id_seq'::regclass) NOT NULL,
    ownerid integer NOT NULL,
    uid integer DEFAULT 0 NOT NULL,
    name character varying(18) NOT NULL,
    commanderid integer,
    planetid integer,
    dest_planetid integer,
    action smallint DEFAULT 0 NOT NULL,
    action_start_time timestamp without time zone,
    action_end_time timestamp without time zone,
    attackonsight boolean DEFAULT false NOT NULL,
    engaged boolean DEFAULT false NOT NULL,
    cargo_capacity integer DEFAULT 0 NOT NULL,
    cargo_ore integer DEFAULT 0 NOT NULL,
    cargo_hydrocarbon integer DEFAULT 0 NOT NULL,
    cargo_workers integer DEFAULT 0 NOT NULL,
    cargo_scientists integer DEFAULT 0 NOT NULL,
    cargo_soldiers integer DEFAULT 0 NOT NULL,
    size integer DEFAULT 0 NOT NULL,
    speed integer DEFAULT 0 NOT NULL,
    signature integer DEFAULT 0 NOT NULL,
    military_signature integer DEFAULT 0 NOT NULL,
    real_signature integer DEFAULT 0 NOT NULL,
    recycler_output integer DEFAULT 0 NOT NULL,
    idle_since timestamp without time zone,
    droppods integer DEFAULT 0 NOT NULL,
    long_distance_capacity integer DEFAULT 0 NOT NULL,
    firepower bigint DEFAULT 0 NOT NULL,
    score bigint DEFAULT 0 NOT NULL,
    next_waypointid bigint,
    mod_speed smallint DEFAULT 0 NOT NULL,
    mod_shield smallint DEFAULT 0 NOT NULL,
    mod_handling smallint DEFAULT 0 NOT NULL,
    mod_tracking_speed smallint DEFAULT 0 NOT NULL,
    mod_damage smallint DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 1.0 NOT NULL,
    mod_signature real DEFAULT 1.0 NOT NULL,
    upkeep integer DEFAULT 0 NOT NULL,
    recycler_percent real DEFAULT 0 NOT NULL,
    categoryid smallint DEFAULT 0 NOT NULL,
    required_vortex_strength integer DEFAULT 0 NOT NULL,
    leadership bigint DEFAULT 0 NOT NULL,
    shared boolean DEFAULT false NOT NULL,
    CONSTRAINT fleets_resources CHECK (((cargo_ore >= 0) AND (cargo_hydrocarbon >= 0) AND (cargo_scientists >= 0) AND (cargo_soldiers >= 0) AND (cargo_workers >= 0) AND (cargo_capacity >= 0)))
);


ALTER TABLE ng03.gm_fleets OWNER TO exileng;

--
-- Name: gm_galaxies; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_galaxies (
    id smallint NOT NULL,
    colonies integer DEFAULT 0 NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    allow_new_players boolean DEFAULT true NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    reserved_for_gameover boolean DEFAULT false NOT NULL,
    planets integer DEFAULT 0 NOT NULL,
    protected_until timestamp without time zone,
    has_merchants boolean DEFAULT true NOT NULL,
    traded_ore bigint DEFAULT 0 NOT NULL,
    traded_hydrocarbon bigint DEFAULT 0 NOT NULL,
    price_ore real DEFAULT 120 NOT NULL,
    price_hydrocarbon real DEFAULT 160 NOT NULL
);


ALTER TABLE ng03.gm_galaxies OWNER TO exileng;

--
-- Name: gm_invasions_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_invasions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_invasions_id_seq OWNER TO exileng;

--
-- Name: gm_invasions; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_invasions (
    id integer DEFAULT nextval('ng03.gm_invasions_id_seq'::regclass) NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    planet_id integer NOT NULL,
    planet_name character varying(32) NOT NULL,
    attacker_name character varying(16) NOT NULL,
    defender_name character varying(16) NOT NULL,
    attacker_succeeded boolean NOT NULL,
    soldiers_total integer NOT NULL,
    soldiers_lost integer NOT NULL,
    def_scientists_total integer NOT NULL,
    def_scientists_lost integer NOT NULL,
    def_soldiers_total integer NOT NULL,
    def_soldiers_lost integer NOT NULL,
    def_workers_total integer NOT NULL,
    def_workers_lost integer NOT NULL
);


ALTER TABLE ng03.gm_invasions OWNER TO exileng;

--
-- Name: gm_log_markets_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_log_markets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_log_markets_id_seq OWNER TO exileng;

--
-- Name: gm_log_markets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_markets (
    id bigint DEFAULT nextval('ng03.gm_log_markets_id_seq'::regclass) NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    ore_sold integer DEFAULT 0,
    hydrocarbon_sold integer DEFAULT 0 NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    username character varying(16),
    workers_sold integer DEFAULT 0 NOT NULL,
    scientists_sold integer DEFAULT 0 NOT NULL,
    soldiers_sold integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_log_markets OWNER TO exileng;

--
-- Name: gm_log_money_transfers; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_money_transfers (
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    senderid integer,
    sendername character varying(20) NOT NULL,
    toid integer,
    toname character varying(16),
    credits integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_log_money_transfers OWNER TO exileng;

--
-- Name: gm_log_multi_warnings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_multi_warnings (
    id bigint NOT NULL,
    withid bigint NOT NULL
);


ALTER TABLE ng03.gm_log_multi_warnings OWNER TO exileng;

--
-- Name: gm_log_planet_owners_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_log_planet_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_log_planet_owners_id_seq OWNER TO exileng;

--
-- Name: gm_log_planet_owners; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_planet_owners (
    id integer DEFAULT nextval('ng03.gm_log_planet_owners_id_seq'::regclass) NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    planetid integer NOT NULL,
    ownerid integer,
    newownerid integer
);


ALTER TABLE ng03.gm_log_planet_owners OWNER TO exileng;

--
-- Name: gm_log_process_errors_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_log_process_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_log_process_errors_id_seq OWNER TO exileng;

--
-- Name: gm_log_process_errors; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_process_errors (
    id integer DEFAULT nextval('ng03.gm_log_process_errors_id_seq'::regclass) NOT NULL,
    procedure character varying NOT NULL,
    added timestamp without time zone DEFAULT now() NOT NULL,
    error character varying NOT NULL
);


ALTER TABLE ng03.gm_log_process_errors OWNER TO exileng;

--
-- Name: gm_log_profile_actions; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_profile_actions (
    userid integer NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    credits integer NOT NULL,
    credits_delta integer NOT NULL,
    buildingid integer,
    shipid integer,
    quantity integer,
    fleetid integer,
    planetid integer,
    ore integer,
    hydrocarbon integer,
    to_alliance integer,
    to_user integer,
    leave_alliance integer,
    spyid integer,
    scientists integer,
    soldiers integer,
    researchid integer,
    login timestamp without time zone
);


ALTER TABLE ng03.gm_log_profile_actions OWNER TO exileng;

--
-- Name: gm_log_profile_alliances; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_profile_alliances (
    userid integer NOT NULL,
    joined timestamp without time zone NOT NULL,
    "left" timestamp without time zone NOT NULL,
    taxes_paid bigint DEFAULT 0 NOT NULL,
    credits_given bigint DEFAULT 0 NOT NULL,
    credits_taken bigint DEFAULT 0 NOT NULL,
    alliance_tag character varying(4) DEFAULT ''::character varying NOT NULL,
    alliance_name character varying(32) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE ng03.gm_log_profile_alliances OWNER TO exileng;

--
-- Name: gm_log_profile_options; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_log_profile_options (
    id integer NOT NULL,
    userid integer NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    action smallint NOT NULL,
    info character varying DEFAULT ''::character varying NOT NULL,
    browser character varying DEFAULT ''::character varying NOT NULL,
    address bigint,
    forwarded_address character varying,
    browserid bigint NOT NULL
);


ALTER TABLE ng03.gm_log_profile_options OWNER TO exileng;

--
-- Name: gm_log_profile_options_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_log_profile_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_log_profile_options_id_seq OWNER TO exileng;

--
-- Name: gm_log_profile_options_id_seq; Type: SEQUENCE OWNED BY; Schema: ng03; Owner: exileng
--

ALTER SEQUENCE ng03.gm_log_profile_options_id_seq OWNED BY ng03.gm_log_profile_options.id;


--
-- Name: gm_mail_addressees_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_mail_addressees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_mail_addressees_id_seq OWNER TO exileng;

--
-- Name: gm_mail_addressees; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_mail_addressees (
    id integer DEFAULT nextval('ng03.gm_mail_addressees_id_seq'::regclass) NOT NULL,
    ownerid integer NOT NULL,
    addresseeid integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_mail_addressees OWNER TO exileng;

--
-- Name: gm_mail_ignorees; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_mail_ignorees (
    userid integer NOT NULL,
    ignored_userid integer NOT NULL,
    added timestamp without time zone DEFAULT now() NOT NULL,
    blocked integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_mail_ignorees OWNER TO exileng;

--
-- Name: gm_mails_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_mails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_mails_id_seq OWNER TO exileng;

--
-- Name: gm_mails; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_mails (
    id integer DEFAULT nextval('ng03.gm_mails_id_seq'::regclass) NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    read_date timestamp without time zone,
    ownerid integer,
    owner character varying(20) NOT NULL,
    senderid integer,
    sender character varying(20) NOT NULL,
    subject character varying(80) NOT NULL,
    body text NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    bbcode boolean DEFAULT false NOT NULL
);


ALTER TABLE ng03.gm_mails OWNER TO exileng;

--
-- Name: gm_market_purchases; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_market_purchases (
    planetid integer NOT NULL,
    ore integer DEFAULT 0 NOT NULL,
    hydrocarbon integer DEFAULT 0 NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    delivery_time timestamp without time zone NOT NULL,
    ore_price smallint DEFAULT 0 NOT NULL,
    hydrocarbon_price smallint DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_market_purchases OWNER TO exileng;

--
-- Name: gm_market_sales; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_market_sales (
    planetid integer NOT NULL,
    ore integer DEFAULT 0 NOT NULL,
    hydrocarbon integer DEFAULT 0 NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    sale_time timestamp without time zone NOT NULL,
    ore_price smallint DEFAULT 0 NOT NULL,
    hydrocarbon_price smallint DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_market_sales OWNER TO exileng;

--
-- Name: gm_planet_building_pendings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_planet_building_pendings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_planet_building_pendings_id_seq OWNER TO exileng;

--
-- Name: gm_planet_building_pendings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_building_pendings (
    id integer DEFAULT nextval('ng03.gm_planet_building_pendings_id_seq'::regclass) NOT NULL,
    planetid integer DEFAULT 0 NOT NULL,
    buildingid integer DEFAULT 0 NOT NULL,
    start_time timestamp without time zone DEFAULT now() NOT NULL,
    end_time timestamp without time zone,
    loop boolean DEFAULT false NOT NULL
);


ALTER TABLE ng03.gm_planet_building_pendings OWNER TO exileng;

--
-- Name: gm_planet_buildings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_buildings (
    planetid integer DEFAULT 0 NOT NULL,
    buildingid integer DEFAULT 0 NOT NULL,
    quantity smallint DEFAULT (1)::smallint NOT NULL,
    destroy_datetime timestamp without time zone,
    disabled smallint DEFAULT 0 NOT NULL,
    CONSTRAINT planet_buildings_disabled_strict_positive CHECK ((disabled >= 0))
);


ALTER TABLE ng03.gm_planet_buildings OWNER TO exileng;

--
-- Name: gm_planet_energy_transfers; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_energy_transfers (
    planetid integer NOT NULL,
    target_planetid integer NOT NULL,
    energy integer DEFAULT 0 NOT NULL,
    effective_energy integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    activation_datetime timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ng03.gm_planet_energy_transfers OWNER TO exileng;

--
-- Name: gm_planet_ship_pendings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_planet_ship_pendings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_planet_ship_pendings_id_seq OWNER TO exileng;

--
-- Name: gm_planet_ship_pendings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_ship_pendings (
    id integer DEFAULT nextval('ng03.gm_planet_ship_pendings_id_seq'::regclass) NOT NULL,
    planetid integer NOT NULL,
    shipid integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    quantity integer DEFAULT 1 NOT NULL,
    recycle boolean DEFAULT false NOT NULL,
    take_resources boolean DEFAULT false NOT NULL
);


ALTER TABLE ng03.gm_planet_ship_pendings OWNER TO exileng;

--
-- Name: gm_planet_ships; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_ships (
    planetid integer NOT NULL,
    shipid integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


ALTER TABLE ng03.gm_planet_ships OWNER TO exileng;

--
-- Name: gm_planet_trainings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_planet_trainings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_planet_trainings_id_seq OWNER TO exileng;

--
-- Name: gm_planet_trainings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planet_trainings (
    id integer DEFAULT nextval('ng03.gm_planet_trainings_id_seq'::regclass) NOT NULL,
    planetid integer NOT NULL,
    start_time timestamp without time zone DEFAULT now(),
    end_time timestamp without time zone,
    scientists integer DEFAULT 0 NOT NULL,
    soldiers integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_planet_trainings OWNER TO exileng;

--
-- Name: gm_planets_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_planets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_planets_id_seq OWNER TO exileng;

--
-- Name: gm_planets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_planets (
    id integer DEFAULT nextval('ng03.gm_planets_id_seq'::regclass) NOT NULL,
    ownerid integer,
    commanderid integer,
    name character varying(32) DEFAULT ''::character varying NOT NULL,
    galaxy smallint DEFAULT (0)::smallint NOT NULL,
    sector smallint DEFAULT (0)::smallint NOT NULL,
    planet smallint DEFAULT (0)::smallint NOT NULL,
    warp_to integer,
    planet_floor smallint DEFAULT 85 NOT NULL,
    planet_space smallint DEFAULT 10 NOT NULL,
    planet_pct_ore smallint DEFAULT 60 NOT NULL,
    planet_pct_hydrocarbon smallint DEFAULT 60 NOT NULL,
    pct_ore smallint DEFAULT 60 NOT NULL,
    pct_hydrocarbon smallint DEFAULT 60 NOT NULL,
    floor smallint DEFAULT (85)::smallint NOT NULL,
    space smallint DEFAULT (10)::smallint NOT NULL,
    floor_occupied smallint DEFAULT (0)::smallint NOT NULL,
    space_occupied smallint DEFAULT (0)::smallint NOT NULL,
    score bigint DEFAULT 0 NOT NULL,
    ore integer DEFAULT 0 NOT NULL,
    ore_capacity integer DEFAULT 0 NOT NULL,
    ore_production integer DEFAULT 0 NOT NULL,
    ore_production_raw integer DEFAULT 0 NOT NULL,
    hydrocarbon integer DEFAULT 0 NOT NULL,
    hydrocarbon_capacity integer DEFAULT 0 NOT NULL,
    hydrocarbon_production integer DEFAULT 0 NOT NULL,
    hydrocarbon_production_raw integer DEFAULT 0 NOT NULL,
    workers integer DEFAULT 0 NOT NULL,
    workers_capacity integer DEFAULT 0 NOT NULL,
    workers_busy integer DEFAULT 0 NOT NULL,
    scientists integer DEFAULT 0 NOT NULL,
    scientists_capacity integer DEFAULT 0 NOT NULL,
    soldiers integer DEFAULT 0 NOT NULL,
    soldiers_capacity integer DEFAULT 0 NOT NULL,
    energy_consumption integer DEFAULT 0 NOT NULL,
    energy_production integer DEFAULT 0 NOT NULL,
    production_lastupdate timestamp without time zone DEFAULT now(),
    production_frozen boolean DEFAULT false NOT NULL,
    radar_strength smallint DEFAULT 0 NOT NULL,
    radar_jamming smallint DEFAULT 0 NOT NULL,
    spawn_ore integer DEFAULT 0 NOT NULL,
    spawn_hydrocarbon integer DEFAULT 0 NOT NULL,
    orbit_ore integer DEFAULT 0 NOT NULL,
    orbit_hydrocarbon integer DEFAULT 0 NOT NULL,
    mod_production_ore smallint DEFAULT 0 NOT NULL,
    mod_production_hydrocarbon smallint DEFAULT 0 NOT NULL,
    mod_production_energy smallint DEFAULT 0 NOT NULL,
    mod_production_workers smallint DEFAULT 0 NOT NULL,
    mod_construction_speed_buildings smallint DEFAULT 0 NOT NULL,
    mod_construction_speed_ships smallint DEFAULT 0 NOT NULL,
    training_scientists integer DEFAULT 0 NOT NULL,
    training_soldiers integer DEFAULT 0 NOT NULL,
    mood smallint DEFAULT 100 NOT NULL,
    buildings_dilapidation integer DEFAULT 0 NOT NULL,
    previous_buildings_dilapidation integer DEFAULT 0 NOT NULL,
    workers_for_maintenance integer DEFAULT 0 NOT NULL,
    soldiers_for_security integer DEFAULT 0 NOT NULL,
    next_battle timestamp without time zone,
    colonization_datetime timestamp without time zone,
    last_catastrophe timestamp without time zone DEFAULT now() NOT NULL,
    next_training_datetime timestamp without time zone DEFAULT now() NOT NULL,
    recruit_workers boolean DEFAULT true NOT NULL,
    sandworm_activity smallint DEFAULT 0 NOT NULL,
    seismic_activity smallint DEFAULT 0 NOT NULL,
    production_percent real DEFAULT 0 NOT NULL,
    blocus_strength smallint,
    credits_production integer DEFAULT 0 NOT NULL,
    credits_random_production integer DEFAULT 0 NOT NULL,
    mod_research_effectiveness smallint DEFAULT 0 NOT NULL,
    energy_receive_antennas smallint DEFAULT 0 NOT NULL,
    energy_send_antennas smallint DEFAULT 0 NOT NULL,
    energy_receive_links smallint DEFAULT 0 NOT NULL,
    energy_send_links smallint DEFAULT 0 NOT NULL,
    energy integer DEFAULT 0 NOT NULL,
    energy_capacity integer DEFAULT 0 NOT NULL,
    next_planet_update timestamp without time zone,
    upkeep integer DEFAULT 0 NOT NULL,
    shipyard_next_continue timestamp without time zone,
    shipyard_suspended boolean DEFAULT false NOT NULL,
    market_buy_ore_price smallint,
    market_buy_hydrocarbon_price smallint,
    credits_total integer DEFAULT 0 NOT NULL,
    credits_next_update timestamp without time zone DEFAULT now() NOT NULL,
    credits_updates smallint DEFAULT 0 NOT NULL,
    planet_vortex_strength integer DEFAULT 0 NOT NULL,
    vortex_strength integer DEFAULT 0 NOT NULL,
    production_prestige integer DEFAULT 0 NOT NULL,
    planet_stock_ore integer DEFAULT 0 NOT NULL,
    planet_stock_hydrocarbon integer DEFAULT 0 NOT NULL,
    planet_need_ore integer DEFAULT 0 NOT NULL,
    planet_need_hydrocarbon integer DEFAULT 0 NOT NULL,
    buy_ore integer DEFAULT 0 NOT NULL,
    buy_hydrocarbon integer DEFAULT 0 NOT NULL,
    invasion_defense integer DEFAULT 0 NOT NULL,
    min_security_level integer DEFAULT 3 NOT NULL,
    parked_ships_capacity integer DEFAULT 0 NOT NULL,
    CONSTRAINT nav_planet_energy_links_check CHECK ((((energy_receive_links <= 0) OR (energy_receive_links <= energy_receive_antennas)) AND ((energy_send_links <= 0) OR (energy_send_links <= energy_send_antennas)))),
    CONSTRAINT nav_planet_energy_receive_or_send_only CHECK (((energy_receive_links <= 0) OR (energy_send_links <= 0))),
    CONSTRAINT nav_planet_floor_space CHECK (((floor_occupied <= floor) AND (space_occupied <= space))),
    CONSTRAINT nav_planet_min_resources CHECK (((ore >= 0) AND (hydrocarbon >= 0) AND (scientists >= 0) AND (soldiers >= 0) AND (workers >= 0))),
    CONSTRAINT nav_planet_resources_capacity CHECK (((ore_capacity >= ore) AND (hydrocarbon_capacity >= hydrocarbon))),
    CONSTRAINT nav_planet_workers_busy CHECK ((workers_busy <= workers)),
    CONSTRAINT nav_planet_workers_capacity CHECK ((workers_capacity >= workers))
);


ALTER TABLE ng03.gm_planets OWNER TO exileng;

--
-- Name: gm_profile_bounties; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_bounties (
    userid integer NOT NULL,
    bounty bigint DEFAULT 0 NOT NULL,
    reward_time timestamp without time zone DEFAULT (now() + '00:01:00'::interval) NOT NULL
);


ALTER TABLE ng03.gm_profile_bounties OWNER TO exileng;

--
-- Name: gm_profile_connections_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_profile_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_profile_connections_id_seq OWNER TO exileng;

--
-- Name: gm_profile_connections; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_connections (
    id bigint DEFAULT nextval('ng03.gm_profile_connections_id_seq'::regclass) NOT NULL,
    userid integer,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    forwarded_address character varying(64),
    browser character varying(128) DEFAULT ''::character varying NOT NULL,
    address inet NOT NULL,
    browserid bigint NOT NULL,
    disconnected timestamp without time zone
);
ALTER TABLE ONLY ng03.gm_profile_connections ALTER COLUMN datetime SET STATISTICS 0;


ALTER TABLE ng03.gm_profile_connections OWNER TO exileng;

--
-- Name: gm_profile_fleet_categories; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_fleet_categories (
    userid integer NOT NULL,
    category smallint NOT NULL,
    label character varying(32) NOT NULL
);


ALTER TABLE ng03.gm_profile_fleet_categories OWNER TO exileng;

--
-- Name: gm_profile_holidays; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_holidays (
    userid integer NOT NULL,
    start_time timestamp without time zone DEFAULT (now() + '24:00:00'::interval) NOT NULL,
    min_end_time timestamp without time zone,
    end_time timestamp without time zone,
    activated boolean DEFAULT false NOT NULL,
    CONSTRAINT users_holidays_check_end_time CHECK ((end_time >= min_end_time))
);


ALTER TABLE ng03.gm_profile_holidays OWNER TO exileng;

--
-- Name: gm_profile_kills; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_kills (
    userid integer NOT NULL,
    shipid integer NOT NULL,
    killed integer DEFAULT 0 NOT NULL,
    lost integer DEFAULT 0 NOT NULL
);


ALTER TABLE ng03.gm_profile_kills OWNER TO exileng;

--
-- Name: gm_profile_reports_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_profile_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_profile_reports_id_seq OWNER TO exileng;

--
-- Name: gm_profile_reports; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_reports (
    id integer DEFAULT nextval('ng03.gm_profile_reports_id_seq'::regclass) NOT NULL,
    ownerid integer NOT NULL,
    type smallint NOT NULL,
    subtype smallint DEFAULT 0 NOT NULL,
    datetime timestamp without time zone DEFAULT now() NOT NULL,
    read_date timestamp without time zone,
    battleid integer,
    fleetid integer,
    fleet_name character varying(18),
    planetid integer,
    researchid integer,
    ore integer DEFAULT 0 NOT NULL,
    hydrocarbon integer DEFAULT 0 NOT NULL,
    scientists integer DEFAULT 0 NOT NULL,
    soldiers integer DEFAULT 0 NOT NULL,
    workers integer DEFAULT 0 NOT NULL,
    credits integer DEFAULT 0 NOT NULL,
    allianceid integer,
    userid integer,
    invasionid integer,
    spyid integer,
    commanderid integer,
    buildingid integer,
    description character varying(128),
    upkeep_planets integer,
    upkeep_scientists integer,
    upkeep_ships integer,
    upkeep_ships_in_position integer,
    upkeep_ships_parked integer,
    upkeep_soldiers integer,
    upkeep_commanders integer,
    planet_name character varying,
    planet_relation smallint,
    planet_ownername character varying,
    data character varying DEFAULT '{}'::character varying NOT NULL
);


ALTER TABLE ng03.gm_profile_reports OWNER TO exileng;

--
-- Name: gm_profile_research_pendings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_profile_research_pendings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_profile_research_pendings_id_seq OWNER TO exileng;

--
-- Name: gm_profile_research_pendings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_research_pendings (
    id integer DEFAULT nextval('ng03.gm_profile_research_pendings_id_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    researchid integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    looping boolean DEFAULT false NOT NULL
);


ALTER TABLE ng03.gm_profile_research_pendings OWNER TO exileng;

--
-- Name: gm_profile_researches; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profile_researches (
    userid integer NOT NULL,
    researchid integer NOT NULL,
    level smallint DEFAULT 1 NOT NULL,
    expires timestamp without time zone
);


ALTER TABLE ng03.gm_profile_researches OWNER TO exileng;

--
-- Name: gm_profiles; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_profiles (
    id integer NOT NULL,
    privilege integer DEFAULT '-3'::integer NOT NULL,
    login character varying(16),
    password character varying(32),
    lastlogin timestamp without time zone DEFAULT now(),
    regdate timestamp without time zone DEFAULT now() NOT NULL,
    email character varying(128),
    credits integer DEFAULT 3500 NOT NULL,
    credits_bankruptcy smallint DEFAULT ng03.static_profile_bankruptcy_hours(),
    lcid smallint DEFAULT 1036 NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    notes text,
    avatar_url character varying(255) DEFAULT ''::character varying NOT NULL,
    lastplanetid integer,
    deletion_date timestamp without time zone,
    score integer DEFAULT 0 NOT NULL,
    score_prestige bigint DEFAULT 0 NOT NULL,
    score_buildings bigint DEFAULT 0 NOT NULL,
    score_research bigint DEFAULT 0 NOT NULL,
    score_ships bigint DEFAULT 0 NOT NULL,
    alliance_id integer,
    alliance_rank smallint DEFAULT 0 NOT NULL,
    alliance_joined timestamp without time zone,
    alliance_left timestamp without time zone,
    alliance_taxes_paid bigint DEFAULT 0 NOT NULL,
    alliance_credits_given bigint DEFAULT 0 NOT NULL,
    alliance_credits_taken bigint DEFAULT 0 NOT NULL,
    alliance_score_combat integer DEFAULT 0 NOT NULL,
    newpassword character varying(32),
    lastactivity timestamp without time zone,
    planets integer DEFAULT 0 NOT NULL,
    noplanets_since timestamp without time zone,
    last_catastrophe timestamp without time zone DEFAULT now() NOT NULL,
    last_holidays timestamp without time zone,
    previous_score integer DEFAULT 0 NOT NULL,
    timers_enabled boolean DEFAULT true NOT NULL,
    ban_datetime timestamp without time zone,
    ban_expire timestamp without time zone DEFAULT '2009-01-01 17:00:00'::timestamp without time zone,
    ban_reason character varying(128),
    ban_reason_public character varying(128),
    ban_adminuserid integer,
    scientists integer DEFAULT 0 NOT NULL,
    soldiers integer DEFAULT 0 NOT NULL,
    dev_lasterror integer,
    dev_lastnotice integer,
    protection_enabled boolean DEFAULT false NOT NULL,
    protection_colonies_to_unprotect smallint DEFAULT 5 NOT NULL,
    protection_datetime timestamp without time zone DEFAULT (now() + '14 days'::interval) NOT NULL,
    max_colonizable_planets integer DEFAULT 50000 NOT NULL,
    remaining_colonizations integer DEFAULT 100000 NOT NULL,
    upkeep_last_cost integer DEFAULT 0 NOT NULL,
    upkeep_commanders real DEFAULT 0 NOT NULL,
    upkeep_planets real DEFAULT 0 NOT NULL,
    upkeep_scientists real DEFAULT 0 NOT NULL,
    upkeep_soldiers real DEFAULT 0 NOT NULL,
    upkeep_ships real DEFAULT 0 NOT NULL,
    upkeep_ships_in_position real DEFAULT 0 NOT NULL,
    upkeep_ships_parked real DEFAULT 0 NOT NULL,
    wallet_display boolean[],
    resets smallint DEFAULT 0 NOT NULL,
    mod_production_ore real DEFAULT 0 NOT NULL,
    mod_production_hydrocarbon real DEFAULT 0 NOT NULL,
    mod_production_energy real DEFAULT 0 NOT NULL,
    mod_production_workers real DEFAULT 0 NOT NULL,
    mod_construction_speed_buildings real DEFAULT 0 NOT NULL,
    mod_construction_speed_ships real DEFAULT 0 NOT NULL,
    mod_fleet_damage real DEFAULT 0 NOT NULL,
    mod_fleet_speed real DEFAULT 0 NOT NULL,
    mod_fleet_shield real DEFAULT 0 NOT NULL,
    mod_fleet_handling real DEFAULT 0 NOT NULL,
    mod_fleet_tracking_speed real DEFAULT 0 NOT NULL,
    mod_fleet_energy_capacity real DEFAULT 0 NOT NULL,
    mod_fleet_energy_usage real DEFAULT 0 NOT NULL,
    mod_fleet_signature real DEFAULT 0 NOT NULL,
    mod_merchant_buy_price real DEFAULT 0 NOT NULL,
    mod_merchant_sell_price real DEFAULT 0 NOT NULL,
    mod_merchant_speed real DEFAULT 0 NOT NULL,
    mod_upkeep_commanders_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_planets_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_scientists_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_soldiers_cost real DEFAULT 0 NOT NULL,
    mod_upkeep_ships_cost real DEFAULT 0 NOT NULL,
    mod_research_cost real DEFAULT 0 NOT NULL,
    mod_research_time real DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 0 NOT NULL,
    mod_commanders real DEFAULT 0 NOT NULL,
    mod_planets real DEFAULT 0 NOT NULL,
    commanders_loyalty smallint DEFAULT 100 NOT NULL,
    orientation smallint DEFAULT 0 NOT NULL,
    admin_notes text DEFAULT ''::text NOT NULL,
    paid_until timestamp without time zone,
    autosignature character varying(512) DEFAULT ''::character varying,
    game_started timestamp without time zone DEFAULT now() NOT NULL,
    mod_research_effectiveness real DEFAULT 0 NOT NULL,
    mod_energy_transfer_effectiveness real DEFAULT 0 NOT NULL,
    requests bigint DEFAULT 0,
    score_next_update timestamp without time zone DEFAULT (date_trunc('day'::text, now()) + '1 day'::interval) NOT NULL,
    display_alliance_planet_name boolean DEFAULT false NOT NULL,
    score_visibility smallint DEFAULT 0 NOT NULL,
    prestige_points integer DEFAULT 0 NOT NULL,
    mod_prestige_from_buildings real DEFAULT 1.0 NOT NULL,
    displays_ads bigint DEFAULT 0 NOT NULL,
    displays_pages bigint DEFAULT 0 NOT NULL,
    ad_bonus_code integer,
    regaddress inet DEFAULT '0.0.0.0'::inet NOT NULL,
    inframe boolean,
    modf_bounty real DEFAULT 1.0 NOT NULL,
    skin character varying,
    tutorial_first_ship_built boolean DEFAULT false NOT NULL,
    tutorial_first_colonisation_ship_built boolean DEFAULT false NOT NULL,
    leave_alliance_datetime timestamp without time zone,
    production_prestige integer DEFAULT 0 NOT NULL,
    score_visibility_last_change timestamp without time zone DEFAULT (now() - '1 day'::interval) NOT NULL,
    credits_produced bigint DEFAULT 0 NOT NULL,
    mod_prestige_from_ships real DEFAULT 1.0 NOT NULL,
    mod_planet_need_ore real DEFAULT 1.0 NOT NULL,
    mod_planet_need_hydrocarbon real DEFAULT 1.0 NOT NULL,
    mod_fleets real DEFAULT 200 NOT NULL,
    security_level integer DEFAULT 3 NOT NULL,
    prestige_points_refund integer DEFAULT 0 NOT NULL,
    CONSTRAINT users_prestige_points_check CHECK ((prestige_points >= 0)),
    CONSTRAINT users_remaining_colonizations_check CHECK ((remaining_colonizations >= 0))
);


ALTER TABLE ng03.gm_profiles OWNER TO exileng;

--
-- Name: gm_profiles_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_profiles_id_seq OWNER TO exileng;

--
-- Name: gm_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: ng03; Owner: exileng
--

ALTER SEQUENCE ng03.gm_profiles_id_seq OWNED BY ng03.gm_profiles.id;


--
-- Name: gm_spying_buildings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_spying_buildings (
    spy_id integer NOT NULL,
    planet_id integer NOT NULL,
    building_id integer NOT NULL,
    endtime timestamp without time zone,
    quantity smallint
);


ALTER TABLE ng03.gm_spying_buildings OWNER TO exileng;

--
-- Name: gm_spying_planets; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_spying_planets (
    spy_id integer NOT NULL,
    planet_id integer NOT NULL,
    planet_name character varying(32),
    floor smallint NOT NULL,
    space smallint NOT NULL,
    ground integer,
    ore integer,
    hydrocarbon integer,
    workers integer,
    ore_capacity integer,
    hydrocarbon_capacity integer,
    workers_capacity integer,
    ore_production integer,
    hydrocarbon_production integer,
    scientists integer,
    scientists_capacity integer,
    soldiers integer,
    soldiers_capacity integer,
    radar_strength smallint,
    radar_jamming smallint,
    orbit_ore integer,
    orbit_hydrocarbon integer,
    floor_occupied smallint,
    space_occupied smallint,
    owner_name character varying(16),
    energy_consumption integer,
    energy_production integer,
    pct_ore smallint,
    pct_hydrocarbon smallint
);


ALTER TABLE ng03.gm_spying_planets OWNER TO exileng;

--
-- Name: gm_spying_researches; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_spying_researches (
    spy_id integer NOT NULL,
    research_id integer NOT NULL,
    research_level integer NOT NULL
);


ALTER TABLE ng03.gm_spying_researches OWNER TO exileng;

--
-- Name: gm_spyings_id_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.gm_spyings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.gm_spyings_id_seq OWNER TO exileng;

--
-- Name: gm_spyings; Type: TABLE; Schema: ng03; Owner: exileng
--

CREATE TABLE ng03.gm_spyings (
    id integer DEFAULT nextval('ng03.gm_spyings_id_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    credits integer,
    type smallint NOT NULL,
    key character varying(8),
    spotted boolean DEFAULT false NOT NULL,
    level smallint NOT NULL,
    target_id integer,
    target_name character varying(16)
);


ALTER TABLE ng03.gm_spyings OWNER TO exileng;

--
-- Name: npc_fleet_uid_seq; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.npc_fleet_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.npc_fleet_uid_seq OWNER TO exileng;

--
-- Name: stats_requests; Type: SEQUENCE; Schema: ng03; Owner: exileng
--

CREATE SEQUENCE ng03.stats_requests
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ng03.stats_requests OWNER TO exileng;

--
-- Name: vw_dt_building_building_reqs; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_dt_building_building_reqs AS
 SELECT dt_buildings.label AS building,
    b2.label AS required_building
   FROM ((ng03.dt_building_building_reqs
     JOIN ng03.dt_buildings ON ((dt_buildings.id = dt_building_building_reqs.buildingid)))
     JOIN ng03.dt_buildings b2 ON ((b2.id = dt_building_building_reqs.required_buildingid)))
  ORDER BY dt_buildings.label, b2.label;


ALTER TABLE ng03.vw_dt_building_building_reqs OWNER TO exileng;

--
-- Name: vw_dt_building_research_reqs; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_dt_building_research_reqs AS
 SELECT dt_buildings.label AS building,
    dt_researches.label AS research,
    dt_building_research_reqs.required_researchlevel AS level
   FROM ((ng03.dt_building_research_reqs
     JOIN ng03.dt_buildings ON ((dt_buildings.id = dt_building_research_reqs.buildingid)))
     JOIN ng03.dt_researches ON ((dt_researches.id = dt_building_research_reqs.required_researchid)))
  ORDER BY dt_buildings.label, dt_researches.label;


ALTER TABLE ng03.vw_dt_building_research_reqs OWNER TO exileng;

--
-- Name: vw_dt_research_research_reqs; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_dt_research_research_reqs AS
 SELECT r1.label AS research,
    r2.label AS required_research,
    dt_research_research_reqs.required_researchlevel AS level
   FROM ((ng03.dt_research_research_reqs
     JOIN ng03.dt_researches r1 ON ((r1.id = dt_research_research_reqs.researchid)))
     JOIN ng03.dt_researches r2 ON ((r2.id = dt_research_research_reqs.required_researchid)))
  ORDER BY r1.label, r2.label;


ALTER TABLE ng03.vw_dt_research_research_reqs OWNER TO exileng;

--
-- Name: vw_dt_ship_building_reqs; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_dt_ship_building_reqs AS
 SELECT dt_ships.label AS ship,
    dt_buildings.label AS building
   FROM ((ng03.dt_ship_building_reqs
     JOIN ng03.dt_ships ON ((dt_ships.id = dt_ship_building_reqs.shipid)))
     JOIN ng03.dt_buildings ON ((dt_buildings.id = dt_ship_building_reqs.required_buildingid)))
  ORDER BY dt_ships.label, dt_buildings.label;


ALTER TABLE ng03.vw_dt_ship_building_reqs OWNER TO exileng;

--
-- Name: vw_dt_ship_research_reqs; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_dt_ship_research_reqs AS
 SELECT dt_ships.label AS ship,
    dt_researches.label AS research,
    dt_ship_research_reqs.required_researchlevel AS level
   FROM ((ng03.dt_ship_research_reqs
     JOIN ng03.dt_ships ON ((dt_ships.id = dt_ship_research_reqs.shipid)))
     JOIN ng03.dt_researches ON ((dt_researches.id = dt_ship_research_reqs.required_researchid)))
  ORDER BY dt_ships.label, dt_researches.label;


ALTER TABLE ng03.vw_dt_ship_research_reqs OWNER TO exileng;

--
-- Name: vw_gm_alliance_reports; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_alliance_reports AS
 SELECT r.ownerallianceid,
    r.ownerid,
    r.type,
    r.datetime,
    r.battleid,
    r.fleetid,
    r.fleet_name,
    r.planetid,
    r.planet_name,
    r.planet_relation,
    r.planet_ownername,
    gm_planets.galaxy,
    gm_planets.sector,
    gm_planets.planet,
    r.researchid,
    r.read_date,
    r.ore,
    r.hydrocarbon,
    r.credits,
    r.subtype,
    r.scientists,
    r.soldiers,
    r.workers,
    gm_profiles.login AS username,
    gm_alliances.tag AS alliance_tag,
    gm_alliances.name AS alliance_name,
    r.invasionid,
    r.spyid,
    gm_spyings.key AS spy_key,
    r.commanderid,
    c.name,
    r.description,
    u_owner.login,
    r.invited_username,
    r.buildingid
   FROM ((((((ng03.gm_alliance_reports r
     LEFT JOIN ng03.gm_planets ON ((gm_planets.id = r.planetid)))
     JOIN ng03.gm_profiles u_owner ON ((u_owner.id = r.ownerid)))
     LEFT JOIN ng03.gm_profiles ON ((gm_profiles.id = r.userid)))
     LEFT JOIN ng03.gm_alliances ON ((gm_alliances.id = r.allianceid)))
     LEFT JOIN ng03.gm_spyings ON ((gm_spyings.id = r.spyid)))
     LEFT JOIN ng03.gm_commanders c ON ((c.id = r.commanderid)))
  WHERE ((r.datetime <= now()) AND (r.datetime > (now() - '14 days'::interval)));


ALTER TABLE ng03.vw_gm_alliance_reports OWNER TO exileng;

--
-- Name: vw_gm_fleets; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_fleets AS
 SELECT gm_fleets.id,
    gm_fleets.ownerid,
    gm_profiles.login AS owner_name,
    gm_profiles.alliance_id AS owner_alliance_id,
    gm_fleets.name,
    gm_fleets.attackonsight,
    gm_fleets.firepower,
    gm_fleets.engaged,
    gm_fleets.size,
    gm_fleets.signature,
    gm_fleets.real_signature,
    int4((((gm_fleets.speed * gm_fleets.mod_speed))::numeric / 100.0)) AS speed,
    gm_fleets.action,
    int4(date_part('epoch'::text, (now() - (gm_fleets.idle_since)::timestamp with time zone))) AS idle_time,
    int4(date_part('epoch'::text, (gm_fleets.action_end_time - gm_fleets.action_start_time))) AS total_time,
    int4(date_part('epoch'::text, ((gm_fleets.action_end_time)::timestamp with time zone - now()))) AS remaining_time,
    gm_fleets.action_start_time,
    gm_fleets.action_end_time,
    gm_fleets.droppods,
    gm_fleets.commanderid,
    ( SELECT gm_commanders.name
           FROM ng03.gm_commanders
          WHERE (gm_commanders.id = gm_fleets.commanderid)) AS commandername,
    gm_fleets.planetid,
    n1.name AS planet_name,
    n1.galaxy AS planet_galaxy,
    n1.sector AS planet_sector,
    n1.planet AS planet_planet,
    n1.ownerid AS planet_ownerid,
    n1.radar_strength,
    (COALESCE((n1.radar_jamming)::integer, 0))::smallint AS radar_jamming,
    ng03.internal_profile_get_name(n1.ownerid) AS planet_owner_name,
    ng03.internal_profile_get_relation(gm_fleets.ownerid, n1.ownerid) AS planet_owner_relation,
    gm_fleets.dest_planetid AS destplanetid,
    n2.name AS destplanet_name,
    n2.galaxy AS destplanet_galaxy,
    n2.sector AS destplanet_sector,
    n2.planet AS destplanet_planet,
    n2.ownerid AS destplanet_ownerid,
    n2.radar_strength AS destplanet_radar_strength,
    (COALESCE((n2.radar_jamming)::integer, 0))::smallint AS destplanet_radar_jamming,
    ng03.internal_profile_get_name(n2.ownerid) AS destplanet_owner_name,
    ng03.internal_profile_get_relation(gm_fleets.ownerid, n2.ownerid) AS destplanet_owner_relation,
    gm_fleets.cargo_capacity,
    (((((gm_fleets.cargo_capacity - gm_fleets.cargo_ore) - gm_fleets.cargo_hydrocarbon) - gm_fleets.cargo_scientists) - gm_fleets.cargo_soldiers) - gm_fleets.cargo_workers) AS cargo_free,
    gm_fleets.cargo_ore,
    gm_fleets.cargo_hydrocarbon,
    gm_fleets.cargo_scientists,
    gm_fleets.cargo_soldiers,
    gm_fleets.cargo_workers,
    gm_fleets.recycler_output,
    gm_fleets.long_distance_capacity,
    gm_fleets.next_waypointid,
    n1.orbit_ore,
    n1.orbit_hydrocarbon,
    n1.warp_to,
    n1.spawn_ore,
    n1.spawn_hydrocarbon,
    n1.planet_floor,
    n2.planet_floor AS destplanet_planet_floor,
    gm_fleets.categoryid,
    gm_fleets.required_vortex_strength,
    gm_fleets.upkeep,
    gm_fleets.leadership,
    gm_fleets.shared
   FROM (((ng03.gm_fleets
     JOIN ng03.gm_profiles ON ((gm_profiles.id = gm_fleets.ownerid)))
     LEFT JOIN ng03.gm_planets n1 ON ((gm_fleets.planetid = n1.id)))
     LEFT JOIN ng03.gm_planets n2 ON ((gm_fleets.dest_planetid = n2.id)));


ALTER TABLE ng03.vw_gm_fleets OWNER TO exileng;

--
-- Name: vw_gm_friend_radars; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_friend_radars AS
 SELECT friends.userid,
    friends.friend
   FROM ( SELECT u1.id AS userid,
            u2.id AS friend
           FROM ((ng03.gm_profiles u1
             JOIN ng03.gm_alliance_naps naps ON (((u1.alliance_id = naps.allianceid2) AND naps.share_radars)))
             JOIN ng03.gm_profiles u2 ON ((u2.alliance_id = naps.allianceid1)))
        UNION
         SELECT u1.id AS userid,
            u2.id AS friend
           FROM (ng03.gm_profiles u1
             JOIN ng03.gm_profiles u2 ON (((u1.alliance_id = u2.alliance_id) OR ((u2.alliance_id IS NULL) AND (u1.id = u2.id)))))) friends;


ALTER TABLE ng03.vw_gm_friend_radars OWNER TO exileng;

--
-- Name: vw_gm_friends; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_friends AS
 SELECT friends.userid,
    friends.friend
   FROM ( SELECT u1.id AS userid,
            u2.id AS friend
           FROM ((ng03.gm_profiles u1
             JOIN ng03.gm_alliance_naps naps ON ((u1.alliance_id = naps.allianceid1)))
             JOIN ng03.gm_profiles u2 ON ((u2.alliance_id = naps.allianceid2)))
        UNION
         SELECT u1.id AS userid,
            u2.id AS friend
           FROM (ng03.gm_profiles u1
             JOIN ng03.gm_profiles u2 ON (((u1.alliance_id = u2.alliance_id) OR ((u2.alliance_id IS NULL) AND (u1.id = u2.id)) OR (u1.privilege = '-50'::integer) OR (u2.privilege = '-50'::integer))))) friends;


ALTER TABLE ng03.vw_gm_friends OWNER TO exileng;

--
-- Name: vw_gm_moving_fleets; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_moving_fleets AS
 SELECT gm_profiles.id AS userid,
    gm_fleets.id,
    gm_fleets.name,
    gm_fleets.attackonsight,
    gm_fleets.firepower,
    gm_fleets.engaged,
    gm_fleets.size,
    gm_fleets.signature,
    gm_fleets.upkeep,
    gm_fleets.speed,
    COALESCE(gm_fleets.remaining_time, 0) AS remaining_time,
    COALESCE(gm_fleets.total_time, 0) AS total_time,
    gm_fleets.ownerid,
    ng03.internal_profile_get_relation(gm_profiles.id, gm_fleets.ownerid) AS owner_relation,
    gm_fleets.owner_name,
    gm_fleets.owner_alliance_id,
    gm_fleets.planetid,
    gm_fleets.planet_name,
    gm_fleets.planet_galaxy,
    gm_fleets.planet_sector,
    gm_fleets.planet_planet,
    gm_fleets.planet_ownerid,
    gm_fleets.radar_jamming,
    gm_fleets.planet_owner_name,
    ng03.internal_profile_get_relation(gm_profiles.id, gm_fleets.planet_ownerid) AS planet_owner_relation,
    gm_fleets.destplanetid,
    gm_fleets.destplanet_name,
    gm_fleets.destplanet_galaxy,
    gm_fleets.destplanet_sector,
    gm_fleets.destplanet_planet,
    gm_fleets.destplanet_ownerid,
    gm_fleets.destplanet_radar_jamming,
    gm_fleets.destplanet_owner_name,
    ng03.internal_profile_get_relation(gm_profiles.id, gm_fleets.destplanet_ownerid) AS destplanet_owner_relation,
    ng03.internal_profile_get_sector_radar_strength(gm_profiles.id, (gm_fleets.planet_galaxy)::integer, (gm_fleets.planet_sector)::integer) AS from_radarstrength,
    ng03.internal_profile_get_sector_radar_strength(gm_profiles.id, (gm_fleets.destplanet_galaxy)::integer, (gm_fleets.destplanet_sector)::integer) AS to_radarstrength,
    gm_fleets.cargo_capacity,
    gm_fleets.cargo_free,
    gm_fleets.cargo_ore,
    gm_fleets.cargo_hydrocarbon,
    gm_fleets.cargo_scientists,
    gm_fleets.cargo_soldiers,
    gm_fleets.cargo_workers,
    gm_fleets.next_waypointid,
    gm_fleets.categoryid,
    gm_fleets.leadership,
    gm_fleets.shared
   FROM ng03.gm_profiles,
    ng03.vw_gm_fleets gm_fleets
  WHERE ((gm_fleets.action = 1) OR (gm_fleets.action = '-1'::integer))
  ORDER BY gm_fleets.ownerid, COALESCE(gm_fleets.remaining_time, 0);


ALTER TABLE ng03.vw_gm_moving_fleets OWNER TO exileng;

--
-- Name: vw_gm_planet_building_pendings; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_planet_building_pendings AS
 SELECT gm_planets.id AS planetid,
    gm_planet_building_pendings.buildingid,
    int4(date_part('epoch'::text, ((gm_planet_building_pendings.end_time)::timestamp with time zone - now()))) AS remaining_time,
    false AS destroying
   FROM (ng03.gm_planets
     JOIN ng03.gm_planet_building_pendings ON ((gm_planet_building_pendings.planetid = gm_planets.id)))
UNION
 SELECT gm_planet_buildings.planetid,
    gm_planet_buildings.buildingid,
    int4(date_part('epoch'::text, ((gm_planet_buildings.destroy_datetime)::timestamp with time zone - now()))) AS remaining_time,
    true AS destroying
   FROM (ng03.gm_planet_buildings
     JOIN ng03.dt_buildings ON (((dt_buildings.id = gm_planet_buildings.buildingid) AND (NOT dt_buildings.is_planet_element))))
  WHERE (gm_planet_buildings.destroy_datetime IS NOT NULL);


ALTER TABLE ng03.vw_gm_planet_building_pendings OWNER TO exileng;

--
-- Name: vw_gm_planet_buildings; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_planet_buildings AS
 SELECT p.id AS planetid,
    p.ownerid,
    b.id,
    b.category,
    b.name,
    b.label,
    b.description,
    b.cost_ore,
    b.cost_hydrocarbon,
    b.cost_credits,
    b.cost_energy,
    b.cost_prestige,
    b.workers,
    b.energy_consumption,
    b.energy_production,
    b.floor,
    b.space,
    (((((LEAST(1.0, ((1.0 * (p.energy_production)::numeric) / (GREATEST(p.energy_consumption, 1))::numeric)))::double precision * p.production_percent) * ((p.pct_ore)::numeric)::double precision) / (100.0)::double precision) * ((b.production_ore)::numeric)::double precision) AS production_ore,
    (((((LEAST(1.0, ((1.0 * (p.energy_production)::numeric) / (GREATEST(p.energy_consumption, 1))::numeric)))::double precision * p.production_percent) * ((p.pct_hydrocarbon)::numeric)::double precision) / (100.0)::double precision) * ((b.production_hydrocarbon)::numeric)::double precision) AS production_hydrocarbon,
    b.storage_ore,
    b.storage_hydrocarbon,
    b.storage_workers,
        CASE
            WHEN b.buildable THEN b.construction_maximum
            ELSE (0)::smallint
        END AS construction_maximum,
    ng03.tool_compute_building_building_time(b.construction_time, b.construction_time_exp_per_building,
        CASE
            WHEN (b.construction_time_exp_per_building <> (1.0)::double precision) THEN (( SELECT gm_planet_buildings.quantity
               FROM ng03.gm_planet_buildings
              WHERE ((gm_planet_buildings.planetid = p.id) AND (gm_planet_buildings.buildingid = b.id))))::integer
            ELSE 0
        END, (p.mod_construction_speed_buildings)::integer) AS construction_time,
    b.destroyable,
    b.mod_production_ore,
    b.mod_production_hydrocarbon,
    b.mod_production_energy,
    b.mod_production_workers,
    b.mod_construction_speed_buildings,
    b.mod_construction_speed_ships,
    b.storage_scientists,
    b.storage_soldiers,
    b.radar_strength,
    b.radar_jamming,
    b.is_planet_element,
    COALESCE(( SELECT gm_planet_buildings.quantity
           FROM ng03.gm_planet_buildings
          WHERE ((gm_planet_buildings.buildingid = b.id) AND (gm_planet_buildings.planetid = p.id))), int2(0)) AS quantity,
    ( SELECT int4(date_part('epoch'::text, ((gm_planet_building_pendings.end_time)::timestamp with time zone - now()))) AS int4
           FROM ng03.gm_planet_building_pendings
          WHERE ((gm_planet_building_pendings.buildingid = b.id) AND (gm_planet_building_pendings.planetid = p.id))) AS build_status,
    (NOT (EXISTS ( SELECT dt_building_building_reqs.required_buildingid
           FROM ng03.dt_building_building_reqs
          WHERE ((dt_building_building_reqs.buildingid = b.id) AND (NOT (dt_building_building_reqs.required_buildingid IN ( SELECT gm_planet_buildings.buildingid
                   FROM ng03.gm_planet_buildings
                  WHERE ((gm_planet_buildings.planetid = p.id) AND ((gm_planet_buildings.quantity > 1) OR ((gm_planet_buildings.quantity >= 1) AND (gm_planet_buildings.destroy_datetime IS NULL))))))))))) AS buildings_requirements_met,
    (NOT (EXISTS ( SELECT dt_building_research_reqs.required_researchid,
            dt_building_research_reqs.required_researchlevel
           FROM ng03.dt_building_research_reqs
          WHERE ((dt_building_research_reqs.buildingid = b.id) AND (NOT (dt_building_research_reqs.required_researchid IN ( SELECT gm_profile_researches.researchid
                   FROM ng03.gm_profile_researches
                  WHERE ((gm_profile_researches.userid = p.ownerid) AND (gm_profile_researches.level >= dt_building_research_reqs.required_researchlevel))))))))) AS research_requirements_met,
    ( SELECT int4(date_part('epoch'::text, ((gm_planet_buildings.destroy_datetime)::timestamp with time zone - now()))) AS int4
           FROM ng03.gm_planet_buildings
          WHERE ((gm_planet_buildings.buildingid = b.id) AND (gm_planet_buildings.planetid = p.id))) AS destruction_time,
    COALESCE(( SELECT GREATEST(0, (
                CASE
                    WHEN ((gm_planet_buildings.destroy_datetime IS NULL) OR b.active_when_destroying) THEN (gm_planet_buildings.quantity)::integer
                    ELSE (gm_planet_buildings.quantity - 1)
                END - gm_planet_buildings.disabled), 0) AS "greatest"
           FROM ng03.gm_planet_buildings
          WHERE ((gm_planet_buildings.buildingid = b.id) AND (gm_planet_buildings.planetid = p.id))), 0) AS working_quantity,
    b.upkeep,
    b.buildable
   FROM ng03.gm_planets p,
    ng03.dt_buildings b
  ORDER BY b.category, b.id;


ALTER TABLE ng03.vw_gm_planet_buildings OWNER TO exileng;

--
-- Name: vw_gm_planet_ship_pendings; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_planet_ship_pendings AS
 SELECT gm_planet_ship_pendings.id,
    p.id AS planetid,
    p.name AS planetname,
    p.ownerid,
    p.galaxy,
    p.sector,
    p.planet,
    COALESCE(dt_ships.new_shipid, gm_planet_ship_pendings.shipid) AS shipid,
    gm_planet_ship_pendings.start_time,
    gm_planet_ship_pendings.end_time,
    (int8(gm_planet_ship_pendings.quantity) * COALESCE(int4(date_part('epoch'::text, ((gm_planet_ship_pendings.end_time)::timestamp with time zone - now()))), int4(((
        CASE
            WHEN gm_planet_ship_pendings.recycle THEN ng03.static_planet_ship_recycling_coeff()
            ELSE (1)::real
        END * (((dt_ships.construction_time * 100))::numeric)::double precision) / ((p.mod_construction_speed_ships)::numeric)::double precision)))) AS remaining_time,
    gm_planet_ship_pendings.quantity,
    gm_planet_ship_pendings.recycle,
    dt_ships.required_shipid,
    dt_ships.cost_ore,
    dt_ships.cost_hydrocarbon,
    dt_ships.cost_credits,
    dt_ships.crew,
    dt_ships.cost_energy,
    dt_ships.workers
   FROM ((ng03.gm_planets p
     JOIN ng03.gm_planet_ship_pendings ON ((gm_planet_ship_pendings.planetid = p.id)))
     LEFT JOIN ng03.dt_ships ON ((gm_planet_ship_pendings.shipid = dt_ships.id)))
  ORDER BY p.id, (upper((dt_ships.label)::text));


ALTER TABLE ng03.vw_gm_planet_ship_pendings OWNER TO exileng;

--
-- Name: vw_gm_planet_ships; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_planet_ships AS
 SELECT p.id AS planetid,
    p.ownerid AS planet_ownerid,
    dt_ships.id,
    dt_ships.category,
    dt_ships.name,
    dt_ships.label,
    dt_ships.description,
    dt_ships.cost_ore,
    dt_ships.cost_hydrocarbon,
    dt_ships.cost_energy,
    dt_ships.cost_credits,
    dt_ships.cost_prestige,
    dt_ships.upkeep,
    dt_ships.workers,
    dt_ships.crew,
    dt_ships.capacity,
    int4((((dt_ships.construction_time)::numeric * 100.0) / (p.mod_construction_speed_ships)::numeric)) AS construction_time,
    COALESCE(s2.hull, dt_ships.hull) AS hull,
    COALESCE(s2.shield, dt_ships.shield) AS shield,
    COALESCE((((s2.weapon_dmg_em + s2.weapon_dmg_explosive) + s2.weapon_dmg_kinetic) + s2.weapon_dmg_thermal), (((dt_ships.weapon_dmg_em + dt_ships.weapon_dmg_explosive) + dt_ships.weapon_dmg_kinetic) + dt_ships.weapon_dmg_thermal)) AS weapon_power,
    COALESCE(s2.weapon_ammo, dt_ships.weapon_ammo) AS weapon_ammo,
    COALESCE(s2.weapon_tracking_speed, dt_ships.weapon_tracking_speed) AS weapon_tracking_speed,
    COALESCE(s2.weapon_turrets, dt_ships.weapon_turrets) AS weapon_turrets,
    COALESCE(s2.signature, dt_ships.signature) AS signature,
    COALESCE(s2.speed, dt_ships.speed) AS speed,
    COALESCE(s2.handling, dt_ships.handling) AS handling,
    dt_ships.buildingid,
    COALESCE(s2.recycler_output, dt_ships.recycler_output) AS recycler_output,
    COALESCE(s2.droppods, dt_ships.droppods) AS droppods,
    COALESCE(s2.long_distance_capacity, dt_ships.long_distance_capacity) AS long_distance_capacity,
    COALESCE(gm_planet_ships.quantity, (int2(0))::integer) AS quantity,
    dt_ships.required_shipid,
    dt_ships.new_shipid,
    COALESCE(( SELECT planet_ships_1.quantity
           FROM ng03.gm_planet_ships planet_ships_1
          WHERE ((planet_ships_1.planetid = p.id) AND (planet_ships_1.shipid = dt_ships.required_shipid))), 0) AS required_ship_count,
    (NOT (EXISTS ( SELECT dt_ship_building_reqs.required_buildingid
           FROM ng03.dt_ship_building_reqs
          WHERE ((dt_ship_building_reqs.shipid = COALESCE(dt_ships.new_shipid, dt_ships.id)) AND (NOT (dt_ship_building_reqs.required_buildingid IN ( SELECT gm_planet_buildings.buildingid
                   FROM ng03.gm_planet_buildings
                  WHERE (gm_planet_buildings.planetid = p.id)))))))) AS buildings_requirements_met,
    (dt_ships.buildable AND (NOT (EXISTS ( SELECT 1
           FROM ng03.dt_ship_research_reqs
          WHERE ((dt_ship_research_reqs.shipid = COALESCE(dt_ships.new_shipid, dt_ships.id)) AND (NOT (dt_ship_research_reqs.required_researchid IN ( SELECT gm_profile_researches.researchid
                   FROM ng03.gm_profile_researches
                  WHERE ((gm_profile_researches.userid = p.ownerid) AND (gm_profile_researches.level >= dt_ship_research_reqs.required_researchlevel)))))))))) AS research_requirements_met,
    dt_ships.built_per_batch,
    dt_ships.required_vortex_strength,
    dt_ships.leadership AS mod_leadership
   FROM (((ng03.gm_planets p
     CROSS JOIN ng03.dt_ships)
     LEFT JOIN ng03.gm_planet_ships ON (((gm_planet_ships.planetid = p.id) AND (gm_planet_ships.shipid = dt_ships.id))))
     LEFT JOIN ng03.dt_ships s2 ON ((s2.id = dt_ships.new_shipid)))
  ORDER BY dt_ships.category, dt_ships.id;


ALTER TABLE ng03.vw_gm_planet_ships OWNER TO exileng;

--
-- Name: vw_gm_planets; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_planets AS
 SELECT gm_planets.id,
    gm_planets.galaxy,
    gm_planets.sector,
    gm_planets.planet,
    gm_planets.name,
    gm_planets.planet_floor,
    gm_planets.planet_space,
    gm_planets.planet_pct_ore,
    gm_planets.planet_pct_hydrocarbon,
    gm_planets.floor,
    gm_planets.space,
    gm_planets.pct_ore,
    gm_planets.pct_hydrocarbon,
    gm_planets.ownerid,
    gm_planets.commanderid,
    int4(LEAST(((gm_planets.ore)::double precision + (((gm_planets.ore_production)::double precision * date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone))) / (3600.0)::double precision)), (gm_planets.ore_capacity)::double precision)) AS ore,
    int4(LEAST(((gm_planets.hydrocarbon)::double precision + (((gm_planets.hydrocarbon_production)::double precision * date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone))) / (3600.0)::double precision)), (gm_planets.hydrocarbon_capacity)::double precision)) AS hydrocarbon,
    int4(GREATEST((0)::double precision, LEAST(((gm_planets.energy)::double precision + ((((gm_planets.energy_production - gm_planets.energy_consumption))::double precision * date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone))) / (3600.0)::double precision)), (gm_planets.energy_capacity)::double precision))) AS energy,
    int4(LEAST(((gm_planets.workers)::double precision * power(((1.0 + ((gm_planets.mod_production_workers)::numeric / 1000.0)))::double precision, LEAST((date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone)) / (3600.0)::double precision), (1500)::double precision))), (gm_planets.workers_capacity)::double precision)) AS workers,
    gm_planets.ore_capacity,
    gm_planets.hydrocarbon_capacity,
    gm_planets.energy_capacity,
    gm_planets.workers_capacity,
    gm_planets.ore_production,
    gm_planets.hydrocarbon_production,
    gm_planets.energy_consumption,
    gm_planets.energy_production,
    gm_planets.floor_occupied,
    gm_planets.space_occupied,
    gm_planets.workers_busy,
    gm_planets.production_lastupdate,
    gm_planets.mod_production_ore,
    gm_planets.mod_production_hydrocarbon,
    gm_planets.mod_production_energy,
    gm_planets.mod_production_workers,
    gm_planets.mod_construction_speed_buildings,
    gm_planets.mod_construction_speed_ships,
    gm_planets.next_battle,
    gm_planets.scientists,
    gm_planets.scientists_capacity,
    gm_planets.soldiers,
    gm_planets.soldiers_capacity,
    gm_planets.radar_strength,
    gm_planets.radar_jamming,
    gm_planets.colonization_datetime,
    gm_planets.orbit_ore,
    gm_planets.orbit_hydrocarbon,
    gm_planets.score,
    gm_planets.last_catastrophe,
    gm_planets.next_training_datetime,
    gm_planets.production_frozen,
    gm_planets.mood,
    gm_planets.workers_for_maintenance,
    gm_planets.soldiers_for_security,
    gm_planets.recruit_workers,
    gm_planets.buildings_dilapidation,
    gm_planets.previous_buildings_dilapidation,
    gm_planets.production_percent,
    gm_planets.energy_receive_antennas,
    gm_planets.energy_send_antennas,
    gm_planets.energy_receive_links,
    gm_planets.energy_send_links,
    gm_planets.upkeep,
    int4(GREATEST((ng03.static_merchant_stock_min())::double precision, LEAST((ng03.static_merchant_stock_max())::double precision, ((gm_planets.planet_stock_ore)::double precision - (((gm_planets.planet_need_ore)::double precision * date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone))) / (3600.0)::double precision))))) AS planet_stock_ore,
    int4(GREATEST((ng03.static_merchant_stock_min())::double precision, LEAST((ng03.static_merchant_stock_max())::double precision, ((gm_planets.planet_stock_hydrocarbon)::double precision - (((gm_planets.planet_need_hydrocarbon)::double precision * date_part('epoch'::text, (now() - (gm_planets.production_lastupdate)::timestamp with time zone))) / (3600.0)::double precision))))) AS planet_stock_hydrocarbon,
    gm_planets.buy_ore,
    gm_planets.buy_hydrocarbon,
    gm_planets.credits_production,
    gm_planets.credits_random_production,
    gm_planets.production_prestige
   FROM ng03.gm_planets;


ALTER TABLE ng03.vw_gm_planets OWNER TO exileng;

--
-- Name: vw_gm_profile_commanders; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_profile_commanders AS
 SELECT c.id,
    c.ownerid,
    c.name,
    f.id AS fleetid,
    f.name AS fleetname,
    n.id AS planetid,
    n.name AS planetname
   FROM ((ng03.gm_commanders c
     LEFT JOIN ng03.gm_fleets f ON (((f.ownerid = c.ownerid) AND (f.commanderid = c.id))))
     LEFT JOIN ng03.gm_planets n ON (((n.ownerid = c.ownerid) AND (n.commanderid = c.id))))
  WHERE (c.recruited <= now());


ALTER TABLE ng03.vw_gm_profile_commanders OWNER TO exileng;

--
-- Name: vw_gm_profile_relations; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_profile_relations AS
 SELECT u1.id AS user1,
    u2.id AS user2,
        CASE
            WHEN (u1.id = u2.id) THEN int2(2)
            WHEN (u1.alliance_id = u2.alliance_id) THEN int2(1)
            WHEN ((u1.privilege = '-50'::integer) OR (u2.privilege = '-50'::integer)) THEN int2(0)
            WHEN (EXISTS ( SELECT 1
               FROM ng03.gm_alliance_naps
              WHERE ((gm_alliance_naps.allianceid1 = u1.alliance_id) AND (gm_alliance_naps.allianceid2 = u2.alliance_id)))) THEN int2(0)
            ELSE int2('-1'::integer)
        END AS relation
   FROM ng03.gm_profiles u1,
    ng03.gm_profiles u2;


ALTER TABLE ng03.vw_gm_profile_relations OWNER TO exileng;

--
-- Name: vw_gm_profile_reports; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_profile_reports AS
 SELECT r.ownerid,
    r.type,
    r.datetime,
    r.battleid,
    r.fleetid,
    r.fleet_name,
    r.planetid,
    r.planet_name,
    r.planet_relation,
    r.planet_ownername,
    gm_planets.galaxy,
    gm_planets.sector,
    gm_planets.planet,
    r.researchid,
    r.read_date,
    r.ore,
    r.hydrocarbon,
    r.credits,
    r.subtype,
    r.scientists,
    r.soldiers,
    r.workers,
    gm_profiles.login AS username,
    gm_alliances.tag AS alliance_tag,
    gm_alliances.name AS alliance_name,
    r.invasionid,
    r.spyid,
    gm_spyings.key AS spy_key,
    r.commanderid,
    c.name,
    r.description,
    r.buildingid,
    r.upkeep_commanders,
    r.upkeep_planets,
    r.upkeep_scientists,
    r.upkeep_ships,
    r.upkeep_ships_in_position,
    r.upkeep_ships_parked,
    r.upkeep_soldiers
   FROM (((((ng03.gm_profile_reports r
     LEFT JOIN ng03.gm_planets ON ((gm_planets.id = r.planetid)))
     LEFT JOIN ng03.gm_profiles ON ((gm_profiles.id = r.userid)))
     LEFT JOIN ng03.gm_alliances ON ((gm_alliances.id = r.allianceid)))
     LEFT JOIN ng03.gm_spyings ON ((gm_spyings.id = r.spyid)))
     LEFT JOIN ng03.gm_commanders c ON ((c.id = r.commanderid)))
  WHERE ((r.datetime <= now()) AND ((r.read_date IS NULL) OR (r.read_date > (now() - '7 days'::interval))));


ALTER TABLE ng03.vw_gm_profile_reports OWNER TO exileng;

--
-- Name: vw_gm_profile_upkeeps; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_profile_upkeeps AS
 SELECT gm_profiles.id AS userid,
    int4(( SELECT count(*) AS count
           FROM ng03.gm_commanders
          WHERE ((gm_commanders.ownerid = gm_profiles.id) AND (gm_commanders.recruited <= now())))) AS gm_commanders,
    int4(( SELECT COALESCE(sum(gm_commanders.salary), (0)::bigint) AS sum
           FROM ng03.gm_commanders
          WHERE ((gm_commanders.ownerid = gm_profiles.id) AND (gm_commanders.recruited <= now())))) AS commanders_salary,
    int4((( SELECT COALESCE(sum(gm_planets.scientists), (0)::bigint) AS "coalesce"
           FROM ng03.gm_planets
          WHERE (gm_planets.ownerid = gm_profiles.id)) + ( SELECT COALESCE(sum(gm_fleets.cargo_scientists), (0)::bigint) AS "coalesce"
           FROM ng03.gm_fleets
          WHERE (gm_fleets.ownerid = gm_profiles.id)))) AS scientists,
    int4((( SELECT COALESCE(sum(gm_planets.soldiers), (0)::bigint) AS "coalesce"
           FROM ng03.gm_planets
          WHERE (gm_planets.ownerid = gm_profiles.id)) + ( SELECT COALESCE(sum(gm_fleets.cargo_soldiers), (0)::bigint) AS "coalesce"
           FROM ng03.gm_fleets
          WHERE (gm_fleets.ownerid = gm_profiles.id)))) AS soldiers,
    int4(( SELECT count(*) AS count
           FROM ng03.gm_planets
          WHERE ((gm_planets.planet_floor > 0) AND (gm_planets.planet_space > 0) AND (gm_planets.ownerid = gm_profiles.id)))) AS planets,
    int4(( SELECT COALESCE(sum(gm_fleets.upkeep), (0)::bigint) AS "coalesce"
           FROM (ng03.gm_fleets
             LEFT JOIN ng03.gm_planets ON (((gm_planets.id = gm_fleets.planetid) AND (gm_fleets.dest_planetid IS NULL))))
          WHERE ((gm_fleets.ownerid = gm_profiles.id) AND ((gm_planets.ownerid IS NULL) OR ((gm_planets.planet_floor = 0) AND (gm_planets.planet_space = 0)) OR (gm_planets.ownerid = gm_profiles.id) OR (EXISTS ( SELECT 1
                   FROM ng03.vw_gm_friends
                  WHERE ((vw_gm_friends.userid = gm_profiles.id) AND (vw_gm_friends.friend = gm_planets.ownerid)))))))) AS ships_signature,
    int4(( SELECT COALESCE(sum(gm_fleets.upkeep), (0)::bigint) AS "coalesce"
           FROM (ng03.gm_fleets
             LEFT JOIN ng03.gm_planets ON (((gm_planets.id = gm_fleets.planetid) AND (gm_fleets.dest_planetid IS NULL))))
          WHERE ((gm_fleets.ownerid = gm_profiles.id) AND (gm_planets.ownerid IS NOT NULL) AND (gm_planets.planet_floor > 0) AND (gm_planets.planet_space > 0) AND (gm_planets.ownerid <> gm_profiles.id) AND (NOT (EXISTS ( SELECT 1
                   FROM ng03.vw_gm_friends
                  WHERE ((vw_gm_friends.userid = gm_profiles.id) AND (vw_gm_friends.friend = gm_planets.ownerid)))))))) AS ships_in_position_signature,
    int4(( SELECT COALESCE(sum((dt_ships.upkeep * gm_planet_ships.quantity)), (0)::bigint) AS "coalesce"
           FROM ((ng03.gm_planet_ships
             JOIN ng03.gm_planets ON ((gm_planets.id = gm_planet_ships.planetid)))
             JOIN ng03.dt_ships ON ((dt_ships.id = gm_planet_ships.shipid)))
          WHERE (gm_planets.ownerid = gm_profiles.id))) AS ships_parked_signature,
    (ng03.static_commander_upkeep_coeff() * gm_profiles.mod_upkeep_commanders_cost) AS cost_commanders,
    (ng03.tool_compute_planets_upkeep(( SELECT int4(count(*)) AS int4
           FROM ng03.gm_planets
          WHERE ((gm_planets.planet_floor > 0) AND (gm_planets.planet_space > 0) AND (gm_planets.ownerid = gm_profiles.id)))) * gm_profiles.mod_upkeep_planets_cost) AS cost_planets,
    (ng03.static_scientist_upkeep() * gm_profiles.mod_upkeep_scientists_cost) AS cost_scientists,
    (ng03.static_soldier_upkeep() * gm_profiles.mod_upkeep_soldiers_cost) AS cost_soldiers,
    (ng03.static_fleet_ship_upkeep() * gm_profiles.mod_upkeep_ships_cost) AS cost_ships,
    (ng03.static_orbitting_fleet_ship_upkeep() * gm_profiles.mod_upkeep_ships_cost) AS cost_ships_in_position,
    (ng03.static_planet_ship_upkeep() * gm_profiles.mod_upkeep_ships_cost) AS cost_ships_parked,
    gm_profiles.upkeep_commanders,
    gm_profiles.upkeep_scientists,
    gm_profiles.upkeep_soldiers,
    gm_profiles.upkeep_ships,
    gm_profiles.upkeep_ships_in_position,
    gm_profiles.upkeep_ships_parked,
    gm_profiles.upkeep_planets,
    gm_profiles.upkeep_last_cost,
    float4(((( SELECT sum(gm_planets.upkeep) AS sum
           FROM ng03.gm_planets
          WHERE ((gm_planets.planet_floor > 0) AND (gm_planets.planet_space > 0) AND (gm_planets.ownerid = gm_profiles.id))))::double precision * gm_profiles.mod_upkeep_planets_cost)) AS cost_planets2
   FROM ng03.gm_profiles;


ALTER TABLE ng03.vw_gm_profile_upkeeps OWNER TO exileng;

--
-- Name: vw_gm_profiles; Type: VIEW; Schema: ng03; Owner: exileng
--

CREATE VIEW ng03.vw_gm_profiles AS
 SELECT gm_profiles.id,
    gm_profiles.privilege,
    gm_profiles.login,
    gm_profiles.password,
    gm_profiles.lastlogin,
    gm_profiles.regdate,
    gm_profiles.email,
    gm_profiles.credits,
    gm_profiles.credits_bankruptcy,
    gm_profiles.lcid,
    gm_profiles.description,
    gm_profiles.notes,
    gm_profiles.avatar_url,
    gm_profiles.lastplanetid,
    gm_profiles.deletion_date,
    gm_profiles.score,
    gm_profiles.score_prestige,
    gm_profiles.score_buildings,
    gm_profiles.score_research,
    gm_profiles.score_ships,
    gm_profiles.alliance_id,
    gm_profiles.alliance_rank,
    gm_profiles.alliance_joined,
    gm_profiles.alliance_left,
    gm_profiles.alliance_taxes_paid,
    gm_profiles.alliance_credits_given,
    gm_profiles.alliance_credits_taken,
    gm_profiles.alliance_score_combat,
    gm_profiles.newpassword,
    gm_profiles.lastactivity,
    gm_profiles.planets,
    gm_profiles.noplanets_since,
    gm_profiles.last_catastrophe,
    gm_profiles.last_holidays,
    gm_profiles.previous_score,
    gm_profiles.timers_enabled,
    gm_profiles.ban_datetime,
    gm_profiles.ban_expire,
    gm_profiles.ban_reason,
    gm_profiles.ban_reason_public,
    gm_profiles.ban_adminuserid,
    gm_profiles.scientists,
    gm_profiles.soldiers,
    gm_profiles.dev_lasterror,
    gm_profiles.dev_lastnotice,
    gm_profiles.protection_enabled,
    gm_profiles.protection_colonies_to_unprotect,
    gm_profiles.protection_datetime,
    gm_profiles.max_colonizable_planets,
    gm_profiles.remaining_colonizations,
    gm_profiles.upkeep_last_cost,
    gm_profiles.upkeep_commanders,
    gm_profiles.upkeep_planets,
    gm_profiles.upkeep_scientists,
    gm_profiles.upkeep_soldiers,
    gm_profiles.upkeep_ships,
    gm_profiles.upkeep_ships_in_position,
    gm_profiles.upkeep_ships_parked,
    gm_profiles.wallet_display,
    gm_profiles.resets,
    gm_profiles.commanders_loyalty,
    gm_profiles.orientation,
    gm_profiles.admin_notes,
    gm_profiles.paid_until,
    gm_profiles.autosignature,
    gm_profiles.game_started,
    gm_profiles.requests,
    gm_profiles.score_next_update,
    gm_profiles.display_alliance_planet_name,
    gm_profiles.score_visibility
   FROM ng03.gm_profiles
  WHERE (((gm_profiles.privilege = 0) OR (gm_profiles.privilege = '-2'::integer)) AND (gm_profiles.orientation > 0) AND (gm_profiles.planets > 0) AND (gm_profiles.credits_bankruptcy > 0));


ALTER TABLE ng03.vw_gm_profiles OWNER TO exileng;

--
-- Name: dt_mails id; Type: DEFAULT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_mails ALTER COLUMN id SET DEFAULT nextval('ng03.dt_mails_id_seq'::regclass);


--
-- Name: gm_log_profile_options id; Type: DEFAULT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_profile_options ALTER COLUMN id SET DEFAULT nextval('ng03.gm_log_profile_options_id_seq'::regclass);


--
-- Name: gm_profiles id; Type: DEFAULT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profiles ALTER COLUMN id SET DEFAULT nextval('ng03.gm_profiles_id_seq'::regclass);


--
-- Data for Name: dt_banned_chat_words; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*tem[\-]la[\-]firme[\.]com[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*idpz[\.]net[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*fourmigration[\.]com[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*bitefight[\.]fr[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*prizee[\.]com[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*woodwar[\.]fr[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*miniville[\.]fr[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*wood-war[\.]net[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*myminicity[\.]fr[[:alnum:]_\./:\?=]*

', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*ville-virtuelle[\.]com[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*floodinator[\.]keuf[\.]net[[:alnum:]_\./:\?=]*', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\-.]*labrute[\.]fr[[:alnum:]_\./:\?=]*', 'http://exile.labrute.fr');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\-.]*labrute[\.]com[[:alnum:]_\./:\?=]*', 'http://exile.labrute.com');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\-.]*gladiatus[\.][[:alnum:]_\./:\?=]*

', ':)');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*clodogame[\.]fr[[:alnum:]_\./:\?=]*

', ':(');
INSERT INTO ng03.dt_banned_chat_words VALUES ('[[:alnum:]_/:\.]*armygames[\.]fr[[:alnum:]_\./:\?=]*', ':)');


--
-- Data for Name: dt_banned_usernames; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_banned_usernames VALUES ('^modo$');
INSERT INTO ng03.dt_banned_usernames VALUES ('^admin');
INSERT INTO ng03.dt_banned_usernames VALUES ('^chob$');
INSERT INTO ng03.dt_banned_usernames VALUES ('^duke$');
INSERT INTO ng03.dt_banned_usernames VALUES ('^exile$');
INSERT INTO ng03.dt_banned_usernames VALUES ('^moderat');
INSERT INTO ng03.dt_banned_usernames VALUES ('^f[0o]ss[0o]*');


--
-- Data for Name: dt_building_building_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_building_building_reqs VALUES (201, 102);
INSERT INTO ng03.dt_building_building_reqs VALUES (201, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (202, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (203, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (205, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (301, 202);
INSERT INTO ng03.dt_building_building_reqs VALUES (301, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (302, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (303, 302);
INSERT INTO ng03.dt_building_building_reqs VALUES (303, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (303, 203);
INSERT INTO ng03.dt_building_building_reqs VALUES (321, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (320, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (221, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (220, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (222, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (207, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (218, 207);
INSERT INTO ng03.dt_building_building_reqs VALUES (208, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (308, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (206, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (204, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (309, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (391, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (209, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (390, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (390, 202);
INSERT INTO ng03.dt_building_building_reqs VALUES (102, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (115, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (116, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (117, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (103, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (105, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (106, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (1020, 1001);
INSERT INTO ng03.dt_building_building_reqs VALUES (1021, 1001);
INSERT INTO ng03.dt_building_building_reqs VALUES (118, 101);
INSERT INTO ng03.dt_building_building_reqs VALUES (370, 96);
INSERT INTO ng03.dt_building_building_reqs VALUES (371, 96);
INSERT INTO ng03.dt_building_building_reqs VALUES (310, 302);
INSERT INTO ng03.dt_building_building_reqs VALUES (210, 207);
INSERT INTO ng03.dt_building_building_reqs VALUES (310, 207);
INSERT INTO ng03.dt_building_building_reqs VALUES (217, 202);
INSERT INTO ng03.dt_building_building_reqs VALUES (317, 302);
INSERT INTO ng03.dt_building_building_reqs VALUES (401, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (400, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (402, 301);
INSERT INTO ng03.dt_building_building_reqs VALUES (230, 201);
INSERT INTO ng03.dt_building_building_reqs VALUES (404, 403);
INSERT INTO ng03.dt_building_building_reqs VALUES (403, 207);
INSERT INTO ng03.dt_building_building_reqs VALUES (231, 201);


--
-- Data for Name: dt_building_research_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_building_research_reqs VALUES (1001, 3, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (317, 402, 3);
INSERT INTO ng03.dt_building_research_reqs VALUES (317, 404, 3);
INSERT INTO ng03.dt_building_research_reqs VALUES (101, 0, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (217, 402, 2);
INSERT INTO ng03.dt_building_research_reqs VALUES (317, 403, 3);
INSERT INTO ng03.dt_building_research_reqs VALUES (118, 401, 2);
INSERT INTO ng03.dt_building_research_reqs VALUES (391, 405, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (390, 405, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (51, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (52, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (90, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (91, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (94, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (95, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (96, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (381, 1, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (370, 410, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (371, 410, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (210, 420, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (310, 420, 1);
INSERT INTO ng03.dt_building_research_reqs VALUES (403, 402, 3);
INSERT INTO ng03.dt_building_research_reqs VALUES (403, 403, 3);
INSERT INTO ng03.dt_building_research_reqs VALUES (403, 404, 3);


--
-- Data for Name: dt_buildings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_buildings VALUES (52, 110, 'hydro_bonus', 'Gisements d''hydrocarbure', 'De riches gisements d''hydrocarbure ont été découverts, la production en hydrocarbure est augmentée.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (90, 100, 'magnetic_clouds', 'Nuages magnétiques', 'Un amas de nuages entoure le système de la planète agissant comme un brouilleur radar géant.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (91, 100, 'electromagnetic_storm', 'Tempête électromagnétique', 'Nous subissons actuellement une tempête électromagétique, la production s''en voit grandement diminuée.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, -0.6, -0.6, -0.3, 0, -0.99, -0.99, 0, 0, 0, 20, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (94, 100, 'extraordinary_planet', 'Planète extraordinaire', 'Cette planète se trouve proche d''une déformation gravitationnelle dans l''espace temps, le temps passe plus vite par rapport aux autres colonies.<br/>

La construction, la production et la formation des nouveaux travailleurs est plus rapide sur cette planète.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0.3, 0.3, 0, 0.8, 2, 2, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (217, 23, 'nuclear_power_plant', 'Centrale nucléaire', 'Cette centrale à énergie accueille plusieurs réacteurs nucléaires dont le principe repose sur la fission nucléaire.<br/>

L''énergie produite est importante.', 28000, 14000, 0, 7500, 200, 2000, 2, 0, 0, 0, 0, 0, 0, 200, 43200, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 150, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (115, 20, 'ore_mine1', 'Mine de minerai', 'Un système automatisé extrait le minerai de la planète continuellement.<br/>

Chaque bâtiment augmente la production de minerai de 1% mais réduit la demande en minerai de la planète.', 500, 1000, 0, 2000, 25, 0, 2, 0, 400, 0, 0, 0, 0, 200, 7200, true, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, -0.015, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (1001, 10, 'merchant_colony', 'Colonie marchande', 'Colonie marchande.', 900000, 600000, 0, 100000, 0, 20000, 20, 0, 0, 0, 400000, 400000, 600000, 1, 900000, false, 0, 0, 0, 0, 0, 0, 100000, 100000, 4, 0, false, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1000000, false, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (310, 80, 'send_energy_satellite', 'Satellite émetteur d''énergie', 'Ce satellite permet de créer un lien avec un satellite de réception d''une autre planète située dans la même galaxie et de lui envoyer de l''énergie.<br/>

Un satellite émetteur ne peut envoyer qu''un seul flux à la fois.', 120000, 80000, 0, 25000, 200, 0, 0, 1, 0, 0, 0, 0, 0, 100, 100000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (117, 23, 'solar_power_plant', 'Capteurs solaires', 'Des capteurs solaires tapissent des champs entiers et convertissent les rayons du soleil en énergie.', 200, 300, 0, 1000, 0, 200, 1, 0, 0, 0, 0, 0, 0, 200, 1200, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (401, 31, 'ore_storage_complex', 'Complexe de stockage de minerai', 'Ce complexe de stockage augmente la capacité de stockage du minerai de 2 000 000.', 500000, 400000, 0, 25000, 1000, 0, 2, 0, 0, 0, 2000000, 0, 0, 200, 128000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 200, 0, true, NULL, NULL, 0, 0, 10000, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (403, 23, 'star_belt', 'Ceinture d''étoile', 'Il s''agit certainement du projet le plus fou mais aussi le plus ambitieux à entreprendre : créer une ceinture tout autour de l''étoile du système afin de capter le plus possible d''énergie.<br/>

Une production d''au moins 50 000 énergie/heure est prévue. De plus, il sera possible d''augmenter cette production en ajoutant jusqu''à 5 capteurs supplémentaires fournissant chacun 10 000 énergie/heure.', 2000000, 1600000, 0, 50000, 0, 50000, 0, 2, 0, 0, 0, 0, 0, 1, 512000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 10000, 0, true, NULL, NULL, 0, 0, 200000, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (402, 32, 'hydrocarbon_storage_complex', 'Complexe de stockage d''hydrocarbure', 'Ce complexe de stockage augmente la capacité de stockage en hydrocarbure de 2 000 000.', 500000, 400000, 0, 25000, 1000, 0, 2, 0, 0, 0, 0, 2000000, 0, 200, 128000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 200, 0, true, NULL, NULL, 0, 0, 10000, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (231, 20, 'manufactured_products_factory', 'Usine de produits manufacturés', 'De ces usines sortent des produits manufacturés vendus à la population.<br/>

Chaque usine génère entre 8 000 et 10 000 crédits par jour.', 30000, 25000, 0, 10000, 3000, 0, 4, 0, 0, 0, 0, 0, 0, 100, 54000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 50, 1, 0, 0, 8000, 2000, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (96, 100, 'sandworm_activity', 'Présence de vers de sable', 'De gigantesques vers de sable sont présents sur la planète et attaquent tout ce qui émet des vibrations régulières.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3600, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (600, 80, 'space_radar', 'Radar renforcé', 'Station temporaire déployée permettant le balayage radar d''un secteur pour une durée limitée (puissance radar 1)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3600, true, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 28800, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (601, 80, 'space_jammer', 'Brouillage renforcé', 'Station temporaire déployée permettant le brouillage de l''emplacement avec une puissance de 10.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3600, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 28800, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (51, 110, 'ore_bonus', 'Filon de minerai', 'De riches filons de minerai ont été découverts, la production de minerai est augmentée.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (102, 11, 'construction_plant1', 'Usine de préfabriqués', 'Cette usine est spécialisée dans la préfabrication, des ouvriers préfabriquent certains éléments qui sont ensuite assemblés sur place ce qui donne une augmentation globale de la vitesse de construction des bâtiments.<br/>

Ce bâtiment est requis avant de pouvoir construire des structures plus avancées.', 2000, 1250, 0, 5000, 50, 0, 1, 0, 0, 0, 0, 0, 0, 1, 43200, true, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (303, 40, 'heavyweapon_factory', 'Usine d''armement lourd', 'Cette usine permet de construire les différentes armes dont vous aurez besoin pour construire vos défenses plus évoluées et équiper vos vaisseaux de combat.', 180000, 160000, 0, 32000, 600, 0, 12, 0, 0, 0, 0, 0, 0, 1, 172800, true, 0, 0, 0, 0, 0, 0.02, 0, 0, 0, 0, false, false, 0, 0, 20, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 1000, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (1021, 32, 'merchant_hydrocarbon_storage', 'Entrepôt marchand d''hydrocarbure', 'Les entrepôts marchand sont immenses et peuvent contenir des millions d''unités de ressources.', 3000000, 2000000, 0, 120000, 0, 0, 5, 0, 0, 0, 0, 900000000, 0, 100, 1000000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (203, 40, 'light_weapon_factory', 'Usine d''armement léger', 'Cette usine permet de construire différentes armes légères dont vous aurez besoin pour construire vos défenses et équiper vos vaisseaux.', 32000, 25000, 0, 17500, 250, 0, 6, 0, 0, 0, 0, 0, 0, 1, 50400, true, 0, 0, 0, 0, 0, 0.02, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 300, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (218, 23, 'solar_power_satellite', 'Satellite solaire', 'Un satelite solaire est envoyé en orbite géostationnaire, transforme l''énergie solaire en électricité puis redirige celle-ci vers la rectenna de la colonie sous forme de micro-ondes.', 4000, 7000, 0, 2500, 0, 600, 0, 1, 0, 0, 0, 0, 0, 200, 32000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 125, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (317, 23, 'energy_plant3', 'Tokamak', 'Cet énorme bâtiment accueille plusieurs machines qui reproduisent la fusion nucléaire semblable à celle qui se produit en permanence au coeur des étoiles.<br/>

L''énergie produite est très importante.<br/>

De plus, cet édifice vous rapportera 100 points de prestige par jour.', 140000, 90000, 0, 40000, 500, 10000, 4, 0, 0, 0, 0, 0, 0, 1, 172800, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 600, 0, true, NULL, NULL, 0, 100, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (302, 11, 'synthesis_plant', 'Usine de synthèse', 'Une technique avancée permet de créer de nouveaux matériaux uniquement à partir d''énergie.<br/>

La qualité de ces matériaux exempts de tout défaut, les rend beaucoup plus résistants.', 100000, 80000, 0, 35000, 800, 0, 1, 0, 0, 0, 0, 0, 0, 1, 172800, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 150, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (391, 10, 'artificial_moon', 'Lune artificielle', 'La création d''une lune artificielle ajoute 10 unités d''espace exploitable.<br/>

Ce bâtiment ne peut être détruit après construction. Il n''est possible d''en construire qu''une seule.', 700000, 150000, 0, 55000, 0, 0, 0, -10, 0, 0, 0, 0, 0, 1, 432000, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (390, 10, 'steel_caves', 'Cavernes d''acier', 'La transformation d''une partie des sous-sols en espace utilisable permet d''étendre le terrain de la planète de 4 unités.<br/>

Ce bâtiment ne peut être détruit après construction. Il n''est possible d''en construire que 5 par planète.', 400000, 300000, 0, 45000, 0, 0, -4, 0, 0, 0, 0, 0, 0, 5, 345600, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (370, 40, 'sandworm_proctection', 'Barrières électromagnétiques', 'Des barrières sont disposées tout autour de la colonie repoussant les attaques des vers de sable. La probabilité qu''un vers s''attaque à un bâtiment de la colonie est grandement réduite.', 100000, 80000, 0, 30000, 2500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 172800, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 10, 1, -19, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 500, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (309, 80, 'jammer', 'Brouilleur radar', 'Ce satellite est capable de brouiller les radars ennemis.<br/>

Lancez plusieurs satellites afin de brouiller efficacement les radars ennemis pour cacher vos flottes en orbite et les caractéristiques de votre planète.<br/>

Chaque satellite augmente le brouillage de la planète de 2 points.', 90000, 65000, 0, 25000, 1000, 0, 0, 1, 0, 0, 0, 0, 0, 200, 100000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, false, true, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 100, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (1020, 31, 'merchant_ore_storage', 'Entrepôt marchand de minerai', 'Les entrepôts marchand sont immenses et peuvent contenir des millions d''unités de ressources.', 3000000, 2000000, 0, 120000, 0, 0, 5, 0, 0, 0, 900000000, 0, 0, 100, 1000000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (381, 40, 'seism_protection', 'Déflecteur', 'Des capteurs sont disséminés sur toute la surface de la planète afin de prévenir les séismes et amoindrir les secousses à la surface.', 420000, 31000, 0, 10000, 3000, 0, 4, 0, 0, 0, 0, 0, 0, 1, 18000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 1, 0, 0, -19, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 500, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (222, 33, 'energy_storage', 'Réserve d''énergie', 'Ce bâtiment permet de stocker 100 000 unités d''énergie supplémentaire.', 30000, 20000, 0, 15000, 100, 0, 1, 0, 0, 0, 0, 0, 0, 200, 30800, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 100000, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (95, 100, 'big_seismic_activity', 'Grande activité sismique', 'Activité sismique très importante pouvant détruire des bâtiments', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3600, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (232, 80, 'commercial_station', 'Station commerciale orbitale', 'Les stations commerciales orbitales permettent la vente de minerai et d''hydrocarbure aux autres planètes de la galaxie', 30000, 20000, 0, 5000, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 3600, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (220, 31, 'ore_hangar2', 'Hangar à minerai', 'Un entrepôt qui augmente la capacité de stockage du minerai de 200 000.', 25000, 14000, 0, 10000, 100, 0, 2, 0, 0, 0, 200000, 0, 0, 200, 28000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (221, 32, 'hydrocarbon_hangar2', 'Hangar à hydrocarbure', 'Un entrepôt qui augmente la capacité de stockage en hydrocarbure de 200 000.', 25000, 14000, 0, 10000, 100, 0, 2, 0, 0, 0, 0, 200000, 0, 200, 30800, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (320, 31, 'ore_hangar3', 'Entrepôt à minerai', 'Un entrepôt souterrain sur plusieurs niveaux qui augmente considérablement la capacité de stockage du minerai de 1 000 000.', 80000, 55000, 0, 15000, 500, 0, 3, 0, 0, 0, 1000000, 0, 0, 200, 56000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 100, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (321, 32, 'hydrocarbon_hangar3', 'Entrepôt à hydrocarbure', 'Un entrepôt souterrain sur plusieurs niveaux qui augmente considérablement la capacité de stockage en hydrocarbure de 1 000 000.', 80000, 55000, 0, 15000, 500, 0, 3, 0, 0, 0, 0, 1000000, 0, 200, 61600, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 100, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (116, 20, 'hydrocarbon_mine1', 'Puits d''hydrocarbures', 'Un système automatisé extrait les hydrocarbures de la planète continuellement.<br/>

Chaque bâtiment augmente la production d''hydrocarbure de 1% mais réduit la demande en hydrocarbure de la planète.', 1000, 500, 0, 2000, 25, 0, 2, 0, 0, 400, 0, 0, 0, 200, 7200, true, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, -0.015, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (308, 30, 'military_base', 'Base militaire', 'La base militaire permet d''accueillir 10 000 soldats supplémentaires dans votre colonie et l''entraînement de 100 soldats à la fois.', 110000, 90000, 0, 30000, 600, 0, 3, 0, 0, 0, 0, 0, 0, 200, 172800, true, 0, 0, 0, 0, 0, 0, 0, 10000, 0, 0, false, false, 0, 100, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 250, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (207, 23, 'rectenna', 'Rectenna', 'La rectenna est une antenne qui convertit les micro-ondes envoyées par les satellites solaires en énergie utilisable par la colonie.<br/>

Vous ne pouvez construire ces satellites qu''une fois la rectenna construite.', 16000, 5000, 0, 6000, 50, 0, 2, 0, 0, 0, 0, 0, 0, 1, 42000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 25, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (89, 100, 'vortex', 'Vortex', 'Présence d''un vortex stable à proximité', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 0, true, 0, 0, true, NULL, NULL, 10, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (603, 80, 'deployed_vortex_short', 'Vortex artificiel', 'Vortex artificiel déployé par un groupe ayant connaissance de la science des vortex', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 1800, true, 0, 0, true, NULL, NULL, 1, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (604, 80, 'deployed_vortex_medium', 'Vortex artificiel', 'Vortex artificiel déployé par un groupe ayant connaissance de la science des vortex', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 43200, true, 0, 0, true, NULL, NULL, 2, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (605, 80, 'deployed_vortex_strong', 'Vortex artificiel', 'Vortex artificiel déployé par un groupe ayant connaissance de la science des vortex', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 1800, true, 0, 0, true, NULL, NULL, 4, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (606, 80, 'deployed_vortex_inhibitor', 'Inhibiteur de vortex', 'Déstabilisateur de vortex rendant son utilisation plus compliquée.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, true, false, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, 172800, true, 0, 0, true, NULL, NULL, -8, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (204, 30, 'workshop1', 'Ateliers', 'Les ateliers fournissent des infrastructures de travail à votre population.<br/>

Votre colonie peut accueillir 3 000 nouveaux travailleurs.<br/>

L''atelier génère 200 crédits par jour et augmente légèrement la demande en minerai et hydrocarbure de la planète.', 8000, 4000, 0, 5000, 150, 0, 1, 0, 0, 0, 0, 0, 3000, 200, 21600, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 200, 0, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 800, 800, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (206, 30, 'research_center', 'Centre de recherche', 'Le centre de recherche est équipé de tout ce qui est nécessaire afin d''entreprendre des recherches avancée.<br/>

Votre planète peut accueillir 5 000 scientifiques de plus et permet la formation de 100 scientifiques par heure.', 28000, 21000, 0, 15000, 150, 0, 2, 0, 0, 0, 0, 0, 0, 1, 108000, true, 0, 0, 0, 0, 0, 0, 5000, 0, 0, 0, false, false, 100, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (101, 10, 'colony1', 'Colonie', 'Ce bâtiment est le centre administratif de votre colonie, il est essentiel pour la gestion de votre colonie.<br/>

Il dispose de petits extracteurs de minerai et d''hydrocarbures, d''une centrale géothermique pour produire de l''énergie à l''ensemble de la colonie et d''ateliers pour construire de nouveaux bâtiments.<br/>

La colonie offre une capacité de stockage de 100 000 unités de minerai, 100 000 unités d''hydrocarbure, 30 000 unités d''énergie et génère 2 500 crédits par jour.', 20000, 10000, 0, 2500, 0, 300, 2, 0, 100, 50, 100000, 100000, 20000, 1, 44800, false, 0, 0, 0, 0, 0, 0, 1000, 1000, 0, 0, false, false, 50, 50, 20, 1, 0, 0, 2500, 0, 0, 0, 0, 1, 30000, true, 0, false, 0, 0, true, NULL, NULL, 0, 10, 0, 0, 0, 8000, 8000, true, 0, 10000);
INSERT INTO ng03.dt_buildings VALUES (400, 10, 'wonder', '12ème merveille', 'Cette reproduction de la douzième merveille de l''univers vous rapportera 100 points de prestige par jour.<br/>

Le tourisme associé à ce bâtiment rapporte entre 1000 et 2000 crédits par jour.', 600000, 150000, 0, 28000, 200, 0, 2, 0, 0, 0, 0, 0, 0, 1, 320000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 1, 1, 0, 0, 1000, 2000, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 100, 1000, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (208, 30, 'military_barracks', 'Caserne militaire', 'La caserne militaire permet d''accueillir 2 000 nouveaux soldats dans la colonie et l''entraînement de 100 soldats à la fois.', 22000, 10000, 0, 6000, 200, 0, 1, 0, 0, 0, 0, 0, 0, 200, 108000, true, 0, 0, 0, 0, 0, 0, 0, 2000, 0, 0, false, true, 0, 100, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 100, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (404, 23, 'star_belt_panel', 'Ceinture d''étoile : capteur', 'Ajoute un capteur solaire à la ceinture d''étoile augmentant la production de 10 000 énergie/heure.', 400000, 300000, 0, 25000, 0, 10000, 0, 0, 0, 0, 0, 0, 0, 5, 128000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 1000, 0, true, NULL, NULL, 0, 0, 10000, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (230, 30, 'housing', 'Habitations', 'Les habitations permettent d''augmenter la population civile au sein de la colonie et ainsi augmenter les besoins en minerai et hydrocarbure.<br/>

Les habitations génèrent 1 000 crédits par jour, la vitesse de formation des travailleurs augmente de 10% et les besoins en minerai et hydrocarbure augmentent sensiblement.', 30000, 18000, 0, 10000, 500, 0, 4, 0, 0, 0, 0, 0, 0, 10, 28000, true, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 10, 1, 0, 0, 1000, 0, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0.1, 0.1, 18750, 18750, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (210, 80, 'receive_energy_satellite', 'Satellite de réception d''énergie', 'Ce satellite permet de recevoir un flux d''énergie provenant d''une autre planète située dans la même galaxie envoyé par un satellite émetteur.<br/>

L''énergie reçue est redirigée vers la rectenna et est ensuite utilisable par la colonie.', 9000, 6000, 0, 5000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 200, 28000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, true, 0, false, 20, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (371, 40, 'sandworm_field', 'Champ de moissonneuses', 'Des moissonneuses récoltent une substance étrange à partir du sable de la planète où la présence de vers a été signalé récemment. Cette substance est ensuite exclusivement vendue à la guilde marchande qui y porte un très grand intérêt.<br/>

Suivant les récoltes, l''argent généré par jour varie entre 40 000 et 50 000 crédits.<br/>

De plus, chaque champ vous fait gagner 20 points de prestige par jour.', 30000, 17000, 0, 10000, 2000, 0, 7, 0, 0, 0, 0, 0, 0, 100, 78000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, true, 0, 0, 50, 1, 0, 0, 40000, 10000, 0, 0, 0, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 20, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (106, 30, 'laboratory', 'Laboratoire', 'Le laboratoire permet d''accueillir 1 000 scientifiques supplémentaire et la formation de 150 scientifiques par heure.', 2500, 2000, 0, 4000, 100, 0, 1, 0, 0, 0, 0, 0, 0, 200, 9600, true, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, false, false, 150, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (201, 10, 'colony2', 'Cité', 'De nouveaux bâtiment et ateliers sont construits à proximité de votre colonie ce qui vous permet d''emmagasiner 70 000 unités d''énergie supplémentaire et d''accueillir 10 000 nouveaux travailleurs.<br/>

La formation de vos travailleurs et l''efficacité de vos mines et puits sont légèrement augmentées.<br/>

La cité génère 1 500 crédits par jour.', 35000, 35000, 0, 6000, 100, 0, 2, 0, 0, 0, 0, 0, 10000, 1, 64800, true, 0.02, 0.02, 0.02, 0.1, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 1500, 0, 0, 0, 0, 1, 70000, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 15000);
INSERT INTO ng03.dt_buildings VALUES (301, 10, 'colony3', 'Métropole', 'Votre colonie s''aggrandit encore et doit être, en partie, réorganisée.<br/>

Le contrôle de la production en minerai, hydrocarbures et énergie est désormais effectué par un centre dédié, la production s''en voit légérement augmentée.<br/>

Les anciens ateliers sont réaménagés et de nouveaux sont construits augmentant le nombre de travailleurs de 10 000.<br/>

La métropole génère 2 500 crédits par jour.', 200000, 200000, 0, 30000, 500, 0, 3, 1, 0, 0, 0, 0, 10000, 1, 259200, true, 0.02, 0.02, 0.02, 0.1, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 2500, 0, 0, 0, 0, 1, 0, true, 0, false, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 25000);
INSERT INTO ng03.dt_buildings VALUES (202, 11, 'construction_plant2', 'Usine d''automates', 'Les ouvriers ne peuvent pas tout construire par eux-même, ils ont besoin d''aide méchanisée pour mener à bien les constructions, cette usine permet de construire de nouveaux bâtiments et augmente la vitesse de construction.', 22500, 15000, 0, 15000, 250, 0, 1, 0, 0, 0, 0, 0, 0, 1, 64800, true, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 100, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (118, 23, 'geothermal_power_plant', 'Centrale géothermique', 'Cette centrale transforme l''énergie thermique en provenance de l''intérieur de la planète en énergie.', 1500, 1250, 0, 1000, 0, 300, 1, 0, 0, 0, 0, 0, 0, 200, 3600, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 50, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (205, 80, 'shipyard', 'Chantier spatial', 'Le chantier spatial construit les vaisseaux de grande taille qu''il n''est pas possible d''assembler dans les usines de la colonie.', 40000, 30000, 0, 22000, 150, 0, 2, 6, 0, 0, 0, 0, 0, 1, 108000, true, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 1500, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (105, 80, 'spaceport', 'Spatioport', 'Le spatioport permet la construction et le lancement en orbite de la plupart des vaisseaux utilitaires et des vaisseaux légers.<br/>

Pour les vaisseaux plus lourds, un chantier spatial est nécessaire, ceux-ci seront construits directement en orbite.', 2500, 2000, 0, 5000, 50, 0, 4, 0, 0, 0, 0, 0, 0, 1, 36000, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, false, false, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 200, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (103, 80, 'radar', 'Radar', 'Les radars vous permettent de scanner les planètes du secteur où se trouve votre planète.<br/>

Cela vous permet, par exemple, de connaître l''espace utilisable sur les planètes ou de visualiser les flottes proche d''une planète.<br/>

Construire plusieurs radars sur la même planète vous permettra de venir à bout des tentatives de brouillage radar ennemies.<br/>

Chaque radar augmente la puissance radar de la planète de 1.', 1000, 500, 0, 2000, 100, 0, 1, 0, 0, 0, 0, 0, 0, 200, 28800, true, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, false, true, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 150, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);
INSERT INTO ng03.dt_buildings VALUES (209, 80, 'radar_satellite', 'Satellite radar', 'Les radars vous permettent de scanner les planètes du secteur où se trouve votre planète.<br/>

Chaque satellite augmente la puissance radar de la planète de 2.', 15000, 8500, 0, 7000, 300, 0, 0, 2, 0, 0, 0, 0, 0, 200, 39600, true, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, false, true, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, true, 0, false, 200, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, true, 0, 0);


--
-- Data for Name: dt_commander_firstnames; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_commander_firstnames VALUES ('Alia');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Leto');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Siona');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Gurney');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Vladimir');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Darwi');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Duncan');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Paul');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Ben');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Jacen');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Maximus');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Yan');
INSERT INTO ng03.dt_commander_firstnames VALUES ('John');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Alexandre');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Charles');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Robert');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Pavel');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Travis');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Leonard');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Tina');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Kira');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Janice');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Alfred');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Marcus');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Thomas');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Oliver');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Douglas');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Conrad');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Jane');
INSERT INTO ng03.dt_commander_firstnames VALUES ('James');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Frank');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Arthur');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Richard');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Steve');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Julian');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Dave');
INSERT INTO ng03.dt_commander_firstnames VALUES ('William');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Walter');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Eric');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Tony');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Peter');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Max');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Martin');
INSERT INTO ng03.dt_commander_firstnames VALUES ('David');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Leo');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Howard');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Julius');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Chris');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Cyril');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Anne');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Anke');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Alberto');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Nicolas');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Arkan');
INSERT INTO ng03.dt_commander_firstnames VALUES ('André');
INSERT INTO ng03.dt_commander_firstnames VALUES ('Mike');


--
-- Data for Name: dt_commander_lastnames; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_commander_lastnames VALUES ('Burnett');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Adams');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Leary');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Page');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Keats');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Keller');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Anderson');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Aicard');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Allen');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Atwood');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Augustus');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Estrada');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Eckhart');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Hebey');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Huxley');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Harris');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Hnin Yu');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Muller');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Moore');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Monroe');
INSERT INTO ng03.dt_commander_lastnames VALUES ('O''Neill');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Orban');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Orwell');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Thompson');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Carr');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Chen');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Claudius');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Gambetta');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Grant');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Newton');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Nietzsche');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Nerval');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Bonaparte');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Nin');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Neumann');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Rolland');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Rousseau');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Rostand');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Russel');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Ruskin');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Surcouffe');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Shepard');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Sheen');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Smith');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Doe');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Sterne');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Stuart');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Swift');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Scott');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Falcon');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wartburg');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wesley');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wiesel');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wolfe');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wei');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Wellington');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Mairet');
INSERT INTO ng03.dt_commander_lastnames VALUES ('Riker');


--
-- Data for Name: dt_mails; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_mails VALUES (1, 1036, 'Rapport de colonisation', 'Notre nouvelle colonie est prête à accueillir nos colons !

Nous devrions commencer à produire de l''énergie, à extraire du minerai et des hydrocarbures dès que possible afin d''assurer le développement de la colonie.

Vous pouvez lancer la construction de nouveaux bâtiments à partir de la page Planète / Infrastructures.

Gagnez des crédits en vendant des ressources dans la page Planète / Marché, un marchand de la Guilde Marchande (géré par ordinateur) viendra au bout de 3 à 4 heures sur la planète pour prendre les ressources vendues. Les marchands payent la moitié de l''argent à la vente puis la seconde moitié est payée une fois que leurs vaisseaux sont revenus sur leur planète.

Cet argent vous servira à l''entretien de vos infrastructures et vaisseaux, à faire des recherches afin de débloquer de nouveaux bâtiments et d''autres recherches, à construire de nouveaux vaisseaux et pour les salaires de vos commandants (notez que votre premier commandant ne vous coûte rien).

En tant que nouvelle nation, vos planètes ne peuvent être attaquées pendant deux semaines. Profitez-en pour faire connaissance avec les nations autour de vous.

Pendant cette période de protection, vous ne pourrez ni recevoir ni envoyer d''argent par la messagerie du jeu ou par la demande de financement de l''alliance.

Développez-vous, augmentez votre production en construisant des mines de minerai et des puits d''hydrocarbure.

Fin de transmission.', '');
INSERT INTO ng03.dt_mails VALUES (4, 1036, 'Fin de contrat', 'Cher client,

J''ai le regret de vous annoncer la fin du contrat vous procurant un bonus sur les ventes de ressources que vous effectuez avec nous.

Cordialement,

Votre représentant de la Guilde Marchande', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES (3, 1036, 'Reconduction tacite de notre contrat', 'Cher client,

Je suis heureux de vous apprendre que notre contrat se prolonge pour une durée de 7 nouveaux jours.

Cordialement,

Votre représentant de la Guilde Marchande', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES (2, 1036, 'Contrat spécial de vente', 'Cher client,

Votre nation fait parti de nos vingt plus importants fournisseurs de ressources aussi nous avons le plaisir de vous annoncer qu''à partir de maintenant et ceci pour une durée d''une semaine, vous bénéficierez d''un bonus de 5% sur le prix de vente de votre minerai et hydrocarbure.

Continuez ainsi et je ne doute pas que ce contrat sera reconduit.

Cordialement,

Votre représentant de la Guilde Marchande', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES (5, 1036, 'Recherches', 'Votre équipe de scientifiques attend vos ordres. Vous pouvez choisir une recherche en allant sur la page "Recherche" du menu Empire.

Nous ne connaissons pas bien les environs de notre colonie, nous pouvons construire un radar mais nous n''aurons que les informations relatives aux planètes de notre secteur.

Il serait bien de débloquer les sondes qui sont de petits appareils très rapides idéaux pour découvrir les planètes d''autres secteurs.

Pour cela, nous avons besoin de faire des recherches en mécanique et nous aurons aussi besoin d''un spatioport pour construire les vaisseaux.

Afin de construire le vaisseau de colonisation, nous avons besoin de "Mécanique" niveau 1 et de "Vaisseau Utilitaire" niveau 3.

Fin de transmission.', '');
INSERT INTO ng03.dt_mails VALUES (7, 1036, 'Premier vaisseau de colonisation', 'Il est désormais temps d''agrandir notre empire en colonisant de nouvelles planètes.

Pour coloniser, vous allez avoir besoin de former une flotte avec votre vaisseau de colonisation et trouver une planète non occupée pour établir votre colonie dans un secteur autre que votre secteur de départ (notez les coordonnées de cette planète).

Lorsque votre future planète est choisie, déplacez votre flotte contenant votre vaisseau de colonisation vers cette planète. Les vaisseaux de colonisation sont très lent et cela prendra plusieurs heures (ou jours suivant la distance à parcourir).

Une fois arrivée à destination, allez dans la page de votre flotte et déployer votre vaisseau de colonisation : bouton "déployer" tout à droite de la page.

Bravo, vous avez désormais une colonie supplémentaire à faire évoluer.

Notez que vous avez besoin de la recherche "Gestion d''Empire" au niveau 2 pour coloniser une deuxième planète.

Fin de transmission.', '');
INSERT INTO ng03.dt_mails VALUES (6, 1036, 'Premier vaisseau', 'Félicitation, vous venez de construire votre premier vaisseau !

Afin de pouvoir le déplacer, vous devez former une flotte à partir de la page "Orbite" de la planète où votre vaisseau a été construit.

Une fois formée, vous pouvez obtenir la liste de vos flottes à partir de la page "Flottes" du menu Empire.

Cliquez sur votre flotte pour observer sa composition et lui donner des ordres :

 - déplacer

 - charger/décharger des ressources

 - changer le mode d''engagement

 - regrouper/scinder

 - déployer un bâtiment

 - envahir une planète si votre flotte possède des barges et des soldats

 - récolter si votre flotte possède des récolteurs

Fin de transmission', '');
INSERT INTO ng03.dt_mails VALUES (10, 1036, 'Résultat de la loterie', 'Vous avez misé un total de $1 crédits malheureusement vous n''avez pas gagné.', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES (12, 1036, 'Début de la loterie ', 'Bonjour,

Nous avons le plaisir de vous annoncer le début de la prochaine loterie intergalactique dont le tirage a lieu chaque vendredi à minuit.

Le gagnant recevra un Dreadnought d''élite directement sorti de nos industries et envoyé à destination d''une de ses planètes.

Afin de piloter ce vaisseau d''exception, vous devrez posséder les connaissances nécessaire au pilotage des croiseurs d''élite.

Pour participer, envoyez-nous simplement un message en joignant la somme de crédit que vous voulez.

Plus la somme est élevée, plus vos chances de gagner augmentent et celles des autres diminuent.

Bon jeu !', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES (11, 1036, 'Résultat de la loterie', 'Vous avez misé un total de $1 crédits dans notre loterie intergalactique et vous avez gagné !

Votre lot a déjà quitté nos hangars et nous vous en souhaitons une bonne réception.', 'Guilde Marchande');


--
-- Data for Name: dt_processes; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_processes VALUES ('process_merchant_contracts()', true, '2020-09-09 18:37:48.554622', '24:00:00', NULL, '{00:00:00.013764,00:00:00.002839,00:00:00.002246,00:00:00.001681,00:00:00.001819,00:00:00.00186,00:00:00.010767,00:00:00.007715,00:00:00.001035,00:00:00.000896}');
INSERT INTO ng03.dt_processes VALUES ('process_lottery()', true, '2020-09-06 18:34:47.887603', '168:00:00', NULL, '{00:00:00.010829,00:00:00.004089,00:00:00.089142,00:00:00.003773,00:00:00.101392,00:00:03.625,00:00:00.938,00:00:00.781,00:00:01.031,00:00:04.203}');
INSERT INTO ng03.dt_processes VALUES ('process_rogue_rushing_fleets()', true, '2020-09-10 07:54:13.999933', '01:15:00', NULL, '{00:00:00.001325,00:00:00.000765,00:00:00.033123,00:00:00.00155,00:00:00.002498,00:00:00.001128,00:00:00.004483,00:00:00.001258,00:00:00.002918,00:00:00.002732}');
INSERT INTO ng03.dt_processes VALUES ('process_rogue_patrolling_fleets()', true, '2020-09-10 08:09:11.449584', '01:30:00', NULL, '{00:00:00.007417,00:00:00.009682,00:00:00.007987,00:00:00.009318,00:00:00.00837,00:00:00.008106,00:00:00.007294,00:00:00.03403,00:00:00.006827,00:00:00.009471}');
INSERT INTO ng03.dt_processes VALUES ('process_daily_cleaning()', true, '2020-09-09 18:37:48.554622', '24:00:00', NULL, '{00:00:00.034056,00:00:00.040125,00:00:00.032311,00:00:00.034862,00:00:00.033231,00:00:00.026335,00:00:00.023199,00:00:00.019599,00:00:00.025142,00:00:00.022588}');
INSERT INTO ng03.dt_processes VALUES ('process_commander_promotions()', true, '2020-09-10 08:15:47.034513', '00:30:00', NULL, '{00:00:00.00147,00:00:00.001721,00:00:00.001647,00:00:00.001341,00:00:00.001246,00:00:00.001248,00:00:00.001645,00:00:00.001611,00:00:00.00233,00:00:00.001672}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_electromagnetic_storms()', true, '2020-09-10 08:30:26.649858', '00:10:40', NULL, '{00:00:00.000989,00:00:00.003432,00:00:00.003864,00:00:00.003104,00:00:00.003833,00:00:00.003117,00:00:00.003097,00:00:00.003352,00:00:00.003291,00:00:00.003682}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_laboratory_accidents()', true, '2020-09-10 08:34:06.966149', '00:10:20', NULL, '{00:00:00.004072,00:00:00.004552,00:00:00.003795,00:00:00.004042,00:00:00.004057,00:00:00.004432,00:00:00.003667,00:00:00.001266,00:00:00.00393,00:00:00.003881}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_robberies()', true, '2020-09-10 08:34:17.997529', '00:10:10', NULL, '{00:00:00.002864,00:00:00.002615,00:00:00.004622,00:00:00.009328,00:00:00.002732,00:00:00.001858,00:00:00.005129,00:00:00.005074,00:00:00.006631,00:00:00.009077}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_riots()', true, '2020-09-10 08:37:03.00961', '00:10:50', NULL, '{00:00:00.006364,00:00:00.005597,00:00:00.010352,00:00:00.003533,00:00:00.004085,00:00:00.00463,00:00:00.004528,00:00:00.005105,00:00:00.005828,00:00:00.004334}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_abandons()', true, '2020-09-10 08:37:52.450203', '00:11:00', NULL, '{00:00:00.003662,00:00:00.002457,00:00:00.001833,00:00:00.002663,00:00:00.002484,00:00:00.002806,00:00:00.002681,00:00:00.002474,00:00:00.000619,00:00:00.002436}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_sandworm_attacks()', true, '2020-09-10 08:39:09.562054', '00:11:10', NULL, '{00:00:00.004023,00:00:00.004078,00:00:00.004364,00:00:00.002844,00:00:00.002454,00:00:00.002211,00:00:00.002366,00:00:00.002693,00:00:00.004324,00:00:00.002044}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_bonuses()', true, '2020-09-10 08:39:46.847862', '00:10:00', NULL, '{00:00:00.004265,00:00:00.004304,00:00:00.00239,00:00:00.004527,00:00:00.00435,00:00:00.008041,00:00:00.004748,00:00:00.005094,00:00:00.008425,00:00:00.00554}');
INSERT INTO ng03.dt_processes VALUES ('process_galaxy_market_price()', true, '2020-09-10 08:34:44.300009', '01:00:00', NULL, '{00:00:00.004638,00:00:00.003627,00:00:00.003688,00:00:00.003939,00:00:00.006734,00:00:00.003795,00:00:00.003886,00:00:00.005855,00:00:00.011807,00:00:00.012746}');
INSERT INTO ng03.dt_processes VALUES ('process_merchant_fleet_cleaning()', true, '2020-09-10 08:37:42.363947', '00:10:00', NULL, '{00:00:00.003096,00:00:00.001882,00:00:00.002355,00:00:00.000761,00:00:00.002188,00:00:00.000984,00:00:00.000606,00:00:00.00071,00:00:00.00207,00:00:00.001924}');
INSERT INTO ng03.dt_processes VALUES ('process_fleet_route_cleaning()', true, '2020-09-10 08:37:43.013722', '00:05:00', NULL, '{00:00:00.001099,00:00:00.003072,00:00:00.000912,00:00:00.000934,00:00:00.000874,00:00:00.000879,00:00:00.000928,00:00:00.002565,00:00:00.001135,00:00:00.001208}');
INSERT INTO ng03.dt_processes VALUES ('process_alliance_cleanings()', true, '2020-09-10 08:39:42.939604', '00:01:00', NULL, '{00:00:00.001001,00:00:00.003425,00:00:00.002044,00:00:00.000916,00:00:00.001209,00:00:00.001134,00:00:00.000953,00:00:00.001153,00:00:00.003359,00:00:00.00291}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_sales(''0:00:05'', 50)', true, '2020-09-10 08:40:17.381115', '00:00:05', NULL, '{00:00:00.000202,00:00:00.000535,00:00:00.000779,00:00:00.000459,00:00:00.000401,00:00:00.000761,00:00:00.000892,00:00:00.000115,00:00:00.000115,00:00:00.000107}');
INSERT INTO ng03.dt_processes VALUES ('process_merchant_unloadings()', true, '2020-09-10 08:40:17.381115', '00:00:05', NULL, '{00:00:00.00009,00:00:00.000116,00:00:00.000188,00:00:00.000096,00:00:00.000094,00:00:00.000152,00:00:00.001188,00:00:00.000091,00:00:00.00009,00:00:00.00009}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_bounties(10)', true, '2020-09-10 08:40:17.381115', '00:00:05', NULL, '{00:00:00.000063,00:00:00.000092,00:00:00.000373,00:00:00.000206,00:00:00.000206,00:00:00.000312,00:00:00.000249,00:00:00.000064,00:00:00.000064,00:00:00.000064}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_holidays()', true, '2020-09-10 08:40:17.381115', '00:00:05', NULL, '{00:00:00.000065,00:00:00.00007,00:00:00.000178,00:00:00.00009,00:00:00.000086,00:00:00.000142,00:00:00.000424,00:00:00.000067,00:00:00.000065,00:00:00.000064}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_purchases()', true, '2020-09-10 08:40:17.381115', '00:00:05', NULL, '{00:00:00.000077,00:00:00.00008,00:00:00.000203,00:00:00.000092,00:00:00.00009,00:00:00.000173,00:00:00.000963,00:00:00.000196,00:00:00.000193,00:00:00.000158}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_building_pendings()', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000235,00:00:00.000234,00:00:00.00018,00:00:00.000338,00:00:00.000257,00:00:00.000239,00:00:00.000248,00:00:00.000228,00:00:00.000233,00:00:00.000245}');
INSERT INTO ng03.dt_processes VALUES ('process_alliance_tributes(25)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.00017,00:00:00.000169,00:00:00.000158,00:00:00.000305,00:00:00.00023,00:00:00.000171,00:00:00.000184,00:00:00.000179,00:00:00.00016,00:00:00.000178}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_trainings(''0:00:01'', 10)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000368,00:00:00.000374,00:00:00.000411,00:00:00.000652,00:00:00.000451,00:00:00.000457,00:00:00.000436,00:00:00.000476,00:00:00.000388,00:00:00.000358}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_production(''0:00:00'', 25)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.00026,00:00:00.000261,00:00:00.000259,00:00:00.000504,00:00:00.000336,00:00:00.000379,00:00:00.000333,00:00:00.000328,00:00:00.000262,00:00:00.000344}');
INSERT INTO ng03.dt_processes VALUES ('process_alliance_leavings(10)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000219,00:00:00.00022,00:00:00.000216,00:00:00.000375,00:00:00.000279,00:00:00.000273,00:00:00.000275,00:00:00.000267,00:00:00.000223,00:00:00.000244}');
INSERT INTO ng03.dt_processes VALUES ('process_alliance_nap_breakings(10)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000158,00:00:00.000159,00:00:00.000272,00:00:00.000301,00:00:00.000224,00:00:00.000173,00:00:00.000175,00:00:00.000176,00:00:00.000156,00:00:00.000169}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_shipyard_waitings(''0:00:01'', 20)', true, '2020-09-10 08:40:19.70904', '00:00:00.5', NULL, '{00:00:00.000249,00:00:00.000444,00:00:00.000248,00:00:00.000405,00:00:00.00039,00:00:00.000422,00:00:00.000484,00:00:00.000406,00:00:00.000394,00:00:00.000436}');
INSERT INTO ng03.dt_processes VALUES ('process_fleet_movings(''0:00:01'', 25)', true, '2020-09-10 08:40:19.70904', '00:00:00.5', NULL, '{00:00:00.000195,00:00:00.000211,00:00:00.000195,00:00:00.000246,00:00:00.000202,00:00:00.000213,00:00:00.000319,00:00:00.000248,00:00:00.000271,00:00:00.000286}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_credit_production(''0:00:00'', 50)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000744,00:00:00.000638,00:00:00.000972,00:00:00.001171,00:00:00.000803,00:00:00.00071,00:00:00.000666,00:00:00.000674,00:00:00.000636,00:00:00.00065}');
INSERT INTO ng03.dt_processes VALUES ('process_alliance_war_endings(10)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000327,00:00:00.000426,00:00:00.000225,00:00:00.000302,00:00:00.000255,00:00:00.000354,00:00:00.000332,00:00:00.000325,00:00:00.000343,00:00:00.000369}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_score(''0:00:00'', 50)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000211,00:00:00.000254,00:00:00.000321,00:00:00.000278,00:00:00.000229,00:00:00.000264,00:00:00.000241,00:00:00.000258,00:00:00.000332,00:00:00.000243}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_research_pendings()', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.00016,00:00:00.000243,00:00:00.000223,00:00:00.000197,00:00:00.00016,00:00:00.000162,00:00:00.000157,00:00:00.000174,00:00:00.000162,00:00:00.000162}');
INSERT INTO ng03.dt_processes VALUES ('process_fleet_waitings()', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000169,00:00:00.000215,00:00:00.000191,00:00:00.00019,00:00:00.000166,00:00:00.000179,00:00:00.000174,00:00:00.000177,00:00:00.000194,00:00:00.000159}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_building_destructions(''0:00:01'', 10)', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000306,00:00:00.000386,00:00:00.000371,00:00:00.000391,00:00:00.000311,00:00:00.000325,00:00:00.000323,00:00:00.000378,00:00:00.000347,00:00:00.000326}');
INSERT INTO ng03.dt_processes VALUES ('process_profile_deletions()', true, '2020-09-10 08:40:19.70904', '00:00:01', NULL, '{00:00:00.000203,00:00:00.000264,00:00:00.000208,00:00:00.000298,00:00:00.000211,00:00:00.000243,00:00:00.000211,00:00:00.00024,00:00:00.000249,00:00:00.000217}');
INSERT INTO ng03.dt_processes VALUES ('process_planet_ship_pendings(''0:00:01'', 20)', true, '2020-09-10 08:40:19.70904', '00:00:00.5', NULL, '{00:00:00.000442,00:00:00.000435,00:00:00.000446,00:00:00.000481,00:00:00.000383,00:00:00.000483,00:00:00.000465,00:00:00.00046,00:00:00.000431,00:00:00.000457}');
INSERT INTO ng03.dt_processes VALUES ('process_fleet_recyclings(''0:00:01'', 25)', true, '2020-09-10 08:40:19.70904', '00:00:00.5', NULL, '{00:00:00.000197,00:00:00.000223,00:00:00.000212,00:00:00.000229,00:00:00.000192,00:00:00.000238,00:00:00.000223,00:00:00.000233,00:00:00.000202,00:00:00.000205}');


--
-- Data for Name: dt_research_building_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_research_building_reqs VALUES (105, 206, 3);
INSERT INTO ng03.dt_research_building_reqs VALUES (405, 206, 5);
INSERT INTO ng03.dt_research_building_reqs VALUES (410, 96, 1);


--
-- Data for Name: dt_research_research_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_research_research_reqs VALUES (202, 201, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (203, 201, 2);
INSERT INTO ng03.dt_research_research_reqs VALUES (204, 201, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (204, 203, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (205, 201, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (206, 201, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (206, 205, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (403, 401, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (404, 401, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (502, 501, 2);
INSERT INTO ng03.dt_research_research_reqs VALUES (505, 504, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (501, 901, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (405, 401, 4);
INSERT INTO ng03.dt_research_research_reqs VALUES (406, 401, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (3, 1, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (902, 901, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (421, 420, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (503, 501, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (504, 501, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (503, 502, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (506, 501, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (505, 501, 4);
INSERT INTO ng03.dt_research_research_reqs VALUES (403, 402, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (506, 403, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (105, 404, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (406, 404, 9);
INSERT INTO ng03.dt_research_research_reqs VALUES (402, 401, 2);
INSERT INTO ng03.dt_research_research_reqs VALUES (510, 102, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (102, 101, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (110, 32, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (110, 902, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (908, 1, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (908, 901, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (908, 907, 4);
INSERT INTO ng03.dt_research_research_reqs VALUES (907, 901, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (907, 102, 4);
INSERT INTO ng03.dt_research_research_reqs VALUES (906, 901, 4);
INSERT INTO ng03.dt_research_research_reqs VALUES (906, 102, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (905, 901, 3);
INSERT INTO ng03.dt_research_research_reqs VALUES (905, 102, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (904, 901, 2);
INSERT INTO ng03.dt_research_research_reqs VALUES (903, 902, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (903, 901, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (303, 301, 10);
INSERT INTO ng03.dt_research_research_reqs VALUES (303, 40, 1);
INSERT INTO ng03.dt_research_research_reqs VALUES (509, 501, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (519, 510, 5);
INSERT INTO ng03.dt_research_research_reqs VALUES (109, 101, 5);


--
-- Data for Name: dt_researches; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_researches VALUES (110, 10, 'advanced_deployement', 'Déploiement avancé de bâtiment', 'En améliorant la technologie des vaisseaux de colonisation, il sera possible de créer des vaisseaux spécialement prévus pour déployer un bâtiment très rapidement sur les bases d''une colonie déjà existante.<br/>

Malheureusement, tous les bâtiments ne peuvent pas être adaptés à cette technologie.', 2, 1, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (501, 50, 'weaponry', 'Armement', 'Recherchez de nouvelles armes afin d''équiper vos vaisseaux. Sans armes, vous serez limités à vous déplacer en vaisseau cargo.<br/>

L''arme de base est le canon laser, facile à produire avec une bonne cadence de tir, il équipera vos premiers vaisseaux légers.', 3, 5, 1, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (203, 20, 'mining', 'Extraction de minerai', 'Des améliorations au niveau du rendement sont effectuées ce qui augmente légèrement la production de minerai.<br/>

Chaque niveau augmente la production de minerai de 1%.', 2, 5, 0, 90, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (206, 20, 'improved_refining', 'Extraction d''hydrocarbure améliorée', 'L''amélioration de vos raffineries réduit les pertes liées au traitement des hydrocarbures.<br/>

Chaque niveau augmente la production d''hydrocarbure de 1%.', 7, 5, 0, 2000, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (402, 40, 'nuclear_physics', 'Physique nucléaire', 'La physique nucléaire est l''étude du comportement du noyau atomique.<br/>

Effectuez des recherches dans ce domaine pour trouver des applications pratiques tel que des centrales d''énergie ou des armes.', 2, 3, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (502, 50, 'rockets', 'Roquettes', 'Les roquettes sont des projectiles autopropulsés non guidés principalement utilisés par les vaisseaux de tailles moyennes pour endommager et détruire des cibles plus importantes.<br/>

Une usine d''armement léger est nécessaire pour construire les lance-roquettes.', 2, 1, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (503, 50, 'missiles', 'Missiles', 'Les missiles constituent une très grande amélioration des roquettes, une fois qu''une cible est acquise, le missile se dirige tout seul vers celle-ci ce qui le rend utilisable par n''importe quel vaisseau.<br/>

Les missiles se dirigent aussi facilement que le meilleur des chasseurs cependant ils peuvent être esquivés par ceux-ci. Lorsque le missile n''a plus de combustible, sa charge est automatiquement désactivée afin d''éviter de se faire endommager par ses propres missiles en les percutant ce qui arrive très rarement.<br/>

Une usine d''armement léger est nécessaire pour construire les lance-missiles.', 4, 1, 0, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (504, 50, 'laser_turrets', 'Tourelles à canon laser', 'Les tourelles à canon laser donnent à vos vaisseaux moins maniables une chance de cibler les vaisseaux plus légers et plus maniables. Elles deviennent de plus en plus essentielles à mesure que vos vaisseaux s''allourdissent et perdent en maniabilité.<br/>

Une usine d''armement léger est nécessaire pour construire ces tourelles.', 2, 3, 0, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (505, 50, 'railgun', 'Railgun', 'Le railgun est un nouveau type de tourelle reposant sur l''envoi de projectiles à très grande vitesse pour un effet dévastateur. Bien que le railgun soit aidé par un ordinateur qui anticipe la direction du vaisseau ciblé, il est assez facile d''éviter ses projectiles.<br/>

Les premiers types de railgun peuvent être construits dans une usine d''armement léger, cependant les railguns plus avancés demanderont une usine d''armement lourd.', 5, 3, 0, 210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (506, 50, 'ion_cannon', 'Canon à ion', 'Le canon à ion tire des jets de particules ionisées traversant les boucliers. Sa spécificité repose sur le fait qu''il n''inflige pas directement de dégats physique mais surcharge les circuits électriques de la cible pouvant provoquer d''importantes explosions.<br/>

Une usine d''armement lourd est nécessaire pour construire les canons à ion.', 6, 1, 0, 290, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (510, 50, 'enhanced_shield', 'Déflecteurs améliorés', 'L''amélioration des déflecteurs permet de mieux régler la force des boucliers sur les différentes parties de sa surface suivant l''origine de la menace.<br/>

Chaque niveau augmente l''efficacité des boucliers de 5%.', 6, 5, 0, 500, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (902, 90, 'utility_ship_construction', 'Construction de vaisseaux utilitaires', 'Les vaisseaux utilitaires regroupent :<br/>

- Les vaisseaux de transport qui sont de grandes coques vides servant à transporter vos ressources ou du personnel vers une autre planète. Un grand équipage est nécessaire pour l''entretien de ces vaisseaux.<br/>

- Les vaisseaux de colonisation qui sont des vaisseaux construit pour se déployer automatiquement en un bâtiment fonctionnel.<br/>

- Les vaisseaux de recyclage qui vous serviront à récupérer des ressources parmi les débris laissés après des batailles.<br/>

Un chantier spatial est nécessaire pour construire la plupart de ces vaisseaux.', 1, 5, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (401, 40, 'science', 'Science', 'Cette branche vous permet de découvrir de nouvelles sources d''énergies pour un usage pacifique ou militaire.', 3, 5, 2, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (204, 20, 'improved_mining', 'Extraction de minerai améliorée', 'L''amélioration des machines d''extraction permet une légère augmentation de la production de minerai.<br/>

Chaque niveau augmente la production de minerai de 1%.', 7, 5, 0, 2000, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (22, 2, 'bonus_soldiers', 'Bonus d''entretient des soldats', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (301, 30, 'planet_control', 'Gestion d''empire', 'Permet d''augmenter le nombre maximum de planètes que vous pouvez gérer de 1 par niveau.', 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (101, 10, 'propulsion', 'Propulsion', 'L''élément primordial de tout vaisseau est la propulsion car un vaisseau immobile est une cible facile.<br/>

Avant de pouvoir élaborer de nouveaux chassis pour vos vaisseaux, vous devez rechercher des moteurs capables de propulser ceux-ci. Plus la propulsion sera puissante, plus les chassis seront importants.<br/>

Chaque niveau augmente la vitesse des vaisseaux de 1%.', 1, 5, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (32, 3, 'unlock_r_advanced_deployement', 'Déblocage du déploiement avancé de bâtiment', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (102, 10, 'energy_conservation', 'Conservation de l''énergie', 'La propulsion est le système qui consomme le plus de puissance sur un vaisseau.<br/>

Effectuez des recherches dans ce domaine pour pouvoir équiper vos plus gros vaisseaux de moteurs sans pour autant être un gouffre en énergie.<br/>

Ces recherches sont applicables à la gestion d''énergie de vos colonies et permet d''augmenter la production d''énergie de vos centrales.<br/>

Chaque niveau augmente la production d''énergie des centrales de 2%.', 3, 5, 0, 220, 0, 0, 0.02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (907, 90, 'cruiser_construction', 'Construction de croiseurs', 'Les croiseurs ont été pensés pour être robustes et avoir une bonne puissance de feu aussi la coque n''a pas été prévue pour accueillir un autre type d''arme que des railguns.<br/>

Un chantier spatial est nécessaire pour construire les croiseurs.', 6, 3, 0, 600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (1, 0, 'evil_science', 'Technologie des fossoyeurs', 'La science spécifique aux technologies des fossoyeurs', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.25, 0.3, 0.5, 0.45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (420, 40, 'energy_transfer', 'Transfert d''énergie', 'Cette technologie permet de transférer la  production d''énergie d''une planète vers une autre grâce à des satellites émetteurs et récepteurs placés en orbite.<br/>

Le système n''est pas parfait et une perte d''énergie est à prévoir suivant la distance séparant les planètes.<br/>

Une rectenna est requise pour faire le lien entre la colonie et les satellites.', 1, 1, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.6, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (421, 40, 'enhanced_energy_transfer', 'Transfert d''énergie amélioré', 'Chaque niveau améliore l''efficacité de vos satellites émetteurs d''énergie de 5% pour une distance de 100 unités.', 6, 5, 0, 1500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (5, 0, 'special_merchant_contract', 'Special contrat marchand', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (12, 1, 'unlock_s_merchant_ship', 'Déblocage de la caravelle marchande', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (403, 40, 'plasma_physics', 'Physique des plasmas', 'La physique des plasmas est l''étude des propriétés des gaz ionisés à haute température, tels qu''on les trouve au coeur des étoiles.<br/>

Maîtriser cette énergie vous permettra de trouver des applications pratiques tel que des centrales d''énergie ou des armes.', 4, 3, 0, 1600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (404, 40, 'quantum_physics', 'Physique quantique', 'La physique quantique étudie les lois fondamentales de la physique au niveau subatomique. Faire des recherches dans ce domaine vous permettra sûrement de développer de nouvelles sources d''énergie.', 6, 3, 0, 700, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (31, 3, 'bonus_cheaper_research', 'Bonus recherche moins couteuse', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.2, 0, 0, -0.2, -0.05, 0, 0, 0, 0, 0, 0.03, 0, 0.03, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (406, 40, 'scalar_waves', 'Ondes scalaires', 'L''étude des ondes scalaires pourrait bien être l''étape majeure suivant la physique quantique. Nos scientifiques sont partagés quant à la réalité de ces ondes mais celles-ci pourraient être responsables de la gravité et de l''écoulement du temps.', 10, 5, 0, 4000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (901, 90, 'mechanic', 'Mécanique', 'La recherche en mécanique permet de trouver de nouveaux designs dans la construction de vaisseaux et l''amélioration de la vitesse de construction de ceux-ci en optimisant les étapes de construction.<br/>

Chaque niveau augmente la vitesse de construction des vaisseaux de 1%.', 3, 5, 1, 50, 0, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (405, 40, 'planetology', 'Planétologie', 'La planétologie est la science de l''étude des planètes. Faites des recherches dans ce domaine afin que vos scientifiques cherchent des solutions pour augmenter la place disponible sur vos planètes.<br/>

Vous avez besoin de 5 centres de recherche pour développer cette recherche.<br/>

Une fois débloqué, vous pourrez construire 2 nouveaux types de bâtiment sur vos colonies permettant d''augmenter la place sur celles-ci.', 8, 1, 0, 6000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (3, 0, 'merchant_science', 'Technologie marchande', 'La science spécifique aux technologies marchandes.', 0, 1, 0, 0, 0.6, 0.6, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (410, 40, 'sandworm_study', 'Etude des vers de sable', 'Les vers de sable peuvent être trouvés sur quelques rares planètes. Ils sont gigantesques et sont attirés par tout ce qui émet des vibrations régulières.<br/>

Nos scientifiques devraient être capables de concevoir une barrière capable de les tenir à l''écart de la colonie.<br/>

Nous avons besoin d''une planète ayant cette particularité afin que nos scientifiques puissent travailler dessus.', 5, 1, 0, 786, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (205, 20, 'refining', 'Extraction d''hydrocarbure', 'Des améliorations au niveau de l''extraction permet d''augmenter la production d''hydrocarbure.<br/>

Chaque niveau augmente la production d''hydrocarbure de 1%.', 2, 5, 0, 90, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (202, 20, 'mass_production', 'Production à la chaîne', 'La standardisation des produits et matériaux utilisés dans la plupart des constructions permet une diminution du temps de construction global des bâtiments et des vaisseaux spaciaux.<br/>

Chaque niveau augmente la vitesse de construction des bâtiments de 4% et de vos vaisseaux de 5%.', 3, 5, 0, 600, 0, 0, 0, 0, 0.04, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (20, 2, 'bonus_faster_ship_construction', 'Bonus vitesse de construction de vaisseaux', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (908, 90, 'dreadnought_construction', 'Construction de dreadnought', 'La classe de vaisseau dreadnought est le grand frère du croiseur. Nos scientifiques ont pensé l''architecture pour que toutes les armes puissent être adaptées à la coque. Pour se faire, le vaisseau a une forme allongée et ses moteurs délivrent une énorme puissance.<br/>

Un chantier spatial est nécessaire pour construire les dreadnoughts.', 10, 3, 0, 3500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (906, 90, 'frigate_construction', 'Construction de frégates', 'Les frégates sont des vaisseaux de taille moyenne dotés d''une coque très modulable qui permet d''accueillir des railguns, des missiles ou même un canon à ion.<br/>

Un chantier spatial est nécessaire pour construire les frégates.', 4, 3, 0, 350, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (30, 3, 'bonus_faster_fleets_build', 'Bonus production d''énergie', 'Votre orientation de scientifique vous procure une production augmentée d''énergie.', 0, 1, 0, 0, 0, 0, 0.2, 0, 0.1, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (21, 2, 'bonus_combat', 'Bonus de combat', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0, 0, 0, 0, 0, 0, 0, -0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0.1, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (40, 4, 'warlord_bonus', 'Seigneur de guerre', 'Votre orientation vous procure une production augmentée de minerai, d''hydrocarbure et d''énergie.', 0, 1, 0, 0, 4, 4, 4, 4, 4, 4, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.75, 0, 0, 0, 0, 0, 1, 1, 3, 3, 3, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (903, 90, 'tactical_ship_construction', 'Construction de vaisseaux tactiques', 'Les vaisseaux tactiques regroupent :<br/>

 - Les vaisseaux mère qui donnent des bonus aux flottes auxquelles ils appartiennent<br/>

 - Les vaisseaux radar qui peuvent être déployés sur une de vos planètes, une planète alliée ou un emplacement vide afin d''obtenir une vision d''un secteur complet pour une durée limitée<br/>

 - Les vaisseaux de brouillage qui peuvent être déployés sur une de vos planètes, une planète alliée ou un emplacement vide pour une durée limitée', 8, 3, 0, 800, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (303, 30, 'warlord_research', 'Gestion d''empire galactique', 'Permet d''augmenter le nombre maximum de planètes que vous pouvez gérer de 10 par niveau.', -4, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (905, 90, 'corvette_construction', 'Construction de corvettes', 'Les corvettes sont des vaisseaux un peu plus gros que les vaisseaux légers mais gardant néanmoins une bonne manoeuvrabilité.<br/>

 Ils bénéficient d''une plus grande puissance ce qui permet de les équiper avec des armes plus grosses ou en plus grand nombre ce qui offre une bonne base pour contrer les vaisseaux légers et attaquer les vaisseaux lourds.<br/>

Les corvettes devraient être équipées de tourelles laser ou de roquettes.<br/>

Vous aurez besoin d''un spatioport pour construire les corvettes.', 2, 3, 0, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (201, 20, 'industry', 'Industrie', 'Vos scientifiques peuvent effectuer des recherches dans le domaine de l''industrie pour améliorer certains bâtiments et machines afin d''augmenter le rendement ou diminuer le temps de construction.<br/>

Chaque niveau augmente la vitesse de construction des bâtiments de 1%.', 3, 5, 0, 40, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (10, 1, 'bonus_buy_sell', 'Bonus achat/vente', '-', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (11, 1, 'bonus_better_production', 'Orientation de marchand', 'Votre orientation de marchand vous procure une production augmentée de minerai et d''hydrocarbure.', 0, 1, 0, 0, 0.05, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.05, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0.05, 0.1, 0.1, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (105, 10, 'jumpdrive', 'Saut hyperspatial', 'Les sauts dans l''hyper-espace permettent de traverser de grandes distances en utilisant les vortex.<br/>

Cette technologie est requise pour les voyages intergalactiques.<br/>

Vous avez besoin de 3 centres de recherche pour développer le saut hyperspatial.', 7, 1, 0, 4000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (904, 90, 'light_ship_construction', 'Construction de vaisseaux légers', 'La coque réduite ne permet pas une grande variété de modifications aussi les vaisseaux de ce type sont limités à deux canons lasers.<br/>

Il ne vous faudra qu''un simple spatioport pour pouvoir construire vos vaisseaux légers.', 1, 3, 1, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (109, 10, 'temp_bonus_speed', 'Surcharge de la propulsion', 'Cette recherche permet d''augmenter la vitesse de tous les vaisseaux de 10% pendant 48 heures.', 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '48:00:00');
INSERT INTO ng03.dt_researches VALUES (509, 50, 'temp_bonus_weapon', 'Surcharge de l''armement', 'Cette recherche permet d''augmenter la puissance de feu de tous les vaisseaux de 10% pendant 48 heures.', 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '48:00:00');
INSERT INTO ng03.dt_researches VALUES (519, 50, 'temp_bonus_shield', 'Surcharge des boucliers', 'Cette recherche permet d''augmenter l''efficacité des boucliers de 10% pendant 48 heures.', 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '48:00:00');
INSERT INTO ng03.dt_researches VALUES (302, 30, 'commanders_control', 'Hiérarchie de commandement', 'Permet d''augmenter le nombre maximum de commandants dont vous pouvez disposer de 1 par niveau.', 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (50, 5, 'exile_bonus', 'Exilé', 'Stats de base des exilés', 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 80, 0, 0, 0, 1, 0, 0, 0, 0, NULL);
INSERT INTO ng03.dt_researches VALUES (0, 0, 'human_science', 'Technologie humaine', 'La science spécifique aux humains', 0, 1, 1, 0, 10, 10, 10, 10, 10, 10, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, -0.9, 0, 5, 20, 0, 0, 0, 0, 0, 0, 0, 0, NULL);


--
-- Data for Name: dt_ship_building_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_ship_building_reqs VALUES (102, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (103, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (201, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (202, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (301, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (301, 203);
INSERT INTO ng03.dt_ship_building_reqs VALUES (302, 203);
INSERT INTO ng03.dt_ship_building_reqs VALUES (205, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (304, 203);
INSERT INTO ng03.dt_ship_building_reqs VALUES (401, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (401, 203);
INSERT INTO ng03.dt_ship_building_reqs VALUES (402, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (402, 303);
INSERT INTO ng03.dt_ship_building_reqs VALUES (404, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (404, 203);
INSERT INTO ng03.dt_ship_building_reqs VALUES (501, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (501, 303);
INSERT INTO ng03.dt_ship_building_reqs VALUES (504, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (504, 303);
INSERT INTO ng03.dt_ship_building_reqs VALUES (101, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (950, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (100, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (105, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (106, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (910, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (150, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (110, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (120, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (151, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (152, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (153, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (154, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (155, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (161, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (162, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (163, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (164, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (165, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (166, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (171, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (121, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (140, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (141, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (505, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (505, 303);
INSERT INTO ng03.dt_ship_building_reqs VALUES (203, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (104, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (142, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (143, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (144, 205);
INSERT INTO ng03.dt_ship_building_reqs VALUES (302, 105);
INSERT INTO ng03.dt_ship_building_reqs VALUES (304, 105);


--
-- Data for Name: dt_ship_research_reqs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_ship_research_reqs VALUES (101, 902, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (201, 501, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (202, 501, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (501, 505, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (102, 902, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (103, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (910, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (910, 12, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (106, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (950, 1, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (105, 902, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (142, 903, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (402, 506, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (504, 505, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (401, 505, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (304, 504, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (301, 504, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (404, 503, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (302, 502, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (150, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (110, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (151, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (152, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (153, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (154, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (155, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (161, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (162, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (163, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (164, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (165, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (166, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (171, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (152, 401, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (161, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (155, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (154, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (153, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (152, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (151, 902, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (162, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (163, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (164, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (165, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (166, 902, 4);
INSERT INTO ng03.dt_ship_research_reqs VALUES (171, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (121, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (106, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (501, 907, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (104, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (401, 906, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (402, 906, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (404, 906, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (301, 905, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (302, 905, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (304, 905, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (201, 904, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (104, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (140, 903, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (141, 903, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (120, 903, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (121, 903, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (505, 505, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (999, 1, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (504, 907, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (104, 12, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (203, 904, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (202, 904, 2);
INSERT INTO ng03.dt_ship_research_reqs VALUES (203, 501, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (505, 907, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (180, 902, 5);
INSERT INTO ng03.dt_ship_research_reqs VALUES (180, 110, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (100, 901, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (143, 903, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (144, 903, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (142, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (143, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (144, 105, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (143, 21, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (144, 31, 1);
INSERT INTO ng03.dt_ship_research_reqs VALUES (605, 505, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (605, 907, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (205, 501, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (205, 904, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (305, 504, 3);
INSERT INTO ng03.dt_ship_research_reqs VALUES (305, 905, 3);


--
-- Data for Name: dt_ships; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.dt_ships VALUES (999, 20, 'ship_remains', 'Débris de vaisseau', 'Restes de vaisseau détruit.', 1000, 200, 0, 0, 0, 0, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (192, 10, 'upg_cargo_I_to_X', 'Upgrade du cargo I en X', 'Upgrade', 42000, 25000, 0, 0, 400, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 10, NULL, 0, 0, 0, true, 101, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (193, 10, 'upg_cargo_V_to_X', 'Upgrade du cargo V', 'upgrade', 25000, 15000, 0, 0, 250, 0, 3600, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 10, NULL, 0, 0, 0, true, 102, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (199, 15, 'upg_mothership', 'Upgrade Vaisseau mère avec saut', 'Upgrade', 60000, 30000, 0, 0, 1000, 0, 18600, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 10, NULL, 0, 0, 0, true, 120, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (102, 10, 'cargo_V', 'Cargo V', 'Avec une capacité de 100 000 unités et une bonne hyper propulsion, le cargo V est parfait pour le déplacement de ressources entre secteurs.', 21000, 18000, 0, 0, 350, 100000, 7200, 0, 9000, 4000, 0, 0, 0, 0, 78, 1100, 100, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 40, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (110, 10, 'recycler', 'Recolteur', 'Le récolteur est un vaisseau spécialisé dans le recyclage des carcasses de vaisseaux et l''exploitation d''astéroides.<br/>

Il peut récupérer et recycler jusqu''a 3000 ressources par heure. Equipé de systèmes de transfert de ressources, le récolteur peut ainsi stocker minerais et hydrocarbures dans les autres vaisseaux de sa flotte.', 10000, 7000, 0, 0, 100, 5000, 5760, 0, 6000, 5000, 0, 0, 0, 0, 34, 1000, 100, NULL, 3000, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 5, 500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (101, 10, 'cargo_I', 'Cargo I', 'Le cargo I est un vaisseau robuste qui peut transporter jusqu''à 30 000 unités de ressources ou de personnel.', 8000, 8000, 0, 0, 200, 30000, 3600, 0, 3000, 1000, 0, 0, 0, 0, 32, 1200, 200, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 20, 500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (103, 10, 'cargo_X', 'Cargo X', 'Le cargo X peut transporter jusqu''à 225 000 unités.', 48000, 27000, 0, 0, 600, 225000, 10800, 0, 25000, 20000, 0, 0, 0, 0, 150, 1000, 50, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 75, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (191, 10, 'upg_cargo_I_to_V', 'Upgrade du cargo I', 'Upgrade', 17000, 10000, 0, 0, 150, 0, 3600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, true, 101, 102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (106, 10, 'jumper', 'Jumper', 'Le jumper permet à un groupe de vaisseaux d''effectuer des sauts permettant de relier les galaxies.<br/>

Ce vaisseau offre une capacité de saut intergalactique de 2000.', 45000, 35000, 0, 0, 16, 0, 20400, 0, 5000, 3000, 0, 0, 0, 0, 40, 800, 10, NULL, 0, 0, 2000, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 10, 8000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (140, 15, 'sector_probe', 'Vaisseau radar', 'Ce vaisseau permet de déployer un satellite qui augmente la puissance radar de 1 pour une durée de 8 heures.<br/>

Le vaisseau est détruit une fois déployé.', 30000, 20000, 0, 0, 0, 0, 19000, 0, 1, 0, 0, 0, 0, 0, 100, 22500, 1, 600, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 2500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (601, 60, 'redempteur', 'Rédempteur', '', 2000000, 1800000, 0, 0, 6000, 10000, 280000, 0, 1000000, 3200000, 1, 28, 900, 28, 7600, 450, 350, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 8000, 500000, 1500, 0, 0, 0, 40, 75, 30, 91, 5, 1000, 0, 100000, 1, 0, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (950, 50, 'imperial_cruiser', 'Croiseur impérial', '', 900000, 800000, 100000, 0, 25000, 25000, 240000, 0, 15000, 25000, 90, 7, 720, 7, 3400, 750, 470, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 200, 5000, 250, 0, 250, 0, 35, 60, 25, 90, 1, 10, 0, 0, 1, 0, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (901, 90, 'mine_field', 'Mine', 'Mine explosive', 20000, 10000, 0, 0, 0, 0, 700, 0, 1, 0, 0, 100, 200, 100, 100, 0, 1, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (910, 10, 'caravel', 'Caravelle marchande', 'La caravelle marchande est un petit vaisseau comparé au cargo X, cependant sa taille, sa forme, son aménagement de l''équipage et sa modularité pour accueillir les différents types de ressource lui confèrent une très nette supériorité aux autres vaisseaux de transport.<br/>

La caravelle peut transporter jusqu''à 100 000 unités de ressource.<br/>

Comparée au cargo X, la caravelle dispose de plusieurs atouts dont un blindage digne d''un vaisseau de guerre et une vitesse supérieure. De plus, à capacité égale, les caravelles marchandes demandent bien moins d''entretien.', 12000, 8000, 0, 0, 300, 100000, 3600, 0, 8000, 10000, 0, 0, 0, 0, 40, 1300, 200, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 10, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (952, 20, 'mower', 'Faucheur', '', 1100, 900, 15, 0, 3, 5, 500, 0, 300, 50, 10, 1, 2300, 2, 8, 1650, 1500, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 8, 100, 10, 0, 0, 10, -30, 50, 0, 5, 1, 1, 0, 0, 1, 250, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (953, 80, 'fortress', 'Forteresse', '', 10000000, 20000000, 0, 0, 30000, 10000000, 500000, 0, 63568, 53392, 15, 400, 100, 400, 20000, 150, 600, NULL, 20000, 10000, 32500, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 20000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1000, 0, 0, 1, 0, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (954, 40, 'escorter', 'Escorteur', '', 10000, 5000, 0, 0, 100, 50, 2880, 0, 200, 250, 40, 4, 400, 4, 26, 550, 330, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 26, 1000, 0, 50, 30, 70, 30, 40, 25, 50, 3, 7, 0, 0, 1, 450, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (955, 30, 'rogue_ctm', 'Foudroyeur', '', 4500, 2600, 0, 0, 32, 50, 2240, 0, 3000, 0, 0, 16, 2300, 16, 15, 1200, 900, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 10, 750, 0, 0, 0, 10, 0, 0, 0, 25, 2, 3, 0, 0, 1, 200, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (960, 10, 'rogue_recycler', 'Collecteur', '', 25000, 15000, 1000, 0, 100, 15000, 18000, 0, 6000, 1200, 0, 0, 0, 0, 80, 1000, 400, NULL, 15000, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 50, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (100, 10, 'probe', 'Sonde', 'Petit vaisseau de reconnaissance extrémement rapide équipé d''un petit dispositif permettant d''analyser la planète qu''il orbite.', 500, 500, 0, 0, 0, 0, 180, 0, 1, 0, 0, 0, 0, 0, 1, 25000, 1, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 1, 50, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (104, 10, 'cargo_Z', 'Convoyeur', 'Le convoyeur est spécialisé dans le transport de ressources intergalactique. Ne possédant pas la vitesse d''une caravelle, il est cependant équipé d''un système de saut intégré qui le rend très utile dès lors qu''il s''agit de déplacer des ressources d''une galaxie à une autre.<br/>

Ce cargo peut transporter jusqu''à 1 000 000 d''unités.', 120000, 80000, 0, 0, 1000, 1000000, 36000, 0, 75000, 60000, 0, 0, 0, 0, 300, 1000, 25, NULL, 0, 0, 300, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 175, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (105, 10, 'droppods', 'Barge d''invasion', 'Les barges d''invasion sont utilisées lors de l''invasion de planètes, plus vous disposez de barges dans votre flotte, plus vous pouvez envoyer de soldats en même temps.<br/>

Cette barge augmente la capacité d''invasion de la flotte de 1 000 soldats.', 15000, 12000, 0, 0, 4, 1000, 4720, 0, 10000, 2000, 0, 0, 0, 0, 54, 1000, 10, NULL, 0, 1000, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 40, 200, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 3, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (141, 15, 'jammer_probe', 'Vaisseau de brouillage', 'Ce vaisseau, une fois déployé, génère une onde qui augmente le brouillage radar de 10 pour une durée de 8 heures.<br/>

Le vaisseau est détruit à son utilisation.', 100000, 70000, 0, 0, 0, 0, 19000, 0, 1, 0, 0, 0, 0, 0, 340, 20000, 1, 601, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 200, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (142, 15, 'd_vortex_medium', 'Harmoniseur quantique', 'Ce vaisseau, une fois déployé, crée un vortex de stabilité 2 pour une durée de 12 heures.<br/>

Le vaisseau est détruit à son utilisation.', 100000, 70000, 0, 0, 0, 0, 19000, 0, 500, 0, 0, 0, 0, 0, 340, 2000, 1, 604, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 200, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 100, 1, 0, 1, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (143, 15, 'd_vortex_strong', 'Stabilisateur quantique', 'Ce vaisseau, une fois déployé, déchire l''espace temps et crée un vortex permettant de faire passer les plus gros vaisseaux pour une durée de 30 minutes.<br/>

Le vaisseau est détruit à son utilisation.', 160000, 100000, 0, 0, 0, 0, 24000, 0, 500, 0, 0, 0, 0, 0, 520, 1200, 1, 605, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 260, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1000, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (144, 15, 'd_vortex_inhibitor', 'Inhibiteur quantique', 'Ce vaisseau, une fois déployé, déstabilise le vortex à proximité et réduit sa stabilité de 8 points pour une durée de 2 jours.<br/>

Le vaisseau est détruit à son utilisation.', 80000, 50000, 0, 0, 0, 0, 16000, 0, 500, 0, 0, 0, 0, 0, 260, 1200, 1, 606, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 130, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2000, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (162, 11, 'd_workshop1', 'D: Atelier', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "atelier".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 13000, 6600, 0, 0, 2, 0, 37600, 0, 300, 0, 0, 0, 0, 0, 40, 450, 1, 204, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 12500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (120, 15, 'mothership_combat', 'Vaisseau mère de combat', 'Ce vaisseau mère de combat n''est pas un vaisseau de combat classique, en ce qu''il ne possède aucune arme. Cependant, il est capable d''augmenter significativement l''efficacité de la flotte à laquelle il appartient.<br/>

Les données de ses nombreux senseurs et relais géotactiques sont transmises à toute la flotte, ce qui permet aux pilotes et artilleurs des vaisseaux des manoeuvres plus précises et des tirs plus mortels.<br/>

Bonus conférés à la flotte contenant un vaisseau mère:<br/>

Boucliers augmentés de 10%<br/>

Manoeuvrabilité augmentée de 10%<br/>

Ciblage augmenté de 20%<br/>

Dégats augmentés de 10%', 300000, 250000, 0, 0, 30000, 100000, 76800, 0, 150000, 75000, 0, 0, 0, 0, 1100, 1000, 10, NULL, 0, 0, 1000, true, NULL, NULL, 0, 0.1, 0.1, 0.2, 0.1, 0, 0, 0, 2000, 80000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 100, 0, 0, 1, 0, 4, 5000, false, 1);
INSERT INTO ng03.dt_ships VALUES (401, 40, 'assault_frigate', 'Frégate d''assaut', 'La frégate d''assaut est un vaisseau lourd équipé de 3 railguns R-1. Moins maniable mais plus résistant que les corvettes, la frégate d''assaut offre un tir de soutien efficace.<br/><br/>

Arme: Railgun R-1', 9000, 5000, 0, 0, 50, 50, 2080, 0, 7500, 2500, 1, 3, 1000, 3, 28, 900, 680, NULL, 0, 0, 16, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 16, 1000, 0, 0, 130, 0, 55, 45, 25, 60, 3, 5, 0, 0, 1, 0, 3, 10, false, 1);
INSERT INTO ng03.dt_ships VALUES (501, 50, 'cruiser', 'Croiseur', 'Conçu pour constituer le fer de lance de vos flottes de combat, le croiseur est un vaisseau puissament armé dont le blindage lui permet de résister à un feu nourri.<br/>

Bien que ses railguns améliorés le rendent dévastateur face aux vaisseaux lourds, il n''est pas équipé pour combattre efficacement les vaisseaux légers, contre lesquels son blindage le rend extrêmement résistant.<br/><br/>

Arme: Railgun R-2', 20000, 14000, 0, 0, 250, 200, 4400, 0, 10000, 20000, 1, 4, 720, 4, 68, 800, 400, NULL, 0, 0, 50, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 3000, 0, 0, 400, 0, 30, 65, 45, 85, 4, 10, 0, 0, 1, 0, 4, 50, false, 1);
INSERT INTO ng03.dt_ships VALUES (504, 50, 'battle_cruiser', 'Croiseur de combat', 'Le croiseur de combat est une version du croiseur optimisée pour la destruction de vaisseaux lourds.<br/>

Bénéficiant d''un bouclier amélioré, la structure du chassis a été repensée pour accueillir 6 railguns à canon long et de grandes quantités de munitions perforantes lourdes.<br/>

Comme son petit frère, il reste inefficace contre les flottes de petits vaisseaux, bien que son blindage en alliage thermo-renforçé le rende très résistant.<br/><br/>

Arme: Railgun R-3', 35000, 25000, 0, 0, 500, 300, 7900, 0, 10000, 25000, 1, 6, 720, 6, 120, 800, 400, NULL, 0, 0, 100, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 90, 5000, 0, 0, 750, 0, 35, 70, 50, 85, 4, 10, 0, 0, 1, 0, 4, 50, false, 1);
INSERT INTO ng03.dt_ships VALUES (302, 30, 'heavy_corvette', 'Corvette lourde', 'La corvette lourde se voit dotée d''un lance roquettes afin de cibler et endommager les vaisseaux les plus lourds en priorité.<br/>

La taille des lance roquettes n''étant pas vraiment adaptée au chassis des corvettes, une partie de la structure a du être allégée réduisant l''armure cependant la manoeuvrabilité du vaisseau reste correcte.<br/><br/>

Arme: Roquette', 2000, 2500, 0, 0, 8, 25, 800, 0, 1500, 0, 1, 1, 1100, 1, 9, 1200, 960, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 6, 500, 0, 225, 0, 0, 10, 35, 20, 35, 2, 2, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (163, 11, 'd_research_center', 'D: Centre de recherche', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "centre de recherche".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 33000, 23600, 0, 0, 2, 0, 117600, 0, 300, 0, 0, 0, 0, 0, 113, 450, 1, 206, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 25000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (164, 11, 'd_military_barracks', 'D: Caserne militaire', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "caserne militaire".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 27000, 12600, 0, 0, 2, 0, 117600, 0, 300, 0, 0, 0, 0, 0, 79, 450, 1, 208, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 25000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (304, 30, 'multi_gun_corvette', 'Corvette à tir multiple', 'Dotée de 5 tourelles T-1, cette corvette peut prendre pour cible plusieurs chasseurs à la fois et les abattre avec une précision redoutable.<br/><br/>

Arme: Laser C-1 sur tourelle', 2500, 2500, 0, 0, 10, 25, 950, 0, 1500, 0, 1, 5, 2300, 5, 10, 1200, 970, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 7, 750, 0, 0, 0, 15, 11, 36, 21, 36, 2, 2, 0, 0, 1, 0, 2, 4, true, 1);
INSERT INTO ng03.dt_ships VALUES (205, 20, 'defense_drone', 'Drone de protection', 'Les drones sont des vaisseaux automatisés ne demandant pas de pilote.<br/>

Bien qu''ils soient armés d''un petit laser, leur principal atout est d''intercepter les tirs ennemis.<br/>

Ces drones sont construits par 10.', 2500, 250, 0, 0, 0, 0, 700, 0, 30, 0, 1, 1, 1, 1, 1, 3000, 1, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 1, 100, 0, 0, 0, 1, -10000, -10000, -10000, -10000, 1, 0, 0, 0, 10, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (150, 10, 'colonizer_I', 'Vaisseau de colonisation', 'Le vaisseau de colonisation est prévu pour atterrir en toute sécurité sur la surface d''une planète vierge et déployer un bâtiment de type "colonie".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

<br/>

Note: le vaisseau de colonisation ne peut pas coloniser une planète déjà occupée.

', 25000, 11600, 0, 0, 2500, 0, 54400, 0, 10000, 2000, 0, 0, 0, 0, 72, 450, 1, 101, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 100, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (151, 11, 'd_construction_plant', 'D: Usine de préfabriqués', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "usine de préfabriqué".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 7000, 3800, 0, 0, 2, 0, 52800, 0, 300, 0, 0, 0, 0, 0, 21, 450, 1, 102, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (152, 11, 'd_geothermal_power', 'D: Centrale géothermique', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "centrale géothermique".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 6000, 3000, 0, 0, 2, 0, 20400, 0, 300, 0, 0, 0, 0, 0, 18, 450, 1, 118, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (404, 40, 'missile_frigate', 'Frégate à missiles', 'La frégate à missiles est équipée de lance-missiles de type M-1 capables de poursuivre efficacement les vaisseaux de taille moyenne tels que les corvettes.<br/><br/>

Arme: Missile M-1', 13000, 12000, 0, 0, 120, 50, 4000, 0, 6000, 2500, 1, 8, 2000, 8, 50, 950, 685, NULL, 0, 0, 16, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 35, 2000, 0, 50, 0, 0, 60, 45, 30, 65, 3, 5, 0, 0, 1, 0, 3, 5, false, 1);
INSERT INTO ng03.dt_ships VALUES (166, 11, 'd_hydrocarbon_hangar2', 'D: Hangar à hydrocarbure', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "hangar à hydrocarbure".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 30000, 16600, 0, 0, 2, 0, 40400, 0, 300, 0, 0, 0, 0, 0, 93, 450, 1, 221, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 12500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (595, 50, 'upg_elite_cruiser', 'Upgrade Croiseur d''Elite', 'Upgrade', 15000, 10000, 0, 0, 0, 0, 3600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, true, 504, 505, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 100, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (155, 11, 'd_laboratory', 'D: Laboratoire', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "laboratoire".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 7500, 4600, 0, 0, 2, 0, 32200, 0, 300, 0, 0, 0, 0, 0, 24, 450, 1, 106, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (161, 11, 'd_construction_plant2', 'D: Usine d''automates', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "usine d''automates".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 27500, 17600, 0, 0, 2, 0, 103200, 0, 300, 0, 0, 0, 0, 0, 90, 450, 1, 202, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (165, 11, 'd_ore_hangar2', 'D: Hangar à minerai', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "hangar à minerai".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 30000, 16600, 0, 0, 2, 0, 37600, 0, 300, 0, 0, 0, 0, 0, 93, 450, 1, 220, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 50, 12500, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (203, 20, 'predator', 'Prédateur', 'Le prédateur est basé sur l''intercepteur offrant ainsi une bonne maniabilité et vitesse, il est équipé d''un canon laser C-3 version améliorée du canon C-2 avec un temps de recharge plus court offrant encore plus de précision.<br/>

Offrant une puissance de feu légèrement supérieure à l''intercepteur, il est aussi prévu pour faciliter la formation d''escadrons composés de 5 vaisseaux.<br/>

<i>Élu modèle de l''année dans sa catégorie.</i><br/><br/>

Arme: Laser C-3', 1000, 1500, 0, 0, 2, 0, 590, 0, 275, 0, 1, 1, 2450, 1, 5, 1550, 1505, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 2, 75, 0, 0, 0, 35, 1, 91, 1, -24, 1, 1, 0, 5, 1, 0, 2, 5, true, 1);
INSERT INTO ng03.dt_ships VALUES (505, 50, 'elite_cruiser', 'Croiseur d''élite', 'Le croiseur d''élite est un croiseur de combat bénéficiant d''améliorations au niveau de la vitesse de déplacement, de la manoeuvrabilité, de la précision de tir et de la puissance de feu.<br/>

<i>A reçu 5 étoiles au crash-test uni NCAP</i><br/><br/>

Arme: Railgun R-3', 35000, 25000, 0, 0, 500, 300, 8400, 0, 10000, 25000, 1, 6, 725, 6, 120, 900, 405, NULL, 0, 0, 100, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 80, 5000, 0, 0, 800, 0, 36, 71, 51, 90, 4, 10, 0, 100, 1, 0, 4, 100, false, 1);
INSERT INTO ng03.dt_ships VALUES (154, 11, 'd_hydrocarbon_hangar1', 'D: Réserve à hydrocarbure', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "réserve d''hydrocarbure".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 6000, 3100, 0, 0, 2, 0, 19500, 0, 300, 0, 0, 0, 0, 0, 18, 450, 1, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (171, 11, 'd_synthesis_plant', 'D: Usine de synthèse', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "usine de synthèse".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 105000, 82600, 0, 0, 2, 0, 182400, 0, 300, 0, 0, 0, 0, 0, 375, 450, 1, 302, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 100, 50000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 3, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (402, 40, 'ion_frigate', 'Frégate à canon ionique', 'La frégate à canon ionique est un vaisseau atypique, celui-ci ne possède qu''une seule et unique arme : un canon ionique qui peut infliger d''énormes dégats. Cependant, ce canon est lent, non directionnel et la puissance demandée pour tirer est telle qu''il ne possède aucune autre arme pour se défendre le rendant complètement sans défense face à des vaisseaux rapides.<br/><br/>

Arme: Canon ionique', 9000, 7000, 0, 0, 80, 75, 2500, 0, 3500, 2500, 1, 1, 450, 1, 32, 900, 680, NULL, 0, 0, 16, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 20, 1500, 4000, 0, 0, 0, 60, 45, 30, 65, 3, 5, 0, 0, 1, 0, 3, 5, false, 1);
INSERT INTO ng03.dt_ships VALUES (202, 20, 'interceptor', 'Intercepteur', 'Moins lourdement blindé que le chasseur, l''intercepteur est sans aucun doute le vaisseau le plus maniable de sa catégorie ce qui le rend très difficile à cibler. Il est équipé d''un canon laser fixe de type C-2 monté sous le cockpit de l''appareil, ce canon est plus puissant et permet un tir plus précis.<br/><br/>

Arme: Laser C-2', 1000, 1500, 0, 0, 2, 0, 550, 0, 275, 0, 1, 1, 2400, 1, 5, 1500, 1500, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 3, 75, 0, 0, 0, 30, 0, 90, 0, -25, 1, 1, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (201, 20, 'fighter', 'Chasseur', 'Le chasseur est un appareil de combat agile et rapide. Il est équipé d''un canon laser fixe C-1 monté sous le cockpit. Sa manoeuvrabilité le rend difficile à toucher et lui procure une grande précision de frappe. Utilisé en nombre, les chasseurs peuvent être fatals contre les flottes composées de vaisseaux moins maniables.<br/><br/>

Arme: Laser C-1', 800, 1200, 0, 0, 2, 15, 420, 0, 350, 0, 1, 1, 2200, 1, 4, 1450, 1400, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 2, 50, 0, 0, 0, 20, 0, 85, 0, -30, 1, 1, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (121, 15, 'mothership_logistic', 'Vaisseau mère de logistique', 'Ce vaisseau mère est capable d''améliorer significativement la coordination de la flotte à laquelle il appartient lors des opérations de recyclage.<br/>

De plus, son générateur de saut lui permet d''assister de nombreux vaisseaux pour des vols hyperspatiaux et d''augmenter la vitesse globale de la flotte.<br/>

Bonus conférés à la flotte contenant ce vaisseau mère:<br/>

Vitesse augmentée de 15%<br/>

Vitesse du recyclage augmentée de 20%

', 350000, 270000, 0, 0, 31000, 100000, 93600, 0, 100000, 50000, 0, 0, 0, 0, 1240, 1000, 10, NULL, 0, 0, 10000, true, NULL, NULL, 0.15, 0, 0, 0, 0, 0, 0.2, 0, 2000, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 5, 100, 0, 0, 1, 0, 4, 2000, false, 1);
INSERT INTO ng03.dt_ships VALUES (292, 20, 'upg_interceptor', 'Upgrade Intercepteur', 'Upgrade', 250, 350, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, true, 201, 202, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (293, 20, 'upg_predator', 'Upgrade Prédateur', 'Upgrade', 100, 100, 0, 0, 0, 0, 160, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, NULL, 0, 0, 0, true, 202, 203, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 5, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (301, 30, 'light_corvette', 'Corvette légère', 'Dessinée pour remplacer le chasseur, la corvette légère possède 3 tourelles mobiles T-1 qui lui permettent de compenser sa mobilité plus réduite que celle des chasseurs.<br/><br/>

Arme: Laser C-1 sur tourelle', 1500, 2000, 0, 0, 4, 50, 600, 0, 1600, 0, 1, 3, 1500, 3, 7, 1200, 965, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 4, 100, 0, 0, 0, 15, 5, 30, 15, 30, 2, 2, 0, 0, 1, 0, 2, 0, true, 1);
INSERT INTO ng03.dt_ships VALUES (305, 30, 'elite_corvette', 'Corvette d''elite', 'Possédant 4 tourelle mobiles T-2, la corvette d''élite est une valeur sûre dans les affrontements contre les vaisseaux légers.<br/><br/>

Arme: Laser C-2 sur tourelle', 3000, 3000, 0, 0, 8, 50, 1300, 0, 1800, 0, 1, 4, 1700, 4, 12, 1350, 965, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 9, 600, 0, 0, 0, 20, 10, 35, 20, 35, 2, 5, 0, 10, 1, 0, 2, 7, true, 1);
INSERT INTO ng03.dt_ships VALUES (959, 60, 'annihilator', 'Annihilateur', '', 2000000, 1500000, 0, 0, 30000, 30000, 300000, 0, 500000000, 500000000, 1, 200, 1500, 200, 1, 400, 200, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 20000, 5000, 5000, 5000, 5000, 20, 95, 95, 95, 5, 1000000, 0, 0, 1, 2000000, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (951, 60, 'obliterator', 'Oblitérateur', '', 200000, 200000, 0, 0, 30000, 30000, 300000, 0, 200000, 200000, 1, 20, 650, 20, 800, 600, 450, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 20000, 500, 500, 500, 500, 20, 50, 50, 50, 5, 100, 0, 0, 1, 2000, 0, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (605, 60, 'elite_dreadnought', 'Dreadnought d''élite', 'Véritable mastodonte, le dreadnought d''élite bénéficie des dernières découvertes en armement lourd permettant d''annihiler ses cibles avec une précision redoutable.<br/>

En plus d''un armement inégalé, il possède un blindage révolutionnaire offrant jusqu''à 99% de réduction de tout type de dégat et offre un bonus de 10% au bouclier à la flotte.<br/><br/>

Boucliers augmentés de 10%', 1300000, 1000000, 0, 0, 6000, 10000, 300000, 0, 1000000, 2000000, 1, 20, 1000, 20, 4600, 600, 300, NULL, 0, 0, 0, false, NULL, NULL, 0, 0.1, 0, 0, 0, 0, 0, 0, 2000, 300000, 10000, 0, 0, 0, 80, 99, 99, 99, 5, 1000, 0, 5000, 1, 0, 4, 1000, false, 1);
INSERT INTO ng03.dt_ships VALUES (153, 11, 'd_ore_hangar1', 'D: Réserve à minerai', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "réserve de minerai".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 6000, 3100, 0, 0, 2, 0, 18600, 0, 300, 0, 0, 0, 0, 0, 18, 450, 1, NULL, 0, 0, 0, false, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 25, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0, false, 1);
INSERT INTO ng03.dt_ships VALUES (180, 11, 'd_energy_cell', 'D: Caisse d''énergie', 'Ce vaisseau est prévu pour atterrir en toute sécurité sur la surface d''une planète colonisée et déployer un bâtiment de type "caisse d''énergie".<br/>

Ce "bâtiment volant" est extrêmement fragile et ne devrait être engagé dans aucun combat.<br/>

Les prérequis à la construction du bâtiment déployé doivent se trouver déjà construit sur la planète.', 45000, 25000, 0, 0, 2, 0, 76000, 0, 300, 0, 0, 0, 0, 0, 140, 450, 1, NULL, 0, 0, 0, true, NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 75, 75000, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 200, 1, 0, 3, 0, false, 1);


--
-- Data for Name: gm_ai_planets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_ai_watched_planets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_invitations; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_money_requests; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_nap_offers; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_naps; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_ranks; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_reports; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_tributes; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_wallet_logs; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliance_wars; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_alliances; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battle_fleet_ship_kills; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battle_fleet_ships; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battle_fleets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battle_relations; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battle_ships; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_battles; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_chat_lines; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_chat_online_profiles; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_chat_profiles; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_chats; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.gm_chats VALUES (2, 'Exile', '', '', true);
INSERT INTO ng03.gm_chats VALUES (1, 'Nouveaux joueurs', '', '', true);


--
-- Data for Name: gm_commanders; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_fleet_route_waypoints; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_fleet_routes; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_fleet_ships; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_fleets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_galaxies; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_invasions; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_markets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_money_transfers; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_multi_warnings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_planet_owners; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_process_errors; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_profile_actions; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_profile_alliances; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_log_profile_options; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_mail_addressees; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_mail_ignorees; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_mails; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_market_purchases; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_market_sales; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_building_pendings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_buildings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_energy_transfers; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_ship_pendings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_ships; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planet_trainings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_planets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_bounties; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_connections; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_fleet_categories; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_holidays; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_kills; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_reports; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_research_pendings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profile_researches; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_profiles; Type: TABLE DATA; Schema: ng03; Owner: exileng
--

INSERT INTO ng03.gm_profiles VALUES (4, -100, 'Nation rebelle', 'A', '2006-09-01 00:00:00', '2006-09-01 00:00:00', 'nr@exile', 1000000, 168, 1036, '', NULL, '', NULL, NULL, 0, 103843, 0, 0, 0, NULL, 0, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, NULL, '2006-09-05 11:57:09.571683', NULL, 0, true, NULL, '2009-01-01 17:00:00', NULL, NULL, NULL, 0, 0, NULL, NULL, false, 5, '2006-09-19 11:57:09.571683', 50000, 100000, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 100, 2, '', NULL, NULL, '2006-09-01 00:00:00', 1, 1, 0, '2007-02-23 10:53:36.184266', false, 0, 103843, 1, 0, 0, NULL, '0.0.0.0', NULL, 1, NULL, true, true, NULL, 0, '2008-07-27 14:38:06.042', 0, 1, 1, 1, 400, 3, 0);
INSERT INTO ng03.gm_profiles VALUES (2, -100, 'Nation oubliée', 'A', '2006-09-01 00:00:00', '2006-09-01 00:00:00', 'no@exile', 1000000, 168, 1036, '', NULL, '', NULL, NULL, 0, 4469810, 140617750, 0, 36455650, NULL, 100, '2019-03-29 18:16:08.73905', '2019-03-30 02:16:08.73905', 0, 0, 0, 0, NULL, NULL, 3, NULL, '2006-09-05 11:54:34.148706', NULL, 0, true, NULL, '2009-01-01 17:00:00', NULL, NULL, NULL, 0, 0, NULL, NULL, false, 5, '2006-09-19 11:54:34.148706', 50000, 100000, 7095, 0, 375, 3255, 1693, 0, 0, 0, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 100, 2, '', NULL, NULL, '2006-09-01 00:00:00', 1, 1, 0, '2007-02-23 10:53:36.184266', false, 0, 4471262, 1, 0, 0, NULL, '0.0.0.0', NULL, 1, NULL, true, true, NULL, 62100, '2008-07-27 14:38:06.042', 2908212204, 1, 1, 1, 400, 3, 3);
INSERT INTO ng03.gm_profiles VALUES (5, 500, 'Duke', 'nocheat', '2019-03-29 16:14:24.626639', '2009-01-01 21:22:34.04', NULL, 1000000, 168, 1036, '', NULL, '', NULL, NULL, 283, 0, 0, 0, 0, NULL, 0, NULL, NULL, 0, 0, 0, 0, NULL, '2019-03-29 16:14:24.626639', 0, NULL, '2009-01-01 21:22:34.04', NULL, 283, true, NULL, '2009-01-01 17:00:00', NULL, NULL, NULL, 0, 0, 637, 99880, false, 5, '2009-01-15 21:22:34.04', 50000, 100000, 0, 0, 0, 0, 0, 0, 0, 0, NULL, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 85, 0, '', NULL, '', '2009-01-01 21:22:34.04', 1, 1, 0, '2020-09-11 00:00:00', false, 0, 0, 1, 0, 0, NULL, '82.246.212.174', NULL, 1, 's_default', false, false, NULL, 0, '2008-12-31 21:22:34.04', 0, 1, 1, 1, 400, 3, 0);
INSERT INTO ng03.gm_profiles VALUES (1, -100, 'Les fossoyeurs', 'A', '2006-09-01 00:00:00', '2006-09-01 00:00:00', 'fos@exile', 1000000, 168, 1036, '', NULL, '', NULL, NULL, 0, 14868700, 0, 0, 0, NULL, 100, '2019-03-30 13:49:00.351465', '2019-03-30 21:49:00.351465', 0, 0, 0, 0, NULL, NULL, 0, NULL, '2006-09-05 11:56:46.664541', NULL, 0, false, NULL, '2009-01-01 17:00:00', NULL, NULL, NULL, 0, 0, NULL, NULL, false, 5, '2006-09-19 11:56:46.664541', 50000, 99999, 0, 0, 0, 0, 0, 535430.8, 0, 0, NULL, 1, 1.8522, 1.8522, 1.21, 1, 1.9845, 2.3625, 1.2, 1.575, 1.625, 1.5, 1.45, 1, 1, 1, 0.9, 1.1, 1.25, 1, 0.95, 0.8, 0.9, 1, 0.8, 0.95, 1, 5, 20, 85, 2, '', NULL, NULL, '2006-09-01 00:00:00', 1, 1, 0, '2007-02-23 10:53:36.184266', false, 0, 14905392, 1.1, 0, 0, NULL, '0.0.0.0', NULL, 1, NULL, true, true, NULL, 0, '2008-07-27 14:38:06.042', 0, 1, 1, 1, 400, 3, 0);
INSERT INTO ng03.gm_profiles VALUES (3, -50, 'Guilde marchande', 'A', '2006-09-01 00:00:00', '2006-09-01 00:00:00', 'gm@exile', 1000000, 168, 1036, '', NULL, '', NULL, NULL, 0, 0, 0, 0, 0, NULL, 100, '2019-03-30 13:49:00.351465', '2019-03-30 21:49:00.351465', 0, 0, 0, 0, NULL, NULL, 1021, NULL, '2106-09-05 11:54:00.464825', NULL, 0, false, NULL, '2009-01-01 17:00:00', NULL, NULL, NULL, 0, 0, NULL, NULL, false, 5, '2005-09-19 11:54:00.464825', 50000, 100000, 46389, 0, 375, 0, 0, 1026.6666, 0, 0, NULL, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 85, 1, '', NULL, NULL, '2006-09-01 00:00:00', 1, 1, 0, '2007-02-23 10:53:36.184266', true, 0, 0, 1, 0, 0, NULL, '0.0.0.0', NULL, 1, NULL, true, true, NULL, 0, '2008-07-27 14:38:06.042', 0, 1, 1, 1, 400, 3, 0);


--
-- Data for Name: gm_spying_buildings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_spying_planets; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_spying_researches; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Data for Name: gm_spyings; Type: TABLE DATA; Schema: ng03; Owner: exileng
--



--
-- Name: dt_buildings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.dt_buildings_id_seq', 1, false);


--
-- Name: dt_mails_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.dt_mails_id_seq', 1, true);


--
-- Name: dt_researches_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.dt_researches_id_seq', 1, false);


--
-- Name: dt_ships_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.dt_ships_id_seq', 1, true);


--
-- Name: gm_alliance_money_requests_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_alliance_money_requests_id_seq', 5128, true);


--
-- Name: gm_alliance_reports_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_alliance_reports_id_seq', 310249, true);


--
-- Name: gm_alliance_wallet_logs_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_alliance_wallet_logs_id_seq', 497256, true);


--
-- Name: gm_alliances_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_alliances_id_seq', 440, true);


--
-- Name: gm_battle_fleets_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_battle_fleets_id_seq', 479634, true);


--
-- Name: gm_battles_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_battles_id_seq', 110642, true);


--
-- Name: gm_chat_lines_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_chat_lines_id_seq', 2266734, true);


--
-- Name: gm_chats_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_chats_id_seq', 12541, true);


--
-- Name: gm_commanders_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_commanders_id_seq', 50938, true);


--
-- Name: gm_fleet_route_waypoints_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_fleet_route_waypoints_id_seq', 1133077, true);


--
-- Name: gm_fleet_routes_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_fleet_routes_id_seq', 560137, true);


--
-- Name: gm_fleets_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_fleets_id_seq', 724266, true);


--
-- Name: gm_invasions_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_invasions_id_seq', 21963, true);


--
-- Name: gm_log_markets_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_log_markets_id_seq', 316590, true);


--
-- Name: gm_log_planet_owners_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_log_planet_owners_id_seq', 157116, true);


--
-- Name: gm_log_process_errors_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_log_process_errors_id_seq', 628115, true);


--
-- Name: gm_log_profile_options_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_log_profile_options_id_seq', 1, false);


--
-- Name: gm_mail_addressees_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_mail_addressees_id_seq', 214540, true);


--
-- Name: gm_mails_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_mails_id_seq', 467894, true);


--
-- Name: gm_planet_building_pendings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_planet_building_pendings_id_seq', 1354293, true);


--
-- Name: gm_planet_ship_pendings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_planet_ship_pendings_id_seq', 45390804, true);


--
-- Name: gm_planet_trainings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_planet_trainings_id_seq', 1996304, true);


--
-- Name: gm_planets_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_planets_id_seq', 1, false);


--
-- Name: gm_profile_connections_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_profile_connections_id_seq', 905474, true);


--
-- Name: gm_profile_reports_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_profile_reports_id_seq', 5705589, true);


--
-- Name: gm_profile_research_pendings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_profile_research_pendings_id_seq', 165397, true);


--
-- Name: gm_profiles_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_profiles_id_seq', 80887, true);


--
-- Name: gm_spyings_id_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.gm_spyings_id_seq', 7880, true);


--
-- Name: npc_fleet_uid_seq; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.npc_fleet_uid_seq', 217505, true);


--
-- Name: stats_requests; Type: SEQUENCE SET; Schema: ng03; Owner: exileng
--

SELECT pg_catalog.setval('ng03.stats_requests', 5334196, true);


--
-- Name: gm_ai_planets ai_planets_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_ai_planets
    ADD CONSTRAINT ai_planets_pkey PRIMARY KEY (planetid);


--
-- Name: gm_alliance_invitations alliances_invitations_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_invitations
    ADD CONSTRAINT alliances_invitations_pkey PRIMARY KEY (allianceid, userid);


--
-- Name: gm_alliance_nap_offers alliances_naps_invitations_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_nap_offers
    ADD CONSTRAINT alliances_naps_invitations_pkey PRIMARY KEY (allianceid, targetallianceid);


--
-- Name: gm_alliance_naps alliances_naps_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_naps
    ADD CONSTRAINT alliances_naps_pkey PRIMARY KEY (allianceid1, allianceid2);


--
-- Name: gm_alliances alliances_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliances
    ADD CONSTRAINT alliances_pkey PRIMARY KEY (id);


--
-- Name: gm_alliance_ranks alliances_ranks_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_ranks
    ADD CONSTRAINT alliances_ranks_pkey PRIMARY KEY (allianceid, rankid);


--
-- Name: gm_alliance_reports alliances_reports_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_pkey PRIMARY KEY (id);


--
-- Name: gm_alliance_tributes alliances_tributes_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_tributes
    ADD CONSTRAINT alliances_tributes_pkey PRIMARY KEY (allianceid, target_allianceid);


--
-- Name: gm_alliance_wallet_logs alliances_wallet_journal_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_wallet_logs
    ADD CONSTRAINT alliances_wallet_journal_pkey PRIMARY KEY (id);


--
-- Name: gm_alliance_money_requests alliances_wallet_requests_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_money_requests
    ADD CONSTRAINT alliances_wallet_requests_pkey PRIMARY KEY (id);


--
-- Name: gm_alliance_wars alliances_wars_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_wars
    ADD CONSTRAINT alliances_wars_pkey PRIMARY KEY (allianceid1, allianceid2);


--
-- Name: dt_banned_usernames banned_logins_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_banned_usernames
    ADD CONSTRAINT banned_logins_pkey PRIMARY KEY (login);


--
-- Name: gm_battle_fleets battles_fleets_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_fleets
    ADD CONSTRAINT battles_fleets_pkey PRIMARY KEY (id);


--
-- Name: gm_battles battles_key_key; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battles
    ADD CONSTRAINT battles_key_key UNIQUE (key);


--
-- Name: gm_battles battles_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battles
    ADD CONSTRAINT battles_pkey PRIMARY KEY (id);


--
-- Name: gm_battle_relations battles_relations_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_relations
    ADD CONSTRAINT battles_relations_pkey PRIMARY KEY (battleid, user1, user2);


--
-- Name: gm_chat_lines chat_lines_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_lines
    ADD CONSTRAINT chat_lines_pkey PRIMARY KEY (id);


--
-- Name: gm_chat_online_profiles chat_onlineusers_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_online_profiles
    ADD CONSTRAINT chat_onlineusers_pkey PRIMARY KEY (chatid, userid);


--
-- Name: gm_chats chat_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chats
    ADD CONSTRAINT chat_pkey PRIMARY KEY (id);


--
-- Name: gm_chat_profiles chat_users_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_profiles
    ADD CONSTRAINT chat_users_pkey PRIMARY KEY (channelid, userid);


--
-- Name: gm_commanders commanders_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_commanders
    ADD CONSTRAINT commanders_pkey PRIMARY KEY (id);


--
-- Name: dt_buildings db_buildings_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_buildings
    ADD CONSTRAINT db_buildings_pkey PRIMARY KEY (id);


--
-- Name: dt_building_building_reqs db_buildings_req_building_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_building_reqs
    ADD CONSTRAINT db_buildings_req_building_pkey PRIMARY KEY (buildingid, required_buildingid);


--
-- Name: dt_building_research_reqs db_buildings_req_research_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_research_reqs
    ADD CONSTRAINT db_buildings_req_research_pkey PRIMARY KEY (buildingid, required_researchid);


--
-- Name: dt_mails db_messages_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_mails
    ADD CONSTRAINT db_messages_pkey PRIMARY KEY (id, lcid);


--
-- Name: dt_researches db_research_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_researches
    ADD CONSTRAINT db_research_pkey PRIMARY KEY (id);


--
-- Name: dt_research_building_reqs db_research_req_building_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_building_reqs
    ADD CONSTRAINT db_research_req_building_pkey PRIMARY KEY (researchid, required_buildingid);


--
-- Name: dt_research_research_reqs db_research_req_research_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_research_reqs
    ADD CONSTRAINT db_research_req_research_pkey PRIMARY KEY (researchid, required_researchid);


--
-- Name: dt_ships db_ships_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ships
    ADD CONSTRAINT db_ships_pkey PRIMARY KEY (id);


--
-- Name: dt_ship_building_reqs db_ships_req_building_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_building_reqs
    ADD CONSTRAINT db_ships_req_building_pkey PRIMARY KEY (shipid, required_buildingid);


--
-- Name: dt_ship_research_reqs db_ships_req_research_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_research_reqs
    ADD CONSTRAINT db_ships_req_research_pkey PRIMARY KEY (shipid, required_researchid);


--
-- Name: gm_fleets fleets_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_pkey PRIMARY KEY (id);


--
-- Name: gm_fleet_ships fleets_ships_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleet_ships
    ADD CONSTRAINT fleets_ships_pkey PRIMARY KEY (fleetid, shipid);


--
-- Name: gm_invasions invasions_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_invasions
    ADD CONSTRAINT invasions_pkey PRIMARY KEY (id);


--
-- Name: gm_log_process_errors log_sys_errors_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_process_errors
    ADD CONSTRAINT log_sys_errors_pkey PRIMARY KEY (id);


--
-- Name: gm_log_markets market_history_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_markets
    ADD CONSTRAINT market_history_pkey PRIMARY KEY (id);


--
-- Name: gm_market_sales market_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_market_sales
    ADD CONSTRAINT market_pkey PRIMARY KEY (planetid);


--
-- Name: gm_market_purchases market_purchases_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_market_purchases
    ADD CONSTRAINT market_purchases_pkey PRIMARY KEY (planetid);


--
-- Name: gm_mail_addressees messages_history_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_addressees
    ADD CONSTRAINT messages_history_pkey PRIMARY KEY (id);


--
-- Name: gm_mail_ignorees messages_ignore_list_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_ignorees
    ADD CONSTRAINT messages_ignore_list_pkey PRIMARY KEY (userid, ignored_userid);


--
-- Name: gm_mails messages_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mails
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: gm_galaxies nav_galaxies_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_galaxies
    ADD CONSTRAINT nav_galaxies_pkey PRIMARY KEY (id);


--
-- Name: gm_planets nav_planet_location_unique; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planets
    ADD CONSTRAINT nav_planet_location_unique UNIQUE (galaxy, sector, planet);


--
-- Name: gm_planets nav_planet_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planets
    ADD CONSTRAINT nav_planet_pkey PRIMARY KEY (id);


--
-- Name: gm_planet_building_pendings planet_buildings_pending_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_building_pendings
    ADD CONSTRAINT planet_buildings_pending_pkey PRIMARY KEY (id);


--
-- Name: gm_planet_building_pendings planet_buildings_pending_unique; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_building_pendings
    ADD CONSTRAINT planet_buildings_pending_unique UNIQUE (planetid, buildingid);


--
-- Name: gm_planet_buildings planet_buildings_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_buildings
    ADD CONSTRAINT planet_buildings_pkey PRIMARY KEY (planetid, buildingid);


--
-- Name: gm_log_planet_owners planet_owners_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_planet_owners
    ADD CONSTRAINT planet_owners_pkey PRIMARY KEY (id);


--
-- Name: gm_planet_energy_transfers planet_sending_energy_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_energy_transfers
    ADD CONSTRAINT planet_sending_energy_pkey PRIMARY KEY (planetid, target_planetid);


--
-- Name: gm_planet_ship_pendings planet_ships_pending_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_ship_pendings
    ADD CONSTRAINT planet_ships_pending_pkey PRIMARY KEY (id);


--
-- Name: gm_planet_ships planet_ships_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_ships
    ADD CONSTRAINT planet_ships_pkey PRIMARY KEY (planetid, shipid);


--
-- Name: gm_planet_trainings planet_training_pending_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_trainings
    ADD CONSTRAINT planet_training_pending_pkey PRIMARY KEY (id);


--
-- Name: gm_profile_reports reports_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: gm_profile_research_pendings researches_pending_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_research_pendings
    ADD CONSTRAINT researches_pending_pkey PRIMARY KEY (id);


--
-- Name: gm_profile_researches researches_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_researches
    ADD CONSTRAINT researches_pkey PRIMARY KEY (userid, researchid);


--
-- Name: gm_fleet_routes routes_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleet_routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: gm_fleet_route_waypoints routes_waypoints_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleet_route_waypoints
    ADD CONSTRAINT routes_waypoints_pkey PRIMARY KEY (id);


--
-- Name: gm_spying_buildings spy_building_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_buildings
    ADD CONSTRAINT spy_building_pkey PRIMARY KEY (spy_id, planet_id, building_id);


--
-- Name: gm_spyings spy_key_key; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spyings
    ADD CONSTRAINT spy_key_key UNIQUE (key);


--
-- Name: gm_spyings spy_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spyings
    ADD CONSTRAINT spy_pkey PRIMARY KEY (id);


--
-- Name: gm_spying_planets spy_planet_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_planets
    ADD CONSTRAINT spy_planet_pkey PRIMARY KEY (spy_id, planet_id);


--
-- Name: gm_spying_researches spy_research_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_researches
    ADD CONSTRAINT spy_research_pkey PRIMARY KEY (spy_id, research_id);


--
-- Name: dt_processes sys_processes_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_processes
    ADD CONSTRAINT sys_processes_pkey PRIMARY KEY (procedure);


--
-- Name: gm_profile_fleet_categories users_fleets_category_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_fleet_categories
    ADD CONSTRAINT users_fleets_category_pkey PRIMARY KEY (userid, category);


--
-- Name: gm_profile_holidays users_holidays_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_holidays
    ADD CONSTRAINT users_holidays_pkey PRIMARY KEY (userid);


--
-- Name: gm_log_profile_options users_options_history_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_profile_options
    ADD CONSTRAINT users_options_history_pkey PRIMARY KEY (id);


--
-- Name: gm_profiles users_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profiles
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: gm_profile_connections users_remote_address_history_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_connections
    ADD CONSTRAINT users_remote_address_history_pkey PRIMARY KEY (id);


--
-- Name: gm_profile_kills users_stats_pkey; Type: CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_kills
    ADD CONSTRAINT users_stats_pkey PRIMARY KEY (userid, shipid);


--
-- Name: ai_planets_nextupdate_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX ai_planets_nextupdate_idx ON ng03.gm_ai_planets USING btree (nextupdate);


--
-- Name: ai_rogue_planets_nextupdate_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX ai_rogue_planets_nextupdate_idx ON ng03.gm_ai_planets USING btree (nextupdate);


--
-- Name: alliances_invitations_replied_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_invitations_replied_idx ON ng03.gm_alliance_invitations USING btree (replied);


--
-- Name: alliances_name_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX alliances_name_unique ON ng03.gm_alliances USING btree (upper((name)::text));


--
-- Name: alliances_naps_offers_replied; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_naps_offers_replied ON ng03.gm_alliance_nap_offers USING btree (replied);


--
-- Name: alliances_ranks_label_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX alliances_ranks_label_unique ON ng03.gm_alliance_ranks USING btree (allianceid, upper((label)::text));


--
-- Name: alliances_reports_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_reports_datetime_idx ON ng03.gm_alliance_reports USING btree (datetime);


--
-- Name: alliances_reports_ownerid_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_reports_ownerid_datetime_idx ON ng03.gm_alliance_reports USING btree (ownerid, datetime);


--
-- Name: alliances_reports_type_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_reports_type_idx ON ng03.gm_alliance_reports USING btree (type);


--
-- Name: alliances_tag_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX alliances_tag_unique ON ng03.gm_alliances USING btree (upper((tag)::text));


--
-- Name: alliances_wallet_journal_allianceid_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX alliances_wallet_journal_allianceid_datetime_idx ON ng03.gm_alliance_wallet_logs USING btree (allianceid, datetime);


--
-- Name: battles_fleets_battleid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX battles_fleets_battleid_idx ON ng03.gm_battle_fleets USING btree (battleid);


--
-- Name: battles_time_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX battles_time_idx ON ng03.gm_battles USING btree ("time");


--
-- Name: chat_lines_chatid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX chat_lines_chatid_idx ON ng03.gm_chat_lines USING btree (chatid);


--
-- Name: chat_name_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX chat_name_idx ON ng03.gm_chats USING btree (upper((name)::text)) WHERE (name IS NOT NULL);


--
-- Name: db_buildings_id; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX db_buildings_id ON ng03.dt_buildings USING btree (id);


--
-- Name: fki_alliances_invitations_recruiterid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_invitations_recruiterid_fkey ON ng03.gm_alliance_invitations USING btree (recruiterid);


--
-- Name: fki_alliances_invitations_userid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_invitations_userid_fkey ON ng03.gm_alliance_invitations USING btree (userid);


--
-- Name: fki_alliances_naps_allianceid2_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_naps_allianceid2_fkey ON ng03.gm_alliance_naps USING btree (allianceid2);


--
-- Name: fki_alliances_naps_invitations_recruterid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_naps_invitations_recruterid_fkey ON ng03.gm_alliance_nap_offers USING btree (recruiterid);


--
-- Name: fki_alliances_wallet_requests_allianceid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_wallet_requests_allianceid ON ng03.gm_alliance_money_requests USING btree (allianceid);


--
-- Name: fki_alliances_wallet_requests_userid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_alliances_wallet_requests_userid ON ng03.gm_alliance_money_requests USING btree (userid);


--
-- Name: fki_battles_fleets_ships_fleetid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_fleets_ships_fleetid ON ng03.gm_battle_fleet_ships USING btree (fleetid);


--
-- Name: fki_battles_fleets_ships_kills_destroyed_shipid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_fleets_ships_kills_destroyed_shipid ON ng03.gm_battle_fleet_ship_kills USING btree (destroyed_shipid);


--
-- Name: fki_battles_fleets_ships_kills_fleetid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_fleets_ships_kills_fleetid ON ng03.gm_battle_fleet_ship_kills USING btree (fleetid);


--
-- Name: fki_battles_fleets_ships_kills_shipid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_fleets_ships_kills_shipid ON ng03.gm_battle_fleet_ship_kills USING btree (shipid);


--
-- Name: fki_battles_fleets_ships_shipid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_fleets_ships_shipid ON ng03.gm_battle_fleet_ships USING btree (shipid);


--
-- Name: fki_battles_ships_battleid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_ships_battleid ON ng03.gm_battle_ships USING btree (battleid);


--
-- Name: fki_battles_ships_owner_id; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_ships_owner_id ON ng03.gm_battle_ships USING btree (owner_id);


--
-- Name: fki_battles_ships_shipid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_battles_ships_shipid ON ng03.gm_battle_ships USING btree (shipid);


--
-- Name: fki_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_buildingid_fk ON ng03.dt_building_building_reqs USING btree (buildingid);


--
-- Name: fki_commanders_ownerid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_commanders_ownerid_fk ON ng03.gm_commanders USING btree (ownerid);


--
-- Name: fki_db_buildings_req_research_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_buildings_req_research_buildingid_fk ON ng03.dt_building_research_reqs USING btree (buildingid);


--
-- Name: fki_db_buildings_req_research_required_research_id; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_buildings_req_research_required_research_id ON ng03.dt_building_research_reqs USING btree (required_researchid);


--
-- Name: fki_db_research_req_building_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_research_req_building_buildingid_fk ON ng03.dt_research_building_reqs USING btree (required_buildingid);


--
-- Name: fki_db_research_req_building_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_research_req_building_researchid_fk ON ng03.dt_research_building_reqs USING btree (researchid);


--
-- Name: fki_db_research_req_research_required_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_research_req_research_required_researchid_fk ON ng03.dt_research_research_reqs USING btree (required_researchid);


--
-- Name: fki_db_research_req_research_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_research_req_research_researchid_fk ON ng03.dt_research_research_reqs USING btree (researchid);


--
-- Name: fki_db_ships_buildingid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_ships_buildingid_fkey ON ng03.dt_ships USING btree (buildingid);


--
-- Name: fki_db_ships_req_building_required_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_ships_req_building_required_buildingid_fk ON ng03.dt_ship_building_reqs USING btree (required_buildingid);


--
-- Name: fki_db_ships_req_building_shipid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_ships_req_building_shipid_fk ON ng03.dt_ship_building_reqs USING btree (shipid);


--
-- Name: fki_db_ships_req_research_required_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_ships_req_research_required_researchid_fk ON ng03.dt_ship_research_reqs USING btree (required_researchid);


--
-- Name: fki_db_ships_req_research_shipid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_db_ships_req_research_shipid_fk ON ng03.dt_ship_research_reqs USING btree (shipid);


--
-- Name: fki_fleets_dest_planetid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_fleets_dest_planetid_fkey ON ng03.gm_fleets USING btree (dest_planetid) WHERE (dest_planetid IS NOT NULL);


--
-- Name: fki_market_planetid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_market_planetid_fk ON ng03.gm_market_sales USING btree (planetid);


--
-- Name: fki_messages_addressee_history_addresseeid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_messages_addressee_history_addresseeid_fk ON ng03.gm_mail_addressees USING btree (addresseeid);


--
-- Name: fki_messages_addressee_history_ownerid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_messages_addressee_history_ownerid_fk ON ng03.gm_mail_addressees USING btree (ownerid);


--
-- Name: fki_messages_ownerid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_messages_ownerid_fk ON ng03.gm_mails USING btree (ownerid) WHERE (ownerid IS NOT NULL);


--
-- Name: fki_messages_senderid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_messages_senderid_fk ON ng03.gm_mails USING btree (senderid) WHERE (senderid IS NOT NULL);


--
-- Name: fki_nav_planet_commanderid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_nav_planet_commanderid_fkey ON ng03.gm_planets USING btree (commanderid) WHERE (commanderid IS NOT NULL);


--
-- Name: fki_planet_buildings_pending_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_planet_buildings_pending_buildingid_fk ON ng03.gm_planet_building_pendings USING btree (buildingid);


--
-- Name: fki_planet_buildings_pending_planetid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_planet_buildings_pending_planetid_fk ON ng03.gm_planet_building_pendings USING btree (planetid);


--
-- Name: fki_planet_ships_pending_planetid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_planet_ships_pending_planetid_fkey ON ng03.gm_planet_ship_pendings USING btree (planetid);


--
-- Name: fki_planet_ships_pending_shipid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_planet_ships_pending_shipid_fkey ON ng03.gm_planet_ship_pendings USING btree (shipid);


--
-- Name: fki_planet_ships_shipid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_planet_ships_shipid_fkey ON ng03.gm_planet_ships USING btree (shipid);


--
-- Name: fki_required_buildingid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_required_buildingid_fk ON ng03.dt_building_building_reqs USING btree (required_buildingid);


--
-- Name: fki_researches_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_researches_researchid_fk ON ng03.gm_profile_researches USING btree (researchid);


--
-- Name: fki_researches_userid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_researches_userid_fk ON ng03.gm_profile_researches USING btree (userid);


--
-- Name: fki_routes_waypoints_routeid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_routes_waypoints_routeid_fkey ON ng03.gm_fleet_route_waypoints USING btree (routeid);


--
-- Name: fki_spy_building_spyid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_spy_building_spyid_fkey ON ng03.gm_spying_buildings USING btree (spy_id);


--
-- Name: fki_spy_planet_spyid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_spy_planet_spyid_fkey ON ng03.gm_spying_planets USING btree (spy_id);


--
-- Name: fki_spy_research_spyid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_spy_research_spyid_fkey ON ng03.gm_spying_researches USING btree (spy_id);


--
-- Name: fki_users_alliance_id_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_users_alliance_id_fkey ON ng03.gm_profiles USING btree (alliance_id) WHERE (alliance_id IS NOT NULL);


--
-- Name: fki_users_multi_account_warnings_id_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_users_multi_account_warnings_id_fkey ON ng03.gm_log_multi_warnings USING btree (id);


--
-- Name: fki_users_multi_account_warnings_withid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_users_multi_account_warnings_withid_fkey ON ng03.gm_log_multi_warnings USING btree (withid);


--
-- Name: fki_users_remote_address_history_userid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_users_remote_address_history_userid ON ng03.gm_profile_connections USING btree (userid);


--
-- Name: fki_users_reports_userid_fkey; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fki_users_reports_userid_fkey ON ng03.gm_profile_reports USING btree (userid);


--
-- Name: fleets_action_end_time_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_action_end_time_idx ON ng03.gm_fleets USING btree (action_end_time) WHERE (action_end_time IS NOT NULL);


--
-- Name: fleets_action_moving_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_action_moving_idx ON ng03.gm_fleets USING btree (action) WHERE ((action = '-1'::integer) OR (action = 1));


--
-- Name: fleets_action_recycling_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_action_recycling_idx ON ng03.gm_fleets USING btree (action) WHERE (action = 2);


--
-- Name: fleets_action_waiting_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_action_waiting_idx ON ng03.gm_fleets USING btree (action) WHERE (action = 4);


--
-- Name: fleets_commanderid_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX fleets_commanderid_unique ON ng03.gm_fleets USING btree (commanderid) WHERE (commanderid IS NOT NULL);


--
-- Name: fleets_engaged_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_engaged_idx ON ng03.gm_fleets USING btree (engaged) WHERE engaged;


--
-- Name: fleets_next_waypointid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_next_waypointid_idx ON ng03.gm_fleets USING btree (next_waypointid) WHERE (next_waypointid IS NOT NULL);


--
-- Name: fleets_ownerid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_ownerid_idx ON ng03.gm_fleets USING btree (ownerid);


--
-- Name: fleets_planetid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX fleets_planetid_idx ON ng03.gm_fleets USING btree (planetid) WHERE (planetid IS NOT NULL);


--
-- Name: invasions_time_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX invasions_time_idx ON ng03.gm_invasions USING btree ("time");


--
-- Name: market_sale_time_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX market_sale_time_idx ON ng03.gm_market_sales USING btree (sale_time);


--
-- Name: messages_money_transfers_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX messages_money_transfers_idx ON ng03.gm_log_money_transfers USING btree (senderid, toid);


--
-- Name: nav_planet_credits_next_update; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_credits_next_update ON ng03.gm_planets USING btree (credits_next_update) WHERE ((credits_next_update IS NOT NULL) AND ((credits_production > 0) OR (credits_random_production > 0)));


--
-- Name: nav_planet_galaxy_owner_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_galaxy_owner_idx ON ng03.gm_planets USING btree (galaxy, ownerid) WHERE (ownerid IS NOT NULL);


--
-- Name: nav_planet_galaxy_sector_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_galaxy_sector_idx ON ng03.gm_planets USING btree (galaxy, sector) WHERE (ownerid IS NOT NULL);


--
-- Name: nav_planet_galaxy_sector_ownerid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_galaxy_sector_ownerid_idx ON ng03.gm_planets USING btree (galaxy, sector, ownerid) WHERE (ownerid IS NOT NULL);


--
-- Name: nav_planet_mood_lt_80_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_mood_lt_80_idx ON ng03.gm_planets USING btree (mood) WHERE (mood < 80);


--
-- Name: nav_planet_next_battle; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_next_battle ON ng03.gm_planets USING btree (next_battle) WHERE (next_battle IS NOT NULL);


--
-- Name: nav_planet_next_planet_update_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_next_planet_update_idx ON ng03.gm_planets USING btree (next_planet_update) WHERE (next_planet_update IS NOT NULL);


--
-- Name: nav_planet_ownerid_notnull_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_ownerid_notnull_idx ON ng03.gm_planets USING btree (ownerid) WHERE (ownerid IS NOT NULL);


--
-- Name: nav_planet_seism_sandworm_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_seism_sandworm_idx ON ng03.gm_planets USING btree (sandworm_activity, seismic_activity) WHERE ((sandworm_activity > 0) OR (seismic_activity > 0));


--
-- Name: nav_planet_shipyard_next_continue_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_shipyard_next_continue_idx ON ng03.gm_planets USING btree (shipyard_next_continue) WHERE ((shipyard_next_continue IS NOT NULL) AND (NOT production_frozen));


--
-- Name: nav_planet_spawn_planet_id; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX nav_planet_spawn_planet_id ON ng03.gm_planets USING btree (id) WHERE ((spawn_ore > 0) OR (spawn_hydrocarbon > 0));


--
-- Name: planet_buildings_destroy_datetime; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_buildings_destroy_datetime ON ng03.gm_planet_buildings USING btree (destroy_datetime) WHERE (destroy_datetime IS NOT NULL);


--
-- Name: planet_buildings_pending_end_time; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_buildings_pending_end_time ON ng03.gm_planet_building_pendings USING btree (end_time) WHERE (end_time IS NOT NULL);


--
-- Name: planet_owners_newownerid; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_owners_newownerid ON ng03.gm_log_planet_owners USING btree (newownerid);


--
-- Name: planet_ships_pending_end_time; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_ships_pending_end_time ON ng03.gm_planet_ship_pendings USING btree (end_time) WHERE (end_time IS NOT NULL);


--
-- Name: planet_training_pending_end_time_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_training_pending_end_time_idx ON ng03.gm_planet_trainings USING btree (end_time) WHERE (end_time IS NOT NULL);


--
-- Name: planet_training_pending_planetid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX planet_training_pending_planetid_idx ON ng03.gm_planet_trainings USING btree (planetid);


--
-- Name: reports_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX reports_datetime_idx ON ng03.gm_profile_reports USING btree (datetime);


--
-- Name: reports_fleetid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX reports_fleetid_idx ON ng03.gm_profile_reports USING btree (fleetid) WHERE (fleetid IS NOT NULL);


--
-- Name: reports_merchants_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX reports_merchants_idx ON ng03.gm_profile_reports USING btree (ownerid, type, subtype, read_date) WHERE ((ownerid = 3) AND (type = 5) AND (subtype = 1) AND (read_date IS NULL));


--
-- Name: reports_ownerid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX reports_ownerid_idx ON ng03.gm_profile_reports USING btree (ownerid);


--
-- Name: reports_type_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX reports_type_idx ON ng03.gm_profile_reports USING btree (type);


--
-- Name: researches_pending_end_time; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX researches_pending_end_time ON ng03.gm_profile_research_pendings USING btree (end_time);


--
-- Name: researches_pending_researchid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX researches_pending_researchid_fk ON ng03.gm_profile_research_pendings USING btree (researchid);


--
-- Name: researches_pending_userid_fk; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX researches_pending_userid_fk ON ng03.gm_profile_research_pendings USING btree (userid);


--
-- Name: routes_name_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX routes_name_unique ON ng03.gm_fleet_routes USING btree (ownerid, upper((name)::text)) WHERE (ownerid IS NOT NULL);


--
-- Name: spy_userid_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX spy_userid_idx ON ng03.gm_spyings USING btree (userid);


--
-- Name: users_credits_use_userid_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_credits_use_userid_datetime_idx ON ng03.gm_log_profile_actions USING btree (userid, datetime);


--
-- Name: users_deletion_date_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_deletion_date_idx ON ng03.gm_profiles USING btree (deletion_date) WHERE (deletion_date IS NOT NULL);


--
-- Name: users_email_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX users_email_unique ON ng03.gm_profiles USING btree (upper((email)::text)) WHERE (email IS NOT NULL);


--
-- Name: users_isplayer_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_isplayer_idx ON ng03.gm_profiles USING btree (lastlogin) WHERE ((privilege = 0) AND (orientation > 0) AND (planets > 0) AND (credits_bankruptcy > 0));


--
-- Name: users_leave_alliance_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_leave_alliance_datetime_idx ON ng03.gm_profiles USING btree (leave_alliance_datetime) WHERE (leave_alliance_datetime IS NOT NULL);


--
-- Name: users_login_unique; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE UNIQUE INDEX users_login_unique ON ng03.gm_profiles USING btree (upper((login)::text)) WHERE (login IS NOT NULL);


--
-- Name: users_orientation; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_orientation ON ng03.gm_profiles USING btree (orientation);


--
-- Name: users_privilege; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_privilege ON ng03.gm_profiles USING btree (privilege);


--
-- Name: users_regdate; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_regdate ON ng03.gm_profiles USING btree (regdate);


--
-- Name: users_remote_address_history_address_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_remote_address_history_address_idx ON ng03.gm_profile_connections USING btree (address);


--
-- Name: users_remote_address_history_datetime_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_remote_address_history_datetime_idx ON ng03.gm_profile_connections USING btree (datetime);


--
-- Name: users_score_next_update_idx; Type: INDEX; Schema: ng03; Owner: exileng
--

CREATE INDEX users_score_next_update_idx ON ng03.gm_profiles USING btree (score_next_update) WHERE ((privilege = '-2'::integer) OR (privilege = 0));


--
-- Name: gm_fleets after_fleets_insert_update_check_battle; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_fleets_insert_update_check_battle AFTER INSERT OR DELETE OR UPDATE ON ng03.gm_fleets FOR EACH ROW EXECUTE FUNCTION ng03.trigger_fleets_after();


--
-- Name: gm_fleet_ships after_fleets_ships_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_fleets_ships_changes AFTER INSERT OR DELETE OR UPDATE ON ng03.gm_fleet_ships FOR EACH ROW EXECUTE FUNCTION ng03.trigger_fleet_ships_after();


--
-- Name: gm_mails after_messages_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_messages_changes AFTER UPDATE ON ng03.gm_mails FOR EACH ROW EXECUTE FUNCTION ng03.trigger_mails_after();


--
-- Name: gm_planets after_nav_planet_update; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_nav_planet_update AFTER UPDATE ON ng03.gm_planets FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planets_after();


--
-- Name: gm_planet_buildings after_planet_buildings_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_planet_buildings_changes AFTER INSERT OR DELETE OR UPDATE ON ng03.gm_planet_buildings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_buildings_after();


--
-- Name: gm_planet_energy_transfers after_planet_energy_transfer_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_planet_energy_transfer_changes AFTER INSERT OR DELETE OR UPDATE ON ng03.gm_planet_energy_transfers FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_energy_transfers_after();


--
-- Name: gm_planet_ships after_planet_ships_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_planet_ships_changes AFTER UPDATE ON ng03.gm_planet_ships FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_ships_after();


--
-- Name: gm_planet_ship_pendings after_planet_ships_pending_delete; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_planet_ships_pending_delete AFTER DELETE ON ng03.gm_planet_ship_pendings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_ship_pendings_after();


--
-- Name: gm_planet_trainings after_planet_training_pending_delete; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_planet_training_pending_delete AFTER DELETE ON ng03.gm_planet_trainings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_trainings_after();


--
-- Name: gm_profile_reports after_reports_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_reports_insert AFTER INSERT ON ng03.gm_profile_reports FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_reports_after();


--
-- Name: gm_fleet_route_waypoints after_routes_waypoints_append; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_routes_waypoints_append AFTER INSERT ON ng03.gm_fleet_route_waypoints FOR EACH ROW EXECUTE FUNCTION ng03.trigger_fleet_route_waypoints_after();


--
-- Name: gm_profiles after_user_leave_alliance; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER after_user_leave_alliance AFTER DELETE OR UPDATE ON ng03.gm_profiles FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profiles_after();


--
-- Name: gm_alliance_wallet_logs before_alliance_wallet_journal_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_alliance_wallet_journal_insert BEFORE INSERT ON ng03.gm_alliance_wallet_logs FOR EACH ROW EXECUTE FUNCTION ng03.trigger_alliance_wallet_logs_before();


--
-- Name: gm_chat_lines before_chat_lines_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_chat_lines_insert BEFORE INSERT ON ng03.gm_chat_lines FOR EACH ROW EXECUTE FUNCTION ng03.trigger_chats_before();


--
-- Name: gm_fleet_ships before_fleets_ships_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_fleets_ships_insert BEFORE INSERT ON ng03.gm_fleet_ships FOR EACH ROW EXECUTE FUNCTION ng03.trigger_fleet_ships_before();


--
-- Name: gm_mail_addressees before_messages_addressee_history_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_messages_addressee_history_insert BEFORE INSERT ON ng03.gm_mail_addressees FOR EACH ROW EXECUTE FUNCTION ng03.trigger_mail_ignorees_before();


--
-- Name: gm_planets before_nav_planet_update; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_nav_planet_update BEFORE UPDATE ON ng03.gm_planets FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planets_before();


--
-- Name: gm_planet_buildings before_planet_buildings_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_planet_buildings_insert BEFORE INSERT ON ng03.gm_planet_buildings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_buildings_before();


--
-- Name: gm_planet_building_pendings before_planet_buildings_pending_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_planet_buildings_pending_insert BEFORE INSERT ON ng03.gm_planet_building_pendings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_building_pendings_before();


--
-- Name: gm_planet_energy_transfers before_planet_energy_transfer_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_planet_energy_transfer_changes BEFORE INSERT OR DELETE OR UPDATE ON ng03.gm_planet_energy_transfers FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_energy_transfers_before();


--
-- Name: gm_planet_ships before_planet_ships_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_planet_ships_insert BEFORE INSERT ON ng03.gm_planet_ships FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_ships_before();


--
-- Name: gm_planet_ship_pendings before_planet_ships_pending_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_planet_ships_pending_insert BEFORE INSERT ON ng03.gm_planet_ship_pendings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_planet_ship_pendings_before();


--
-- Name: gm_profile_reports before_reports_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_reports_insert BEFORE INSERT ON ng03.gm_profile_reports FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_reports_before();


--
-- Name: gm_profile_researches before_researches_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_researches_insert BEFORE INSERT ON ng03.gm_profile_researches FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_researches_before();


--
-- Name: gm_profile_research_pendings before_researches_pending_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_researches_pending_insert BEFORE INSERT ON ng03.gm_profile_research_pendings FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_research_pendings_before();


--
-- Name: gm_profiles before_user_changes; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_user_changes BEFORE UPDATE ON ng03.gm_profiles FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profiles_before();


--
-- Name: gm_profiles before_user_deletion; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_user_deletion BEFORE DELETE ON ng03.gm_profiles FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profiles_before();


--
-- Name: gm_profile_kills before_users_ships_kills_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER before_users_ships_kills_insert BEFORE INSERT ON ng03.gm_profile_kills FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_kills_before();


--
-- Name: gm_chat_online_profiles chat_onlineusers_beforeinsert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER chat_onlineusers_beforeinsert BEFORE INSERT ON ng03.gm_chat_online_profiles FOR EACH ROW EXECUTE FUNCTION ng03.trigger_chat_online_profiles_before();


--
-- Name: gm_profile_bounties users_bounty_before_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER users_bounty_before_insert BEFORE INSERT ON ng03.gm_profile_bounties FOR EACH ROW EXECUTE FUNCTION ng03.trigger_profile_bounties_before();


--
-- Name: gm_log_profile_actions users_expenses_before_insert; Type: TRIGGER; Schema: ng03; Owner: exileng
--

CREATE TRIGGER users_expenses_before_insert BEFORE INSERT ON ng03.gm_log_profile_actions FOR EACH ROW EXECUTE FUNCTION ng03.trigger_log_profile_actions_before();


--
-- Name: gm_alliances alliances_chatid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliances
    ADD CONSTRAINT alliances_chatid_fkey FOREIGN KEY (chatid) REFERENCES ng03.gm_chats(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: gm_alliance_invitations alliances_invitations_alliances_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_invitations
    ADD CONSTRAINT alliances_invitations_alliances_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_invitations alliances_invitations_recruiterid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_invitations
    ADD CONSTRAINT alliances_invitations_recruiterid_fkey FOREIGN KEY (recruiterid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_alliance_invitations alliances_invitations_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_invitations
    ADD CONSTRAINT alliances_invitations_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_naps alliances_naps_allianceid1_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_naps
    ADD CONSTRAINT alliances_naps_allianceid1_fkey FOREIGN KEY (allianceid1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_naps alliances_naps_allianceid2_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_naps
    ADD CONSTRAINT alliances_naps_allianceid2_fkey FOREIGN KEY (allianceid2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_nap_offers alliances_naps_invitations_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_nap_offers
    ADD CONSTRAINT alliances_naps_invitations_allianceid_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_nap_offers alliances_naps_invitations_recruterid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_nap_offers
    ADD CONSTRAINT alliances_naps_invitations_recruterid_fkey FOREIGN KEY (recruiterid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_alliance_nap_offers alliances_naps_invitations_targetallianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_nap_offers
    ADD CONSTRAINT alliances_naps_invitations_targetallianceid_fkey FOREIGN KEY (targetallianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_ranks alliances_rank_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_ranks
    ADD CONSTRAINT alliances_rank_allianceid_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_allianceid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_allianceid_fk FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_commanderid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_commanderid_fkey FOREIGN KEY (commanderid) REFERENCES ng03.gm_commanders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_alliance_reports alliances_reports_fleetid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_fleetid FOREIGN KEY (fleetid) REFERENCES ng03.gm_fleets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_alliance_reports alliances_reports_invasionid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_invasionid_fk FOREIGN KEY (invasionid) REFERENCES ng03.gm_invasions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_ownerallianceid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_ownerallianceid_fk FOREIGN KEY (ownerallianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_spyid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_spyid_fk FOREIGN KEY (spyid) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_reports alliances_reports_userid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_reports
    ADD CONSTRAINT alliances_reports_userid_fk FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_alliance_tributes alliances_tributes_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_tributes
    ADD CONSTRAINT alliances_tributes_allianceid_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_tributes alliances_tributes_target_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_tributes
    ADD CONSTRAINT alliances_tributes_target_allianceid_fkey FOREIGN KEY (target_allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_wallet_logs alliances_wallet_journal_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_wallet_logs
    ADD CONSTRAINT alliances_wallet_journal_allianceid_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_money_requests alliances_wallet_requests_allianceid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_money_requests
    ADD CONSTRAINT alliances_wallet_requests_allianceid_fkey FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_money_requests alliances_wallet_requests_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_money_requests
    ADD CONSTRAINT alliances_wallet_requests_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_wars alliances_wars_allianceid1_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_wars
    ADD CONSTRAINT alliances_wars_allianceid1_fkey FOREIGN KEY (allianceid1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_alliance_wars alliances_wars_allianceid2_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_alliance_wars
    ADD CONSTRAINT alliances_wars_allianceid2_fkey FOREIGN KEY (allianceid2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_battle_fleets battles_fleets_battleid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_fleets
    ADD CONSTRAINT battles_fleets_battleid FOREIGN KEY (battleid) REFERENCES ng03.gm_battles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_battle_fleet_ships battles_fleets_ships_fleetid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_fleet_ships
    ADD CONSTRAINT battles_fleets_ships_fleetid FOREIGN KEY (fleetid) REFERENCES ng03.gm_battle_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_battle_fleet_ship_kills battles_fleets_ships_kills_fleetid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_fleet_ship_kills
    ADD CONSTRAINT battles_fleets_ships_kills_fleetid FOREIGN KEY (fleetid) REFERENCES ng03.gm_battle_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_battle_relations battles_relations_battleid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_relations
    ADD CONSTRAINT battles_relations_battleid FOREIGN KEY (battleid) REFERENCES ng03.gm_battles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_battle_ships battles_ships_battleid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_battle_ships
    ADD CONSTRAINT battles_ships_battleid FOREIGN KEY (battleid) REFERENCES ng03.gm_battles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_chat_lines chat_lines_chatid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_lines
    ADD CONSTRAINT chat_lines_chatid_fkey FOREIGN KEY (chatid) REFERENCES ng03.gm_chats(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_chat_online_profiles chat_onlineusers_chatid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_online_profiles
    ADD CONSTRAINT chat_onlineusers_chatid_fkey FOREIGN KEY (chatid) REFERENCES ng03.gm_chats(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_chat_online_profiles chat_onlineusers_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_online_profiles
    ADD CONSTRAINT chat_onlineusers_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_chat_profiles chat_users_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_chat_profiles
    ADD CONSTRAINT chat_users_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_commanders commanders_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_commanders
    ADD CONSTRAINT commanders_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dt_building_building_reqs db_buildings_req_building_buildingid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_building_reqs
    ADD CONSTRAINT db_buildings_req_building_buildingid_fk FOREIGN KEY (buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_building_building_reqs db_buildings_req_building_required_buildingid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_building_reqs
    ADD CONSTRAINT db_buildings_req_building_required_buildingid_fk FOREIGN KEY (required_buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_building_research_reqs db_buildings_req_research_buildingid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_research_reqs
    ADD CONSTRAINT db_buildings_req_research_buildingid_fk FOREIGN KEY (buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_building_research_reqs db_buildings_req_research_required_research_id; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_building_research_reqs
    ADD CONSTRAINT db_buildings_req_research_required_research_id FOREIGN KEY (required_researchid) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_research_building_reqs db_research_req_building_buildingid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_building_reqs
    ADD CONSTRAINT db_research_req_building_buildingid_fk FOREIGN KEY (required_buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_research_building_reqs db_research_req_building_researchid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_building_reqs
    ADD CONSTRAINT db_research_req_building_researchid_fk FOREIGN KEY (researchid) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_research_research_reqs db_research_req_research_required_researchid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_research_reqs
    ADD CONSTRAINT db_research_req_research_required_researchid_fk FOREIGN KEY (required_researchid) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_research_research_reqs db_research_req_research_researchid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_research_research_reqs
    ADD CONSTRAINT db_research_req_research_researchid_fk FOREIGN KEY (researchid) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_ships db_ships_buildingid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ships
    ADD CONSTRAINT db_ships_buildingid_fkey FOREIGN KEY (buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: dt_ship_building_reqs db_ships_req_building_required_buildingid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_building_reqs
    ADD CONSTRAINT db_ships_req_building_required_buildingid_fk FOREIGN KEY (required_buildingid) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_ship_building_reqs db_ships_req_building_shipid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_building_reqs
    ADD CONSTRAINT db_ships_req_building_shipid_fk FOREIGN KEY (shipid) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_ship_research_reqs db_ships_req_research_required_research_id; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_research_reqs
    ADD CONSTRAINT db_ships_req_research_required_research_id FOREIGN KEY (required_researchid) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dt_ship_research_reqs db_ships_req_research_shipid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.dt_ship_research_reqs
    ADD CONSTRAINT db_ships_req_research_shipid_fk FOREIGN KEY (shipid) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_fleets fleets_commanderid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_commanderid_fkey FOREIGN KEY (commanderid) REFERENCES ng03.gm_commanders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_fleets fleets_dest_planetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_dest_planetid_fkey FOREIGN KEY (dest_planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_fleets fleets_next_waypointid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_next_waypointid_fkey FOREIGN KEY (next_waypointid) REFERENCES ng03.gm_fleet_route_waypoints(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gm_fleets fleets_ownerid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_ownerid_fkey FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_fleets fleets_planetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleets
    ADD CONSTRAINT fleets_planetid_fkey FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_fleet_ships fleets_ships_fleetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleet_ships
    ADD CONSTRAINT fleets_ships_fleetid_fkey FOREIGN KEY (fleetid) REFERENCES ng03.gm_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_market_sales market_planetid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_market_sales
    ADD CONSTRAINT market_planetid_fk FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_market_purchases market_purchases_planetid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_market_purchases
    ADD CONSTRAINT market_purchases_planetid_fk FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_mail_addressees messages_addressee_history_addresseeid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_addressees
    ADD CONSTRAINT messages_addressee_history_addresseeid_fk FOREIGN KEY (addresseeid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_mail_addressees messages_addressee_history_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_addressees
    ADD CONSTRAINT messages_addressee_history_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_mail_ignorees messages_ignore_list_ignored_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_ignorees
    ADD CONSTRAINT messages_ignore_list_ignored_userid_fkey FOREIGN KEY (ignored_userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_mail_ignorees messages_ignore_list_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mail_ignorees
    ADD CONSTRAINT messages_ignore_list_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_mails messages_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mails
    ADD CONSTRAINT messages_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_mails messages_senderid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_mails
    ADD CONSTRAINT messages_senderid_fk FOREIGN KEY (senderid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_planets nav_planet_commanderid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planets
    ADD CONSTRAINT nav_planet_commanderid_fkey FOREIGN KEY (commanderid) REFERENCES ng03.gm_commanders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_planets nav_planet_galaxy_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planets
    ADD CONSTRAINT nav_planet_galaxy_fkey FOREIGN KEY (galaxy) REFERENCES ng03.gm_galaxies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_planets nav_planet_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planets
    ADD CONSTRAINT nav_planet_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gm_planet_building_pendings planet_buildings_pending_planetid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_building_pendings
    ADD CONSTRAINT planet_buildings_pending_planetid_fk FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_planet_ship_pendings planet_ships_pending_planetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_ship_pendings
    ADD CONSTRAINT planet_ships_pending_planetid_fkey FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_planet_ships planet_ships_planetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_ships
    ADD CONSTRAINT planet_ships_planetid_fkey FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_planet_trainings planet_training_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_trainings
    ADD CONSTRAINT planet_training_fkey FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_planet_buildings planetid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_planet_buildings
    ADD CONSTRAINT planetid_fk FOREIGN KEY (planetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports reports_allianceid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_allianceid_fk FOREIGN KEY (allianceid) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports reports_commanderid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_commanderid_fkey FOREIGN KEY (commanderid) REFERENCES ng03.gm_commanders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_profile_reports reports_fleetid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_fleetid FOREIGN KEY (fleetid) REFERENCES ng03.gm_fleets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_profile_reports reports_invasionid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_invasionid_fk FOREIGN KEY (invasionid) REFERENCES ng03.gm_invasions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports reports_ownerid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_ownerid_fk FOREIGN KEY (ownerid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports reports_spyid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_spyid_fk FOREIGN KEY (spyid) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports reports_userid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT reports_userid_fk FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_profile_research_pendings researches_pending_userid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_research_pendings
    ADD CONSTRAINT researches_pending_userid_fk FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_researches researches_userid_fk; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_researches
    ADD CONSTRAINT researches_userid_fk FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_fleet_route_waypoints routes_waypoints_routeid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_fleet_route_waypoints
    ADD CONSTRAINT routes_waypoints_routeid_fkey FOREIGN KEY (routeid) REFERENCES ng03.gm_fleet_routes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_spying_buildings spy_building_spy_id_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_buildings
    ADD CONSTRAINT spy_building_spy_id_fkey FOREIGN KEY (spy_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_spying_planets spy_planet_spy_id_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_planets
    ADD CONSTRAINT spy_planet_spy_id_fkey FOREIGN KEY (spy_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_spying_researches spy_research_spy_id_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spying_researches
    ADD CONSTRAINT spy_research_spy_id_fkey FOREIGN KEY (spy_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_spyings spy_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_spyings
    ADD CONSTRAINT spy_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_log_profile_alliances users_alliance_history_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_profile_alliances
    ADD CONSTRAINT users_alliance_history_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profiles users_alliance_id_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profiles
    ADD CONSTRAINT users_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_profiles users_alliance_rank_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profiles
    ADD CONSTRAINT users_alliance_rank_fkey FOREIGN KEY (alliance_id, alliance_rank) REFERENCES ng03.gm_alliance_ranks(allianceid, rankid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_bounties users_bounty_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_bounties
    ADD CONSTRAINT users_bounty_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_log_profile_actions users_credits_use_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_profile_actions
    ADD CONSTRAINT users_credits_use_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_holidays users_holidays_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_holidays
    ADD CONSTRAINT users_holidays_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: gm_profiles users_lastplanetid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profiles
    ADD CONSTRAINT users_lastplanetid_fkey FOREIGN KEY (lastplanetid) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: gm_log_multi_warnings users_multi_account_warnings_id_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_multi_warnings
    ADD CONSTRAINT users_multi_account_warnings_id_fkey FOREIGN KEY (id) REFERENCES ng03.gm_profile_connections(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_log_multi_warnings users_multi_account_warnings_withid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_multi_warnings
    ADD CONSTRAINT users_multi_account_warnings_withid_fkey FOREIGN KEY (withid) REFERENCES ng03.gm_profile_connections(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_log_profile_options users_options_history_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_log_profile_options
    ADD CONSTRAINT users_options_history_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_connections users_remote_address_history_userid; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_connections
    ADD CONSTRAINT users_remote_address_history_userid FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_reports users_reports_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_reports
    ADD CONSTRAINT users_reports_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gm_profile_kills users_stats_userid_fkey; Type: FK CONSTRAINT; Schema: ng03; Owner: exileng
--

ALTER TABLE ONLY ng03.gm_profile_kills
    ADD CONSTRAINT users_stats_userid_fkey FOREIGN KEY (userid) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--