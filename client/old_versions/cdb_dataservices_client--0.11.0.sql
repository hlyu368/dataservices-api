--DO NOT MODIFY THIS FILE, IT IS GENERATED AUTOMATICALLY FROM SOURCES
-- Complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION cdb_dataservices_client" to load this file. \quit
--
-- Geocoder server connection config
--
-- The purpose of this function is provide to the PL/Proxy functions
-- the connection string needed to connect with the server

CREATE OR REPLACE FUNCTION cdb_dataservices_client._server_conn_str()
RETURNS text AS $$
DECLARE
  db_connection_str text;
BEGIN
  SELECT cartodb.cdb_conf_getconf('geocoder_server_config')->'connection_str' INTO db_connection_str;
  SELECT trim(both '"' FROM db_connection_str) INTO db_connection_str;
  RETURN db_connection_str;
END;
$$ LANGUAGE 'plpgsql';CREATE TYPE cdb_dataservices_client._entity_config AS (
    username text,
    organization_name text
);

--
-- Get entity config function
--
-- The purpose of this function is to retrieve the username and organization name from
-- a) schema where he/her is the owner in case is an organization user
-- b) entity_name from the cdb_conf database in case is a non organization user
CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_entity_config()
RETURNS record AS $$
DECLARE
    result cdb_dataservices_client._entity_config;
    is_organization boolean;
    username text;
    organization_name text;
BEGIN
    SELECT cartodb.cdb_conf_getconf('user_config')->'is_organization' INTO is_organization;
    IF is_organization IS NULL THEN
        RAISE EXCEPTION 'User must have user configuration in the config table';
    ELSIF is_organization = TRUE THEN
        SELECT nspname
        FROM pg_namespace s
        LEFT JOIN pg_roles r ON s.nspowner = r.oid
        WHERE r.rolname = session_user INTO username;
        SELECT cartodb.cdb_conf_getconf('user_config')->>'entity_name' INTO organization_name;
    ELSE
        SELECT cartodb.cdb_conf_getconf('user_config')->>'entity_name' INTO username;
        organization_name = NULL;
    END IF;
    result.username = username;
    result.organization_name = organization_name;
    RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;CREATE TYPE cdb_dataservices_client.isoline AS (
    center geometry(Geometry,4326),
    data_range integer,
    the_geom geometry(Multipolygon,4326)
);

CREATE TYPE cdb_dataservices_client.simple_route AS (
    shape geometry(LineString,4326),
    length real,
    duration integer
);--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_admin0_polygon (country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_admin0_polygon(username, orgname, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_admin1_polygon (admin1_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_admin1_polygon(username, orgname, admin1_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_admin1_polygon (admin1_name text, country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_admin1_polygon(username, orgname, admin1_name, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point (city_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_namedplace_point(username, orgname, city_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point (city_name text, country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_namedplace_point(username, orgname, city_name, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point (city_name text, admin1_name text, country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_namedplace_point(username, orgname, city_name, admin1_name, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_postalcode_polygon (postal_code text, country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_postalcode_polygon(username, orgname, postal_code, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_postalcode_point (postal_code text, country_name text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_postalcode_point(username, orgname, postal_code, country_name) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_ipaddress_point (ip_address text)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_ipaddress_point(username, orgname, ip_address) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_geocode_street_point (searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_geocode_street_point(username, orgname, searchtext, city, state_province, country) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_here_geocode_street_point (searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_here_geocode_street_point(username, orgname, searchtext, city, state_province, country) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_google_geocode_street_point (searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_google_geocode_street_point(username, orgname, searchtext, city, state_province, country) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_mapzen_geocode_street_point (searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._cdb_mapzen_geocode_street_point(username, orgname, searchtext, city, state_province, country) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_isodistance (source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])
RETURNS SETOF cdb_dataservices_client.isoline AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._cdb_isodistance(username, orgname, source, mode, range, options);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_isochrone (source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])
RETURNS SETOF cdb_dataservices_client.isoline AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._cdb_isochrone(username, orgname, source, mode, range, options);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_mapzen_isochrone (source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])
RETURNS SETOF cdb_dataservices_client.isoline AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._cdb_mapzen_isochrone(username, orgname, source, mode, range, options);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_mapzen_isodistance (source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])
RETURNS SETOF cdb_dataservices_client.isoline AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._cdb_mapzen_isodistance(username, orgname, source, mode, range, options);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_route_point_to_point (origin geometry(Point, 4326), destination geometry(Point, 4326), mode text, options text[] DEFAULT ARRAY[]::text[], units text DEFAULT 'kilometers')
RETURNS cdb_dataservices_client.simple_route AS $$
DECLARE
  ret cdb_dataservices_client.simple_route;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT * FROM cdb_dataservices_client._cdb_route_point_to_point(username, orgname, origin, destination, mode, options, units) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.cdb_route_with_waypoints (waypoints geometry(Point, 4326)[], mode text, options text[] DEFAULT ARRAY[]::text[], units text DEFAULT 'kilometers')
RETURNS cdb_dataservices_client.simple_route AS $$
DECLARE
  ret cdb_dataservices_client.simple_route;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT * FROM cdb_dataservices_client._cdb_route_with_waypoints(username, orgname, waypoints, mode, options, units) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_get_demographic_snapshot (geom geometry(Geometry, 4326), time_span text DEFAULT '2009 - 2013'::text, geometry_level text DEFAULT NULL)
RETURNS json AS $$
DECLARE
  ret json;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_get_demographic_snapshot(username, orgname, geom, time_span, geometry_level) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_get_segment_snapshot (geom geometry(Geometry, 4326), geometry_level text DEFAULT NULL)
RETURNS json AS $$
DECLARE
  ret json;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_get_segment_snapshot(username, orgname, geom, geometry_level) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getdemographicsnapshot (geom geometry(Geometry, 4326), time_span text DEFAULT NULL, geometry_level text DEFAULT NULL)
RETURNS SETOF JSON AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getdemographicsnapshot(username, orgname, geom, time_span, geometry_level);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getsegmentsnapshot (geom geometry(Geometry, 4326), geometry_level text DEFAULT NULL)
RETURNS SETOF JSON AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getsegmentsnapshot(username, orgname, geom, geometry_level);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getboundary (geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getboundary(username, orgname, geom, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getboundaryid (geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL)
RETURNS text AS $$
DECLARE
  ret text;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getboundaryid(username, orgname, geom, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getboundarybyid (geometry_id text, boundary_id text, time_span text DEFAULT NULL)
RETURNS Geometry AS $$
DECLARE
  ret Geometry;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getboundarybyid(username, orgname, geometry_id, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getboundariesbygeometry (geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)
RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getboundariesbygeometry(username, orgname, geom, boundary_id, time_span, overlap_type);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getboundariesbypointandradius (geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)
RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getboundariesbypointandradius(username, orgname, geom, radius, boundary_id, time_span, overlap_type);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getpointsbygeometry (geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)
RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getpointsbygeometry(username, orgname, geom, boundary_id, time_span, overlap_type);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getpointsbypointandradius (geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)
RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getpointsbypointandradius(username, orgname, geom, radius, boundary_id, time_span, overlap_type);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getmeasure (geom Geometry, measure_id text, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)
RETURNS numeric AS $$
DECLARE
  ret numeric;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getmeasure(username, orgname, geom, measure_id, normalize, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getmeasurebyid (geom_ref text, measure_id text, boundary_id text, time_span text DEFAULT NULL)
RETURNS numeric AS $$
DECLARE
  ret numeric;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getmeasurebyid(username, orgname, geom_ref, measure_id, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getcategory (geom Geometry, category_id text, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)
RETURNS text AS $$
DECLARE
  ret text;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getcategory(username, orgname, geom, category_id, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getuscensusmeasure (geom Geometry, name text, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)
RETURNS numeric AS $$
DECLARE
  ret numeric;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getuscensusmeasure(username, orgname, geom, name, normalize, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getuscensuscategory (geom Geometry, name text, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)
RETURNS text AS $$
DECLARE
  ret text;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getuscensuscategory(username, orgname, geom, name, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getpopulation (geom Geometry, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)
RETURNS numeric AS $$
DECLARE
  ret numeric;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT cdb_dataservices_client._obs_getpopulation(username, orgname, geom, normalize, boundary_id, time_span) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_search (search_term text, relevant_boundary text DEFAULT NULL)
RETURNS TABLE(id text, description text, name text, aggregate text, source text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_search(username, orgname, search_term, relevant_boundary);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_getavailableboundaries (geom Geometry, timespan text DEFAULT NULL)
RETURNS TABLE(boundary_id text, description text, time_span text, tablename text) AS $$
DECLARE
  
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    RETURN QUERY
    SELECT * FROM cdb_dataservices_client._obs_getavailableboundaries(username, orgname, geom, timespan);
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
--
-- Public dataservices API function
--
-- These are the only ones with permissions to publicuser role
-- and should also be the only ones with SECURITY DEFINER

CREATE OR REPLACE FUNCTION cdb_dataservices_client.obs_dumpversion ()
RETURNS text AS $$
DECLARE
  ret text;
  username text;
  orgname text;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;
  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument, check it out';
  END IF;
  
    SELECT * FROM cdb_dataservices_client._obs_dumpversion(username, orgname) INTO ret;
    RETURN ret;
  
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;
CREATE TYPE cdb_dataservices_client.ds_fdw_metadata as (schemaname text, tabname text, servername text);
CREATE TYPE cdb_dataservices_client.ds_return_metadata as (colnames text[], coltypes text[]);

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_PrepareTableOBS_GetMeasure(
    output_table_name text,
    params json
) RETURNS boolean AS $$
DECLARE
  username text;
  user_db_role text;
  orgname text;
  user_schema text;
  result boolean;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;

  SELECT session_user INTO user_db_role;

  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument';
  END IF;

  IF orgname IS NULL OR orgname = '' OR orgname = '""' THEN
    user_schema := 'public';
  ELSE
    user_schema := username;
  END IF;

  SELECT cdb_dataservices_client.__DST_PrepareTableOBS_GetMeasure(
      username,
      orgname,
      user_db_role,
      user_schema,
      output_table_name,
      params
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_PopulateTableOBS_GetMeasure(
    table_name text,
    output_table_name text,
    params json
) RETURNS boolean AS $$
DECLARE
  username text;
  user_db_role text;
  orgname text;
  dbname text;
  user_schema text;
  result boolean;
BEGIN
  IF session_user = 'publicuser' OR session_user ~ 'cartodb_publicuser_*' THEN
    RAISE EXCEPTION 'The api_key must be provided';
  END IF;

  SELECT session_user INTO user_db_role;

  SELECT u, o INTO username, orgname FROM cdb_dataservices_client._cdb_entity_config() AS (u text, o text);
  -- JSON value stored "" is taken as literal
  IF username IS NULL OR username = '' OR username = '""' THEN
    RAISE EXCEPTION 'Username is a mandatory argument';
  END IF;

  IF orgname IS NULL OR orgname = '' OR orgname = '""' THEN
    user_schema := 'public';
  ELSE
    user_schema := username;
  END IF;

  SELECT current_database() INTO dbname;

  SELECT cdb_dataservices_client.__DST_PopulateTableOBS_GetMeasure(
      username,
      orgname,
      user_db_role,
      user_schema,
      dbname,
      table_name,
      output_table_name,
      params
  ) INTO result;

  RETURN result;
END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;


CREATE OR REPLACE FUNCTION cdb_dataservices_client.__DST_PrepareTableOBS_GetMeasure(
    username text,
    orgname text,
    user_db_role text,
    user_schema text,
    output_table_name text,
    params json
) RETURNS boolean AS $$
    function_name = 'GetMeasure'
    # Obtain return types for augmentation procedure
    ds_return_metadata = plpy.execute("SELECT colnames, coltypes "
        "FROM cdb_dataservices_client._DST_GetReturnMetadata({username}::text, {orgname}::text, {function_name}::text, {params}::json);"
        .format(
            username=plpy.quote_nullable(username),
            orgname=plpy.quote_nullable(orgname),
            function_name=plpy.quote_literal(function_name),
            params=plpy.quote_literal(params)
            )
        )
    if ds_return_metadata[0]["colnames"]:
        colnames_arr = ds_return_metadata[0]["colnames"]
        coltypes_arr = ds_return_metadata[0]["coltypes"]
    else:
        raise Exception('Error retrieving OBS_GetMeasure metadata')


    # Prepare column and type strings required in the SQL queries
    columns_with_types_arr = [colnames_arr[i] + ' ' + coltypes_arr[i] for i in range(0,len(colnames_arr))]
    columns_with_types = ','.join(columns_with_types_arr)

    # Create a new table with the required columns
    plpy.execute('CREATE TABLE "{schema}".{table_name} ( '
        'cartodb_id int, the_geom geometry, {columns_with_types} '
        ');'
        .format(schema=user_schema, table_name=output_table_name, columns_with_types=columns_with_types)
        )

    plpy.execute('ALTER TABLE "{schema}".{table_name} OWNER TO "{user}";'
        .format(schema=user_schema, table_name=output_table_name, user=user_db_role)
        )

    return True
$$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION cdb_dataservices_client.__DST_PopulateTableOBS_GetMeasure(
    username text,
    orgname text,
    user_db_role text,
    user_schema text,
    dbname text,
    table_name text,
    output_table_name text,
    params json
) RETURNS boolean AS $$
    function_name = 'GetMeasure'
    # Obtain return types for augmentation procedure
    ds_return_metadata = plpy.execute(
        "SELECT colnames, coltypes "
        "FROM cdb_dataservices_client._DST_GetReturnMetadata({username}::text, {orgname}::text, {function_name}::text, {params}::json);" .format(
            username=plpy.quote_nullable(username),
            orgname=plpy.quote_nullable(orgname),
            function_name=plpy.quote_literal(function_name),
            params=plpy.quote_literal(params)))

    if ds_return_metadata[0]["colnames"]:
        colnames_arr = ds_return_metadata[0]["colnames"]
        coltypes_arr = ds_return_metadata[0]["coltypes"]
    else:
        raise Exception('Error retrieving OBS_GetMeasure metadata')

    # Prepare column and type strings required in the SQL queries
    columns_with_types_arr = [
        colnames_arr[i] +
        ' ' +
        coltypes_arr[i] for i in range(
            0,
            len(colnames_arr))]
    columns_with_types = ','.join(columns_with_types_arr)
    aliased_colname_list = ','.join(
        ['result.' + name for name in colnames_arr])

    # Instruct the OBS server side to establish a FDW
    # The metadata is obtained as well in order to:
    #   - (a) be able to write the query to grab the actual data to be executed in the remote server via pl/proxy,
    #   - (b) be able to tell OBS to free resources when done.
    ds_fdw_metadata = plpy.execute(
        "SELECT schemaname, tabname, servername "
        "FROM cdb_dataservices_client._DST_ConnectUserTable({username}::text, {orgname}::text, {user_db_role}::text, "
        "{schema}::text, {dbname}::text, {table_name}::text);" .format(
            username=plpy.quote_nullable(username),
            orgname=plpy.quote_nullable(orgname),
            user_db_role=plpy.quote_literal(user_db_role),
            schema=plpy.quote_literal(user_schema),
            dbname=plpy.quote_literal(dbname),
            table_name=plpy.quote_literal(table_name)))

    if ds_fdw_metadata[0]["schemaname"]:
        server_schema = ds_fdw_metadata[0]["schemaname"]
        server_table_name = ds_fdw_metadata[0]["tabname"]
        server_name = ds_fdw_metadata[0]["servername"]
    else:
        raise Exception('Error connecting dataset via FDW')

    # Create a new table with the required columns
    plpy.execute(
        'INSERT INTO "{schema}".{analysis_table_name} '
        'SELECT ut.cartodb_id, ut.the_geom, {colname_list} '
        'FROM "{schema}".{table_name} ut '
        'LEFT JOIN _DST_FetchJoinFdwTableData({username}::text, {orgname}::text, {server_schema}::text, {server_table_name}::text, '
        '{function_name}::text, {params}::json) '
        'AS result ({columns_with_types}, cartodb_id int)  '
        'ON result.cartodb_id = ut.cartodb_id;' .format(
            schema=user_schema,
            analysis_table_name=output_table_name,
            colname_list=aliased_colname_list,
            table_name=table_name,
            username=plpy.quote_nullable(username),
            orgname=plpy.quote_nullable(orgname),
            server_schema=plpy.quote_literal(server_schema),
            server_table_name=plpy.quote_literal(server_table_name),
            function_name=plpy.quote_literal(function_name),
            params=plpy.quote_literal(params),
            columns_with_types=columns_with_types))

    # Wipe user FDW data from the server
    wiped = plpy.execute(
        "SELECT cdb_dataservices_client._DST_DisconnectUserTable({username}::text, {orgname}::text, {server_schema}::text, "
        "{server_table_name}::text, {fdw_server}::text)" .format(
            username=plpy.quote_nullable(username),
            orgname=plpy.quote_nullable(orgname),
            server_schema=plpy.quote_literal(server_schema),
            server_table_name=plpy.quote_literal(server_table_name),
            fdw_server=plpy.quote_literal(server_name)))

    return True
$$ LANGUAGE plpythonu;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_ConnectUserTable(
    username text,
    orgname text,
    user_db_role text,
    user_schema text,
    dbname text,
    table_name text
)RETURNS cdb_dataservices_client.ds_fdw_metadata AS $$
    CONNECT cdb_dataservices_client._server_conn_str();
    TARGET cdb_dataservices_server._DST_ConnectUserTable;
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_GetReturnMetadata(
    username text,
    orgname text,
    function_name text,
    params json
) RETURNS cdb_dataservices_client.ds_return_metadata AS $$
    CONNECT cdb_dataservices_client._server_conn_str();
    TARGET cdb_dataservices_server._DST_GetReturnMetadata;
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_FetchJoinFdwTableData(
    username text,
    orgname text,
    table_schema text,
    table_name text,
    function_name text,
    params json
) RETURNS SETOF record AS $$
    CONNECT cdb_dataservices_client._server_conn_str();
    TARGET cdb_dataservices_server._DST_FetchJoinFdwTableData;
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._DST_DisconnectUserTable(
    username text,
    orgname text,
    table_schema text,
    table_name text,
    server_name text
) RETURNS boolean AS $$
    CONNECT cdb_dataservices_client._server_conn_str();
    TARGET cdb_dataservices_server._DST_DisconnectUserTable;
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_admin0_polygon (username text, organization_name text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_admin0_polygon (username, organization_name, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_admin1_polygon (username text, organization_name text, admin1_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_admin1_polygon (username, organization_name, admin1_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_admin1_polygon (username text, organization_name text, admin1_name text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_admin1_polygon (username, organization_name, admin1_name, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_namedplace_point (username text, organization_name text, city_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_namedplace_point (username, organization_name, city_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_namedplace_point (username text, organization_name text, city_name text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_namedplace_point (username, organization_name, city_name, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_namedplace_point (username text, organization_name text, city_name text, admin1_name text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_namedplace_point (username, organization_name, city_name, admin1_name, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_postalcode_polygon (username text, organization_name text, postal_code text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_postalcode_polygon (username, organization_name, postal_code, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_postalcode_point (username text, organization_name text, postal_code text, country_name text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_postalcode_point (username, organization_name, postal_code, country_name);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_ipaddress_point (username text, organization_name text, ip_address text)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_ipaddress_point (username, organization_name, ip_address);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_geocode_street_point (username text, organization_name text, searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_geocode_street_point (username, organization_name, searchtext, city, state_province, country);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_here_geocode_street_point (username text, organization_name text, searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_here_geocode_street_point (username, organization_name, searchtext, city, state_province, country);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_google_geocode_street_point (username text, organization_name text, searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_google_geocode_street_point (username, organization_name, searchtext, city, state_province, country);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_mapzen_geocode_street_point (username text, organization_name text, searchtext text, city text DEFAULT NULL, state_province text DEFAULT NULL, country text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.cdb_mapzen_geocode_street_point (username, organization_name, searchtext, city, state_province, country);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_isodistance (username text, organization_name text, source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])

RETURNS SETOF cdb_dataservices_client.isoline AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_isodistance (username, organization_name, source, mode, range, options);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_isochrone (username text, organization_name text, source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])

RETURNS SETOF cdb_dataservices_client.isoline AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_isochrone (username, organization_name, source, mode, range, options);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_mapzen_isochrone (username text, organization_name text, source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])

RETURNS SETOF cdb_dataservices_client.isoline AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_mapzen_isochrone (username, organization_name, source, mode, range, options);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_mapzen_isodistance (username text, organization_name text, source geometry(Geometry, 4326), mode text, range integer[], options text[] DEFAULT ARRAY[]::text[])

RETURNS SETOF cdb_dataservices_client.isoline AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_mapzen_isodistance (username, organization_name, source, mode, range, options);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_route_point_to_point (username text, organization_name text, origin geometry(Point, 4326), destination geometry(Point, 4326), mode text, options text[] DEFAULT ARRAY[]::text[], units text DEFAULT 'kilometers')

RETURNS cdb_dataservices_client.simple_route AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_route_point_to_point (username, organization_name, origin, destination, mode, options, units);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._cdb_route_with_waypoints (username text, organization_name text, waypoints geometry(Point, 4326)[], mode text, options text[] DEFAULT ARRAY[]::text[], units text DEFAULT 'kilometers')

RETURNS cdb_dataservices_client.simple_route AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.cdb_route_with_waypoints (username, organization_name, waypoints, mode, options, units);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_get_demographic_snapshot (username text, organization_name text, geom geometry(Geometry, 4326), time_span text DEFAULT '2009 - 2013'::text, geometry_level text DEFAULT NULL)

RETURNS json AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_get_demographic_snapshot (username, organization_name, geom, time_span, geometry_level);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_get_segment_snapshot (username text, organization_name text, geom geometry(Geometry, 4326), geometry_level text DEFAULT NULL)

RETURNS json AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_get_segment_snapshot (username, organization_name, geom, geometry_level);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getdemographicsnapshot (username text, organization_name text, geom geometry(Geometry, 4326), time_span text DEFAULT NULL, geometry_level text DEFAULT NULL)

RETURNS SETOF JSON AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getdemographicsnapshot (username, organization_name, geom, time_span, geometry_level);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getsegmentsnapshot (username text, organization_name text, geom geometry(Geometry, 4326), geometry_level text DEFAULT NULL)

RETURNS SETOF JSON AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getsegmentsnapshot (username, organization_name, geom, geometry_level);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getboundary (username text, organization_name text, geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getboundary (username, organization_name, geom, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getboundaryid (username text, organization_name text, geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL)

RETURNS text AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getboundaryid (username, organization_name, geom, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getboundarybyid (username text, organization_name text, geometry_id text, boundary_id text, time_span text DEFAULT NULL)

RETURNS Geometry AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getboundarybyid (username, organization_name, geometry_id, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getboundariesbygeometry (username text, organization_name text, geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)

RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_getboundariesbygeometry (username, organization_name, geom, boundary_id, time_span, overlap_type);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getboundariesbypointandradius (username text, organization_name text, geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)

RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_getboundariesbypointandradius (username, organization_name, geom, radius, boundary_id, time_span, overlap_type);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getpointsbygeometry (username text, organization_name text, geom geometry(Geometry, 4326), boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)

RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_getpointsbygeometry (username, organization_name, geom, boundary_id, time_span, overlap_type);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getpointsbypointandradius (username text, organization_name text, geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text DEFAULT NULL, overlap_type text DEFAULT NULL)

RETURNS TABLE(the_geom geometry, geom_refs text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_getpointsbypointandradius (username, organization_name, geom, radius, boundary_id, time_span, overlap_type);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getmeasure (username text, organization_name text, geom Geometry, measure_id text, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)

RETURNS numeric AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getmeasure (username, organization_name, geom, measure_id, normalize, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getmeasurebyid (username text, organization_name text, geom_ref text, measure_id text, boundary_id text, time_span text DEFAULT NULL)

RETURNS numeric AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getmeasurebyid (username, organization_name, geom_ref, measure_id, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getcategory (username text, organization_name text, geom Geometry, category_id text, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)

RETURNS text AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getcategory (username, organization_name, geom, category_id, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getuscensusmeasure (username text, organization_name text, geom Geometry, name text, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)

RETURNS numeric AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getuscensusmeasure (username, organization_name, geom, name, normalize, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getuscensuscategory (username text, organization_name text, geom Geometry, name text, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)

RETURNS text AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getuscensuscategory (username, organization_name, geom, name, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getpopulation (username text, organization_name text, geom Geometry, normalize text DEFAULT NULL, boundary_id text DEFAULT NULL, time_span text DEFAULT NULL)

RETURNS numeric AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT cdb_dataservices_server.obs_getpopulation (username, organization_name, geom, normalize, boundary_id, time_span);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_search (username text, organization_name text, search_term text, relevant_boundary text DEFAULT NULL)

RETURNS TABLE(id text, description text, name text, aggregate text, source text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_search (username, organization_name, search_term, relevant_boundary);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_getavailableboundaries (username text, organization_name text, geom Geometry, timespan text DEFAULT NULL)

RETURNS TABLE(boundary_id text, description text, time_span text, tablename text) AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_getavailableboundaries (username, organization_name, geom, timespan);
  
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION cdb_dataservices_client._obs_dumpversion (username text, organization_name text)

RETURNS text AS $$
  CONNECT cdb_dataservices_client._server_conn_str();
  
  SELECT * FROM cdb_dataservices_server.obs_dumpversion (username, organization_name);
  
$$ LANGUAGE plproxy;
-- Make sure by default there are no permissions for publicuser
-- NOTE: this happens at extension creation time, as part of an implicit transaction.
REVOKE ALL PRIVILEGES ON SCHEMA cdb_dataservices_client FROM PUBLIC, publicuser CASCADE;

-- Grant permissions on the schema to publicuser (but just the schema)
GRANT USAGE ON SCHEMA cdb_dataservices_client TO publicuser;

-- Revoke execute permissions on all functions in the schema by default
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA cdb_dataservices_client FROM PUBLIC, publicuser;GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_admin0_polygon(country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_admin1_polygon(admin1_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_admin1_polygon(admin1_name text, country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point(city_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point(city_name text, country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_namedplace_point(city_name text, admin1_name text, country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_postalcode_polygon(postal_code text, country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_postalcode_point(postal_code text, country_name text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_ipaddress_point(ip_address text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_geocode_street_point(searchtext text, city text, state_province text, country text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_here_geocode_street_point(searchtext text, city text, state_province text, country text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_google_geocode_street_point(searchtext text, city text, state_province text, country text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_mapzen_geocode_street_point(searchtext text, city text, state_province text, country text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_isodistance(source geometry(Geometry, 4326), mode text, range integer[], options text[]) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_isochrone(source geometry(Geometry, 4326), mode text, range integer[], options text[]) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_mapzen_isochrone(source geometry(Geometry, 4326), mode text, range integer[], options text[]) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_mapzen_isodistance(source geometry(Geometry, 4326), mode text, range integer[], options text[]) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_route_point_to_point(origin geometry(Point, 4326), destination geometry(Point, 4326), mode text, options text[], units text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.cdb_route_with_waypoints(waypoints geometry(Point, 4326)[], mode text, options text[], units text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_get_demographic_snapshot(geom geometry(Geometry, 4326), time_span text, geometry_level text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_get_segment_snapshot(geom geometry(Geometry, 4326), geometry_level text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getdemographicsnapshot(geom geometry(Geometry, 4326), time_span text, geometry_level text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getsegmentsnapshot(geom geometry(Geometry, 4326), geometry_level text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getboundary(geom geometry(Geometry, 4326), boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getboundaryid(geom geometry(Geometry, 4326), boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getboundarybyid(geometry_id text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getboundariesbygeometry(geom geometry(Geometry, 4326), boundary_id text, time_span text, overlap_type text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getboundariesbypointandradius(geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text, overlap_type text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getpointsbygeometry(geom geometry(Geometry, 4326), boundary_id text, time_span text, overlap_type text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getpointsbypointandradius(geom geometry(Geometry, 4326), radius numeric, boundary_id text, time_span text, overlap_type text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getmeasure(geom Geometry, measure_id text, normalize text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getmeasurebyid(geom_ref text, measure_id text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getcategory(geom Geometry, category_id text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getuscensusmeasure(geom Geometry, name text, normalize text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getuscensuscategory(geom Geometry, name text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getpopulation(geom Geometry, normalize text, boundary_id text, time_span text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_search(search_term text, relevant_boundary text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_getavailableboundaries(geom Geometry, timespan text) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client.obs_dumpversion() TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client._DST_PrepareTableOBS_GetMeasure(output_table_name text, params json) TO publicuser;
GRANT EXECUTE ON FUNCTION cdb_dataservices_client._DST_PopulateTableOBS_GetMeasure(table_name text, output_table_name text, params json) TO publicuser;
