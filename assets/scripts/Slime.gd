extends KinematicBody2D

export (float) var GRAVITY := 1400.0
export (float) var FALL_SPEED := 180.0

export (float) var MOVEMENT_SPEED := 30.0
export (float) var ACCELERATION := 300.0
export ({LEFT = -1, RIGHT = 1}) var direction := 1

export (float) var KNOCKBACK := 250.0

export (float) var health := 1

var velocity := Vector2.ZERO

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, MOVEMENT_SPEED*direction, ACCELERATION*delta)
	velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY*delta)
	
	var old = velocity
	velocity = move_and_slide(velocity)
	if (old - velocity).x != 0:
		direction *= -1
	
	$AnimatedSprite.flip_h = direction > 0

func _on_damage_taken(hitbox : Hitbox):
	velocity += hitbox.knockback_vector
	health -= hitbox.damage
	if health <= 0:
		$Hurtbox.set_invincible(true)
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$DeathAnim.play("Death")

func _on_hit_success(hurtbox):
	$Hitbox.knockback_vector = global_position.direction_to(hurtbox.global_position)
	$Hitbox.knockback_vector.y = 0
	$Hitbox.knockback_vector = $Hitbox.knockback_vector.normalized()*KNOCKBACK
