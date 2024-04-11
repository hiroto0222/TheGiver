extends CanvasLayer

@onready var new_game_button: Button = %NewGameButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	new_game_button.pressed.connect(on_new_game_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func on_new_game_pressed() -> void:
	print("New game pressed")


func on_settings_pressed() -> void:
	print("Settings pressed")


func on_quit_pressed() -> void:
	get_tree().quit()
