# RGBA-FLOAT-RGBA
For GLSL ES or WebGL shader. Encodes 32bit floating point number to color RGBA, and decodes back. 

This tries to emulate 32bit floating-point number with little-endian system. 
To make it for big-endian, remove ".abgr" swizzles, or add checks to swizzle or not.

Originally this was written for GameMaker, but hopefully this is useful for others too.

