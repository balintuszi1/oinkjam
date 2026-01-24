extends Node2D

@onready var player = $Player
@onready var score_label = $UI/Score

var money = 0

func _on_desk_is_player_working(work: Variant) -> void:
	player.work(work)


func _on_desk_reward(amount: Variant) -> void:
	money += amount
	score_label.text = "Money: " + str(money)
