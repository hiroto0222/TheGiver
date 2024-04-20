@tool
extends Node
class_name LevelManager

signal clean_up
signal start_fight_sequence
signal start_attack_sequence
signal start_act_sequence

# Managers
@export var fight_manager: FightManager
@export var attack_manager: AttackManager
@export var action_manager: ActionManager
@export var act_manager: ActManager
@export var state_manager: StateManager


func on_fight_selected() -> void:
	pass


func on_fight_sequence_ended() -> void:
	pass


func on_act_selected() -> void:
	pass


func on_act_cancelled() -> void:
	pass


func on_act_sequence_ended() -> void:
	pass


func on_attack_sequence_ended() -> void:
	pass


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if fight_manager == null:
		warnings.append("fight_manager property is empty")
	if attack_manager == null:
		warnings.append("attack_manager property is empty")
	if action_manager == null:
		warnings.append("action_manager property is empty")
	if act_manager == null:
		warnings.append("act_manager property is empty")
	if state_manager == null:
		warnings.append("state_manager property is empty")
	return warnings
