extends Node2D

var starPaths = {} # to store references to stars and their paths
const MAX_DISTANCE = 10000
const MAX_ATTEMPT = 15
const scale_factor = .79

class StarComparator:
	var ref_star
	var refposition
	
	func _init(_ref_star):
		ref_star = _ref_star
		refposition = ref_star.global_position
		
	func compare(star1, star2):
		var dist1 = star1.global_position.distance_to(refposition)
		var dist2 = star2.global_position.distance_to(refposition)
		
		if dist1 < dist2:
			return -1
		elif dist1 > dist2:
			return 1
		else:
			return 0

func generate_paths():
	var path = get_parent().get_node("StarPath_Arm").curve.get_baked_points()
	for i in range(path.size()):
		var stars_in_range = get_stars_in_range(path[i])
		for star in stars_in_range:
			var max_paths = get_max_paths(star.star_type)
			var nearby_stars = get_nearby_stars(star,stars_in_range)
			for j in range(min(max_paths, nearby_stars.size())):
				var other_star = nearby_stars[j]
				if not path_exists_between(star, other_star):
					add_path_between(star, other_star, scale_factor)
					
func get_stars_in_range(position):
	var stars_in_range = []
	for star in get_tree().get_nodes_in_group("stars"):
		if star.global_position.distance_to(position) <= MAX_DISTANCE:
			stars_in_range.append(star)
	return stars_in_range
	
func get_nearby_stars(star, stars_in_range):
	var nearby_stars = stars_in_range.duplicate(true)
	nearby_stars.erase(star)
	
	var comparator = StarComparator.new(star)
	nearby_stars.sort_custom(Callable(comparator, "compare"))
	
	return nearby_stars
	
func path_exists_between(star1, star2):
	for path in star1.get_node("StarPaths").get_children():
		if path.points[1] == star2.global_position:
			return true
	return false


func get_max_paths(star_type):
	match star_type:
		"BlackHole":
			return 1
		"Neutron":
			return 2
		"White_Dwarf":
			return 4
		"ProtoStar": 
			return 2
		"Red_Giant":
			return 4
		"Red_Dwarf":
			return 5
		"Blue_Giant":
			return 3
		"Yellow_Star":
			return 5
	
	return 0
	
func add_path_between(star1, star2,scale_factor):
	#add a check for existing paths
	print("attempting to add a path between ", star1.name, " + ", star2.name)
	for path in star1.get_node("StarPaths").get_children():
		if path.points[1] == star2.global_position * scale_factor:
			print("Path already exists, returning...")
			return 
	
	print("Star1 Position: ", star1.global_position * scale_factor)
	print("Star2 Position: ", star2.global_position * scale_factor)
	
	var line = Line2D.new()
	line.default_color = Color(randf_range(0,1),randf_range(0,1), 1)
	line.width = 5
	line.points = [star1.global_position * scale_factor, star2.global_position * scale_factor]
	
	#add the lines as a child to the StarPaths nodes of both stars
	star1.get_node("StarPaths").add_child(line)
	star2.get_node("StarPaths").add_child(line)
	
