extends StaticBody2D

var star_size = randf_range(0.05,0.45)
var star_radius = 0.0
var safeDisfromOthers: float = 0.0

@export var probability: float = 0.17

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_RedDwarf()
	
func generate_RedDwarf():
	var ReddwarfSize = $Red_Dwarf.scale
	var ReddwarfRad = $ReddwarfRadius.shape.radius
	var ReddwarfRadSize = $ReddwarfRadius.scale
	
	ReddwarfSize = Vector2(star_size,star_size)
	ReddwarfRadSize = ReddwarfSize * 2
	
	star_radius = ReddwarfRadSize.length() * ReddwarfRad
	safeDisfromOthers = star_radius * .25
