extends Node2D
class_name FightApproach


signal success
signal fail

@export var key_input_scene: PackedScene

@onready var player: CharacterBody2D = $Player
@onready var key_enter_area: FightApproachKeyEnterArea = $KeyEnterArea
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var key_input_layer: Node
var key_input_instance: FightApproachKeyInput
var key_spawn_timer: Timer

var key_combos := ["w", "w", "a", "s", "w", "d", "a", "s", "d"]
var key_combo_success_pitches := []
var key_combo_idx: int = 0
var key_letter_dist := 500
var key_letter_speed: float
# change to alter speed and pitch of heartbeat
var heart_beat_pitch_scale: float = 1.0

var success_cnt := 0

const y_pos := 360


func _ready() -> void:
	audio.pitch_scale = heart_beat_pitch_scale

	# calculate key letter speed according to heart beat pitch scale
	key_letter_speed = 1000

	# calculate key_combo_success_pitches
	var step := 0 / float(len(key_combos) - 1)
	for i in range(key_combos.size()):
		var val := 1 + i * step
		key_combo_success_pitches.append(val)

	key_input_layer = get_tree().get_first_node_in_group("key_input_layer")

	key_spawn_timer = Timer.new()
	key_spawn_timer.wait_time = 0.5
	key_spawn_timer.timeout.connect(on_key_spawn_timer_timeout)
	add_child(key_spawn_timer)
	key_spawn_timer.start()


func on_key_spawn_timer_timeout() -> void:
	if key_combo_idx < len(key_combos):
		key_input_instance = key_input_scene.instantiate() as FightApproachKeyInput
		key_input_instance.key_letter = key_combos[key_combo_idx]
		key_input_instance.speed = key_letter_speed
		key_input_instance.missed.connect(on_key_input_missed)

		key_combo_idx += 1
		key_input_instance.destroyed.connect(on_key_input_instance_destroyed.bind(key_combo_idx))

		key_input_layer.add_child(key_input_instance)


func _unhandled_key_input(event: InputEvent) -> void:
	if success_cnt >= len(key_combos):
		return

	if key_enter_area.check_correct_key_press(event.as_text().to_lower(), key_combo_success_pitches[success_cnt]):
		handle_successful_key_press()


func handle_successful_key_press() -> void:
	var tween := create_tween()
	var rand_x: float = [randi_range(-200, -75), randi_range(75, 200)].pick_random()
	var rand_y: float = [randi_range(-200, -75), randi_range(75, 200)].pick_random()
	tween.tween_property(player, "position", Vector2(640 - rand_x, y_pos - rand_y), 0.1)
	tween.tween_property(player, "position", Vector2(640, y_pos), 0.2)
	success_cnt += 1


func on_key_input_missed() -> void:
	var tween := create_tween()
	tween.tween_property(player, "position", Vector2(640 - 15, y_pos), 0.05)
	tween.tween_property(player, "position", Vector2(640 + 15, y_pos), 0.05)
	tween.tween_property(player, "position", Vector2(640 - 15, y_pos), 0.05)
	tween.tween_property(player, "position", Vector2(640 + 15, y_pos), 0.05)
	tween.tween_property(player, "position", Vector2(640, y_pos), 0.05)


func on_key_input_instance_destroyed(key_index: int) -> void:
	# if not last key input then dismiss
	if key_index < len(key_combos):
		return

	if success_cnt >= len(key_combos):
		handle_success()
	else:
		handle_fail()


func handle_success() -> void:
	anim.animation_finished.connect(on_success_anim_finished)
	anim.play("success")


func handle_fail() -> void:
	anim.animation_finished.connect(on_fail_anim_finished)
	anim.play("fail")


func on_success_anim_finished(anim_name: String) -> void:
	success.emit()


func on_fail_anim_finished(anim_name: String) -> void:
	fail.emit()
