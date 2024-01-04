extends RigidBody2D

@export var speed = 400
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_position = player.position
	var target_position = (player_position - position).normalized()
	
	var velocity = delta * speed
	move_and_collide(target_position * velocity)


func _on_body_entered(body):
	if body.is_in_group("bullet"):
		queue_free()
