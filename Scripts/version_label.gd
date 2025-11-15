extends Node

@export var label: Label

func _ready() -> void:
    label.text = ProjectSettings.get_setting("application/config/version")