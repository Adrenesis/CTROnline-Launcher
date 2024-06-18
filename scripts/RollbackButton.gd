extends Button

export var windowsDefault := ""
export var linuxDefault := ""

var lineEdit = null

func _ready():
	lineEdit = get_node("../" + get_name().replace("Rollback", "LineEdit"))
	

func _pressed():
	if OS.get_name() == "Windows":
		lineEdit.text = windowsDefault
	elif OS.get_name() == "X11":
		lineEdit.text = linuxDefault
	else:
		OS.alert("Sorry this OS is nor implemented yet =(")
