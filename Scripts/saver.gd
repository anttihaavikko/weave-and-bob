class_name Saver

static var filename: String

func _init(name := "save.dat"):
	filename = "user://%s" % name

func save(data: Dictionary):
	var file := FileAccess.open(filename, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))

func load() -> Dictionary:
	if not FileAccess.file_exists(filename):
		return {}
	var file = FileAccess.open(filename, FileAccess.READ)
	while file.get_position() < file.get_length():
		var data: Dictionary = JSON.parse_string(file.get_line())
		if data:
			return data
	return {}

func erase():
	save({})