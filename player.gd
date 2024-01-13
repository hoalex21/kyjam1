extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	$Sprite2D.flip_h = false


func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
	
	if Input.is_action_pressed("down"):
		velocity.y = SPEED
	
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite2D.flip_h = true
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite2D.flip_h = false
	

	move_and_slide()


