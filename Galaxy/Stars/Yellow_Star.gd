extends StaticBody2D

var star_size = randf_range(0.35,.075)
var star_radius = 0.0

func _ready():
	randomize()
	generate_YellowStar()
	
func generate_YellowStar():
	$Yellow_Star.scale = Vector2(star_size,star_size)
	star_radius = star_size / 2
	
