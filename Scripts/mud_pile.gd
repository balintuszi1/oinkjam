extends Area2D

var is_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and is_in_range:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
