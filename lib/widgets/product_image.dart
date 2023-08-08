import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;

  const ProductImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          decoration: _BuildBoxDecoration(),
          width: double.infinity,
          height: 450,
          child: Opacity(
            opacity: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url)
                  
            ),
          ),
        ));
  }



  BoxDecoration _BuildBoxDecoration() => BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5))
          ]);


Widget getImage(String? picture){

if(picture == null)
// para los productos nulos que no posean imagen..
return Image(
      image: AssetImage('assets/no-image.jpg'),
      fit: BoxFit.cover
      );
  //if para los url que vengan comiencen con http    
  if(picture.startsWith('http'))
    return FadeInImage(
        //mando que si o si llegara el url porque yo ya tengo la validacion echa previamente
        image: NetworkImage(this.url!),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
//Retorno el picture de la foto con el file qeu solo necesita el path..
return Image.file(
 File(picture),
 fit: BoxFit.cover,
);      
                            
}          
}
