import 'package:http/http.dart' as http;


import 'dart:convert';
import 'dart:async';

import 'package:peliculas_udemy/src/models/pelicula_model.dart';
import 'package:peliculas_udemy/src/models/actores_model.dart';

class PeliculasProvider{

  String _apikey = '99ba746a823030a8cf37421cb099ff4d';
  String _url    = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List ();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>_popularesStreamController.stream;



  void disposeStream(){
    _popularesStreamController.close();
  }

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

    if(_cargando) return [];
    
    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',{  
      'api_key' : _apikey,
      'language': _language,
      'page'    : _popularesPage.toString()
    } );

    final resp= await _procesarRespuesta(url);
    _populares.addAll(resp);
    //colocar en el inicio de datos con sink
    popularesSink(_populares);
    _cargando=false;
    return resp; 
  }
  Future<List<Actor>> getCast(String peliId)async{
    final url = Uri.https(_url, '3/movie/${peliId}/credits',{
       'api_key' : _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

  }
  Future <List<Pelicula>> buscarPelicula(String query) async{
      final url = Uri.https(_url, '3/search/movie',{
        'api_key' : _apikey,
        'language': _language,
        'query': query
      } );

      return await _procesarRespuesta(url);
    }
}