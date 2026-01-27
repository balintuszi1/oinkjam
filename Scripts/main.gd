extends Node2D

@onready var player = null
@onready var camera = $Camera2D
@onready var score_label = $UI/Score
@onready var floors_container = $Floors
@onready var time_progress_bar = $UI/Time
@onready var timer = $Timer

@export var main_office: PackedScene
@export var room1: PackedScene

var level = 1
var money = 0
var time_left = 60

func _ready() -> void:
	player = get_player()
	Global.give_documents.connect(_on_printer_give_paper)
	Global.is_player_working.connect(_on_desk_is_player_working)
	Global.add_money.connect(_on_desk_reward)
	Global.is_player_in_elevator.connect(_on_player_elevator)
	Global.move_floors.connect(_on_elevator_move)
	
	create_level()
	create_player()
	
	start_timer()

func _on_desk_is_player_working(work: Variant) -> void:
	player.freeze_movement(work)
	
func _on_player_elevator(value: Variant) -> void:
	player.freeze_movement(value)
	
func _on_elevator_move(amount: Variant) -> void:
	Global.active_elevator = null
	Global.current_floor += amount
	move_player()
	var next_floor = get_floor(Global.current_floor-1)
	if next_floor: player.reparent(next_floor)
	await get_tree().create_timer(0.1).timeout
	var next_elevator = get_elevator()
	Global.active_elevator = next_elevator
	Global.active_elevator.activate()
	Global.active_elevator.player = player
	
	if Global.active_elevator == null:
		print("Error: couldn't find elevator on floor: " + str(Global.current_floor-1))
		return

func _on_desk_reward(amount: Variant) -> void:
	money += amount
	add_time(4)
	score_label.text = "Money: " + str(money)

func load_floor(level, floor):
	pass

func _on_printer_give_paper(amount: Variant) -> void:
	player.pickup_item("paper")

func get_player():
	if Global.player: return Global.player
	
func get_all_floors():
	var floors = []
	for i in range(floors_container.get_child_count()):
		if floors_container.get_child(i).get_child_count() > 0: floors.append(floors_container.get_child(i).get_child(0))
	return floors
	
func get_floor(number):
	var all_floors = get_all_floors()
	if floors_container.get_child_count() > number:
		if floors_container.get_child(number).get_child_count() > 0:
			return floors_container.get_child(number).get_child(0)
			
func get_elevator():
	var current_floor = get_floor(Global.current_floor-1)
	if current_floor:
		return current_floor.find_child("Elevator", true, false)
	else: 
		return null

func create_player():
	var all_floors = get_all_floors()
	var main_room = null
	player = get_player()
	
	for room in all_floors:
		if room.has_meta("office"):
			if room.get_meta("office") == true:
				main_room = room
				break
	
	player.reparent(main_room)

func create_level(office_location=1):
	var office = main_office.instantiate()
	floors_container.get_child(office_location).add_child(office)
	for i in range(floors_container.get_child_count()):
		if floors_container.get_child(i).get_child_count() == 0: 
			var room = room1.instantiate()
			floors_container.get_child(i).add_child(room)

func move_player():
	player = get_player()
	print(Global.current_floor)
	player.global_position = Vector2(player.global_position.x, Global.get_floor_y()-6)
	camera.global_position = Vector2(240, 135-((Global.current_floor-1)*270))
	
func start_timer():
	time_progress_bar.value = Global.max_timer
	time_left = Global.max_timer
	timer.start()

func add_time(amount):
	time_left += amount
	time_progress_bar.value = time_left

func _on_timer_timeout() -> void:
	if time_left > 0:
		time_left -= 1
		time_progress_bar.value = time_left
	else:
		timer.stop()
