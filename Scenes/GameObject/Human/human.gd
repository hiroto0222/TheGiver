extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer


func open_mask() -> void:
	animated_sprite.play("open_mask")


func close_mask() -> void:
	animated_sprite.play_backwards("open_mask")


func damage() -> void:
	anim.play("damage")
	anim.queue("idle")
