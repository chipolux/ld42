extends Button

var color

func _draw():
	if color:
		draw_rect(Rect2(5, 5, rect_size.x - 10, rect_size.y - 10), color)