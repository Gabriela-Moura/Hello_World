import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Localização',
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget{
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {
  double latitude = 0;
  double longitude = 0;

  // Localização predefinida
  double latitudeDestino = -21.472989;
  double longitudeDestino = -47.017614;

  double distancia = 0;
  bool mostrarDistancia = false;

  Future<void> buscarLocalizacao() async{
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }    

    LocationPermission permissao = await Geolocator.checkPermission();

    if(permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;
    
      distancia = Geolocator.distanceBetween(
        //Recebe a localiozação atual do usuário e a localização predefinida. Calcula a distância (em metros) entre elas
        posicao.latitude,
        posicao.longitude,
        latitudeDestino,
        longitudeDestino,
      );

      mostrarDistancia = true;
    });

    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Localização')),
      body: Center (
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const Icon(Icons.home, size: 80, color: Colors.purple),

              const SizedBox(height: 20),

              const Text(
                "Distância entre a escola e minha casa",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  
              ),

              const SizedBox(height: 30),

              Text(
                'Clique no botão para calcular a distância',
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: buscarLocalizacao,
                child: const Text('Calcular distância'),
              ),

              const SizedBox(height: 30),

              if (mostrarDistancia)
              Text(
                'Distância: ${(distancia / 1000).toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        )
      )
    );
  }
}