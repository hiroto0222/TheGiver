extends CharacterBody2D
class_name FightApproachKeyInput

signal destroyed

@export var key_letter: String

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var success_audio_player: AudioStreamPlayer = $Success
@onready var miss_audio_player: AudioStreamPlayer = $Miss

var is_processed := false
var speed := 250.0


# map key letters to sprite paths
var sprite_paths := {
	"w": "res://Assets/Sprites/KeyInputs/w.png",
	"a": "res://Assets/Sprites/KeyInputs/a.png",
	"s": "res://Assets/Sprites/KeyInputs/s.png",
	"d": "res://Assets/Sprites/KeyInputs/d.png",
}


func _ready() -> void:
	position = Vector2(-50, 640)

	if key_letter in sprite_paths:
		var sprite_path: String = sprite_paths[key_letter]
		var texture := load(sprite_path)
		sprite_2d.texture = texture


func _process(delta: float) -> void:
	position.x += speed * delta

	if position.x > 1280 + 50:
		queue_free()
		destroyed.emit()


func success(pitch_scale: float) -> void:
	sprite_2d.modulate = Color("#00b23b")

	success_audio_player.pitch_scale = pitch_scale
	success_audio_player.play()

	# bounce anim
	var tween := create_tween()
	tween.tween_property(sprite_2d, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.1)


func miss() -> void:
	sprite_2d.modulate = Color("#cc0000")

	PlayerState.decrease_health(2)
	miss_audio_player.play()

	# shake anim
	var tween := create_tween()
	tween.tween_property(sprite_2d, "position:x", 7, 0.05)
	tween.tween_property(sprite_2d, "position:x", -7, 0.05)
	tween.tween_property(sprite_2d, "position:x", 7, 0.05)
	tween.tween_property(sprite_2d, "position:x", -7, 0.05)
	tween.tween_property(sprite_2d, "position:x", 0, 0.05)
