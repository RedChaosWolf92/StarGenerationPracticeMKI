extends Node2D

var star_types = []
const MAX_ATTEMPTS = 10
const Spiral_Dis = 500
const Spiral_tight = 30

var numArms = 2
var blackHole = preload("res://Galaxy/Stars/BlackHole.tscn").instantiate() # gets the black hole node in Stars

var angle_increment = PI / 90 #controlls the tightness of the spiral, higher makes spiral looser and lower makes spiral tighter
var current_angle = 0 # starting angle


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	centralBlackHole()
	#getting the child 'star' nodes
	for child in get_node("StarTemplates").get_children():
		if child is StaticBody2D:
			star_types.append(child)
			child.hide()
			
func centralBlackHole():
	var BlackHole = blackHole.duplicate()
	BlackHole.global_position = Vector2(get_viewport_rect().size/2) # center location of the screen
	BlackHole.scale = Vector2(5.0,5.0)
	BlackHole.z_index = 1
	add_child(BlackHole)
	BlackHole.show()
	print(BlackHole.global_position, "this is where the blackhole is ")
	print(BlackHole.scale, "this is how large the black hole is")
	print(" ")

func generate_spiral(starsNum: int, Arms: int, safeDis: float, current_angle: float) -> Vector2:
	var angle = current_angle + (Arms * ((2 * PI) / numArms)) # adjust this value to change the distance between stars in the spiral
	var rad = Spiral_Dis + Spiral_tight * angle
	
	#adding the safe distance tp 'rad'
	rad += safeDis
	return Vector2(cos(angle), sin(angle)) * rad
	
func chooseStar():
	var ran = randf()
	var total_Prob = 0.0
	
	for star in star_types:
		total_Prob += star.probability
		if ran <= total_Prob:
			return star
			
	return star_types[0]
			
func add_star(starsNum: int):
	var newStar = chooseStar().duplicate()
	var Arms = starsNum % numArms
	#finding the safe distance from blackhole
	var safeDis = blackHole.star_radius + (starsNum * 15)
	print(safeDis)
	#position of stars
	var pos
	var attempts = 0	
	#if starsNum == 0:
	while  attempts < MAX_ATTEMPTS:
		# Add a random offset to the radius and angle for some randomness
		var randomRadoffset = randf_range(-360.00,360.00)
		var randomAngleoffset = randf_range(-0.450,0.450) 

		# Use generate_spiral function to calculate position
		pos = get_viewport_rect().size / 2 + generate_spiral(starsNum, Arms, safeDis + randomRadoffset, current_angle + randomAngleoffset)

		# Check if the new position is far enough from the black hole to prevent overlap
		if pos.distance_to(blackHole.global_position) < newStar.star_radius + blackHole.star_radius:
			attempts += 1
			safeDis += blackHole.star_radius
			continue  # The position is not valid, try again

		# Check if the new position is far enough from all other stars to prevent overlap
		var overlaps = false
		for star in get_node("StarTemplates").get_children():
			if star != newStar and star.has_method("get_global_position") and pos.distance_to(star.get_global_position()) < newStar.star_radius + star.star_radius:
				overlaps = true
				safeDis = (blackHole.star_radius + (newStar.star_radius + star.star_radius)) / 2
				break
		if overlaps:
			attempts += 1
			safeDis += blackHole.star_radius
			continue  # The position is not valid, try again

		# The position is valid, exit the loop
		break

	if attempts == MAX_ATTEMPTS:
		print("Failed to find a valid position for the star after", MAX_ATTEMPTS, "attempts.")
		return  # Failed to find a valid position, don't add the star
		
	add_child(newStar)
	newStar.show()
	newStar.global_position = pos
	print(pos)
	current_angle += angle_increment
	
func polar_to_cartesian(r, theta):
	#converts poar coordinates to Cartesian
	return Vector2(r * cos(theta), r * sin(theta))
