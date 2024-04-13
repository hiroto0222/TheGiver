extends Button
class_name ActChoiceButton

@export var focus_sound: AudioStream
@export var pressed_sound: AudioStream

var act_text: String
var audio := AudioStreamPlayer.new()


func _ready() -> void:
	if act_text.is_empty():
		return
	text = act_text
	add_child(audio)
	connect("focus_entered", on_focus)
	connect("pressed", on_pressed)


func on_focus() -> void:
	audio.stream = focus_sound
	audio.play()


func on_pressed() -> void:
	audio.stream = pressed_sound
	audio.play()
