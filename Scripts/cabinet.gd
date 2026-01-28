extends Area2D

@onready var ui = $UI

@export var items_count = -1
@export var item = "none"
@export var amount = 1

var player = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		if !Global.touching_objects.has(self):
			Global.touching_objects.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		if Global.touching_objects.has(self):
			Global.touching_objects.erase(self)
		if Global.current_object == self:
			Global.current_object = null
			ui.hide()
		
#func enter_touching_queue(body):
	#var was_touched = false
	#while(not was_touched):
		#var can_be_touched = Global.current_object == self or Global.current_object == null
		#if can_be_touched:
			#activate(body)
			#was_touched = true
	#return
	
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and Global.current_object == self:
		give_item()
				
func give_item():
	if items_count == -1 or items_count > 0:
		Global.give_item.emit(item, amount)
		if items_count >= amount:
			items_count -= amount
		if items_count == 0:
			ui.text = "Empty!"
	
