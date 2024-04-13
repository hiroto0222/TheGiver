@tool
extends Node2D

@export var action_buttons_scene: PackedScene
@export var act_choice_buttons_scene: PackedScene
@export var attack_sequence: Array[PackedScene]
@export var battle_box_scene: PackedScene
@export var battle_player_scene: PackedScene

@onready var anim: AnimationPlayer = $AnimationPlayer

var action_buttons_instance: ActionButtons
var act_choice_buttons_instance: ActChoiceButtons
var attack_instance: Attack
var battle_box_instance: BattleBox
var battle_player_instance: CharacterBody2D


func _ready() -> void:
	if len(attack_sequence) < 1:
		get_tree().quit()
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
	attack_instance.timer.timeout.connect(on_attack_timer_timeout)

	# add children
	battle_area_layer.add_child(battle_box_instance)
	entities_layer.add_child(attack_instance)
	add_child(battle_player_instance)

	anim.play("enter_battle")


func end_attack_sequence() -> void:
	clean_up()
	anim.play("exit_battle")


func on_attack_timer_timeout() -> void:
	end_attack_sequence()


func start_act_choice_sequence() -> void:
	act_choice_buttons_instance = act_choice_buttons_scene.instantiate() as ActChoiceButtons

	# assign current act choices
	var choices: Array[String] = ["Check", "Throw Dust", "Do Nothing"]
	act_choice_buttons_instance.act_choices = choices

	act_choice_buttons_instance.cancel.connect(on_act_choice_buttons_cancel)
	act_choice_buttons_instance.selected.connect(on_act_choice_button_pressed)

	add_child(act_choice_buttons_instance)


func on_act_choice_button_pressed(act_choice: String) -> void:
	print(act_choice)
	# 1. hide UI
	act_choice_buttons_instance.queue_free()
	# 2. emit dialogue
	Dialogic.start_timeline("level_1_act_check_1_timeline")
	# 3. once dialogue finished, start attack sequence
	Dialogic.timeline_ended.connect(on_act_dialogue_ended)


# once dialogue for current act choice has ended, start attack sequence
func on_act_dialogue_ended() -> void:
	Dialogic.timeline_ended.disconnect(on_act_dialogue_ended)
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
	if action_buttons_scene == null:
		return ["action_buttons_scene property is null"]
	if act_choice_buttons_scene == null:
		return ["act_buttons_scene property is null"]
	if len(attack_sequence) < 1:
		return ["attack_sequence property is empty"]
	if battle_box_scene == null:
		return ["battle_box_scene property is null"]
	if battle_player_scene == null:
		return ["battle_player_scene property is null"]
	return []
