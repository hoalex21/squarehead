extends Node

@export var enemy_scene: PackedScene
var enemy_timer: Timer

var player: Node

var score_label: Label
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	
	enemy_timer = $EnemyTimer
	enemy_timer.start()
	
	score_label = $CanvasLayer/Score
	score_label.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	health_display()


func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = get_node("EnemyPath/EnemySpawnLocation")
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	add_child(enemy)


func score_add(num):
	score += num
	score_label.text = str(score)


func score_subtract(num):
	score -= num
	score_label.text = str(score)


func health_display():
	for i in range(0, 5):
		var node_string = "CanvasLayer/Heart Grid Container/Heart %s" % str(i+1)
		if i < player.health:
			get_node(node_string).texture = load("res://images/heart.png")
		else:
			get_node(node_string).texture = load("res://images/empty_heart.png")
