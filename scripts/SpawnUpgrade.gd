extends Control

@onready var buy_button = $VBoxContainer/VBoxContainer2/Buy
@onready var quiz_panel = $QuizPanel
@onready var question_label = $QuizPanel/QuestionLabel
@onready var answer_button_1 = $QuizPanel/Answer1
@onready var answer_button_2 = $QuizPanel/Answer2
@onready var wrong_answer_label = $QuizPanel/WrongAnswerLabel
@onready var correct_answer_label = $QuizPanel/CorrectAnswerLabel

const WRONG_ANSWER_DISPLAY_TIME = 1.5
const CORRECT_ANSWER_DISPLAY_TIME = 0.5

var questions = []
var quiz_active = false
var questions_loaded = false
var purchase_completed = false

func _ready():
	load_questions()
	reset_ui_state()

func reset_ui_state():
	quiz_panel.visible = false
	wrong_answer_label.visible = false
	correct_answer_label.visible = false
	if purchase_completed:
		buy_button.text = "Bought"
		buy_button.disabled = true
	else:
		buy_button.text = "Buy"
		buy_button.disabled = false

func load_questions():
	if not FileAccess.file_exists("res://data/questions.json"):
		push_error("Questions file not found at res://data/questions.json")
		return
	
	var file = FileAccess.open("res://data/questions.json", FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		push_error("JSON Parse Error: ", json.get_error_message())
		return
	
	questions = json.get_data()
	questions_loaded = not questions.is_empty()
	print("Loaded %d questions" % questions.size())

func _on_buy_pressed():
	if quiz_active or purchase_completed:
		return
	
	if not questions_loaded:
		push_warning("No valid questions available - completing purchase directly")
		complete_purchase()
	else:
		start_quiz()

func start_quiz():
	quiz_active = true
	buy_button.disabled = true
	quiz_panel.visible = true
	
	# Select a random question
	var random_question = questions[randi() % questions.size()]
	
	# Validate question structure
	if not validate_question(random_question):
		push_error("Invalid question format")
		complete_purchase()
		return
	
	question_label.text = random_question["Questions"]
	# Randomize answer button positions
	if randf() > 0.5:
		answer_button_1.text = str(random_question["Right"])
		answer_button_2.text = str(random_question["Wrong"])
	else:
		answer_button_1.text = str(random_question["Wrong"])
		answer_button_2.text = str(random_question["Right"])

func validate_question(question):
	return question.has("Questions") and question.has("Right") and question.has("Wrong")

func check_answer(selected_answer):
	if not quiz_active:
		return
	
	var current_answer_1 = answer_button_1.text
	var current_answer_2 = answer_button_2.text
	var is_correct = false
	
	# Check which button has the correct answer
	for question in questions:
		if str(question["Right"]) == current_answer_1 and selected_answer == current_answer_1:
			is_correct = true
			break
		if str(question["Right"]) == current_answer_2 and selected_answer == current_answer_2:
			is_correct = true
			break
	
	if is_correct:
		handle_correct_answer()
	else:
		handle_wrong_answer()

func handle_correct_answer():
	quiz_active = false
	correct_answer_label.visible = true
	await get_tree().create_timer(CORRECT_ANSWER_DISPLAY_TIME).timeout
	correct_answer_label.visible = false
	complete_purchase()

func handle_wrong_answer():
	wrong_answer_label.visible = true
	await get_tree().create_timer(WRONG_ANSWER_DISPLAY_TIME).timeout
	wrong_answer_label.visible = false
	end_quiz()

func end_quiz():
	quiz_active = false
	quiz_panel.visible = false
	if not purchase_completed:
		buy_button.disabled = false

func complete_purchase():
	purchase_completed = true
	Global.phase_bought = true
	quiz_panel.visible = false
	buy_button.text = "Bought"
	buy_button.disabled = true
	print("Purchase completed successfully")

func _on_answer_1_pressed():
	check_answer(answer_button_1.text)

func _on_answer_2_pressed():
	check_answer(answer_button_2.text)
