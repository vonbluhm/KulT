extends Area2D

@export var hp = 3
#@export var speed = 200
signal destroyed


func _ready():
	add_to_group("enemies")


func _process(_delta):
	pass


func take_damage(amount):
	hp -= amount
	if hp <= 0:
		destroyed.emit()


func _on_destroyed():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player") and not body.striking:
		body.take_damage()
	elif body.striking:
		take_damage(10)


func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(0.1).timeout
	queue_free()
