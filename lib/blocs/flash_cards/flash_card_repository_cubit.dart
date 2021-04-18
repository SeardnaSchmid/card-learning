import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:card_learning/data/database.dart';
import 'package:card_learning/models/flash_card.dart';
import 'package:card_learning/models/learning_card_box.dart';

import 'flash_card_repository_state.dart';

class FlashCardRepositoryCubit extends Cubit<FlashCardRepositoryState> {
  final Database _db;
  List<FlashCard> _flashCards = [];

  FlashCardRepositoryCubit(this._db) : super(const FlashCardRepositoryState.loading());

  Future<void> createFlashCardInCardBox(String boxId, FlashCard flashCard) async {
    try {
      LearningCardBox box = await this._db.read(boxId);
      box.cards.add(flashCard);

      await this._db.create(boxId, box);
      emit(FlashCardRepositoryState.success(box.cards));
    } on Exception {
      emit(const FlashCardRepositoryState.failure());
    }
  }

  Future<void> fetchLatestFlashCardsFromCardBox(String boxId) async {
    if (boxId.isEmpty) {
      throw new Error();
    }
    try {
      LearningCardBox box = await this._db.read(boxId);
      this._flashCards = box.cards;
      emit(FlashCardRepositoryState.success(this._flashCards));
    } on Exception {
      emit(const FlashCardRepositoryState.failure());
    }
  }

  Future<void> updateFlashCardInCardBox(String boxId, FlashCard flashCard) async {
    try {
      LearningCardBox box = await this._db.read(boxId);
      int oldFlashCardIndex = box.cards.indexWhere((element) => element.id == flashCard.id);
      box.cards.removeAt(oldFlashCardIndex);
      box.cards.add(flashCard);

      emit(FlashCardRepositoryState.success(box.cards));
    } on Exception {
      emit(const FlashCardRepositoryState.failure());
    }
  }

  Future<void> deleteFlashCardInCardBox(String boxId, FlashCard flashCard) async {
    try {
      LearningCardBox box = await this._db.read(boxId);
      int oldFlashCardIndex = box.cards.indexWhere((element) => element.id == flashCard.id);
      box.cards.removeAt(oldFlashCardIndex);

      emit(FlashCardRepositoryState.success(box.cards));
    } on Exception {
      emit(const FlashCardRepositoryState.failure());
    }
  }

  Future<void> deleteAllFlashCardsInCardBox(String boxId, FlashCard flashCard) async {
    try {
      LearningCardBox box = await this._db.read(boxId);
      box.cards.removeRange(0, box.cards.length);

      emit(FlashCardRepositoryState.success(box.cards));
    } on Exception {
      emit(const FlashCardRepositoryState.failure());
    }
  }
}
