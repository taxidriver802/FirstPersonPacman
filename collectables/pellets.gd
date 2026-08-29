extends Node3D
@onready var area_3d: Area3D = %Area3D
@onready var player = %Player

var start_y: float
var bob_speed = 1.5
var bob_amplitude = 0.05
var rotation_speed = 1.0
var total_time: float = 0.0

func _ready():
	area_3d.body_entered.connect(_on_body_entered)
	start_y = global_position.y

func _process(delta):
	total_time += delta
	global_position.y = start_y + sin(total_time * bob_speed) * bob_amplitude
	global_rotate(Vector3.UP, rotation_speed * delta)


func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()

func collect():
	player.points += 1
	queue_free()
