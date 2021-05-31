# Nivel1.gd

extends Node2D

onready var food = preload("res://nut.tscn")
onready var level_score = 0

func _ready():
	# warning-ignore:return_value_discarded
	$player.connect("falling", Globals, "end_level")
	# warning-ignore:return_value_discarded
	Globals.connect("game_over", self,  "end_level")
	Globals.score = 0
	start_food_timer()

func start_food_timer():
	$food_timer.set_wait_time(rand_range(5, 25)/10.0)
	$food_timer.start()

func _on_food_timer_timeout():
	spawn_food()
	start_food_timer()

func spawn_food():
	var g = food.instance()
	$food_container.add_child(g)
	g.connect("stored", self, "_on_food_grab")
	var x = 0
	if randf() < 0.5:
		x = rand_range(50, Globals.screenMidW - 70)
	else:
		x = rand_range(Globals.screenMidW + 70, Globals.screenW - 50)
	g.set_position(Vector2(x, 0))

func _on_food_grab():
	level_score += 10
	Globals.score += 10
	$food.play()

func end_level():
	$food_timer.stop()
	# level_score ?
	# $Menu.visible = true

#func _on_Menu_id_pressed(id):
#	var root = get_tree()
#	if not root.paused: return
#	match id:
#		0:
#			Globals.level += 1
#			# warning-ignore:return_value_discarded
#			root.change_scene("res://Nivel2.tscn")
#		1:
#			if Globals.lives <= 1: return
#			Globals.score -= level_score
#			level_score = 0
#			Globals.lives -= 1
#			# warning-ignore:return_value_discarded
#			root.reload_current_scene()
#		2:
#			# warning-ignore:return_value_discarded
#			root.quit()
