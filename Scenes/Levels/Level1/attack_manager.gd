extends AttackManager


func _ready() -> void:
	level_manager.start_attack_sequence.connect(on_start_attack_sequence)
	level_manager.clean_up.connect(on_clean_up)


func on_start_attack_sequence() -> void:
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

	animation_player.play("enter_battle")


func on_attack_timer_timeout() -> void:
	end_attack_sequence()


func end_attack_sequence() -> void:
	animation_player.play("exit_battle")
	attack_sequence_ended.emit()


func on_clean_up() -> void:
	# destroy battle box
	if battle_box_instance != null:
		battle_box_instance.remove()
	# destroy attack
	if attack_instance != null:
		attack_instance.queue_free()
	# destroy battle player
	if battle_player_instance != null:
		battle_player_instance.queue_free()
