extends ShakeableCamera

@export var amt := 10
@export var dur := 0.3

func _ready() -> void:
	shake(amt, dur)
