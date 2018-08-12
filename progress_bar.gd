extends Panel

var color
var bar

func _draw():
	if bar and color:
		draw_rect(bar, color)

func set_color(new_color):
	color = new_color
	update()

func set_progress(value, total):
	if total != 0:
		bar = Rect2(0.5, 0.5, min(((rect_size.x - 1) / total) * value, rect_size.x - 1), rect_size.y - 1)
	else:
		bar = Rect2(0.5, 0.5, rect_size.x - 1, rect_size.y - 1)
	update()