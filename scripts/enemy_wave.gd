extends Node2D

var enemy_scene: PackedScene
@onready var number: int
var enemies_spawned = 0
@onready var time_btw_enemies: float
@onready var spawn = $SpawnPoints/Marker2D
@onready var enemy_path = $Path2D
@onready var btw_timer = $TimerBetweenEnemies


func _ready():
	btw_timer.start(time_btw_enemies)
	spawn_enemy()


func _process(delta):
	for container in enemy_path.get_children():
		container.progress_ratio += 0.3 * delta
	var enemies_left = false
	for child in enemy_path.get_children():
		if child.get_children():
			enemies_left = enemies_left\
			or child.get_child(0).is_in_group("enemies")
	if enemies_spawned >= number and not enemies_left:
		queue_free()


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
