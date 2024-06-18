extends Node

signal download_done

var polling_download
var waiting_download_print
var download_path
var download_was_text
var function_state
var used_http

func _process(delta : float):
	if polling_download:
		if not waiting_download_print:
			waiting_download_print = true
			function_state = yield(get_tree().create_timer(0.2), "timeout")
			var bodySize = used_http.get_body_size()
			var downloadedBytes = used_http.get_downloaded_bytes()
			var percent = int(downloadedBytes*100/bodySize)
			Utils.controller.proxy_print("Downloading " + str(percent) + "%...")
			waiting_download_print = false


func download(link : String, p_path : String, http : HTTPRequest):
	http.connect("request_completed", self, "_http_request_completed")
	var path = Utils.get_absolute_path(p_path)
	if not link.ends_with(".ini"):
		download_was_text = false
		http.set_download_file(path)
	else:
		download_was_text = true
	download_path = path
	print("Downloading " + link + " to " + path)
	used_http = http
	var request = http.request(link)
	polling_download = true
	if request != OK:
		Utils.controller.proxy_print("Http request error")
	else:
		polling_download = true

func _http_request_completed(result, _response_code, _headers, _body):
	polling_download = false
#	print(result)
	if result != OK:
		Utils.controller.proxy_print("Download Failed")
	else:
		Utils.controller.proxy_print("Downloading 100%.")
		if download_was_text:
			Utils.write_file(_body.get_string_from_utf8(), download_path)
	used_http.disconnect("request_completed", self, "_http_request_completed")
	print(_response_code)
	emit_signal("download_done")
