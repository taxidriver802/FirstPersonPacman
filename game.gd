extends Node3D

@onready var player = %Player
@onready var power_pellet_timer = %PowerPelletTimer
@onready var health_label = %HealthLabel
@onready var power_label = %PowerLabel
@onready var pellet_counter_label = %PelletCounterLabel
@onready var score_label = %ScoreLabel
@onready var directional_light_3d = $DirectionalLight3D

var total_pellets := 0
var pellets_remaining := 0
var power_pellet_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	power_label.hide()
	
	total_pellets = get_tree().get_nodes_in_group("pellets").size()
	pellets_remaining = total_pellets
	
func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	score_label.text = "Score: " + str(player.points)
	health_label.text = "Lives: " + str(player.health)
	pellet_counter_label.text = "Pelletes remaining: " + str(pellets_remaining) + " / " + str(total_pellets)

func handle_power_pellet():
	power_pellet_active = true
	directional_light_3d.light_energy = 1.0
	power_label.show()
	power_pellet_timer.start()

func pellet_collected():
	pellets_remaining -= 1
	
	if pellets_remaining <= 0:
		win_game()

func win_game():
	print("You win!")
	get_tree().paused = true

func _on_power_pellet_timer_timeout():
	power_pellet_active = false
	directional_light_3d.light_energy = 0.0
	power_label.hide()
