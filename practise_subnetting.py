#!/usr/bin/env python
# Generates a random IPv4 address and a prefix length and asks to compute the information about the subnet,
#   such as subnet ID, broadcast address, range of valid host addresses, number of hosts, and network class.
# The script can be used as a way to practise subnetting.
#
# You can also use the `ipcalc` command-line program to check the answers:
#   import os
#   os.system(f"ipcalc {ip_address}/{prefix_length}")
#
# For the documentation of the ipaddress library, see https://docs.python.org/3/library/ipaddress.html

from ipaddress import IPv4Address, IPv4Network
import random
from termcolor import colored

def get_class(ip_address: IPv4Address) -> str:
    octets = str(ip_address).split(".")
    first_octet = int(octets[0])
    # Technically, 0.0.0.0/8 and 127.0.0.0/8 networks are reserved
    # We include them here just to keep it simple
    if first_octet <= 127:
        return "A"
    elif first_octet <= 191:
        return "B"
    elif first_octet <= 223:
        return "C"
    # Not used in this script 
    elif first_octet <= 239:
        return "D"
    return "E"

def get_color(correct: bool) -> str:
    if correct:
        return "green"
    else:
        return "red"

def check_answer(answer: str, correct_answer: IPv4Address):
    try:
        ip = IPv4Address(answer)
        return ip == correct_answer
    except:
        return False


# INFO: Generate a random IP address
# (In the range from 1.0.0.0 to 223.255.255.255)
ip_address_numeric = random.randint(2**24, 2**31 + 2**30 + 2**29 - 1)
ip_address = IPv4Address(ip_address_numeric)

# INFO: Generate a random prefix length for the subnet mask
if get_class(ip_address) == "A":
    MIN_PREFIX_LENGTH = 8
elif get_class(ip_address) == "B":
    MIN_PREFIX_LENGTH = 16
else:
    MIN_PREFIX_LENGTH = 24
MAX_PREFIX_LENGTH = 30
prefix_length = random.randint(MIN_PREFIX_LENGTH, MAX_PREFIX_LENGTH)

# INFO: Data structure to get the correct answers
net = IPv4Network(f"{ip_address}/{prefix_length}", strict=False)
hosts = list(net.hosts())
host_min = hosts[0]
host_max = hosts[-1]

# INFO: Display the problem
IP_ADDRESS_COLOR="blue"
print(colored(f"{ip_address}/{prefix_length}\n", IP_ADDRESS_COLOR))
answer = input("Do you want to solve the problem yourself? [Y/n] ").upper()

if answer != "Y":
    # INFO: The format is similar to the output of the ipcalc program
    width = len("First host:")  # the length of the longest question
    print("Address:".ljust(width), colored(ip_address, color=IP_ADDRESS_COLOR))
    print("Netmask:".ljust(width), colored(f"{net.netmask} = {net.prefixlen}", color=IP_ADDRESS_COLOR))
    print("Wildcard:".ljust(width), colored(net.hostmask, color=IP_ADDRESS_COLOR))
    print("=>")
    # print("Subnet ID:".ljust(width), colored(net.network_address, color=IP_ADDRESS_COLOR))
    print("Network:".ljust(width), colored(net.with_prefixlen, color=IP_ADDRESS_COLOR))
    print("First host:".ljust(width), colored(host_min, color=IP_ADDRESS_COLOR))
    print("Last host:".ljust(width), colored(host_max, color=IP_ADDRESS_COLOR))
    print("Broadcast:".ljust(width), colored(net.broadcast_address, color=IP_ADDRESS_COLOR))
    print("Hosts/net:".ljust(width), colored(net.num_addresses - 2, color=IP_ADDRESS_COLOR))
    print("Net class: ".ljust(width), colored(f"Class {get_class(ip_address)}", color="magenta"))
    exit()

# INFO: The questions and the expected (correct) answers
questions = ["Address", "Netmask", "Wildcard", "Subnet ID", "First host", "Last host", "Broadcast", "Hosts/net", "Net class"]
types = [IPv4Address, IPv4Address, IPv4Address, IPv4Address, IPv4Address, IPv4Address, IPv4Address, int, str]
expected = [ip_address, net.netmask, net.hostmask, net.network_address, host_min, host_max, net.broadcast_address, net.num_addresses - 2, get_class(ip_address)]
question_width = max(len(q) for q in questions) + 2  # include ": "

# INFO: Display the questions and ask for the answers
answers = []
for q in questions:
    answer = input(f"{q}:".ljust(question_width))
    answers.append(answer)

# INFO: Check the provided answers
print("\nCorrect answers:")
for i in range(len(questions)):
    if types[i] == IPv4Address:
        color = get_color(check_answer(answers[i], expected[i]))
    elif types[i] == int:
        color = get_color(answers[i] == str(expected[i]))
    else:
        color = get_color(answers[i] == expected[i]) 
    print(f"{questions[i]}:".ljust(question_width), colored(expected[i], color=color), sep='')
