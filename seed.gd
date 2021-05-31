extends RigidBody2D

signal enemy

func _ready():
	$effect.interpolate_property($sprite, 'scale', \
		1.0, 2.0, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$effect.interpolate_property($sprite, 'modulate:a', \
		1, 0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)

func _on_seed_body_entered(body):
	var collider = body.get_name()
	if collider.left(4) == "piso":
		$effect.start()
	elif collider.left(4) == "isla":
		$effect.start()
	elif collider == "player":
		$enemy.play()
		$effect.start()
		emit_signal("enemy")

func _on_effect_tween_all_completed():
	queue_free()
