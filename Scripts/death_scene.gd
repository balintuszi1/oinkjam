extends CanvasLayer

func _input(event: InputEvent) -> void:
	pass

func toggle_pause():
	get_tree().paused = true


func _on_farm_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/farm.tscn")
