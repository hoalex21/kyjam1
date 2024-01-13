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

const PURPLE_GUY = preload("res://purple_guy.tscn")

const LADDER = preload("res://ladder.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_rooms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_rooms():
	var dungeon = [
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, true, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
		[null, null, null, null, null, null, null, null, null, null],
	]
	
	var i = 0
	
	var num: int
	
	while i < 50:
		for j in dungeon.size():
			for k in dungeon[j].size():
				if dungeon[j][k]:
					if j > 0:
						num = randi_range(0, 5)
						if num < 2:
							dungeon[j-1][k] = true
							i += 1
					
					if j < dungeon.size() - 1:
						num = randi_range(0, 5)
						if num < 2:
							dungeon[j+1][k] = true
							i += 1
					
					if k > 0:
						num = randi_range(0, 5)
						if num < 2:
							dungeon[j][k-1] = true
							i += 1
					
					if k < dungeon[j].size() - 1:
						num = randi_range(0, 5)
						if num < 2:
							dungeon[j][k+1] = true
							i += 1
	
	var ladder = 1
	while ladder > 0:
		for j in dungeon.size():
			for k in dungeon[j].size():
				if dungeon[j][k] == true:
					num = randi_range(0, 20)
					if num == 0 and j != 4 and k != 4:
						dungeon[j][k] = "ladder"
						ladder -= 1
						break
			if ladder < 1:
				break

	for j in dungeon.size():
		for k in dungeon[j].size():
			var current_room = dungeon[j][k]
			if current_room:
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
				if j < dungeon.size() - 1:
					if dungeon[j+1][k]:
						doors += 1
						right = true
				if k > 0:
					if dungeon[j][k-1]:
						doors += 1
						up = true
				if k < dungeon[j].size() - 1:
					if dungeon[j][k+1]:
						doors += 1
						down = true
				
				if doors == 1:
					rooms = ROOMS.one_door
					if left:
						instantiate_room(rooms.right, j, k, current_room)
					elif down:
						instantiate_room(rooms.up, j, k, current_room)
					elif right:
						instantiate_room(rooms.left, j, k, current_room)
					elif up:
						instantiate_room(rooms.down, j, k, current_room)
				elif doors == 2:
					rooms = ROOMS.two_door
					if left && down:
						instantiate_room(rooms.right_up, j, k, current_room)
					if left && right:
						instantiate_room(rooms.left_right, j, k, current_room)
					if left && up:
						instantiate_room(rooms.down_right, j, k, current_room)
					if down && right:
						instantiate_room(rooms.left_up, j, k, current_room)
					if down && up:
						instantiate_room(rooms.down_up, j, k, current_room)
					if right && up:
						instantiate_room(rooms.left_down, j, k, current_room)
				elif doors == 3:
					rooms = ROOMS.three_door
					if left && down && right:
						instantiate_room(rooms.left_right_up, j, k, current_room)
					if left && down && up:
						instantiate_room(rooms.down_right_up, j, k, current_room)
					if left && right && up:
						instantiate_room(rooms.left_down_right, j, k, current_room)
					if down && right && up:
						instantiate_room(rooms.left_down_up, j, k, current_room)
				elif doors == 4:
					rooms = ROOMS.four_door
					instantiate_room(rooms.left_down_right_up, j, k, current_room)


func instantiate_room(ref, j, k, current_room_value):
	j -= 4
	k -= 4
	var room = ref.instantiate()
	room.position = Vector2(-448 * j, -448 * k)
	add_child(room)
	move_child(room, 0)
	
	if typeof(current_room_value) == TYPE_STRING:
		if current_room_value == "ladder":
			var ladder = LADDER.instantiate()
			ladder.position = room.position
			add_child(ladder)
			move_child(ladder, $Player.get_index())
	elif j != 0 and k != 0:
		var num = randi_range(0, 1)
		if num == 0:
			var purple_guy = PURPLE_GUY.instantiate()
			purple_guy.position = room.position
			add_child(purple_guy)
