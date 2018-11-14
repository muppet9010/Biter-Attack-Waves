GuiStyle = {

	Padding = {
		All2 = function(el)
			el.style.top_padding = 2
			el.style.bottom_padding = 2
			el.style.left_padding = 2
			el.style.right_padding = 2
		end,
		Top2 = function(el)
			el.style.top_padding = 2
		end,
		Left2 = function(el)
			el.style.left_padding = 2
		end,
		
		All4 = function(el)
			el.style.top_padding = 4
			el.style.bottom_padding = 4
			el.style.left_padding = 4
			el.style.right_padding = 4
		end,
		Top4 = function(el)
			el.style.top_padding = 4
		end,
		Left4 = function(el)
			el.style.left_padding = 4
		end,
		
		All8 = function(el)
			el.style.top_padding = 8
			el.style.bottom_padding = 8
			el.style.left_padding = 8
			el.style.right_padding = 8
		end,
		Top8 = function(el)
			el.style.top_padding = 8
		end,
		Left8 = function(el)
			el.style.left_padding = 8
		end
	},
	
	FontColor = {
		Set = function(el, RGBA)
			el.style.font_color = RGBA
		end,
	
		Red = function(el)
			el.style.font_color = sisyphean.color.red
		end,
		BrightRed = function(el)
			el.style.font_color = sisyphean.color.brightred
		end,
		
		Green = function(el)
			el.style.font_color = sisyphean.color.green
		end,
		
		DullYellow = function(el)
			el.style.font_color = sisyphean.color.dullyellow
		end
	},
	
	Font = {
		Normal = function(el)
			el.style.font = "default"
		end,
		Normal_semibold = function(el)
			el.style.font = "default-semibold"
		end,
		Normal_bold = function(el)
			el.style.font = "default-bold"
		end,
	}

}