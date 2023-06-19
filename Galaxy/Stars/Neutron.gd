extends StaticBody2D

var star_size = randf_range(0.20,0.35)
var star_radius = 0.0

@export var probability: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_Neutron()
	
func generate_Neutron():
	
	var NeutronSize = $Neutron.scale
	var NeutronRad = $NeutronRadius.shape.radius
	var NeutronRadSize = $NeutronRadius.scale
	
	NeutronRad = Vector2(star_size,star_size)
	NeutronRadSize = NeutronRad * 4
	
	star_radius = NeutronRadSize.length() * NeutronRad
