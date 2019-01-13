import os
#Reset pending days file
with open('day.txt','w+') as file:
    file.write('Day 0\nDay 1\nDay 2\nDay 3\nDay 4\nDay 5\nDay 6\nDay 7\nTermination\n')
#Reset mail status file
with open(os.path.join('output','mail_status.txt'), 'w+') as file:
    pass
