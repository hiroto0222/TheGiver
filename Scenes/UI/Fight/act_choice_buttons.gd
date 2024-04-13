extends CanvasLayer
class_name ActChoiceButtons

signal cancel
signal selected(act_choice: String)

@export var act_choice_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer

var act_choices: Array[String] = ["Test 1", "Test 2", "Test 3", "Test 4"]


func _ready() -> void:
	if len(act_choices) < 1:
		printerr("act choices array is empty")
		return

	for i in range(len(act_choices)):
		var act_choice_button_instance := act_choice_button_scene.instantiate() as ActChoiceButton
		act_choice_button_instance.act_text = act_choices[i]
		act_choice_button_instance.pressed.connect(on_act_choice_button_pressed.bind(act_choices[i]))
		grid_container.add_child(act_choice_button_instance)

		# if first choice, grab focus
		if i == 0:
			act_choice_button_instance.grab_focus()


func on_act_choice_button_pressed(act_choice: String) -> void:
	selected.emit(act_choice)


func _unhandled_key_input(event: InputEvent) -> void:
	if !event.is_action("ui_cancel"):
		return

	# if input is ui_cancel
	cancel.emit()
