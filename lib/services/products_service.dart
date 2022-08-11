



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier{

  
  final String _baseUrl = 'flutter-varios-34ce6-default-rtdb.firebaseio.com';

  // Lista donde de todos los productos que se encuentran en mi services.
  final List<Product> products = [];
  late Product selectedProduct;
  // prop para saber cuando estoy cargando y cuando no
  bool isLoading = true;

  ProductsService(){
  this.loadProducts();
  }

  
  Future<List<Product>> loadProducts()async{


    this.isLoading = true;
    notifyListeners();
    
    final url = Uri.https(_baseUrl,'Products.json');
    final resp = await http.get(url);
    //la respuesta del body esta como string
    //hay que parsearlo como si fuera un json
    final Map<String,dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key,value) { 
       final tempProduct = Product.fromMap(value);
       tempProduct.id = key;
       //añadimos el producto como un add ya que lo tengo como final.
       this.products.add(tempProduct);
    });


    this.isLoading = false;
    notifyListeners();

    return this.products;

  }


}