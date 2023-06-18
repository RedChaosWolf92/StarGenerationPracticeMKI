extends StaticBody2D

var star_size = randf_range(0.3,.6)
var star_radius = 0.0
var blackhole = Color.BLACK.lightened(0.1)
var border = Color.WHITE

@export var probability: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_BlackHole()
	
func generate_BlackHole():
	self.modulate = blackhole
	var BlackHolesize = get_node("BlackHoleImage").scale
	var BlackHoleRad = $BlackHoleRadius.shape.radius
	var BlackHoleRadSize = $BlackHoleRadius.scale
	
	BlackHolesize = Vector2(star_size, star_size)
	
	BlackHoleRadSize = BlackHolesize * 4.0
	
	#ensuring the star_radius changes in relation to BlackHoleRad multi by BlackHoleRadSize(which is 4 times the scale of BlackholeSize)
	star_radius = BlackHoleRadSize.length() * BlackHoleRad

