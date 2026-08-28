extends Node3D
@onready var area_3d: Area3D = %Area3D

func _ready():
	area_3d.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect()

func collect():
	print("Pellet collected!")
	queue_free()
