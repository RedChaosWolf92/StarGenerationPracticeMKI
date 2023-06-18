extends Node2D

var star_types = []
const MAX_ATTEMPTS = 10
const Spiral_Dis = 500
const Spiral_tight = 55

var numArms = 2
var blackHole = preload("res://Galaxy/Stars/BlackHole.tscn").instantiate() # gets the black hole node in Stars


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	centralBlackHole()
	#getting the child 'star' nodes
	for child in get_children():
		if child is StaticBody2D:
			star_types.append(child)
			
func centralBlackHole():
	blackHole.global_position = Vector2(get_viewport_rect().size/2) # center location of the screen
	blackHole.scale = Vector2(0.85,0.85)
	add_child(blackHole)
	print(blackHole.global_position, "this is where the blackhole is ")
	print(blackHole.scale, "this is how large the black hole is")
	print(" ")

func generate_spiral(starsNum: int, Arms: int, safeDis: float) -> Vector2:
	var angle = 0.34 * starsNum + Arms * (2 * PI / numArms) # adjust this value to change the distance between stars in the spiral
	var rad = Spiral_Dis + Spiral_tight * angle
	
	#adding the safe distance tp 'rad'
	rad += safeDis
	return Vector2(cos(angle), sin(angle)) * rad
	
func chooseStar():
	var ran = randf()
	var total_Prob = 0.0
	
	for ct in range(get_child_count()):
		total_Prob += get_child(ct).probability
		if ran <= total_Prob:
			return get_child(ct)
			
	return get_child(0)

#func is_position_valid(newStar,pos):
#	for star in get_children():
#		var starDis = star.global_position.distance_to(pos)
#		if starDis < newStar.star_radius + star.star_radius:
#			return false
#	return true
			
func add_star(starsNum: int):
	var newStar = chooseStar().duplicate()
	var Arms = starsNum % numArms
	#position of stars
	var pos
	var attempts = 0
	#finding the safe distance from blackhole
	var safeDis = blackHole.star_radius
	#if first star (starnums ==0), then generate it at least position equal to safe_distance
	print(safeDis)
	if starsNum == 0:
		pos = get_viewport_rect().size / 2 + Vector2(0, safeDis)
		print(pos, " safe distance from the blackhole")
	else:
		pos = get_viewport_rect().size / 2 + generate_spiral(starsNum, Arms, safeDis)
		print(pos, "after the first star")
		
	#checking if new star would overlap with black hole
	#if starsNum == 0 and pos.distance_to(blackHole.global_position) < newStar.star_radius + safeDis:
		#var direction = (pos - blackHole.global_position).normalized()
		#pos = blackHole.global_position + direction * (newStar.star_radius + safeDis)
		
	newStar.global_position = pos

	attempts += 1
	if attempts > MAX_ATTEMPTS:
		print("Failed to find a valid position for the star after", MAX_ATTEMPTS, "attempts.")
	
#	while not is_position_valid(newStar,pos):
#		newStar.global_position = pos
	
	add_child(newStar)
