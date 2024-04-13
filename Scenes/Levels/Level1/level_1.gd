@tool
extends Node2D

# level specific
@export var attack_sequence: Array[PackedScene]
@export var act_choices: Array[Act]

# visuals
@export var action_buttons_scene: PackedScene
@export var act_choice_buttons_scene: PackedScene
@export var battle_box_scene: PackedScene
@export var battle_player_scene: PackedScene

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var human: CharacterBody2D = $Human

var action_buttons_instance: ActionButtons
var act_choice_buttons_instance: ActChoiceButtons
var attack_instance: Attack
var battle_box_instance: BattleBox
var battle_player_instance: CharacterBody2D

# level gimmicks
var attack_cnt := 0
var act_success_cnt := 0
var is_mask_off := false


func _ready() -> void:
	if len(attack_sequence) < 1:
		printerr("No attacks in attack sequence")


func on_action_button_pressed(action_type: String) -> void:
	match action_type:
		"fight":
			action_buttons_instance.hide()
			start_attack_sequence()
		"act":
			action_buttons_instance.hide()
			start_act_choice_sequence()


func start_attack_sequence() -> void:
	# get layers
	var battle_area_layer := get_tree().get_first_node_in_group("battle_area_layer")
	var entities_layer := get_tree().get_first_node_in_group("entities_layer")

	# add battle player
	battle_player_instance = battle_player_scene.instantiate() as CharacterBody2D

	# add battle area
	battle_box_instance = battle_box_scene.instantiate() as Node2D

	# add attack instance
	attack_instance = attack_sequence[0].instantiate() as Attack
	attack_instance.attack_cnt = attack_cnt
	attack_instance.timer.timeout.connect(on_attack_timer_timeout)

	# add children
	battle_area_layer.add_child(battle_box_instance)
	entities_layer.add_child(attack_instance)
	add_child(battle_player_instance)

	anim.play("enter_battle")


func end_attack_sequence() -> void:
	attack_cnt += 1
	process_human_mask_gimmick()
	clean_up()
	anim.play("exit_battle")


func process_human_mask_gimmick() -> void:
	if attack_cnt % 3 == 2 and is_mask_off:
		human.close_mask()
		is_mask_off = false
	elif attack_cnt % 3 == 0 and !is_mask_off:
		human.open_mask()
		is_mask_off = true


func on_attack_timer_timeout() -> void:
	end_attack_sequence()


func start_act_choice_sequence() -> void:
	act_choice_buttons_instance = act_choice_buttons_scene.instantiate() as ActChoiceButtons

	# assign current act choices
	act_choice_buttons_instance.act_choices = act_choices

	act_choice_buttons_instance.cancel.connect(on_act_choice_buttons_cancel)
	act_choice_buttons_instance.act_selected.connect(on_act_choice_button_pressed)

	add_child(act_choice_buttons_instance)


func on_act_choice_button_pressed(act_selected: Act, index: int) -> void:
	# check if successful act conditions are met
	var is_successful := check_is_successful_act(act_selected, index)
	# hide UI
	act_choice_buttons_instance.queue_free()

	if is_successful and act_selected.success_timeline != null:
		# update act choices
		if act_selected.next != null:
			act_choices[index] = act_selected.next
		# emit dialogue
		Dialogic.start_timeline(act_selected.success_timeline)
		# once dialogue finished, start attack sequence
		Dialogic.timeline_ended.connect(on_act_dialogue_ended)
	else:
		# emit dialogue
		Dialogic.start_timeline(act_selected.default_timeline)
		# once dialogue finished, start attack sequence
		Dialogic.timeline_ended.connect(on_act_dialogue_ended)


func check_is_successful_act(act_selected: Act, index: int) -> bool:
	if act_selected.name == "Throw Dust" and is_mask_off:
		act_success_cnt += 1
		return true

	return false


# once dialogue for current act choice has ended, start attack sequence
func on_act_dialogue_ended() -> void:
	Dialogic.timeline_ended.disconnect(on_act_dialogue_ended)
	Dialogic.clear()
	start_attack_sequence()


func on_act_choice_buttons_cancel() -> void:
	clean_up()


func clean_up() -> void:
	# destroy battle box
	if battle_box_instance != null:
		battle_box_instance.remove()
	# destroy attack
	if attack_instance != null:
		attack_instance.queue_free()
	# destroy battle player
	if battle_player_instance != null:
		battle_player_instance.queue_free()
	# remove act buttons if any
	if act_choice_buttons_instance != null:
		act_choice_buttons_instance.queue_free()

	# re-enable action buttons
	action_buttons_instance.show()
	action_buttons_instance.enable_buttons()


# called once intro sequence has finished
func handle_intro_finished() -> void:
	action_buttons_instance = action_buttons_scene.instantiate() as ActionButtons
	action_buttons_instance.selected.connect(on_action_button_pressed)
	add_child(action_buttons_instance)


# node configuration warnings
func _get_configuration_warnings() -> PackedStringArray:
	if len(attack_sequence) < 1:
		return ["attack_sequence property is empty"]
	if len(act_choices) < 1:
		return ["act_choices property is empty"]
	if action_buttons_scene == null:
		return ["action_buttons_scene property is null"]
	if act_choice_buttons_scene == null:
		return ["act_buttons_scene property is null"]
	if battle_box_scene == null:
		return ["battle_box_scene property is null"]
	if battle_player_scene == null:
		return ["battle_player_scene property is null"]
	return []
