extends Node2D

var star_types = []
const MAX_ATTEMPTS = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#getting the child 'star' nodes
	for child in get_children():
		if child is StaticBody2D:
			star_types.append(child)
			
func is_position_valid(newStar,pos):
	for star in get_children():
		var starDis = star.global_position.distance_to(pos)
		if starDis < newStar.star_radius + star.star_radius:
			return false
	return true
			
func add_star():
	var star_type = star_types[randi() % star_types.size()]
	var newStar = star_type.duplicate()
	#position of stars
	var pos = Vector2.ZERO
	var attempts = 0

	pos.x = randf_range(-250, get_viewport_rect().size.x + 250)
	pos.y = randf_range(-250, get_viewport_rect().size.y + 250)
	attempts += 1
	if attempts > MAX_ATTEMPTS:
		print("Failed to find a valid position for the star after", MAX_ATTEMPTS, "attempts.")
	
	while not is_position_valid(newStar,pos):
		newStar.global_position = pos
	
	add_child(newStar)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
