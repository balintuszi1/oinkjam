extends Area2D

signal is_player_working(work)

@onready var progress_UI = $UI

var working_player = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		working_player = body
		is_player_working.emit(true)
		progress_UI.show()
		print("Player is at the station")


func _on_body_exited(body: Node2D) -> void:
	if body == working_player:
		working_player = null
		is_player_working.emit(true)
		progress_UI.hide()
		print("Player left")
