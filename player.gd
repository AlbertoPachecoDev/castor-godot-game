# player.gd

extends KinematicBody2D

const ACCEL = 1200
const MAX_SPEED = 500
const FRICTION = -300
const GRAVITY = 1000
const JUMP_SPEED = -600
const MIN_JUMP = -100

signal falling

onready var ground_ray = $"ground_ray"

var acc = Vector2()
var vel = Vector2()

var anim = 'idle'

func _ready():
	set_physics_process(true)
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_up") and ground_ray.is_colliding():
		vel.y = JUMP_SPEED
	if event.is_action_released("ui_up"):
		vel.y = clamp(vel.y, MIN_JUMP, vel.y)

func _physics_process(delta):
	acc.y = GRAVITY
	acc.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	# avoid player going out-of-limits
	if acc.x > 0 and position.x > 1020:
		acc.x = -1
	elif acc.x < 0 and position.x < 5:
		acc.x = 1
	acc.x *= ACCEL
	if acc.x == 0:
		acc.x = vel.x * FRICTION * delta
	vel += acc * delta
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	var collision = move_and_collide(vel * delta)
	if collision:
		var objcolname = collision.collider.get_name()
		# end-level if colision-object-name starts with "end" (platform)
		vel = vel.slide(collision.normal)
		# warning-ignore:return_value_discarded
		move_and_slide(vel)
		if objcolname.left(3) == "end":
			# continue after some delay
			yield(get_tree().create_timer(0.5), "timeout")
			# ToDo: Add Tween effect
			emit_signal("falling")
			queue_free() # BUG

	if vel.y > 200:
		anim = 'fall'
	elif abs(vel.x) < 5:
		vel.x = 0
		anim = 'idle'
	elif abs(vel.y) > 5:
		anim = 'jump'
	else:
		anim = 'walk'
	if vel.x >= 5:
		$sprite.set_flip_h(false)
	elif vel.x < -5:
		$sprite.set_flip_h(true)
	$mover.play(anim)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("falling")
	queue_free()
