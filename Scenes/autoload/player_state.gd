extends Node

# Player Health
signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal death
@export var max_health := 20
var player_health := max_health

# Player Blood
signal blood_changed(blood: int)
signal set_max_blood(max_blood: int)
var max_player_blood := 100
var player_blood := 0

# Last Death Scene
var last_scene: String


func update_max_health(amount: int) -> void:
	max_health += amount
	max_health_changed.emit(max_health)


func increase_health(amount: int) -> void:
	player_health = mini(player_health + amount, max_health)
	health_changed.emit(player_health)


func decrease_health(amount: int) -> void:
	player_health = maxi(player_health - amount, 0)
	health_changed.emit(player_health)
	if player_health == 0:
		death.emit()


func regenerate() -> void:
	player_health = max_health
	health_changed.emit(player_health)


func increase_blood(amount: int) -> void:
	player_blood = mini(player_blood + amount, max_player_blood)
	blood_changed.emit(player_blood)


func set_last_scene(scene_path: String) -> void:
	last_scene = scene_path
