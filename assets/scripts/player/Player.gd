extends KinematicBody2D

enum {MOVE, DASH, DEATH}

#Jumping
export (float) var JUMP_STRENGTH := 225
export (float) var GRAVITY := 1400.0
export (float) var FALL_FACTOR := 1.25
export (float) var HOLD_FACTOR := 0.25
export (float) var FALL_SPEED = 275
var grounded := false
var air_jump := true

#Movement
export (float) var ACCELERATION := 1800.0
export (float) var FRICTION := 1800.0
export (float) var MAX_SPEED := 160.0

#Dashing
export (float) var DASH_SPEED := 800.0
export (float) var DASH_DECEL := 5500.0
export (float) var DASH_ANGLE := PI/8
export (float) var DASH_COOLDOWN := 0.5
export (PackedScene) var DASH_PARTICLE = null
var dash_direction := Vector2.ZERO
var dash_available := true
onready var dash_cooldown : Timer


#Attack
export (int) var damage := 1
export (float) var KNOCKBACK_STRENGTH := 125.0

#Health
export (int) var MAX_HEALTH := 6
export (int) var INITIAL_HEALTH := 5
export (int) var DAMAGE_KNOCKBACK := 100

var aim_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var state := MOVE

export (Color) var damage_colour := Color.red
export (Color) var dash_colour := Color.white

func _ready():
	$Slash/Hitbox.damage = damage
	PlayerStats.player_max_health = MAX_HEALTH
	PlayerStats.player_health = INITIAL_HEALTH
	dash_cooldown = PlayerStats.get_node("DashCooldown")
	dash_cooldown.wait_time = DASH_COOLDOWN\

func _process(delta):
	aim_direction = global_position.direction_to(get_global_mouse_position())
	$DirectionArrow.rotation = aim_direction.angle()

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		DASH:
			dash(delta)
		DEATH:
			death(delta)
	
	velocity = move_and_slide(velocity)
	#move_and_collide(velocity * delta)

func death(delta):
	velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
	$PlayerSprite.play("Idle")

func dash(delta):
	velocity = velocity.move_toward(dash_direction*MAX_SPEED, DASH_DECEL*delta)
	$PlayerSprite.flip_h = velocity.x < 0

func move(delta):
	var input = 1 if Input.is_action_pressed("movement_right") else -Input.get_action_strength("movement_left")
	
	#Movement from input vector
	if input != 0:
		velocity.x = move_toward(velocity.x, input*MAX_SPEED, ACCELERATION*delta)
		$PlayerSprite.play("Run")
		$PlayerSprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
		$PlayerSprite.play("Idle")
	
	if Input.is_action_just_pressed("movement_jump") && (grounded || air_jump):
		air_jump = grounded
		velocity.y = -JUMP_STRENGTH
		$JumpTimer.start()
		$Jump.play()
	
	if ($JumpTimer.time_left > 0):
		if (not Input.is_action_pressed("movement_jump")):
			$JumpTimer.stop()
		velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY*HOLD_FACTOR*delta)
	else:
		if velocity.y > 0:
			velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY*FALL_FACTOR*delta)
		else:
			velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY*delta)
	
	if Input.is_action_just_pressed("attack"):
		$Slash/SlashAnimation.play("Attack")
		$Slash.rotation = aim_direction.angle()
		$Slash/Sprite.flip_v = abs(aim_direction.angle()) > PI/2
		$Slash/Hitbox.knockback_vector = aim_direction*KNOCKBACK_STRENGTH
		$SlashSound.play()
	
	if Input.is_action_just_pressed("movement_dash") && dash_available && dash_cooldown.is_stopped():
		dash_direction = aim_direction
		var angle = round(dash_direction.angle()/DASH_ANGLE)*DASH_ANGLE - dash_direction.angle()
		dash_direction = dash_direction.rotated(angle)
		state = DASH
		velocity = DASH_SPEED*dash_direction
		$DashTimer.start()
		$DashParticleTimer.start()
		dash_cooldown.start()
		$PlayerSprite.material.set_shader_param("colour", dash_colour)
		$Hurtbox.set_invincible(true)
		$Dash.play()

func _on_grounded(body):
	dash_available = true
	grounded = true
	air_jump = true

func _on_ground_left(body):
	grounded = false

func _on_dash_finish():
	state = MOVE
	dash_available = grounded
	$Hurtbox.set_invincible(false)
	$DashParticleTimer.stop()

func _on_damage_taken(hitbox):
	PlayerStats.player_health -= hitbox.damage
	velocity = hitbox.knockback_vector
	$PlayerSprite.material.set_shader_param("colour", damage_colour)
	if PlayerStats.player_health <= 0:
		state = DEATH
		$AnimationPlayer.play("Death")
	else:
		$Hurt.play()

func _on_invincibility_start():
	$PlayerSprite.material.set_shader_param("enabled", true)

func _on_invincibility_end():
	$PlayerSprite.material.set_shader_param("enabled", false)

func _on_spawn_dash_particle():
	if DASH_PARTICLE != null:
		var particle = DASH_PARTICLE.instance()
		get_parent().add_child(particle)
		particle.global_position = global_position
	pass # Replace with function body.

func die():
	get_tree().change_scene("res://assets/Scenes/End Screen.tscn")

func _on_hit_success(hurtbox):
	if !grounded:
		velocity = -$Slash/Hitbox.knockback_vector*2
