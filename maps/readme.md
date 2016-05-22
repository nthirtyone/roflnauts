# Mapmaking
*Hugs Emo*.
### Center
It is the center of the map. Camera will use it for tracking and together with **map size** they will cause deaths to players (IRL).

### Size
This is used for camera and checking if naut should die. Camera tracks nauts that are in rectangle with *width* x *height* size with its center in **map center**. 

Nauts will die if they are outside of rectangle with *width&sdot;2* x *height&sdot;2* size also with its center in the **map center**.

### Colors
In RGBA format.

### Respawns
Global coordinates to each respawn point.

### Platforms
This image should explain most parts of creating platforms:

![alt](https://raw.githubusercontent.com/nthirtyone/not-nautz/master/maps/platform.png)
