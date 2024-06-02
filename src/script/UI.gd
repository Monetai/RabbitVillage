extends CanvasLayer

@onready var farm: Button = $Farm
@onready var vacuum: Button = $Vacuum
@onready var destroy: Button = $Destroy

@onready var crotte_counter: Label = $CrotteCounter
@onready var rabbit_counter: Label = $RabbitCounter

signal tool_selected(tool)

func _ready():
	farm.pressed.connect(func(): tool_selected.emit("farm"))
	vacuum.pressed.connect(func(): tool_selected.emit("vacuum"))
	destroy.pressed.connect(func(): tool_selected.emit("destroy"))
	
	Stats.crotte_count_changed.connect(func(new_count): crotte_counter.text = str(new_count))
	Stats.rabbit_count_changed.connect(func(new_count): rabbit_counter.text = str(new_count))
