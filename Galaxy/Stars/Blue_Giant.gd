extends StaticBody2D

var star_color = Color.DEEP_SKY_BLUE
var star_size = randf_range(0.75,1.50)
var star_radius = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_BlueGiant()
	
func generate_BlueGiant():
	self.modulate = star_color
	$Blue_Giant.scale = Vector2(star_size,star_size)
	
	star_radius = star_size / 2
