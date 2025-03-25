import 'dart:io';


int rows = 5;
int columns = 5;
List<List<Map<String, String>?>> seats = [];

void initiaSeats() {
  seats = List.generate(rows, (_) => List.filled(columns, null));
}

void displaySeats() {
  print('\n Theater Seating:');
  print(
      '   ${List.generate(columns, (i) => (i + 1).toString().padLeft(3)).join(' ')}');

  for (int row = 0; row < rows; row++) {
    String rowDisplay = '${String.fromCharCode(65 + row)} ';
    for (int seat = 0; seat < columns; seat++) {
      rowDisplay += seats[row][seat] != null ? '[x]' : '[ ]';
      rowDisplay += ' ';
    }
    print(rowDisplay);
  }
}

void displayBookingInfo() {
  print('\nBooking Details:');
  bool isBooked = false;

  for (int row = 0; row < rows; row++) {
    for (int seat = 0; seat < columns; seat++) {
      final booking = seats[row][seat];
      if (booking != null) {
        isBooked = true;
        String seatNumber = '${String.fromCharCode(65 + row)}${seat + 1}';
        print('Seat $seatNumber:');
        print('  Name: ${booking['name']}');
        print('  Phone: ${booking['phone']}');
        print('-------------------');
      }
    }
  }

  if (!isBooked) {
    print('No seats are currently booked.');
  }
}

bool bookSeat(String seatNumber) {
  try {
    if (seatNumber.isEmpty || seatNumber.length < 2) {
      throw const FormatException();
    }

    int row = seatNumber[0].toUpperCase().codeUnitAt(0) - 65;
    int seat = int.parse(seatNumber.substring(1)) - 1;

    if (row < 0 || row >= rows || seat < 0 || seat >= columns) {
      throw FormatException();
    }

    if (seats[row][seat] != null) {
      print('\nSeat $seatNumber is already booked!');
      return false;
    }

    stdout.write('Enter your name: ');
    String name = stdin.readLineSync()?.trim() ?? '';

    stdout.write('Enter your phone number: ');
    String phone = stdin.readLineSync()?.trim() ?? '';

    if (name.isEmpty || phone.isEmpty) {
      print('\nName and phone number cannot be empty!');
      return false;
    }

    seats[row][seat] = {
      'name': name,
      'phone': phone,
    };

    print('\nSuccessfully booked seat $seatNumber!');
    return true;
  } catch (e) {
    print('\nInvalid seat number. Please use format like "A1" or "B3".');
    return false;
  }
}

void main() {
  initiaSeats();

  print('Welcome to Theater Booking System');

  while (true) {
    print('\nMenu:');
    print('1. View seats');
    print('2. Book a seat');
    print('3. View booking Information');
    print('4. Exit');
    stdout.write('Enter your choice (1-4): ');

    var choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        displaySeats();
        break;
      case '2':
        stdout.write('Enter seat number to book (ex: A 1) : ');
        var seat = stdin.readLineSync()?.trim();
        if (seat != null && seat.isNotEmpty) {
          bookSeat(seat);
        } else {
          print('\nInvalid input. Please try again.');
        }
        break;
      case '3':
        displayBookingInfo();
        break;
      case '4':
        print('\nThank you for using our booking system. Goodbye!');
        return;
      default:
        print('\nInvalid choice. Please enter a number between 1 and 4.');
    }
  }
}
