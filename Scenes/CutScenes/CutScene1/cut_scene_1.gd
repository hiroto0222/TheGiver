extends Node2D

@onready var slides: Array[Node] = %Slides.get_children()
@onready var anim: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	Dialogic.signal_event.connect(on_dialog_signal)
	Dialogic.timeline_ended.connect(on_dialog_ended)
	Dialogic.start("cut_scene_1_timeline")


func on_dialog_ended() -> void:
	Dialogic.timeline_ended.disconnect(on_dialog_ended)
	print("cut_scene_1 dialogue ended")


# When signal is recieved, transition to value slide
func on_dialog_signal(value: String) -> void:
	clear_slides()
	anim.play("slide" + value)


# Set all slides to not visible
func clear_slides() -> void:
	for slide in slides:
		slide.visible = false
