extends Node2D

func _ready():
	PlayerStats.speedrun_time = 0.0

func _process(delta):
	PlayerStats.speedrun_time += delta
