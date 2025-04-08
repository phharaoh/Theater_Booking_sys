import 'dart:io';
// ignore_for_file: avoid_print

class Product {
  String name;
  double _price;
  int _quantity;

  Product(this.name, double price, int quantity)
      : _price = price,
        _quantity = quantity;

  double get price => _price;

  set price(double value) {
    if (value >= 0) {
      _price = value;
    } else {
      print('Price cannot be negative.');
    }
  }

  int get quantity => _quantity;

  set quantity(int value) {
    if (value >= 0) {
      _quantity = value;
    } else {
      print('Quantity cannot be negative.');
    }
  }

  @override
  String toString() {
    return 'Product: $name, Price: \$${_price.toStringAsFixed(2)}, Quantity: $_quantity';
  }
}

class Category {
  String name;
  List<Product> products = [];

  Category(this.name);

  void addProduct(String name, double price, int quantity) {
    products.add(Product(name, price, quantity));
    print('Product "$name" added to category "$this.name"');
  }

  void editProduct(int index, {String? name, double? price, int? quantity}) {
    if (index >= 0 && index < products.length) {
      Product product = products[index];
      product.name = name ?? product.name;
      product.price = price ?? product.price;
      product.quantity = quantity ?? product.quantity;
      print('Product updated: ${products[index]}');
    } else {
      print('Invalid product index');
    }
  }

  void displayProducts() {
    if (products.isEmpty) {
      print('No products in this category');
    } else {
      print('Products in category "$name":');
      for (int i = 0; i < products.length; i++) {
        print('$i. ${products[i]}');
      }
    }
  }
}

class ECommerce {
  String name;
  List<Category> categories = [];

  ECommerce(this.name);

  void buyProduct(int categoryIndex, int productIndex, int quantity) {
    if (categoryIndex >= 0 && categoryIndex < categories.length) {
      Category category = categories[categoryIndex];
      if (productIndex >= 0 && productIndex < category.products.length) {
        Product product = category.products[productIndex];
        if (product.quantity >= quantity) {
          product.quantity -= quantity;
          print(
              'Successfully bought $quantity of ${product.name}. Remaining: ${product.quantity}');
        } else {
          print('Not enough stock. Available: ${product.quantity}');
        }
      } else {
        print('Invalid product index');
      }
    } else {
      print('Invalid category index');
    }
  }

  void sellProduct(int categoryIndex, int productIndex, int quantity) {
    if (categoryIndex >= 0 && categoryIndex < categories.length) {
      Category category = categories[categoryIndex];
      if (productIndex >= 0 && productIndex < category.products.length) {
        Product product = category.products[productIndex];
        product.quantity += quantity;
        print(
            'Successfully restocked $quantity of ${product.name}. New quantity: ${product.quantity}');
      } else {
        print('Invalid product index');
      }
    } else {
      print('Invalid category index');
    }
  }

  void displayMenu() {
    print('\n=== $name E-Commerce System ===');
    print('1. Show all categories and products');
    print('2. Add a new product');
    print('3. Buy a product');
    print('4. Sell/Restock a product');
    print('5. Edit a product');
    print('6. Exit');
    print('==============================');
  }

  void run() {
    bool running = true;

    while (running) {
      displayMenu();
      stdout.write('Enter your choice (1-6): ');
      var input = stdin.readLineSync();

      try {
        int choice = int.parse(input!);

        switch (choice) {
          case 1:
            showAllProducts();
            break;
          case 2:
            addProductMenu();
            break;
          case 3:
            buyProductMenu();
            break;
          case 4:
            sellProductMenu();
            break;
          case 5:
            editProductMenu();
            break;
          case 6:
            running = false;
            print('Thank you for using $name E-Commerce System!');
            break;
          default:
            print('Invalid choice. Please enter a number between 1 and 6.');
        }
      } catch (e) {
        print('Invalid input. Please enter a number.');
      }
    }
  }

  void showAllProducts() {
    if (categories.isEmpty) {
      print('No categories available.');
    } else {
      for (int i = 0; i < categories.length; i++) {
        print('\nCategory ${i + 1}: ${categories[i].name}');
        categories[i].displayProducts();
      }
    }
  }

  void addProductMenu() {
    if (categories.isEmpty) {
      print('No categories available. Please create a category first.');
      return;
    }

    showAllProducts();
    stdout.write('Enter category number to add product to: ');
    int catIndex = int.parse(stdin.readLineSync()!) - 1;

    if (catIndex >= 0 && catIndex < categories.length) {
      stdout.write('Enter product name: ');
      String name = stdin.readLineSync()!;

      stdout.write('Enter product price: ');
      double price = double.parse(stdin.readLineSync()!);

      stdout.write('Enter product quantity: ');
      int quantity = int.parse(stdin.readLineSync()!);

      categories[catIndex].addProduct(name, price, quantity);
    } else {
      print('Invalid category number.');
    }
  }

  void buyProductMenu() {
    showAllProducts();
    if (categories.isEmpty) return;

    stdout.write('Enter category number: ');
    int catIndex = int.parse(stdin.readLineSync()!) - 1;

    if (catIndex >= 0 && catIndex < categories.length) {
      if (categories[catIndex].products.isEmpty) {
        print('No products in this category.');
        return;
      }

      stdout.write('Enter product number: ');
      int prodIndex = int.parse(stdin.readLineSync()!) - 1;

      stdout.write('Enter quantity to buy: ');
      int quantity = int.parse(stdin.readLineSync()!);

      buyProduct(catIndex, prodIndex, quantity);
    } else {
      print('Invalid category number.');
    }
  }

  void sellProductMenu() {
    showAllProducts();
    if (categories.isEmpty) return;

    stdout.write('Enter category number: ');
    int catIndex = int.parse(stdin.readLineSync()!) - 1;

    if (catIndex >= 0 && catIndex < categories.length) {
      if (categories[catIndex].products.isEmpty) {
        print('No products in this category.');
        return;
      }

      stdout.write('Enter product number: ');
      int prodIndex = int.parse(stdin.readLineSync()!) - 1;

      stdout.write('Enter quantity to sell/restock: ');
      int quantity = int.parse(stdin.readLineSync()!);

      sellProduct(catIndex, prodIndex, quantity);
    } else {
      print('Invalid category number.');
    }
  }

  void editProductMenu() {
    showAllProducts();
    if (categories.isEmpty) return;

    stdout.write('Enter category number: ');
    int catIndex = int.parse(stdin.readLineSync()!) - 1;

    if (catIndex >= 0 && catIndex < categories.length) {
      if (categories[catIndex].products.isEmpty) {
        print('No products in this category.');
        return;
      }

      stdout.write('Enter product number to edit: ');
      int prodIndex = int.parse(stdin.readLineSync()!) - 1;

      if (prodIndex >= 0 && prodIndex < categories[catIndex].products.length) {
        Product product = categories[catIndex].products[prodIndex];
        print('Current product details: $product');

        stdout.write('Enter new name (leave blank to keep current): ');
        String nameInput = stdin.readLineSync()!;
        String? name = nameInput.isEmpty ? null : nameInput;

        stdout.write('Enter new price (leave blank to keep current): ');
        String priceInput = stdin.readLineSync()!;
        double? price = priceInput.isEmpty ? null : double.parse(priceInput);

        stdout.write('Enter new quantity (leave blank to keep current): ');
        String quantityInput = stdin.readLineSync()!;
        int? quantity = quantityInput.isEmpty ? null : int.parse(quantityInput);

        categories[catIndex].editProduct(prodIndex,
            name: name, price: price, quantity: quantity);
      } else {
        print('Invalid product number.');
      }
    } else {
      print('Invalid category number.');
    }
  }
}

void main() {
  var myStore = ECommerce('MyShop');

  myStore.categories.add(Category('Electronics'));
  myStore.categories.add(Category('Clothing'));

  myStore.categories[0].addProduct('Laptop', 999.99, 10);
  myStore.categories[0].addProduct('Smartphone', 699.99, 15);
  myStore.categories[1].addProduct('T-Shirt', 19.99, 50);
  myStore.categories[1].addProduct('Jeans', 49.99, 30);

  myStore.run();
}
