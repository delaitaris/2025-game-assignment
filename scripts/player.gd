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
var walljumpHBcollideL = false
var walljumpHBcollideR = false
var gravityMultiplier = 1
var tricks = []
var score = 0
var pencilPointB = false
var pencilPointT = false
var Ptrickcount = 0
var frontflipCount = 0
var frontspringCount = 0
var wallgrip = false


@onready var animated_sprite = $AnimatedSprite2D

#point system
func _process(_delta):
	game.score.text = str(score) + "\n"
	for trick in tricks:
		game.score.text += trick.text + "\n"

func _physics_process(delta):
	# Add the gravity & pencilling
	gravityMultiplier = 1
	if !is_on_floor() and Input.is_action_just_pressed("S") and pencilCount == 1:
		if velocity.y < 75.0:
			if !pencilFallStop:
				pencilFallStop = true
				$"penciling fall cancel timer".start()
	if pencilFallStop:
		gravityMultiplier = 0
		velocity.y = 0.0
		if pencilPointB and pencilPointT and !is_on_floor() and Ptrickcount == 0: #penciling TRICK and slide TRICK
			tricks.append(Trick.newPencilTrick())
			Ptrickcount = 1
		if pencilPointB and pencilPointT and is_on_floor() and Ptrickcount == 0:
			tricks.append(Trick.newSlideTrick())
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
		isSliding = true
		if velocity.x < 0 or velocity.x > 0:
			animated_sprite.play("slide move")
		else:
			animated_sprite.play("slide stop")
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
	$"AnimatedSprite2D".scale = Vector2(12, 16)
	$"AnimatedSprite2D".position = Vector2(7.5, 0)
	$CollisionShape2D.shape.size = Vector2(99, 129)
	$CollisionShape2D.position = Vector2(7.5, 0)
	$"right walljump radius/walljump collision right".shape.size.y = 127
	$"right walljump radius/walljump collision right".position.y = 0
	$"left walljump radius/walljump collision left".shape.size.y = 127
	$"left walljump radius/walljump collision left".position.y = 0
	if Input.is_action_pressed("S") or slideHBcollide:
		if !isSliding:
			slideDirCount = 0
		isSliding = true
		$"AnimatedSprite2D".scale = Vector2(12.222, 7.9445)
		$"AnimatedSprite2D".position = Vector2(7.5, 30)
		$"CollisionShape2D".shape.size = Vector2(129, 49.5)
		$"CollisionShape2D".position = Vector2(7.5, 39)
		if is_moving and is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 4.0)
			if velocity.x == 0.0 and (Input.is_action_pressed("S") or slideHBcollide):
				if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
					velocity.x = -150.0
				if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
					velocity.x = 150.0
	elif direction: #MOVEMENT
		isSliding = false
		is_moving = true
		velocity.x += direction * SPEED / 2
		if !isSliding:
			animated_sprite.play("walk")
		if Input.is_action_pressed("A") and velocity.x <= -500.0 and !Input.is_action_pressed("D"):
			velocity.x = -500.0
		if Input.is_action_pressed("D") and velocity.x >= 500.0 and !Input.is_action_pressed("A"):
			velocity.x = 500.0
		animated_sprite.flip_h = direction == -1
	elif is_on_floor():
		animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, 20.0)
	# jump whatever
	if not is_on_floor() and (walljumpHBcollideR or walljumpHBcollideL): 
		if is_on_wall() and (Input.is_action_pressed("A") or Input.is_action_pressed("D")):
			gravityMultiplier = 0.5
			if velocity.y > 700.0:
				velocity.y = 700.0
			if velocity.y < 0 and wallgrip:
				animated_sprite.play("wall climb")
			else:
				animated_sprite.play("wall slide")
		if Input.is_action_just_pressed("Space"):
			if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
				velocity.x += 400.0
				velocity.y = -400.0
				wallgrip = true
			if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
				velocity.x -= 400.0
				velocity.y = -400.0
				wallgrip = true
			if pencilCount == 2:
				pencilCount = 1
				Ptrickcount = 0
			if frontflipCount == 1:
				frontflipCount = 0
		if Input.is_action_just_pressed("Shift"):
			if Input.is_action_pressed("A") and !Input.is_action_pressed("D"):
				velocity.x += 600.0
			if Input.is_action_pressed("D") and !Input.is_action_pressed("A"):
				velocity.x -= 60.0
			if pencilCount == 2:
				pencilCount = 1
				Ptrickcount = 0
			if frontflipCount == 1:
				frontflipCount = 0
	elif !is_on_floor() and velocity.y < 0:
		animated_sprite.play("jump")
	elif !is_on_floor() and velocity.y > 0:
		animated_sprite.play("fall")
	velocity += get_gravity() * delta * gravityMultiplier
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
		$"frontflip duration".start()
		if !$"frontflip duration".is_stopped():
			if (is_on_ceiling() or is_on_floor() or is_on_wall()):
				$"frontflip duration".stop()
				$"stun timer".start()
				if !$"stun timer".is_stopped():
					if Input.is_action_pressed("A") or Input.is_action_pressed("D"):
						velocity.x == 0
	if Input.is_action_just_pressed("M1") and (Input.is_action_pressed("A") or Input.is_action_pressed("D")) and is_on_floor() and frontspringCount == 0:
		print("frontspringed")
		$"front handspring duration".start()
		frontspringCount = 1
	if is_on_floor():
		frontflipCount = 0
		if velocity.x == 0:
			if len(tricks) > 0: evaluateTricks()



func evaluateTricks():
	var multipliers = 1
	var additives = 0
	for trick in tricks:
		print(trick.text)
		if trick.type == Trick.TYPES.MULTIPLICATIVE:
			multipliers *= trick.value
		else:
			additives += trick.value
	print(multipliers)
	print(additives)
	score += multipliers * additives
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
func _on_right_walljump_radius_body_entered(body):
	if body == self or body.get_parent() == self: return
	walljumpHBcollideR = true
	print("WJcollidedR")


func _on_right_walljump_radius_body_exited(body):
	if body == self or body.get_parent() == self: return
	walljumpHBcollideR = false
	print("WJuncollidedR")

func _on_right_walljump_radius_2_body_entered(body):
	if body == self or body.get_parent() == self: return
	walljumpHBcollideL = true
	print("WJcollidedL")
	
func _on_walljump_radius_body_exited(body):
	if body == self or body.get_parent() == self: return
	walljumpHBcollideL = false
	print("WJuncollidedL")

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


func _on_frontflip_duration_timeout():
	tricks.append(Trick.newFrontflipTrick())
	print("success FF")
	frontflipCount = 1


func _on_killbox_body_entered(body):
	if body is Danger: position = start_position
