import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import time


def sendmailraw(html_text,credentials,to_list,subject,output_file=None):
    wait_time = 15
    host = "smtp.gmail.com"
    port = 587
    username = credentials[0]
    password = credentials[1]

    from_email = username
    for attempts in range(5):
        
        email_conn = smtplib.SMTP(host, port)
        email_conn.ehlo()
        email_conn.starttls()
        email_conn.login(username, password)

        the_msg = MIMEMultipart("alternative")
        the_msg['Subject'] = subject
        the_msg['To'] = to_list

        part_2 = MIMEText(html_text, 'html')
        the_msg.attach(part_2)

        email_conn.sendmail(from_email,to_list,the_msg.as_string())

        if output_file!=None:
            with open(output_file, 'a') as file:
                file.write('Email sent succesfully!\n')
            return
