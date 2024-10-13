extends TextureButton

var normal_color = Color.DIM_GRAY
var hover_color = Color.GRAY

# Called when the node enters the scene tree for the first time.
func _ready():
	var bg_img = Image.create(1,1,false,Image.FORMAT_RGB8)
	bg_img.fill(normal_color)
	var normal_bg = ImageTexture.new()
	normal_bg.set_image(bg_img)
	self.texture_normal = normal_bg
	
	self.mouse_entered.connect(_on_mouse_enter)
	self.mouse_exited.connect(_on_mouse_exit)
	self.pressed.connect(_on_press)

func _on_mouse_enter():
	var bg_img = Image.create(1,1,false,Image.FORMAT_RGB8)
	bg_img.fill(hover_color)
	var normal_bg = ImageTexture.new()
	normal_bg.set_image(bg_img)
	self.texture_normal = normal_bg
	
func _on_mouse_exit():
	var bg_img = Image.create(1,1,false,Image.FORMAT_RGB8)
	bg_img.fill(normal_color)
	var normal_bg = ImageTexture.new()
	normal_bg.set_image(bg_img)
	self.texture_normal = normal_bg

func _on_press():
	#while pressed, have the background color slide from left to right, progress bar style, where the left most side represents 0 seconds and the right most side represents x seconds where x is the confirmation time
	pass 
