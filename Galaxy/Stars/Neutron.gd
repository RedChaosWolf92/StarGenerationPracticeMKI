extends StaticBody2D

var star_size = randf_range(0.20,0.35)
var star_radius = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_Neutron()
	
func generate_Neutron():
	$Neutron.scale = Vector2(star_size,star_size)
	star_radius = star_size / 2
	
	self.position = Vector2(250,250)
