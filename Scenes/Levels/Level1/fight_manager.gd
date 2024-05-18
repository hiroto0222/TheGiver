@tool
extends FightManager

@export var dialog_background: ColorRect # TODO: move logic else where
@export var slapping_hand_scene: PackedScene


func _ready() -> void:
	level_manager.start_fight_sequence.connect(on_start_fight_sequence)


func clean_up() -> void:
	if fight_approach_scene_instance != null:
		fight_approach_scene_instance.queue_free()
	if blood_suck_scene_instance != null:
		blood_suck_scene_instance.queue_free()
	fight_sequence_ended.emit()
	animation_player.play("exit_fight")


func on_start_fight_sequence() -> void:
	fight_approach_scene_instance = fight_approach_scene.instantiate() as FightApproach
	fight_approach_scene_instance.success.connect(on_fight_approach_scene_success)
	fight_approach_scene_instance.fail.connect(on_fight_approach_scene_fail)

	animation_player.play("enter_fight")
	dialog_background.hide()
	add_child(fight_approach_scene_instance)


func on_fight_approach_scene_fail() -> void:
	clean_up()


func on_fight_approach_scene_success() -> void:
	fight_approach_scene_instance.queue_free()

	blood_suck_scene_instance = blood_suck_scene.instantiate() as BloodSuck
	blood_suck_scene_instance.current_phase = state_manager.phase

	blood_suck_scene_instance.ended.connect(on_fight_ended)

	add_child(blood_suck_scene_instance)


func on_fight_ended(success: bool, x_pos: float, y_pos: float) -> void:
	if !success:
		var delay_timer := Timer.new()
		delay_timer.one_shot = true
		delay_timer.wait_time = 0.5
		delay_timer.timeout.connect(on_delay_timer_timeout.bind(x_pos, y_pos))

		add_child(delay_timer)
		delay_timer.start()
	else:
		# TODO: handle successful blood suck animation transition
		clean_up()


func on_delay_timer_timeout(pos_x: float, pos_y: float) -> void:
	# check if successful blood suck
	var slapping_hand_instance := slapping_hand_scene.instantiate()
	slapping_hand_instance.ended.connect(on_slapping_hand_ended)
	var screen_x := get_viewport().get_visible_rect().size.x
	var screen_y := get_viewport().get_visible_rect().size.y

	slapping_hand_instance.target_pos_x = pos_x if (pos_x > 0 and pos_x <= screen_x) else 640.0
	slapping_hand_instance.target_pos_y = pos_y if (pos_y > 0 and pos_y <= screen_y) else 360.0

	add_child(slapping_hand_instance)


func on_slapping_hand_ended() -> void:
	clean_up()
