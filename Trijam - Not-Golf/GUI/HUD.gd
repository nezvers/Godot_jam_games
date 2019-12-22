extends CanvasLayer

var show:bool = false setget set_show

func set_show(value:bool):
	show = value
	$Control.visible = value