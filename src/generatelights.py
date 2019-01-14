from PIL import Image, ImageDraw
from sense_hat import SenseHat
import random
import os
import time

height = 300
width = 300

#Creating the pattern of colors

def generateimage(color="all"):
    image = Image.new(mode='RGB', size=(height, width), color="white")
    draw = ImageDraw.Draw(image)
    points = [0,0,37.5,37.5]
    x = 0
    y = 0
    lights = []
    maxred = 255
    maxgreen = 255
    maxblue = 255
    
    if color=="blue":
        maxred = 0
        maxgreen = 70
    elif color=="red":
        maxgreen = 0
        maxblue = 70
    elif color=="green":
        maxblue = 0
        maxred = 70
        
    for columns in range(8):
        for rows in range(8):
                
            if random.randint(0,1)==1:
                r = random.randint(0,maxred)
                g = random.randint(0,maxgreen)
                b = random.randint(0,maxblue)
                draw.rectangle(points, fill=(r,g,b), outline=None)
            else:
                r = 0
                g = 0
                b = 0
            points[0] += 37.5
            points[2] += 37.5
            pixel = [x,y,r,g,b]
            lights.append(pixel)
            x += 1
        x = 0
        points[0] = 0
        points[2] = 37.5
        points[1] += 37.5
        points[3] += 37.5
        y += 1
    image.save("img/dianapattern.png")
def ingestimage(path):
    image = []
    im = Image.open(path)
    pix = im.load()
    x =18.75
    y = 18.75
    rgb = lambda x : (x[0],x[1],x[2])
    for columns in range(8):
        for rows in range(8):
            if rgb(pix[x,y])==(255,255,255):
                image.append((0,0,0))
            else:
                image.append(rgb(pix[x,y]))
            x += 37.5
        x = 18.75
        y += 37.5
    im.close()
    return image

def showimage(path): #Showing an image on the sensehat
    image = ingestimage(path)
    sense = SenseHat()
    sense.set_pixels(image) 
    time.sleep(60)
    sense.clear() 

def ingestvideo(folder):#'animation\\Frames'

    images = sorted(list(os.walk(folder))[0][2])
    video = []
    for image in images:
        video.append(ingestimage(os.path.join(folder,image)))
    return video

def showvideo(video): #Showing the video on the sensehat
    sense = SenseHat()
    for frame in video:
        sense.set_pixels(frame) #Showing a single frame on the sensehat
        time.sleep(.142857)
    sense.clear() 



