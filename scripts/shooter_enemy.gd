extends Area2D

@export var hp = 1
@onready var muzzle = $Marker2D
@onready var bullet_scene = preload("res://scenes/enemy_straight_bullet.tscn")
var fired = false
signal destroyed


func _ready():
	add_to_group("enemies")


func _process(_delta):
	await get_tree().create_timer(0.5).timeout
	if not fired:
		shoot()


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.global_rotation = global_rotation
	get_tree().get_first_node_in_group("current_stage").enemy_BC.add_child(bullet)
	fired = true


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
