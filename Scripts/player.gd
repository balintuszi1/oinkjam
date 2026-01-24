extends CharacterBody2D

@export var speed = 100

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	move_and_slide()
	
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true
		
func work():
	print("I'm working")
