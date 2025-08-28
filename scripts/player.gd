extends CharacterBody2D

@onready var game = get_node("/root/game")
@onready var level = get_node("..")
var current_size_state: Vector2
var is_moving = false
const SPEED = 50.0
const JUMP_VELOCITY = -300.00
var pencilFallStop = false
var pencilCount = 1
var start_position = Vector2(-8, 1)
var isSliding = false
var slideDirCount = 0
var slideHBcollide = false
var walljumpHBcollide = false
var gravityMultiplier = 1
var tricks = []
var score = 0
var pencilPointB = false
var pencilPointT = false
var Ptrickcount = 0
var frontflipCount = 0
var frontspringCount = 0

#point system
func _process(_delta):
	game.score.text = str(score) + "\n"
	for trick in tricks:
		game.score.text += trick.text + "\n"

func _physics_process(delta):
	# Add the gravity, wallgripping and walljumping
	gravityMultiplier = 1
	if not is_on_floor() and walljumpHBcollide:
		if is_on_wall():
			gravityMultiplier = 0.5
			if velocity.y > 700.0:
				velocity.y = 700.0
		if Input.is_action_just_pressed("Space"):
			if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
				velocity.x += 400.0
				velocity.y = -400.0
			if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
				velocity.x -= 400.0
				velocity.y = -400.0
			if pencilCount == 2:
				pencilCount = 1
				Ptrickcount = 0
	else:  #penciling
		if !is_on_floor() and Input.is_action_just_pressed("S") and pencilCount == 1:
			if velocity.y < 75.0:
				if !pencilFallStop:
					pencilFallStop = true
					$"penciling fall cancel timer".start()
		if pencilFallStop:
			gravityMultiplier = 0
			velocity.y = 0.0
			if pencilPointB and pencilPointT and !is_on_floor() and Ptrickcount == 0:
				tricks.append(Trick.newPencilTrick())
				Ptrickcount = 1
	velocity += get_gravity() * delta * gravityMultiplier
	if is_on_floor():
		pencilCount = 1
		Ptrickcount = 0
	if Input.is_action_just_released("S"):
		pencilFallStop = false
	# Handle jump with variable heights depending on speeds
	if Input.is_action_just_pressed("Space") and is_on_floor() and (!isSliding or slideDirCount == 0):
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
	if (Input.is_action_pressed("S") or slideHBcollide) and Input.is_action_just_pressed("Space") and is_on_floor() and slideDirCount == 0:
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
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("A", "D")
	$"Sprite2D".scale = Vector2(0.773, 1)
	$"Sprite2D".position = Vector2(7.5, 0)
	$CollisionShape2D.shape.size = Vector2(99, 129)
	$CollisionShape2D.position = Vector2(7.5, 0)
	$"walljump radius/walljump collision".shape.size.y = 127
	$"walljump radius/walljump collision".position.y = 0
	if Input.is_action_pressed("S") or slideHBcollide:
		if !isSliding:
			slideDirCount = 0
		isSliding = true
		$"Sprite2D".scale = Vector2(1, 0.5)
		$"Sprite2D".position = Vector2(7.5, 30)
		$"CollisionShape2D".shape.size = Vector2(129, 49.5)
		$"CollisionShape2D".position = Vector2(7.5, 39)
		$"walljump radius/walljump collision".shape.size.y = 49
		$"walljump radius/walljump collision".position.y = 39
		if is_moving and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 4.0)
			if velocity.x == 0.0 and (Input.is_action_pressed("S") or slideHBcollide):
				if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
					velocity.x = -150.0
				if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
					velocity.x = 150.0
	elif direction:
		isSliding = false
		is_moving = true
		velocity.x += direction * SPEED / 2
		if Input.is_action_pressed("A") and velocity.x <= -500.0 and !Input.is_action_pressed("D"):
			velocity.x = -500.0
		if Input.is_action_pressed("D") and velocity.x >= 500.0 and !Input.is_action_pressed("A"):
			velocity.x = 500.0
	elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 20.0)
	move_and_slide()
	#respawn
	match level.levelName:
		"tutorial":
			if position.y > 4000.0 or Input.is_action_just_pressed("R"):
				position = start_position
		"testingground":
			if position.y > 4000.0 or Input.is_action_just_pressed("R"):
				position = start_position

	#tricks
	if Input.is_action_just_pressed("M1") and (Input.is_action_pressed("A") or Input.is_action_pressed("D")) and !is_on_floor() and frontflipCount == 0:
		print("frontflipped")
		tricks.append(Trick.newFrontflipTrick())
		frontflipCount = 1
	if Input.is_action_just_pressed("M1") and (Input.is_action_pressed("A") or Input.is_action_pressed("D")) and is_on_floor() and frontspringCount == 0:
		print("frontspringed")
		$"front handspring duration".start()
		frontspringCount = 1
	if is_on_floor():
		frontflipCount = 0
		if velocity.x == 0:
			evaluateTricks()
func evaluateTricks():
	tricks = []

func _on_penciling_fall_cancel_timer_timeout():
	print("Fallstop")
	pencilFallStop = false
	pencilCount = 2

#force crouch under smth
func _on_slide_collision_detect_body_entered(body):
	if body == self: return
	slideHBcollide = true
	print("Scollided")


func _on_slide_collision_detect_body_exited(body):
	if body == self: return
	slideHBcollide = false
	print("Suncollided")

#walljump chcek
func _on_walljump_radius_body_entered(body):
	if body == self: return
	walljumpHBcollide = true
	print("WJcollided")


func _on_walljump_radius_body_exited(body):
	if body == self: return
	walljumpHBcollide = false
	print("WJuncollided")

#penciling point check BOTTOM
func _on_penciling_check_bottom_body_entered(body):
	if body == self: return
	pencilPointB = true
	print("P-pointB Y")


func _on_penciling_check_bottom_body_exited(body):
	if body == self: return
	pencilPointB = true
	print("P-pointB N")


func _on_penciling_check_top_body_entered(body):
	if body == self: return
	pencilPointT = true
	print("P-pointT Y")


func _on_penciling_check_top_body_exited(body):
	if body == self: return
	pencilPointT = false
	print("P-pointT N")


func _on_front_handspring_duration_timeout():
	tricks.append(Trick.newFrontspringTrick())
	frontspringCount = 0
