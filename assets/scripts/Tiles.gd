extends TileMap

export (Array, PackedScene) var replacements

func _ready():
	for i in range(replacements.size()):
		if replacements[i] != null:
			for position in get_used_cells_by_id(i):
				var scene = replacements[i].instance()
				scene.global_position = map_to_world(position, true) + cell_size/2
				if is_cell_transposed(position.x, position.y):
					scene.rotate(-PI/2)
				if is_cell_y_flipped(position.x, position.y):
					scene.rotate(-PI)
				add_child(scene)
				set_cellv(position, -1)
