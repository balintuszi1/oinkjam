extends Node2D

@onready var player = $Player
@onready var score_label = $UI/Score
@onready var desk = $Stations/Desk
@onready var printer = $Stations/Printer

var level = 1
var floor = 1

var money = 0

func _on_desk_is_player_working(work: Variant) -> void:
	player.work(work)

func _on_desk_reward(amount: Variant) -> void:
	money += amount
	score_label.text = "Money: " + str(money)

func load_floor(level, floor):
	pass

func _on_printer_give_paper(amount: Variant) -> void:
	desk.papers += 1
