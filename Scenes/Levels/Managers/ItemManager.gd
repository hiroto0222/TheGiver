@tool
extends Node
class_name ItemManager

signal cancelled
signal item_sequence_ended

# Game Objects
@export var item_buttons_scene: PackedScene

# Managers
@export var level_manager: LevelManager

# Instances
var item_buttons_instance: ItemButtons


func on_start_item_sequence() -> void:
	pass


func on_item_dialogue_ended() -> void:
	pass


func on_item_buttons_cancel() -> void:
	pass


func on_clean_up() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if item_buttons_scene == null:
		warnings.append("item_buttons_scene property is empty")
	if level_manager == null:
		warnings.append("level_manager property is empty")
	return warnings
