extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func open_mask() -> void:
	animated_sprite.play("open_mask")


func close_mask() -> void:
	animated_sprite.play_backwards("open_mask")
