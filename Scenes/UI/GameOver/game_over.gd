extends Control


@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var retry_button: Button = %RetryButton
@onready var giveup_button: Button = %GiveUpButton


func _ready() -> void:
	get_tree().paused = false
	retry_button.grab_focus()
	retry_button.pressed.connect(on_retry_button_pressed)


func on_retry_button_pressed() -> void:
	anim.animation_finished.connect(on_animation_finished)
	anim.play("fade_out")


func on_animation_finished(anim_name: String) -> void:
	if !PlayerState.last_scene.is_empty() and anim_name == "fade_out":
		get_tree().change_scene_to_file(PlayerState.last_scene)
