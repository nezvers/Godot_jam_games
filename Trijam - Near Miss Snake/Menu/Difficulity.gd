extends Control

func _ready()->void:
	var buttons:Array = $VBoxContainer/HBoxContainer.get_children()
	for button in buttons:
		button.connect("pressed", self, "pressed", [button.name])

func pressed(value:String)->void:
	Event.difficulity = float(value)
	owner._on_Button_pressed()
