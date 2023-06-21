extends StaticBody2D

var star_color = Color.RED.lightened(0.35)
var star_size = randf_range(0.5,1.15)
var star_radius = 0.0
var safeDisfromOthers: float = 0.0

@export var probability: float = 0.13

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_RedGiant()
	
func generate_RedGiant():
	self.modulate = star_color

	var RedgiantSize = $Red_Giant.scale
	var RedgiantRad = $RedgiantRadius.shape.radius
	var RedgiantRadSize = $RedgiantRadius.scale
	
	RedgiantSize = Vector2(star_size,star_size)
	RedgiantRadSize = RedgiantSize * 2
	
	star_radius = RedgiantRadSize.length() * RedgiantRad
	safeDisfromOthers = star_radius
