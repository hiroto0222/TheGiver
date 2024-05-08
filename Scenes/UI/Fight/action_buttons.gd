extends CanvasLayer
class_name ActionButtons

signal selected(action_type: String)

@onready var fight_button: Button = %FightButton
@onready var act_button: Button = %ActButton
@onready var item_button: Button = %ItemButton
@onready var defend_button: Button = %DefendButton


func _ready() -> void:
	fight_button.grab_focus()
	fight_button.pressed.connect(on_fight_button_pressed)
	act_button.pressed.connect(on_act_button_pressed)
	item_button.pressed.connect(on_item_button_pressed)
	defend_button.pressed.connect(on_defend_button_pressed)


func on_fight_button_pressed() -> void:
	selected.emit("fight")


func on_act_button_pressed() -> void:
	selected.emit("act")


func on_item_button_pressed() -> void:
	selected.emit("items")


func on_defend_button_pressed() -> void:
	selected.emit("defend")


func disable_buttons() -> void:
	fight_button.visible = false
	act_button.visible = false
	item_button.visible = false
	defend_button.visible = false


func enable_buttons() -> void:
	fight_button.visible = true
	act_button.visible = true
	item_button.visible = true
	defend_button.visible = true
	fight_button.grab_focus()
