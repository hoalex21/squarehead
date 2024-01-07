extends RigidBody2D

var shot_expiration = .5
var shot_expiration_timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(shot_expiration_timer)
	shot_expiration_timer.set_one_shot(true)
	shot_expiration_timer.start(shot_expiration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if shot_expiration_timer.is_stopped():
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("wall"):
		queue_free()


func hit_enemy():
	queue_free()
