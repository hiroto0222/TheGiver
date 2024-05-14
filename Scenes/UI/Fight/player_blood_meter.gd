extends Control


@onready var blood_meter: ProgressBar = $BloodMeter
@onready var blood_value: Label = $BloodValue


func _ready() -> void:
	blood_meter.max_value = PlayerState.max_player_blood
	blood_meter.value = PlayerState.player_blood
	blood_value.text = "%d/%d" % [PlayerState.player_blood, PlayerState.max_player_blood]

	PlayerState.blood_changed.connect(on_blood_changed)
	PlayerState.set_max_blood.connect(on_set_max_blood)


func on_blood_changed(blood: int) -> void:
	blood_meter.value = blood
	blood_value.text = "%d/%d" % [blood, PlayerState.max_player_blood]


func on_set_max_blood(max_blood: int) -> void:
	blood_meter.max_value = max_blood
	blood_value.text = "%d/%d" % [PlayerState.player_blood, max_blood]
