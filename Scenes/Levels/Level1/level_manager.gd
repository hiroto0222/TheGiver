@tool
extends LevelManager

signal intro_finished


func _ready() -> void:
	# handle attacks
	action_manager.fight_selected.connect(on_fight_selected)
	attack_manager.attack_sequence_ended.connect(on_attack_sequence_ended)

	# handle acts
	action_manager.act_selected.connect(on_act_selected)
	act_manager.cancelled.connect(on_act_cancelled)
	act_manager.act_sequence_ended.connect(on_act_sequence_ended)


func on_fight_selected() -> void:
	start_attack_sequence.emit()


func on_act_selected() -> void:
	start_act_sequence.emit()


func on_act_cancelled() -> void:
	clean_up.emit()


func on_act_sequence_ended() -> void:
	act_cnt += 1
	start_attack_sequence.emit()


func on_attack_sequence_ended() -> void:
	attack_cnt += 1
	clean_up.emit()


# called once intro sequence has finished
func handle_intro_finished() -> void:
	intro_finished.emit()
