extends CharacterBody3D

@onready var camera_3d: Camera3D = %Camera3D

const SPEED = 5.5
const SPRINT_MULTI = 1.5
const MAX_STAMINA = 100.0
const STAMINA_DRAIN = 20.0
const STAMINA_RECHARGE = 25.0
const TIRED_RECOVERY = 50.0

var tired = false
var sprint_stamina = MAX_STAMINA

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.40
		camera_3d.rotation_degrees.x -= event.relative.y * 0.2
		camera_3d.rotation_degrees.x = clamp(
			camera_3d.rotation_degrees.x, -50.0, 50.0
		)

func _physics_process(delta):
	var direction : = Vector3.ZERO
	
	direction = get_player_direction()
	
	var can_sprint = not tired and direction != Vector3.ZERO
	
	handle_sprint(delta, can_sprint, direction)
	
	move_and_slide()
	
func get_player_direction():
	var input_direction_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	)
	return transform.basis * input_direction_3D

func handle_sprint(delta, can_sprint, direction):
	if sprint_stamina <= 0.0:
		tired = true

	if tired and sprint_stamina >= TIRED_RECOVERY:
		tired = false
	
	if Input.is_action_pressed("sprint") and can_sprint:
		velocity.x = direction.x * SPEED * SPRINT_MULTI
		velocity.z = direction.z * SPEED * SPRINT_MULTI
		
		sprint_stamina -=  STAMINA_DRAIN * delta
		sprint_stamina = max(sprint_stamina, 0.0)
	else:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		sprint_stamina += STAMINA_RECHARGE * delta
		sprint_stamina = min(sprint_stamina, MAX_STAMINA)
