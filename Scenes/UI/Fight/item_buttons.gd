extends CanvasLayer
class_name ItemButtons

signal cancel
signal item_selected(item: Item)

@export var items: Array[Item]
@export var item_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	if len(items) < 1:
		printerr("items array is empty!")
		return

	# iterate through each items
	for i in range(len(items)):
		var item_button_instance := item_button_scene.instantiate() as ItemButton

		var curr_item: Item = items[i]

		item_button_instance.item_text = curr_item.name
		item_button_instance.pressed.connect(on_item_button_pressed.bind(curr_item))
		grid_container.add_child(item_button_instance)

		# if first choice, grab focus
		if i == 0:
			item_button_instance.grab_focus()


func on_item_button_pressed(item: Item) -> void:
	item_selected.emit(item)


func _unhandled_key_input(event: InputEvent) -> void:
	if !event.is_action("ui_cancel"):
		return

	# if input is ui_cancel
	cancel.emit()
