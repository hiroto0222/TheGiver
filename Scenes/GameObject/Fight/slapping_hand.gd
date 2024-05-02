extends Node2D

signal ended

@onready var hand_sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

var target_pos_x: float = 640
var target_pos_y: float = 360
var speed := 3500
var target_pos: Vector2

var init_pos := Vector2(1600, 360)
var slapped := false
var move_back := false
var finished := false


func _ready() -> void:
	print("slapping_hand target_pos_x: ", target_pos_x)
	print("slapping_hand target_pos_y: ", target_pos_y)
	target_pos = Vector2(target_pos_x, target_pos_y)
	timer.timeout.connect(on_timer_timeout)
	hand_sprite.position = init_pos


func _process(delta: float) -> void:
	if finished:
		return

	if !slapped:
		var dir := (target_pos - hand_sprite.position).normalized()
		var move_distance := speed * delta
		hand_sprite.position += dir * min(move_distance, (target_pos - hand_sprite.position).length())

	if hand_sprite.position == target_pos and !slapped:
		PlayerState.decrease_health(10)
		timer.start()
		slapped = true

	if move_back:
		var dir := (init_pos - hand_sprite.position).normalized()
		var move_distance := 500 * delta
		hand_sprite.position += dir * min(move_distance, (init_pos - hand_sprite.position).length())

	if hand_sprite.position == init_pos and move_back:
		finished = true
		ended.emit()


func on_timer_timeout() -> void:
	move_back = true
