extends Button

#var data = "res://data/Book(Sheet1).csv"
var data = csv_to_dict_array("res://data/Book(Sheet1).csv")

func _on_pressed() -> void:  
	print("Complete first row:")
	for key in data[0]:
		print(key, ": ", data[0][key])
