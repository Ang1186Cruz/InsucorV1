import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final int idPedidP;
  final String id;
  final String title;
  int quantity;
  final double price;
  final double? priceRequested;
  String? descripcion;
  bool todo;
  String motivo;
  int? cantidadPreparada;
  bool controlado;
  bool preparado;
  bool retiroDespacho;
  bool camaraFriogorifico;
  TextEditingController? inputCantidadPrepa; //= TextEditingController();

  CartItem(
      {this.idPedidP = 0,
      required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      this.priceRequested,
      this.descripcion,
      this.todo = false,
      this.motivo = 'completo',
      this.cantidadPreparada,
      this.controlado = false,
      this.preparado = false,
      this.retiroDespacho = false,
      this.camaraFriogorifico = false,
      this.inputCantidadPrepa});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
        (key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  void addItem(String productId, double price, String title, String quantity,
      String priceRequested, int? idpedidoP) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: int.parse(quantity),
                priceRequested: double.parse(priceRequested),
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                title: title,
                price: price,
                quantity: int.parse(quantity),
                priceRequested: double.parse(priceRequested),
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if ((_items[productId]?.quantity ?? 0) > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void addCart(List<CartItem> _items) {
    _items.forEach((item) {
      addItem(item.id, item.price, item.title, item.quantity.toString(),
          item.priceRequested.toString(), item.idPedidP);
    });
  }
}
