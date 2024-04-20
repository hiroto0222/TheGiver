@tool
extends FightManager

@export var dialog_background: ColorRect # TODO: move logic else where


func _ready() -> void:
	level_manager.start_fight_sequence.connect(on_start_fight_sequence)


func on_start_fight_sequence() -> void:
	fight_scene_instance = fight_scene.instantiate() as Fight
	fight_scene_instance.ended.connect(on_fight_ended)

	dialog_background.hide()
	animation_player.animation_finished.connect(on_animation_enter_finished)
	animation_player.play("enter_fight")


func on_fight_ended(pos_x: float, pos_y: float) -> void:
	print("pos x: ", pos_x)
	print("pos y: ", pos_y)
	fight_scene_instance.queue_free()
	animation_player.animation_finished.connect(on_animation_exit_finished)
	animation_player.play_backwards("enter_fight")


func on_animation_enter_finished(anim_name: String) -> void:
	animation_player.animation_finished.disconnect(on_animation_enter_finished)
	add_child(fight_scene_instance)
	fight_scene_instance.start()


func on_animation_exit_finished(anim_name: String) -> void:
	animation_player.animation_finished.disconnect(on_animation_exit_finished)
	fight_sequence_ended.emit()
