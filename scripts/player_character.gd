extends CharacterBody2D


const SPEED = 300.0
var shot_cd = false

@export var time_btw_shots = 0.2
@onready var aim_vector = Vector2.UP
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var bullet_origin_point = $BulletOriginPoint
@export var bullet_scenes: Array[PackedScene] = []
signal player_shot_fired
signal aim_activated
signal strike_started
signal player_downed

var charging_up = false
var charging_time = 0.0
@export var minimal_chrg_threshold = 0.5
@export var max_chrg_threshold = 1.5
@export var critical_chrg_threshold = 3
var striking = false
var strike_dir = Vector2.UP
var strike_time = 0.0


func _ready():
	add_to_group("player")


func _process(delta):
	aim_vector = Vector2(\
	Input.get_axis("aim_left", "aim_right"),\
	Input.get_axis("aim_up", "aim_down"))
	if aim_vector:
		aim_vector.normalized()
		aim_activated.emit(aim_vector.angle())
		if not (charging_up or striking):
			if !shot_cd:
				shot_cd = true
				shoot()
				await get_tree().create_timer(time_btw_shots).timeout
				shot_cd = false
	
	if Input.is_action_just_pressed("charge") and not striking:
		charging_up = true
		charging_time = 0
	if charging_up:
		charging_time += delta
		if Input.is_action_just_released("charge") or\
		charging_time >= critical_chrg_threshold:
			charging_up = false
			striking = (charging_time >= minimal_chrg_threshold)
		if striking:
			strike_started.emit()
	elif striking:
		strike_time -= delta
		if strike_time <= 0:
			striking = false
			strike_time = 0
			velocity = velocity.normalized() * SPEED


func _physics_process(delta):
	var direction = Vector2.ZERO
	var momentum_fadeout = 2 * delta
	direction = Vector2(\
	Input.get_axis("move_left", "move_right"),\
	Input.get_axis("move_up", "move_down"))
	if charging_up:
		velocity = Vector2.ZERO
	if striking:
		velocity = strike_dir * 3 * SPEED
	if not (charging_up or striking):
		if direction:
			if direction.length() > 1:
				direction = direction.normalized()
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, momentum_fadeout * SPEED)
			velocity.y = move_toward(velocity.y, 0, momentum_fadeout * SPEED)

	
	move_and_slide()
	global_position = global_position.clamp(\
	Vector2.ZERO, get_viewport_rect().size\
	)
	
	global_position = global_position.round()


func shoot():
	player_shot_fired.emit(bullet_scenes[0],\
	bullet_origin_point.global_position,\
	aim_vector)


func take_damage():
	player_downed.emit()
	queue_free()


func _on_tree_entered():
	var ANIMATED_SPRITE = $AnimatedSprite2D
	ANIMATED_SPRITE.play("idle")


func _on_aim_activated(angle):
	global_rotation = angle + 0.5 * PI


func _on_strike_started():
	strike_time = 0.6 * charging_time if charging_time < \
	max_chrg_threshold else 0.6 * max_chrg_threshold
	var direction = Vector2(Input.get_axis("move_left", "move_right"),\
	Input.get_axis("move_up", "move_down"))
	if direction:
		strike_dir = direction.normalized()
	else:
		strike_dir = Vector2(sin(global_rotation), -cos(global_rotation))
