extends KinematicBody2D

enum {SLEEPING, IDLE, SPIN, LASER_CHASE, LASER, SHOCKWAVE, RISE, ALIGN}

export (float) var MIN_ATTACK_TIME = 2
export (float) var MAX_ATTACK_TIME = 4

#IDLE
export (float) var IDLE_ACCEL := 200.0
export (float) var IDLE_SPEED := 30.0
export (float) var IDLE_KNOCK := 250.0

#SPIN
export (float) var SPIN_ACCEL := 200.0
export (float) var SPIN_SPEED := 100.0
export (float) var SPIN_KNOCK := 250.0

#SLAM
export(float) var SLAM_KNOCK := 350

#Laser
export (float) var LASER_KNOCK := 350.0

var state = SLEEPING
var velocity = Vector2.ZERO
var speed := 0.0
var knockback := 0.0
var acceleration := 0.0
var player
export (int) var health = 10

func _ready():
	$Hurtbox.set_invincible(true)

func _physics_process(delta):
	match(state):
		SPIN, IDLE:
			chase(delta)
		RISE:
			if $ShockwaveHeightTrigger.get_overlapping_bodies().size()>0:
				velocity = velocity.move_toward(Vector2.UP * speed, acceleration*delta)
			elif velocity != Vector2.ZERO:
				velocity = velocity.move_toward(Vector2.ZERO * speed, acceleration*delta)
			else:
				change_state(SHOCKWAVE)
		SHOCKWAVE:
			if $ShockwaveHeightTrigger.get_overlapping_bodies().size() == 0:
				velocity = velocity.move_toward(Vector2.DOWN * speed/2, acceleration*delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, acceleration*delta)
				if $AnimationPlayer.current_animation != "Shockwave":
					hide_all()
					print("Shockwave!")
					$AnimationPlayer.play("Shockwave")
		LASER_CHASE:
			chase(delta)
			if $LaserHit/LaserTrigger.get_overlapping_bodies().size() > 0:
				hide_all()
				$AnimationPlayer.play("Laser")
				change_state(LASER)
		LASER:
			velocity = velocity.move_toward(Vector2.ZERO, acceleration*delta)
				
	velocity = move_and_slide(velocity)

func chase(delta):
	var direction = position.direction_to(player.position)
	velocity = velocity.move_toward(direction * speed, acceleration*delta)
	set_flip()

func change_state(state):
	var pstate = self.state
	self.state = state
	match (state):
		SLEEPING:
			pass
		IDLE:
			speed = IDLE_SPEED
			acceleration = IDLE_ACCEL
			knockback = IDLE_KNOCK
			hide_all()
			$AnimationPlayer.play("Idle")
			$AttackTimer.start(rand_range(MIN_ATTACK_TIME, MAX_ATTACK_TIME))
			$Hurtbox.set_invincible(false)
		SPIN:
			hide_all()
			speed = 0
			$AnimationPlayer.play("Spin_Start")
			knockback = SPIN_KNOCK
		LASER:
			speed = IDLE_SPEED
			acceleration = IDLE_ACCEL
			if $LaserHit.rotation == 0:
				$LaserHit/Hitbox.knockback_vector.x = -LASER_KNOCK
			else:
				$LaserHit/Hitbox.knockback_vector.x = LASER_KNOCK
		LASER_CHASE, RISE:
			speed = IDLE_SPEED
			acceleration = IDLE_ACCEL
			knockback = IDLE_KNOCK
		SHOCKWAVE:
			speed = IDLE_SPEED
			acceleration = IDLE_ACCEL
			knockback = SLAM_KNOCK
			$Hurtbox.set_invincible(true)

func set_flip():
	$Idle.flip_h = velocity.x > 0
	$Spin.flip_h = velocity.x > 0
	$Laser.flip_h = velocity.x > 0
	$Shockwave.flip_h = velocity.x > 0
	$LaserHit.rotation = PI if velocity.x > 0 else 0

func hide_all():
	$Idle.visible = false
	$Spin.visible = false
	$Laser.visible = false
	$Shockwave.visible = false
	print("hide all")

func _on_ChaseTrigger_body_entered(body):
	match (state):
		SLEEPING:
			self.player = body
			$AnimationPlayer.play("Awaken")

func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"Awaken":
			state = IDLE
			hide_all()
			change_state(IDLE)
			$Hurtbox.set_invincible(false)
		"Spin_Start":
			hide_all()
			speed = SPIN_SPEED
			acceleration = SPIN_ACCEL
			$AnimationPlayer.play("Spin")
			$SpinTimer.start()
		"Spin_End", "Shockwave", "Laser":
			hide_all()
			change_state(IDLE)

func _on_AttackTimer_timeout():
	if $ShockwaveTrigger.get_overlapping_bodies().size() > 0:
		change_state(RISE)
	elif $ChaseTrigger.get_overlapping_bodies().size() > 0:
		change_state(SPIN)
		$Hurtbox.set_invincible(true)
	else:
		change_state(LASER_CHASE)

func _on_spin_finished():
	hide_all()
	speed = 0
	$AnimationPlayer.play("Spin_End")

func _on_SlamHitbox_hit_success(hurtbox):
	$SlamHitbox.knockback_vector = global_position.direction_to(hurtbox.global_position)
	$SlamHitbox.knockback_vector.y = 0
	$SlamHitbox.knockback_vector = $SlamHitbox.knockback_vector.normalized()*SLAM_KNOCK

func _on_BodyHitbox_hit_success(hurtbox):
	$BodyHitbox.knockback_vector = global_position.direction_to(hurtbox.global_position)
	$BodyHitbox.knockback_vector.y = 0
	$BodyHitbox.knockback_vector = $BodyHitbox.knockback_vector.normalized()*knockback

func _on_Hurtbox_damage_taken(hitbox):
	health -= hitbox.damage
	velocity = hitbox.knockback_vector
	if health <= 0:
		state = IDLE
		hide_all()
		$Hurtbox.set_invincible(true)
		$AnimationPlayer.play("Death")

func return_to_menu():
	get_tree().change_scene("res://assets/Scenes/End Screen.tscn")
