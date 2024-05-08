@tool
extends ActManager


func _ready() -> void:
	level_manager.start_act_sequence.connect(on_start_act_sequence)
	level_manager.clean_up.connect(on_clean_up)


# check conditions with state manager for successful act
func is_successful_act(act_selected: Act) -> bool:
	match state_manager.phase:
		# phase 1
		0: return true
		# phase 2
		1:
			# mask open and throw dust success
			if state_manager.mask_open and act_selected.name == "Throw Dust":
				level_manager.damage_enemy()
				return true

	return false


func on_start_act_sequence() -> void:
	act_choice_buttons_instance = act_choice_buttons_scene.instantiate() as ActChoiceButtons

	# current phase
	var curr_phase := state_manager.phase

	# assign current act choices
	act_choice_buttons_instance.act_choices = act_choices_per_phase[curr_phase].acts

	act_choice_buttons_instance.cancel.connect(on_act_choice_buttons_cancel)
	act_choice_buttons_instance.act_selected.connect(on_act_choice_button_pressed)

	add_child(act_choice_buttons_instance)


func on_act_choice_button_pressed(act_selected: Act, index: int) -> void:
	# clean up buttons
	act_choice_buttons_instance.cancel.disconnect(on_act_choice_buttons_cancel)
	act_choice_buttons_instance.hide()

	# check conditions for successful act
	var is_success := is_successful_act(act_selected)
	var dialogue: DialogicTimeline
	if is_success:
		dialogue = act_selected.success_timeline
	else:
		dialogue = act_selected.default_timeline.pick_random()

	# emit dialogue
	Dialogic.start_timeline(dialogue)
	# once dialogue finished, start attack sequence
	Dialogic.timeline_ended.connect(on_act_dialogue_ended)


func on_act_dialogue_ended() -> void:
	Dialogic.timeline_ended.disconnect(on_act_dialogue_ended)
	Dialogic.clear()
	act_sequence_ended.emit()


func on_act_choice_buttons_cancel() -> void:
	cancelled.emit()


func on_clean_up() -> void:
	if act_choice_buttons_instance != null:
		act_choice_buttons_instance.queue_free()
