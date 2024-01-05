extends CharacterBody2D

@export var speed = 400
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play("idle_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Vector2.ZERO
	
	$NavigationAgent2D.target_position = player.position
	direction = $NavigationAgent2D.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	if direction.x > 0 && abs(direction.y) - direction.x < 0:
		$AnimatedSprite2D.play("walk_right")
	elif direction.x < 0 && abs(direction.y) + direction.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("walk_up")
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		var groups = collider.get_groups()
		
		if "projectile" in groups:
			queue_free()
			collider.hit_enemy()
