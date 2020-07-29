--------------------------------------------------------------------------------
-- PostgreSQL database
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- SCHEMA
--------------------------------------------------------------------------------

CREATE SCHEMA ng03;
ALTER SCHEMA ng03 OWNER TO exileng;

--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_create(_profile_id integer, _tag character varying, _name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

    -- -1 no active profile
    -- -2 can't create alliance
    -- -3 not enough credit
    -- -4 duplicated tag
    -- -5 duplicated name

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_create(_profile_id integer, _tag character varying, _name character varying) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_give_credits(_profile_id integer, _credit_count integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
   
   profile record;
   
BEGIN

    -- -1 no active profile
    -- -2 can't give to alliance
    -- -3 not enough credit

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_give_credits(_profile_id integer, _credit_count integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_invitation_accept(_profile_id integer, _invitation_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_invitation_accept(_profile_id integer, _invitation_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_invitation_create(_profile_id integer, _member_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_invitation_create(_profile_id integer, _member_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_invitation_decline(_profile_id integer, _invitation_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_invitation_decline(_profile_id integer, _invitation_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_leave(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_leave(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_break(_profile_id integer, _nap_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_break(_profile_id integer, _nap_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_request_accept(_profile_id integer, _nap_request_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_request_accept(_profile_id integer, _nap_request_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_request_cancel(_profile_id integer, _nap_request_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_request_cancel(_profile_id integer, _nap_request_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_request_create(_profile_id integer, _alliance_id integer, _guarantee integer, _breaking_delay interval) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_request_create(_profile_id integer, _alliance_id integer, _guarantee integer, _breaking_delay interval) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_request_decline(_profile_id integer, _nap_request_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_request_decline(_profile_id integer, _nap_request_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_toggle_location(_profile_id integer, _nap_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_toggle_location(_profile_id integer, _nap_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_nap_toggle_radar(_profile_id integer, _nap_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_nap_toggle_radar(_profile_id integer, _nap_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_tribute_cancel(_profile_id integer, _tribute_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_tribute_cancel(_profile_id integer, _tribute_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_tribute_create(_profile_id integer, _alliance_id integer, _credit_count integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_tribute_create(_profile_id integer, _alliance_id integer, _credit_count integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_update_announce(_profile_id integer, _defcon smallint, _announce text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_update_announce(_profile_id integer, _defcon smallint, _announce text) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_update_details(_profile_id integer, _tag character varying, _name character varying, _description text, _logo_url character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_update_details(_profile_id integer, _tag character varying, _name character varying, _description text, _logo_url character varying) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_update_tax(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_update_tax(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_wallet_request_accept(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_wallet_request_accept(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_wallet_request_cancel(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_wallet_request_cancel(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_wallet_request_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_wallet_request_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_wallet_request_decline(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_wallet_request_decline(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_war_cancel(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_war_cancel(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_war_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_war_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_alliance_war_pay(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_alliance_war_pay(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_chat_join(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_chat_join(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_chat_leave(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_chat_leave(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_chat_message_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_chat_message_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_assign_commander(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_assign_commander(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_building_destroy(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_building_destroy(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_building_pending_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_building_pending_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_building_pending_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_building_pending_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_building_update_enabled_count(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_building_update_enabled_count(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_energy_transfer_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_energy_transfer_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_energy_transfer_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_energy_transfer_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_fire_people(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_fire_people(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_leave(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_leave(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_rename(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_rename(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_ship_pending_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_ship_pending_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_ship_pending_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_ship_pending_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_toggle_worker_growing(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_toggle_worker_growing(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_training_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_training_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_training_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_training_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_planet_update_resource_prices(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_planet_update_resource_prices(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_commander_engage(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_commander_engage(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_commander_fire(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_commander_fire(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_commander_rename(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_commander_rename(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_commander_train(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_commander_train(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_commander_update_skills(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_commander_update_skills(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_create(_user_id integer, _remote_addr character varying, _user_agent character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   user record;
   profile record;

   profile_id integer;

BEGIN

   SELECT INTO user * FROM auth_user WHERE id = _user_id;
   IF NOT FOUND THEN RETURN -1; END IF;
   
   SELECT INTO profile * FROM gm_profiles WHERE user_id = _user_id;
   IF FOUND THEN RETURN -2; END IF;

   INSERT INTO gm_profiles(created_by, user_id, pseudo) VALUES("user".username, _user_id, "user".username) RETURNING id INTO profile_id;

   INSERT INTO log_connections(profile_id, remote_addr, user_agent) VALUES(profile_id, _remote_addr, _user_agent);

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_create(_user_id integer, _remote_addr character varying, _user_agent character varying) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_assign_category(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_assign_category(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_assign_commander(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_assign_commander(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_category_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_category_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_category_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_category_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_category_rename(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_category_rename(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_deploy_ship(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_deploy_ship(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_invade_planet(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_invade_planet(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_leave(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_leave(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_merge(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_merge(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_rename(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_rename(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_split(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_split(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_start_moving(_profile_id integer, _fleet_id integer, _planet_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

    gm_fleet record;
    gm_origin record;
    gm_profile record;
    gm_destination record;
    
    travel_cost int4;
    travel_time interval;
    travel_distance float;
    
    waypoint_id integer;
    
BEGIN

    -- -1 no active profile
    -- -2 invalid fleet
    -- -3 origin and destination are the same
    -- -4 invalid destination

    SELECT INTO gm_profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
    IF NOT FOUND THEN RETURN -1; END IF;

    SELECT INTO gm_fleet * FROM gm_profile_fleets WHERE id = _fleet_id AND profile_id = _profile_id AND current_waypoint_id IS NULL FOR UPDATE;
    IF NOT FOUND THEN RETURN -2; END IF;

    IF _planet_id = gm_fleet.planet_id THEN RETURN -3; END IF;

    SELECT INTO gm_origin * FROM gm_planets WHERE id = gm_fleet.planet_id;
    
    SELECT INTO gm_destination * FROM gm_planets WHERE id = _planet_id AND NOT production_frozen AND galaxy_id = gm_origin.galaxy_id;
    IF NOT FOUND THEN RETURN -4; END IF;

    travel_distance := _planet_get_distance(gm_destination.sector, gm_destination.planet, gm_origin.sector, gm_origin.planet);
    travel_time := travel_distance * 3600 * 1000.0 / _fleet_get_speed(_fleet_id) * INTERVAL '1 second';
    travel_cost := int4(floor(travel_distance / 200.0 * _fleet_get_real_signature(_fleet_id)));
    travel_cost := GREATEST(1, travel_cost);

    UPDATE gm_profiles SET credit_count = credit_count - travel_cost WHERE id = _profile_id;

    INSERT INTO gm_profile_fleet_waypoints(fleet_id, planet_id, action, ending_date) VALUES(_fleet_id, _planet_id, 'move', now() + travel_time)
        RETURNING id INTO waypoint_id;
    
    UPDATE gm_profile_fleets SET idle_since_date = null, current_waypoint_id = waypoint_id WHERE id = _fleet_id AND profile_id = _profile_id;

    RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_start_moving(_profile_id integer, _fleet_id integer, _planet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_start_recycling(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_start_recycling(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_stop_moving(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_stop_moving(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_stop_recycling(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_stop_recycling(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_toggle_sharing(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_toggle_sharing(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_toggle_stance(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_toggle_stance(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_transfer_ressources(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_transfer_ressources(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_fleet_warp(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_fleet_warp(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_init(_profile_id integer, _name character varying, _orientation_id character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   orientation record;
   
BEGIN

    -- -1 no new profile
    -- -2 invalid name
    -- -3 banned name
    -- -4 already used name
    -- -5 invalid orientation

    SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'new' AND reset_count = 0;
    IF NOT FOUND THEN RETURN -1; END IF;

    IF _name = '' OR LENGTH(_name) < 2 OR LENGTH(_name) > 12 THEN RETURN -2; END IF;
    
    PERFORM 1 FROM dt_banned_pseudo WHERE id ILIKE _name;
    IF FOUND THEN RETURN -3; END IF;
    
    PERFORM 1 FROM gm_profiles WHERE pseudo ILIKE _name AND id <> _profile_id;
    IF FOUND THEN RETURN -4; END IF;
    
    SELECT INTO orientation FROM dt_orientations WHERE id = _orientation_id;
    IF NOT FOUND THEN RETURN -5; END IF;
    
    UPDATE gm_profiles SET pseudo = _name, orientation_id = _orientation_id WHERE id = _profile_id;
    
    DELETE FROM gm_profile_researches WHERE profile_id = _profile_id AND research_id IN ('rs_orientation_scientist', 'rs_orientation_soldier', 'rs_orientation_merchant');
    
    IF _orientation_id = 'or_scientist' THEN INSERT INTO gm_profile_researches(profile_id, research_id) VALUES(_profile_id, 'rs_orientation_scientist');
    ELSEIF _orientation_id = 'or_soldier' THEN INSERT INTO gm_profile_researches(profile_id, research_id) VALUES(_profile_id, 'rs_orientation_soldier');
    ELSEIF _orientation_id = 'or_merchant' THEN INSERT INTO gm_profile_researches(profile_id, research_id) VALUES(_profile_id, 'rs_orientation_merchant');
    END IF;
    
    RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_init(_profile_id integer, _name character varying, _orientation_id character varying) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_kick_alliance(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_kick_alliance(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_mail_blacklist_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_mail_blacklist_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_mail_blacklist_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_mail_blacklist_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_mail_delete(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_mail_delete(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_market_purchase_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_market_purchase_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_market_sale_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_market_sale_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_rename(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_rename(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_research_pending_cancel(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_research_pending_cancel(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_research_pending_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_research_pending_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_research_pending_toggle(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_research_pending_toggle(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_reset(_profile_id integer, _galaxy_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

    gm_planet record;
    gm_profile record;
   
BEGIN

    -- -1 no profile
    -- -2 still has planet
    -- -3 no planet available

    SELECT INTO gm_profile * FROM gm_profiles WHERE id = _profile_id;
    IF NOT FOUND THEN RETURN -1; END IF;

    PERFORM 1 FROM gm_planets WHERE profile_id = _profile_id;
    IF FOUND THEN RETURN -2; END IF;
    
    UPDATE gm_profile_fleets SET profile_id = 2 WHERE profile_id = _profile_id;

    DELETE FROM gm_profile_research_pendings WHERE profile_id = _profile_id;
    
    INSERT INTO gm_profile_researches(profile_id, research_id, level)
        SELECT _profile_id, id, default_level FROM dt_researches
            WHERE default_level > 0
              AND NOT EXISTS(SELECT 1 FROM gm_profile_researches WHERE profile_id = _profile_id AND research_id = dt_researches.id);
    
    SELECT INTO gm_planet * FROM gm_planets
        INNER JOIN gm_galaxies ON (gm_galaxies.id = gm_planets.galaxy_id)
        WHERE profile_id IS NULL
          AND galaxy_id = _galaxy_id
          AND planet % 2 = 0
          AND (sector % 10 = 0 OR sector % 10 = 1 OR sector <= 10 OR sector > 90)
          AND floor > 0 AND space > 0
          AND allow_new
    ORDER BY random() LIMIT 1 FOR UPDATE;
    IF NOT FOUND THEN RETURN -3; END IF;
    
    PERFORM ua_profile_fleet_start_moving(gm_profile_fleets.profile_id, gm_profile_fleets.id, _planet_get_nearest(gm_profile_fleets.profile_id, gm_planets.id))
    FROM gm_planets
        INNER JOIN gm_profile_fleets ON (gm_profile_fleets.current_waypoint_id IS NULL AND gm_profile_fleets.planet_id = gm_planets.id AND gm_profile_fleets.profile_id <> gm_planets.profile_id)
    WHERE gm_planets.id = gm_planet.id;
    
    PERFORM _planet_clear(gm_planet.id);

    DELETE FROM gm_planet_ships WHERE planet_id = gm_planet.id;
    
    UPDATE gm_planets SET
        name = gm_profile.pseudo || ' I', profile_id = _profile_id,
        ore_count = 10000, hydro_count = 7500,
        worker_count = 10000, scientist_count = 50, soldier_count = 50
    WHERE id = gm_planet.id;
    
    INSERT INTO gm_planet_buildings(planet_id, building_id, count) VALUES(gm_planet.id, 'bd_planet_colony', 1);
    
    PERFORM _profile_reset_commanders(_profile_id);
    
    UPDATE gm_planets SET
        commander_id = (SELECT id FROM gm_profile_commanders WHERE profile_id = _profile_id LIMIT 1),
        mood = 100
    WHERE id = gm_planet.id;
    
    UPDATE gm_profiles SET
        privilege = 'active',
        reset_count = reset_count + 1,
        credit_count = DEFAULT,
        prestige_count = DEFAULT,
        bankruptcy = DEFAULT,
        score_dev = DEFAULT,
        score_battle = DEFAULT,
        previous_score_dev = DEFAULT,
        alliance_id = null,
        alliance_rank_id = null,
        last_catastrophe_date = now(),
        last_holidays_date = now(),
        current_upkeep_commanders = DEFAULT,
        current_upkeep_planets = DEFAULT,
        current_upkeep_scientists = DEFAULT,
        current_upkeep_soldiers = DEFAULT,
        current_upkeep_fleets = DEFAULT,
        current_upkeep_orbitting = DEFAULT,
        current_upkeep_parking = DEFAULT
    WHERE id = _profile_id;

    DELETE FROM gm_profile_chats WHERE profile_id = _profile_id;
    DELETE FROM gm_profile_mail_addressee_list WHERE addressee_id = _profile_id;
    DELETE FROM gm_profile_mail_blacklist WHERE ignored_profile_id = _profile_id;
    
    RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_reset(_profile_id integer, _galaxy_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_start_holidays(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_start_holidays(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_stop_holidays(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_stop_holidays(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_unlock(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_unlock(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_update_alliance_rank(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_update_alliance_rank(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_update_notes(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_update_notes(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_profile_update_options(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_profile_update_options(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.ua_spying_create(_profile_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

   profile record;
   
BEGIN

   SELECT INTO profile * FROM gm_profiles WHERE id = _profile_id AND privilege = 'active';
   IF NOT FOUND THEN RETURN -1; END IF;

   RETURN 0;
END;$$;

ALTER FUNCTION ng03.ua_spying_create(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_alliance_nap_breakings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_alliance_nap_breakings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_alliance_tributes() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_alliance_tributes() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_alliance_war_billings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_alliance_war_billings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_alliance_war_ceasings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_alliance_war_ceasings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_commander_generations() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_commander_generations() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_commander_promotions() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_commander_promotions() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_fleet_delay_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_fleet_delay_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_fleet_recyclings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_fleet_recyclings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_fleet_travels() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_fleet_travels() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_fleet_waitings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_fleet_waitings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_annihilation_fleets_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_annihilation_fleets_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_lost_nation_leavings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_lost_nation_leavings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_merchant_fleets_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_merchant_fleets_cleaning() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_merchant_unloading() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_merchant_unloading() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_resource_prices_updating() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_resource_prices_updating() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_resource_spawnings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_resource_spawnings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_resource_spawns_updating() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_resource_spawns_updating() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_rogue_fleets_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_rogue_fleets_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_galaxy_rogue_planets() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_galaxy_rogue_planets() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_bonus_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_bonus_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_building_destructions() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_building_destructions() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_building_pendings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_building_pendings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_laboratory_accidents_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_laboratory_accidents_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_magnetic_storm_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_magnetic_storm_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_productions() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_productions() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_riot_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_riot_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_robbery_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_robbery_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_sandworm_attack_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_sandworm_attack_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_seism_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_seism_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_ship_pendings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_ship_pendings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_trainings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_trainings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_planet_watching() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_planet_watching() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_alliance_leaving() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_alliance_leaving() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_booster_market_generation() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_booster_market_generation() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_bounties() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_bounties() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_credit_production() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_credit_production() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_deletion() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_deletion() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_holidays_ending() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_holidays_ending() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_holidays_starting() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_holidays_starting() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_market_purchases() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_market_purchases() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_market_sales() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_market_sales() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_research_pendings() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_research_pendings() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_profile_score_updating() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_profile_score_updating() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_server_alliance_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_server_alliance_cleaning() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_server_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_server_cleaning() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_server_fleet_route_cleaning() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_server_fleet_route_cleaning() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.process_server_lottery() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
BEGIN

END;$$;

ALTER FUNCTION ng03.process_server_lottery() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_chat_messages_before_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NEW;
END;$$;

ALTER FUNCTION ng03.trigger_chat_messages_before_insert() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_planet_buildings_after_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NULL;
END;$$;

ALTER FUNCTION ng03.trigger_planet_buildings_after_update() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_planet_energy_transfers_before_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NEW;
END;$$;

ALTER FUNCTION ng03.trigger_planet_energy_transfers_before_changes() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_planet_ships_before_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NEW;
END;$$;

ALTER FUNCTION ng03.trigger_planet_ships_before_insert() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_planet_ships_after_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NULL;
END;$$;

ALTER FUNCTION ng03.trigger_planet_ships_after_changes() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.trigger_planet_ship_pendings_after_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    
BEGIN
    
    RETURN NULL;
END;$$;

ALTER FUNCTION ng03.trigger_planet_ship_pendings_after_delete() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_execute_processes() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
   
   process record;
   
BEGIN

    FOR process IN (SELECT * FROM dt_processes WHERE last_rundate IS NULL OR last_rundate + frequency < now()) LOOP
        BEGIN
        
            EXECUTE 'SELECT ' || process.id;
            UPDATE dt_processes SET last_rundate = now(), last_result = null WHERE id = process.id;
            
        EXCEPTION WHEN OTHERS THEN
            
            UPDATE dt_processes SET last_rundate = now(), last_result = SQLERRM WHERE id = process.id;
            INSERT INTO log_processes(process_id, error) VALUES(process.id, SQLERRM);
            
        END;
    END LOOP;
    
END;$$;

ALTER FUNCTION ng03.admin_execute_processes() OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_generate_starting_galaxy(_galaxy_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    i integer;
    t integer;

    sector integer;
    sector_value float;
    sector_planets integer;
    special_planets integer[];

    planet_id integer;
    planet_type integer;
    floor integer;
    space integer;
    ore_pct integer;
    hydro_pct integer;

BEGIN

    INSERT INTO gm_galaxies(id) VALUES(_galaxy_id);

    FOR sector IN 1..99 LOOP

        FOR i IN 1..10 LOOP special_planets[i] := int4(50 * random()); END LOOP;
        
        sector_planets := 25;
        FOR p IN 1..25 LOOP
            FOR i IN 1..10 LOOP
                IF special_planets[i] = p THEN
                    sector_planets := sector_planets - 1;
                    EXIT;
                END IF;
            END LOOP;
        END LOOP;

        IF sector = 45 OR sector = 46 OR sector = 55 OR sector = 56 THEN sector_planets := sector_planets - 1; END IF;

        sector_value := (6 - 0.55 * sqrt(power(5.5 - (sector % 10), 2) + power(5.5 - (sector / 10 + 1), 2))) * 20;
        sector_value := sector_value * 25 / sector_planets;

        FOR p IN 1..25 LOOP

            planet_type := 1;

            FOR i IN 1..10 LOOP
                IF special_planets[i] = p THEN

                    planet_type := int2(100 * random());
                    IF planet_type < 92 THEN planet_type := 0;
                    ELSEIF planet_type <= 98 THEN planet_type := 3;
                    ELSE planet_type := 4;
                    END IF;

                    IF (planet_type = 3 OR planet_type = 4) AND (6 - 0.55 * sqrt(power(5.5 - (sector % 10), 2) + power(5.5 - (sector / 10 + 1), 2))) > 4.5 THEN planet_type := 1; END IF;

                    EXIT;
                END IF;
            END LOOP;

            IF p = 13 AND (sector = 23 OR sector = 28 OR sector = 73 OR sector = 78) THEN planet_type := 1; END IF;

            IF (sector = 45 AND p = 25) OR (sector = 46 AND p = 21) OR (sector = 55 AND p = 5) OR (sector = 56 AND p = 1) THEN planet_type := 0; END IF;

            IF sector <= 10 OR sector >= 90 OR sector % 10 = 0 OR sector % 10 = 1 THEN
          
                IF planet_type = 3 OR planet_type = 4 THEN planet_type := 0; END IF;

                floor := 80;
                space := 10;
                ore_pct := 60;
                hydro_pct := 60;

            ELSE

                floor := int2((sector_value * 2/3) + random() * sector_value / 3);
                WHILE floor < 80 LOOP floor := floor + 4; END LOOP;
                WHILE floor > 155 LOOP floor := floor - 4; END LOOP;
                
                IF floor < 90 THEN space := int2(20 + random() * 20);
                ELSEIF floor < 100 THEN space := int2(15 + random() * 20);
                ELSE space := int2(10 + random() * 15);
                END IF;
                
                t := int2(80 + random() * 100 + sector_value / 5);
                IF floor > 70 AND floor < 85 THEN t := int2(t * 1.3); END IF;
                ore_pct := int2(LEAST(35 + random() * (t - 47), t));
                hydro_pct := t - ore_pct;
    
                IF random() > 0.6 THEN
                    t := hydro_pct;
                    hydro_pct := ore_pct;
                    ore_pct := t;
                END IF;

            END IF;

            IF planet_type = 0 THEN

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0);

            ELSEIF planet_type = 1 THEN

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro) VALUES(_galaxy_id, sector, p, floor, space, ore_pct, hydro_pct) RETURNING id INTO planet_id;

                IF floor > 120 AND random() < 0.01 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_sandworm');
                END IF;

                IF floor > 65 AND random() < 0.001 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_magnetic');
                END IF;

            ELSEIF planet_type = 3 THEN

                IF sector = 34 OR sector = 35 OR sector = 36 OR sector = 37 OR sector = 44 OR sector = 47 OR sector = 54 OR sector = 57 OR sector = 64 OR sector = 65 OR sector = 66 OR sector = 67 THEN
                    INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_ore) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 22000 + 5000 * random());
                ELSE
                    INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_ore) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 13000 + 4000 * random());
                END IF;

            ELSE

                IF sector = 34 OR sector = 35 OR sector = 36 OR sector = 37 OR sector = 44 OR sector = 47 OR sector = 54 OR sector = 57 OR sector = 64 OR sector = 65 OR sector = 66 OR sector = 67 THEN
                    INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_hydro) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 22000 + 5000 * random());
                ELSE
                    INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_hydro) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 13000 + 4000 * random());
                END IF;

            END IF;

        END LOOP;

    END LOOP;

    PERFORM admin_generate_merchant(_galaxy_id, 23, 13);
    PERFORM admin_generate_merchant(_galaxy_id, 28, 13);
    PERFORM admin_generate_merchant(_galaxy_id, 73, 13);
    PERFORM admin_generate_merchant(_galaxy_id, 78, 13);

    PERFORM admin_generate_vortexes(_galaxy_id);

    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 1, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor > 95 AND gm_planets.floor <= 120 AND profile_id IS NULL;
    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 2, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor > 120 AND profile_id IS NULL;
    UPDATE gm_profile_fleets SET stance = true WHERE profile_id = 1 AND NOT stance;

END;$$;

ALTER FUNCTION ng03.admin_generate_starting_galaxy(_galaxy_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_generate_special_galaxy(_galaxy_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    i integer;
    t integer;

    sector integer;
    sector_value float;
    sector_planets integer;
    special_planets integer[];

    planet_id integer;
    planet_type integer;
    floor integer;
    space integer;
    ore_pct integer;
    hydro_pct integer;
    
BEGIN

    INSERT INTO gm_galaxies(id, allow_new) VALUES(_galaxy_id, false);

    FOR sector IN 1..99 LOOP
    
        FOR i IN 1..10 LOOP special_planets[i] := int4(30 * random()); END LOOP;
        
        sector_planets := 25;
        FOR p IN 1..25 LOOP
            FOR i IN 1..10 LOOP
                IF special_planets[i] = p THEN
                    sector_planets := sector_planets - 1;
                    EXIT;
                END IF;
            END LOOP;
        END LOOP;

        IF sector = 45 OR sector = 46 OR sector = 55 OR sector = 56 THEN sector_planets := sector_planets - 1; END IF;

        sector_value := 130 - 3 * LEAST(_planet_get_distance(sector, 13, 23, 13), _planet_get_distance(sector, 13, 28, 13), _planet_get_distance(sector, 13, 73, 13), _planet_get_distance(sector, 13, 78, 13));
        sector_value := sector_value * 25 / sector_planets;

        FOR p IN 1..25 LOOP
         
            planet_type := 1;

            FOR i IN 1..10 LOOP
                IF special_planets[i] = p THEN

                    planet_type := int2(100 * random());
                    IF planet_type < 98 THEN planet_type := 0;
                    ELSEIF random() < 0.5 THEN planet_type := 3;
                    ELSE planet_type := 4;
                    END IF;

                    EXIT;
                END IF;
            END LOOP;

            IF p = 13 AND (sector = 23 OR sector = 28 OR sector = 73 OR sector = 78) THEN planet_type := 1; END IF;

            IF (sector = 45 AND p = 25) OR (sector = 46 AND p = 21) OR (sector = 55 AND p = 5) OR (sector = 56 AND p = 1) THEN planet_type := 0; END IF;
            
            floor := int2(1.1 * ((sector_value * 2/3) + random() * sector_value / 3));
            WHILE floor > 200 LOOP floor := floor - 4; END LOOP;
            
            IF floor < 90 THEN space := int2(20 + random() * 20);
            ELSEIF floor < 100 THEN space := int2(15 + random() * 20);
            ELSE space := int2(10 + random() * 15);
            END IF;
            
            t := int2(80 + random() * 100 + sector_value / 5);
            ore_pct := int2(LEAST(35 + random() * (t - 47), t));
            hydro_pct := t - ore_pct;

            IF random() > 0.6 THEN
                t := hydro_pct;
                hydro_pct := ore_pct;
                ore_pct := t;
            END IF;
            
            IF planet_type = 0 THEN

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0);

            ELSEIF planet_type = 1 THEN

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro) VALUES(_galaxy_id, sector, p, floor, space, ore_pct, hydro_pct) RETURNING id INTO planet_id;

                IF floor > 170 AND random() < 0.5 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_seismic');
                END IF;

                IF floor > 129 AND random() < 0.05 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_sandworm');
                END IF;

                IF floor > 65 AND random() < 0.02 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_extraordinary');
                END IF;

                IF floor > 65 AND random() < 0.01 THEN
                    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(planet_id, 'bd_planet_magnetic');
                END IF;

            ELSEIF planet_type = 3 THEN

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_ore) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 42000 + 10000 * random());

            ELSE

                INSERT INTO gm_planets(galaxy_id, sector, planet, floor, space, pct_ore, pct_hydro, spawn_hydro) VALUES(_galaxy_id, sector, p, 0, 0, 0, 0, 42000 + 10000 * random());

            END IF;
            
        END LOOP;
       
    END LOOP;

    PERFORM admin_generate_vortexes(_galaxy_id);
    
    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 5, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor = 0 AND profile_id IS NULL;
    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 6, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor >= 95 AND gm_planets.floor < 140 AND profile_id IS NULL;
    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 7, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor >= 140 AND gm_planets.floor < 180 AND profile_id IS NULL;
    PERFORM admin_generate_fleet(1, 'Les fossoyeurs', 8, id) FROM gm_planets WHERE galaxy_id = _galaxy_id AND gm_planets.floor >= 180 AND profile_id IS NULL;
    UPDATE gm_profile_fleets SET stance = true WHERE profile_id = 1 AND NOT stance;

END;$$;

ALTER FUNCTION ng03.admin_generate_special_galaxy(_galaxy_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_generate_vortexes(_galaxy_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    vortexes integer;
    
    gm_planet record;
    
BEGIN

    SELECT INTO gm_planet * FROM gm_planets
        WHERE galaxy_id = _galaxy_id AND sector > 11 AND sector < 30 AND sector % 10 <> 0 AND sector % 10 <> 1 AND floor = 0 AND spawn_ore = 0 AND spawn_hydro = 0
        ORDER BY random() LIMIT 1;
    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_planet_vortex');
    vortexes := 1;
    
    IF random() > 0.40 THEN
        SELECT INTO gm_planet * FROM gm_planets
            WHERE galaxy_id = _galaxy_id AND sector > 31 AND sector < 50 AND sector % 10 <> 0 AND sector % 10 <> 1 AND floor = 0 AND spawn_ore = 0 AND spawn_hydro = 0
        ORDER BY random() LIMIT 1;        
        IF FOUND THEN
            INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_planet_vortex');
            vortexes := 2;
        END IF;
    END IF;

    IF random() > 0.70 THEN
        SELECT INTO gm_planet * FROM gm_planets
            WHERE galaxy_id = _galaxy_id AND sector > 51 AND sector < 90 AND sector % 10 <> 0 AND sector % 10 <> 1 AND floor = 0 AND spawn_ore = 0 AND spawn_hydro = 0
        ORDER BY random() LIMIT 1;        
        IF FOUND THEN
            INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_planet_vortex');
            vortexes := 3;
        END IF;
    END IF;

    IF vortexes < 2 OR random() > 0.5 THEN
        SELECT INTO gm_planet * FROM gm_planets
            WHERE galaxy_id = _galaxy_id AND sector > 71 AND sector < 90 AND sector % 10 <> 0 AND sector % 10 <> 1 AND floor = 0 AND spawn_ore = 0 AND spawn_hydro = 0
        ORDER BY random() LIMIT 1;        
        IF FOUND THEN
            INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_planet_vortex');
            vortexes := 4;
        END IF;
    END IF;

END;$$;

ALTER FUNCTION ng03.admin_generate_vortexes(_galaxy_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_generate_merchant(_galaxy_id integer, _sector integer, _planet integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    gm_planet record;

BEGIN

    SELECT INTO gm_planet * FROM gm_planets WHERE galaxy_id = _galaxy_id AND sector = _sector AND planet = _planet;
    IF NOT FOUND THEN RETURN; END IF;
    
    UPDATE gm_planets SET profile_id = 3 WHERE id = gm_planet.id AND profile_id IS NULL;

    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_planet_merchant');
    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_ore_storage_merchant');
    INSERT INTO gm_planet_buildings(planet_id, building_id) VALUES(gm_planet.id, 'bd_hydro_storage_merchant');

    UPDATE gm_planets SET worker_count = 100000, growing = false WHERE id = gm_planet.id;

END;$$;

ALTER FUNCTION ng03.admin_generate_merchant(_galaxy_id integer, _sector integer, _planet integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03.admin_generate_fleet(_profile_id integer, _name character varying, _size integer, _planet_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    fleet_id integer;

BEGIN

    INSERT INTO gm_profile_fleets(created_by, profile_id, planet_id, name) VALUES('system', _profile_id, _planet_id, _name) RETURNING id INTO fleet_id;
    
    IF _size = 1 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 20 + int4(random() * 20));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 80 + int4(random() * 50));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 50 + int4(random() * 50));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 20 + int4(random() * 20));
    END IF;

    IF _size = 2 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 100 + int4(random() * 100));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 100 + int4(random() * 100));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 60 + int4(random() * 50));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 100 + int4(random() * 100));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_multigun', 30 + int4(random() * 30));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_light', 30 + int4(random() * 30));
        UPDATE gm_profile_fleets SET cargo_worker = 5000 WHERE id = fleet_id;
    END IF;

    IF _size = 5 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 200 + int4(random() * 2000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 200 + int4(random() * 2000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 200 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 200 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_multigun', 200 + int4(random() * 600));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_light', 200 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_heavy', 200 + int4(random() * 800));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_elite', 500 + int4(random() * 1000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_light', 300 + int4(random() * 800));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_heavy', 500 + int4(random() * 700));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_util_droppods', 30 + int4(random() * 70));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_util_jumper', int4(random() * 300));
        UPDATE gm_profile_fleets SET cargo_soldier = 50000, cargo_worker = 50000 WHERE id = fleet_id;
    END IF;

    IF _size = 6 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 200 + int4(random() * 1000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 200 + int4(random() * 1000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 200 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 200 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_multigun', 200 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_light', 200 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_heavy', 200 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_elite', 500 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_light', 300 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_heavy', 500 + int4(random() * 300));
        UPDATE gm_profile_fleets SET cargo_soldier = 50000, cargo_worker = 50000 WHERE id = fleet_id;
    END IF;

    IF _size = 7 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 1200 + int4(random() * 1000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 1200 + int4(random() * 1000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 300 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 300 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_multigun', 300 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_light', 300 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_heavy', 400 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_elite', 700 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_light', 500 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_heavy', 1000 + int4(random() * 300));
        UPDATE gm_profile_fleets SET cargo_soldier = 50000, cargo_worker = 50000 WHERE id = fleet_id;
    END IF;

    IF _size = 8 THEN
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_light', 5200 + int4(random() * 2000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_fighter_heavy', 5200 + int4(random() * 2000));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_light', 800 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_heavy', 800 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_corvet_multigun', 1200 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_light', 1000 + int4(random() * 300));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_heavy', 600 + int4(random() * 200));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_frigate_elite', 1000 + int4(random() * 500));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_light', 1200 + int4(random() * 800));
        INSERT INTO gm_profile_fleet_ships(created_by, fleet_id, ship_id, count) VALUES('system', fleet_id, 'sh_cruiser_heavy', 2000 + int4(random() * 1000));
        UPDATE gm_profile_fleets SET cargo_soldier = 50000, cargo_worker = 50000 WHERE id = fleet_id;
    END IF;
    
END;$$;

ALTER FUNCTION ng03.admin_generate_fleet(_profile_id integer, _name character varying, _size integer, _planet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._planet_get_distance(_from_sector integer, _from_planet integer, _to_sector integer,  _to_planet integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF _from_sector <> _to_sector THEN
        RETURN 6 * sqrt(((_from_sector - 1) / 10 - (_to_sector - 1) / 10 ) ^ 2 + ((_from_sector - 1) % 10 - (_to_sector - 1) % 10) ^ 2);
    ELSE
        RETURN sqrt(((_from_planet - 1) / 5 - (_to_planet - 1) / 5 ) ^ 2 + ((_from_planet - 1) % 5 - (_to_planet - 1) % 5) ^ 2);
    END IF;
END;$$;

ALTER FUNCTION ng03._planet_get_distance(_from_sector integer, _from_planet integer, _to_sector integer,  _to_planet integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._galaxy_get_recommendation(_galaxy_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

    galaxy record;
    
    profiles integer;
    recommendation integer;
    
BEGIN
    
    SELECT INTO galaxy * FROM gm_galaxies WHERE id = _galaxy_id AND allow_new = true;
    IF NOT FOUND THEN RETURN -1; END IF;
    
    SELECT INTO profiles COUNT(DISTINCT profile_id) FROM gm_planets WHERE galaxy_id = _galaxy_id;
    IF profiles < 50 THEN recommendation := 2;
    ELSE recommendation := 1;
    END IF;
    
    RETURN recommendation;
END;$$;

ALTER FUNCTION ng03._galaxy_get_recommendation(_galaxy_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._profile_reset_commanders(_profile_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

    gm_profile record;
    
BEGIN

    SELECT INTO gm_profile * FROM gm_profiles WHERE id = _profile_id;
    IF NOT FOUND THEN RETURN; END IF;
    
    DELETE FROM gm_profile_commanders WHERE profile_id = _profile_id;

    IF gm_profile.orientation_id = 'or_soldier' THEN
        INSERT INTO gm_profile_commanders(profile_id, engaging_date, point_count, mod_fleet_shield, mod_fleet_handling, mod_fleet_tracking, mod_fleet_damage)
            VALUES(_profile_id, now(), 10, 1.10, 1.10, 1.10, 1.10);
    ELSE
        INSERT INTO gm_profile_commanders(profile_id, engaging_date, point_count)
            VALUES(_profile_id, now(), 15);
    END IF;
END;$$;

ALTER FUNCTION ng03._profile_reset_commanders(_profile_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._fleet_get_speed(_fleet_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

    speed integer;
    
    ship_speed integer;
    
BEGIN

    speed := 25000;
    
    FOR ship_speed IN (SELECT speed FROM gm_profile_fleet_ships JOIN dt_ships ON gm_profile_fleet_ships.ship_id = dt_ships.id WHERE fleet_id = _fleet_id AND count > 0) LOOP
        IF ship_speed < speed THEN speed := ship_speed; END IF;
    END LOOP;
    
    return speed;
END;$$;

ALTER FUNCTION ng03._fleet_get_speed(_fleet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._fleet_get_real_signature(_fleet_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

    signature integer;
    
    ship record;
    
BEGIN

    signature := 0;
    
    FOR ship IN (SELECT signature, count FROM gm_profile_fleet_ships JOIN dt_ships ON gm_profile_fleet_ships.ship_id = dt_ships.id WHERE fleet_id = _fleet_id) LOOP
        signature := signature + (ship.signature * ship.count);
    END LOOP;
    
    return signature;
END;$$;

ALTER FUNCTION ng03._fleet_get_real_signature(_fleet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._planet_get_nearest(_profile_id integer, _planet_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

	gm_planet record;
    
    res integer;
    
BEGIN
	SELECT INTO gm_planet * FROM gm_planets WHERE id = _planet_id;

	SELECT INTO res id FROM gm_planets
        WHERE profile_id = _profile_id AND galaxy_id = gm_planet.galaxy_id AND floor > 0 AND space > 0
        ORDER BY _planet_get_distance(sector, planet, gm_planet.sector, gm_planet.planet) ASC LIMIT 1;
	IF FOUND THEN RETURN res; END IF;

	SELECT INTO res id FROM gm_planets
        WHERE profile_id IS NULL AND galaxy_id = gm_planet.galaxy_id AND NOT sector IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 20, 21, 30, 31, 40, 41, 50, 51, 60, 61, 70, 71, 80, 81, 90, 91)
        ORDER BY _planet_get_distance(sector, planet, gm_planet.sector, gm_planet.planet) ASC LIMIT 1;
	IF FOUND THEN RETURN res; END IF;

	RETURN -1;
END;$$;

ALTER FUNCTION ng03._planet_get_nearest(_profile_id integer, _planet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._planet_clear(_planet_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    DELETE FROM gm_planet_building_pendings WHERE planet_id = _planet_id;
    DELETE FROM gm_planet_buildings USING dt_buildings WHERE planet_id = _planet_id AND building_id = dt_buildings.id AND NOT dt_buildings.category_id = 'cat_bd_modifier';

    DELETE FROM gm_planet_ship_pendings WHERE planet_id = _planet_id;
    DELETE FROM gm_planet_ships WHERE planet_id = _planet_id;

    DELETE FROM gm_planet_energy_transfers WHERE planet_id_1 = _planet_id OR planet_id_2 = _planet_id;

    UPDATE gm_planets SET
        profile_id = null, name = '', commander_id = null,
        ore_count = 0, hydro_count = 0,
        worker_count = 0, scientist_count = 0, soldier_count = 0,
        production_last_date = now(),
        ore_price = 0, hydro_price = 0
    WHERE id = _planet_id;
    
END;$$;

ALTER FUNCTION ng03._planet_clear(_planet_id integer) OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE FUNCTION ng03._commander_generate_name() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN

    RETURN (SELECT id FROM dt_commander_firstnames ORDER BY random() LIMIT 1) || ' ' || (SELECT id FROM dt_commander_lastnames ORDER BY random() LIMIT 1);
    
END;$$;

ALTER FUNCTION ng03._commander_generate_name() OWNER TO exileng;

--------------------------------------------------------------------------------
-- TABLES
--------------------------------------------------------------------------------

SET default_tablespace = '';
SET default_table_access_method = heap;

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_banned_pseudo (
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_banned_pseudo OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_banned_pseudo ADD CONSTRAINT dt_banned_pseudo_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_banned_pseudo VALUES('^modo$');
INSERT INTO ng03.dt_banned_pseudo VALUES('^admin');
INSERT INTO ng03.dt_banned_pseudo VALUES('^exile$');
INSERT INTO ng03.dt_banned_pseudo VALUES('^moderat');
INSERT INTO ng03.dt_banned_pseudo VALUES('^f[0o]ss[0o]*');
INSERT INTO ng03.dt_banned_pseudo VALUES('^oublié*');
INSERT INTO ng03.dt_banned_pseudo VALUES('^marchand*');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_building_categories (
    displaying_order integer NOT NULL,
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_building_categories OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_building_categories ADD CONSTRAINT dt_building_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_building_categories ADD CONSTRAINT dt_building_categories_displaying_order_key UNIQUE (displaying_order);

INSERT INTO ng03.dt_building_categories VALUES(10, 'cat_bd_modifier');
INSERT INTO ng03.dt_building_categories VALUES(20, 'cat_bd_deployed');
INSERT INTO ng03.dt_building_categories VALUES(30, 'cat_bd_planet');
INSERT INTO ng03.dt_building_categories VALUES(40, 'cat_bd_construction');
INSERT INTO ng03.dt_building_categories VALUES(50, 'cat_bd_resource');
INSERT INTO ng03.dt_building_categories VALUES(60, 'cat_bd_energy');
INSERT INTO ng03.dt_building_categories VALUES(70, 'cat_bd_people');
INSERT INTO ng03.dt_building_categories VALUES(80, 'cat_bd_ore_storage');
INSERT INTO ng03.dt_building_categories VALUES(90, 'cat_bd_hydro_storage');
INSERT INTO ng03.dt_building_categories VALUES(100, 'cat_bd_energy_storage');
INSERT INTO ng03.dt_building_categories VALUES(110, 'cat_bd_army');
INSERT INTO ng03.dt_building_categories VALUES(120, 'cat_bd_space');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_buildings (
    category_id character varying NOT NULL,
    displaying_order integer NOT NULL,
    id character varying NOT NULL,
    max integer DEFAULT 1 NOT NULL,
    delay integer DEFAULT 0 NOT NULL,
    is_destroyable boolean DEFAULT true NOT NULL,
    is_disable boolean DEFAULT false NOT NULL,
    is_active_when_destroying boolean DEFAULT false NOT NULL,
    cost_floor integer DEFAULT 0 NOT NULL,
    cost_space integer DEFAULT 0 NOT NULL,
    cost_ore integer DEFAULT 0 NOT NULL,
    cost_hydro integer DEFAULT 0 NOT NULL,
    cost_worker integer DEFAULT 0 NOT NULL,
    cost_prestige integer DEFAULT 0 NOT NULL,
    prod_ore integer DEFAULT 0 NOT NULL,
    prod_hydro integer DEFAULT 0 NOT NULL,
    prod_energy integer DEFAULT 0 NOT NULL,
    prod_credit integer DEFAULT 0 NOT NULL,
    prod_credit_random integer DEFAULT 0 NOT NULL,
    prod_prestige integer DEFAULT 0 NOT NULL,
    train_scientist integer DEFAULT 0 NOT NULL,
    train_soldier integer DEFAULT 0 NOT NULL,
    stock_ore integer DEFAULT 0 NOT NULL,
    stock_hydro integer DEFAULT 0 NOT NULL,
    stock_energy integer DEFAULT 0 NOT NULL,
    stock_worker integer DEFAULT 0 NOT NULL,
    stock_scientist integer DEFAULT 0 NOT NULL,
    stock_soldier integer DEFAULT 0 NOT NULL,
    mod_prod_ore real DEFAULT 0 NOT NULL,
    mod_prod_hydro real DEFAULT 0 NOT NULL,
    mod_prod_energy real DEFAULT 0 NOT NULL,
    mod_prod_worker real DEFAULT 0 NOT NULL,
    mod_speed_building real DEFAULT 0 NOT NULL,
    mod_speed_ship real DEFAULT 0 NOT NULL,
    mod_need_ore real DEFAULT 0 NOT NULL,
    mod_need_hydro real DEFAULT 0 NOT NULL,
    working_energy integer DEFAULT 0 NOT NULL,
    working_credit integer DEFAULT 0 NOT NULL,
    strength_radar integer DEFAULT 0 NOT NULL,
    strength_jammer integer DEFAULT 0 NOT NULL,
    factor_maintenance integer DEFAULT 0 NOT NULL,
    factor_security integer DEFAULT 0 NOT NULL,
    factor_sandworm integer DEFAULT 0 NOT NULL,
    factor_seismic integer DEFAULT 0 NOT NULL,
    factor_vortex integer DEFAULT 0 NOT NULL,
    factor_need_ore integer DEFAULT 0 NOT NULL,
    factor_need_hydro integer DEFAULT 0 NOT NULL,
    antenna_receiving integer DEFAULT 0 NOT NULL,
    antenna_sending integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.dt_buildings OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_buildings ADD CONSTRAINT dt_buildings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_buildings ADD CONSTRAINT dt_buildings_displaying_order_key UNIQUE (category_id, displaying_order);
ALTER TABLE ONLY ng03.dt_buildings ADD CONSTRAINT dt_buildings_category_id_fkey FOREIGN KEY (category_id) REFERENCES ng03.dt_building_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_buildings VALUES('cat_bd_modifier', 10, 'bd_modifier_babyboom', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_modifier', 20, 'bd_modifier_ore', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_modifier', 30, 'bd_modifier_hydro', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_modifier', 40, 'bd_modifier_magnetic_storm', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -0.6, -0.6, -0.3, 0, -0.99, -0.99, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_deployed', 10, 'bd_deployed_radar', 1, 0, true, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_deployed', 20, 'bd_deployed_jammer', 1, 0, true, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 1, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_deployed', 30, 'bd_deployed_vortex_medium', 1, 0, true, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_deployed', 40, 'bd_deployed_vortex_large', 1, 0, true, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 4, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_deployed', 50, 'bd_deployed_vortex_killer', 1, 0, true, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, -8, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 10, 'bd_planet_vortex', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 20, 'bd_planet_magnetic', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 30, 'bd_planet_extraordinary', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0, 0.8, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 40, 'bd_planet_seismic', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 50, 'bd_planet_sandworm', 1, 0, false, false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 60, 'bd_planet_merchant', 1, 0, false, false, false, 20, 0, 900000, 600000, 100000, 0, 0, 0, 20000, 0, 0, 0, 0, 0, 400000, 400000, 1000000, 600000, 100000, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 70, 'bd_planet_colony', 1, 0, false, false, false, 2, 0, 20000, 10000, 2500, 0, 100, 50, 300, 2500, 0, 10, 50, 50, 100000, 100000, 30000, 20000, 1000, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 1, 0, 0, 0, 8000, 8000, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 80, 'bd_planet_city', 1, 64800, true, false, false, 2, 0, 35000, 35000, 6000, 0, 0, 0, 0, 1500, 0, 0, 0, 0, 0, 0, 70000, 10000, 0, 0, 0.02, 0.02, 0.02, 0.1, 0, 0, 0, 0, 100, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 90, 'bd_planet_metropolis', 1, 259200, true, false, false, 3, 1, 200000, 200000, 30000, 0, 0, 0, 0, 2500, 0, 0, 0, 0, 0, 0, 0, 10000, 0, 0, 0.02, 0.02, 0.02, 0.1, 0, 0, 0, 0, 500, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 100, 'bd_planet_wonder', 1, 320000, true, false, false, 2, 0, 600000, 150000, 28000, 1000, 0, 0, 0, 1000, 2000, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 110, 'bd_planet_cave', 5, 345600, false, false, false, -4, 0, 400000, 300000, 45000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_planet', 120, 'bd_planet_moon', 1, 432000, false, false, false, 0, -10, 700000, 150000, 55000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_construction', 10, 'bd_construction_prefab', 1, 43200, true, false, false, 1, 0, 2000, 1250, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 50, 50, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_construction', 20, 'bd_construction_automate', 1, 64800, true, false, false, 1, 0, 22500, 15000, 15000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 250, 100, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_construction', 30, 'bd_construction_synthesis', 1, 172800, true, false, false, 1, 0, 100000, 80000, 35000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 800, 150, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_construction', 40, 'bd_construction_sandworm', 1, 172800, true, true, false, 0, 0, 100000, 80000, 30000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2500, 500, 0, 0, 10, 1, -19, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_construction', 50, 'bd_construction_seismic', 1, 18000, true, true, false, 4, 0, 420000, 31000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3000, 500, 0, 0, 1, 0, 0, -19, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_resource', 10, 'bd_resource_mine', 999, 7200, true, true, false, 2, 0, 500, 1000, 2000, 0, 400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, -0.015, 0, 25, 20, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_resource', 20, 'bd_resource_well', 999, 7200, true, true, false, 2, 0, 1000, 500, 2000, 0, 0, 400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, -0.015, 25, 20, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_resource', 30, 'bd_resource_manufactory', 999, 54000, true, true, false, 4, 0, 30000, 25000, 10000, 0, 0, 0, 0, 8000, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3000, 0, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_resource', 40, 'bd_resource_field', 999, 78000, true, true, false, 7, 0, 30000, 17000, 10000, 0, 0, 0, 0, 40000, 10000, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000, 50, 0, 0, 50, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 10, 'bd_energy_solar_plant', 999, 1200, true, false, false, 1, 0, 200, 300, 1000, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 20, 'bd_energy_geothermal', 999, 3600, true, false, false, 1, 0, 1500, 1250, 1000, 0, 0, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 30, 'bd_energy_nuclear', 999, 43200, true, false, false, 2, 0, 28000, 14000, 7500, 0, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 150, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 40, 'bd_energy_tokamak', 1, 172800, true, false, false, 4, 0, 140000, 90000, 40000, 0, 0, 0, 10000, 0, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 600, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 50, 'bd_energy_rectenna', 1, 42000, true, false, false, 2, 0, 16000, 5000, 6000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 25, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 60, 'bd_energy_solar_satellite', 999, 32000, true, false, false, 0, 1, 4000, 7000, 2500, 0, 0, 0, 600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 125, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 70, 'bd_energy_receiving_satellite', 999, 28000, true, false, false, 0, 1, 9000, 6000, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 5, 1, 0, 0, 0, 0, 0, 1, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 80, 'bd_energy_sending_satellite', 999, 100000, true, true, false, 0, 1, 120000, 80000, 25000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 50, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 1);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 90, 'bd_energy_star_belt', 1, 512000, true, false, false, 0, 2, 2000000, 1600000, 50000, 200000, 0, 0, 50000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10000, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy', 100, 'bd_energy_star_panel', 5, 128000, true, false, false, 0, 0, 400000, 300000, 25000, 10000, 0, 0, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 10, 'bd_people_laboratory', 999, 9600, true, false, false, 1, 0, 2500, 2000, 4000, 0, 0, 0, 0, 0, 0, 0, 150, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 50, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 20, 'bd_people_center', 1, 108000, true, false, false, 2, 0, 28000, 21000, 15000, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 150, 50, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 30, 'bd_people_workshop', 999, 21600, true, false, false, 1, 0, 8000, 4000, 5000, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 3000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 150, 0, 0, 0, 5, 1, 0, 0, 0, 800, 800, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 40, 'bd_people_house', 10, 28000, true, false, false, 4, 0, 30000, 18000, 10000, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0.1, 0.1, 500, 0, 0, 0, 10, 1, 0, 0, 0, 18750, 18750, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 50, 'bd_people_barrack', 999, 108000, true, true, false, 1, 0, 22000, 10000, 6000, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 200, 100, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_people', 60, 'bd_people_base', 999, 172800, true, false, false, 3, 0, 110000, 90000, 30000, 0, 0, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 600, 250, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_ore_storage', 10, 'bd_ore_storage_1', 999, 28000, true, false, false, 2, 0, 25000, 14000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 20, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_ore_storage', 20, 'bd_ore_storage_2', 999, 56000, true, false, false, 3, 0, 80000, 55000, 15000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 100, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_ore_storage', 30, 'bd_ore_storage_3', 999, 128000, true, false, false, 2, 0, 500000, 400000, 25000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 2000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 200, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_ore_storage', 40, 'bd_ore_storage_merchant', 999, 0, true, false, false, 5, 0, 3000000, 2000000, 120000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 900000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_hydro_storage', 10, 'bd_hydro_storage_1', 999, 30800, true, false, false, 2, 0, 25000, 14000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 20, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_hydro_storage', 20, 'bd_hydro_storage_2', 999, 61600, true, false, false, 3, 0, 80000, 55000, 15000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 500, 100, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_hydro_storage', 30, 'bd_hydro_storage_3', 999, 128000, true, false, false, 2, 0, 500000, 400000, 25000, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 200, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_hydro_storage', 40, 'bd_hydro_storage_merchant', 999, 0, true, false, false, 5, 0, 3000000, 2000000, 120000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 900000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_energy_storage', 10, 'bd_energy_storage_1', 999, 30800, true, false, false, 1, 0, 30000, 20000, 15000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 20, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_army', 10, 'bd_army_light', 1, 50400, true, false, false, 6, 0, 32000, 25000, 17500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.02, 0, 0, 250, 300, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_army', 20, 'bd_army_heavy', 1, 172800, true, false, false, 12, 0, 180000, 160000, 32000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.02, 0, 0, 600, 1000, 0, 0, 20, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_space', 10, 'bd_space_radar', 999, 28800, true, true, false, 1, 0, 1000, 500, 2000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100, 150, 1, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_space', 20, 'bd_space_spaceport', 1, 36000, true, false, false, 4, 0, 2500, 2000, 5000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 200, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_space', 30, 'bd_space_sphipyard', 1, 108000, true, false, false, 2, 6, 40000, 30000, 22000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 150, 1500, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_space', 40, 'bd_space_satellite', 999, 39600, true, true, false, 0, 2, 15000, 8500, 7000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 300, 200, 2, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_buildings VALUES('cat_bd_space', 50, 'bd_space_jammer', 999, 100000, true, true, false, 0, 1, 90000, 65000, 25000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 100, 0, 2, 5, 1, 0, 0, 0, 0, 0, 0, 0);

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_research_categories (
    displaying_order integer NOT NULL,
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_research_categories OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_research_categories ADD CONSTRAINT dt_research_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_research_categories ADD CONSTRAINT dt_research_categories_displaying_order_key UNIQUE (displaying_order);

INSERT INTO ng03.dt_research_categories VALUES(10, 'cat_rs_orientation');
INSERT INTO ng03.dt_research_categories VALUES(20, 'cat_rs_booster');
INSERT INTO ng03.dt_research_categories VALUES(30, 'cat_rs_technology');
INSERT INTO ng03.dt_research_categories VALUES(40, 'cat_rs_production');
INSERT INTO ng03.dt_research_categories VALUES(50, 'cat_rs_empire');
INSERT INTO ng03.dt_research_categories VALUES(60, 'cat_rs_science');
INSERT INTO ng03.dt_research_categories VALUES(70, 'cat_rs_weapon');
INSERT INTO ng03.dt_research_categories VALUES(80, 'cat_rs_ship');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_researches (
    category_id character varying NOT NULL,
    displaying_order integer NOT NULL,
    id character varying NOT NULL,
    is_researchable boolean DEFAULT true NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    max integer DEFAULT 1 NOT NULL,
    default_level integer DEFAULT 0 NOT NULL,
    expiration interval,
    cost_credit integer DEFAULT 0 NOT NULL,
    mod_prod_ore real DEFAULT 0 NOT NULL,
    mod_prod_hydro real DEFAULT 0 NOT NULL,
    mod_prod_energy real DEFAULT 0 NOT NULL,
    mod_speed_building real DEFAULT 0 NOT NULL,
    mod_speed_ship real DEFAULT 0 NOT NULL,
    mod_damage real DEFAULT 0 NOT NULL,
    mod_fleet_speed real DEFAULT 0 NOT NULL,
    mod_shield real DEFAULT 0 NOT NULL,
    mod_handling real DEFAULT 0 NOT NULL,
    mod_selling real DEFAULT 0 NOT NULL,
    mod_merchant_speed real DEFAULT 0 NOT NULL,
    mod_upkeep_commander real DEFAULT 0 NOT NULL,
    mod_upkeep_planet real DEFAULT 0 NOT NULL,
    mod_upkeep_scientist real DEFAULT 0 NOT NULL,
    mod_upkeep_soldier real DEFAULT 0 NOT NULL,
    mod_research_cost real DEFAULT 0 NOT NULL,
    mod_research_time real DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 0 NOT NULL,
    mod_energy_transfer real DEFAULT 0 NOT NULL,
    mod_reward_prestige real DEFAULT 0 NOT NULL,
    mod_reward_credit real DEFAULT 0 NOT NULL,
    mod_prestige real DEFAULT 0 NOT NULL,
    mod_need_ore real DEFAULT 0 NOT NULL,
    mod_need_hydro real DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.dt_researches OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_researches ADD CONSTRAINT dt_researches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_researches ADD CONSTRAINT dt_researches_displaying_order_key UNIQUE (category_id, displaying_order);
ALTER TABLE ONLY ng03.dt_researches ADD CONSTRAINT dt_research_category_id_fkey FOREIGN KEY (category_id) REFERENCES ng03.dt_research_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_researches VALUES('cat_rs_orientation', 10, 'rs_orientation_merchant', false, 0, 1, 0, null, 0, 0.05, 0.05, 0, 0, 0, 0, 0, 0, 0, 0.1, 0.25, 0, -0.05, 0, 0, 0, 0, 0.1, 0, 0, 0, 0.05, 0.1, 0.1);
INSERT INTO ng03.dt_researches VALUES('cat_rs_orientation', 20, 'rs_orientation_soldier', false, 0, 1, 0, null, 0, 0, 0, 0, 0, 0.2, 0, 0, 0.1, 0.1, 0, 0, -0.1, 0, 0, -0.1, 0, 0, 0, 0, 0.05, 0.1, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_orientation', 30, 'rs_orientation_scientist', false, 0, 1, 0, null, 0, 0, 0, 0.2, 0.1, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, -0.2, 0, -0.2, -0.05, 0, 0, 0.03, 0, 0.03, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_booster', 10, 'rs_booster_market', false, 0, 1, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_booster', 20, 'rs_booster_propulsion', true, 0, 1, 0, '48:00:00', 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_booster', 30, 'rs_booster_shield', true, 0, 1, 0, '48:00:00', 0, 0, 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_booster', 40, 'rs_booster_damage', true, 0, 1, 0, '48:00:00', 0, 0, 0, 0, 0, 0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_technology', 10, 'rs_technology_propulsion', true, 1, 5, 0, null, 40, 0, 0, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_technology', 20, 'rs_technology_energy', true, 3, 5, 0, null, 220, 0, 0, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_technology', 30, 'rs_technology_jumpdrive', true, 7, 1, 0, null, 4000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_technology', 40, 'rs_technology_deployment', true, 2, 1, 0, null, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 10, 'rs_production_industry', true, 3, 5, 0, null, 40, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 20, 'rs_production_massive', true, 3, 5, 0, null, 600, 0, 0, 0, 0.04, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 30, 'rs_production_mining', true, 2, 5, 0, null, 90, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 40, 'rs_production_mining_improved', true, 7, 5, 0, null, 2000, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 50, 'rs_production_refining', true, 2, 5, 0, null, 90, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_production', 60, 'rs_production_refining_improved', true, 7, 5, 0, null, 2000, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_empire', 10, 'rs_empire_planet', true, 0, 20, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_empire', 20, 'rs_empire_commander', true, 0, 5, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 10, 'rs_science_study', true, 3, 5, 2, null, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 20, 'rs_science_nuclear', true, 2, 3, 0, null, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 30, 'rs_science_plasma', true, 4, 3, 0, null, 1600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 40, 'rs_science_quantum', true, 6, 3, 0, null, 700, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 50, 'rs_science_planetology', true, 8, 1, 0, null, 6000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 60, 'rs_science_energy_transfer', true, 1, 1, 0, null, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.6, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 70, 'rs_science_energy_transfer_improved', true, 6, 5, 0, null, 1500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_science', 80, 'rs_science_sandworm', true, 5, 1, 0, null, 786, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 10, 'rs_weapon_army', true, 3, 5, 1, null, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 20, 'rs_weapon_rocket', true, 2, 1, 0, null, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 30, 'rs_weapon_missile', true, 4, 1, 0, null, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 40, 'rs_weapon_turret', true, 2, 3, 0, null, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 50, 'rs_weapon_railgun', true, 5, 3, 0, null, 210, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 60, 'rs_weapon_ion', true, 6, 1, 0, null, 290, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_weapon', 70, 'rs_weapon_shield', true, 6, 5, 0, null, 500, 0, 0, 0, 0, 0, 0, 0, 0.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 10, 'rs_ship_mechanic', true, 3, 5, 1, null, 50, 0, 0, 0, 0, 0.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 20, 'rs_ship_util', true, 1, 5, 0, null, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 30, 'rs_ship_tactic', true, 8, 3, 0, null, 800, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 40, 'rs_ship_light', true, 1, 3, 1, null, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 50, 'rs_ship_corvet', true, 2, 3, 0, null, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 60, 'rs_ship_frigate', true, 4, 3, 0, null, 350, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_researches VALUES('cat_rs_ship', 70, 'rs_ship_cruiser', true, 6, 3, 0, null, 600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_ship_categories (
    displaying_order integer NOT NULL,
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_ship_categories OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_ship_categories ADD CONSTRAINT dt_ship_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_ship_categories ADD CONSTRAINT dt_ship_categories_displaying_order_key UNIQUE (displaying_order);

INSERT INTO ng03.dt_ship_categories VALUES(10, 'cat_sh_cargo');
INSERT INTO ng03.dt_ship_categories VALUES(20, 'cat_sh_util');
INSERT INTO ng03.dt_ship_categories VALUES(30, 'cat_sh_deployment');
INSERT INTO ng03.dt_ship_categories VALUES(40, 'cat_sh_tactic');
INSERT INTO ng03.dt_ship_categories VALUES(50, 'cat_sh_special');
INSERT INTO ng03.dt_ship_categories VALUES(60, 'cat_sh_fighter');
INSERT INTO ng03.dt_ship_categories VALUES(70, 'cat_sh_corvet');
INSERT INTO ng03.dt_ship_categories VALUES(80, 'cat_sh_frigate');
INSERT INTO ng03.dt_ship_categories VALUES(90, 'cat_sh_cruiser');
INSERT INTO ng03.dt_ship_categories VALUES(100, 'cat_sh_dreadnought');
INSERT INTO ng03.dt_ship_categories VALUES(110, 'cat_sh_rogue');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_ships (
    category_id character varying NOT NULL,
    displaying_order integer NOT NULL,
    id character varying NOT NULL,
    delay integer DEFAULT 0 NOT NULL,
    cost_ore integer DEFAULT 0 NOT NULL,
    cost_hydro integer DEFAULT 0 NOT NULL,
    cost_energy integer DEFAULT 0 NOT NULL,
    cost_worker integer DEFAULT 0 NOT NULL,
    cost_prestige integer DEFAULT 0 NOT NULL,
    reward_prestige integer DEFAULT 0 NOT NULL,
    reward_credit integer DEFAULT 0 NOT NULL,
    signature integer DEFAULT 0 NOT NULL,
    speed integer DEFAULT 0 NOT NULL,
    cargo integer DEFAULT 0 NOT NULL,
    recycling integer DEFAULT 0 NOT NULL,
    droppods integer DEFAULT 0 NOT NULL,
    warping integer DEFAULT 0 NOT NULL,
    upkeep integer DEFAULT 0 NOT NULL,
    hull integer DEFAULT 0 NOT NULL,
    shield integer DEFAULT 0 NOT NULL,
    handling integer DEFAULT 0 NOT NULL,
    building_id character varying,
    tracking integer DEFAULT 0 NOT NULL,
    turrets integer DEFAULT 0 NOT NULL,
    dmg_thermal integer DEFAULT 0 NOT NULL,
    dmg_kinetic integer DEFAULT 0 NOT NULL,
    dmg_explosive integer DEFAULT 0 NOT NULL,
    dmg_em integer DEFAULT 0 NOT NULL,
    resist_thermal integer DEFAULT 0 NOT NULL,
    resist_kinetic integer DEFAULT 0 NOT NULL,
    resist_explosive integer DEFAULT 0 NOT NULL,
    resist_em integer DEFAULT 0 NOT NULL,
    tech integer DEFAULT 0 NOT NULL,
    required_ship_id character varying,
    new_ship_id character varying,
    required_vortex_strength integer DEFAULT 0 NOT NULL,
    leadership integer DEFAULT 0 NOT NULL,
    mod_speed real DEFAULT 0 NOT NULL,
    mod_shield real DEFAULT 0 NOT NULL,
    mod_handling real DEFAULT 0 NOT NULL,
    mod_tracking real DEFAULT 0 NOT NULL,
    mod_damage real DEFAULT 0 NOT NULL,
    mod_recycling real DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.dt_ships OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_ships ADD CONSTRAINT dt_ships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_ships ADD CONSTRAINT dt_ships_displaying_order_key UNIQUE (category_id, displaying_order);
ALTER TABLE ONLY ng03.dt_ships ADD CONSTRAINT dt_ship_category_id_fkey FOREIGN KEY (category_id) REFERENCES ng03.dt_ship_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 10, 'sh_cargo_1', 3600, 8000, 8000, 500, 200, 0, 0, 0, 32, 1200, 30000, 0, 0, 0, 20, 3000, 1000, 200, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 20, 'sh_cargo_2', 7200, 21000, 18000, 1000, 350, 0, 0, 0, 78, 1100, 100000, 0, 0, 0, 40, 9000, 4000, 100, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 30, 'sh_cargo_3', 10800, 48000, 27000, 2000, 600, 0, 0, 0, 150, 1000, 225000, 0, 0, 0, 75, 25000, 20000, 50, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 40, 'sh_upcargo_1', 3600, 17000, 10000, 500, 150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_cargo_1', 'sh_cargo_2', 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 50, 'sh_upcargo_2', 7200, 42000, 25000, 1500, 400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_cargo_1', 'sh_cargo_3', 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 60, 'sh_upcargo_3', 3600, 25000, 15000, 1000, 250, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_cargo_2', 'sh_cargo_3', 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cargo', 70, 'sh_cargo_caravel', 3600, 12000, 8000, 1000, 300, 0, 0, 0, 40, 1300, 100000, 0, 0, 0, 10, 8000, 10000, 200, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_util', 10, 'sh_util_probe', 180, 500, 500, 50, 0, 0, 0, 0, 1, 25000, 0, 0, 0, 0, 1, 1, 0, 1, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_util', 20, 'sh_util_recycler', 5760, 10000, 7000, 500, 100, 0, 0, 0, 34, 1000, 5000, 3000, 0, 0, 5, 6000, 5000, 100, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_util', 30, 'sh_util_jumper', 20400, 45000, 35000, 8000, 16, 0, 0, 0, 40, 800, 0, 0, 0, 2000, 10, 5000, 3000, 10, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_util', 40, 'sh_util_droppods', 4720, 15000, 12000, 200, 4, 0, 0, 0, 54, 1000, 1000, 0, 1000, 0, 40, 10000, 2000, 10, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 3, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 10, 'sh_deployment_colony', 54400, 25000, 11600, 10000, 2500, 0, 0, 0, 72, 450, 0, 0, 0, 0, 100, 10000, 2000, 1, 'bd_planet_colony', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 20, 'sh_deployment_prefab', 52800, 7000, 3800, 5000, 2, 0, 0, 0, 21, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_construction_prefab', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 30, 'sh_deployment_automate', 103200, 27500, 17600, 10000, 2, 0, 0, 0, 90, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_construction_automate', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 40, 'sh_deployment_synthesis', 182400, 105000, 82600, 50000, 2, 0, 0, 0, 375, 450, 0, 0, 0, 0, 100, 300, 0, 1, 'bd_construction_synthesis', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 3, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 50, 'sh_deployment_geothermal', 20400, 6000, 3000, 5000, 2, 0, 0, 0, 18, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_energy_geothermal', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 60, 'sh_deployment_laboratory', 32200, 7500, 4600, 5000, 2, 0, 0, 0, 24, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_people_laboratory', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 70, 'sh_deployment_center', 117600, 33000, 23600, 25000, 2, 0, 0, 0, 113, 450, 0, 0, 0, 0, 50, 300, 0, 1, 'bd_people_center', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 80, 'sh_deployment_workshop', 37600, 13000, 6600, 12500, 2, 0, 0, 0, 40, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_people_workshop', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 90, 'sh_deployment_barrack', 117600, 27000, 12600, 25000, 2, 0, 0, 0, 79, 450, 0, 0, 0, 0, 50, 300, 0, 1, 'bd_people_barrack', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 100, 'sh_deployment_ore_storage_1', 18600, 6000, 3100, 5000, 2, 0, 0, 0, 18, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_ore_storage_1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 110, 'sh_deployment_ore_storage_2', 37600, 30000, 16600, 12500, 2, 0, 0, 0, 93, 450, 0, 0, 0, 0, 50, 300, 0, 1, 'bd_ore_storage_2', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 120, 'sh_deployment_hydro_storage_1', 19500, 6000, 3100, 5000, 2, 0, 0, 0, 18, 450, 0, 0, 0, 0, 25, 300, 0, 1, 'bd_hydro_storage_1', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 130, 'sh_deployment_hydro_storage_2', 40400, 30000, 16600, 12500, 2, 0, 0, 0, 93, 450, 0, 0, 0, 0, 50, 300, 0, 1, 'bd_hydro_storage_2', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 140, 'sh_deployment_vortex_medium', 19000, 100000, 70000, 100000, 0, 100, 0, 0, 340, 2000, 0, 0, 0, 0, 200, 500, 0, 1, 'bd_deployed_vortex_medium', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 1, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 150, 'sh_deployment_vortex_large', 24000, 160000, 100000, 100000, 0, 1000, 0, 0, 520, 1200, 0, 0, 0, 0, 260, 500, 0, 1, 'bd_deployed_vortex_large', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_deployment', 160, 'sh_deployment_vortex_killer', 16000, 80000, 50000, 100000, 0, 2000, 0, 0, 260, 1200, 0, 0, 0, 0, 130, 500, 0, 1, 'bd_deployed_vortex_killer', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_tactic', 10, 'sh_tactic_radar', 19000, 30000, 20000, 2500, 0, 0, 0, 0, 100, 22500, 0, 0, 0, 0, 50, 1, 0, 1, 'bd_deployed_radar', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_tactic', 20, 'sh_tactic_jammer', 19000, 100000, 70000, 5000, 0, 0, 0, 0, 340, 20000, 0, 0, 0, 0, 200, 1, 0, 1, 'bd_deployed_jammer', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_tactic', 30, 'sh_tactic_battle', 76800, 300000, 250000, 80000, 30000, 0, 100, 0, 1100, 1000, 100000, 0, 0, 1000, 2000, 150000, 75000, 10, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, null, null, 4, 5000, 0, 0.1, 0.1, 0.2, 0.1, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_tactic', 40, 'sh_tactic_logistic', 93600, 350000, 270000, 100000, 31000, 0, 100, 0, 1240, 1000, 100000, 0, 0, 10000, 2000, 100000, 50000, 10, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, null, null, 4, 2000, 0.15, 0, 0, 0, 0, 0.2);
INSERT INTO ng03.dt_ships VALUES('cat_sh_tactic', 50, 'sh_uptactic_mothership', 18600, 60000, 30000, 20000, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_tactic_battlle', 'sh_tactic_logistic', 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_special', 10, 'sh_special_ruin', 120, 1000, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_fighter', 10, 'sh_fighter_light', 420, 800, 1200, 50, 2, 0, 1, 0, 4, 1450, 15, 0, 0, 0, 2, 350, 0, 1400, null, 2200, 1, 20, 0, 0, 0, -30, 0, 85, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_fighter', 20, 'sh_fighter_heavy', 550, 1000, 1500, 75, 2, 0, 1, 0, 5, 1500, 0, 0, 0, 0, 3, 275, 0, 1500, null, 2400, 1, 30, 0, 0, 0, -25, 0, 90, 0, 1, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_fighter', 30, 'sh_fighter_elite', 590, 1000, 1500, 75, 2, 5, 1, 0, 5, 1550, 0, 0, 0, 0, 2, 275, 0, 1505, null, 2450, 1, 35, 0, 0, 0, -24, 1, 91, 1, 1, null, null, 2, 5, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_fighter', 40, 'sh_upfighter_heavy', 200, 250, 350, 35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_fighter_light', 'sh_fighter_heavy', 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_fighter', 50, 'sh_upfighter_elite', 160, 100, 100, 10, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_fighter_heavy', 'sh_fighter_elite', 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_corvet', 10, 'sh_corvet_light', 600, 1500, 2000, 100, 4, 0, 2, 0, 7, 1200, 50, 0, 0, 0, 4, 1600, 0, 965, null, 1500, 3, 15, 0, 0, 0, 30, 15, 30, 5, 2, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_corvet', 20, 'sh_corvet_heavy', 800, 2000, 2500, 500, 8, 0, 2, 0, 9, 1200, 25, 0, 0, 0, 6, 1500, 0, 960, null, 1100, 1, 0, 0, 225, 0, 35, 20, 35, 10, 2, null, null, 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_corvet', 30, 'sh_corvet_multigun', 950, 2500, 2500, 750, 10, 0, 2, 0, 10, 1200, 25, 0, 0, 0, 7, 1500, 0, 970, null, 2300, 5, 15, 0, 0, 0, 36, 21, 36, 11, 2, null, null, 2, 4, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_corvet', 40, 'sh_corvet_elite', 1300, 3000, 3000, 600, 8, 10, 5, 0, 12, 1350, 50, 0, 0, 0, 9, 1800, 0, 965, null, 1700, 4, 20, 0, 0, 0, 35, 20, 35, 10, 2, null, null, 2, 7, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_frigate', 10, 'sh_frigate_light', 2080, 9000, 5000, 1000, 50, 0, 5, 0, 28, 900, 50, 0, 0, 16, 16, 7500, 2500, 680, null, 1000, 3, 0, 130, 0, 0, 60, 25, 45, 55, 3, null, null, 3, 10, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_frigate', 20, 'sh_frigate_heavy', 2500, 9000, 7000, 1500, 80, 0, 5, 0, 32, 900, 75, 0, 0, 16, 20, 3500, 2500, 680, null, 450, 1, 0, 0, 0, 4000, 65, 30, 45, 60, 3, null, null, 3, 5, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_frigate', 30, 'sh_frigate_elite', 4000, 13000, 12000, 2000, 120, 0, 5, 0, 50, 950, 50, 0, 0, 16, 35, 6000, 2500, 685, null, 2000, 8, 0, 0, 50, 0, 65, 30, 45, 60, 3, null, null, 3, 5, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cruiser', 10, 'sh_cruiser_light', 4400, 20000, 14000, 3000, 250, 0, 10, 0, 68, 800, 200, 0, 0, 50, 50, 10000, 20000, 400, null, 720, 4, 0, 400, 0, 0, 85, 45, 65, 30, 4, null, null, 4, 50, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cruiser', 20, 'sh_cruiser_heavy', 7900, 35000, 25000, 5000, 500, 0, 10, 0, 120, 800, 300, 0, 0, 100, 90, 10000, 25000, 400, null, 720, 6, 0, 750, 0, 0, 85, 50, 70, 35, 4, null, null, 4, 50, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cruiser', 30, 'sh_cruiser_elite', 8400, 35000, 25000, 5000, 500, 100, 10, 0, 120, 900, 300, 0, 0, 100, 80, 10000, 25000, 405, null, 725, 6, 0, 800, 0, 0, 90, 51, 71, 36, 4, null, null, 4, 100, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_cruiser', 40, 'sh_upcruiser_elite', 3600, 15000, 10000, 1000, 0, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'sh_cruiser_heavy', 'sh_cruiser_elite', 2, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_dreadnought', 10, 'sh_dreadnought', 0, 1300000, 1000000, 0, 6000, 5000, 1000, 0, 4600, 600, 10000, 0, 0, 0, 2000, 1000000, 2000000, 300, null, 1000, 20, 0, 0, 0, 10000, 99, 99, 99, 80, 5, null, null, 4, 1000, 0, 0.1, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 10, 'sh_rogue_recycler', 0, 25000, 15000, 0, 100, 0, 0, 50, 80, 1000, 15000, 15000, 0, 0, 0, 6000, 1200, 400, null, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 20, 'sh_rogue_fighter', 0, 1100, 900, 0, 3, 0, 1, 250, 8, 1650, 5, 0, 0, 0, 0, 300, 50, 1500, null, 2300, 2, 10, 0, 0, 10, 5, 0, 50, -30, 1, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 30, 'sh_rogue_corvet', 0, 4500, 2600, 0, 32, 0, 3, 200, 15, 1200, 50, 0, 0, 0, 0, 3000, 0, 900, null, 2300, 16, 10, 0, 0, 0, 25, 0, 0, 0, 2, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 40, 'sh_rogue_frigate', 0, 10000, 5000, 0, 100, 0, 7, 450, 26, 550, 50, 0, 0, 0, 0, 200, 250, 330, null, 400, 4, 70, 30, 50, 0, 50, 25, 40, 30, 3, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 50, 'sh_rogue_cruiser', 0, 900000, 800000, 0, 25000, 0, 10, 0, 3400, 750, 25000, 0, 0, 0, 0, 15000, 25000, 470, null, 720, 7, 0, 250, 0, 250, 90, 25, 60, 35, 1, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 60, 'sh_rogue_obliterator', 0, 200000, 200000, 0, 30000, 0, 100, 2000, 800, 600, 30000, 0, 0, 0, 0, 200000, 200000, 450, null, 650, 20, 500, 500, 500, 500, 50, 50, 50, 20, 5, null, null, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO ng03.dt_ships VALUES('cat_sh_rogue', 70, 'sh_rogue_annihilator', 0, 2000000, 1500000, 0, 30000, 0, 1000000, 2000000, 1, 400, 30000, 0, 0, 0, 0, 500000000, 500000000, 200, null, 1500, 200, 5000, 5000, 5000, 5000, 95, 95, 95, 20, 5, null, null, 0, 0, 0, 0, 0, 0, 0, 0);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_building_building_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_building_building_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_building_building_requirements (
    id integer DEFAULT nextval('ng03.dt_building_building_requirements_id_seq'::regclass) NOT NULL,
    building_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    count integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_building_building_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_building_building_requirements_id_seq OWNED BY ng03.dt_building_building_requirements.id;

ALTER TABLE ONLY ng03.dt_building_building_requirements ADD CONSTRAINT dt_building_building_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_building_building_requirements ADD CONSTRAINT dt_building_building_requirements_requirement_id_key UNIQUE (building_id, requirement_id);
ALTER TABLE ONLY ng03.dt_building_building_requirements ADD CONSTRAINT dt_building_building_requirements_building_id_fkey FOREIGN KEY (building_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_building_building_requirements ADD CONSTRAINT dt_building_building_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_building_building_requirements VALUES(1, 'bd_planet_city', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(2, 'bd_planet_city', 'bd_construction_prefab', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(3, 'bd_planet_metropolis', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(4, 'bd_planet_metropolis', 'bd_construction_automate', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(5, 'bd_planet_wonder', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(6, 'bd_planet_cave', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(7, 'bd_planet_cave', 'bd_construction_automate', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(8, 'bd_planet_moon', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(9, 'bd_construction_prefab', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(10, 'bd_construction_automate', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(11, 'bd_construction_synthesis', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(12, 'bd_construction_sandworm', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(13, 'bd_resource_mine', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(14, 'bd_resource_well', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(15, 'bd_resource_manufactory', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(16, 'bd_resource_field', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(17, 'bd_energy_solar_plant', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(18, 'bd_energy_geothermal', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(19, 'bd_energy_nuclear', 'bd_construction_automate', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(20, 'bd_energy_tokamak', 'bd_construction_synthesis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(21, 'bd_energy_rectenna', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(22, 'bd_energy_solar_satellite', 'bd_energy_rectenna', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(23, 'bd_energy_receiving_satellite', 'bd_energy_rectenna', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(24, 'bd_energy_sending_satellite', 'bd_energy_rectenna', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(25, 'bd_energy_sending_satellite', 'bd_construction_synthesis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(26, 'bd_energy_star_belt', 'bd_energy_rectenna', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(27, 'bd_energy_star_panel', 'bd_energy_star_belt', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(28, 'bd_people_laboratory', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(29, 'bd_people_center', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(30, 'bd_people_workshop', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(31, 'bd_people_house', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(32, 'bd_people_barrack', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(33, 'bd_people_base', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(34, 'bd_ore_storage_1', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(35, 'bd_ore_storage_2', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(36, 'bd_ore_storage_3', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(37, 'bd_ore_storage_merchant', 'bd_planet_merchant', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(38, 'bd_hydro_storage_1', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(39, 'bd_hydro_storage_2', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(40, 'bd_hydro_storage_3', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(41, 'bd_hydro_storage_merchant', 'bd_planet_merchant', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(42, 'bd_energy_storage_1', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(43, 'bd_army_light', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(44, 'bd_army_heavy', 'bd_army_light', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(45, 'bd_army_heavy', 'bd_planet_metropolis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(46, 'bd_army_heavy', 'bd_construction_synthesis', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(47, 'bd_space_radar', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(48, 'bd_space_spaceport', 'bd_planet_colony', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(49, 'bd_space_sphipyard', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(50, 'bd_space_satellite', 'bd_planet_city', 1);
INSERT INTO ng03.dt_building_building_requirements VALUES(51, 'bd_space_jammer', 'bd_planet_metropolis', 1);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_building_research_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_building_research_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_building_research_requirements (
    id integer DEFAULT nextval('ng03.dt_building_research_requirements_id_seq'::regclass) NOT NULL,
    building_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    level integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_building_research_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_building_research_requirements_id_seq OWNED BY ng03.dt_building_research_requirements.id;

ALTER TABLE ONLY ng03.dt_building_research_requirements ADD CONSTRAINT dt_building_research_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_building_research_requirements ADD CONSTRAINT dt_building_research_requirements_requirement_id_key UNIQUE (building_id, requirement_id);
ALTER TABLE ONLY ng03.dt_building_research_requirements ADD CONSTRAINT dt_building_research_requirements_building_id_fkey FOREIGN KEY (building_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_building_research_requirements ADD CONSTRAINT dt_building_research_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_building_research_requirements VALUES(1, 'bd_planet_cave', 'rs_science_planetology', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(2, 'bd_planet_moon', 'rs_science_planetology', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(3, 'bd_construction_sandworm', 'rs_science_sandworm', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(4, 'bd_resource_field', 'rs_science_sandworm', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(5, 'bd_energy_geothermal', 'rs_science_study', 2);
INSERT INTO ng03.dt_building_research_requirements VALUES(6, 'bd_energy_nuclear', 'rs_science_nuclear', 2);
INSERT INTO ng03.dt_building_research_requirements VALUES(7, 'bd_energy_tokamak', 'rs_science_nuclear', 3);
INSERT INTO ng03.dt_building_research_requirements VALUES(8, 'bd_energy_tokamak', 'rs_science_plasma', 3);
INSERT INTO ng03.dt_building_research_requirements VALUES(9, 'bd_energy_tokamak', 'rs_science_quantum', 3);
INSERT INTO ng03.dt_building_research_requirements VALUES(10, 'bd_energy_receiving_satellite', 'rs_science_energy_transfer', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(11, 'bd_energy_sending_satellite', 'rs_science_energy_transfer', 1);
INSERT INTO ng03.dt_building_research_requirements VALUES(12, 'bd_energy_star_belt', 'rs_science_nuclear', 3);
INSERT INTO ng03.dt_building_research_requirements VALUES(13, 'bd_energy_star_belt', 'rs_science_plasma', 3);
INSERT INTO ng03.dt_building_research_requirements VALUES(14, 'bd_energy_star_belt', 'rs_science_quantum', 3);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_research_building_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_research_building_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_research_building_requirements (
    id integer DEFAULT nextval('ng03.dt_research_building_requirements_id_seq'::regclass) NOT NULL,
    research_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    count integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_research_building_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_research_building_requirements_id_seq OWNED BY ng03.dt_research_building_requirements.id;

ALTER TABLE ONLY ng03.dt_research_building_requirements ADD CONSTRAINT dt_research_building_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_research_building_requirements ADD CONSTRAINT dt_research_building_requirements_requirement_id_key UNIQUE (research_id, requirement_id);
ALTER TABLE ONLY ng03.dt_research_building_requirements ADD CONSTRAINT dt_research_building_requirements_research_id_fkey FOREIGN KEY (research_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_research_building_requirements ADD CONSTRAINT dt_research_building_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_research_building_requirements VALUES(1, 'rs_technology_jumpdrive', 'bd_people_center', 3);
INSERT INTO ng03.dt_research_building_requirements VALUES(2, 'rs_science_planetology', 'bd_people_center', 5);
INSERT INTO ng03.dt_research_building_requirements VALUES(3, 'rs_science_sandworm', 'bd_planet_sandworm', 1);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_research_research_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_research_research_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_research_research_requirements (
    id integer DEFAULT nextval('ng03.dt_research_research_requirements_id_seq'::regclass) NOT NULL,
    research_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    level integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_research_research_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_research_research_requirements_id_seq OWNED BY ng03.dt_research_research_requirements.id;

ALTER TABLE ONLY ng03.dt_research_research_requirements ADD CONSTRAINT dt_research_research_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_research_research_requirements ADD CONSTRAINT dt_research_research_requirements_requirement_id_key UNIQUE (research_id, requirement_id);
ALTER TABLE ONLY ng03.dt_research_research_requirements ADD CONSTRAINT dt_research_research_requirements_research_id_fkey FOREIGN KEY (research_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_research_research_requirements ADD CONSTRAINT dt_research_research_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_research_research_requirements VALUES(1, 'rs_booster_propulsion', 'rs_technology_propulsion', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(2, 'rs_booster_shield', 'rs_weapon_shield', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(3, 'rs_booster_damage', 'rs_weapon_army', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(4, 'rs_booster_damage', 'rs_science_plasma', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(5, 'rs_technology_energy', 'rs_technology_propulsion', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(6, 'rs_technology_jumpdrive', 'rs_science_quantum', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(7, 'rs_technology_deployment', 'rs_orientation_scientist', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(8, 'rs_technology_deployment', 'rs_ship_util', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(9, 'rs_production_massive', 'rs_production_industry', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(10, 'rs_production_mining', 'rs_production_industry', 2);
INSERT INTO ng03.dt_research_research_requirements VALUES(11, 'rs_production_mining_improved', 'rs_production_industry', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(12, 'rs_production_mining_improved', 'rs_production_mining', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(13, 'rs_production_refining', 'rs_production_industry', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(14, 'rs_production_refining_improved', 'rs_production_industry', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(15, 'rs_production_refining_improved', 'rs_production_refining', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(16, 'rs_science_nuclear', 'rs_science_study', 2);
INSERT INTO ng03.dt_research_research_requirements VALUES(17, 'rs_science_plasma', 'rs_science_study', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(18, 'rs_science_plasma', 'rs_science_nuclear', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(19, 'rs_science_quantum', 'rs_science_study', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(20, 'rs_science_planetology', 'rs_science_study', 4);
INSERT INTO ng03.dt_research_research_requirements VALUES(21, 'rs_science_energy_transfer', 'rs_technology_propulsion', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(22, 'rs_science_energy_transfer_improved', 'rs_science_energy_transfer', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(23, 'rs_weapon_army', 'rs_ship_mechanic', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(24, 'rs_weapon_rocket', 'rs_weapon_army', 2);
INSERT INTO ng03.dt_research_research_requirements VALUES(25, 'rs_weapon_missile', 'rs_weapon_army', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(26, 'rs_weapon_missile', 'rs_weapon_rocket', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(27, 'rs_weapon_turret', 'rs_weapon_army', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(28, 'rs_weapon_railgun', 'rs_weapon_army', 4);
INSERT INTO ng03.dt_research_research_requirements VALUES(29, 'rs_weapon_ion', 'rs_weapon_army', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(30, 'rs_weapon_ion', 'rs_science_plasma', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(31, 'rs_weapon_shield', 'rs_technology_energy', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(32, 'rs_ship_util', 'rs_ship_mechanic', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(33, 'rs_ship_tactic', 'rs_ship_util', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(34, 'rs_ship_tactic', 'rs_ship_mechanic', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(35, 'rs_ship_light', 'rs_ship_mechanic', 2);
INSERT INTO ng03.dt_research_research_requirements VALUES(36, 'rs_ship_corvet', 'rs_ship_mechanic', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(37, 'rs_ship_corvet', 'rs_technology_energy', 1);
INSERT INTO ng03.dt_research_research_requirements VALUES(38, 'rs_ship_frigate', 'rs_ship_mechanic', 4);
INSERT INTO ng03.dt_research_research_requirements VALUES(39, 'rs_ship_frigate', 'rs_technology_energy', 3);
INSERT INTO ng03.dt_research_research_requirements VALUES(40, 'rs_ship_cruiser', 'rs_ship_mechanic', 5);
INSERT INTO ng03.dt_research_research_requirements VALUES(41, 'rs_ship_cruiser', 'rs_technology_energy', 4);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_ship_building_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_ship_building_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_ship_building_requirements (
    id integer DEFAULT nextval('ng03.dt_ship_building_requirements_id_seq'::regclass) NOT NULL,
    ship_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    count integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_ship_building_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_ship_building_requirements_id_seq OWNED BY ng03.dt_ship_building_requirements.id;

ALTER TABLE ONLY ng03.dt_ship_building_requirements ADD CONSTRAINT dt_ship_building_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_ship_building_requirements ADD CONSTRAINT dt_ship_building_requirements_requirement_id_key UNIQUE (ship_id, requirement_id);
ALTER TABLE ONLY ng03.dt_ship_building_requirements ADD CONSTRAINT dt_ship_building_requirements_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_ship_building_requirements ADD CONSTRAINT dt_ship_building_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_ship_building_requirements VALUES(1, 'sh_cargo_1', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(2, 'sh_cargo_2', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(3, 'sh_cargo_3', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(4, 'sh_cargo_caravel', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(5, 'sh_util_probe', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(6, 'sh_util_recycler', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(7, 'sh_util_jumper', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(8, 'sh_util_droppods', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(9, 'sh_deployment_colony', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(10, 'sh_deployment_prefab', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(11, 'sh_deployment_automate', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(12, 'sh_deployment_synthesis', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(13, 'sh_deployment_geothermal', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(14, 'sh_deployment_laboratory', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(15, 'sh_deployment_center', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(16, 'sh_deployment_workshop', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(17, 'sh_deployment_barrack', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(18, 'sh_deployment_ore_storage_1', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(19, 'sh_deployment_ore_storage_2', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(20, 'sh_deployment_hydro_storage_1', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(21, 'sh_deployment_hydro_storage_2', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(22, 'sh_deployment_vortex_medium', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(23, 'sh_deployment_vortex_large', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(24, 'sh_deployment_vortex_killer', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(25, 'sh_tactic_radar', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(26, 'sh_tactic_jammer', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(27, 'sh_tactic_battle', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(28, 'sh_tactic_logistic', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(29, 'sh_fighter_light', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(30, 'sh_fighter_heavy', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(31, 'sh_fighter_elite', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(32, 'sh_corvet_light', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(33, 'sh_corvet_light', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(34, 'sh_corvet_heavy', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(35, 'sh_corvet_heavy', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(36, 'sh_corvet_multigun', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(37, 'sh_corvet_multigun', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(38, 'sh_corvet_elite', 'bd_space_spaceport', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(39, 'sh_corvet_elite', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(40, 'sh_frigate_light', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(41, 'sh_frigate_light', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(42, 'sh_frigate_heavy', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(43, 'sh_frigate_heavy', 'bd_army_heavy', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(44, 'sh_frigate_elite', 'bd_army_light', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(45, 'sh_frigate_elite', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(46, 'sh_cruiser_light', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(47, 'sh_cruiser_light', 'bd_army_heavy', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(48, 'sh_cruiser_heavy', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(49, 'sh_cruiser_heavy', 'bd_army_heavy', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(50, 'sh_cruiser_elite', 'bd_space_sphipyard', 1);
INSERT INTO ng03.dt_ship_building_requirements VALUES(51, 'sh_cruiser_elite', 'bd_army_heavy', 1);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.dt_ship_research_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.dt_ship_research_requirements_id_seq OWNER TO exileng;

CREATE TABLE ng03.dt_ship_research_requirements (
    id integer DEFAULT nextval('ng03.dt_ship_research_requirements_id_seq'::regclass) NOT NULL,
    ship_id character varying NOT NULL,
    requirement_id character varying NOT NULL,
    level integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.dt_ship_research_requirements OWNER TO exileng;

ALTER SEQUENCE ng03.dt_ship_research_requirements_id_seq OWNED BY ng03.dt_ship_research_requirements.id;

ALTER TABLE ONLY ng03.dt_ship_research_requirements ADD CONSTRAINT dt_ship_research_requirements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.dt_ship_research_requirements ADD CONSTRAINT dt_ship_research_requirements_requirement_id_key UNIQUE (ship_id, requirement_id);
ALTER TABLE ONLY ng03.dt_ship_research_requirements ADD CONSTRAINT dt_ship_research_requirements_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.dt_ship_research_requirements ADD CONSTRAINT dt_ship_research_requirements_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;

INSERT INTO ng03.dt_ship_research_requirements VALUES(1, 'sh_cargo_1', 'rs_ship_util', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(2, 'sh_cargo_2', 'rs_ship_util', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(3, 'sh_cargo_3', 'rs_ship_util', 5);
INSERT INTO ng03.dt_ship_research_requirements VALUES(4, 'sh_cargo_caravel', 'rs_orientation_merchant', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(5, 'sh_cargo_caravel', 'rs_ship_util', 5);
INSERT INTO ng03.dt_ship_research_requirements VALUES(6, 'sh_util_probe', 'rs_ship_mechanic', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(7, 'sh_util_recycler', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(8, 'sh_util_jumper', 'rs_ship_util', 5);
INSERT INTO ng03.dt_ship_research_requirements VALUES(9, 'sh_util_jumper', 'rs_technology_jumpdrive', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(10, 'sh_util_droppods', 'rs_ship_util', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(11, 'sh_deployment_colony', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(12, 'sh_deployment_prefab', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(13, 'sh_deployment_prefab', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(14, 'sh_deployment_automate', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(15, 'sh_deployment_automate', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(16, 'sh_deployment_synthesis', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(17, 'sh_deployment_synthesis', 'rs_ship_util', 5);
INSERT INTO ng03.dt_ship_research_requirements VALUES(18, 'sh_deployment_geothermal', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(19, 'sh_deployment_geothermal', 'rs_science_study', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(20, 'sh_deployment_geothermal', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(21, 'sh_deployment_laboratory', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(22, 'sh_deployment_laboratory', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(23, 'sh_deployment_center', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(24, 'sh_deployment_center', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(25, 'sh_deployment_workshop', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(26, 'sh_deployment_workshop', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(27, 'sh_deployment_barrack', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(28, 'sh_deployment_barrack', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(29, 'sh_deployment_ore_storage_1', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(30, 'sh_deployment_ore_storage_1', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(31, 'sh_deployment_ore_storage_2', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(32, 'sh_deployment_ore_storage_2', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(33, 'sh_deployment_hydro_storage_1', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(34, 'sh_deployment_hydro_storage_1', 'rs_ship_util', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(35, 'sh_deployment_hydro_storage_2', 'rs_technology_deployment', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(36, 'sh_deployment_hydro_storage_2', 'rs_ship_util', 4);
INSERT INTO ng03.dt_ship_research_requirements VALUES(37, 'sh_deployment_vortex_medium', 'rs_technology_jumpdrive', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(38, 'sh_deployment_vortex_medium', 'rs_ship_tactic', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(39, 'sh_deployment_vortex_large', 'rs_orientation_soldier', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(40, 'sh_deployment_vortex_large', 'rs_technology_jumpdrive', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(41, 'sh_deployment_vortex_large', 'rs_ship_tactic', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(42, 'sh_deployment_vortex_killer', 'rs_orientation_scientist', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(43, 'sh_deployment_vortex_killer', 'rs_technology_jumpdrive', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(44, 'sh_deployment_vortex_killer', 'rs_ship_tactic', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(45, 'sh_tactic_radar', 'rs_ship_tactic', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(46, 'sh_tactic_jammer', 'rs_ship_tactic', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(47, 'sh_tactic_battle', 'rs_ship_tactic', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(48, 'sh_tactic_logistic', 'rs_technology_jumpdrive', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(49, 'sh_tactic_logistic', 'rs_ship_tactic', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(50, 'sh_fighter_light', 'rs_weapon_army', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(51, 'sh_fighter_light', 'rs_ship_light', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(52, 'sh_fighter_heavy', 'rs_weapon_army', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(53, 'sh_fighter_heavy', 'rs_ship_light', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(54, 'sh_fighter_elite', 'rs_weapon_army', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(55, 'sh_fighter_elite', 'rs_ship_light', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(56, 'sh_corvet_light', 'rs_weapon_turret', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(57, 'sh_corvet_light', 'rs_ship_corvet', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(58, 'sh_corvet_heavy', 'rs_weapon_rocket', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(59, 'sh_corvet_heavy', 'rs_ship_corvet', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(60, 'sh_corvet_multigun', 'rs_weapon_turret', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(61, 'sh_corvet_multigun', 'rs_ship_corvet', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(62, 'sh_corvet_elite', 'rs_weapon_turret', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(63, 'sh_corvet_elite', 'rs_ship_corvet', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(64, 'sh_frigate_light', 'rs_weapon_railgun', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(65, 'sh_frigate_light', 'rs_ship_frigate', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(66, 'sh_frigate_heavy', 'rs_weapon_ion', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(67, 'sh_frigate_heavy', 'rs_ship_frigate', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(68, 'sh_frigate_elite', 'rs_weapon_missile', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(69, 'sh_frigate_elite', 'rs_ship_frigate', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(70, 'sh_cruiser_light', 'rs_weapon_railgun', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(71, 'sh_cruiser_light', 'rs_ship_cruiser', 1);
INSERT INTO ng03.dt_ship_research_requirements VALUES(72, 'sh_cruiser_heavy', 'rs_weapon_railgun', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(73, 'sh_cruiser_heavy', 'rs_ship_cruiser', 2);
INSERT INTO ng03.dt_ship_research_requirements VALUES(74, 'sh_cruiser_elite', 'rs_weapon_railgun', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(75, 'sh_cruiser_elite', 'rs_ship_cruiser', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(76, 'sh_dreadnought', 'rs_weapon_railgun', 3);
INSERT INTO ng03.dt_ship_research_requirements VALUES(77, 'sh_dreadnought', 'rs_ship_cruiser', 3);

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_commander_firstnames (
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_commander_firstnames OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_commander_firstnames ADD CONSTRAINT dt_commander_firstnames_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_commander_firstnames VALUES('Alia');
INSERT INTO ng03.dt_commander_firstnames VALUES('Leto');
INSERT INTO ng03.dt_commander_firstnames VALUES('Siona');
INSERT INTO ng03.dt_commander_firstnames VALUES('Gurney');
INSERT INTO ng03.dt_commander_firstnames VALUES('Vladimir');
INSERT INTO ng03.dt_commander_firstnames VALUES('Darwi');
INSERT INTO ng03.dt_commander_firstnames VALUES('Duncan');
INSERT INTO ng03.dt_commander_firstnames VALUES('Paul');
INSERT INTO ng03.dt_commander_firstnames VALUES('Ben');
INSERT INTO ng03.dt_commander_firstnames VALUES('Jacen');
INSERT INTO ng03.dt_commander_firstnames VALUES('Maximus');
INSERT INTO ng03.dt_commander_firstnames VALUES('Yan');
INSERT INTO ng03.dt_commander_firstnames VALUES('John');
INSERT INTO ng03.dt_commander_firstnames VALUES('Alexandre');
INSERT INTO ng03.dt_commander_firstnames VALUES('Charles');
INSERT INTO ng03.dt_commander_firstnames VALUES('Robert');
INSERT INTO ng03.dt_commander_firstnames VALUES('Pavel');
INSERT INTO ng03.dt_commander_firstnames VALUES('Travis');
INSERT INTO ng03.dt_commander_firstnames VALUES('Leonard');
INSERT INTO ng03.dt_commander_firstnames VALUES('Tina');
INSERT INTO ng03.dt_commander_firstnames VALUES('Kira');
INSERT INTO ng03.dt_commander_firstnames VALUES('Janice');
INSERT INTO ng03.dt_commander_firstnames VALUES('Alfred');
INSERT INTO ng03.dt_commander_firstnames VALUES('Marcus');
INSERT INTO ng03.dt_commander_firstnames VALUES('Thomas');
INSERT INTO ng03.dt_commander_firstnames VALUES('Oliver');
INSERT INTO ng03.dt_commander_firstnames VALUES('Douglas');
INSERT INTO ng03.dt_commander_firstnames VALUES('Conrad');
INSERT INTO ng03.dt_commander_firstnames VALUES('Jane');
INSERT INTO ng03.dt_commander_firstnames VALUES('James');
INSERT INTO ng03.dt_commander_firstnames VALUES('Frank');
INSERT INTO ng03.dt_commander_firstnames VALUES('Arthur');
INSERT INTO ng03.dt_commander_firstnames VALUES('Richard');
INSERT INTO ng03.dt_commander_firstnames VALUES('Steve');
INSERT INTO ng03.dt_commander_firstnames VALUES('Julian');
INSERT INTO ng03.dt_commander_firstnames VALUES('Dave');
INSERT INTO ng03.dt_commander_firstnames VALUES('William');
INSERT INTO ng03.dt_commander_firstnames VALUES('Walter');
INSERT INTO ng03.dt_commander_firstnames VALUES('Eric');
INSERT INTO ng03.dt_commander_firstnames VALUES('Tony');
INSERT INTO ng03.dt_commander_firstnames VALUES('Peter');
INSERT INTO ng03.dt_commander_firstnames VALUES('Max');
INSERT INTO ng03.dt_commander_firstnames VALUES('Martin');
INSERT INTO ng03.dt_commander_firstnames VALUES('David');
INSERT INTO ng03.dt_commander_firstnames VALUES('Leo');
INSERT INTO ng03.dt_commander_firstnames VALUES('Howard');
INSERT INTO ng03.dt_commander_firstnames VALUES('Julius');
INSERT INTO ng03.dt_commander_firstnames VALUES('Chris');
INSERT INTO ng03.dt_commander_firstnames VALUES('Cyril');
INSERT INTO ng03.dt_commander_firstnames VALUES('Anne');
INSERT INTO ng03.dt_commander_firstnames VALUES('Anke');
INSERT INTO ng03.dt_commander_firstnames VALUES('Alberto');
INSERT INTO ng03.dt_commander_firstnames VALUES('Nicolas');
INSERT INTO ng03.dt_commander_firstnames VALUES('Arkan');
INSERT INTO ng03.dt_commander_firstnames VALUES('André');
INSERT INTO ng03.dt_commander_firstnames VALUES('Mike');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_commander_lastnames (
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_commander_lastnames OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_commander_lastnames ADD CONSTRAINT dt_commander_lastnames_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_commander_lastnames VALUES('Burnett');
INSERT INTO ng03.dt_commander_lastnames VALUES('Adams');
INSERT INTO ng03.dt_commander_lastnames VALUES('Leary');
INSERT INTO ng03.dt_commander_lastnames VALUES('Page');
INSERT INTO ng03.dt_commander_lastnames VALUES('Keats');
INSERT INTO ng03.dt_commander_lastnames VALUES('Keller');
INSERT INTO ng03.dt_commander_lastnames VALUES('Anderson');
INSERT INTO ng03.dt_commander_lastnames VALUES('Aicard');
INSERT INTO ng03.dt_commander_lastnames VALUES('Allen');
INSERT INTO ng03.dt_commander_lastnames VALUES('Atwood');
INSERT INTO ng03.dt_commander_lastnames VALUES('Augustus');
INSERT INTO ng03.dt_commander_lastnames VALUES('Estrada');
INSERT INTO ng03.dt_commander_lastnames VALUES('Eckhart');
INSERT INTO ng03.dt_commander_lastnames VALUES('Hebey');
INSERT INTO ng03.dt_commander_lastnames VALUES('Huxley');
INSERT INTO ng03.dt_commander_lastnames VALUES('Harris');
INSERT INTO ng03.dt_commander_lastnames VALUES('Hnin Yu');
INSERT INTO ng03.dt_commander_lastnames VALUES('Muller');
INSERT INTO ng03.dt_commander_lastnames VALUES('Moore');
INSERT INTO ng03.dt_commander_lastnames VALUES('Monroe');
INSERT INTO ng03.dt_commander_lastnames VALUES('Orban');
INSERT INTO ng03.dt_commander_lastnames VALUES('Orwell');
INSERT INTO ng03.dt_commander_lastnames VALUES('Thompson');
INSERT INTO ng03.dt_commander_lastnames VALUES('Carr');
INSERT INTO ng03.dt_commander_lastnames VALUES('Chen');
INSERT INTO ng03.dt_commander_lastnames VALUES('Claudius');
INSERT INTO ng03.dt_commander_lastnames VALUES('Gambetta');
INSERT INTO ng03.dt_commander_lastnames VALUES('Grant');
INSERT INTO ng03.dt_commander_lastnames VALUES('Newton');
INSERT INTO ng03.dt_commander_lastnames VALUES('Nietzsche');
INSERT INTO ng03.dt_commander_lastnames VALUES('Nerval');
INSERT INTO ng03.dt_commander_lastnames VALUES('Bonaparte');
INSERT INTO ng03.dt_commander_lastnames VALUES('Nin');
INSERT INTO ng03.dt_commander_lastnames VALUES('Neumann');
INSERT INTO ng03.dt_commander_lastnames VALUES('Rolland');
INSERT INTO ng03.dt_commander_lastnames VALUES('Rousseau');
INSERT INTO ng03.dt_commander_lastnames VALUES('Rostand');
INSERT INTO ng03.dt_commander_lastnames VALUES('Russel');
INSERT INTO ng03.dt_commander_lastnames VALUES('Ruskin');
INSERT INTO ng03.dt_commander_lastnames VALUES('Surcouffe');
INSERT INTO ng03.dt_commander_lastnames VALUES('Shepard');
INSERT INTO ng03.dt_commander_lastnames VALUES('Sheen');
INSERT INTO ng03.dt_commander_lastnames VALUES('Smith');
INSERT INTO ng03.dt_commander_lastnames VALUES('Doe');
INSERT INTO ng03.dt_commander_lastnames VALUES('Sterne');
INSERT INTO ng03.dt_commander_lastnames VALUES('Stuart');
INSERT INTO ng03.dt_commander_lastnames VALUES('Swift');
INSERT INTO ng03.dt_commander_lastnames VALUES('Scott');
INSERT INTO ng03.dt_commander_lastnames VALUES('Falcon');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wartburg');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wesley');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wiesel');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wolfe');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wei');
INSERT INTO ng03.dt_commander_lastnames VALUES('Wellington');
INSERT INTO ng03.dt_commander_lastnames VALUES('Mairet');
INSERT INTO ng03.dt_commander_lastnames VALUES('Riker');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_mails (
    id character varying NOT NULL,
    sender_name character varying
);

ALTER TABLE ng03.dt_mails OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_mails ADD CONSTRAINT dt_mails_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_mails VALUES('ml_new_planet', null);
INSERT INTO ng03.dt_mails VALUES('ml_research', null);
INSERT INTO ng03.dt_mails VALUES('ml_first_ship', null);
INSERT INTO ng03.dt_mails VALUES('ml_first_colonizer', null);
INSERT INTO ng03.dt_mails VALUES('ml_contract_ending', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES('ml_contract_starting', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES('ml_lotery_starting', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES('ml_lotery_winning', 'Guilde Marchande');
INSERT INTO ng03.dt_mails VALUES('ml_lotery_failing', 'Guilde Marchande');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_orientations (
    id character varying NOT NULL
);

ALTER TABLE ng03.dt_orientations OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_orientations ADD CONSTRAINT dt_orientations_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_orientations VALUES('or_scientist');
INSERT INTO ng03.dt_orientations VALUES('or_soldier');
INSERT INTO ng03.dt_orientations VALUES('or_merchant');

--------------------------------------------------------------------------------

CREATE TABLE ng03.dt_processes (
    id character varying NOT NULL,
    frequency interval NOT NULL,
    last_rundate timestamp with time zone,
    last_result character varying
);

ALTER TABLE ng03.dt_processes OWNER TO exileng;

ALTER TABLE ONLY ng03.dt_processes ADD CONSTRAINT dt_processes_pkey PRIMARY KEY (id);

INSERT INTO ng03.dt_processes VALUES('process_alliance_nap_breakings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_alliance_tributes()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_alliance_war_billings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_alliance_war_ceasings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_commander_generations()', '00:30:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_commander_promotions()', '00:30:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_fleet_delay_generation()', '00:10:30', null, null);
INSERT INTO ng03.dt_processes VALUES('process_fleet_recyclings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_fleet_travels()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_fleet_waitings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_annihilation_fleets_generation()', '00:30:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_lost_nation_leavings()', '00:11:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_merchant_fleets_cleaning()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_merchant_unloading()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_resource_prices_updating()', '01:00:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_resource_spawnings()', '00:19:10', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_resource_spawns_updating()', '00:01:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_rogue_fleets_generation()', '01:30:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_galaxy_rogue_planets()', '01:00:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_bonus_generation()', '00:10:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_building_destructions()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_building_pendings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_laboratory_accidents_generation()', '00:10:20', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_magnetic_storm_generation()', '00:10:40', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_productions()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_riot_generation()', '00:10:50', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_robbery_generation()', '00:10:10', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_sandworm_attack_generation()', '00:11:10', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_seism_generation()', '00:10:40', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_ship_pendings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_trainings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_planet_watching()', '00:10:40', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_alliance_leaving()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_booster_market_generation()', '24:00:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_bounties()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_credit_production()', '00:01:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_deletion()', '00:01:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_holidays_ending()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_holidays_starting()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_market_purchases()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_market_sales()', '00:00:05', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_research_pendings()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_profile_score_updating()', '00:00:01', null, null);
INSERT INTO ng03.dt_processes VALUES('process_server_alliance_cleaning()', '00:01:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_server_cleaning()', '24:00:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_server_fleet_route_cleaning()', '00:05:00', null, null);
INSERT INTO ng03.dt_processes VALUES('process_server_lottery()', '168:00:00', null, null);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliances_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliances (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliances_id_seq'::regclass) NOT NULL,
    chat_id integer NOT NULL,
    tag character varying(4) NOT NULL,
    name character varying NOT NULL,
    description text,
    logo_url character varying,
    announce text,
    member_max integer DEFAULT 30 NOT NULL,
    tax real DEFAULT 0 NOT NULL,
    credit_count integer DEFAULT 0 NOT NULL,
    previous_score integer DEFAULT 0 NOT NULL,
    defcon smallint DEFAULT 5 NOT NULL,
    last_kick_date timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ng03.gm_alliances OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliances_id_seq OWNED BY ng03.gm_alliances.id;

ALTER TABLE ONLY ng03.gm_alliances ADD CONSTRAINT gm_alliances_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliances ADD CONSTRAINT gm_alliances_tag_key UNIQUE (tag);
ALTER TABLE ONLY ng03.gm_alliances ADD CONSTRAINT gm_alliances_name_key UNIQUE (name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_invitations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_invitations_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_invitations (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_invitations_id_seq'::regclass) NOT NULL,
    alliance_id integer NOT NULL,
    profile_id integer NOT NULL
);

ALTER TABLE ng03.gm_alliance_invitations OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_invitations_id_seq OWNED BY ng03.gm_alliance_invitations.id;

ALTER TABLE ONLY ng03.gm_alliance_invitations ADD CONSTRAINT gm_alliance_invitations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_invitations ADD CONSTRAINT gm_alliance_invitations_profile_id_key UNIQUE (alliance_id, profile_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_nap_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_nap_requests_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_nap_requests (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_nap_requests_id_seq'::regclass) NOT NULL,
    alliance_id_1 integer NOT NULL,
    alliance_id_2 integer NOT NULL,
    guarantee integer DEFAULT 0 NOT NULL,
    breaking_delay interval DEFAULT '24:00:00'::interval NOT NULL
);

ALTER TABLE ng03.gm_alliance_nap_requests OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_nap_requests_id_seq OWNED BY ng03.gm_alliance_nap_requests.id;

ALTER TABLE ONLY ng03.gm_alliance_nap_requests ADD CONSTRAINT gm_alliance_nap_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_nap_requests ADD CONSTRAINT gm_alliance_nap_requests_alliance_id_2_key UNIQUE (alliance_id_1, alliance_id_2);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_naps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_naps_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_naps (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_naps_id_seq'::regclass) NOT NULL,
    alliance_id_1 integer NOT NULL,
    alliance_id_2 integer NOT NULL,
    guarantee integer DEFAULT 0 NOT NULL,
    breaking_delay interval DEFAULT '24:00:00'::interval NOT NULL,
    breaking_date timestamp without time zone,
    sharing_location boolean DEFAULT true NOT NULL,
    sharing_radar boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_alliance_naps OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_naps_id_seq OWNED BY ng03.gm_alliance_naps.id;

ALTER TABLE ONLY ng03.gm_alliance_naps ADD CONSTRAINT gm_alliance_naps_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_naps ADD CONSTRAINT gm_alliance_naps_alliance_id_2_key UNIQUE (alliance_id_1, alliance_id_2);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_ranks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_ranks_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_ranks (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_ranks_id_seq'::regclass) NOT NULL,
    alliance_id integer NOT NULL,
    name character varying NOT NULL,
    is_leader boolean DEFAULT false NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_displayed boolean DEFAULT false NOT NULL,
    can_invite boolean DEFAULT false NOT NULL,
    can_kick boolean DEFAULT false NOT NULL,
    can_create_nap boolean DEFAULT false NOT NULL,
    can_break_nap boolean DEFAULT false NOT NULL,
    can_see_reports boolean DEFAULT false NOT NULL,
    can_request boolean DEFAULT false NOT NULL,
    can_accept_requests boolean DEFAULT false NOT NULL,
    can_set_tax boolean DEFAULT false NOT NULL,
    can_mail_alliance boolean DEFAULT false NOT NULL,
    can_manage_description boolean DEFAULT false NOT NULL,
    can_manage_announce boolean DEFAULT false NOT NULL,
    can_see_members boolean DEFAULT false NOT NULL,
    can_manage_fleets boolean DEFAULT false NOT NULL,
    can_use_radars boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_alliance_ranks OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_ranks_id_seq OWNED BY ng03.gm_alliance_ranks.id;

ALTER TABLE ONLY ng03.gm_alliance_ranks ADD CONSTRAINT gm_alliance_ranks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_ranks ADD CONSTRAINT gm_alliance_ranks_name_key UNIQUE (alliance_id, name);
ALTER TABLE ONLY ng03.gm_alliance_ranks ADD CONSTRAINT gm_alliance_ranks_is_leader_key UNIQUE (alliance_id, is_leader);
ALTER TABLE ONLY ng03.gm_alliance_ranks ADD CONSTRAINT gm_alliance_ranks_is_default_key UNIQUE (alliance_id, is_default);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_reports_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_reports (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_reports_id_seq'::regclass) NOT NULL,
    alliance_id integer NOT NULL,
    type smallint NOT NULL,
    data character varying DEFAULT '{}'::character varying NOT NULL
);

ALTER TABLE ng03.gm_alliance_reports OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_reports_id_seq OWNED BY ng03.gm_alliance_reports.id;

ALTER TABLE ONLY ng03.gm_alliance_reports ADD CONSTRAINT gm_alliance_reportspkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_tributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_tributes_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_tributes (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_tributes_id_seq'::regclass) NOT NULL,
    alliance_id_1 integer NOT NULL,
    alliance_id_2 integer NOT NULL,
    credit_count integer NOT NULL
);

ALTER TABLE ng03.gm_alliance_tributes OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_tributes_id_seq OWNED BY ng03.gm_alliance_tributes.id;

ALTER TABLE ONLY ng03.gm_alliance_tributes ADD CONSTRAINT gm_alliance_tributes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_tributes ADD CONSTRAINT gm_alliance_tributes_alliance_id_2_key UNIQUE (alliance_id_1, alliance_id_2);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_wallet_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_wallet_logs_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_wallet_logs (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_wallet_logs_id_seq'::regclass) NOT NULL,
    alliance_id integer NOT NULL,
    type smallint NOT NULL,
    data character varying DEFAULT '{}'::character varying NOT NULL
);

ALTER TABLE ng03.gm_alliance_wallet_logs OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_wallet_logs_id_seq OWNED BY ng03.gm_alliance_wallet_logs.id;

ALTER TABLE ONLY ng03.gm_alliance_wallet_logs ADD CONSTRAINT gm_alliance_wallet_logs_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_wallet_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_wallet_requests_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_wallet_requests (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_wallet_requests_id_seq'::regclass) NOT NULL,
    alliance_id integer NOT NULL,
    profile_id integer NOT NULL,
    credit_count integer NOT NULL,
    description character varying NOT NULL
);

ALTER TABLE ng03.gm_alliance_wallet_requests OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_wallet_requests_id_seq OWNED BY ng03.gm_alliance_wallet_requests.id;

ALTER TABLE ONLY ng03.gm_alliance_wallet_requests ADD CONSTRAINT gm_alliance_wallet_requests_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_wallet_requests ADD CONSTRAINT gm_alliance_wallet_requests_profile_id_key UNIQUE (alliance_id, profile_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_alliance_wars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_alliance_wars_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_alliance_wars (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_alliance_wars_id_seq'::regclass) NOT NULL,
    alliance_id_1 integer NOT NULL,
    alliance_id_2 integer NOT NULL,
    starting_date timestamp with time zone DEFAULT (now() + '24:00:00'::interval) NOT NULL,
    ending_date timestamp with time zone,
    payment_date timestamp with time zone DEFAULT now(),
    cease_fire boolean DEFAULT false
);

ALTER TABLE ng03.gm_alliance_wars OWNER TO exileng;

ALTER SEQUENCE ng03.gm_alliance_wars_id_seq OWNED BY ng03.gm_alliance_wars.id;

ALTER TABLE ONLY ng03.gm_alliance_wars ADD CONSTRAINT gm_alliance_wars_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_alliance_wars ADD CONSTRAINT gm_alliance_wars_alliance_id_2_key UNIQUE (alliance_id_1, alliance_id_2);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_battles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_battles_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_battles (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_battles_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    round_count smallint DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.gm_battles OWNER TO exileng;

ALTER SEQUENCE ng03.gm_battles_id_seq OWNED BY ng03.gm_battles.id;

ALTER TABLE ONLY ng03.gm_battles ADD CONSTRAINT gm_battles_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_battle_fleets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_battle_fleets_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_battle_fleets (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_battle_fleets_id_seq'::regclass) NOT NULL,
    battle_id integer NOT NULL,
    alliance_tag character varying,
    profile_name character varying NOT NULL,
    fleet_name character varying NOT NULL,
    stance boolean DEFAULT true NOT NULL,
    mod_shield smallint DEFAULT 0 NOT NULL,
    mod_handling smallint DEFAULT 0 NOT NULL,
    mod_tracking smallint DEFAULT 0 NOT NULL,
    mod_damage smallint DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_battle_fleets OWNER TO exileng;

ALTER SEQUENCE ng03.gm_battle_fleets_id_seq OWNED BY ng03.gm_battle_fleets.id;

ALTER TABLE ONLY ng03.gm_battle_fleets ADD CONSTRAINT gm_battle_fleets_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_battle_fleet_ships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_battle_fleet_ships_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_battle_fleet_ships (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_battle_fleet_ships_id_seq'::regclass) NOT NULL,
    battle_fleet_id integer NOT NULL,
    ship_id character varying NOT NULL,
    before integer DEFAULT 0 NOT NULL,
    after integer DEFAULT 0 NOT NULL,
    killed integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_battle_fleet_ships OWNER TO exileng;

ALTER SEQUENCE ng03.gm_battle_fleet_ships_id_seq OWNED BY ng03.gm_battle_fleet_ships.id;

ALTER TABLE ONLY ng03.gm_battle_fleet_ships ADD CONSTRAINT gm_battle_fleet_ships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_battle_fleet_ships ADD CONSTRAINT gm_battle_fleet_ships_ship_id_key UNIQUE (battle_fleet_id, ship_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_battle_fleet_ship_kills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_battle_fleet_ship_kills_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_battle_fleet_ship_kills (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_battle_fleet_ship_kills_id_seq'::regclass) NOT NULL,
    battle_fleet_ship_id integer NOT NULL,
    ship_id character varying NOT NULL,
    count integer NOT NULL
);

ALTER TABLE ng03.gm_battle_fleet_ship_kills OWNER TO exileng;

ALTER SEQUENCE ng03.gm_battle_fleet_ship_kills_id_seq OWNED BY ng03.gm_battle_fleet_ship_kills.id;

ALTER TABLE ONLY ng03.gm_battle_fleet_ship_kills ADD CONSTRAINT gm_battle_fleet_ship_kills_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_battle_fleet_ship_kills ADD CONSTRAINT gm_battle_fleet_ship_kills_ship_id_key UNIQUE (battle_fleet_ship_id, ship_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_chats_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_chats (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_chats_id_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    password character varying
);

ALTER TABLE ng03.gm_chats OWNER TO exileng;

ALTER SEQUENCE ng03.gm_chats_id_seq OWNED BY ng03.gm_chats.id;

ALTER TABLE ONLY ng03.gm_chats ADD CONSTRAINT gm_chats_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_chats ADD CONSTRAINT gm_chats_password_key UNIQUE (name, password);

INSERT INTO ng03.gm_chats(created_by, id, name) VALUES('system', 1, 'Nouveaux joueurs');
INSERT INTO ng03.gm_chats(created_by, id, name) VALUES('system', 2, 'Exile');

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_chat_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_chat_messages_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_chat_messages (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_chat_messages_id_seq'::regclass) NOT NULL,
    chat_id integer NOT NULL,
    profile_name character varying NOT NULL,
    message character varying(512) NOT NULL
);

ALTER TABLE ng03.gm_chat_messages OWNER TO exileng;

ALTER SEQUENCE ng03.gm_chat_messages_id_seq OWNED BY ng03.gm_chat_messages.id;

ALTER TABLE ONLY ng03.gm_chat_messages ADD CONSTRAINT gm_chat_messages_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_galaxies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_galaxies_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_galaxies (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_galaxies_id_seq'::regclass) NOT NULL,
    allow_new boolean DEFAULT true NOT NULL,
    traded_ore bigint DEFAULT 0 NOT NULL,
    traded_hydro bigint DEFAULT 0 NOT NULL,
    price_ore real DEFAULT 120 NOT NULL,
    price_hydro real DEFAULT 160 NOT NULL
);

ALTER TABLE ng03.gm_galaxies OWNER TO exileng;

ALTER SEQUENCE ng03.gm_galaxies_id_seq OWNED BY ng03.gm_galaxies.id;

ALTER TABLE ONLY ng03.gm_galaxies ADD CONSTRAINT gm_galaxies_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_invasions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_invasions_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_invasions (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_invasions_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    planet_name character varying NOT NULL,
    success boolean NOT NULL,
    att_name character varying NOT NULL,
    att_soldier_count integer NOT NULL,
    att_soldier_lost integer NOT NULL,
    def_name character varying NOT NULL,
    def_soldier_count integer NOT NULL,
    def_soldier_lost integer NOT NULL,
    def_scientist_count integer NOT NULL,
    def_scientist_lost integer NOT NULL,
    def_worker_count integer NOT NULL,
    def_worker_lost integer NOT NULL
);

ALTER TABLE ng03.gm_invasions OWNER TO exileng;

ALTER SEQUENCE ng03.gm_invasions_id_seq OWNED BY ng03.gm_invasions.id;

ALTER TABLE ONLY ng03.gm_invasions ADD CONSTRAINT gm_invasions_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planets_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planets (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planets_id_seq'::regclass) NOT NULL,
    galaxy_id integer NOT NULL,
    sector smallint NOT NULL,
    planet smallint NOT NULL,
    profile_id integer,
    commander_id integer,
    name character varying,
    pct_ore smallint DEFAULT 60 NOT NULL,
    pct_hydro smallint DEFAULT 60 NOT NULL,
    floor smallint DEFAULT (85)::smallint NOT NULL,
    space smallint DEFAULT (10)::smallint NOT NULL,
    ore_count real DEFAULT 0 NOT NULL,
    hydro_count real DEFAULT 0 NOT NULL,
    energy_count real DEFAULT 0 NOT NULL,
    worker_count real DEFAULT 0 NOT NULL,
    scientist_count integer DEFAULT 0 NOT NULL,
    soldier_count integer DEFAULT 0 NOT NULL,
    production_last_date timestamp with time zone DEFAULT now(),
    production_frozen boolean DEFAULT false NOT NULL,
    spawn_ore integer DEFAULT 0 NOT NULL,
    spawn_hydro integer DEFAULT 0 NOT NULL,
    orbit_ore integer DEFAULT 0 NOT NULL,
    orbit_hydro integer DEFAULT 0 NOT NULL,
    mood smallint DEFAULT 100 NOT NULL,
    dilapidation integer DEFAULT 0 NOT NULL,
    previous_dilapidation integer DEFAULT 0 NOT NULL,
    battle_date timestamp with time zone,
    last_catastrophe_date timestamp with time zone DEFAULT now() NOT NULL,
    growing boolean DEFAULT true NOT NULL,
    ore_price smallint,
    hydro_price smallint,
    vortex_strength integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_planets OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planets_id_seq OWNED BY ng03.gm_planets.id;

ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_planet_key UNIQUE (galaxy_id, sector, planet);
ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_commander_id_key UNIQUE (commander_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_building_pendings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_building_pendings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_building_pendings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_building_pendings_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    building_id character varying NOT NULL,
    starting_date timestamp with time zone DEFAULT now() NOT NULL,
    ending_date timestamp with time zone
);

ALTER TABLE ng03.gm_planet_building_pendings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_building_pendings_id_seq OWNED BY ng03.gm_planet_building_pendings.id;

ALTER TABLE ONLY ng03.gm_planet_building_pendings ADD CONSTRAINT gm_planet_building_pendings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_building_pendings ADD CONSTRAINT gm_planet_building_pendings_building_id_key UNIQUE (planet_id, building_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_buildings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_buildings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_buildings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_buildings_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    building_id character varying NOT NULL,
    count smallint DEFAULT (1)::smallint NOT NULL,
    enabled_count smallint DEFAULT (1)::smallint NOT NULL
);

ALTER TABLE ng03.gm_planet_buildings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_buildings_id_seq OWNED BY ng03.gm_planet_buildings.id;

ALTER TABLE ONLY ng03.gm_planet_buildings ADD CONSTRAINT gm_planet_buildings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_buildings ADD CONSTRAINT gm_planet_buildings_building_id_key UNIQUE (planet_id, building_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_energy_transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_energy_transfers_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_energy_transfers (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_energy_transfers_id_seq'::regclass) NOT NULL,
    planet_id_1 integer NOT NULL,
    planet_id_2 integer NOT NULL,
    energy_count integer NOT NULL
);

ALTER TABLE ng03.gm_planet_energy_transfers OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_energy_transfers_id_seq OWNED BY ng03.gm_planet_energy_transfers.id;

ALTER TABLE ONLY ng03.gm_planet_energy_transfers ADD CONSTRAINT gm_planet_energy_transfers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_energy_transfers ADD CONSTRAINT gm_planet_energy_transfers_planet_id_2_key UNIQUE (planet_id_1, planet_id_2);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_ship_pendings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_ship_pendings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_ship_pendings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_ship_pendings_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    ship_id character varying NOT NULL,
    starting_date timestamp with time zone,
    ending_date timestamp with time zone,
    count integer NOT NULL,
    recycling boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_planet_ship_pendings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_ship_pendings_id_seq OWNED BY ng03.gm_planet_ship_pendings.id;

ALTER TABLE ONLY ng03.gm_planet_ship_pendings ADD CONSTRAINT gm_planet_ship_pendings_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_ships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_ships_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_ships (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_ships_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    ship_id character varying NOT NULL,
    count integer NOT NULL
);

ALTER TABLE ng03.gm_planet_ships OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_ships_id_seq OWNED BY ng03.gm_planet_ships.id;

ALTER TABLE ONLY ng03.gm_planet_ships ADD CONSTRAINT gm_planet_ships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_ships ADD CONSTRAINT gm_planet_ships_ship_id_key UNIQUE (planet_id, ship_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_training_pendings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_training_pendings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_training_pendings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_training_pendings_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    starting_date timestamp with time zone,
    ending_date timestamp with time zone,
    count integer NOT NULL,
    type character varying NOT NULL
);

ALTER TABLE ng03.gm_planet_training_pendings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_training_pendings_id_seq OWNED BY ng03.gm_planet_training_pendings.id;

ALTER TABLE ONLY ng03.gm_planet_training_pendings ADD CONSTRAINT gm_planet_training_pendings_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profiles_id_seq
    AS integer
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profiles_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profiles (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profiles_id_seq'::regclass) NOT NULL,
    user_id integer,
    pseudo character varying NOT NULL,
    privilege character varying DEFAULT 'new'::character varying NOT NULL,
    reset_count smallint DEFAULT 0 NOT NULL,
    bankruptcy smallint DEFAULT 168 NOT NULL,
    credit_count integer DEFAULT 3500 NOT NULL,
    prestige_count integer DEFAULT 0 NOT NULL,
    description text,
    notes text,
    avatar_url character varying,
    last_planet_id integer,
    score_dev integer DEFAULT 0 NOT NULL,
    score_battle integer DEFAULT 0 NOT NULL,
    previous_score_dev integer DEFAULT 0 NOT NULL,
    alliance_id integer,
    alliance_rank_id integer,
    last_activity_date timestamp with time zone DEFAULT now() NOT NULL,
    last_catastrophe_date timestamp with time zone DEFAULT now() NOT NULL,
    last_holidays_date timestamp with time zone DEFAULT now() NOT NULL,
    deleting_date timestamp with time zone,
    ban_ending_date timestamp with time zone,
    current_upkeep_commanders real DEFAULT 0 NOT NULL,
    current_upkeep_planets real DEFAULT 0 NOT NULL,
    current_upkeep_scientists real DEFAULT 0 NOT NULL,
    current_upkeep_soldiers real DEFAULT 0 NOT NULL,
    current_upkeep_fleets real DEFAULT 0 NOT NULL,
    current_upkeep_orbitting real DEFAULT 0 NOT NULL,
    current_upkeep_parking real DEFAULT 0 NOT NULL,
    commander_loyalty smallint DEFAULT 100 NOT NULL,
    orientation_id character varying,
    tutorial_first_ship boolean DEFAULT false NOT NULL,
    tutorial_first_colonizer boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_profiles OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profiles_id_seq OWNED BY ng03.gm_profiles.id;

ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_user_id_key UNIQUE (user_id);
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_pseudo_key UNIQUE (pseudo);

INSERT INTO ng03.gm_profiles(created_by, id, pseudo, privilege) VALUES('system', 1, 'Les fossoyeurs', 'active');
INSERT INTO ng03.gm_profiles(created_by, id, pseudo, privilege) VALUES('system', 2, 'Nation oubliée', 'active');
INSERT INTO ng03.gm_profiles(created_by, id, pseudo, privilege) VALUES('system', 3, 'Guilde marchande', 'active');

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_bounties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_bounties_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_bounties (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_bounties_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    credit_count integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_profile_bounties OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_bounties_id_seq OWNED BY ng03.gm_profile_bounties.id;

ALTER TABLE ONLY ng03.gm_profile_bounties ADD CONSTRAINT gm_profile_bounties_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_chats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_chats_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_chats (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_chats_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    chat_id integer NOT NULL,
    is_admin boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_profile_chats OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_chats_id_seq OWNED BY ng03.gm_profile_chats.id;

ALTER TABLE ONLY ng03.gm_profile_chats ADD CONSTRAINT gm_profile_chats_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_chats ADD CONSTRAINT gm_profile_chats_chat_id_key UNIQUE (profile_id, chat_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_commanders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_commanders_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_commanders (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_commanders_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    name character varying DEFAULT ng03._commander_generate_name() NOT NULL,
    point_count smallint DEFAULT 10 NOT NULL,
    salary integer DEFAULT 0 NOT NULL,
    engaging_date timestamp with time zone,
    increase_count smallint DEFAULT 0 NOT NULL,
    last_training_date timestamp with time zone DEFAULT now() NOT NULL,
    mod_planet_ore real DEFAULT 1.0 NOT NULL,
    mod_planet_hydro real DEFAULT 1.0 NOT NULL,
    mod_planet_energy real DEFAULT 1.0 NOT NULL,
    mod_planet_worker real DEFAULT 1.0 NOT NULL,
    mod_planet_building real DEFAULT 1.0 NOT NULL,
    mod_planet_ship real DEFAULT 1.0 NOT NULL,
    mod_fleet_damage real DEFAULT 1.0 NOT NULL,
    mod_fleet_speed real DEFAULT 1.0 NOT NULL,
    mod_fleet_shield real DEFAULT 1.0 NOT NULL,
    mod_fleet_handling real DEFAULT 1.0 NOT NULL,
    mod_fleet_tracking real DEFAULT 1.0 NOT NULL,
    mod_fleet_signature real DEFAULT 1.0 NOT NULL
);

ALTER TABLE ng03.gm_profile_commanders OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_commanders_id_seq OWNED BY ng03.gm_profile_commanders.id;

ALTER TABLE ONLY ng03.gm_profile_commanders ADD CONSTRAINT gm_profile_commanders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_commanders ADD CONSTRAINT gm_profile_commanders_name_key UNIQUE (profile_id, name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_fleet_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_fleet_categories_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_fleet_categories (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_fleet_categories_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    name character varying NOT NULL
);

ALTER TABLE ng03.gm_profile_fleet_categories OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_fleet_categories_id_seq OWNED BY ng03.gm_profile_fleet_categories.id;

ALTER TABLE ONLY ng03.gm_profile_fleet_categories ADD CONSTRAINT gm_profile_fleet_categories_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_fleet_categories ADD CONSTRAINT gm_profile_fleet_categories_name_key UNIQUE (profile_id, name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_fleets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_fleets_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_fleets (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_fleets_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    commander_id integer,
    planet_id integer,
    category_id smallint,
    current_waypoint_id integer,
    name character varying NOT NULL,
    stance boolean DEFAULT false NOT NULL,
    cargo_ore integer DEFAULT 0 NOT NULL,
    cargo_hydro integer DEFAULT 0 NOT NULL,
    cargo_worker integer DEFAULT 0 NOT NULL,
    cargo_scientist integer DEFAULT 0 NOT NULL,
    cargo_soldier integer DEFAULT 0 NOT NULL,
    idle_since_date timestamp with time zone DEFAULT now() NOT NULL,
    is_shared boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_profile_fleets OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_fleets_id_seq OWNED BY ng03.gm_profile_fleets.id;

ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_commander_id_key UNIQUE (commander_id);
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_current_waypoint_id_key UNIQUE (current_waypoint_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_fleet_waypoints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_fleet_waypoints_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_fleet_waypoints (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_fleet_waypoints_id_seq'::regclass) NOT NULL,
    fleet_id integer NOT NULL,
    next_waypoint_id integer,
    planet_id integer,
    action smallint NOT NULL
);

ALTER TABLE ng03.gm_profile_fleet_waypoints OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_fleet_waypoints_id_seq OWNED BY ng03.gm_profile_fleet_waypoints.id;

ALTER TABLE ONLY ng03.gm_profile_fleet_waypoints ADD CONSTRAINT gm_profile_fleet_waypoints_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_fleet_waypoints ADD CONSTRAINT gm_profile_fleet_waypoints_next_waypoint_id_key UNIQUE (next_waypoint_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_fleet_ships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_fleet_ships_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_fleet_ships (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_fleet_ships_id_seq'::regclass) NOT NULL,
    fleet_id integer NOT NULL,
    ship_id character varying NOT NULL,
    count integer DEFAULT 1 NOT NULL
);

ALTER TABLE ng03.gm_profile_fleet_ships OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_fleet_ships_id_seq OWNED BY ng03.gm_profile_fleet_ships.id;

ALTER TABLE ONLY ng03.gm_profile_fleet_ships ADD CONSTRAINT gm_profile_fleet_ships_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_fleet_ships ADD CONSTRAINT gm_profile_fleet_ships_ship_id_key UNIQUE (fleet_id, ship_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_holidays_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_holidays (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_holidays_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    starting_date timestamp with time zone DEFAULT (now() + '24:00:00'::interval) NOT NULL,
    min_ending_date timestamp with time zone,
    ending_date timestamp with time zone
);

ALTER TABLE ng03.gm_profile_holidays OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_holidays_id_seq OWNED BY ng03.gm_profile_holidays.id;

ALTER TABLE ONLY ng03.gm_profile_holidays ADD CONSTRAINT gm_profile_holidays_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_holidays ADD CONSTRAINT gm_profile_holidays_profile_id_key UNIQUE (profile_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_mails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_mails_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_mails (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_mails_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    sender_id integer,
    subject character varying NOT NULL,
    body text NOT NULL,
    credit_count integer,
    reading_date timestamp with time zone
);

ALTER TABLE ng03.gm_profile_mails OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_mails_id_seq OWNED BY ng03.gm_profile_mails.id;

ALTER TABLE ONLY ng03.gm_profile_mails ADD CONSTRAINT gm_profile_mails_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_mail_addressee_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_mail_addressee_list_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_mail_addressee_list (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_mail_addressee_list_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    addressee_id integer NOT NULL
);

ALTER TABLE ng03.gm_profile_mail_addressee_list OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_mail_addressee_list_id_seq OWNED BY ng03.gm_profile_mail_addressee_list.id;

ALTER TABLE ONLY ng03.gm_profile_mail_addressee_list ADD CONSTRAINT gm_profile_mail_addressee_list_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_mail_addressee_list ADD CONSTRAINT gm_profile_mail_addressee_list_addressee_id_key UNIQUE (profile_id, addressee_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_mail_blacklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_mail_blacklist_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_mail_blacklist (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_mail_blacklist_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    ignored_profile_id integer NOT NULL
);

ALTER TABLE ng03.gm_profile_mail_blacklist OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_mail_blacklist_id_seq OWNED BY ng03.gm_profile_mail_blacklist.id;

ALTER TABLE ONLY ng03.gm_profile_mail_blacklist ADD CONSTRAINT gm_profile_mail_blacklist_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_mail_blacklist ADD CONSTRAINT gm_profile_mail_blacklist_ignored_profile_id_key UNIQUE (profile_id, ignored_profile_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_market_purchases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_market_purchases_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_market_purchases (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_market_purchases_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    ore_count integer DEFAULT 0 NOT NULL,
    hydro_count integer DEFAULT 0 NOT NULL,
    credit_count integer DEFAULT 0 NOT NULL,
    delivery_date timestamp with time zone NOT NULL
);

ALTER TABLE ng03.gm_planet_market_purchases OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_market_purchases_id_seq OWNED BY ng03.gm_planet_market_purchases.id;

ALTER TABLE ONLY ng03.gm_planet_market_purchases ADD CONSTRAINT gm_planet_market_purchases_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_market_purchases ADD CONSTRAINT gm_planet_market_purchases_planet_id_key UNIQUE (planet_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_planet_market_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_planet_market_sales_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_planet_market_sales (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_planet_market_sales_id_seq'::regclass) NOT NULL,
    planet_id integer NOT NULL,
    ore_count integer DEFAULT 0 NOT NULL,
    hydro_count integer DEFAULT 0 NOT NULL,
    credit_count integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_planet_market_sales OWNER TO exileng;

ALTER SEQUENCE ng03.gm_planet_market_sales_id_seq OWNED BY ng03.gm_planet_market_sales.id;

ALTER TABLE ONLY ng03.gm_planet_market_sales ADD CONSTRAINT gm_planet_market_sales_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_planet_market_sales ADD CONSTRAINT gm_planet_market_sales_planet_id_key UNIQUE (planet_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_reports_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_reports (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_reports_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    type smallint NOT NULL,
    data character varying DEFAULT '{}'::character varying NOT NULL
);

ALTER TABLE ng03.gm_profile_reports OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_reports_id_seq OWNED BY ng03.gm_profile_reports.id;

ALTER TABLE ONLY ng03.gm_profile_reports ADD CONSTRAINT gm_profile_reports_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_researches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_researches_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_researches (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_researches_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    research_id character varying NOT NULL,
    level smallint DEFAULT 1 NOT NULL,
    expiration_date timestamp with time zone
);

ALTER TABLE ng03.gm_profile_researches OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_researches_id_seq OWNED BY ng03.gm_profile_researches.id;

ALTER TABLE ONLY ng03.gm_profile_researches ADD CONSTRAINT gm_profile_researches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_researches ADD CONSTRAINT gm_profile_researches_research_id_key UNIQUE (profile_id, research_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_research_pendings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_research_pendings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_research_pendings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_research_pendings_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    research_id character varying NOT NULL,
    starting_date timestamp without time zone NOT NULL,
    ending_date timestamp without time zone NOT NULL,
    loop boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_profile_research_pendings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_research_pendings_id_seq OWNED BY ng03.gm_profile_research_pendings.id;

ALTER TABLE ONLY ng03.gm_profile_research_pendings ADD CONSTRAINT gm_profile_research_pendings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_research_pendings ADD CONSTRAINT gm_profile_research_pendings_research_id_key UNIQUE (profile_id, research_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_profile_ship_kills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_profile_ship_kills_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_profile_ship_kills (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_profile_ship_kills_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    ship_id character varying NOT NULL,
    killed integer DEFAULT 0 NOT NULL,
    lost integer DEFAULT 0 NOT NULL
);

ALTER TABLE ng03.gm_profile_ship_kills OWNER TO exileng;

ALTER SEQUENCE ng03.gm_profile_ship_kills_id_seq OWNED BY ng03.gm_profile_ship_kills.id;

ALTER TABLE ONLY ng03.gm_profile_ship_kills ADD CONSTRAINT gm_profile_ship_kills_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_profile_ship_kills ADD CONSTRAINT gm_profile_ship_kills_ship_id_key UNIQUE (profile_id, ship_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_spyings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_spyings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_spyings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying NOT NULL,
    id integer DEFAULT nextval('ng03.gm_spyings_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    type smallint NOT NULL,
    level smallint NOT NULL,
    target_name character varying,
    is_spotted boolean DEFAULT false NOT NULL
);

ALTER TABLE ng03.gm_spyings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_spyings_id_seq OWNED BY ng03.gm_spyings.id;

ALTER TABLE ONLY ng03.gm_spyings ADD CONSTRAINT gm_spyings_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_spying_buildings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_spying_buildings_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_spying_buildings (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_spying_buildings_id_seq'::regclass) NOT NULL,
    spying_id integer NOT NULL,
    building_id character varying NOT NULL,
    count smallint NOT NULL
);

ALTER TABLE ng03.gm_spying_buildings OWNER TO exileng;

ALTER SEQUENCE ng03.gm_spying_buildings_id_seq OWNED BY ng03.gm_spying_buildings.id;

ALTER TABLE ONLY ng03.gm_spying_buildings ADD CONSTRAINT gm_spying_buildings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_spying_buildings ADD CONSTRAINT gm_spying_buildings_building_id_key UNIQUE (spying_id, building_id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_spying_fleets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_spying_fleets_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_spying_fleets (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_spying_fleets_id_seq'::regclass) NOT NULL,
    spying_id integer NOT NULL,
    name character varying NOT NULL,
    size integer NOT NULL,
    signature integer NOT NULL
);

ALTER TABLE ng03.gm_spying_fleets OWNER TO exileng;

ALTER SEQUENCE ng03.gm_spying_fleets_id_seq OWNED BY ng03.gm_spying_fleets.id;

ALTER TABLE ONLY ng03.gm_spying_fleets ADD CONSTRAINT gm_spying_fleets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_spying_fleets ADD CONSTRAINT gm_spying_fleets_name_key UNIQUE (spying_id, name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_spying_planets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_spying_planets_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_spying_planets (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_spying_planets_id_seq'::regclass) NOT NULL,
    spying_id integer NOT NULL,
    name character varying NOT NULL,
    floor smallint NOT NULL,
    floor_occupied smallint,
    space smallint NOT NULL,
    space_occupied smallint,
    parking integer,
    ore_count integer,
    ore_stock integer,
    ore_prod integer,
    hydro_count integer,
    hydro_stock integer,
    worker_count integer,
    worker_stock integer,
    hydrocarbon_production integer,
    scientist_count integer,
    scientist_stock integer,
    soldier_count integer,
    soldier_stock integer,
    radar_strength smallint,
    jammer_strength smallint,
    orbit_ore integer,
    orbit_hydro integer,
    energy_consumption integer,
    energy_prod integer,
    pct_ore smallint,
    pct_hydro smallint
);

ALTER TABLE ng03.gm_spying_planets OWNER TO exileng;

ALTER SEQUENCE ng03.gm_spying_planets_id_seq OWNED BY ng03.gm_spying_planets.id;

ALTER TABLE ONLY ng03.gm_spying_planets ADD CONSTRAINT gm_spying_planets_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_spying_planets ADD CONSTRAINT gm_spying_planets_name_key UNIQUE (spying_id, name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.gm_spying_researches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.gm_spying_researches_id_seq OWNER TO exileng;

CREATE TABLE ng03.gm_spying_researches (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.gm_spying_researches_id_seq'::regclass) NOT NULL,
    spying_id integer NOT NULL,
    name character varying NOT NULL,
    level integer NOT NULL
);

ALTER TABLE ng03.gm_spying_researches OWNER TO exileng;

ALTER SEQUENCE ng03.gm_spying_researches_id_seq OWNED BY ng03.gm_spying_researches.id;

ALTER TABLE ONLY ng03.gm_spying_researches ADD CONSTRAINT gm_spying_researches_pkey PRIMARY KEY (id);
ALTER TABLE ONLY ng03.gm_spying_researches ADD CONSTRAINT gm_spying_researches_name_key UNIQUE (spying_id, name);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.log_actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.log_actions_id_seq OWNER TO exileng;

CREATE TABLE ng03.log_actions (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.log_actions_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    action character varying  NOT NULL,
    result integer NOT NULL
);

ALTER TABLE ng03.log_actions OWNER TO exileng;

ALTER SEQUENCE ng03.log_actions_id_seq OWNED BY ng03.log_actions.id;

ALTER TABLE ONLY ng03.log_actions ADD CONSTRAINT log_actions_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.log_connections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.log_connections_id_seq OWNER TO exileng;

CREATE TABLE ng03.log_connections (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.log_connections_id_seq'::regclass) NOT NULL,
    profile_id integer NOT NULL,
    remote_addr character varying NOT NULL,
    user_agent character varying NOT NULL
);

ALTER TABLE ng03.log_connections OWNER TO exileng;

ALTER SEQUENCE ng03.log_connections_id_seq OWNED BY ng03.log_connections.id;

ALTER TABLE ONLY ng03.log_connections ADD CONSTRAINT log_connections_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------

CREATE SEQUENCE ng03.log_processes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ng03.log_processes_id_seq OWNER TO exileng;

CREATE TABLE ng03.log_processes (
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    created_by character varying DEFAULT 'system' NOT NULL,
    id integer DEFAULT nextval('ng03.log_processes_id_seq'::regclass) NOT NULL,
    process_id character varying NOT NULL,
    error character varying NOT NULL
);

ALTER TABLE ng03.log_processes OWNER TO exileng;

ALTER SEQUENCE ng03.log_processes_id_seq OWNED BY ng03.log_processes.id;

ALTER TABLE ONLY ng03.log_processes ADD CONSTRAINT log_processes_pkey PRIMARY KEY (id);

--------------------------------------------------------------------------------
-- FOREIGN KEYS
--------------------------------------------------------------------------------

ALTER TABLE ONLY ng03.gm_alliances ADD CONSTRAINT gm_alliances_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES ng03.gm_chats(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_invitations ADD CONSTRAINT gm_alliance_invitations_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_invitations ADD CONSTRAINT gm_alliance_invitations_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_nap_requests ADD CONSTRAINT gm_alliance_nap_requests_alliance_id_1_fkey FOREIGN KEY (alliance_id_1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_nap_requests ADD CONSTRAINT gm_alliance_nap_requests_alliance_id_2_fkey FOREIGN KEY (alliance_id_2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_naps ADD CONSTRAINT gm_alliance_naps_alliance_id_1_fkey FOREIGN KEY (alliance_id_1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_naps ADD CONSTRAINT gm_alliance_naps_alliance_id_2_fkey FOREIGN KEY (alliance_id_2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_ranks ADD CONSTRAINT gm_alliance_ranks_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_reports ADD CONSTRAINT gm_alliance_reports_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_tributes ADD CONSTRAINT gm_alliance_tributes_alliance_id_1_fkey FOREIGN KEY (alliance_id_1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_tributes ADD CONSTRAINT gm_alliance_tributes_alliance_id_2_fkey FOREIGN KEY (alliance_id_2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_wallet_logs ADD CONSTRAINT gm_alliance_wallet_logs_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_wallet_requests ADD CONSTRAINT gm_alliance_wallet_requests_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_wallet_requests ADD CONSTRAINT gm_alliance_wallet_requests_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_alliance_wars ADD CONSTRAINT gm_alliance_wars_alliance_id_1_fkey FOREIGN KEY (alliance_id_1) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_alliance_wars ADD CONSTRAINT gm_alliance_wars_alliance_id_2_fkey FOREIGN KEY (alliance_id_2) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_battle_fleet_ship_kills ADD CONSTRAINT gm_battle_fleet_ship_kills_battle_fleet_ship_id_fkey FOREIGN KEY (battle_fleet_ship_id) REFERENCES ng03.gm_battle_fleet_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_battle_fleet_ship_kills ADD CONSTRAINT gm_battle_fleet_ship_kills_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_battle_fleet_ships ADD CONSTRAINT gm_battle_fleet_ships_battle_fleet_id_fkey FOREIGN KEY (battle_fleet_id) REFERENCES ng03.gm_battle_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_battle_fleet_ships ADD CONSTRAINT gm_battle_fleet_ships_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_battle_fleets ADD CONSTRAINT gm_battle_fleets_battle_id_fkey FOREIGN KEY (battle_id) REFERENCES ng03.gm_battles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_battles ADD CONSTRAINT gm_battles_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_chat_messages ADD CONSTRAINT gm_chat_messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES ng03.gm_chats(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_invasions ADD CONSTRAINT gm_invasions_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_building_pendings ADD CONSTRAINT gm_planet_building_pendings_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planet_building_pendings ADD CONSTRAINT gm_planet_building_pendings_building_id_fkey FOREIGN KEY (building_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_buildings ADD CONSTRAINT gm_planet_buildings_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planet_buildings ADD CONSTRAINT gm_planet_buildings_building_id_fkey FOREIGN KEY (building_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_energy_transfers ADD CONSTRAINT gm_planet_energy_transfers_planet_id_1_fkey FOREIGN KEY (planet_id_1) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planet_energy_transfers ADD CONSTRAINT gm_planet_energy_transfers_planet_id_2_fkey FOREIGN KEY (planet_id_2) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_market_purchases ADD CONSTRAINT gm_planet_market_purchases_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_market_sales ADD CONSTRAINT gm_planet_market_sales_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_ship_pendings ADD CONSTRAINT gm_planet_ship_pendings_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planet_ship_pendings ADD CONSTRAINT gm_planet_ship_pendings_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_ships ADD CONSTRAINT gm_planet_ships_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planet_ships ADD CONSTRAINT gm_planet_ships_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planet_training_pendings ADD CONSTRAINT gm_planet_training_pendings_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_galaxy_id_fkey FOREIGN KEY (galaxy_id) REFERENCES ng03.gm_galaxies(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_planets ADD CONSTRAINT gm_planets_commander_id_fkey FOREIGN KEY (commander_id) REFERENCES ng03.gm_profile_commanders(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_bounties ADD CONSTRAINT gm_profile_bounties_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_chats ADD CONSTRAINT gm_profile_chats_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_chats ADD CONSTRAINT gm_profile_chats_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES ng03.gm_chats(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_commanders ADD CONSTRAINT gm_profile_commanders_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_fleet_categories ADD CONSTRAINT gm_profile_fleet_categories_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_fleet_ships ADD CONSTRAINT gm_profile_fleet_ships_fleet_id_fkey FOREIGN KEY (fleet_id) REFERENCES ng03.gm_profile_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleet_ships ADD CONSTRAINT gm_profile_fleet_ships_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_fleet_waypoints ADD CONSTRAINT gm_profile_fleet_waypoints_fleet_id_fkey FOREIGN KEY (fleet_id) REFERENCES ng03.gm_profile_fleets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleet_waypoints ADD CONSTRAINT gm_profile_fleet_waypoints_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleet_waypoints ADD CONSTRAINT gm_profile_fleet_waypoints_next_waypoint_id_fkey FOREIGN KEY (next_waypoint_id) REFERENCES ng03.gm_profile_fleet_waypoints(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_commander_id_fkey FOREIGN KEY (commander_id) REFERENCES ng03.gm_profile_commanders(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_category_id_fkey FOREIGN KEY (category_id) REFERENCES ng03.gm_profile_fleet_categories(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_fleets ADD CONSTRAINT gm_profile_fleets_current_waypoint_id_fkey FOREIGN KEY (current_waypoint_id) REFERENCES ng03.gm_profile_fleet_waypoints(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_holidays ADD CONSTRAINT gm_profile_holidays_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_mail_addressee_list ADD CONSTRAINT gm_profile_mail_addressee_list_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_mail_addressee_list ADD CONSTRAINT gm_profile_mail_addressee_list_addressee_id_fkey FOREIGN KEY (addressee_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_mail_blacklist ADD CONSTRAINT gm_profile_mail_blacklist_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_mail_blacklist ADD CONSTRAINT gm_profile_mail_blacklist_ignored_profile_id_fkey FOREIGN KEY (ignored_profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_mails ADD CONSTRAINT gm_profile_mails_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_mails ADD CONSTRAINT gm_profile_mails_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_reports ADD CONSTRAINT gm_profile_reports_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_research_pendings ADD CONSTRAINT gm_profile_research_pendings_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_research_pendings ADD CONSTRAINT gm_profile_research_pendings_research_id_fkey FOREIGN KEY (research_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_researches ADD CONSTRAINT gm_profile_researches_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_researches ADD CONSTRAINT gm_profile_researches_research_id_fkey FOREIGN KEY (research_id) REFERENCES ng03.dt_researches(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profile_ship_kills ADD CONSTRAINT gm_profile_ship_kills_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profile_ship_kills ADD CONSTRAINT gm_profile_ship_kills_ship_id_fkey FOREIGN KEY (ship_id) REFERENCES ng03.dt_ships(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_last_planet_id_fkey FOREIGN KEY (last_planet_id) REFERENCES ng03.gm_planets(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_alliance_id_fkey FOREIGN KEY (alliance_id) REFERENCES ng03.gm_alliances(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_alliance_rank_id_fkey FOREIGN KEY (alliance_rank_id) REFERENCES ng03.gm_alliance_ranks(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_profiles ADD CONSTRAINT gm_profiles_orientation_id_fkey FOREIGN KEY (orientation_id) REFERENCES ng03.dt_orientations(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_spying_buildings ADD CONSTRAINT gm_spying_buildings_spying_id_fkey FOREIGN KEY (spying_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY ng03.gm_spying_buildings ADD CONSTRAINT gm_spying_buildings_building_id_fkey FOREIGN KEY (building_id) REFERENCES ng03.dt_buildings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_spying_fleets ADD CONSTRAINT gm_spying_fleets_spying_id_fkey FOREIGN KEY (spying_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_spying_planets ADD CONSTRAINT gm_spying_planets_spying_id_fkey FOREIGN KEY (spying_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_spying_researches ADD CONSTRAINT gm_spying_researches_spying_id_fkey FOREIGN KEY (spying_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.gm_spyings ADD CONSTRAINT gm_spyings_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_spyings(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.log_actions ADD CONSTRAINT log_actions_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.log_connections ADD CONSTRAINT log_connections_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES ng03.gm_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY ng03.log_processes ADD CONSTRAINT log_processes_process_id_fkey FOREIGN KEY (process_id) REFERENCES ng03.dt_processes(id) ON UPDATE CASCADE ON DELETE CASCADE;

--------------------------------------------------------------------------------
-- VIEWS
--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_starting_galaxies AS
    SELECT gm_galaxies.id,
        ng03._galaxy_get_recommendation(gm_galaxies.id) AS recommendation
    FROM ng03.gm_galaxies;
   
ALTER TABLE ng03.vw_starting_galaxies OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_starting_orientations AS
    SELECT dt_orientations.id,
        dt_orientations.id::text || '_label'::text AS label
    FROM ng03.dt_orientations;
   
ALTER TABLE ng03.vw_starting_orientations OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_layout_profile AS
    SELECT gm_profiles.id,
        gm_profiles.credit_count,
        gm_profiles.prestige_count
    FROM ng03.gm_profiles;
   
ALTER TABLE ng03.vw_layout_profile OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_layout_planet AS
    SELECT gm_planets.id
        gm_planets.galaxy_id,
        gm_planets.sector,
        gm_planets.planet
    FROM ng03.gm_planets;
   
ALTER TABLE ng03.vw_layout_planet OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_header_planet AS
    SELECT gm_planets.id,
        gm_planets.ore_count::integer AS ore_count
    FROM gm_planets;
   
ALTER TABLE ng03.vw_header_planet OWNER TO exileng;

--------------------------------------------------------------------------------

CREATE VIEW ng03.vw_header_planets AS
    SELECT gm_planets.id,
        gm_planets.profile_id,
        gm_planets.name,
        gm_planets.galaxy_id,
        gm_planets.sector,
        gm_planets.planet
    FROM gm_planets
    WHERE gm_planets.floor > 0 AND gm_planets.space > 0
    ORDER BY gm_planets.galaxy_id, gm_planets.sector, gm_planets.planet;
  
ALTER TABLE ng03.vw_header_planets OWNER TO exileng;

--------------------------------------------------------------------------------
-- PostgreSQL database
--------------------------------------------------------------------------------
