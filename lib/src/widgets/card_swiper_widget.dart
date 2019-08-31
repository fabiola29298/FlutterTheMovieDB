import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas_udemy/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas});
  
  @override
  Widget build(BuildContext context) {

    //dimenciones del dispositivo
    final _screenSize = MediaQuery.of(context).size;
     

    return Container(
       padding: EdgeInsets.only(top: 10.0),
       child: Swiper(
          layout: SwiperLayout.STACK,
          
          itemWidth: _screenSize.width * 0.7 ,// 70% del ancho
          itemHeight: _screenSize.height * 0.4, // 50% del alto
      
          itemBuilder: (BuildContext context,int index){
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // esquinas redondeadas
              child:  FadeInImage(
                image: NetworkImage(peliculas[index].getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
              )
            );
            
             
          },
          itemCount: peliculas.length,
          //pagination: new SwiperPagination(),
          //control: new SwiperControl(),
        ),
    );
  }
}