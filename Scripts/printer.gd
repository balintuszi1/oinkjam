extends Area2D

@onready var printer_label = $UI/Label
@onready var ui = $UI
@onready var front_tray = $output
@onready var paper_tray = $input

@export var requires_paper = false
@export var items_count = 10
@export var item = "paper"
@export var amount = 1

@export var texture_paper_1: Texture2D
@export var texture_paper_2: Texture2D
@export var texture_paper_3: Texture2D
@export var texture_paper_loaded: Texture2D

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
	update_texture()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and Global.current_object == self and (items_count > 0 or !Global.printer_requires_paper):
		give_item()
		update_texture()
		if items_count == 0:
			printer_label.text = "Out of paper!"
		
func give_item():
	if items_count == -1 or items_count > 0:
		Global.give_item.emit(item, amount)
		if items_count >= amount:
			items_count -= amount
		if items_count == 0:
			printer_label.text = "Empty!"
		
func update_texture():
	if items_count >= 6:
		front_tray.texture = texture_paper_3
	elif items_count >= 4:
		front_tray.texture = texture_paper_2
	elif items_count >= 1:
		front_tray.texture = texture_paper_1
	else:
		front_tray.texture = null
	
	
	
