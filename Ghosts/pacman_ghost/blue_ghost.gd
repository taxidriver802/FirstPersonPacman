extends CharacterBody3D

@onready var navigation_agent = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")

@export var speed := 3.0
var target_update_timer := 0.0

func _physics_process(delta):
	if player == null:
		return
	
	target_update_timer -= delta
	
	if target_update_timer <= 0.0:
		navigation_agent.target_position = player.global_position
		target_update_timer = 0.2
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return
	
	var next_position = navigation_agent.get_next_path_position()

	var direction = global_position.direction_to(next_position)
	direction.y = 0.0
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if direction.length() > 0.01:
		var target_angle = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 8.0 * delta)
	
	move_and_slide()
