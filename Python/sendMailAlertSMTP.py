#!/usr/bin/python3
# Copyright (C) 2015-2022, Wazuh Inc.
# All rights reserved.

# This program, based on the original work by Wazuh Inc.,
# has been modified by Leonit Shabani 2023
# Modifications include sending a custom Email with any smtp, works best if you or your workplace owns one.
# And it solves the token issue of gmail.
# This is a Stateless active response script. 
# Meaning that there's no need for the delete commmand that would undo the script.
# The HTML Email template is completely designed by me.

from __future__ import print_function
import sys
from pathlib import PureWindowsPath, PurePosixPath
import datetime
import json
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os.path
import smtplib

if os.name == 'nt':
    LOG_FILE = "C:\\Program Files (x86)\\ossec-agent\\active-response\\active-responses.log"
else:
    LOG_FILE = "/var/ossec/logs/active-responses.log"

ADD_COMMAND = 0
DELETE_COMMAND = 1
CONTINUE_COMMAND = 2
ABORT_COMMAND = 3

OS_SUCCESS = 0
OS_INVALID = -1


class Message:
    def __init__(self):
        self.alert = ""
        self.command = 0


def write_debug_file(ar_name, msg):
    with open(LOG_FILE, mode="a") as log_file:
        ar_name_posix = str(PurePosixPath(PureWindowsPath(ar_name[ar_name.find("active-response"):])))
        log_file.write(
            str(datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')) + " " + ar_name_posix + ": " + msg + "\n")


def setup_and_check_message(argv):
    # get alert from stdin
    input_str = ""
    for line in sys.stdin:
        input_str = line
        break

    write_debug_file(argv[0], input_str)

    try:
        data = json.loads(input_str)
    except ValueError:
        write_debug_file(argv[0], 'Decoding JSON has failed, invalid input format')
        Message.command = OS_INVALID
        return Message

    Message.alert = data

    command = data.get("command")

    if command == "add":
        Message.command = ADD_COMMAND
    elif command == "delete":
        Message.command = DELETE_COMMAND
    else:
        Message.command = OS_INVALID
        write_debug_file(argv[0], 'Not valid command: ' + command)

    return Message


def send_keys_and_check_message(argv, keys):
    # build and send Message with keys
    keys_msg = json.dumps(
        {"version": 1, "origin": {"name": argv[0], "module": "active-response"}, "command": "check_keys",
         "parameters": {"keys": keys}})

    write_debug_file(argv[0], keys_msg)

    print(keys_msg)
    sys.stdout.flush()

    # read the response of previous Message
    input_str = ""
    while True:
        line = sys.stdin.readline()
        if line:
            input_str = line
            break

    write_debug_file(argv[0], input_str)

    try:
        data = json.loads(input_str)
    except ValueError:
        write_debug_file(argv[0], 'Decoding JSON has failed, invalid input format')
        return Message

    action = data.get("command")

    if "continue" == action:
        ret = CONTINUE_COMMAND
    elif "abort" == action:
        ret = ABORT_COMMAND
    else:
        ret = OS_INVALID
        write_debug_file(argv[0], "Invalid value of 'command'")

    return ret


def setupHTML(msg):
    try:
        computer = msg["data"]["win"]["system"]["computer"]
    except KeyError:
        computer = "Unknown"
    try:
        message = msg["data"]["win"]["system"]["message"]
    except KeyError:
        message = "Unknown"
    try:
        data = msg["data"]["win"]["eventdata"]["data"]
    except KeyError:
        data = "Unknwon"

    html = f''' <link />
         <meta />
         <meta content="width=device-width, initial-scale=1.0" />


         <table width="500" align="center" cellpadding="0" cellspacing="0" style="border-collapse: collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; border: 2px solid #ccc; border-radius: 8px; mso-line-height-rule: exactly;">

           <tr>
             <td style="padding: 16px 32px 0; background-color: #ffffff;">
               <h1 style="margin: 0; font-size: 36px; text-align: center;">
                 <font>Wazuh</font>
               </h1>
               <p style="text-align: left; margin: 16px 0; font-size: 14px; mso-line-height-rule: exactly;">
                 <font>Hello, you've received this email because Wazuh detected a level 12 log. The important part of the log is as follows:</font>
               </p>

               <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse; border: 2px solid #ccc; border-radius: 8px;">
                 <tr style="height: 32px; background-color: #f5f5f5;">
                   <td style="width: 25%; text-align: center; font-weight: bold; border-right: 1px solid #ccc; padding: 8px;">Name</td>
                   <td style="width: 75%; text-align: center; font-weight: bold; padding: 8px;">Detail</td>
                 </tr>

                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Time Stamp</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">{msg["timestamp"]}</td>
                 </tr>
                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Rule</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">Level: {str(msg["rule"]["level"])} | ID: {msg["rule"]["id"][0]} <br> {msg["rule"]["description"]}</td>
                 </tr>
                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Agent</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">Name: {msg["agent"]["name"]} | ID: {msg["agent"]["id"]} | IP: {msg["agent"]["ip"]}</td>
                 </tr>
                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Computer</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">{computer}</td>
                 </tr>
                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Message</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">{message}</td>
                 </tr>
                 <tr style="height: 32px;">
                   <td style="width: 25%; text-align: center; border-right: 1px solid #ccc; padding: 8px;">Event</td>
                   <td style="width: 75%; text-align: left; padding: 8px;">{data}</td>
                 </tr>
               </table>

               <p style="margin-top: 16px; margin-bottom: 32px; text-align: left; font-size: 14px; mso-line-height-rule: exactly;">
                 <font>To view the full log, please log in to the dashboard. We encourage you to take action as fast as possible.</font>
               </p>
             </td>
           </tr>

           <tr>
             <td style="padding: 16px 0; background-color: #f5f5f5; border-radius: 0 0 8px 8px; text-align: center;">
               <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse;">
                 <tr>
                   <td style="font-size: 10px; width: 40%; vertical-align: top; text-align: left; padding-left: 32px;">
                     <font>
                       <p>FIRM NAME</p>
                       <p>ADDRESS</p>
                       <p>EMAIL <br />PHONE NUMBER</p>
                     </font>
                   </td>

                   <td style="width: 40px; text-align: right; padding-right: 10px; vertical-align: middle;">
                     <img width="100" height="60" src="" alt="Your Company Logo" style="display: block;" align="right" />
                   </td>
                   <td style="width: 5px;"></td>

                   <td style="width: 1px; border-left: 1px solid #ccc; padding: 0;"></td>
                   <td style="width: 5px;"></td>

                   <td style="width: 40px; text-align: left; padding-left: 10px; vertical-align: middle;">
                     <img width="85" height="30" src="" alt="Customer Logo" style="display: block;" />
                   </td>
                 </tr>
               </table>
             </td>
           </tr>
         </table>'''
    return html


def sendMail(html):
    sender = 'example@youremail.com'
    receivers = ['example@reciever.com']

    port = 587

    msg = MIMEMultipart(
        "alternative", None, [MIMEText(html, 'html')])

    msg['Subject'] = ''
    msg['From'] = sender
    msg['To'] = receivers[0]

    server = smtplib.SMTP('yoursmtp', port)
    server.starttls()
    server.login('user', 'password')
    text = msg.as_string()
    server.sendmail(sender, receivers, text)
    server.quit()


def main(argv):
    write_debug_file(argv[0], "Started")

    # validate json and get command
    msg = setup_and_check_message(argv)

    if msg.command < 0:
        sys.exit(OS_INVALID)

    if msg.command == ADD_COMMAND:
        """ Start Custom Key """

        alert = msg.alert["parameters"]["alert"]
        keys = [alert["rule"]["id"]]

        """ End Custom Key """

        action = send_keys_and_check_message(argv, keys)

        # if necessary, abort execution
        if action != CONTINUE_COMMAND:

            if action == ABORT_COMMAND:
                write_debug_file(argv[0], "Aborted")
                sys.exit(OS_SUCCESS)
            else:
                write_debug_file(argv[0], "Invalid command")
                sys.exit(OS_INVALID)

        """ Start Custom Action Add """
        html = setupHTML(alert)
        sendMail(html)
        """ End Custom Action Add """
    else:
        write_debug_file(argv[0], "Invalid command")

    write_debug_file(argv[0], "Ended")

    sys.exit(OS_SUCCESS)


if __name__ == "__main__":
    main(sys.argv)
