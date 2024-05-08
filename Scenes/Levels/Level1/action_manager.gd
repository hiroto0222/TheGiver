@tool
extends ActionManager


func _ready() -> void:
	level_manager.intro_finished.connect(on_intro_finished)
	level_manager.clean_up.connect(on_clean_up)


# called once intro sequence has finished
func on_intro_finished() -> void:
	action_buttons_instance = action_buttons_scene.instantiate() as ActionButtons
	action_buttons_instance.selected.connect(on_action_button_pressed)
	add_child(action_buttons_instance)


func on_action_button_pressed(action_type: String) -> void:
	match action_type:
		"fight":
			action_buttons_instance.hide()
			fight_selected.emit()
		"act":
			action_buttons_instance.hide()
			act_selected.emit()
		"items":
			action_buttons_instance.hide()
			items_selected.emit()


# when clean up is called, re-enable action buttons
func on_clean_up() -> void:
	action_buttons_instance.show()
	action_buttons_instance.enable_buttons()
