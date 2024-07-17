extends Area2D


@export var speed = 800
var direction = Vector2.ZERO


func _ready():
	direction = Vector2.from_angle(global_rotation)


func _physics_process(delta):
	global_translate(direction * speed * delta) 


func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player") and not body.striking:
		body.take_damage()
		queue_free()
	elif body.striking:
		queue_free()
