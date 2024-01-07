extends CharacterBody2D

var dead = false

@export var health = 3
@export var armor = 0
@export var speed = 500

@export var weapon_speed = 1500

@export var invincible_speed = 2
var invincible_timer = Timer.new()

@export var shot_speed = 1
var shot_speed_timer = Timer.new()

var animated_sprite: AnimatedSprite2D

var weapon: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon = preload("res://projectile.tscn")
	
	add_child(invincible_timer)
	invincible_timer.set_one_shot(true)
	
	add_child(shot_speed_timer)
	shot_speed_timer.set_one_shot(true)
	shot_speed_timer.start()
	
	animated_sprite = $AnimatedSprite2D
	animated_sprite.animation = "idle_down"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Movement
	velocity = Vector2.ZERO # The player's movement vector.
	
	if not dead:
		if Input.is_action_pressed("move_right"):
			if animated_sprite.animation != "walk_down" && animated_sprite.animation != "walk_up":
				animated_sprite.play("walk_right")
			velocity.x += 1
		elif animated_sprite.animation == "walk_right":
			animated_sprite.play("idle_right")
		
		if Input.is_action_pressed("move_left"):
			if animated_sprite.animation != "walk_down" && animated_sprite.animation != "walk_up":
				animated_sprite.play("walk_left")
			velocity.x -= 1
		elif animated_sprite.animation == "walk_left":
			animated_sprite.play("idle_left")
		
		if Input.is_action_pressed("move_down"):
			animated_sprite.play("walk_down")
			velocity.y += 1
		elif animated_sprite.animation == "walk_down":
				animated_sprite.play("idle_down")
		
		if Input.is_action_pressed("move_up"):
			animated_sprite.play("walk_up")
			velocity.y -= 1
		elif animated_sprite.animation == "walk_up":
				animated_sprite.play("idle_up")
		
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		
		move_and_slide()
		
		# Shooting
		if Input.is_action_pressed("arrow_right"):
			fire(weapon_speed, 0)
		elif Input.is_action_pressed("arrow_left"):
			fire(-weapon_speed, 0)
		if Input.is_action_pressed("arrow_down"):
			fire(0, weapon_speed)
		if Input.is_action_pressed("arrow_up"):
			fire(0, -weapon_speed)


func fire(x, y):
	if shot_speed_timer.is_stopped():
		var weapon_instance = weapon.instantiate()
		weapon_instance.position = global_position
		if y == 0:
			if x > 0:
				weapon_instance.rotation = PI / 2
			else:
				weapon_instance.rotation = -PI / 2
		else:
			if y > 0:
				weapon_instance.rotation = PI
		weapon_instance.apply_impulse(
			Vector2(x, y), 
			Vector2.ZERO
		)
		get_tree().get_root().call_deferred("add_child", weapon_instance)
		shot_speed_timer.start(shot_speed)


func take_damage(num):
	if invincible_timer.is_stopped():
		health -= num
		invincible_timer.start(invincible_speed)


func health_add(num):
	if health < 5:
		health += num


func die():
	hide()
	dead = true
