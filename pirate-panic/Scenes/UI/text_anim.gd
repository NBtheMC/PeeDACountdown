extends Node

# speed at which the text appears (in letters per second)
@export var letters_per_second : float
@export var linger_time : float

var type_delay : float # 1 / letters_per_second
var full_text : String

# reference to text label
var label

var barks : Dictionary = {
	"hunger_full_1" : "T'was a fine meal.",
	"hunger_full_2" : "The sea always provides.",
	"hunger_low_1" : "Yarr, My stomach be grumblin'...",
	"hunger_low_2" : "I should eat soon...",
	"hunger_low_3" : "I'm famished...",
	"hunger_fatal_1" : "So weak... Need food...",
	"hunger_fatal_2" : "Help... food...",
	"psyche_full_1" : "Must've been the wind...",
	"psyche_full_2" : "It's nothing. Just me and the sea.",
	"psyche_low_1" : "What the freak.",
	"psyche_low_2" : "He's after me. I can't let him win.",
	"psyche_low_3" : "I be seeing things. They aren't real.",
	"psyche_fatal_1" : "I'm going to die out here, aren't I...?",
	"psyche_fatal_2" : "It's only a matter of time until He catches up.",
	"psyche_fatal_3" : "HELP! HELP ME! ... HELP!",
	"psyche_fatal_4" : "He took my crew. He took everything."
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $RichTextLabel
	start_text_scroll(label.text)

func clear_text():
	label.text = ""

func start_text_scroll(text: String) -> void:
	full_text = text
	#clear_text()
	type_delay = 1.0 / letters_per_second
	label.visible_characters = 0
	text_scroll()

func text_scroll() -> void:
	#var bbcode_skip : bool
	#bbcode_skip = false
	
	
	while label.visible_ratio < 1.0:
		label.visible_characters += 1
		await get_tree().create_timer(type_delay).timeout
	
	### GRAVEYARD OF SHAME FOR REIMPLEMENTING EXISTING FEATURE ###
	#for i in full_text.length():
	#	$RichTextLabel.text += full_text[i]
	#	if (full_text[i] == '[' or full_text[i] == '{' or full_text[i] == '/'): bbcode_skip = true
	#	if (full_text.length() > i + 3 and full_text[i] == 'r' and full_text[i + 1] == 'e' and full_text[i + 2] == 's' and full_text[i + 3] == ':'): bbcode_skip = true
	#	if (full_text[i] == ']' or full_text[i] == '}'): bbcode_skip = false
	#	print($RichTextLabel.text)
	#	
	#	# don't wait for delay under these conditions
	#	if (bbcode_skip): continue
	#	#if (full_text[i] == ' '): continue
	#	
	#	await get_tree().create_timer(type_delay).timeout
	
	await get_tree().create_timer(linger_time).timeout
	clear_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
