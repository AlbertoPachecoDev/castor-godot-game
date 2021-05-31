# nut.gd

extends RigidBody2D

signal stored

onready var scale1 = $sprite.get_scale()
onready var scale2 = scale1 * 1.5 
onready var id = get_shape_owners()[0]

func _ready():
	contact_monitor = true
	contacts_reported = 1
	$effect.interpolate_property($sprite, 'scale', \
		scale1, scale2, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$effect.interpolate_property($sprite, 'modulate:a', \
		1, 0, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_VisibilityNotifier2D_screen_exited():
	if position.x > 400 and position.x < 600:
		emit_signal("stored")
	queue_free()

func _on_Timer_timeout():
	shape_owner_clear_shapes(id)
	$effect.start()

func _on_effect_tween_all_completed():
	if position.y < 464:
		queue_free()	

func _on_nut_body_entered(body):
	var collider = body.get_name()
	if collider.left(4) == "piso":
		if not $hit.playing:
			$hit.play(0.2)
		$aninut.play("roten")
	elif collider == "player":
		$grab.play()
