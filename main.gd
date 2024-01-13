extends Node

# Each TileMap Room is 448 x 448

const ROOMS = {
	"four_door": {
		"left_down_right_up": preload("res://rooms/room_left_down_right_up.tscn"),
	},
	"three_door": {
		"left_down_right": preload("res://rooms/room_left_down_right.tscn"),
		"left_down_up": preload("res://rooms/room_left_down_up.tscn"),
		"left_right_up": preload("res://rooms/room_left_right_up.tscn"),
		"down_right_up": preload("res://rooms/room_down_right_up.tscn"),
	},
	"two_door": {
		"left_down": preload("res://rooms/room_left_down.tscn"),
		"left_right": preload("res://rooms/room_left_right.tscn"),
		"left_up": preload("res://rooms/room_left_up.tscn"),
		"down_right": preload("res://rooms/room_down_right.tscn"),
		"down_up": preload("res://rooms/room_down_up.tscn"),
		"right_up": preload("res://rooms/room_right_up.tscn"),
	},
	"one_door": {
		"left": preload("res://rooms/room_left.tscn"),
		"down": preload("res://rooms/room_down.tscn"),
		"right": preload("res://rooms/room_right.tscn"),
		"up": preload("res://rooms/room_up.tscn"),
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_rooms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_rooms():
	var dungeon = [
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, true, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
		[false, false, false, false, false, false, false, false, false, false],
	]
	
	var i = 0
	
	while i < 30:
		var num: int
		for j in dungeon.size():
			for k in dungeon[j].size():
				if dungeon[j][k]:
					if j > 0:
						num = randi_range(0, 5)
						if num < 4:
							dungeon[j-1][k] = true
							i += 1
					
					if j < 9:
						num = randi_range(0, 5)
						if num < 4:
							dungeon[j+1][k] = true
							i += 1
					
					if k > 0:
						num = randi_range(0, 5)
						if num < 4:
							dungeon[j][k-1] = true
							i += 1
					
					if k < 9:
						num = randi_range(0, 5)
						if num < 4:
							dungeon[j][k+1] = true
							i += 1

	for j in dungeon[0].size():
		for k in dungeon[j].size():
			if dungeon[j][k]:
				var doors = 0
				var left = false
				var down = false
				var right = false
				var up = false
				
				var rooms: Dictionary
				
				if j > 0:
					if dungeon[j-1][k]:
						doors += 1
						left = true
				if j < 9:
					if dungeon[j+1][k]:
						doors += 1
						right = true
				if k > 0:
					if dungeon[j][k-1]:
						doors += 1
						up = true
				if k < 9:
					if dungeon[j][k+1]:
						doors += 1
						down = true
				
				if doors == 1:
					rooms = ROOMS.one_door
					if left:
						instantiate_room(rooms.right, j, k)
					elif down:
						instantiate_room(rooms.up, j, k)
					elif right:
						instantiate_room(rooms.left, j, k)
					elif up:
						instantiate_room(rooms.down, j, k)
				elif doors == 2:
					rooms = ROOMS.two_door
					if left && down:
						instantiate_room(rooms.right_up, j, k)
					if left && right:
						instantiate_room(rooms.left_right, j, k)
					if left && up:
						instantiate_room(rooms.down_right, j, k)
					if down && right:
						instantiate_room(rooms.left_up, j, k)
					if down && up:
						instantiate_room(rooms.down_up, j, k)
					if right && up:
						instantiate_room(rooms.left_down, j, k)
				elif doors == 3:
					rooms = ROOMS.three_door
					if left && down && right:
						instantiate_room(rooms.left_right_up, j, k)
					if left && down && up:
						instantiate_room(rooms.down_right_up, j, k)
					if left && right && up:
						instantiate_room(rooms.left_down_right, j, k)
					if down && right && up:
						instantiate_room(rooms.left_down_up, j, k)
				elif doors == 4:
					rooms = ROOMS.four_door
					instantiate_room(rooms.left_down_right_up, j, k)


func instantiate_room(ref, j, k):
	j -= 4
	k -= 4
	var instance = ref.instantiate()
	instance.position = Vector2(-448 * j, -448 * k)
	add_child(instance)
	move_child(instance, 0)
