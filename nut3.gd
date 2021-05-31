# nut3.gd

extends RigidBody2D

signal stored
signal eaten

onready var scale1 = $sprite.get_scale()
onready var scale2 = scale1 * 1.2 
onready var id = get_shape_owners()[0]
onready var cracked = false
onready var piso = false

func _ready():
	contact_monitor = true
	contacts_reported = 1
	$effect.interpolate_property($sprite, 'scale', \
		scale1, scale2, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_VisibilityNotifier2D_screen_exited():
	if position.y < 1: # nut very high?
		return
	if position.x > 400 and position.x < 600:
		emit_signal("stored")
	queue_free()

# nut life span timer
func _on_Timer_timeout():
	shape_owner_clear_shapes(id)
	if not cracked:
		$effect.start()

func _on_effect_tween_all_completed():
	if not cracked:
		queue_free()	

# set contact-monitor = true
func _on_nut_body_entered(body):
	var collider = body.get_name()
	if collider.left(4) == "piso":
		if not $hit.playing:
			$hit.play(0.2)
		if not cracked:
			$aninut.play("roten")
		piso = true
	elif collider == "player":
		$grab.play()
		if not piso:	
			if cracked:
				$eat.play()
				emit_signal("eaten")
				queue_free()
			else:
				cracked = true
				$crack.play()
				$aninut.play("crack")
				$effect.start()
