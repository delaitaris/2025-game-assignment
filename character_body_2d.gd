extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -700.0

var isSliding:bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#movement
	var direction = Input.get_axis("A", "D")
	if direction:
		velocity.x == direction * SPEED


	velocity.x = move_toward(velocity.x, 0, SPEED)



	move_and_slide()
