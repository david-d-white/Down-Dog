extends Node

enum InputModes {KEYBOARD, CONTROLLER}
var input_mode = InputModes.KEYBOARD

signal input_mode_changed()

func _ready():
	if Input.get_connected_joypads().size() > 0:
		input_mode = InputModes.CONTROLLER
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

func _on_joy_connection_changed(device_id, connected):
	if connected:
		input_mode = InputModes.CONTROLLER
		emit_signal("input_mode_changed")
	elif Input.get_connected_joypads().size() <= 0:
		input_mode = InputModes.KEYBOARD
		emit_signal("input_mode_changed")
	print("connection change")
