extends CanvasLayer

onready var CurrentTime:String = $CurrentTime.text
onready var BestTime:String = $BestTime.text
onready var TimeToBeat:String = $TimeToBeat.text
var Time:float = 0.0
var FastestTime:float = -1.0
var failed:bool = false
onready var Time_limit:float = get_parent().Time_limit

func _ready()->void:
	set_process(false)	#don't count until start is touched
	Event.connect("Start", self, "on_Start")
	Event.connect("Lap", self, "on_Lap")
	Event.connect("Fail", self, "on_Fail")
	$CurrentTime.text = CurrentTime+"0:00"
	$BestTime.text = BestTime+"x:xx"
	$TimeToBeat.text = TimeToBeat+ time_to_string(Time_limit)

func on_Start()->void:
	set_process(true)

func on_Fail()->void:
	failed = true
	$Restart.show()
	set_process(false)

func on_Lap()->void:
	if failed:
		return
	if FastestTime<0.0 || Time < FastestTime:
		FastestTime = Time
		$BestTime.text = $CurrentTime.text
	if Time <= Time_limit:
		Event.emit_signal("NextScene")
	Time = 0.0

func _process(delta)->void:
	Time += delta
	$CurrentTime.text = CurrentTime + time_to_string(Time)

func time_to_string(time:float)->String:
	var sec:float = floor(time)
	var milisec:float = floor(fmod(time, 1) * 100)
	return str(sec)+":"+str(milisec)