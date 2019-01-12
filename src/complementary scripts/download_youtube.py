#pip install pytube
from pytube import YouTube
import os

yt = YouTube('https://www.youtube.com/watch?v=lCCJc_V8_MQ')
streams = yt.streams.filter(only_audio=True).all()
print(streams)

os.mkdir("music")
os.chdir("music")

yt.streams.get_by_itag(140).download()
