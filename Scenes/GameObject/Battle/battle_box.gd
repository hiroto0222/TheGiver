extends Node2D
class_name BattleBox

@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name: String) -> void:
	if anim_name != "leave":
		return
	queue_free()


func remove() -> void:
	anim.play("leave")
