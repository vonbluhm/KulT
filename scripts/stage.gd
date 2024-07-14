extends Node

@onready var player = $PlayerCharacter
@onready var spawn_point = $SpawnPoint
@onready var bullet_container = $PlayerBulletContainer
@onready var enemy_container = $EnemyContainer
@export var enemy_scenes: Array[PackedScene] = []
@onready var enemy_spawning_timer = $Timer

func _ready():
	player.global_position = spawn_point.global_position
	player.player_shot_fired.connect(_on_player_shot_fired)


func _process(delta):
	pass


func spawn_enemy(id: int, pos: Vector2, rotation: float):
	var enemy_scene = enemy_scenes[id].instantiate()
	enemy_scene.global_position = pos
	enemy_scene.global_rotation = rotation
	enemy_container.add_child(enemy_scene)
	
	
func _on_player_shot_fired(scene: PackedScene, pos, direction):
	var bullet = scene.instantiate()
	bullet.global_position = pos
	bullet.global_rotation = direction.angle() + PI/2
	bullet.direction = direction.normalized()
	bullet.speed += (player.velocity.dot(bullet.direction))
	bullet_container.add_child(bullet)
	


func _on_timer_timeout():
	spawn_enemy(0, Vector2(300, 20), PI)
