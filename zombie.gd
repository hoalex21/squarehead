extends CharacterBody2D

@export var speed = 400
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play("idle_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO
	
	if player:
		$NavigationAgent2D.target_position = player.position
		direction = $NavigationAgent2D.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if direction.x > 0 && abs(direction.y) - direction.x < 0:
		$AnimatedSprite2D.play("walk_right")
	elif direction.x < 0 && abs(direction.y) + direction.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("walk_up")
	
	if direction.x == 0 && direction.y == 0:
		if $AnimatedSprite2D.animation == "walk_right":
			$AnimatedSprite2D.play("idle_right")
		elif $AnimatedSprite2D.animation == "walk_left":
			$AnimatedSprite2D.play("idle_left")
		elif $AnimatedSprite2D.animation == "walk_down":
			$AnimatedSprite2D.play("idle_down")
		elif $AnimatedSprite2D.animation == "walk_up":
			$AnimatedSprite2D.play("idle_up")
	
	if collision:
		var collider = collision.get_collider()
		
		if collider:
			var groups = collider.get_groups()
			
			if "projectile" in groups:
				get_parent().score_add(100)
				queue_free()
				collider.hit_enemy()
