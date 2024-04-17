@tool
extends StateManager

signal open_mask(mask_open: bool)

var mask_open := false
var mask_close_countdown := 2
var mask_open_countdown := 2


func _ready() -> void:
	attack_manager.attack_sequence_ended.connect(on_attack_sequence_ended)
	act_manager.act_sequence_ended.connect(on_act_sequence_ended)


func on_attack_sequence_ended() -> void:
	attack_count += 1
	handle_mask_open()
	handle_phase_progress()


func on_act_sequence_ended() -> void:
	act_count += 1


func handle_phase_progress() -> void:
	# initial act -> phase 1
	if phase < 1 and act_count == 1:
		print("initiated phase 1")
		phase = 1
		mask_open_countdown = 1
		return


func handle_mask_open() -> void:
	# ignore if not passed phase 0
	if phase < 1:
		return

	if !mask_open:
		mask_open_countdown -= 1
	else:
		mask_close_countdown -= 1

	# close mask
	if mask_open and mask_close_countdown <= 0:
		mask_open = false
		mask_close_countdown = 2
		mask_open_countdown = 2
		open_mask.emit(mask_open)
		return

	# open mask
	if !mask_open and mask_open_countdown <= 0:
		mask_open = true
		mask_close_countdown = 2
		mask_open_countdown = 2
		open_mask.emit(mask_open)
		return
