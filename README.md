Bedrock
=======

This repo contains the development, non-minified code. It it really only for learning from, copying or developing. If you want to use Bedrock in your project all you need to do is add this line of code to the top of your main file, it will download it if needed. If you want to have the API in a different location (for example, in an APIs folder) just change the bedrockPath value. You MUST make sure the name is 'Bedrock' (case sensitive) though.

This does not work yet, I haven't uploaded it to Pastebin. For now, download Build/Bedrock and place it in root.

local bedrockPath='' if OneOS then OneOS.LoadAPI('/System/API/Bedrock.lua', false)elseif fs.exists(bedrockPath)then os.loadAPI(bedrockPath)else if http then print('Downloading Bedrock...')local h=http.get('pastebin...')if h then local f=fs.open(bedrockPath,'w')f.write(h.readAll())f.close()h.close()else error('Failed to download Bedrock. Is your internet working?') end else error('This program needs to download Bedrock to work. Please enable HTTP.') end end

What is Bedrock?
================

Bedrock is an extremely advanced and powerful framework for developing beautiful, easy to use ComputerCraft programs. Not only does it make for a more pleasant experience for the user, by coding programs with Bedrock removes the need for you, the developer, to wrangle with low level aspects of programs. With Bedrock file sizes are also significantly lower than previously due to huge amounts of code, that would have previously made your program huge bigger, being in one central API. A single line of code is all that is needed to download and install Bedrock, and if Bedrock was already installed by another program it will use that version, saving precious disk space.

What are some programs made with Bedrock?
If you made a program with Bedrock let me know, I’ll add you to the list!

- OneOS - OneOS and most of it’s programs were entirely coded using Bedrock. Anything that OneOS does you can do with ease.
- Your next program?