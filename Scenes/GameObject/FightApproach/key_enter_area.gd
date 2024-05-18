extends Node2D
class_name FightApproachKeyEnterArea

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

var curr_key_input: FightApproachKeyInput


func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)


func check_correct_key_press(pressed_key: String, success_pitch_scale: float) -> bool:
	if curr_key_input == null or curr_key_input.is_processed:
		return false

	curr_key_input.is_processed = true
	if pressed_key == curr_key_input.key_letter:
		curr_key_input.success(success_pitch_scale)
		return true
	else:
		curr_key_input.miss()
		return false


func on_body_entered(other_body: Node2D) -> void:
	sprite_2d.modulate = Color("#00b23b") # change to color green
	if other_body is FightApproachKeyInput:
		curr_key_input = other_body


func on_body_exited(other_body: Node2D) -> void:
	sprite_2d.modulate = Color("#ffffff")
	if other_body is FightApproachKeyInput:
		if !curr_key_input.is_processed:
			curr_key_input.miss()
		curr_key_input = null
