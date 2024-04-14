extends Node2D


@onready var health_bar: ProgressBar = $HealthBar
@onready var health_value: Label = $HealthValue


func _ready() -> void:
	health_bar.max_value = PlayerState.max_health
	health_bar.value = PlayerState.player_health
	health_value.text = "%d/%d" % [PlayerState.player_health, PlayerState.max_health]

	PlayerState.health_changed.connect(on_health_changed)
	PlayerState.max_health_changed.connect(on_max_health_changed)


func on_health_changed(health: int) -> void:
	health_bar.value = health
	health_value.text = "%d/%d" % [health, PlayerState.max_health]


func on_max_health_changed(max_health: int) -> void:
	health_bar.max_value = max_health
	health_value.text = "%d/%d" % [PlayerState.player_health, max_health]
