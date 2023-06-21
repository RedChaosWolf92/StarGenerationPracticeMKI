extends StaticBody2D

var star_size = randf_range(0.05,0.35)
var star_radius = 0.0
var safeDisfromOthers: float = 0.0

@export var probability: float = 0.13

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_WhiteDwarf()
	
func generate_WhiteDwarf():
	var WhitedwarfSize = $White_Dwarf.scale
	var WhitedwarfRad = $WhitedwarfRadius.shape.radius
	var WhitedwarfRadSize = $WhitedwarfRadius.scale
	
	WhitedwarfSize = Vector2(star_size,star_size)
	WhitedwarfRadSize = WhitedwarfSize * 2
	
	star_radius = WhitedwarfRadSize.length() * WhitedwarfRad
	safeDisfromOthers = star_radius * .1
