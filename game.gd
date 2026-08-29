extends Node3D

@onready var score_label = %ScoreLabel
@onready var player = %Player
@onready var power_pellet_timer = %PowerPelletTimer
@onready var power_label = %PowerLabel

var power_pellet_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	power_label.hide()
	
func _unhandled_input(_event):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	score_label.text = "Score: " + str(player.points)

func handle_power_pellet():
	power_pellet_active = true
	power_label.show()
	power_pellet_timer.start()

func _on_power_pellet_timer_timeout():
	power_pellet_active = false
	power_label.hide()
	pass # Replace with function body.
