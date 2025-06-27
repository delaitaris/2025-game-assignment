extends CharacterBody2D

@export var small_size: Vector2 = Vector2(32, 16)
@export var medium_size: Vector2 = Vector2(32, 32)
var current_size_state: Vector2
var is_moving = false
const SPEED = 50.0
const JUMP_VELOCITY = -300.00
var isOnFloor = false
var wallgrip = false
func _physics_process(delta):
	# Add the gravity, wallgripping and walljumping
	if not is_on_floor() and is_on_wall() and (Input.is_action_pressed("A") or Input.is_action_pressed("D") and velocity.y < 0.0):
		wallgrip = true
		velocity += get_gravity() * delta / 2
		if wallgrip and Input.is_action_pressed("A") or Input.is_action_pressed("D"):
			if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
				velocity.x += 300.0
				velocity.y += -300.0
			if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
				velocity.x -= 300.0
				velocity.y += -300.0
	else:
		velocity += get_gravity() * delta
	#rolling WIP
	if velocity.y >= 100.0 and !isOnFloor: 
		if Input.is_action_pressed("A") and is_on_floor():
			velocity.x += 50.0
		if Input.is_action_pressed("D") and is_on_floor():
			velocity.x -= 50.0
	# Handle jump with variable heights depending on speeds
	if Input.is_action_just_pressed("Space") and is_on_floor():
		if velocity.x == 0.0:
			velocity.y = JUMP_VELOCITY / 2
		if velocity.x <= -125.0 or velocity.x >= 125.0:
			velocity.y = JUMP_VELOCITY
		if velocity.x <= -250.0 or velocity.x >= 250.0:
			velocity.y = JUMP_VELOCITY * 1.1
		if velocity.x <= -375.0 or velocity.x >= 375.0:
			velocity.y = JUMP_VELOCITY * 1.2
		if velocity.x <= -500.0 or velocity.x >= 500.0:
			velocity.y = JUMP_VELOCITY * 1.3
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("A", "D")
	$"Sprite2D".scale = Vector2(0.773, 1)
	$"Sprite2D".position = Vector2(7.5, 0)
	$CollisionShape2D.shape.size = Vector2(99, 129)
	$CollisionShape2D.position = Vector2(7.5, 0)
	if direction and not Input.is_action_pressed("S"):
		is_moving = true
		velocity.x * 0.9
		velocity.x += direction * SPEED / 2
		if Input.is_action_pressed("A") and velocity.x <= -500.0 and !Input.is_action_pressed("D"):
			velocity.x = -500.0
		if Input.is_action_pressed("D") and velocity.x >= 500.0 and !Input.is_action_pressed("A"):
			velocity.x = 500.0
	else: #slide
		if Input.is_action_pressed("S"):
			$"Sprite2D".scale = Vector2(1, 0.5)
			$"Sprite2D".position = Vector2(7.5, 30)
			$"CollisionShape2D".shape.size = Vector2(129, 49.5)
			$"CollisionShape2D".position = Vector2(7.5, 35)
			if is_moving:
				velocity.x = move_toward(velocity.x, 0, 4.0)
			elif Input.is_action_pressed("A") or Input.is_action_pressed("D"):
				pass
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 20.0)
	
	if is_on_floor() and !isOnFloor:
		isOnFloor = true
		# just touched floor
		
	elif !is_on_floor() and isOnFloor:
		isOnFloor = false
		#just left floor
	
	move_and_slide()
