extends CharacterBody2D

@export var small_size: Vector2 = Vector2(32, 16)
@export var medium_size: Vector2 = Vector2(32, 32)
var current_size_state: Vector2
var is_moving = false
const SPEED = 50.0
const JUMP_VELOCITY = -300.00
var isOnFloor = false
var wallgrip = false
var pencilFallStop = false
var pencilCount = 1
var start_position = Vector2(-8, 1)
var isSliding = false
var slideDirCount = 0

func _physics_process(delta):
	# Add the gravity, wallgripping and walljumping
	if not is_on_floor() and is_on_wall() and velocity.y > -500.0:
		wallgrip = true
		velocity += get_gravity() * delta / 2
		if velocity.y > 700.0:
			velocity.y = 700.0
		if is_moving and Input.is_action_just_pressed("Space"):
			if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
				velocity.x += 400.0
				velocity.y = -650.0
			if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
				velocity.x -= 400.0
				velocity.y = -650.0
	else:  #penciling
		if !is_on_floor() and Input.is_action_just_pressed("S") and pencilCount == 1:
			if velocity.y < 75.0 and Input.is_action_pressed("S"):
				if !pencilFallStop:
					pencilFallStop = true
					$"penciling fall cancel timer".start()
		if pencilFallStop:
			velocity.y = 0.0
		else:
			velocity += get_gravity() * delta
	if is_on_floor():
		pencilCount = 1
	if Input.is_action_just_released("S"):
		pencilFallStop = false
	# Handle jump with variable heights depending on speeds
	if Input.is_action_just_pressed("Space") and is_on_floor() and slideDirCount == 0:
		if velocity.x == 0.0:
			velocity.y = JUMP_VELOCITY / 1.1
		if velocity.x <= -125.0 or velocity.x >= 125.0:
			velocity.y = JUMP_VELOCITY
		if velocity.x <= -250.0 or velocity.x >= 250.0:
			velocity.y = JUMP_VELOCITY * 1.2
		if velocity.x <= -375.0 or velocity.x >= 375.0:
			velocity.y = JUMP_VELOCITY * 1.3
		if velocity.x <= -500.0 or velocity.x >= 500.0:
			velocity.y = JUMP_VELOCITY * 1.4
	#slide change direction
	if Input.is_action_pressed("S") and Input.is_action_just_pressed("Space") and is_on_floor() and slideDirCount == 0:
		slideDirCount = 1
		if Input.is_action_pressed("A") and !Input.is_action_pressed("D") and (velocity.x <= 500.0 or velocity.x >= -550.0):
			velocity.x += -650.0
			velocity.y = JUMP_VELOCITY / 3
			if is_on_floor():
				velocity.x = -500.0
		if Input.is_action_pressed("D") and !Input.is_action_pressed("A") and (velocity.x <= 500.0 or velocity.x >= -550.0):
			velocity.x += 650.0
			velocity.y = JUMP_VELOCITY / 3
			if is_on_floor():
				velocity.x = 500.0
	if Input.is_action_just_released("S") and is_on_floor():
		slideDirCount = 0
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("A", "D")
	$"Sprite2D".scale = Vector2(0.773, 1)
	$"Sprite2D".position = Vector2(7.5, 0)
	$CollisionShape2D.shape.size = Vector2(99, 129)
	$CollisionShape2D.position = Vector2(7.5, 0)
	if direction and not Input.is_action_pressed("S") :
		is_moving = true
		velocity.x += direction * SPEED / 2
		if Input.is_action_pressed("A") and velocity.x <= -500.0 and !Input.is_action_pressed("D"):
			velocity.x = -500.0
		if Input.is_action_pressed("D") and velocity.x >= 500.0 and !Input.is_action_pressed("A"):
			velocity.x = 500.0
	else: #sliding
		if Input.is_action_pressed("S"):
			isSliding = true
			$"Sprite2D".scale = Vector2(1, 0.5)
			$"Sprite2D".position = Vector2(7.5, 30)
			$"CollisionShape2D".shape.size = Vector2(129, 49.5)
			$"CollisionShape2D".position = Vector2(7.5, 39)
			if is_moving and is_on_floor():
				velocity.x = move_toward(velocity.x, 0, 4.0)
				if velocity.x == 0.0 and Input.is_action_pressed("S"):
					if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
						velocity.x = -150.0
					if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
						velocity.x = 150.0
			elif Input.is_action_pressed("A") or Input.is_action_pressed("D") or Input.is_action_pressed("Space"):
				pass
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 20.0)
	move_and_slide()
	if position.y > 7500.0:
		position = start_position
	

func _on_penciling_fall_cancel_timer_timeout():
	print("Fallstop")
	pencilFallStop = false
	pencilCount = 2
