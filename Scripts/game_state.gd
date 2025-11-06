extends Node

var has_magazine := false
var map_upgrades := 0

var ids: Array[String]

func mark(id: String):
	ids.push_back(id)

func has(id: String) -> bool:
	return ids.has(id)