import random

BALANCE = 0
DEPOSITED = 0

MAX_LINES = 5
MAX_BET = 100
MIN_BET = 1

ROWS = 3
COLS = 3
slot_count = {"7": 3, "HIGH": 6, "BAR": 9, "LOW": 12}

def get_num_of_lines():
    while True:
        lines = input("Enter the amount of lines to bet on (1-" + str(MAX_LINES) +"): ")
        if lines.isdigit():
            lines = int(lines)
            if lines < MAX_LINES and lines >= 1:
                break
            else:
                print("Line amount must be greater than 0!")
        else:
            print("Enter a number!")
            
    return lines

def get_bet():
    while True:
        betAmt = input("Enter bet per-line amount: $")
        if betAmt.isdigit():
            betAmt = int(betAmt)
            if betAmt >= MIN_BET and betAmt <= MAX_BET:
                break
            else:
                print(f"Bet amount must be between ${MIN_BET} and ${MAX_BET}")
        else:
            print("Enter an amount!")
            
    return betAmt

def deposit():
    print(f"Your current balance is ${BALANCE}. How much money would you like to deposit?\n")
    depositAmount = input("Deposit amount: $")
    if depositAmount.isdigit():
        depositAmount = int(depositAmount)
        if depositAmount > BALANCE:
            print("You do not have enough money to deposit that amount!")
            return
        else:
            BALANCE -= depositAmount
            DEPOSITED += depositAmount
            print(f"You have deposited ${depositAmount} successfully!\nYour new deposited balance is: ${DEPOSITED} and your remaining money is ${BALANCE}")
    return depositAmount
        
def withdraw():
    print(f"Your current scored balance is: ${DEPOSITED}. How much money would you like to withdraw?\n")
    withdrawAmount = input("Withdraw amount: $")
    if withdrawAmount.isdigit():
        int(withdrawAmount)
        if withdrawAmount > DEPOSITED:
            print("You do not have that much money deposited!")
            return
        else:
            DEPOSITED -= withdrawAmount
            BALANCE += withdrawAmount
            print(f"You have withdrawn ${withdrawAmount} successfully!\nYour new balance is: ${BALANCE} and your remaining deposited balance is ${DEPOSITED}")
    return withdrawAmount
            
def gamblingRNG(rows, cols, slots):
    all_slots = []
    for slot, slot_count in slots.items():
        for _ in range(slot_count):
            all_slots.append(slot)
            
    columns = [[], [], []]
    for col in range(cols):
        column = []
        for row in range(rows):
            value = random.choice(all_slots)
        
    
def game():
    # STARTING BALANCE #
    BALANCE += 10
    DEPOSITED += 10
    ####################
    print("Welcome to gambling simulator 9000!\n")
    print(f"Your current balance is: ${BALANCE} and your deposited balance is {DEPOSITED}\n")
    print("-== Menu ==-\n1) Roll the slots\n2) Deposit money\n3) Withdraw money")
    choice = int(input("Enter your choice: "))
    
    if choice == 1:
        while True:
            bet = get_bet
            lines = get_num_of_lines
            total_bet = bet * lines
            print(f"You are currently betting ${bet} on {lines} lines. Total bet: ${total_bet}")
            
            if total_bet > BALANCE:
                print("You do not have enough money to bet that amount!")
            else:
                break
    
    elif choice == 2:
        while True:
            deposit()
            break
        
    elif choice == 3:
        while True:
            withdraw()
            break
            