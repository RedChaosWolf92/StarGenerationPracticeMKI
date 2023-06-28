extends Node2D

var star_types = []

@export var numStars: int = 150

var offset_range = 2400
var scaleFactor = 6
var MaxNearbyStars = 7

const MAX_ATTEMPTS = 15
const DISPLACEMENT_STDEV = 2.5
const REPEL_FORCE = 3.5
const MAX_REPEL_ITERATIONS = 10
var center = Vector2(get_viewport_rect().size / 2)

var rng = RandomNumberGenerator.new()
var visible_stars = [] #list for tracking all visible stars
var removedStars: int = 0

@onready var camera = $Practice

func _ready():
	# get all star types and hide them
	for child in get_children():
		if child is StaticBody2D:
			star_types.append(child)
			child.hide()
			
	#sort star_types in descending order by their sizes
	star_types.sort_custom(Callable(self, "compare_star_sizes"))
	
	# start star generation
	generate_stars()
	
	# center the camera
	camera.global_position = get_viewport_rect().size / 2
	camera.scale = Vector2(.5,.5)

func compare_star_sizes(star1, star2):
	if star1.star_size > star2.star_size:
		return -1
	elif star1.star_size < star2.star_size:
		return 1
	else:
		return 0
		
func generate_stars():
	rng.randomize()
	
	var path = $Path2D.curve.get_baked_points()
	var scaled_path = []
	
	for point in path:
		scaled_path.append(point * scaleFactor)
		
	var step = scaled_path.size() / numStars
	
	
	#uniformed placement
	for i in range(numStars):
		var newstar = chooseStar().duplicate()
		var t = sqrt(float(i) / numStars)
		var pos = scaled_path[int(i * step) % scaled_path.size()]
		var disfromCenter = pos.distance_to(center)
		
		#Calculate direction of path
		var direction = Vector2()
		if i < numStars - 1:
			direction = scaled_path[i + 1] - scaled_path[i]
		else:
			direction = scaled_path[i] - scaled_path[i - 1]
			
		#calculate perpendicular direction
		var PerpDirection = Vector2(-direction.y, direction.x).normalized()
		
		#add random displacement
		var displacement = PerpDirection * disfromCenter * rng.randfn() * DISPLACEMENT_STDEV * (1 -4 * (t - 0.5) * (t - 0.5))
		
		
		#adding random angle to each star's position
		'var angle = rng.randf() * 2 * PI
		var distance = rng.randf() * t * DISPLACEMENT_STDEV
		displacement += Vector2(cos(angle), sin(angle)) * distance'
		
		pos += displacement
		
		place_star(pos,newstar)
		
	#Collision avoidance
	for c in range(MAX_REPEL_ITERATIONS):
		var hasMoved = false
		for star in visible_stars:
			var repelForce = Vector2()
			for otherStars in visible_stars:
				if star == otherStars:
					continue
					
				var diff = star.global_position - otherStars.global_position
				var dist = diff.length()
				
				if dist < star.safeDisfromOthers + otherStars.safeDisfromOthers:
					repelForce += diff.normalized() / dist
			
			if repelForce.length() > 0:
				hasMoved = true
				star.global_position += repelForce.normalized() * REPEL_FORCE
				
		if !hasMoved:
			break
#modify to check for overlaps only with visible stars
'func is_position_valid(pos: Vector2, newstar) -> bool:
	var num_nearby_stars = 0
	for star in visible_stars:
		var minDist = star.safeDisfromOthers + newstar.safeDisfromOthers
		var maxDist = minDist * 4
		var dist = star.global_position.distance_to(pos)
		if dist < minDist:
			num_nearby_stars += 1
		if num_nearby_stars > MaxNearbyStars:
			return false
	return true'

'func revalidate_stars(newstar):	
	for star in visible_stars:
		if star != newstar:
			var minDist = star.safeDisfromOthers + newstar.safeDisfromOthers
			var maxDist = minDist * 4
			var dist = star.global_position.distance_to(newstar.global_position)
			if dist < minDist:
				visible_stars.erase(star)
				star.queue_free()
				removedStars += 1
				print("Stars removed: ", removedStars)
				#after finding overlapping star and removing, we can revalid
				revalidate_stars(newstar)
				return'


func place_star(pos: Vector2, newstar):
	newstar.global_position = pos
	newstar.show()
	add_child(newstar)
	visible_stars.append(newstar)
	print(newstar, " and ", pos," and ", newstar.safeDisfromOthers)
	print("Total Stars: ", visible_stars.size())

func chooseStar():
	var ran = randf()
	var total_Prob = 0.0
	for star in star_types:
		total_Prob += star.probability
		if ran <= total_Prob:
			return star
	return star_types[0]
