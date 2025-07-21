extends Node

var questions = []

func _ready():
	load_questions()

func load_questions():
	var file = FileAccess.open("res://data/questions.json", FileAccess.READ)
	questions = JSON.parse_string(file.get_as_text())
