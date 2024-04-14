@tool
extends Node
class_name ActManager

signal cancelled
signal act_sequence_ended

# Game Objects
@export var act_choices: Array[Act]  # head of linked list for each choices
@export var act_choice_buttons_scene: PackedScene

# Managers
@export var level_manager: LevelManager

# Instances
var act_choice_buttons_instance: ActChoiceButtons


func on_start_act_sequence() -> void:
	pass


func on_act_choice_button_pressed(act_selected: Act, index: int) -> void:
	pass


func on_act_dialogue_ended() -> void:
	pass


func on_act_choice_buttons_cancel() -> void:
	pass


func on_clean_up() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if level_manager == null:
		warnings.append("level_manager property is empty")
	if len(act_choices) < 1:
		warnings.append("act_choices property is empty")
	if act_choice_buttons_scene == null:
		warnings.append("act_choice_buttons_scene property is empty")
	return warnings
