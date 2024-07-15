extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_translate(\
	Vector2(sin(global_rotation), -cos(global_rotation))* 100 * delta)


func take_damage():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player") and not body.striking:
		body.take_damage()
	elif body.striking:
		take_damage()


func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(0.1).timeout
	queue_free()
