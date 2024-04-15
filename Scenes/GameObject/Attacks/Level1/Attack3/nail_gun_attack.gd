extends CharacterBody2D

@export var nail_attack_scene: PackedScene

@onready var timer: Timer = $Timer

var attack_damage: int

var nail_attack_instance: CharacterBody2D


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func shoot() -> void:
	timer.start()


func on_timer_timeout() -> void:
	nail_attack_instance = nail_attack_scene.instantiate() as CharacterBody2D
	nail_attack_instance.attack_damage = attack_damage
	add_child(nail_attack_instance)
