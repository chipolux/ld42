extends Button


var pixel_w
var pixel_h
var pixels = [
	Vector2(3, 11),
	Vector2(4, 10),
	Vector2(4, 11),
	Vector2(4, 12),
	Vector2(5, 11),
	Vector2(5, 12),
	Vector2(5, 13),
	Vector2(6, 12),
	Vector2(6, 13),
	Vector2(6, 14),
	Vector2(7, 13),
	Vector2(7, 14),
	Vector2(7, 15),
	Vector2(8, 12),
	Vector2(8, 13),
	Vector2(8, 14),
	Vector2(9, 11),
	Vector2(9, 12),
	Vector2(9, 13),
	Vector2(10, 10),
	Vector2(10, 11),
	Vector2(10, 12),
	Vector2(11, 9),
	Vector2(11, 10),
	Vector2(11, 11),
	Vector2(12, 8),
	Vector2(12, 9),
	Vector2(12, 10),
	Vector2(13, 7),
	Vector2(13, 8),
	Vector2(13, 9),
	Vector2(14, 6),
	Vector2(14, 7),
	Vector2(14, 7),
	Vector2(14, 8),
	Vector2(15, 5),
	Vector2(15, 6),
	Vector2(15, 7),
	Vector2(16, 6),
]


func _ready():
	pixel_w = rect_size.x / 20
	pixel_h = rect_size.y / 20

func _draw():
	var color
	if disabled:
		color = Color("#999999")
	else:
		color = Color("#ffffff")
	for pixel in pixels:
		draw_rect(Rect2(pixel * pixel_w, Vector2(pixel_w, pixel_h)), color)