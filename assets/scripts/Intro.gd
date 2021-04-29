extends Control

export (PackedScene) var level_1

func _ready():
	$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	get_tree().change_scene_to(level_1)

func _input(event):
	if event.is_pressed():
		get_tree().change_scene_to(level_1)
