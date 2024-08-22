class_name Level
extends Resource

var shapes: Array[Shape]
const grid_size = 32
var snap_grid_pixels
var container_edge_size
var number
var flavor_text

static func create(_shapes: Array[Shape], n, flavor) -> Level:
  var level = Level.new()
  level.flavor_text = flavor
  level.snap_grid_pixels = int(Cs.CONTAINER_EDGE_SIZE / grid_size)
  level.number = n
  level.container_edge_size = int(Cs.CONTAINER_EDGE_SIZE / grid_size) * grid_size
  level.shapes = _shapes
  return level


## RANDOM LEVEL GENERATOR
static func create_random(_snap_grid_pixels, _grid_size, breakpoints = 20):
  var level = Level.new()
  level.snap_grid_pixels = _snap_grid_pixels
  level.grid_size = _grid_size
  level.container_edge_size = _snap_grid_pixels * _grid_size

  var edges = []
  var points = []
  var adjacency = {}
  
  var corners = [
Vector2i(0, level.container_edge_size),
Vector2i(0, 0),
Vector2i(level.container_edge_size, 0),
Vector2i(level.container_edge_size, level.container_edge_size)]

  for i in range(corners.size()):
    # only add edge once for border cuz they border only one polygon
    var neighbor = corners[(i - 1 + corners.size()) % corners.size()]
    adjacency[corners[i]] = [neighbor]
    edges.append([corners[i], neighbor])
    points.append_array(corners)


  # Select random points on the grid to break the square from
  for i in range(breakpoints):
    var x = randi_range(0, level.container_edge_size / 4)
    var y = randi_range(0, level.container_edge_size / 4)
    var point = Vector2i(x * level.snap_grid_pixels * 4, y * level.snap_grid_pixels * 4)
    var too_close = false
    for p in points:
      if point.distance_to(p) < level.snap_grid_pixels * 2:
        too_close = true
        break
    if too_close:
      continue
    points.append(point)
    adjacency[point] = []

  # Connect points to other nearby points
  var bads = []
  for p: Vector2i in points:
    while adjacency[p].size() < 3:
      var closest = p
      var closest_dist = INF
      for other: Vector2i in points:
        if (other != p
        # and adjacency[other].size() < 5
        and not Cs.is_in_list(other, adjacency[p])
        and p.distance_to(other) < closest_dist
        and no_overlap([p, other], edges)
        and has_good_angles(p, other, adjacency[p], adjacency[other])):
            closest_dist = p.distance_to(other)
            closest = other
        if closest == p:
          if adjacency[p].size() < 2:
            bads.append(p)
          break
        adjacency[p].append(closest)
        adjacency[closest].append(p)
        edges.append([p, closest])
        edges.append([closest, p])
  
  # Remove bad (non-polygon) points
  while bads:
    var bad = bads.pop_front()
    points.erase(bad)
    var to_be_removed = []
    for edge in edges:
      if edge[0] == bad or edge[1] == bad:
        var other
        if edge[0] == bad:
          other = edge[1]
        if edge[1] == bad:
          other = edge[0]
        to_be_removed.append(edge)
        adjacency[other].erase(bad)
        if adjacency[other].size() < 2:
          bads.append(other)
    for edge in to_be_removed:
      remove_from_edges(edge, edges)
  
  # Algorithm outsourced from Osman Ltd for 30% of the revenue share
  # Extract polygons from edges by randomly selecting unvisited edges 
  # and traveling to the next smallest angled edge
  while edges:
    var edge = edges.pop_front()
    adjacency[edge[0]].erase(edge[1])
    var start_point = edge[0]
    var polygon = []
    while true:
      polygon.append(edge[0])
      if edge[1] == start_point:
        break
      var A = edge[0]
      var B = edge[1]
      var C
      var smallest_angle = INF
      for point in adjacency[B]:
        if point == A:
          continue
        var angle = rad_to_deg(Vector2(A - B).angle_to(Vector2(point - B)))
        if angle < 0:
          angle += 360
        if angle < smallest_angle:
          smallest_angle = angle
          C = point
        edge = [B, C]
        remove_from_edges(edge, edges)
        adjacency[B].erase(C)
    level.polygons.append(polygon)

static func remove_from_edges(edge, edges):
  var k = -1
  for i in range(edges.size()):
    if edge[0] == edges[i][0] and edge[1] == edges[i][1]:
      k = i
      break
  if k >= 0:
    edges.remove_at(k)

static func no_overlap(line, lines):
  for edge in lines:
    var neighbors = false
    for i in range(2):
      for j in range(2):
        if line[i] == edge[j]:
          neighbors = true
    if neighbors:
      continue
    if Geometry2D.segment_intersects_segment(line[0], line[1], edge[0], edge[1]):
      return false
  return true

static func has_good_angles(pointA, pointB, neighborsA, neighborsB) -> bool:
  for pointC in neighborsA:
    var vectorB: Vector2 = pointB - pointA
    var vectorC: Vector2 = pointC - pointA
    var angle = abs(rad_to_deg(vectorB.angle_to(vectorC)))
    if angle < 30:
      return false
  
  for pointC in neighborsB:
    var vectorA: Vector2 = pointA - pointB
    var vectorC: Vector2 = pointC - pointB
    var angle = abs(rad_to_deg(vectorA.angle_to(vectorC)))
    if angle < 20:
      return false
  return true
