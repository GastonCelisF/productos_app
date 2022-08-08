import 'dart:ui';

import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  

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
            _BackgroundImage(),

            _ProductsDetail(),

            Positioned(
              top:0,
              right: 0,
              child: _PriceTag()
              ),

              //TODO: Mostrar de manera condicional..
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$103.99',style: TextStyle(color:Colors.white,fontSize: 20),)),
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
        children:const [
          Text('Disco duro G',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          ),
          Text('Id del disco duro',style: TextStyle(fontSize: 15,color: Colors.white),          
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
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
           image: NetworkImage('https://dummyimage.com/400x300/000/fff'),
           fit: BoxFit.cover,
           ),
    
      ),
    );
  }
}