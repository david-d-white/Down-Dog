extends StaticBody2D

func _ready():
	pass # Replace with function body.


func _on_player_contact(body):
	print("player contact")
	$AnimationPlayer.play("Crumble")
	$RegenTimer.start()

func _on_regen_timeout():
	$AnimationPlayer.play("Regen")
