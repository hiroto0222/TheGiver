@tool
extends ItemManager


func _ready() -> void:
	level_manager.start_item_sequence.connect(on_start_item_sequence)
	level_manager.clean_up.connect(on_clean_up)


func on_start_item_sequence() -> void:
	item_buttons_instance = item_buttons_scene.instantiate() as ItemButtons

	item_buttons_instance.cancel.connect(on_item_buttons_cancel)
	item_buttons_instance.item_selected.connect(on_item_selected)

	add_child(item_buttons_instance)


func on_item_selected(item: Item) -> void:
	# clean up buttons
	item_buttons_instance.cancel.disconnect(on_item_buttons_cancel)
	item_buttons_instance.hide()

	# emit dialogue
	Dialogic.start_timeline(item.dialogue)
	Dialogic.timeline_ended.connect(on_item_dialogue_ended)

	# item effect
	PlayerState.increase_health(item.heal_amount)


func on_item_dialogue_ended() -> void:
	Dialogic.timeline_ended.disconnect(on_item_dialogue_ended)
	Dialogic.clear()
	item_sequence_ended.emit()


func on_item_buttons_cancel() -> void:
	cancelled.emit()


func on_clean_up() -> void:
	if item_buttons_instance != null:
		item_buttons_instance.queue_free()
