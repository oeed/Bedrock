Bedrock
=======

This repo contains the development, non-minified code. It it really only for learning from, copying or developing. If you want to use Bedrock in your project all you need to do is add this line of code to the top of your main file, it will download it if needed. If you want to have the API in a different location (for example, in an APIs folder) just change the bedrockPath value. You MUST make sure the name is 'Bedrock' (case sensitive) though.

This does not work yet, I haven't uploaded it to Pastebin.

local bedrockPath='Bedrock' if OneOS then OneOS.LoadAPI('/System/API/Bedrock.lua', false)elseif fs.exists(bedrockPath)then os.loadAPI(bedrockPath)else if http then print('Downloading Bedrock...')local h=http.get('pastebin...')if h then local f=fs.open(bedrockPath,'w')f.write(h.readAll())f.close()h.close()else error('Failed to download Bedrock. Is your internet working?') end else error('This program needs to download Bedrock to work. Please enable HTTP.') end end