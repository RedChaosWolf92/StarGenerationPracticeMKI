extends Node2D

var stars = preload("res://Galaxy/Stars/stars.tscn").instantiate()
@onready var camera = $Practice

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_child(stars)
	
	for ns in range(100):
		stars.add_star()
		
	# center the camera
	camera.global_position = get_viewport_rect().size / 2
	camera.scale = Vector2(.5,.5)
