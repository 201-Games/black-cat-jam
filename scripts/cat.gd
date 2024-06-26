extends CharacterBody2D


@onready var animation = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if velocity.y > 0:
		animation.play('fall')

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play('jump')
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
		
	if velocity.x == 0 and velocity.y == 0 and is_on_floor():
		animation.play("idle")
	
	if(direction < 0):
		animation.flip_h = true
	elif (direction > 0):
		animation.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animation.play("run")
			
		if(velocity.y < 0):
			animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
