import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:peliculas_udemy/src/models/pelicula_model.dart';

class PeliculasProvider{

  String _apikey = '99ba746a823030a8cf37421cb099ff4d';
  String _url    = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future <List<Pelicula>> _procesarRespuesta(Uri url)async{
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
 
    return peliculas.items;
  }


  //GET / Movie/now_playing
  Future <List<Pelicula>> getEnCines() async{
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apikey,
      'language': _language
    } );

    return await _procesarRespuesta(url);
  }

  Future <List<Pelicula>> getPopulares ()async{
    final url = Uri.https(_url, '3/movie/popular',{  
      'api_key' : _apikey,
      'language': _language
    } );

    return await _procesarRespuesta(url);
  }


}