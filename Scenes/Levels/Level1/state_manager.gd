@tool
extends Node
class_name StateManager

@export var level_manager: LevelManager
@export var act_manager: ActManager
@export var total_phase_count: int

var attack_cnt := 0
var act_cnt := 0
var current_phase := 0


func _ready() -> void:
	level_manager.start_attack_sequence.connect(on_start_attack_sequence)
	act_manager.act_selected.connect(on_act_selected)


# update attack count
func on_start_attack_sequence() -> void:
	attack_cnt += 1


# update act count
func on_act_selected(act_selected: Act) -> void:
	act_cnt += 1


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if total_phase_count < 1:
		warnings.append("total_phase_count property is not set")
	if level_manager == null:
		warnings.append("level_manager property is empty")
	if act_manager == null:
		warnings.append("act_manager property is empty")
	return warnings
