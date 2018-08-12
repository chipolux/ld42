extends Panel


signal done_painting

export(Color) var WATER = Color("#0087BD")
export(Color) var NATURE = Color("#009F6B")
export(Color) var FOOD = Color("#D2B55B")
export(Color) var CITY = Color("#747474")
export(int) var COLS = 20
export(int) var ROWS = 20

onready var water_button = get_node("water_button")
onready var nature_button = get_node("nature_button")
onready var food_button = get_node("food_button")
onready var city_button = get_node("city_button")
onready var save_button = get_node("save_button")

var freeplay = false
var is_drawing = false
var pixel_w
var pixel_h
var pixels = {}
var current_color
var texture = ImageTexture.new()
var water_total = 0
var nature_total = 0
var food_total = 0
var city_total = 0


func _ready():
	pixel_w = rect_size.x / COLS
	pixel_h = rect_size.y / ROWS
	water_button.color = WATER
	water_button.connect("pressed", self, "change_color", [WATER])
	nature_button.color = NATURE
	nature_button.connect("pressed", self, "change_color", [NATURE])
	food_button.color = FOOD
	food_button.connect("pressed", self, "change_color", [FOOD])
	city_button.color = CITY
	city_button.connect("pressed", self, "change_color", [CITY])
	save_button.disabled = not freeplay and pixels.size() != (ROWS * COLS)
	change_color(WATER)

func _input(event):
	event = make_input_local(event)
	if event is InputEventMouseButton and event.is_pressed():
		is_drawing = true
		color_pixel(event.position)
	elif event is InputEventMouseButton:
		is_drawing = false
	elif event is InputEventMouseMotion and is_drawing:
		color_pixel(event.position)

func _draw():
	for pixel in pixels.keys():
		var rect = Rect2(
			Vector2(pixel.x * pixel_w, pixel.y * pixel_h),
			Vector2(pixel_w, pixel_h)
		)
		draw_rect(rect, pixels[pixel])

func _update_button(button, color):
	if current_color == color and button.rect_position.x != -70:
		button.rect_position.x = -70
	elif current_color != color and button.rect_position.x != -60:
		button.rect_position.x = -60

func color_pixel(position):
	var x_valid = position.x < rect_size.x and position.x > 0
	var y_valid = position.y < rect_size.y and position.y > 0
	if x_valid and y_valid:
		var pixel = Vector2(floor(position.x / pixel_w), floor(position.y / pixel_h))
		if current_color:
			pixels[pixel] = current_color
		else:
			pixels.erase(pixel)
		save_button.disabled = not freeplay and pixels.size() != (ROWS * COLS)
		update()

func change_color(color):
	current_color = color
	_update_button(water_button, WATER)
	_update_button(nature_button, NATURE)
	_update_button(food_button, FOOD)
	_update_button(city_button, CITY)

func clear_panel():
	current_color = WATER
	pixels = {}
	texture = ImageTexture.new()
	is_drawing = false
	water_total = 0
	nature_total = 0
	food_total = 0
	city_total = 0
	save_button.disabled = not freeplay and pixels.size() != (ROWS * COLS)
	update()

func save_image():
	var image = Image.new()
	image.create(COLS, ROWS, false, Image.FORMAT_RGB8)
	image.lock()
	for pixel in pixels.keys():
		image.set_pixel(pixel.x, pixel.y, pixels[pixel])
		if pixels[pixel] == WATER:
			water_total += 1
		elif pixels[pixel] == NATURE:
			nature_total += 1
		elif pixels[pixel] == FOOD:
			food_total += 1
		elif pixels[pixel] == CITY:
			city_total += 1
	image.unlock()
	texture.create_from_image(image, 0)
	emit_signal("done_painting")