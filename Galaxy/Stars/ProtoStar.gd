extends StaticBody2D

var star_size = randf_range(0.3,.6)
var star_radius = 0.0

@export var probability: float = 0.12

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_ProtoStar()
	
func generate_ProtoStar():
	
	var ProtoSize = $ProtoStar.scale
	var ProtoRad = $ProtoRadius.shape.radius
	var ProtoRadSize = $ProtoRadius.scale
	
	ProtoSize = Vector2(star_size,star_size)
	ProtoRadSize = ProtoSize * 2
	
	star_radius = ProtoRadSize.length() * ProtoRad
