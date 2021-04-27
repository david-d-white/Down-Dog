extends Node

var golem_health := 1 setget set_golem_health
var golem_max_health := 1 setget set_golem_max_health

signal golem_health_changed(old_health, new_health)

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

