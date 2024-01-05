extends CharacterBody2D

@export var speed = 400
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO
	
	$NavigationAgent2D.target_position = player.position
	direction = $NavigationAgent2D.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		var groups = collider.get_groups()
		
		if "projectile" in groups:
			queue_free()
			collider.hit_enemy()
