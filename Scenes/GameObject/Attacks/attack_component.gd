extends Node
class_name Attack

const SPAWN_TIME := 0.5

@export var attack_object_scene: PackedScene
@export var attack_duration: int = 10

var timer := Timer.new()
var spawn_timer := Timer.new()


func _ready() -> void:
	# total timer for current attack sequence
	timer.wait_time = attack_duration
	add_child(timer)
	timer.start()

	# timer for spawning attacks
	spawn_timer.wait_time = SPAWN_TIME
	spawn_timer.one_shot = false # repeat timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()


func on_spawn_timer_timeout() -> void:
	var attack_object_instance := attack_object_scene.instantiate()
	add_child(attack_object_instance)
