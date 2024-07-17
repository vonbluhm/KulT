extends Node2D

var enemy_scene: PackedScene
@onready var number = 3
var enemies_spawned = 0
var enemy_speed: int
var increment: float
@onready var enemy_path = $Path2D
@onready var container = $Path2D/PathFollow2D
@onready var spawn = $Path2D/PathFollow2D/SpawnPoints
var path_length: float


func _ready():
	enemy_speed = 250
	enemy_path.curve.set_point_position(1, \
	Vector2(0, -1.15 * get_viewport_rect().size.y))
	path_length = enemy_path.curve.get_baked_length()
	increment = enemy_speed/path_length
	spawn_enemy()


func _process(_delta):
	var enemies_left = false
	for child in container.get_children():
		enemies_left = enemies_left\
		or child.is_in_group("enemies")
	if enemies_spawned >= number and not enemies_left:
		queue_free()


func _physics_process(delta):
	container.progress_ratio += \
	delta * increment


func spawn_enemy():
	for idx in range(number):
		var e = enemy_scene.instantiate()
		spawn.get_child(idx).add_child(e)
