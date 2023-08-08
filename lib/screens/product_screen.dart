import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //redibujo el producto en caso de que suceda..
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct!),
      child: _ProductScreenBody(productService: productService),
    );
    //return
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productService,
  });

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct?.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 40,
                        color: Colors.white,
                      )),
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                      onPressed: () async{
                        //todo:camara o galeria
                        final picker = new ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 100
                        );
                        if (pickedFile == null) {
                          return;
                        }
                        productService.updateSelectedProducImage(pickedFile.path);
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: 
          productService.isSaving 
          ? CircularProgressIndicator( color: Colors.white,)
          : Icon(Icons.save_outlined),          
          onPressed: productService.isSaving  ? null
          
          : () async {
            if (!productForm.isValidForm()) return;
            final String? imageUrl  = await productService.uploadImage();
            // si el decode secure_url (la imagen que subi) es distinto de null
            // la asigno a la proiedad picture de productForm que es el objeto que mando al abm..
            if (imageUrl != null) productForm.product.picture = imageUrl;

            await productService.saveOrCreateProduct(productForm.product);
          }),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        //Evitar que los inputs queden pegados al borde de la tarjeta
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _BuildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // NOMBRE DEL PRODUCTO EL ONCHANGE SI QUEREMOS HACER UN EDIT Y EL VLAIDADOR..
              initialValue: product.name,
              onChanged: (value) => product.name = value,
              validator: (value) {
                if (value == null || value.length < 1)
                  return 'El nombre el obligatorio..';
              },
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto', labelText: 'Nombre:'),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              //  parseo a double
              initialValue: '${product.price}',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              // condicional para ver si el valor por insetado puede ser parseado, sino seteado con 0 en este caso.
              onChanged: (value) {
                if (double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', labelText: 'Precio:'),
            ),
            SizedBox(
              height: 30,
            ),
            SwitchListTile.adaptive(
                value: product.available,
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: productForm.updateAvailability),
            SizedBox(
              height: 30,
            )
          ]),
        ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
  }
}
