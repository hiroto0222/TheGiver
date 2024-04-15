@tool
extends Node
class_name ActionManager

signal fight_selected
signal act_selected

# Game Objects
@export var action_buttons_scene: PackedScene

# Managers
@export var level_manager: LevelManager

# Instances
var action_buttons_instance: ActionButtons


func on_action_button_pressed(action_type: String) -> void:
	pass


func on_clean_up() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if action_buttons_scene == null:
		warnings.append("action_buttons_scene property is empty")
	if level_manager == null:
		warnings.append("level_manager property is empty")
	return warnings
