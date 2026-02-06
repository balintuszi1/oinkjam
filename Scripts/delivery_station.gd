extends Area2D

@onready var ui = $UI
@onready var label = $UI/Label

@export var items_count = 0
@export var item = "delivery"
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

func _ready() -> void:
	if not Global.add_money.is_connected(add_document): Global.add_money.connect(add_document)
	set_text()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and Global.current_object == self:
		give_item()
				
func give_item():
	if items_count == -1 or items_count > 0:
		Global.give_item.emit(item, amount)
		if items_count >= amount:
			items_count -= amount
		if items_count == 0:
			label.text = ""
	
func add_document(money_amount=0):
	if items_count != -1: items_count += 1
	
func set_text():
	pass
