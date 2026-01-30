extends CanvasLayer

func _input(event: InputEvent) -> void:
	pass

func toggle_pause():
	get_tree().paused = true
