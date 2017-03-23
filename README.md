# Arche
A modular gamemode template for Garry's Mod

## WTF is it?

Arche is technically a "working" gamemode, but it doesn't do much. It was made to be a template for creating 
your own gamemodes.
It comes with the 3 base files, `init.lua`, `shared.lua`, and `cl_init.lua`, but will also load any lua file 
in the `modules` directory.
It won't just load the files, but it will load them in the correct order, and using include/AddCSLuaFile appropriately. 
All you need to worry about is making sure your files start with:

* `sh_` for shared files
* `cl_` for client-side files
* `sv_` for server-side files

You can add numbers to your modules directory if you want to load them in a particular order, as Arche will sort them by 
default. The numbering system is completely optional. 
So your workspace should look something like

```
gamemode
|\
| modules
|  \
|   01_mymod
|    \
|     sv_mymod.lua
|     sh_mymod.lua
|     cl_mymod.lua
|
cl_init.lua
init.lua
shared.lua
```
