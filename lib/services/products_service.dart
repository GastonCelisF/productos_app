import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-productos-app-11884-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  Product? selectedProduct;
  File? newPictureFile;

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

      await this.createProduct(productoaGuardar);
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


  Future<String> createProduct(Product product) async {
    //endpoint al cual apuntamos..
    final url = Uri.https(_baseUrl, 'products.json');
    //peticion , junto con su body
    final resp = await http.post(url, body: product.toRawJson());

    //el decode en este caso es el id que firebase genera automaticamente..
    final decodedData = json.decode(resp.body);
    
    product.id = decodedData['name'];


    this.products.add(product);

    //return product.id!;

    return '';
  }


void updateSelectedProducImage(String path){
  this.selectedProduct?.picture  = path; 
  this.newPictureFile = File.fromUri(Uri(path: path));

 notifyListeners();
}


Future<String?> uploadImage() async{
//nos aseguramos de tener una imagen antes de hacer la peticion http
  if(this.newPictureFile ==null) return null;

this.isSaving = true;
notifyListeners();

final url = Uri.parse('https://api.cloudinary.com/v1_1/dtxqqa165/image/upload?upload_preset=yifypzpj');

// se crea la peticion
final imageUploadRequest = http.MultipartRequest('POST',url,);


// se adjunta el archivo
// ya hice la evaluacion previamente asi que mando obligatoriamente el path...
final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

imageUploadRequest.files.add(file);

//stream response es la informacion que esperamos de la peticion...
final streamResponse = await imageUploadRequest.send();

final resp = await http.Response.fromStream(streamResponse);


if(resp.statusCode != 200 && resp.statusCode != 201){
  print('algo salio mal..');
  print(resp.body);
  return null;
}

//limpio propiedad porque ya la subi...
this.newPictureFile =null;

final decodedData = json.decode(resp.body);
return decodedData['secure_url'];




}

}
