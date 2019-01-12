import multiprocessing
from sendmail import sendmail
from generatelights import showimage, ingestvideo, showvideo
from playsound import playsound

def getcredentials(file):
    with open(file, 'r') as file:
        username = file.readline()[:-1]
        password=file.readline()
    return [username, password]

to_list=['luisverges@gmail.com','perseofliesagain@gmail.com'] ######LIST
output_file='output\\mail_status.txt'

#Obtain current day
with open('day.txt', 'r') as file:
    lines = file.readlines()
    day = lines[0][:-1]

html_file=open('mails\\'+day+'.html', 'r', encoding='utf-8')
html=html_file.read() #path of the html file to send

if day=='Day 0' or day=='Termination':
    credentials= getcredentials('credentials\\deepsound.txt')
    sendmail(html, credentials, to_list, 'Deepsound News', output_file)
    
elif day=='Day 7':
    credentials= getcredentials('credentials\\diana.txt')
    sendmail(html, credentials, to_list, 'Diana\'s SOTD', output_file)
    video = ingestvideo('animation\\Frames')
    if __name__ == '__main__':
            
        sound = multiprocessing.Process(name='sound', target=playsound, args=('music\\Brian Eno The Big Ship.mp3',))
        images = multiprocessing.Process(name='images', target=showvideo, args=(video,))

        sound.start()
        images.start()
else:
    credentials= getcredentials('credentials\\diana.txt')
    sendmail(html, credentials, to_list, 'Diana\'s SOTD', output_file)
   #### showimage('img\\'+day+'.png') 

#Delete day from the file, so next time the program is executed, next day gets read
with open("day.txt", "w") as file:
    for pos, line in enumerate(lines):
        if pos != 0:
            file.write(line)
