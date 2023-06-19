extends StaticBody2D

var star_color = Color.DEEP_SKY_BLUE
var star_size = randf_range(0.75,1.50)
var star_radius = 0.0

@export var probability: float = 0.13

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_BlueGiant()
	
func generate_BlueGiant():
	self.modulate = star_color
	var BluegiantSize = $Blue_Giant.scale
	var BluegiantRad = $BlueRadius.shape.radius
	var BluegiantRadSize = $BlueRadius.scale
	
	BluegiantSize = Vector2(star_size,star_size)
	BluegiantRadSize = BluegiantSize * 2
	
	star_radius = BluegiantRadSize.length() * BluegiantRad
