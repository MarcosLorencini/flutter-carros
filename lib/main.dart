import 'package:carros/pages/favoritos/favoritos_bloc.dart';
import 'package:carros/splash_page.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(//o objetivo é colocar o favoritosBloc no Provider
      providers: [//dentro declara objetos que serão gerenciados pelo Provider
        Provider<EventBus>(// ele está global para ouivr todos os eventos no app. Provider pq não precisa usar o listen para atualizacao
            create: (context) => EventBus(),
            dispose: (context, bus) => bus.dispose()
        ),
        Provider<FavoritosBloc>(
            // ignore: deprecated_member_use
            create: (context) => FavoritosBloc(),//instancia o FavoritosBloc
            dispose: (context, bloc) => bloc.dispose(),//encerra a Stream que está associada com o FavoritosBloc
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, //tira o bunner
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white, //todos o scaffold e container vão herdar esta cor do thema
        ),
        home: SplashPage(),
      ),
    );
  }
}

