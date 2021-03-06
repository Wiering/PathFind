# PathFind

PathFind is a simple console program to easily find the location of an executable file on your system, 
according to the PATH and PATHEXT variables. 
This can be useful if you have multiple versions of the same program on your computer, for example:

```
C:\> pathfind make

d:\Borland\Delphi5\Bin\make.exe
C:\FPC\bin\i386-Win32\make.exe
```
You may also use wildcards:

```
C:\> pathfind notepad*

c:\windows\system32\notepad.exe
c:\windows\notepad.exe
d:\utils\Notepad2.exe
```

The files are listed in the order they occur in the PATH, so the top result is the one that would run from the command line.

PathFind also allows the option /L to list the paths in the PATH variable line by line (and optionally search for a string).

```
C:\> pathfind /L "visual studio"

C:\Program Files\Microsoft Visual Studio 12.0\common7\ide
C:\Program Files\Microsoft Visual Studio 12.0\vc\bin
```
