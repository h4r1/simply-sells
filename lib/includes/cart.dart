class CItem {
  int id = 0;
  String nama = '';
  int harga = 0;
}

class ShoppingCart {
  static String nama = "My Shopping Cart";
  static DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static List<CItem> itemData = [];
  static List<int> itemQty = [];
  static dynamic custID;
  static dynamic grandTotal;
  static dynamic qtyTotal;

  static save() {
    print("Save invoice to database...");
  }

  static clearCart() {
    date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    custID = null;
    itemData.clear();
  }

  static setPrice(idx, newPrice) {
    itemData[idx].harga = newPrice;
  }

  static itemAdd(itemRec) {
    CItem newItem = CItem();
    newItem.id = itemRec.id;
    newItem.nama = itemRec.nama;
    newItem.harga = itemRec.harga;
    itemData.add(newItem);
    itemQty.add(1); // default value
  }

  static calculate() {
    grandTotal = 0;
    qtyTotal = 0;
    for (var i = 0; i < itemData.length; i++) {
      grandTotal = grandTotal + (itemQty[i] * itemData[i].harga);
      qtyTotal += itemQty[i];
    }
  }

  static printName() {
    print("Hello ${ShoppingCart.nama}");
  }
}
