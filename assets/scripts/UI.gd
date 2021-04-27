extends Control

onready var hearts_empty = $MarginContainer/Hearts_Empty
onready var hearts_half = $MarginContainer/Hearts_Half
onready var hearts_full = $MarginContainer/Hearts_Full

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("player_health_changed", self, "_on_player_health_changed")
	PlayerStats.connect("player_max_health_changed", self, "_on_player_max_health_changed")
	
	_on_player_max_health_changed(0, PlayerStats.player_max_health)
	_on_player_health_changed(0, PlayerStats.player_health)

func _on_player_health_changed(old_health, new_health):
	hearts_half.rect_min_size.x = hearts_half.texture.get_size().x * ceil(new_health/2.0)
	hearts_full.rect_min_size.x = hearts_full.texture.get_size().x * floor(new_health/2.0)

func _on_player_max_health_changed(old_max, new_max):
	hearts_empty.rect_min_size.x = hearts_empty.texture.get_size().x * ceil(new_max/2)
