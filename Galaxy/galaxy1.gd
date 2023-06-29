extends Node2D

var Stars = preload("res://Galaxy/Stars/stars.tscn")
var Blackhole = preload("res://Galaxy/Stars/BlackHole.tscn")

@onready var camera = $Practice

var arms = []
var blackhole

var displacement_factor = 0.45
var num_arms = 2 #default number of arms

# Called when the node enters the scene tree for the first time.
func _ready():
	# center the camera
	camera.global_position = Vector2(0,0)
	camera.scale = Vector2(.5,.5)

	blackhole = Blackhole.instantiate()
	blackhole.scale = Vector2(15 + 5 * num_arms, 15 + 5 * num_arms)

	add_child(blackhole)
	blackhole.safeDisfromOthers *= blackhole.scale.x
	print("Safe Distance from Center: ",blackhole.safeDisfromOthers)
	
	generate_arms()
	
	
func generate_arms():
	for i in range(num_arms):
		var arm = Stars.instantiate()
		arms.append(arm)
		add_child(arm)
		place_arm(arm, i)
		
func place_arm(arm, index):
	arm.rotation = (2 * PI * index) / num_arms
	
	var direction = Vector2(-sin(arm.rotation), cos(arm.rotation))
	var offset = direction * blackhole.safeDisfromOthers * displacement_factor
	arm.global_position = blackhole.global_position + offset
	
	print("Arm ", index, " : ", arm.global_position)
	
"func set_number_of_arms(value):
	#limit the value to avoid performance issues
	
	value = clamp(value, 2, 10)
	
	num_arms = value
	
	#delete old arms
	for arm in arms:
		arm.queue_free()
	arms.clear()
	
	#generate new arms
	generate_arms()
"
