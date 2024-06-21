extends Node

signal update_confirm_answered

var need_to_update = false

func main():
	Utils.controller.updateConfirmationDialog.get_ok().connect("pressed", self, "update_confirmed")
	Utils.controller.updateConfirmationDialog.get_cancel().connect("pressed", self, "update_canceled")
	Utils.controller.updateConfirmationDialog.get_close_button().connect("pressed", self, "update_canceled")
	Utils.make_directory("./temp/")
	if not Utils.directory_exists("./temp/"):
		OS.alert("Can't write " + Utils.get_absolute_path("./temp/"))
		yield(get_tree(), "idle_frame")
	else:
		Downloader.download("https://github.com/Adrenesis/CTROnline-Launcher/releases/latest/download/version" , "./temp/version.txt", Utils.controller.versionHTTPRequest)
		yield(Downloader, "download_done")
#		print("whaaat?")
		var new_version = Utils.read_file("./temp/version.txt").replace("\r", "")
		new_version = new_version.replace("\n", "")
		var old_version = Utils.controller.versionLabel.text.replace("v", "")
		var new_version_table = new_version.split(".")
		var old_version_table = old_version.split(".")
#		print(new_version_table) 
#		print(old_version_table)
		if new_version_table[0] > old_version_table [0]:
			need_to_update = true
		elif new_version_table[0] == old_version_table [0]:
			if new_version_table[1] > old_version_table [1]:
				need_to_update = true
			elif new_version_table[1] == old_version_table [1]:
				if new_version_table[2] > old_version_table [2]:
					need_to_update = true
				elif new_version_table[2] == old_version_table [2]:
					if new_version_table[3] > old_version_table [3]:
						need_to_update = true
		if (need_to_update):
			Utils.controller.updateConfirmationDialog.get_node("Label2").text = (
				"Th launcher can update from v" + old_version + " to v" + new_version + "\n" +
				"Do you want to update?")
			Utils.controller.updateConfirmationDialog.popup()
			yield(self, "update_confirm_answered")
	
	print("answered")
	Utils.controller.updateConfirmationDialog.get_ok().disconnect("pressed", self, "update_confirmed")
	Utils.controller.updateConfirmationDialog.get_cancel().disconnect("pressed", self, "update_canceled")
	Utils.controller.updateConfirmationDialog.get_close_button().disconnect("pressed", self, "update_canceled")
	print(Utils.controller.usernameLineEdit.text)
	Utils.controller.is_running = false
	Utils.controller.username_changed(Utils.controller.usernameLineEdit.text)
	queue_free()
		
		
func update_confirmed():
	print("confirmed")
	print(Utils.os_get_original_exe_filename())
	Downloader.download(Utils.os_get_update_link() , "./temp/" + Utils.os_get_update_zip_filename(), Utils.controller.updateHTTPRequest) 
	yield(Downloader, "download_done")
	Utils.os_extract_archive("./temp/" + Utils.os_get_update_zip_filename(), "./temp/")

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	Utils.os_install_update_and_relaunch()
	emit_signal("update_confirm_answered")
	get_tree().quit()

func update_canceled():
	emit_signal("update_confirm_answered")
		#https://github.com/Adrenesis/CTROnline-Launcher/releases/latest/download/CTROnline-Launcher-win64-latest.zip
	#Compare from local version
	#If already last 
		#return to controller
	#Else 
		#download last version
		#launch a script with ping (to wait) then copy launcher on itself
		#close th launcher
	

