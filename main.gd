extends Node


@export var enemy_scene: PackedScene

var score_label: Label
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Score:", score)
	$EnemyTimer.start()
	score_label = $CanvasLayer/Score
	score_label.text = str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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
