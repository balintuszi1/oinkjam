extends CharacterBody2D

@export var speed = 100

var can_move = true
var inventory = {
	"left_hand": {"item": "none", "amount": 0},
	"right_hand": {"item": "none", "amount": 0}
}
var hand_capacity = {
	"paper": 5,
	"black_ink": 1,
	"blue_ink": 1,
	"magenta_ink": 1,
	"yellow_ink": 1,
	"delivery": 1
}
var paper_limit = 5

var papers = 0

func _ready() -> void:
	Global.player = self

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if can_move:
		velocity.x = direction * speed
		move_and_slide()
	
		if direction > 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
		
func freeze_movement(state):
	if state == true:
		can_move = false
	else:
		can_move = true
		
func pickup_item(item):
	if (inventory["right_hand"]["item"] == "none") or inventory["right_hand"]["item"] == item:
		if inventory["right_hand"]["amount"] < hand_capacity[item]:
			inventory["right_hand"]["item"] = item
			inventory["right_hand"]["amount"] += 1
	elif (inventory["left_hand"]["item"] == "none") or inventory["left_hand"]["item"] == item:
		if inventory["left_hand"]["amount"] < hand_capacity[item]:
			inventory["left_hand"]["item"] = item
			inventory["left_hand"]["amount"] += 1
			
func use_item(item, amount:int=1):
	if inventory["right_hand"]["item"] == item:
		inventory["right_hand"]["amount"] -= amount
		if inventory["right_hand"]["amount"] <= 0:
			inventory["right_hand"]["item"] = "none"
	elif inventory["left_hand"]["item"] == item:
		inventory["left_hand"]["amount"] -= amount
		if inventory["left_hand"]["amount"] <= 0:
			inventory["left_hand"]["item"] = "none"
	
func has_item(item):
	if inventory["right_hand"]["item"] == item:
		return inventory["right_hand"]["amount"]
	elif inventory["left_hand"]["item"] == item:
		return inventory["left_hand"]["amount"]
	return false
