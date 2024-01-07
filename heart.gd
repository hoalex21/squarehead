extends Area2D

var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.set_one_shot(true)
	timer.start(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timer.is_stopped():
		queue_free()


func _on_body_entered(body):
	if "player" in body.get_groups():
		if body.health < 5:
			body.health_add(1)
			queue_free()
