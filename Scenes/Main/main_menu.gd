extends CanvasLayer

@onready var new_game_button: Button = %NewGameButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var anim: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	new_game_button.grab_focus()
	new_game_button.pressed.connect(on_new_game_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func on_new_game_pressed() -> void:
	settings_button.visible = false
	quit_button.visible = false
	anim.play("start_game")


func on_settings_pressed() -> void:
	print("Settings pressed")


func on_quit_pressed() -> void:
	get_tree().quit()


# transition to cut_scene_1
func handle_start_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/CutScenes/CutScene1/cut_scene_1.tscn")
