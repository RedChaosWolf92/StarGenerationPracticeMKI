extends StaticBody2D

var star_size = randf_range(0.35,.075)
var star_radius = 0.0

@export var probability: float = 0.17

func _ready():
	randomize()
	generate_YellowStar()
	
func generate_YellowStar():
	var YellowstarSize = $Yellow_Star.scale
	var YellowstarRad = $YellowstarRadius.shape.radius
	var YellowstarRadSize = $YellowstarRadius.scale
	
	YellowstarSize = Vector2(star_size,star_size)
	YellowstarRadSize = YellowstarSize * 2
	
	star_radius = YellowstarRadSize.length() * YellowstarRad
