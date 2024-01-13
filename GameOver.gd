extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and not get_child(1).has_focus():
		get_child(1).grab_focus()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
