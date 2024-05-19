extends CharacterBody2D
class_name FightApproachKeyInput

signal is_middle
signal destroyed
signal missed

@export var key_letter: String
@export var key_success_sounds: Array[AudioStreamWAV]

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var success_audio_player: AudioStreamPlayer = $Success
@onready var hit_audio_player: AudioStreamPlayer = $Hit
@onready var miss_audio_player: AudioStreamPlayer = $Miss

@onready var destroy_timer: Timer = $DestroyTimer

var key_idx := 0
var is_success := false
var is_check_middle := true
var is_pause_middle := false
var is_processed := false
var speed := 250.0
var y_speed := -200
const y_pos := 360


# map key letters to sprite paths
var sprite_paths := {
	"w": "res://Assets/Sprites/KeyInputs/w.png",
	"a": "res://Assets/Sprites/KeyInputs/a.png",
	"s": "res://Assets/Sprites/KeyInputs/s.png",
	"d": "res://Assets/Sprites/KeyInputs/d.png",
}


func _ready() -> void:
	add_to_group("key_input_layer")

	destroy_timer.timeout.connect(on_destroy_timer_timeout)

	position = Vector2(-50, y_pos)

	if key_letter in sprite_paths:
		var sprite_path: String = sprite_paths[key_letter]
		var texture := load(sprite_path)
		sprite_2d.texture = texture


func _process(delta: float) -> void:
	if is_pause_middle:
		return

	position.x += speed * delta
	if is_success:
		position.y += y_speed * delta

	if position.x > 1280 + 50:
		queue_free()
		destroyed.emit()

	if position.x >= 635 and position.x <= 645 and is_check_middle:
		position.x = 640
		is_middle.emit()
		is_check_middle = false


func key_pause_middle() -> void:
	is_pause_middle = true


func key_unpause_middle() -> void:
	is_pause_middle = false


func success() -> void:
	is_success = true

	# slow down
	speed = [-0.2, -0.5, 0.5, 0.2].pick_random() * speed
	y_speed = [-1, -0.5, 0.5, 1].pick_random() * speed

	sprite_2d.modulate = Color("#00b23b")

	success_audio_player.stream = key_success_sounds[mini(key_idx, len(key_success_sounds) - 1)]
	success_audio_player.play()
	hit_audio_player.play()

	# bounce anim
	var bounceTween := create_tween()
	bounceTween.tween_property(sprite_2d, "scale", Vector2(1.5, 1.5), 0.1)
	bounceTween.tween_property(sprite_2d, "scale", Vector2(0, 0), 0.5)

	# fade anim
	var fadeTween := create_tween()
	fadeTween.tween_property(sprite_2d, "modulate", Color(1, 1, 1, 0), 0.5)

	destroy_timer.start()


func on_destroy_timer_timeout() -> void:
	queue_free()
	destroyed.emit()


func miss() -> void:
	sprite_2d.modulate = Color("#cc0000")

	PlayerState.decrease_health(2)
	miss_audio_player.play()

	missed.emit()

	# shake anim
	var tween := create_tween()
	tween.tween_property(sprite_2d, "position:x", 7, 0.05)
	tween.tween_property(sprite_2d, "position:x", -7, 0.05)
	tween.tween_property(sprite_2d, "position:x", 7, 0.05)
	tween.tween_property(sprite_2d, "position:x", -7, 0.05)
	tween.tween_property(sprite_2d, "position:x", 0, 0.05)
