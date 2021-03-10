extends Node2D

onready var _name := $Name
onready var _message := $Message
onready var _message_timer := $MessageTimer

func _ready() -> void:
	_message.text = ""
	_message.visible = false

func set_name(value) -> void:
	_name.text = value

func set_message(value) -> void:
	_message.text = value
	_message.visible = true
	_message_timer.start()

func _on_message_timer_timeout():
	_message.visible = false
