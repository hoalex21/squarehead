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
	
	score_label = $HUD/Score
	score_label.text = str(score)
	
	$"HUD/Heart Grid Container".show()
	$HUD/Score.show()
	$"HUD/Game Over".hide()
	$"HUD/Game Over Score".hide()
	$HUD/VBoxContainer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	health_display()
	
	if player.health <= 0:
		player.die()
		die()


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
		var node_string = "HUD/Heart Grid Container/Heart %s" % str(i+1)
		if player:
			if i < player.health:
				get_node(node_string).texture = load("res://images/heart.png")
			else:
				get_node(node_string).texture = load("res://images/empty_heart.png")


func die():
	$"HUD/Heart Grid Container".hide()
	$HUD/Score.hide()
	$"HUD/Game Over".show()
	$"HUD/Game Over Score".show()
	$"HUD/Game Over Score".text = "Score: %s" % str(score)
	$HUD/VBoxContainer.show()
	$"HUD/VBoxContainer/Main Menu".grab_focus()
