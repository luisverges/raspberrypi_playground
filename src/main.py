import multiprocessing
from sendmail import sendmail
from generatelights import showimage, ingestvideo, showvideo
from playsound import playsound
import os

def getcredentials(file):
    with open(file, 'r') as file:
        username = file.readline()[:-1]
        password=file.readline()
    return [username, password]

to_list=['luisverges@gmail.com','perseofliesagain@gmail.com'] ######LIST
output_file=os.path.join('output','mail_status.txt')

#Obtain current day
with open('day.txt', 'r') as file:
    lines = file.readlines()
    day = lines[0][:-1]

html_file=open(os.path.join('mails',day+'.html'), 'r', encoding='utf-8'))
html=html_file.read()
html_file.close()

if day=='Day 0' or day=='Termination':
    credentials= getcredentials(os.path.join('credentials','deepsound.txt'))
    sendmail(html, credentials, to_list, 'Deepsound News', output_file)
    
elif day=='Day 7':
    credentials= getcredentials(os.path.join('credentials','diana.txt'))
    sendmail(html, credentials, to_list, 'Diana\'s SOTD', output_file)
    video = ingestvideo(os.path.join('animation','Frames'))
    music_path=os.path.join('music', 'Brian Eno The Big Ship.mp3')
    if __name__ == '__main__':
            
        sound = multiprocessing.Process(name='sound', target=playsound, args=(music_path,))
        images = multiprocessing.Process(name='images', target=showvideo, args=(video,))

        sound.start()
        images.start()
else:
    credentials= getcredentials(os.path.join('credentials','diana.txt'))
    sendmail(html, credentials, to_list, 'Diana\'s SOTD', output_file)
    showimage(os.path.join('img',day+'.png'))

#Delete day from the file, so next time the program is executed, next day gets read
with open("day.txt", "w") as file:
    for pos, line in enumerate(lines):
        if pos != 0:
            file.write(line)
