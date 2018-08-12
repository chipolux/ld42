extends Node


onready var paint_panel = get_node("paint_panel")
onready var world = get_node("world")
onready var water_bar = get_node("water_bar")
onready var nature_bar = get_node("nature_bar")
onready var food_bar = get_node("food_bar")
onready var city_bar = get_node("city_bar")

var tile_size = 100
var tile_position
var tiles = {}
var freeplay = false

var water_counts = {}
var nature_counts = {}
var food_counts = {}
var city_counts = {}
var base_water = 20
var base_nature = 18
var base_food = 15
var base_city = 10
var desired_water = 10
var desired_nature = 10
var desired_food = 5
var desired_city = 3
var total_water = base_water
var total_nature = base_nature
var total_food = base_food
var total_city = base_city


func _ready():
	get_node("timer").connect("timeout", self, "adjust_desires")
	paint_panel.connect("done_painting", self, "painting_finished")
	water_bar.set_color(paint_panel.WATER)
	nature_bar.set_color(paint_panel.NATURE)
	food_bar.set_color(paint_panel.FOOD)
	city_bar.set_color(paint_panel.CITY)
	update_progress()
	start_painting(Vector2(350, 350))

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and not paint_panel.visible:
		start_painting(event.position)
	if event is InputEventKey and event.pressed and event.scancode == KEY_F:
		print("TOGGLING FREEPLAY")
		freeplay = not freeplay
		paint_panel.freeplay = freeplay
	if event is InputEventKey and event.pressed and event.scancode == KEY_H:
		print("TOGGLING PROGRESS BARS")
		water_bar.visible = not water_bar.visible
		nature_bar.visible = not nature_bar.visible
		food_bar.visible = not food_bar.visible
		city_bar.visible = not city_bar.visible

func start_painting(position):
	tile_position = Vector2(floor(position.x / tile_size), floor(position.y / tile_size)) * tile_size
	if tiles.has(tile_position) and not freeplay:
		return
	world.rect_scale = Vector2(4, 4)
	world.rect_position = -Vector2(tile_position.x - (tile_size / 2), tile_position.y - (tile_size / 2)) * 4
	paint_panel.clear_panel()
	paint_panel.show()

func painting_finished():
	var tr = TextureRect.new()
	tr.texture = paint_panel.texture
	tr.expand = true
	tr.rect_size = Vector2(tile_size, tile_size)
	tr.rect_position = tile_position
	tiles[tile_position] = tr
	water_counts[tile_position] = paint_panel.water_total
	nature_counts[tile_position] = paint_panel.nature_total
	food_counts[tile_position] = paint_panel.food_total
	city_counts[tile_position] = paint_panel.city_total
	world.add_child(tr)
	world.rect_scale = Vector2(1, 1)
	world.rect_position = Vector2(0, 0)
	paint_panel.hide()
	calculate_totals()
	update_progress()

func calculate_totals():
	total_water = base_water
	for value in water_counts.values():
		total_water += value
	total_nature = base_nature
	for value in nature_counts.values():
		total_nature += value
	total_food = base_food
	for value in food_counts.values():
		total_food += value
	total_city = base_city
	for value in city_counts.values():
		total_city += value

func adjust_desires():
	var rate = max(tiles.size() / 64, 0.01)
	desired_water += (10 * rate)
	desired_nature += (8 * rate)
	desired_food += (6 * rate)
	desired_city += (4 * rate)
	update_progress()

func update_progress():
	water_bar.set_progress(desired_water, total_water)
	nature_bar.set_progress(desired_nature, total_nature)
	food_bar.set_progress(desired_food, total_food)
	city_bar.set_progress(desired_city, total_city)
	
	if desired_water > total_water:
		return game_over()
	if desired_nature > total_nature:
		return game_over()
	if desired_food > total_food:
		return game_over()
	if desired_city > total_city:
		return game_over()

func game_over():
	print("game over")