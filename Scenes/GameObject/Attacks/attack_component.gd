extends Node
class_name Attack

const MAX_ATTACK_DURATION = 12
const MIN_SPAWN_TIME := 0.4
const MAX_SPAWN_TIME := 1.2

@export var attack_object_scene: PackedScene
@export var attack_duration: int = 5

var timer := Timer.new()
var spawn_timer := Timer.new()
var attack_cnt := 0

func _ready() -> void:
	# total timer for current attack sequence
	timer.wait_time = minf(attack_duration + attack_cnt * 1.5, MAX_ATTACK_DURATION)
	add_child(timer)
	timer.start()

	# timer for spawning attacks
	spawn_timer.wait_time = maxf(MAX_SPAWN_TIME - float(attack_cnt) / 5, MIN_SPAWN_TIME)
	spawn_timer.one_shot = false # repeat timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()


func on_spawn_timer_timeout() -> void:
	var attack_object_instance := attack_object_scene.instantiate()
	add_child(attack_object_instance)
