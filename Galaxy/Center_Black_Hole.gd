extends StaticBody2D

var star_size: float = 1.0
var star_radius: float = 0.0
var blackhole = Color.BLACK.lightened(0.1)
var border = Color.WHITE

var safeDisfromOthers: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_BlackHole()
	
func generate_BlackHole():
	self.modulate = blackhole
	var BlackHolesize = get_node("Black_Hole").scale
	var BlackHoleRad = $BHRadius.shape.radius
	var BlackHoleRadSize = $BHRadius.scale
	
	BlackHolesize = Vector2(star_size, star_size)
	
	BlackHoleRadSize = BlackHolesize * 4.0
	
	star_radius = BlackHoleRadSize.length() * BlackHoleRad
	safeDisfromOthers = star_radius * 4.5

