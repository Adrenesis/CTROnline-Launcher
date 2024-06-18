extends Node



#	OS.execute("cmd.exe", ["/c", ("echo " + usernameLineEdit.text + "> ./username.ini") ], false, output, true, true)
#	OS.execute("powershell", args, false, output, true, true)
func get_run_string():
	#TODO support Linux
	return get_win_run_string()

func get_win_run_string():
	var string = ".\\autoupdater.bat"
	string += " -f" if fps30Button.pressed else ""
	string += " -sb" if skipBiosButton.pressed else ""
	string += " -sd" if skipDuckStationButton.pressed else ""
	string += " -ss" if skipGameSettingsButton.pressed else ""
	string += " -sx" if skipXDeltaButton.pressed else ""
	string += " -fb" if forceBiosButton.pressed else ""
	string += " -fd" if forceDuckStationButton.pressed else ""
	string += " -fs" if forceGameSettingsButton.pressed else ""
	string += " -fx" if forceXDeltaButton.pressed else ""
	string += " -fu" if forceUpdateButton.pressed else ""
	string += " -i '" + inputLineEdit.text.replace("/", "\\") + "'"
	string += " -o '" + outputLineEdit.text.replace("/", "\\") + "'"
	string += " -b '" + biosLineEdit.text.replace("/", "\\") + "'"
	string += " -d '" + duckStationLineEdit.text.replace("/", "\\") + "'"
	string += " -s '" + gameSettingsLineEdit.text.replace("/", "\\") + "'"
	string += " -x '" + xDeltaLineEdit.text.replace("/", "\\") + "'"
	
	return string
