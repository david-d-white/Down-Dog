extends Camera2D

func _ready():
	limit_top = $Limits/TopLeft.position.y
	limit_left = $Limits/TopLeft.position.x
	limit_bottom = $Limits/BottomRight.position.y
	limit_right = $Limits/BottomRight.position.x

var accum = 0

func _physics_process(delta):
	accum += delta
	if accum >= 1:
		accum -= 1
		
		print(get_camera_position(), " ", get_camera_screen_center())
