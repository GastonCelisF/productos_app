import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';


class ProductCard extends StatelessWidget {
  
  final Product product;

  const ProductCard({
    super.key,
    required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30,bottom:50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          //Todos los widgets aparecen alineados en la parte inferior gracias a Aligment.bottomleft
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: product.picture),

            _ProductsDetail(
              title: product.name,
              subtitle: product.id!,
            ),

            Positioned(
              top:0,
              right: 0,
              child: _PriceTag(
                price: product.price,
              )
              ),

              
              //si no esta dispoble se mostrara el no disponible
              if( !product.available)
              Positioned(
              top:0,
              left: 0,
              child: _NotAvailable()
              )
          ],
        ),
        
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow:  const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,7),
        blurRadius: 10
      )
      ]
  );
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No Disponible',style: TextStyle(color: Colors.white,fontSize: 20 ),
          ),
          ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$$price',style: TextStyle(color:Colors.white,fontSize: 20),)),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(25))
      ),
    );
  }
}

class _ProductsDetail extends StatelessWidget {

  final String title;
  final String subtitle;

  const _ProductsDetail({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      width: double.infinity,
      height: 70,    
      decoration: _BuildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          ),
          Text(subtitle,style: TextStyle(fontSize: 15,color: Colors.white),          
          )
        ],
      ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() => const BoxDecoration(
    color: Colors.indigo,
    borderRadius:  BorderRadius.only(bottomLeft: Radius.circular(25),topRight: Radius.circular(25))
  );
}

class _BackgroundImage extends StatelessWidget {
  
  final String? url;

  const _BackgroundImage({this.url});

  @override 
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        //ternario para que los productos que si su url(imagen) es nulo enviamos un nuevo widget que es una imagen(imagen default)
        child: url == null ? Image(image: AssetImage('assets/no-image.jpg'),
        fit: BoxFit.cover,)
        // pero si la tenemos se la mandamos por el fade in image
        : FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
           image: NetworkImage(url!),
           fit: BoxFit.cover,
           ),
    
      ),
    );
  }
}