extends ColorRect


@onready var anim: AnimationPlayer = $AnimationPlayer
var game_over: PackedScene = preload("res://Scenes/UI/GameOver/game_over.tscn")


func _ready() -> void:
	anim.animation_finished.connect(on_anim_finished)
	anim.play("transition_to_death")


func on_anim_finished(anim_name: String) -> void:
	get_tree().change_scene_to_packed(game_over)
