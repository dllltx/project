products = {
    "keyboard": 2500,
    "mouse": 1500,
    "headphones": 5000,
    "usb_cable": 800
}

def calculate_item_price(price, quantity):
    total = price * quantity
    return total

def calculate_order(items):
    total = 0

    for item in items:
        name = item["name"]
        quantity = item["quantity"]

        price = products[name]
        item_total = calculate_item_price(price, quantity)

        total += item_total

    return total

def print_order(items):
    total = calculate_order(items)

    print("Заказ:")

    for item in items:
        print(f'{item["name"]}: {item["quantity"]} шт.')

    print(f"Итого: {total} руб.")

order = [
    {"name": "keyboard", "quantity": 2},
    {"name": "usb_cable", "quantity": 3},
    {"name": "mouse", "quantity": 1}
]

print_order(order)