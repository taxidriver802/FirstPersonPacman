extends CharacterBody3D

@onready var game = get_node("/root/Game")
@onready var camera_3d: Camera3D = %Camera3D
@onready var flashlight_beam = %FlashlightBeam
@onready var damage_timer = %DamageTimer

#region Constants
const SPEED = 5.5
const SPRINT_MULTI = 1.5
const MAX_STAMINA = 100.0
const STAMINA_DRAIN = 20.0
const STAMINA_RECHARGE = 25.0
const TIRED_RECOVERY = 50.0

const MIN_FLASHLIGHT_ANGLE = 10.0
const MAX_FLASHLIGHT_ANGLE = 50.0
const MIN_FLASHLIGHT_RANGE = 10.0
const MAX_FLASHLIGHT_RANGE = 25.0

const MIN_ATTENUATION = 0.5
const MAX_ATTENUATION = 5.0

const ZOOM_SPEED = 30.0

const MAX_HEALTH = 3
#endregion

#region Variablbles
var points = 0
var tired = false
var sprint_stamina = MAX_STAMINA
var health = MAX_HEALTH
#endregion

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
	
	handle_flashlight_zoom(delta)
	
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

func handle_flashlight_zoom(delta):
	if Input.is_action_pressed("zoom_in"):
		flashlight_beam.spot_angle -= ZOOM_SPEED * delta

	elif Input.is_action_pressed("zoom_out"):
		flashlight_beam.spot_angle += ZOOM_SPEED * delta

	flashlight_beam.spot_angle = clamp(
		flashlight_beam.spot_angle,
		MIN_FLASHLIGHT_ANGLE,
		MAX_FLASHLIGHT_ANGLE
	)

	var zoom_amount = inverse_lerp(
		MIN_FLASHLIGHT_ANGLE,
		MAX_FLASHLIGHT_ANGLE,
		flashlight_beam.spot_angle
	)

	flashlight_beam.spot_attenuation = lerp(
		MIN_ATTENUATION,
		MAX_ATTENUATION,
		zoom_amount
	)

	flashlight_beam.spot_range = lerp(
		MAX_FLASHLIGHT_RANGE,
		MIN_FLASHLIGHT_RANGE,
		zoom_amount
	)

func handle_ghost_contact():
	if damage_timer.is_stopped():
		damage_timer.start()
		health = max(health - 1, 0)
		print(health)
	if health <= 0:
		game.health_label.text = "Lives: 0"
		get_tree().paused = true
