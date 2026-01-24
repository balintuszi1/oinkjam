extends CharacterBody2D

@export var speed = 100

var can_move = true

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if can_move:
		velocity.x = direction * speed
		move_and_slide()
	
		if direction > 0:
			$Sprite2D.flip_h = false
		elif direction < 0:
			$Sprite2D.flip_h = true
		
func work(state):
	if state == true:
		can_move = false
	else:
		can_move = true
