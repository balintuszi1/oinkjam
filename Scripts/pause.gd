extends CanvasLayer

var is_paused = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	self.visible = is_paused


func _on_close_button_pressed() -> void:
	toggle_pause()
