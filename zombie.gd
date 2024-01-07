extends CharacterBody2D

@export var speed = 400

var animated_sprite: AnimatedSprite2D

var navigation_agent: NavigationAgent2D

var player
var heart_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("idle_down")
	
	navigation_agent = $NavigationAgent2D
	
	heart_scene = preload("res://heart.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO
	
	if player:
		navigation_agent.target_position = player.position
		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if direction.x > 0 && abs(direction.y) - direction.x < 0:
		animated_sprite.play("walk_right")
	elif direction.x < 0 && abs(direction.y) + direction.x < 0:
		animated_sprite.play("walk_left")
	elif direction.y > 0:
		animated_sprite.play("walk_down")
	elif direction.y < 0:
		animated_sprite.play("walk_up")
	
	if direction.x == 0 && direction.y == 0:
		if animated_sprite.animation == "walk_right":
			animated_sprite.play("idle_right")
		elif animated_sprite.animation == "walk_left":
			animated_sprite.play("idle_left")
		elif animated_sprite.animation == "walk_down":
			animated_sprite.play("idle_down")
		elif animated_sprite.animation == "walk_up":
			animated_sprite.play("idle_up")
	
	if collision:
		var collider = collision.get_collider()
		
		if collider:
			var groups = collider.get_groups()
			
			if "projectile" in groups:
				var heart_random = randi_range(0, 14)
				if heart_random == 0:
					var heart = heart_scene.instantiate()
					heart.position = global_position
					get_parent().add_child(heart)
					
				get_parent().score_add(100)
				queue_free()
				collider.hit_enemy()
			
			if "player" in groups:
				collider.take_damage(1)
