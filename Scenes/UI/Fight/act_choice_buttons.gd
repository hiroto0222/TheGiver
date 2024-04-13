extends CanvasLayer
class_name ActChoiceButtons

signal cancel
signal act_selected(act: Act, index: int)

@export var act_choices: Array[Act]
@export var act_choice_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	if len(act_choices) < 1:
		printerr("act choices array is empty!")
		return

	# iterate through each act choice
	for i in range(len(act_choices)):
		var act_choice_button_instance := act_choice_button_scene.instantiate() as ActChoiceButton

		# get the curr act for the curr act choice
		var curr_act: Act = act_choices[i]

		act_choice_button_instance.act_text = curr_act.name
		act_choice_button_instance.pressed.connect(on_act_choice_button_pressed.bind(curr_act, i))
		grid_container.add_child(act_choice_button_instance)

		# if first choice, grab focus
		if i == 0:
			act_choice_button_instance.grab_focus()


func on_act_choice_button_pressed(act: Act, index: int) -> void:
	act_selected.emit(act, index)


func _unhandled_key_input(event: InputEvent) -> void:
	if !event.is_action("ui_cancel"):
		return

	# if input is ui_cancel
	cancel.emit()
