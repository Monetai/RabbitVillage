extends Node

signal crotte_count_changed(new_count)
signal rabbit_count_changed(new_count)
signal carrot_count_changed(new_count)

var crotte_count : int = 9999:
	set(new_value):
		crotte_count = new_value
		crotte_count_changed.emit(new_value)
		
var rabbit_count : int = 0:
	set(new_value):
		rabbit_count = new_value
		rabbit_count_changed.emit(new_value)

var carrot_count: float = 0.0:
	set(new_value):
		carrot_count = new_value
		carrot_count_changed.emit(new_value)
