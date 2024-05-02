extends Node

signal health_changed(health: int)
signal max_health_changed(max_health: int)

@export var max_health := 40

var player_health := max_health


func update_max_health(amount: int) -> void:
	max_health += amount
	max_health_changed.emit(max_health)


func increase_health(amount: int) -> void:
	player_health = mini(player_health + amount, max_health)
	health_changed.emit(player_health)


func decrease_health(amount: int) -> void:
	player_health = maxi(player_health - amount, 0)
	print("player health: ", player_health)
	health_changed.emit(player_health)
