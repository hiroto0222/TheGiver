extends Button

@export var focus_sound: AudioStream
@export var pressed_sound: AudioStream
var audio := AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio)
	connect("mouse_entered", on_focus)
	connect("pressed", on_pressed)


func on_focus() -> void:
	audio.stream = focus_sound
	audio.play()


func on_pressed() -> void:
	audio.stream = pressed_sound
	audio.play()
