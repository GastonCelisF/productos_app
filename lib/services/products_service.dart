import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-productos-app-11884-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  Product? selectedProduct;

  bool isLoading = true;
  bool isSaving = false;
  // CONSTRUCTOR
  ProductsService() {
    this.LoadProducts();
  }

  Future<List<Product>> LoadProducts() async {
    this.isLoading = true;
    notifyListeners();

    // PETICION DEL ENDPOINT GET LISTA PRODUCTOS
    final url = Uri.https(_baseUrl, 'products.json');
    // respuesta del endpoint...
    final resp = await http.get(url);
    // obtiene el mapa de la respuesta..
    final Map<String, dynamic> productMap = json.decode(resp.body);

    // ya recibido el dinamic como un map se parsean  a la lista para mejor visualizacion y manejo de la informaicon..
    // parseando cada una de las llaves (en este caso los productos).

    productMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();

    return this.products;
  }

  Future saveOrCreateProduct(Product productoaGuardar) async {
    isSaving = true;
    notifyListeners();

    if (productoaGuardar.id == null) {
      // Es necesario crear
    } else {
      // Actualiza
      await this.updateProduct(productoaGuardar);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    //endpoint al cual apuntamos..
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    //peticion , junto con su body
    final resp = await http.put(url, body: product.toRawJson());
    final decodedData = resp.body;
    //print(decodedData);

  
    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;


    return product.id!;
  }
}
