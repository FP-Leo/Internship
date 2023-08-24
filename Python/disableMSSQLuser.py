#!/usr/bin/python3
# Copyright (C) 2015-2022, Wazuh Inc.
# All rights reserved.

# This program, based on the original work by Wazuh Inc.,
# has been modified by Leonit Shabani 2023
# Modifications include getting the username of the user that failed to log in to MSSQL from the logs.
# Executing a cmd command that disables that said user
# This is a Stateless active response script. 
# Meaning that there's no need for the delete commmand that would undo the script.
# But you can turn this into a Stateful active response by adding the delete command that would execute a cmd command that would enable the user.

import sys
import os
from pathlib import PureWindowsPath, PurePosixPath
import datetime
import json
import re

if os.name == 'nt':
    LOG_FILE = "C:\\Program Files (x86)\\ossec-agent\\active-response\\active-responses.log"
else:
    LOG_FILE = "/var/ossec/logs/active-responses.log"

ADD_COMMAND = 0
#DELETE_COMMAND = 1
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
    # elif command == "delete":
       # message.command = DELETE_COMMAND
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


def main(argv):
    write_debug_file(argv[0], "Started")
    # validate json and get command
    msg = setup_and_check_message(argv)

    if msg.command < 0:
        sys.exit(OS_INVALID)

    if msg.command == ADD_COMMAND:

        """ Start Custom Key
        At this point, it is necessary to select the keys from the alert and add them into the keys array.
        """

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
        #Get MSSQL user from the log
        msg = alert["data"]["win"]["system"]["message"]
        pattern = "'(.*?)'"
        # Extracting the word inside single quotes
        match = re.search(pattern, msg)
        if match:
            user = match.group(1)
            parameter = "\"ALTER LOGIN " + user + " DISABLE\""
            #use the account that manages the other accounts to disable the user
            ip = ""
            port = ""
            accountUsername = ""
            password = ""
            cmdpart = f"sqlcmd -S tcp:{ip},{port} -U {accountUsername} -P {password} -q " + parameter
            totalCommand = 'cmd /c ' + cmdpart
            #execute the cmd command to disable the user
            os.system(totalCommand)

        """ End Custom Action Add """
    # elif msg.command == DELETE_COMMAND:
        # to turn it into a stateful ar script
    else:
        write_debug_file(argv[0], "Invalid command")

    write_debug_file(argv[0], "Ended")

    sys.exit(OS_SUCCESS)


if __name__ == "__main__":
    main(sys.argv)
