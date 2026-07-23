extends Node

# speed at which the text appears (in letters per second)
@export var letters_per_second : float
var type_delay : float # 1 / letters_per_second
var full_text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_text_scroll($RichTextLabel.text)

func start_text_scroll(text: String) -> void:
	full_text = text
	$RichTextLabel.text = ""
	type_delay = 1.0 / letters_per_second
	text_scroll()

func text_scroll() -> void:
	var bbcode_skip : bool
	bbcode_skip = false
	
	for i in full_text.length():
		$RichTextLabel.text += full_text[i]
		if (full_text[i] == '[' or full_text[i] == '{' or full_text[i] == '/'): bbcode_skip = true
		if (full_text.length() > i + 3 and full_text[i] == 'r' and full_text[i + 1] == 'e' and full_text[i + 2] == 's' and full_text[i + 3] == ':'): bbcode_skip = true
		if (full_text[i] == ']' or full_text[i] == '}'): bbcode_skip = false
		print($RichTextLabel.text)
		
		# don't wait for delay under these conditions
		if (bbcode_skip): continue
		#if (full_text[i] == ' '): continue
		
		await get_tree().create_timer(type_delay).timeout
	
	#for letter in full_text:
	#	$RichTextLabel.text += letter
	#	if (letter == '[' or letter == '{' or letter == '/'): bbcode_skip = true
	#	if (letter == ']' or letter == '}'): bbcode_skip = false
	#	print($RichTextLabel.text)
	#	if (not bbcode_skip):
	#		await get_tree().create_timer(type_delay).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
