extends Button
	 
# In the button's script (e.g., MyButton.gd)
func _ready():
	var ui_root = CanvasLayer.new() 
	get_parent().add_child(ui_root)
	ui_root.add_child(self)
