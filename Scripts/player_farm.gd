extends CharacterBody2D

@onready var sprite = $Sprite2D

@export var speed = 100
@export var acceleration = 600
@export var friction = 600

func _ready() -> void:
	Global.player = self

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		sprite.play("walk")
		if direction > 0:
			sprite.flip_h = true
		elif direction < 0:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		sprite.stop()
	
	move_and_slide()
