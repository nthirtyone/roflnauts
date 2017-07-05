all:
	zip not-nautz lib/object/Object.lua not/*.lua config/maps/*.lua config/menus/*.lua config/*.lua assets/*.png assets/sounds/*.ogg assets/platforms/*.png assets/nauts/*.png assets/music/*.ogg assets/decorations/*.png assets/backgrounds/*.png *.lua gamecontrollerdb.txt settings.default 

clean:
	rm ../not-nautz.love