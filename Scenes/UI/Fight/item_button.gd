extends Button
class_name ItemButton

@export var focus_sound: AudioStream
@export var pressed_sound: AudioStream

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var item_text: String


func _ready() -> void:
	if item_text.is_empty():
		return
	text = item_text
	connect("focus_entered", on_focus)
	connect("pressed", on_pressed)


func on_focus() -> void:
	audio.stream = focus_sound
	audio.pitch_scale = 0.4
	audio.play()


func on_pressed() -> void:
	audio.stream = pressed_sound
	audio.pitch_scale = 1
	audio.play()
