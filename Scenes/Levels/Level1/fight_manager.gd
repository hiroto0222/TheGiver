@tool
extends FightManager

@export var dialog_background: ColorRect # TODO: move logic else where
@export var slapping_hand_scene: PackedScene

# min/max speed for each available phase
var line_speeds := [
	[2000, 2500],
	[1500, 2000],
	[500, 1000],
	[250, 500]
]


func _ready() -> void:
	level_manager.start_fight_sequence.connect(on_start_fight_sequence)


func clean_up() -> void:
	if fight_approach_scene_instance != null:
		fight_approach_scene_instance.queue_free()
	if fight_scene_instance != null:
		fight_scene_instance.queue_free()
	fight_sequence_ended.emit()
	animation_player.play("exit_fight")


func on_start_fight_sequence() -> void:
	fight_approach_scene_instance = fight_approach_scene.instantiate() as FightApproach
	fight_approach_scene_instance.success.connect(on_fight_approach_scene_success)
	fight_approach_scene_instance.fail.connect(on_fight_approach_scene_fail)

	animation_player.play("enter_fight")
	add_child(fight_approach_scene_instance)


func on_fight_approach_scene_fail() -> void:
	clean_up()


func on_fight_approach_scene_success() -> void:
	fight_approach_scene_instance.queue_free()
	dialog_background.hide()

	fight_scene_instance = fight_scene.instantiate() as Fight
	var curr_phase := mini(state_manager.phase, len(line_speeds) - 1)
	var min_speed: float = line_speeds[curr_phase][0]
	var max_speed: float = line_speeds[curr_phase][1]
	fight_scene_instance.horizontal_speed = randf_range(min_speed, max_speed)
	fight_scene_instance.vertical_speed = randf_range(min_speed, max_speed)

	fight_scene_instance.ended.connect(on_fight_ended)

	add_child(fight_scene_instance)
	fight_scene_instance.start()


func on_fight_ended(pos_x: float, pos_y: float) -> void:
	var delay_timer := Timer.new()
	delay_timer.one_shot = true
	delay_timer.wait_time = 0.5
	delay_timer.timeout.connect(on_delay_timer_timeout.bind(pos_x, pos_y))

	add_child(delay_timer)
	delay_timer.start()


func on_delay_timer_timeout(pos_x: float, pos_y: float) -> void:
	var slapping_hand_instance := slapping_hand_scene.instantiate()
	slapping_hand_instance.ended.connect(on_slapping_hand_ended)
	var screen_x := get_viewport().get_visible_rect().size.x
	var screen_y := get_viewport().get_visible_rect().size.y
	if pos_x > 0 and pos_x < screen_x and pos_y > 0 and pos_y < screen_y:
		slapping_hand_instance.target_pos_x = pos_x
		slapping_hand_instance.target_pos_y = pos_y

	add_child(slapping_hand_instance)


func on_slapping_hand_ended() -> void:
	clean_up()
