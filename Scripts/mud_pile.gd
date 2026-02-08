extends Area2D

@onready var ui = $UI
@onready var pig_sprite = $MudPileAnimation

var is_in_range = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and is_in_range:
		player.hide()
		pig_sprite.show()
		pig_sprite.play("default")
		await pig_sprite.animation_finished
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = true
		ui.show()
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_in_range = false
		ui.hide()
		player = null
