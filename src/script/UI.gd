extends CanvasLayer

@onready var farm: Button = $ToolBar/ToolRect/TextureRect/Farm
@onready var vacuum: Button = $ToolBar/ToolRect/TextureRect2/Vacuum
@onready var destroy: Button = $ToolBar/ToolRect/TextureRect3/Destroy

@onready var crotte_counter: Label = $StatBar/VBoxContainer/CrotteRect/CrotteCounter
@onready var rabbit_counter: Label = $StatBar/VBoxContainer/RabbitRect/RabbitCounter
@onready var carrot_counter: Label = $Control/VBoxContainer/CarrotRect/CarottCounter

signal tool_selected(tool)

func _ready():
	farm.pressed.connect(func(): tool_selected.emit("farm"))
	vacuum.pressed.connect(func(): tool_selected.emit("vacuum"))
	destroy.pressed.connect(func(): tool_selected.emit("destroy"))
	
	Stats.crotte_count_changed.connect(func(new_count): crotte_counter.text = str(new_count))
	Stats.rabbit_count_changed.connect(func(new_count): rabbit_counter.text = str(new_count))
