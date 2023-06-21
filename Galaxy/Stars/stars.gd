extends Node2D

var star_types = []
const MAX_ATTEMPTS = 10
const Spiral_Dis = 750
const Spiral_tight = 15

var numArms = 2
var blackHole = preload("res://Galaxy/Stars/BlackHole.tscn").instantiate() # gets the black hole node in Stars

var angle_increment = PI / 90 #controls the tightness of the spiral, higher makes spiral looser and lower makes spiral tighter
var current_angle = 0 # starting angle
var cell_size = 90 # Size of grid cells
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
	var angle = current_angle + Arms * ((2 * PI) / numArms) # adjust this value to change the distance between stars in the spiral
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
	
	#original value of radius before adding the safeDisfromOthers value
	var originalRadius = newStar.star_radius
	
	#finding the safe distance from blackhole
	var safeDis = blackHole.star_radius + (starsNum * 15) + newStar.star_radius
	print(safeDis)
	
	# include the safety distance from other stars in the star's radius
	newStar.star_radius += newStar.safeDisfromOthers
	
	#position of stars
	var pos
	var attempts = 0
	var cell_coords
	
	
	while attempts < MAX_ATTEMPTS:
		# Add a random offset to the radius and angle for some randomness
		var randomRadoffset = randf_range(-360.0,360.0)
		var randomAngleoffset = randf_range(-0.15,0.15) 

		# Use generate_spiral function to calculate position
		pos = get_viewport_rect().size / 2 + generate_spiral(starsNum, Arms, safeDis + randomRadoffset, current_angle + randomAngleoffset)
		
		var is_valid = true
		for star in get_node("StarTemplates").get_children():
			if star != blackHole and star.global_position.distance_to(pos) < newStar.star_radius + star.star_radius:
				is_valid = false
				#adjusts the position of the new star to prevent overlap
				var overlap = pos.distance_to(star.global_position) - newStar.star_radius - star.star_radius
				var direction = (pos - star.global_position).normalized()
				pos += direction * (overlap + 1.0)
				break

		# Check if the new position is far enough from the black hole to prevent overlap
		if pos.distance_to(blackHole.global_position) < newStar.star_radius + blackHole.star_radius:
			is_valid = false
			var overlap = pos.distance_to(blackHole.global_position) - newStar.star_radius - blackHole.star_radius
			var direction = (pos - blackHole.global_position).normalized()
			pos += direction * (overlap + 1.0)
			
		if is_valid:
			break
		
		attempts += 1

	if attempts == MAX_ATTEMPTS:
		print("Failed to find a valid position for the star after", MAX_ATTEMPTS, "attempts.")
		return  # Failed to find a valid position, don't add the star
		
	add_child(newStar)
	newStar.show()
	newStar.global_position = pos
	print(pos)
	current_angle += angle_increment
	
	#apply replusion
	apply_repulsion(newStar)
	newStar.star_radius = originalRadius
	
func polar_to_cartesian(r, theta):
	#converts poar coordinates to Cartesian
	return Vector2(r * cos(theta), r * sin(theta))
	
func apply_repulsion(newStar):
	var repulsion_strength = 2.0
	var repulsion_distance = 50.0
	var safe_distance_to_blackhole = blackHole.star_radius * 5
	var safe_distance_to_screen = 50.0  # Minimum distance to the screen edge

	# Get the cell coordinates of the new star
	var cell_coords = newStar.global_position / cell_size

	# Iterate over the stars in the same and neighboring cells
	for delta_x in range(-1, 2):
		for delta_y in range(-1, 2):
			var neighbour_coords = cell_coords + Vector2(delta_x, delta_y)
			var neighbour_cell = grid.get(str(neighbour_coords))
			if neighbour_cell != null:
				for star in neighbour_cell:
					# Skip the new star itself
					if star == newStar:
						continue

					var distance = star.global_position.distance_to(newStar.global_position)
					if distance < repulsion_distance:
						# Calculate and apply repulsion vector
						var repulsion_vector = newStar.global_position - star.global_position
						repulsion_vector = repulsion_vector.normalized() * repulsion_strength
						star.global_position += repulsion_vector

						# Pull the star back if it's too close to the central black hole
						var distance_to_blackhole = star.global_position.distance_to(blackHole.global_position)
						if distance_to_blackhole < safe_distance_to_blackhole:
							var direction = (star.global_position - blackHole.global_position).normalized()
							star.global_position = blackHole.global_position + direction * safe_distance_to_blackhole

