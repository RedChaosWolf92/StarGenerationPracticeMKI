extends Node2D

var star_types = []

@export var NUM_STARS: int = 500

var OFFSET_RANGE = 2400
var LOG_BASE = 2
var SCALE_FACTOR = .63

const MAX_ATTEMPTS = 15
const DISPLACEMENT_STDEV = 18.1
const REPEL_FORCE = 22.7
const MAX_REPEL_ITERATIONS = 25
const MAX_DISTANCE = 70000
const MIN_DISTANCE = 40000

var center = Vector2(0,0)

var rng = RandomNumberGenerator.new()

var visible_stars = [] #list for tracking all visible stars
var removedStars: int = 0

@onready var camera = $Practice

func _ready():
	randomize()
	initialize_star_types()
	# start star generation
	generate_stars()
	
func initialize_star_types():
	# get all star types and hide them
	for child in get_node("StarTemplates").get_children():
		if child is StaticBody2D:
			star_types.append(child)
			child.hide()
			
	#sort star_types in descending order by their sizes
	star_types.sort_custom(Callable(self, "compare_star_sizes"))


func compare_star_sizes(star1, star2):
	if star1.star_size > star2.star_size:
		return -1
	elif star1.star_size < star2.star_size:
		return 1
	else:
		return 0
		
func generate_stars():
	rng.randomize()
	var path = $StarPath.curve.get_baked_points()
	var scaled_path = []
	for point in path:
		scaled_path.append(point * SCALE_FACTOR)
	var step = scaled_path.size() / NUM_STARS
	
	generate_star_placement(scaled_path, step)
	apply_collision_avoidance()
	
func generate_star_placement(scaled_path, step):
	for i in range(NUM_STARS):
		var new_star = chooseStar().duplicate()
		var pos = calculate_star_position(i, new_star, scaled_path, step)
		place_star(pos,new_star)
	
func calculate_star_position(i, new_star, scaled_path, step):
	var t = pow((float(i) / NUM_STARS) + rng.randf_range(-2.5,9.5), 3.2)	
	var pos = scaled_path[int(i * step) % scaled_path.size()]
	var dis_from_Center = pos.distance_to(center)
	var direction = calculate_direction(i, scaled_path)
	var perp_direction = direction.normalized()
	#add random displacement
	var displacement = perp_direction * dis_from_Center * rng.randfn() * DISPLACEMENT_STDEV * .03
	#adding random angle to each star's position
	var angle = rng.randf_range(0,7.5) * 2 * PI
	#how far the displacement
	var distance = rng.randf() * t * DISPLACEMENT_STDEV
	displacement += Vector2(cos(angle), sin(angle)) * distance
	pos += displacement
	
	if pos.length() > MAX_DISTANCE:
		pos = pos.normalized() * rng.randf_range(MIN_DISTANCE, MAX_DISTANCE)
	return pos
	
func calculate_direction(i, scaled_path):
	if i < NUM_STARS - 1:
		return scaled_path[i + 1] + scaled_path[i]
	else:
		return scaled_path[i] + scaled_path[i - 1]

func place_star(pos: Vector2, newstar):
	newstar.global_position = pos
	newstar.show()
	add_child(newstar)
	visible_stars.append(newstar)

func apply_collision_avoidance():
	#Collision avoidance
	for c in range(MAX_REPEL_ITERATIONS):
		var has_moved = false
		for star in visible_stars:
			var repel_force = Vector2()
			for other_stars in visible_stars:
				if star == other_stars:
					continue
					
				var diff = star.global_position - other_stars.global_position
				var dist = diff.length() * 1.02
				
				if dist < star.safeDisfromOthers + other_stars.safeDisfromOthers:
					repel_force += (diff.normalized() / (dist * dist + .0001)) * REPEL_FORCE
			
			if repel_force.length() > 0:
				has_moved = true
				star.global_position += repel_force.normalized() * (REPEL_FORCE)
				
		if !has_moved:
			break

func chooseStar():
	var ran = randf()
	var total_Prob = 0.0
	for star in star_types:
		total_Prob += star.probability
		if ran <= total_Prob:
			return star
	return star_types[0]
