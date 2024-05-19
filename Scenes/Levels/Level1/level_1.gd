extends Node2D


@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# if retry
	if PlayerState.last_scene == get_tree().current_scene.scene_file_path:
		anim.play("no_intro")
	else:
		anim.play("intro_sequence")
