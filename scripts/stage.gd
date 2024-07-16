extends Node

@onready var player = $PlayerCharacter
@onready var spawn_point = $SpawnPoint
@onready var bullet_container = $PlayerBulletContainer
@onready var enemy_container = $EnemyContainer
@export var enemy_scenes: Array[PackedScene] = []
@export var wave_scenes: Array[PackedScene] = []
@onready var enemy_spawning_timer = $Timer
@onready var restart_button = $CanvasLayer/VBoxContainer/RestartButton
@onready var quit_button = $CanvasLayer/VBoxContainer/QuitButton


func _ready():
	player.global_position = spawn_point.global_position
	player.player_shot_fired.connect(_on_player_shot_fired)
	player.player_downed.connect(_on_player_downed)
	spawn_wave(0, 0, Vector2(400, -50), PI, 5, 2.0)


func _process(_delta):
	pass


func spawn_enemy(id: int, pos: Vector2, rotation: float):
	var enemy_scene = enemy_scenes[id].instantiate()
	enemy_scene.global_position = pos
	enemy_scene.global_rotation = rotation
	enemy_container.add_child(enemy_scene)
	
	
func spawn_wave(wave_id, enemy_id, pos, rotation, number, btw_time):
	var wave = wave_scenes[wave_id].instantiate()
	wave.enemy_scene = enemy_scenes[enemy_id]
	wave.global_position = pos
	wave.global_rotation = rotation
	wave.number = number
	wave.time_btw_enemies = btw_time
	enemy_container.add_child(wave)
	
	
func _on_player_shot_fired(scene: PackedScene, pos: Vector2, direction):
	var bullet = scene.instantiate()
	bullet.global_position = pos
	bullet.global_rotation = direction.angle() + PI/2
	bullet.direction = direction.normalized()
	bullet.speed += (player.velocity.dot(bullet.direction))
	bullet_container.add_child(bullet)


#func _on_timer_timeout():
	#spawn_enemy(0, Vector2(300, -50), PI)


func _on_player_downed():
	restart_button.visible = true
	quit_button.visible = true


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	get_tree().quit()
