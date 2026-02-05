extends Node2D

### Nodes ###
@onready var player = null
@onready var camera = $Camera2D
@onready var score_label = $UI/Score
@onready var floors_container = $Floors
@onready var time_progress_bar = $UI/Time
@onready var timer = $Timer
@onready var death_screen = $DeathScreen
@onready var right_hand_icon = $UI/RightHand
@onready var left_hand_icon = $UI/LeftHand

### Audio ###
@export var background_music: AudioStream

### Level generation ###
@export var offices: Array[PackedScene] = []
@export var default_rooms: Array[PackedScene] = []

### Variables ###
var level = 1
var money = 0
var time_left = 60

const window_length_mid = 240
const window_height_mid = 135
const camere_offset = 60
var camera_target = Vector2(window_length_mid, window_height_mid-(get_floor_coordinate())+camere_offset)

var item_textures = {
	"empty_paper": "res://Sprites/empty paper.png",
	"paper": "res://Sprites/empty paper.png",
	"black_ink": "res://Sprites/blackink.png",
	"blue_ink": "res://Sprites/blueink.png",
	"magenta_ink": "res://Sprites/pinkink.png",
	"yellow_ink": "res://Sprites/yellowink.png",
	"delivery": "res://Sprites/blue_brick.png"
}

func get_floor_coordinate(): return (Global.current_floor-1)*Global.window_height

func _ready() -> void:
	#reset progress
	Global.current_floor = 1
	Global.touching_objects = [] 
	Global.current_object = null
	camera_target = Vector2(window_length_mid, window_height_mid-(get_floor_coordinate())+camere_offset)
	
	#setup scene
	death_screen.hide()
	player = get_player()
	
	#connect signals (if not already connected)
	if not Global.give_item.is_connected(_on_give_item): Global.give_item.connect(_on_give_item)
	if not Global.is_player_working.is_connected(_on_desk_is_player_working): Global.is_player_working.connect(_on_desk_is_player_working)
	if not Global.add_money.is_connected(_on_desk_reward): Global.add_money.connect(_on_desk_reward)
	if not Global.is_player_in_elevator.is_connected(_on_player_elevator): Global.is_player_in_elevator.connect(_on_player_elevator)
	if not Global.move_floors.is_connected(_on_elevator_move): Global.move_floors.connect(_on_elevator_move)
	if not Global.refresh_inventory.is_connected(update_inventory_ui): Global.refresh_inventory.connect(update_inventory_ui)
	
	create_level() #generate map
	create_player() #place the player
	player.global_position.y = Global.get_floor_y() #set player position
	camera.global_position = Vector2(window_length_mid, window_height_mid-(get_floor_coordinate())+camere_offset)
	
	Audio.play_music(background_music) #play background music
	start_timer() #start the timer

func _process(delta: float) -> void:
	refresh_objects()
	camera.global_position = camera.global_position.lerp(camera_target, 5*delta)

func _on_desk_is_player_working(work: Variant) -> void:
	player.freeze_movement(work)
	
func _on_player_elevator(value: Variant) -> void:
	player.freeze_movement(value)
	
func _on_elevator_move(amount: Variant) -> void:
	var next_floor = null
	var next_elevator = null
	
	Global.active_elevator = null #sets Global elevator to null
	Global.current_floor += amount #in-/decreases our floor by the amount we moved
	player = get_player() #find the player Node in the current floor
	player.global_position = Vector2(player.global_position.x, Global.get_floor_y()-6)
	camera_target = Vector2(window_length_mid, window_height_mid-(get_floor_coordinate())+camere_offset)
	next_floor = get_floor(Global.current_floor-1)
	if next_floor: player.reparent(next_floor) #moves the player node to be under the current floor
	await get_tree().create_timer(0.1).timeout
	next_elevator = get_elevator()
	Global.active_elevator = next_elevator
	Global.active_elevator.activate(player)

func _on_desk_reward(amount: Variant) -> void:
	money += amount
	add_time(4)
	score_label.text = "Money: " + str(money)

func _on_give_item(item: Variant, amount: Variant) -> void:
	player.pickup_item(item)
	update_inventory_ui()

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
	var office = offices[office_location].instantiate()
	floors_container.get_child(office_location).add_child(office)
	
	for i in range(floors_container.get_child_count()):
		if floors_container.get_child(i).get_child_count() == 0: 
			var room = default_rooms[i].instantiate()
			floors_container.get_child(i).add_child(room)
	
func start_timer():
	time_progress_bar.max_value = Global.max_timer
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
		death_screen.show()
		player.freeze_movement(true)
		
func refresh_objects():
	if player and len(Global.touching_objects) > 0:
		var closest_object = null
		var smallest_distance = 99999999
		
		for object in Global.touching_objects:
			var distance = player.global_position.distance_to(object.global_position)
			if distance < smallest_distance:
				smallest_distance = distance
				closest_object = object
				
		if Global.current_object != closest_object:
			if Global.current_object != null: Global.current_object.ui.hide()
			Global.current_object = closest_object
			if Global.current_object != null:
				Global.current_object.ui.show()
				
func update_inventory_ui():
	var player_right_hand = Global.player.inventory["right_hand"]["item"]
	var player_left_hand = Global.player.inventory["left_hand"]["item"]
	var r_hand_texture = null
	var l_hand_texture = null
	if player_right_hand != "none":
		r_hand_texture = load(item_textures[player_right_hand])
		right_hand_icon.texture = r_hand_texture
	else:
		right_hand_icon.texture = null
	if player_left_hand != "none":
		l_hand_texture = load(item_textures[player_left_hand])
		left_hand_icon.texture = l_hand_texture
	else:
		left_hand_icon.texture = null
