@tool
extends Node
class_name AttackManager

signal attack_sequence_ended

# Game Objects
@export var attack_sequence: Array[PackedScene]
@export var battle_box_scene: PackedScene
@export var battle_player_scene: PackedScene
@export var animation_player: AnimationPlayer

# Managers
@export var level_manager: LevelManager

# Instances
var battle_player_instance: CharacterBody2D
var battle_box_instance: Node2D
var attack_instance: Node


func on_start_attack_sequence() -> void:
	pass


func on_attack_timer_timeout() -> void:
	pass


func end_attack_sequence() -> void:
	pass


func on_clean_up() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if level_manager == null:
		warnings.append("level_manager property is empty")
	if len(attack_sequence) < 1:
		warnings.append("attack_sequence property is empty")
	if battle_box_scene == null:
		warnings.append("battle_box_scene property is null")
	if battle_player_scene == null:
		warnings.append("battle_player_scene property is null")
	if animation_player == null:
		warnings.append("animation_player property is null")
	return warnings
