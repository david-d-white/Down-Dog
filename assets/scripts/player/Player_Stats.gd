extends Node

var player_health := 1 setget set_player_health
var player_max_health := 1 setget set_player_max_health

signal player_health_changed(old_health, new_health)
signal player_max_health_changed(old_max, new_max)

func set_player_max_health(max_health):
	max_health = max(max_health, 1)
	emit_signal("player_max_health_changed", player_max_health, max_health)
	player_max_health = max_health
	if player_max_health < player_health:
		set_player_health(player_max_health)

func set_player_health(health):
	health = max(health, 0)
	emit_signal("player_health_changed", player_health, health)
	player_health = health

