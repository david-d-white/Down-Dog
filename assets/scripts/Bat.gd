extends KinematicBody2D

enum {IDLE, CHASE}

export (float) var ACCELERATION := 200.0
export (float) var MAX_SPEED := 100.0
export (float) var KNOCKBACK := 250.0
export (int) var health := 3

export (Color) var hit_colour := Color.white

var state = IDLE
var velocity := Vector2.ZERO

var player

func _ready():
	$AnimatedSprite.material.set_shader_param("colour", hit_colour)

func _physics_process(delta):
	match (state):
		CHASE:
			var direction = position.direction_to(player.position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION*delta)
	
	velocity = move_and_slide(velocity)

func _on_player_detected(player):
	state = CHASE
	self.player = player
	$Detection/CollisionShape2D.disabled = true
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.play("fly")

func _on_damaged(hitbox):
	health -= hitbox.damage
	velocity = hitbox.knockback_vector
	if health <= 0:
		state = IDLE
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$DeathAnim.play("Death")

func _on_invincibility_start():
	$AnimatedSprite.material.set_shader_param("enabled", true)

func _on_invincibility_end():
	$AnimatedSprite.material.set_shader_param("enabled", false)

func _on_hit_success(hurtbox):
	$Hitbox.knockback_vector = global_position.direction_to(hurtbox.global_position)
	$Hitbox.knockback_vector.y = 0
	$Hitbox.knockback_vector = $Hitbox.knockback_vector.normalized()*KNOCKBACK
