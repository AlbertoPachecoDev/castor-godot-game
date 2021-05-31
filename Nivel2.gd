# Nivel2.gd

extends Node2D

onready var food = preload("res://nut2.tscn")
onready var level_score = 0

func _ready():
	# warning-ignore:return_value_discarded
	$player.connect("falling", Globals, "end_level")
	# warning-ignore:return_value_discarded
	# $player.connect("endisla", Globals, "end_level")
	start_food_timer()

#func change_font():
#	var font = DynamicFont.new()
#	var fdat = DynamicFontData.new()
#	fdat.font_path = "res://fonts/cave_font.ttf"
#	font.font_data = fdat
#	font.size = 16
#	font.use_filter = false
#	score_txt.add_font_override("font", font)
#	time_txt.add_font_override("font", font)

func start_food_timer():
	$food_timer.set_wait_time(rand_range(5, 25)/10.0)
	$food_timer.start()

func _on_food_timer_timeout():
	spawn_food()
	start_food_timer()

func spawn_food():
	var g = food.instance()
	$food_container.add_child(g)
	g.connect("catch", self, "_on_food_grab")
	var	x = rand_range(25, Globals.screenW - 25)
	g.set_position(Vector2(x, 0))

func _on_food_grab():
	level_score += 10
	Globals.score += 10
	$food.play()

func end_level():
	$food_timer.stop()
