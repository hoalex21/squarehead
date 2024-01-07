extends CharacterBody2D

@export var health = 3
@export var armor = 0
@export var speed = 500
@export var shot_speed = 1
@export var weapon_speed = 1500
var shot_speed_timer = Timer.new()

var weapon: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon = preload("res://projectile.tscn")
	
	add_child(shot_speed_timer)
	shot_speed_timer.set_one_shot(true)
	shot_speed_timer.start()
	
	$AnimatedSprite2D.animation = "idle_down"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Movement
	velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		if $AnimatedSprite2D.animation != "walk_down" && $AnimatedSprite2D.animation != "walk_up":
			$AnimatedSprite2D.play("walk_right")
		velocity.x += 1
	elif $AnimatedSprite2D.animation == "walk_right":
		$AnimatedSprite2D.play("idle_right")
	
	if Input.is_action_pressed("move_left"):
		if $AnimatedSprite2D.animation != "walk_down" && $AnimatedSprite2D.animation != "walk_up":
			$AnimatedSprite2D.play("walk_left")
		velocity.x -= 1
	elif $AnimatedSprite2D.animation == "walk_left":
		$AnimatedSprite2D.play("idle_left")
	
	if Input.is_action_pressed("move_down"):
		$AnimatedSprite2D.play("walk_down")
		velocity.y += 1
	elif $AnimatedSprite2D.animation == "walk_down":
			$AnimatedSprite2D.play("idle_down")
	
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.play("walk_up")
		velocity.y -= 1
	elif $AnimatedSprite2D.animation == "walk_up":
			$AnimatedSprite2D.play("idle_up")
	
	
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
