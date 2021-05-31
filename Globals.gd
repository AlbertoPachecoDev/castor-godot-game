# Globals.gd

extends Node2D

onready var music_off = preload("res://art/music-off.png")
onready var music_on = preload("res://art/music-on.png")
onready var pause = preload("res://art/pause.png")
onready var play = preload("res://art/play.png")

onready var level_txt  = $HUD/level
onready var score_txt  = $HUD/score
onready var time_txt   = $HUD/time
onready var vidas_txt  = $HUD/vidas
onready var lives = 3

var screenH
var screenW
var screenMidW
var level = 1
var score = 0
const MAX_LEVEL = 4

signal game_over

func _ready():
	var screensize = get_viewport_rect().size
	screenH = screensize.y
	screenW = screensize.x
	screenMidW = screenW / 2
	restart()
	# Important: Shown current scene nodes
	z_index = 1

func _process(_delta):
	level_txt.set_text("Level: %d" % level)
	score_txt.set_text("Score: %d" % score)
	vidas_txt.set_text("Lifes: %d" % lives)
	time_txt.set_text ( "Left: %d" % $game_timer.get_time_left())

"""
func _input(event):
	if event is InputEventKey and event.pressed:
		# Get activated by number-key
		match event.scancode:
			KEY_1:
				_on_Continue_pressed()
			KEY_2:
				_on_GoBack_pressed()
			KEY_3:
				_on_Quit_pressed()
"""
				
func restart(nuevo=true):
	$Buttons/Continue.visible = false
	$Buttons/GoBack.visible = false
	$Buttons/Quit.visible = false
	#set_process_input(false)
	$game_timer.start() 
	$music.play()
	randomize()
	if nuevo:
		lives = 3
	set_process(true)
	get_tree().paused = false

func end_level():
	if level < MAX_LEVEL:
		$Buttons/Continue.visible = true
	$Buttons/GoBack.visible = true
	$Buttons/Quit.visible = true
	$music.stop()
	$end.play()
	emit_signal("game_over")
	get_tree().paused = true
	#set_process_input(true)

func _on_game_timer_timeout():
	end_level()
	
func change_level():
	var root = get_tree()
	level += 1
	if level <= MAX_LEVEL: 
		# warning-ignore:return_value_discarded
		root.change_scene("res://Nivel"+str(level)+".tscn")
		restart()
	#else:
	#	root.quit()

func add_time(secs):
	var t = $game_timer.get_time_left() + secs
	$game_timer.stop()
	$game_timer.set_wait_time(t)
	$game_timer.start() 

func dec_lifes():
	lives -= 1
	if lives <= 0:
		end_level()

func _on_Music_pressed():
	if $music.playing:
		$music.stop()
		$Buttons/Music.set_texture(music_off)
	else:
		$music.play()
		$Buttons/Music.set_texture(music_on)

# Note: set Pause Mode = Process inside Pause Node
func _on_Pause_pressed():
	var root= get_tree()
	if root.paused:
		$Buttons/Pause.set_texture(pause)
		root.paused = false
	else:
		$Buttons/Pause.set_texture(play)
		root.paused = true

func _on_Continue_pressed():
	change_level()

func _on_GoBack_pressed():
	if Globals.lives <= 1: return
	lives -= 1
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	restart(false)

func _on_Quit_pressed():
	get_tree().quit()
