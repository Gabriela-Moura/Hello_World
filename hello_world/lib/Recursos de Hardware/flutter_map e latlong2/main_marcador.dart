import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Mapa',
      home: const MapaPage(),
    );
  }
}

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Position? _posicao;

  //mapaController é responsável por controlar o estado do mapa, permitindo que você mova o mapa para uma nova posição ou altere o nível de zoom.
  final MapController mapaController = MapController();

  Future<void> buscarLocalizacao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    Position novaPosicao = await Geolocator.getCurrentPosition();

    setState(() {
      _posicao = novaPosicao;
    });

    mapaController.move(
      //move o mapa para a nova posição
      LatLng(novaPosicao.latitude, novaPosicao.longitude),
      //15 -> nível de zoom do mapa
      15,
    );
  }

  @override
  void initState() {
    //inicializa o estado do widget e busca a localização atual do usuário
    super.initState();
    buscarLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Mapa')),

      body: FlutterMap(//componente responsável pelo mapa
        mapController: mapaController,

        options: const MapOptions(//definições iniciais do mapa
          initialCenter: LatLng(-21.470000, -47.030000),
          initialZoom: 13, //nível de zoom do mapa
        ),

        children: [
          TileLayer(//carrega as imagens que formam o mapa
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png', //z -> nível do zoom, x -> latitude, y -> longitude
            userAgentPackageName: 'com.example.mapa_flutter',
          ),

          if (_posicao != null)
          //Se a posição do usuário não for nula, será exibido um marcador no mapa indicando a localização atual do usuário.
            MarkerLayer(
              markers: [
                Marker(
                  //cria um marcador na posição do usuário
                  point: LatLng(_posicao!.latitude, _posicao!.longitude),
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            ),
        ],
      ),

      //Botão flutuante que, ao ser pressionado, chama a função buscarLocalizacao() para atualizar a posição do usuário no mapa.
      floatingActionButton: FloatingActionButton(
        onPressed: buscarLocalizacao,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
