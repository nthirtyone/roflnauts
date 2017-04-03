all:
	zip not-nautz not/*.lua maps/*.lua config/*.lua assets/*.png assets/sounds/*.ogg assets/platforms/*.png assets/nauts/*.png assets/music/*.ogg assets/decorations/*.png assets/backgrounds/*.png *.lua gamecontrollerdb.txt settings.default 
	mv not-nautz.zip ../not-nautz.love

clean:
	$(RM) ../not-nautz.love