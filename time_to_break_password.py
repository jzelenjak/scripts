#!/usr/bin/env python
# Computes the (worst-case) time to brute-force a password, depending on various parameters, such as:
#  - The number of machines used to brute-force the password
#  - The number of tested passwords per second
#  - The length of the password
#  - The size of the used character set when creating the password

def parse_input(provided_input: str) -> int:
    try:
        num = int(provided_input)
        if num <= 0:
            print("The value must be non-negative")
            exit(1)
        return num
    except ValueError:
        print("Invalid input")
        exit(1)


num_machines = parse_input(input("How many machines try to break the password: "))
passwords_per_second = parse_input(input("How many passwords are tried per second: "))
password_length = parse_input(input("What is the length of the password: "))

print("Assuming at most 95 printable ASCII characters can be used to create a password, i.e.")
print(" - 26 uppercase letters (A-Z)")
print(" - 26 lowercase letters (a-z)")
print(" - 10 digits (0-9)")
print(" - 33 punctuation marks and symbols")
num_diff_chars = parse_input(input("What is the size of the used character set: "))

password_space = num_diff_chars**password_length
total_passwords_per_second = num_machines * passwords_per_second

time_in_seconds = password_space / total_passwords_per_second
time_in_minutes = time_in_seconds / 60
time_in_hours = time_in_minutes / 60
time_in_days = time_in_hours / 24
time_in_years = time_in_days / 365

print("\nIn the worst-case scenario, the time to brute-force the password is:")
if int(time_in_years) > 0:
    print(f" - {round(time_in_years, 2)} years")
if int(time_in_days) > 0:
    print(f" - {round(time_in_days, 2)} days")
if int(time_in_hours) > 0:
    print(f" - {round(time_in_hours, 2)} hours")
if int(time_in_minutes) > 0:
    print(f" - {round(time_in_minutes, 2)} minutes")
print(f" - {round(time_in_seconds, 2)} seconds")
