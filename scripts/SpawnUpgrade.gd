extends Control

@onready var buy_button = $VBoxContainer/VBoxContainer2/Buy
@onready var quiz_panel = $QuizPanel
@onready var question_label = $QuizPanel/QuestionLabel
@onready var answer_button_1 = $QuizPanel/Answer1
@onready var answer_button_2 = $QuizPanel/Answer2
@onready var wrong_answer_label = $QuizPanel/WrongAnswerLabel

var questions = []
var current_question = 0
var quiz_active = false

func _ready():
	load_questions()
	quiz_panel.visible = false
	wrong_answer_label.visible = false
	
	# Connect buttons programmatically if not done in editor
	answer_button_1.pressed.connect(_on_answer_1_pressed)
	answer_button_2.pressed.connect(_on_answer_2_pressed)

func load_questions():
	if not FileAccess.file_exists("res://data/questions.json"):
		push_error("Questions file not found!")
		return
	
	var file = FileAccess.open("res://data/questions.json", FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	
	if error != OK:
		push_error("JSON Parse Error: ", json.get_error_message())
		return
	
	questions = json.get_data()
	print("Loaded %d questions" % questions.size())

func _on_buy_pressed():
	if quiz_active:
		return
	
	if questions.is_empty():
		push_warning("No questions available - skipping quiz")
		complete_purchase()
	else:
		start_quiz()

func start_quiz():
	quiz_active = true
	current_question = 0
	buy_button.disabled = true
	quiz_panel.visible = true
	show_question(current_question)

func show_question(index):
	if index >= questions.size():
		complete_purchase()
		return
	
	var question = questions[index]
	question_label.text = question.get("Qestuions", "Missing question text")
	answer_button_1.text = str(question.get("RIght", "?"))
	answer_button_2.text = str(question.get("Wrong", "?"))

func check_answer(selected_answer):
	var correct_answer = str(questions[current_question].get("RIght", ""))
	
	if selected_answer == correct_answer:
		current_question += 1
		if current_question >= questions.size():
			complete_purchase()
		else:
			show_question(current_question)
	else:
		handle_wrong_answer()

func handle_wrong_answer():
	wrong_answer_label.visible = true
	await get_tree().create_timer(1.5).timeout
	wrong_answer_label.visible = false
	quiz_panel.visible = false
	quiz_active = false
	buy_button.disabled = false

func complete_purchase():
	Global.phase_bought = true
	print("Bought phase")
	queue_free()

func _on_answer_1_pressed():
	check_answer(answer_button_1.text)

func _on_answer_2_pressed():
	check_answer(answer_button_2.text)
