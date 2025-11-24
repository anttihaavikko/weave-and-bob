class_name Message
extends Label

@export var speed := 1.0

var content: String
var pos := 0.0
var done := true

func show_text(txt: String):
	content = txt
	pos = 0
	done = false

func _process(delta):
	if not done:
		pos += delta * 20 * speed
		done = pos >= len(content)
		text = content.substr(0, floori(pos))