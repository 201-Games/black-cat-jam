extends CharacterBody2D


@onready var animation = $AnimatedSprite2D

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
#region Movement
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if velocity.y > 0:
		animation.play('fall')
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play('jump')
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
		
	if(direction < 0):
		animation.flip_h = true
	elif (direction > 0):
		animation.flip_h = false
		
	if direction:
		if Input.is_action_pressed("crouch") and is_on_floor():
			velocity.x = direction * 50
			animation.play("sneak")
		elif is_on_floor():
			velocity.x = direction * SPEED
			animation.play("run")
			
		if(velocity.y < 0):
			animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity == Vector2.ZERO and is_on_floor():
		if Input.is_action_pressed("crouch") and not direction:
			animation.play("crouch")
		else:
			animation.play("idle")
		
	
	move_and_slide()
#endregion
