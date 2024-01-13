extends CharacterBody2D


const SPEED = 45.0


var navigation_agent: NavigationAgent2D
var player


func _ready():
	navigation_agent = $NavigationAgent2D
	player = get_parent().get_node("Player")
	$AnimatedSprite2D.play("walk")


func _process(delta):
	var direction = Vector2.ZERO
	
	if player:
		navigation_agent.target_position = player.position
		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
	
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	velocity = direction * SPEED
	move_and_slide()
