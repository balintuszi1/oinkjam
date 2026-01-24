extends Area2D

signal is_player_working(work)
signal reward(amount)

@onready var progress_UI = $UI
@onready var progress_bar = $UI/ProgressBar
@onready var progress_label = $UI/Label

var working_player = null
var is_at_desk = false
var work_progress = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and working_player and !is_at_desk:
			begin_work(working_player)
	elif working_player and is_at_desk:
		if Input.is_action_just_pressed("move_left"):
			leave_desk(working_player, "left")
		elif Input.is_action_just_pressed("move_right"):
			leave_desk(working_player, "right")
		elif Input.is_action_just_pressed("interact"):
			leave_desk(working_player)
	work(delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		working_player = body
		progress_label.text = "Press E to work"
		progress_UI.show()
		if work_progress <= 0: progress_bar.hide()
		print("Player is at the station")

func _on_body_exited(body: Node2D) -> void:
	working_player = null

func work(delta):
	if Input.is_action_pressed("work") and working_player and is_at_desk:
		if work_progress >= 100:
			complete_work()
		if work_progress < 100:
			progress_label.text = "Working..."
			work_progress += 25 * delta
			update_progress(work_progress)
	else:
		if work_progress > 0:
			if is_at_desk: 
				progress_label.text = "Hold SPACE to work"
			else:
				progress_label.text = "Come back to work"
			work_progress -= 2.5 * delta
			update_progress(work_progress)
		elif !working_player:
			progress_UI.hide()

func begin_work(player:Node2D):
	is_player_working.emit(true)
	player.position = Vector2(self.position.x, 220) 
	progress_label.text = "Hold SPACE to work"
	progress_bar.show()
	is_at_desk = true

func complete_work():
	progress_label.text = "Hold SPACE to work"
	work_progress = 0
	reward.emit(1)
	
func leave_desk(player:Node2D, direction = null):
	if player.is_in_group("player"):
		if direction == "right":
			player.position = Vector2(self.position.x+30, 234)
		elif direction == "left":
			player.position = Vector2(self.position.x-30, 234)
		else:
			player.position = Vector2(self.position.x, 234)
		working_player = player
		is_at_desk = false
		progress_label.text = "Press E to work"
		progress_UI.show()
		is_player_working.emit(false)
		if work_progress <= 0: progress_bar.hide()
		print("Player is at the station")

func update_progress(value):
	progress_bar.value = value
	

	
