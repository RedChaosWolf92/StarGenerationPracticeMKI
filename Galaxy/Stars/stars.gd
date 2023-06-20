extends Node2D

var star_types = []
const MAX_ATTEMPTS = 10
const Spiral_Dis = 500
const Spiral_tight = 30

var numArms = 5
var blackHole = preload("res://Galaxy/Stars/BlackHole.tscn").instantiate() # gets the black hole node in Stars

var angle_increment = PI / 90 #controls the tightness of the spiral, higher makes spiral looser and lower makes spiral tighter
var current_angle = 0 # starting angle
var cell_size = 100.0 # Size of grid cells
var grid = {} # Dictionary to store grid cells


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
	var cell_coords
	
	# Add a random offset to the radius and angle for some randomness
	var randomRadoffset = randf_range(-360.00,360.00)
	var randomAngleoffset = randf_range(-0.150,0.150)
	var originalRadoffset = randomRadoffset
	var originalAngleoffset = randomAngleoffset 
	
	while  attempts < MAX_ATTEMPTS:
		#adding limits to random offsets
		randomRadoffset = clamp(randomRadoffset, -300.0, 300)
		randomAngleoffset = clamp(randomAngleoffset, -.075, .075)
		
		# Use generate_spiral function to calculate position
		pos = get_viewport_rect().size / 2 + generate_spiral(starsNum, Arms, safeDis + randomRadoffset, current_angle + randomAngleoffset)

		cell_coords = Vector2(floor(pos.x / cell_size), floor(pos.y / cell_size))

		# Check if the new position is far enough from the black hole and other stars to prevent overlap
		var is_valid = true
		if pos.distance_to(blackHole.global_position) < newStar.star_radius + blackHole.star_radius:
			is_valid = false
		else:
			for neighbour_coords in get_neighboring_cells(cell_coords):
				var cell_key = str(neighbour_coords.x) + "," + str(neighbour_coords.y)
				if cell_key in grid:
					for star in grid[cell_key]:
						if pos.distance_to(star.global_position) < newStar.star_radius + star.star_radius:
							is_valid = false
							# Adjust position based on the overlapping star's position
							var overlap = pos.distance_to(star.global_position) - newStar.star_radius - star.star_radius
							var direction = (pos - star.global_position).normalized()
							
							# Update random offsets based on overlap and direction
							randomRadoffset += overlap * direction.length()
							randomAngleoffset += atan2(direction.y, direction.x)
							break
				if not is_valid:
					break

		if is_valid:
			break  # The position is valid, exit the loop

		# The position is not valid, increment attempts and try again
		attempts += 1

		if attempts % 10 == 0:
			# Reset random offsets to their original values
			randomRadoffset = originalRadoffset
			randomAngleoffset = originalAngleoffset

	if attempts == MAX_ATTEMPTS:
		print("Failed to find a valid position for the star after", MAX_ATTEMPTS, "attempts.")
		return  # Failed to find a valid position, don't add the star

	# Add the new star to the relevant grid cell
	var cell_key = str(cell_coords.x) + "," + str(cell_coords.y)
	if cell_key in grid:
		grid[cell_key].append(newStar)
	else:
		grid[cell_key] = [newStar]
		
	add_child(newStar)
	newStar.show()
	newStar.global_position = pos
	print(pos)
	current_angle += angle_increment
	
func polar_to_cartesian(r, theta):
	#converts poar coordinates to Cartesian
	return Vector2(r * cos(theta), r * sin(theta))
	
func get_neighboring_cells(cell_coords: Vector2) -> Array:
	var neighbours = []
	for x in range(-1,2):
		for y in range(-1,2):
			if x != 0 or y != 0:
				neighbours.append(cell_coords + Vector2(x,y))
	return neighbours
