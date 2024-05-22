extends Node2D


@onready var anim: AnimationPlayer = $AnimationPlayer
var scene_transition: PackedScene = preload("res://Scenes/UI/Misc/scene_transition.tscn")

func _ready() -> void:
	PlayerState.reset()
	var scene_transition_instance := scene_transition.instantiate()
	add_child(scene_transition_instance)
	# if retry
	if PlayerState.last_scene == get_tree().current_scene.scene_file_path:
		anim.play("no_intro")
	else:
		anim.play("no_intro")
