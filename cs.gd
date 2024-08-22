extends Node

# SIZE CONSTANTS
const SCREEN_WIDTH = 1920
const SCREEN_HEIGHT = 1080
const CONTAINER_EDGE_SIZE = 1080 * 0.7

# COLOR CONSTANTS

static var UIGREEN1: Color = Color.html("#8EA604")
static var UIGREEN2: Color = Color.html("#333C02")

static var GREEN5: Color = Color.html("#3E470A")
static var GREEN4: Color = Color.html("#8EA604")
static var GREEN3: Color = Color.html("#536105")
static var GREEN2: Color = Color.html("#B9D904")
static var GREEN1: Color = Color.html("#D3ED40")
static var BLUE1: Color = Color.html("#F0FCFF")
static var BLUE2: Color = Color.html("#D9F9FF")
static var BLUE3: Color = Color.html("#CAF0F8")
static var BLUE4: Color = Color.html("#ACF1FF")
static var BLUE5: Color = Color.html("#A3E1ED")
static var BLUE6: Color = Color.html("#0083D4")
static var BLUE7: Color = Color.html("#0F5784")
static var SNOW1: Color = Color.SNOW
static var SNOW2: Color = Color.LIGHT_BLUE
static var PURPLE1: Color = Color.html("#BC40ED")
static var PURPLE2: Color = Color.html("#AD26E3")
static var PINK1: Color = Color.DEEP_PINK
static var YELLOW1: Color = Color.html("#FFD930")
static var YELLOW2: Color = Color.html("#FAB339")
static var YELLOW3: Color = Color.html("#D19630")
static var YELLOW4: Color = Color.html("#FFE15C")
static var RED1: Color = Color.html("#E82020")
static var RED2: Color = Color.html("#C91C1C")
static var RED3: Color = Color.html("#B01313")
static var BROWN: Color = Color.html("#520A00")
static var WHITE1: Color = Color.html("#CDCFC2")
static var WHITE2: Color = Color.html("#F3F9D0")
static var GRAY: Color = Color.html("#9D543D")

static var COLORS = [GREEN1, GREEN2, BLUE1, RED1, RED2, GRAY]

# SOUND
var sfx_value = 60
var bgm_value = 60
func _ready():
  SignalBus.sfx_changed.connect(_on_sfx_changed)
  SignalBus.bgm_changed.connect(_on_bgm_changed)
func _on_sfx_changed(value):
  sfx_value = value
func _on_bgm_changed(value):
  bgm_value = value


# UTILITY METHODS
func snap_to_grid(point: Vector2, snap_grid_pixels) -> Vector2i:
  return round(point / snap_grid_pixels) * snap_grid_pixels

func is_in_list(item, lst):
  for l in lst:
    if l == item:
      return true
  return false

func polygon_area(poly) -> float:
  var sum = 0
  for i in range(poly.size()):
    var a = poly[i]
    var b = poly[(i + 1) % poly.size()]
    sum += a[0] * b[1] - a[1] * b[0]
  return abs(sum) / 2

# LEVELS
 
# Volcano
static var LEVEL1: Level = Level.create([
  Shape.new([[0, 0], [4, 0], [4, 4], [3, 4], [0, 8]], BLUE4, 1, Vector2i(14, -1), 0),
  Shape.new([[4, 0], [8, 0], [8, 8], [4, 4]], BLUE3, 1, Vector2i(19, -1), 0),
  Shape.new([[0, 8], [8, 8], [4, 4], [3, 4]], GRAY, 1, Vector2i(19, 0), 0)],
  1,
  """\"Is that volcano about to erupt!?\"
  
  
  """)

# Heart
static var LEVEL2: Level = Level.create([
  Shape.new([[2, 3], [3, 2], [4, 3], [5, 2], [6, 3], [6, 4], [4, 6], [2, 4]], PINK1, 0.75, Vector2i(18, -2), 0),
  Shape.new([[0, 0], [5, 0], [2, 3], [0, 3]], BLUE2, 0.75, Vector2i(11, -4), 0),
  Shape.new([[0, 3], [0, 8], [4, 8], [4, 6], [2, 4], [2, 3]], BLUE3, 0.75, Vector2i(11, 2), 0),
  Shape.new([[8, 4], [6, 4], [4, 6], [4, 8], [8, 8]], BLUE5, 0.75, Vector2i(25, 2), 0),
  Shape.new([[8, 4], [8, 0], [5, 0], [3, 2], [4, 3], [5, 2], [6, 3], [6, 4]], BLUE4, 0.75, Vector2i(22, -7), 0)],
  2,
  """\"So much to love in the world!
  Isn't that true Mr. Wizard?\"
  
  """)

# Boat
static var LEVEL3: Level = Level.create([
  Shape.new([[0, 0], [4, 0], [4, 2], [2, 5], [0, 5]], BLUE4, 0.5, Vector2i(33, -10), 0),
  Shape.new([[8, 3], [8, 6], [5, 6]], BLUE6, 0.75, Vector2i(3, 7), -270),
  Shape.new([[0, 5], [2, 5], [3, 6], [8, 6], [8, 8], [0, 8]], BLUE7, 0.75, Vector2i(14, 11), 0),
  Shape.new([[4, 0], [8, 0], [8, 3], [6, 5], [4, 5]], BLUE3, 0.5, Vector2i(12, -10), 0),
  Shape.new([[4, 2], [4, 5], [2, 5]], YELLOW1, 1.5, Vector2i(21, 1), 0),
  Shape.new([[6, 5], [5, 6], [3, 6], [2, 5]], BROWN, 1.25, Vector2i(27, 9), 0)],
  3,
  """\"Thanks Mr. Wizard. 
  Now I can watch my boat sway
  on the sea. Such a beauty.
  Lucky to live in MagicLand!\"""")

# Desert
static var LEVEL4: Level = Level.create([
  Shape.new([[0, 0], [3, 0], [3, 1], [2, 1], [2, 2], [0, 4]], BLUE2, 1, Vector2i(12, 3), -360),
  Shape.new([[3, 0], [8, 0], [8, 4], [7, 4], [3, 2]], BLUE3, 0.5, Vector2i(16, 6), -180),
  Shape.new([[2, 1], [3, 1], [3, 2], [2, 2]], YELLOW1, 1.75, Vector2i(4, -14), 0),
  Shape.new([[0, 4], [2, 2], [3, 2], [7, 4], [3, 5]], BLUE4, 0.5, Vector2i(13, -9), -90),
  Shape.new([[0, 4], [0, 7], [3, 5]], YELLOW2, 0.5, Vector2i(18, 5), -90),
  Shape.new([[0, 7], [0, 8], [8, 8], [8, 4], [7, 4], [3, 5]], YELLOW3, 0.75, Vector2i(24, -2), -90)],
  4,
  """\"Whew, it's so hot out there.
  Don't forget to drink lots of water!\"
  
  """)

# Trees in Snow
static var LEVEL5: Level = Level.create([
  Shape.new([[0, 0], [3, 0], [1, 6], [0, 7]], SNOW2, 0.5, Vector2i(18, 10), 0),
  Shape.new([[0, 7], [0, 8], [1, 8], [3, 6], [1, 6]], BLUE1, 0.75, Vector2i(7, 3), -270),
  Shape.new([[1, 8], [3, 6], [5, 5], [7, 5], [8, 8]], SNOW1, 0.5, Vector2i(15, -13), -90),
  Shape.new([[3, 6], [2, 3], [5, 5]], BLUE2, 1.25, Vector2i(12, -18), -180),
  Shape.new([[2, 3], [1, 6], [3, 6]], GREEN4, 0.75, Vector2i(28, -10), 0),
  Shape.new([[6, 1], [5, 5], [7, 5]], GREEN3, 0.75, Vector2i(34, -8), -180),
  Shape.new([[8, 8], [8, 0], [6, 1], [7, 5]], BLUE3, 1, Vector2i(27, -6), -180),
  Shape.new([[3, 0], [8, 0], [6, 1], [5, 5], [2, 3]], BLUE4, 0.5, Vector2i(10, 1), -270)],
  5,
  """\"Brrr! Thanks for helping me
  out in such bad weather Mr. Wizard.
  I don't know what I would do without
  a window...\"""")

# Butterfly
static var LEVEL6: Level = Level.create([
  Shape.new([[1, 0], [8, 0], [7, 1], [4, 3], [1, 1]], GREEN1, 0.5, Vector2i(17, -7), -90),
  Shape.new([[0, 0], [1, 0], [1, 3], [2, 4], [0, 6]], GREEN2, 0.75, Vector2i(6, -7), -180),
  Shape.new([[1, 5], [0, 6], [0, 8], [4, 8], [3, 6], [2, 6]], GREEN3, 0.75, Vector2i(22, 0), 0),
  Shape.new([[4, 8], [3, 6], [4, 4], [5, 6], [6, 6], [7, 5], [8, 5], [8, 8]], GREEN4, 0.5, Vector2i(27, 12), 0),
  Shape.new([[8, 5], [7, 5], [6, 4], [7, 3], [7, 1], [8, 0]], GREEN5, 0.5, Vector2i(30, -2), 0),
  Shape.new([[1, 1], [1, 3], [2, 4], [1, 5], [2, 6], [3, 6], [4, 4], [4, 3]], PURPLE1, 0.75, Vector2i(23, -13), 90),
  Shape.new([[7, 1], [7, 3], [6, 4], [7, 5], [6, 6], [5, 6], [4, 4], [4, 3]], PURPLE2, 0.75, Vector2i(11, 10), -90)],
  6,
  """\"Oh my, a butterfly!
  Now I kinda wish my window was open
  so the butterfly could fly in...\"
  """)

# Goose
static var LEVEL7: Level = Level.create([
  Shape.new([[0, 0], [0, 3], [2, 3], [3, 2], [4, 2], [4, 0]], GREEN1, 0.75, Vector2i(22, 9), -180),
  Shape.new([[2, 3], [3, 2], [3, 3]], YELLOW1, 2, Vector2i(7, -16), -180),
  Shape.new([[3, 3], [3, 2], [4, 2], [4, 3]], WHITE2, 1.75, Vector2i(7, 2), 0),
  Shape.new([[4, 0], [8, 0], [6, 4], [4, 3]], GREEN2, 0.5, Vector2i(25, -16), -270),
  Shape.new([[8, 0], [6, 4], [8, 6]], GREEN3, 0.5, Vector2i(27, 1), -360),
  Shape.new([[8, 6], [7, 5], [6, 6], [6, 7], [5, 7], [5, 8], [8, 8]], GREEN4, 0.75, Vector2i(20, -3), 0),
  Shape.new([[5, 6], [6, 6], [6, 7], [5, 7]], YELLOW1, 0.75, Vector2i(11, -7), -90),
  Shape.new([[5, 8], [0, 8], [0, 5], [4, 5], [5, 6]], GREEN5, 0.25, Vector2i(22, 3), 0),
  Shape.new([[0, 3], [0, 5], [4, 5], [3, 3]], UIGREEN1, 0.5, Vector2i(21, -10), -270),
  Shape.new([[3, 3], [4, 3], [6, 4], [7, 5], [6, 6], [5, 6], [4, 5]], SNOW1, 0.75, Vector2i(10, 6), -270)],
  7,
  """\"Honk!
  Honk! Honk! Honk!
  Honk! Mr. Wizard. Honk! Honk!
  Honk.\"""")

# Flower
static var LEVEL8: Level = Level.create([
  Shape.new([[0, 0], [3, 2], [2, 3], [0, 3]], BLUE1, 0.5, Vector2i(30, 9), 0),
  Shape.new([[0, 0], [3, 2], [4, 2], [4, 0]], BLUE2, 0.75, Vector2i(17, 14), 90),
  Shape.new([[4, 0], [4, 4], [8, 2]], BLUE3, 0.5, Vector2i(33, 10), 90),
  Shape.new([[4, 0], [8, 0], [8, 2]], BLUE4, 0.75, Vector2i(33, -17), 0),
  Shape.new([[2, 3], [3, 2], [4, 2], [4, 4]], RED2, 0.75, Vector2i(7, -5), 180),
  Shape.new([[0, 3], [2, 3], [4, 4], [2, 5], [0, 8]], BLUE5, 1, Vector2i(19, -6), 0),
  Shape.new([[0, 8], [2, 5], [3, 6], [4, 6], [4, 8]], WHITE2, 0.5, Vector2i(9, 13), 360),
  Shape.new([[2, 5], [3, 6], [4, 6], [4, 4]], RED1, 0.5, Vector2i(23, 0), 270),
  Shape.new([[6, 3], [7, 4], [6, 5], [4, 4]], RED3, 1, Vector2i(24, -5), 270),
  Shape.new([[8, 2], [6, 3], [7, 4], [6, 5], [4, 4], [8, 8]], SNOW1, 0.75, Vector2i(7, 0), 0),
  Shape.new([[4, 4], [8, 8], [6, 8]], GREEN4, 0.5, Vector2i(17, 8), 90),
  Shape.new([[4, 4], [4, 8], [6, 8]], SNOW2, 0.75, Vector2i(3, -17), 90)],
  8,
  """\"What a view of the meadow!
  I wanna run out and smell all
  the wildflowers.\"
  """)

# Iceberg
static var LEVEL9: Level = Level.create([
  Shape.new([[0, 0], [2, 2], [4, 0]], WHITE2, 0.75, Vector2i(17, -14), -90),
  Shape.new([[0, 0], [2, 2], [0, 8]], BLUE1, 0.5, Vector2i(9, -16), 0),
  Shape.new([[0, 8], [2, 2], [2, 8]], SNOW2, 0.5, Vector2i(22, -4), -90),
  Shape.new([[4, 0], [2, 2], [6, 4]], BLUE2, 0.75, Vector2i(3, 6), -90),
  Shape.new([[4, 0], [8, 0], [6, 4]], WHITE2, 0.5, Vector2i(18, -17), 0),
  Shape.new([[2, 2], [2, 4], [6, 4]], BLUE5, 0.75, Vector2i(17, 13), -90),
  Shape.new([[2, 4], [2, 8], [8, 8]], BLUE3, 0.5, Vector2i(32, -8), -90),
  Shape.new([[2, 4], [6, 4], [8, 8]], BLUE4, 0.5, Vector2i(19, 5), -90),
  Shape.new([[8, 0], [6, 4], [8, 8]], SNOW1, 0.5, Vector2i(27, 7), 0)],
  9,
  """\"Uh Oh! I was trying to move my
  house into a tropical zone. Not an
  arctic one!\"""")

# Crown
static var LEVEL10: Level = Level.create([
  Shape.new([[0, 0], [3, 0], [1, 2], [0, 6]], WHITE2, 0.5, Vector2i(21, 11), -180),
  Shape.new([[1, 2], [3, 0], [5, 0], [5, 1], [3, 2], [2, 3]], BLUE1, 0.75, Vector2i(9, -10), -90),
  Shape.new([[1, 2], [0, 6], [1, 6]], SNOW1, 1, Vector2i(38, 15), 0),
  Shape.new([[1, 2], [2, 3], [3, 6], [1, 6]], YELLOW4, 1, Vector2i(7, 3), 0),
  Shape.new([[0, 6], [1, 6], [5, 7], [8, 8], [0, 8]], RED2, 0.5, Vector2i(17, -15), -180),
  Shape.new([[1, 6], [5, 7], [7, 6]], RED1, 0.5, Vector2i(17, 4), -270),
  Shape.new([[5, 7], [7, 6], [8, 4], [8, 8]], RED3, 0.75, Vector2i(9, 0), -90),
  Shape.new([[3, 6], [7, 2], [7, 6]], YELLOW3, 0.5, Vector2i(28, -19), -90),
  Shape.new([[7, 2], [8, 4], [7, 6]], BLUE4, 0.75, Vector2i(32, -12), 0),
  Shape.new([[6, 0], [8, 0], [8, 4]], BLUE3, 1, Vector2i(38, -19), 0),
  Shape.new([[5, 0], [6, 0], [7, 2], [6, 3], [5, 2]], SNOW2, 0.5, Vector2i(14, -13), -540),
  Shape.new([[3, 2], [5, 1], [5, 2], [4, 3]], BLUE2, 1, Vector2i(14, 7), -90),
  Shape.new([[3, 2], [4, 3], [3, 6], [2, 3]], YELLOW1, 1, Vector2i(33, 2), 0),
  Shape.new([[5, 2], [6, 3], [3, 6], [4, 3]], YELLOW2, 1, Vector2i(20, -6), 270)],
  10,
  """\"I am Queen Witch Lady Magic,
  Matriarch of MagicLand. As a thank
  you for your selfless window mending,
  I announce you Sir Mr. Wizard!\"""")

static var LEVELS = [LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5, LEVEL6, LEVEL7, LEVEL8, LEVEL9, LEVEL10]
