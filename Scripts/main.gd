extends Node2D

@onready var player = $Player

func _on_desk_is_player_working(work: Variant) -> void:
	player.work()
