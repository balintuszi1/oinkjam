extends Area2D

@onready var ui = $UI
@onready var up_arrow = $UI/Up
@onready var down_arrow = $UI/Down

var player = null
static var is_in_elevator = false
static var offset_y = 0 #222-Global.ground_height #substarct elevator height from the ground height
static var offset_x = 0

func _process(delta: float) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			if is_in_elevator:
				on_elevator_leave()
			else:
				on_elevator_enter()
		if Input.is_action_just_pressed("move_left") and is_in_elevator: on_elevator_leave("left")
		if Input.is_action_just_pressed("move_right") and is_in_elevator: on_elevator_leave("right")
	
	if Global.active_elevator == self:
		if Input.is_action_just_pressed("move_up") and Global.current_floor < Global.MAX_FLOORS:
			Global.move_floors.emit(1)
			inactivate()
		elif Input.is_action_just_pressed("move_down") and Global.current_floor > 1:
			Global.move_floors.emit(-1)
			inactivate()
			
func on_elevator_enter():
	Global.active_elevator = self
	Global.is_player_in_elevator.emit(true)
	show_arrows()
	is_in_elevator = true
	
func on_elevator_leave(direction=null):
	Global.active_elevator = null
	Global.is_player_in_elevator.emit(false)
	leave(player, direction)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null

func inactivate():
	player = null
	ui.hide()
	
func activate():
	Global.active_elevator = self
	show_arrows()

func show_arrows():
	ui.show()
	if Global.current_floor >= Global.MAX_FLOORS: 
		up_arrow.hide()
	else:
		up_arrow.show()
	if Global.current_floor <= 1: 
		down_arrow.hide()
	else:
		down_arrow.show()

func leave(body:Node2D, direction = null):
	var pos_x = self.global_position.x
	if body.is_in_group("player"):
		if direction == "right": pos_x = self.global_position.x+offset_x
		elif direction == "left": pos_x = self.global_position.x-offset_x
		else: pos_x = self.global_position.x
		body.global_position = Vector2(pos_x, Global.get_floor_y()-offset_y)
		ui.hide()
		is_in_elevator = false
