import os
#Reset pending days file
with open('day.txt','w+') as file:
    file.write('Day 0\nMonday\nTuesday\nWednesday\nThursday\nFriday\nSaturday\nSunday\nTermination\n')
#Reset mail status file
with open(os.path.join('output','mail_status.txt'), 'w+') as file:
    pass
