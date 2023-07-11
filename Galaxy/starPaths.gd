extends Node2D

var starPaths = {} # to store references to stars and their paths 

class StarComparator:
	var ref_star
	
	func _init(_ref_star):
		ref_star = _ref_star
		
	func compare(star1, star2):
		return star1.global_position.distance_to(ref_star.global_position) - star2.global_position.distance_to(ref_star.global_position)

func generate_paths():
	for star in get_tree().get_nodes_in_group("stars"):
		if star.name != "Central_Black_Hole":
			print("Star: ", star.name)
			var max_paths = get_max_paths(star.star_type)
			print("MAx paths: ", max_paths)
			for i in range(max_paths):
				var other_star = choose_other_star(star)
				if other_star == null:
					break
				add_path_between(star,other_star)

func create_path(star, max_paths):
	var current_paths = 0
	while current_paths < max_paths:
		var other_star = choose_other_star(star)
		if other_star == null: # if there are no stars to connect
			break
		if len(other_star.get_node("starPaths").get_children()) < get_max_paths(other_star.star_type):
			add_path_between(star,other_star)
			current_paths +=1
			
func choose_other_star(star):
	var other_stars = get_tree().get_nodes_in_group("stars").duplicate()
	other_stars.erase(star)
	
	for path in star.get_node("StarPaths").get_children():
		if path.points[1] in other_stars:
			other_stars.erase(path.points[1])
	if other_stars.is_empty():
		return null
	else:
		var comparator = StarComparator.new(star)
		other_stars.sort_custom(Callable(comparator, "compare"))
		return other_stars[0]
		
	
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
	
func add_path_between(star1, star2):
	var line = Line2D.new()
	line.default_color = Color(randf_range(0,1),randf_range(0,1), 1)
	line.width = 2
	line.points = [star1.global_position, star2.global_position]
	
	#add the lines as a child to the StarPaths nodes of both stars
	star1.get_node("StarPaths").add_child(line)
	star2.get_node("StarPaths").add_child(line)
	
