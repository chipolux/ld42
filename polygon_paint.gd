extends Node2D


const MIN_DISTANCE = 20
var is_drawing = false
var last_point = Vector2()
var current_shape = []
var shapes = []


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print("starting shape")
		is_drawing = true
		last_point = event.position
		current_shape.append(event.position)
		update()
	elif event is InputEventMouseButton:
		print("closing shape")
		is_drawing = false
		current_shape.append(current_shape[0])
		shapes.append(current_shape)
		last_point = Vector2()
		current_shape = []
		update()
	elif event is InputEventMouseMotion and is_drawing:
		if last_point.distance_to(event.position) > MIN_DISTANCE:
			print("new point")
			last_point = event.position
			current_shape.append(event.position)
			update()


func _draw():
	if len(current_shape) > 1:
		draw_polyline(current_shape, Color("#ff0000"), 4)
	for shape in shapes:
		if len(shape) > 1:
			draw_polygon(shape, [Color("#00ff00")])