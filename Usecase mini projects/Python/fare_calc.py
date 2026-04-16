vehicle_rates = {
    'Economy': 10,
    'Premium': 18,
    'SUV': 25
}

surge_multiplier = 1.5
surge_start_hour = 17
surge_end_hour = 20


def calculate_fare(km, vehicle_type, hour):
    if vehicle_type not in vehicle_rates:
        return None

    rate = vehicle_rates[vehicle_type]
    base_fare = km * rate
    is_surge = surge_start_hour <= hour <= surge_end_hour

    if is_surge:
        multiplier = surge_multiplier
    else:
        multiplier = 1.0
    final_fare = base_fare * multiplier

    return {
        "base_fare": base_fare,
        "surge_applied": is_surge,
        "multiplier": multiplier,
        "final_fare": final_fare
    }


def print_receipt(km, vehicle_type, hour, result):
    width = 42
    line = "-" * width

    print(f"\n{line}")
    print(f"{'CityCab - Price Receipt':^{width}}")
    print(line)
    print(f"  {'Vehicle Type':<20} {vehicle_type}")
    print(f"  {'Distance':<20} {km:.1f} km")
    print(f"  {'Hour of Travel':<20} {hour:02d}:00")
    print(f"  {'Rate per km':<20} Rs.{vehicle_rates[vehicle_type]}")
    print(f"  {'Base Fare':<20} Rs.{result['base_fare']:.2f}")

    if result["surge_applied"]:
        print(f"  {'Surge Pricing':<20} x{result['multiplier']}  (5 PM - 8 PM)")
    else:
        print(f"  {'Surge Pricing':<20} None")

    print(line)
    print(f"  {'TOTAL ESTIMATE':<20} Rs.{result['final_fare']:.2f}")
    print(f"{line}\n")


def main():
    print("Welcome to CityCab FareCalc")

    while True:
        try:
            km = float(input("Enter distance in km: "))
            if km <= 0:
                raise ValueError
            break
        except ValueError:
            print("Please enter a positive number for distance.\n")

    print(f"Available vehicle types: {', '.join(vehicle_rates.keys())}")
    vehicle_type = input("Enter vehicle type: ").strip()

    vehicle_type_map = {}
    for k in vehicle_rates:
        vehicle_type_map[k.lower()] = k

    vehicle_type = vehicle_type_map.get(vehicle_type.lower(), vehicle_type)

    while True:
        try:
            hour = int(input("Enter hour of travel (0-23): "))
            if not (0 <= hour <= 23):
                raise ValueError
            break
        except ValueError:
            print("Please enter a whole number between 0 and 23.\n")

    result = calculate_fare(km, vehicle_type, hour)

    if result is None:
        print(f"\nService Not Available.")
        print(f"'{vehicle_type}' is not a recognised vehicle type.")
        print(f"Please choose from: {', '.join(vehicle_rates.keys())}.\n")
    else:
        print_receipt(km, vehicle_type, hour, result)


if __name__ == "__main__":
    main()
