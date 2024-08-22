class_name Shape
extends Resource

static func v(poly) -> Array[Vector2i]:
  var p: Array[Vector2i] = []
  for point in poly:
    p.append(Vector2i(point[0] * 4, point[1] * 4))
  return p

var polygon: Array[Vector2i]
var color
var scale
var position
var rotation

# position in grid coordinates. will be multiplied by level.snap_grid_pixels later
func _init(poly, c, s: float = 1., p = Vector2i(0, 0), r = 0):
  polygon = v(poly)
  color = c
  scale = s
  position = p
  rotation = r

func to_polygon() -> Polygon2D:
  var poly = Polygon2D.new()
  poly.polygon = polygon.duplicate()
  poly.color = color
  return poly
