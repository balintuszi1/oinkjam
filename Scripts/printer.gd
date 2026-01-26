extends Area2D

@onready var printer_label = $UI/Label
@export var papers = 10
@export var requires_paper = false
@export var texture_paper_1: Texture2D
@export var texture_paper_2: Texture2D
@export var texture_paper_3: Texture2D
@export var texture_paper_loaded: Texture2D

@onready var front_tray = $output
@onready var paper_tray = $input

var player = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		printer_label.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		printer_label.hide()

func _ready() -> void:
	update_texture()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player and (papers > 0 or !Global.printer_requires_paper):
		if Global.printer_requires_paper:
			papers -= 1
		Global.give_documents.emit(1)
		update_texture()
		if papers <= 0:
			printer_label.text = "Out of paper!"
		
func update_texture():
	if papers >= 6:
		front_tray.texture = texture_paper_3
	elif papers >= 4:
		front_tray.texture = texture_paper_2
	elif papers >= 1:
		front_tray.texture = texture_paper_1
	else:
		front_tray.texture = null
	
	
	
