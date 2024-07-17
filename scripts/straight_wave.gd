extends Node2D

var enemy_scene: PackedScene
@onready var number: int
var enemies_spawned = 0
var enemy_speed: int
@onready var time_btw_enemies: float
@onready var spawn = $SpawnPoints/Marker2D
@onready var enemy_path = $Path2D
var path_length: float
var increment: float
@onready var btw_timer = $TimerBetweenEnemies


func _ready():
	enemy_path.curve.set_point_position(1, \
	Vector2(0, -1.15 * get_viewport_rect().size.y))
	btw_timer.start(time_btw_enemies)
	enemy_speed = 250
	path_length = enemy_path.curve.get_baked_length()
	increment = enemy_speed/path_length
	spawn_enemy()


func _process(_delta):
	var enemies_left = false
	for child in enemy_path.get_children():
		if child.get_children():
			enemies_left = enemies_left\
			or child.get_child(0).is_in_group("enemies")
	if enemies_spawned >= number and not enemies_left:
		queue_free()


func _physics_process(delta):
	for container in enemy_path.get_children():
		container.progress_ratio += \
		delta * increment


func spawn_enemy():
	var e = enemy_scene.instantiate()
	var container = PathFollow2D.new()
	enemy_path.add_child(container)
	container.add_child(e)
	enemies_spawned += 1
	
	
func _on_timer_between_enemies_timeout():
	if enemies_spawned >= number:
		btw_timer.stop()
	else:
		spawn_enemy()
