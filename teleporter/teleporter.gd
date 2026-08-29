extends Area3D

@onready var marker_3d: Marker3D = $Marker3D
@onready var teleporter: Area3D = $"."

func _ready():
	teleporter.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") and marker_3d:
		body.global_position = marker_3d.global_position
