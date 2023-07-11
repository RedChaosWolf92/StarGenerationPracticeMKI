extends Path2D

@export var spirals: float = 2
@export var points_per_spiral: float = 125


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_spiral_path()
	
func generate_spiral_path():
	var curve = Curve2D.new()
	
	#a determines the scale of the spiral. This represents the spiral's size at its origin.
	var a: float = 624 * .95
	#b determines the spiral's growth rate. As theta increases, the spiral's radius r grows exponentially at the rate b.
	var b: float = .512
	var theta: float = 0.0
	
	for spiral in range(spirals):
		for i in range(points_per_spiral):
			var t = i / points_per_spiral
			theta += 2.0 * PI / points_per_spiral
			
			var radius = a * exp(b * theta)
			var point = Vector2(cos(theta), sin(theta)) * radius
			curve.add_point(point)
			point += Vector2(0,0)
			
	self.curve = curve
