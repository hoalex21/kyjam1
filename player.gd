extends CharacterBody2D


const SPEED = 47.0

var alive = true


func _ready():
	$Sprite2D.flip_h = false


func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if alive:
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
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			var groups = collider.get_groups()
			if "enemy" in groups:
				print(die)
				die()


func die():
	alive = false
	hide()
