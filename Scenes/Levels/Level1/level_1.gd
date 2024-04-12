extends Node2D

@export var action_buttons_scene: PackedScene
@export var attack_sequence: Array[PackedScene]
@export var battle_box_scene: PackedScene
@export var battle_player_scene: PackedScene

@onready var anim: AnimationPlayer = $AnimationPlayer

var action_buttons_instance: ActionButtons
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
			action_buttons_instance.disable_buttons()
			start_attack_sequence()
		_:
			print("handle others")


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
	# destroy battle box
	if battle_box_instance != null:
		battle_box_instance.remove()
	# destroy attack
	if attack_instance != null:
		attack_instance.queue_free()
	# destroy battle player
	if battle_player_instance != null:
		battle_player_instance.queue_free()
	# re-enable action buttons
	action_buttons_instance.enable_buttons()

	anim.play("exit_battle")


func on_attack_timer_timeout() -> void:
	end_attack_sequence()


# called once intro sequence has finished
func handle_intro_finished() -> void:
	action_buttons_instance = action_buttons_scene.instantiate() as ActionButtons
	action_buttons_instance.selected.connect(on_action_button_pressed)
	add_child(action_buttons_instance)
