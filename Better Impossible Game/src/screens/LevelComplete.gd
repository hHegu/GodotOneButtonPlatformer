extends Control

func _ready():
	GameStates.connect("level_complete", self, "show_complete_menu")
	
func show_complete_menu():
	set_visible(true)
