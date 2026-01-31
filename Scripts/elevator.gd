extends Area2D

@onready var ui = $UI
@onready var up_arrow = $UI/Up
@onready var down_arrow = $UI/Down
@onready var sprite = $AnimatedSprite2D

@export var offset_y = 0 #222-Global.ground_height #substarct elevator height from the ground height
@export var offset_x = 0

var player = null
var is_in_elevator = false
var is_door_opening = false
var can_use_elevator = false
var is_moving = false

func _process(delta: float) -> void:
	if player:
		if Input.is_action_just_pressed("interact"):
			if is_in_elevator and Global.active_elevator == self:
				on_elevator_leave()
			elif can_use_elevator:
				on_elevator_enter()
		if is_in_elevator and Global.active_elevator == self:
			if Input.is_action_just_pressed("move_left"): on_elevator_leave("left")
			if Input.is_action_just_pressed("move_right"): on_elevator_leave("right")
	
	if Global.active_elevator == self:
		if Input.is_action_just_pressed("move_up") and Global.current_floor < Global.MAX_FLOORS:
			move_elevator(1)
		elif Input.is_action_just_pressed("move_down") and Global.current_floor > 1:
			move_elevator(-1)
			
func move_elevator(num):
	is_moving = true
	Global.player.hide()
	Global.move_floors.emit(num)
	is_in_elevator = false
	inactivate()
			
func on_elevator_enter():
	Global.active_elevator = self
	Global.is_player_in_elevator.emit(true)
	show_arrows()
	is_in_elevator = true
	player.global_position = Vector2(self.global_position.x, Global.get_floor_y()-offset_y)
	
func on_elevator_leave(direction=null):
	Global.active_elevator = null
	Global.is_player_in_elevator.emit(false)
	leave(player, direction)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_door_opening = true
		player = body
		if sprite.animation != "open": sprite.play("open")
		can_use_elevator = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_door_opening = false
		player = null
		if sprite.animation != "close": sprite.play("close")
		await sprite.animation_finished
		if !is_moving: Global.player.show()
		can_use_elevator = false
		

func inactivate():
	ui.hide()
	
func activate():
	Global.active_elevator = self
	is_in_elevator = true
	is_moving = false
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


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_door_opening and sprite.animation == "close":
		sprite.play("open")
	elif !is_door_opening and sprite.animation == "open":
		sprite.play("close")
