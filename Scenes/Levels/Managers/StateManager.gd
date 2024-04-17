@tool
extends Node
class_name StateManager

@export var attack_manager: AttackManager
@export var act_manager: ActManager

var act_count: int = 0
var attack_count: int = 0
var phase: int = 0


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if attack_manager == null:
		warnings.append("attack_manager property is empty")
	if act_manager == null:
		warnings.append("act_manager property is empty")
	return warnings
