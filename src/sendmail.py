import time
import smtplib
import datetime
from os.path import basename
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication




def sendmail(html_text,credentials,to_list,subject,output_file=None, files=None):
    wait_time = 15
    host = "smtp.gmail.com"
    port = 587
    username = credentials[0]
    password = credentials[1]

    from_email = username
    for attempts in range(5):
        try:
            email_conn = smtplib.SMTP(host, port)
            email_conn.ehlo()
            email_conn.starttls()
            email_conn.login(username, password)

            the_msg = MIMEMultipart("alternative")
            the_msg['Subject'] = subject
            the_msg['To'] = ', '.join(to_list)

            html = MIMEText(html_text, 'html')
            the_msg.attach(html)

            if files!=None:
                for f in files:
                    print(f)
                    with open(f, "rb") as fil:
                        part = MIMEApplication(fil.read(),Name=basename(f))

                part['Content-Disposition'] = 'attachment; filename="%s"' % basename(f)
                the_msg.attach(part)
            
            email_conn.sendmail(from_email,to_list,the_msg.as_string())

            if output_file!=None:
                now=datetime.datetime.now()
                with open(output_file, 'a') as file:
                    file.write('Email sent succesfully on '+'{0} {1}, at {2:02}:{3:02}:{4:02}'.format(now.strftime("%A"), now.day, now.hour, now.minute, now.second)+'!\n')
                return
        except Exception as inst:
            if output_file!=None:
                now=datetime.datetime.now()
                with open(output_file, 'a') as file:
                    file.write('Failed attempt on '+'{0} {1}, at {2:02}:{3:02}:{4:02}'.format(now.strftime("%A"), now.day, now.hour, now.minute, now.second)+': '+str(inst)+'\n')
                time.sleep(wait_time)
                wait_time+=15

