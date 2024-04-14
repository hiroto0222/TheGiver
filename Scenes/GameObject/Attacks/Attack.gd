extends Node
class_name Attack

@export var attack_duration: int = 5
@export var attack_damage: int = 1

var timer := Timer.new()
