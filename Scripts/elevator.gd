extends Area2D

@onready var ui = $UI

var player = null
var is_in_elevator = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player and !is_in_elevator:
		player.global_position = Vector2(self.global_position.x, self.global_position.y)
		Global.is_player_in_elevator.emit(true)
		ui.show()
		is_in_elevator = true
	elif player and is_in_elevator:
		movement_handler()
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !is_in_elevator:
			player = null
			ui.hide()

func movement_handler():
	if Input.is_action_just_pressed("move_left"):
		leave(player, "left")
		return
	if Input.is_action_just_pressed("move_right"):
		leave(player, "right")
		return
	if Input.is_action_just_pressed("interact"):
		leave(player)
		return
	if Input.is_action_just_pressed("move_up"):
		Global.move_floors.emit(1)
		return
	if Input.is_action_just_pressed("move_down"):
		Global.move_floors.emit(-1)
		return
	

func leave(current_player:Node2D, direction = null):
	if current_player.is_in_group("player"):
		if direction == "right":
			current_player.global_position = Vector2(self.global_position.x+6, Global.get_floor_y())
		elif direction == "left":
			current_player.global_position = Vector2(self.global_position.x-6, Global.get_floor_y())
		else:
			current_player.global_position = Vector2(self.global_position.x, Global.get_floor_y())
		ui.hide()
		Global.is_player_in_elevator.emit(false)
		is_in_elevator = false
