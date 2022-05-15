# RGBA-FLOAT-RGBA
For GLSL ES or WebGL shader. 
Allows you encodes 32bit floating point number to RGBA color channels, and decode them back. 

This tries to emulate 32bit floating-point number with little-endian system. 
To make it for big-endian, remove ".abgr" swizzles, or add checks to swizzle or not.

Originally this was written for GameMaker, but hopefully this is useful for others too.
As alpha-channel is also used for encoding, remember to disable blending when drawing to destination surface.

The encode-function took inspiration from someone else code, so can't take full credit for that.
