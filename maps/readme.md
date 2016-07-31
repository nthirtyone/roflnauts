# Mapmaking
*Hugs Emo*

### Name (string)
Name of the map. Should be same as the filename. *I think*.
```lua
name = "default"
```

### Center (int)
Coordinates of center of the map. Camera zone and death zone are placed relative to it.
```lua
center_x = 0,
center_y = 0
```

### Size (int)
Width and height of playground. Camera zone and death zone sizes are calculated based on map size.
```lua
width  = 360,
height = 240
```

### Respawns (table, int)
Table of possible respawn points. Players will randomly spawn on one of these points.
```lua
respawns = {
	{x = -15, y = -80},
	{x =  -5, y = -80},
	{x =   5, y = -80},
	{x =  15, y = -80}
}
```

### Clouds (bool)
Presence of clouds. Clouds will spawn if set to **true**.
```lua
clouds = true
```

### Background (string)
Path to background image in the game structure. It will be used as fixed background.
```lua
background = "assets/background-default.png"
```

### Platforms (table, int, string)
Platforms on which player can stand. They will be placed on given coordinates with given sprite and shape.
Shape are points placed relatively to platform's coordinates. Shape points are connected in given order. On top of that last point is connected with first one.
```lua
platforms = {
	{
		x = -91,
		y = 0,
		shape = {0,1, 181,1, 181,10, 96,76, 86,76, 0,10},
		sprite = "assets/platform_big.png"
	},
	{
		x = 114,
		y = 50,
		shape = {0,1, 52,1, 52,30, 0,30},
		sprite = "assets/platform_small.png"
	}
}
```

### Decoration (table, int, string)
Decorations are objects in the background which are not fixed but move alongside with foreground objects (platforms, players, clouds). They do not have physical body.
```lua
decorations = {
	{
		x = -80,
		y = 10,
		sprite = "assets/decoration_big.png"
	},
	{
		x = 50,
		y = 50,
		sprite = "assets/decoration_small.png"
	}
}
```