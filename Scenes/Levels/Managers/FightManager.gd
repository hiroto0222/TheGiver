@tool
extends Node
class_name FightManager

signal fight_sequence_ended

# Game Objects
@export var fight_approach_scene: PackedScene
@export var fight_scene: PackedScene
@export var animation_player: AnimationPlayer

# Managers
@export var level_manager: LevelManager
@export var state_manager: StateManager

# Instances
var fight_approach_scene_instance: FightApproach
var fight_scene_instance: Fight


func on_start_fight_sequence() -> void:
	pass


func on_clean_up() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if fight_approach_scene == null:
		warnings.append("fight_approach_scene property is empty")
	if fight_scene == null:
		warnings.append("fight_scene property is empty")
	if animation_player == null:
		warnings.append("animation_player property is empty")
	if state_manager == null:
		warnings.append("state_manager property is empty")
	if level_manager == null:
		warnings.append("level_manager property is empty")
	return warnings
