--DO NOT MODIFY THIS FILE, IT IS GENERATED AUTOMATICALLY FROM SOURCES
-- Complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "ALTER EXTENSION cdb_dataservices_server UPDATE TO '0.14.1'" to load this file. \quit

-- HERE goes your code to upgrade/downgrade
CREATE OR REPLACE FUNCTION cdb_dataservices_server._cdb_mapzen_route_with_waypoints(
  username TEXT,
  orgname TEXT,
  waypoints geometry(Point, 4326)[],
  mode TEXT,
  options text[] DEFAULT ARRAY[]::text[],
  units text DEFAULT 'kilometers')
RETURNS cdb_dataservices_server.simple_route AS $$
  import json
  from cartodb_services.mapzen import MapzenRouting, MapzenRoutingResponse
  from cartodb_services.mapzen.types import polyline_to_linestring
  from cartodb_services.metrics import QuotaService
  from cartodb_services.tools import Coordinate
  from cartodb_services.tools import Logger,LoggerConfig

  redis_conn = GD["redis_connection_{0}".format(username)]['redis_metrics_connection']
  user_routing_config = GD["user_routing_config_{0}".format(username)]

  plpy.execute("SELECT cdb_dataservices_server._get_logger_config()")
  logger_config = GD["logger_config"]
  logger = Logger(logger_config)

  quota_service = QuotaService(user_routing_config, redis_conn)
  if not quota_service.check_user_quota():
    raise Exception('You have reached the limit of your quota')

  try:
    client = MapzenRouting(user_routing_config.mapzen_api_key, logger)

    if not waypoints or len(waypoints) < 2:
      logger.info("Empty origin or destination")
      quota_service.increment_empty_service_use()
      return [None, None, None]

    waypoint_coords = []
    for waypoint in waypoints:
      lat = plpy.execute("SELECT ST_Y('%s') AS lat" % waypoint)[0]['lat']
      lon = plpy.execute("SELECT ST_X('%s') AS lon" % waypoint)[0]['lon']
      waypoint_coords.append(Coordinate(lon,lat))

    resp = client.calculate_route_point_to_point(waypoint_coords, mode, options, units)
    if resp and resp.shape:
      shape_linestring = polyline_to_linestring(resp.shape)
      if shape_linestring:
        quota_service.increment_success_service_use()
        return [shape_linestring, resp.length, resp.duration]
      else:
        quota_service.increment_empty_service_use()
        return [None, None, None]
    else:
      quota_service.increment_empty_service_use()
      return [None, None, None]
  except BaseException as e:
    import sys
    quota_service.increment_failed_service_use()
    logger.error('Error trying to calculate mapzen routing', sys.exc_info(), data={"username": username, "orgname": orgname})
    raise Exception('Error trying to calculate mapzen routing')
  finally:
    quota_service.increment_total_service_use()
$$ LANGUAGE plpythonu SECURITY DEFINER;