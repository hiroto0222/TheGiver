@tool
extends LevelManager

signal intro_finished

@export var enemy_body: CharacterBody2D


func _ready() -> void:
	# handle attacks
	action_manager.fight_selected.connect(on_fight_selected)
	attack_manager.attack_sequence_ended.connect(on_attack_sequence_ended)

	# handle acts
	action_manager.act_selected.connect(on_act_selected)
	act_manager.cancelled.connect(on_act_cancelled)
	act_manager.act_sequence_ended.connect(on_act_sequence_ended)

	# handle state transitions
	state_manager.open_mask.connect(on_open_mask)


func on_fight_selected() -> void:
	start_attack_sequence.emit()


func on_act_selected() -> void:
	start_act_sequence.emit()


func on_act_cancelled() -> void:
	clean_up.emit()


func on_act_sequence_ended() -> void:
	start_attack_sequence.emit()


func on_attack_sequence_ended() -> void:
	clean_up.emit()


func on_open_mask(mask_open: bool) -> void:
	if mask_open:
		enemy_body.open_mask()
	else:
		enemy_body.close_mask()


# called once intro sequence has finished
func handle_intro_finished() -> void:
	intro_finished.emit()
