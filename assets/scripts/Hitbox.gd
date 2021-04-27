extends Area2D

class_name Hitbox

export (int, FLAGS, "Player", "Enemy") var MASK := 0
export (int) var damage := 0

var knockback_vector := Vector2.ZERO

signal hit_success(hurtbox)

func _on_Hitbox_area_entered(area):
	if area is Hurtbox && (MASK & area.LAYER) != 0:
		emit_signal("hit_success", area as Hurtbox)
		area.damage(self as Hitbox)
