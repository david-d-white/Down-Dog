extends Control

func _ready():
	GlobalSettings.connect("input_mode_changed", self, "_on_input_mode_changed")
	_on_input_mode_changed()

func _on_input_mode_changed():
	match(GlobalSettings.input_mode):
		GlobalSettings.InputModes.CONTROLLER:
			$MarginContainer/Keyboard.visible = false
			$MarginContainer/Controller.visible = true
		GlobalSettings.InputModes.KEYBOARD:
			$MarginContainer/Keyboard.visible = true
			$MarginContainer/Controller.visible = false

func _input(event):
	if event.is_pressed():
		get_tree().change_scene("res://assets/Scenes/Intro.tscn")
