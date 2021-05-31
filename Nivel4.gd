# Nivel4.gd

extends Node2D

onready var food = preload("res://nut4.tscn")
onready var enemy = preload("res://seed.tscn")
onready var level_score = 0

func _ready():
	# warning-ignore:return_value_discarded
	$player.connect("falling", Globals, "end_level")
	# warning-ignore:return_value_discarded
	Globals.connect("game_over", self,  "end_level")
	start_food_timer()

func start_food_timer():
	$food_timer.set_wait_time(rand_range(5, 15)/10.0)
	$food_timer.start()

func _on_food_timer_timeout():
	spawn_food()
	start_food_timer()

func _on_seed_timer_timeout():
	var g = enemy.instance()
	g.connect("enemy", Globals, "dec_lifes")
	g.set_position(Vector2(rand_range(50, Globals.screenW - 50), 0))
	$food_container.add_child(g)

func spawn_food():
	var g = food.instance()
	g.connect("eaten", self, "_on_food_eaten")	
	g.set_position(Vector2(rand_range(25, Globals.screenW - 25), 0))
	$food_container.add_child(g)

func _on_food_eaten():
	Globals.add_time(5)
	$food.play()
	level_score += 20
	Globals.score += 20

func end_level():
	$food_timer.stop()
