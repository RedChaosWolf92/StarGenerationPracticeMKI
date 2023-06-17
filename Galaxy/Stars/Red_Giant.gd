extends StaticBody2D

var star_color = Color.RED.lightened(0.35)
var star_size = randf_range(0.5,1.15)
var star_radius = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_RedGiant()
	
func generate_RedGiant():
	self.modulate = star_color
	$Red_Giant.scale = Vector2(star_size,star_size)
	
	star_radius = star_size / 2
