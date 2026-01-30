extends Area2D

@onready var printer_label = $UI/Label
@onready var ui = $UI
@onready var progress_ui = $ProgressUI
@onready var progress_bar = $ProgressUI/ProgressBar
@onready var printer_timer = $Timer
@onready var front_tray = $output
@onready var paper_tray = $input

@export var requires_paper = false
@export var finished_count:int = 10
@export var empty_paper_count:int = 0
@export var blue:int = 0
@export var yellow:int = 0
@export var magenta:int = 0
@export var black:int = 0
@export var item = "paper"
var amount = 1
var is_printing = false


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
			check_for_paper(body)

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
	if empty_paper_count > 0 and is_printing == false:
		print_paper()
		
	if Input.is_action_just_pressed("interact") and Global.current_object == self and (finished_count > 0 or !requires_paper):
		give_item()
		update_texture()
		update_text()
		
	if is_printing:
		progress_bar.value += 200 * delta
		
func check_for_paper(body):
	if body.is_in_group("player") and requires_paper:
		#print("check for paper")
		var load_amount = player.has_item("empty_paper")
		if load_amount > 0:
			empty_paper_count += load_amount
			player.use_item("empty_paper", load_amount)
			update_texture()
			update_text()
			#print("loaded" + "paper")
		
func print_paper():
	is_printing = true
	printer_timer.start()
	progress_ui.show()
	progress_bar.value = 0
		
func give_item():
	if finished_count == -1 or finished_count > 0:
		Global.give_item.emit(item, amount)
		if finished_count >= amount:
			finished_count -= amount
		update_text()
		
func update_texture():
	if finished_count >= 6:
		front_tray.texture = texture_paper_3
	elif finished_count >= 4:
		front_tray.texture = texture_paper_2
	elif finished_count >= 1:
		front_tray.texture = texture_paper_1
	else:
		front_tray.texture = null
	
func update_text():
	if finished_count > 0 or finished_count == -1:
		printer_label.text = "Take paper"
	elif empty_paper_count > 0:
		printer_label.text = "Printing"
	else:
		printer_label.text = "Out of paper"
		
func _on_timer_timeout() -> void:
	empty_paper_count -= 1
	finished_count += 1
	update_texture()
	update_text()
	is_printing = false
	progress_ui.hide()
