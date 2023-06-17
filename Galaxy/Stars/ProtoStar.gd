extends StaticBody2D

var star_size = randf_range(0.3,.6)
var star_radius = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_ProtoStar()
	
func generate_ProtoStar():
	$ProtoStar.scale = Vector2(star_size,star_size)
	star_radius = star_size / 2
	
	self.position = Vector2(250,250)
