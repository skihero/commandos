"""  
Create a image with the input text, 
attempt at trying to create images of texts for use 
in small screen devices
""" 

import Image, ImageDraw, ImageFont

i = Image.new("RGB", (480,272))   #PSP screen size 320 240 
d = ImageDraw.Draw(i)

# Select a desired font 
f = ImageFont.truetype("/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf", 12)

d.text((1,1), """hello world """, font=f) 
d.text((1,5), "", font = f) 

d.text((1,14), """hello world gwget: ideas""", font=f)
 
i.save(open("helloworld.png", "wb"), "PNG")
