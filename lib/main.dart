import 'package:card_learning/blocs/flash_cards/flash_card_repository_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/card_box_list/card_box_list_cubit.dart';
import 'blocs/selected_card_box/selected_card_box_cubit.dart';
import 'blocs/simple_bloc_observer.dart';
import 'data/database.dart';
import 'package:hive/hive.dart';

import 'screens/tab_screen.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  DatabaseConfig dbConfig = DatabaseConfig(true);
  var db = Database()..init(dbConfig);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => CardBoxListCubit(db)),
        BlocProvider(create: (BuildContext context) => FlashCardRepositoryCubit(db)),
        BlocProvider(create: (BuildContext context) => SelectedCardBoxCubit()),
      ],
      child: FlashCardLearningApp(),
    ),
  );

  Hive.close();
}

class FlashCardLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabScreen();
  }
}
