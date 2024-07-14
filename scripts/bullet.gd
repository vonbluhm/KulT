extends Area2D


@export var speed = 800
var direction = Vector2.ZERO


func _ready():
	pass


func _physics_process(delta):
	global_translate(direction * speed * delta) 


func _on_visible_on_screen_notifier_2d_screen_exited():
	await 0.1
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage()
	queue_free()
