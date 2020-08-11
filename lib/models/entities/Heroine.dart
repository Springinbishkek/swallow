//синглтон для имени героини пока негде его хранить

import 'package:flutter/material.dart';

abstract class HeroineBase{
  @protected
  String name;
  @protected
  String initialName;

  String get currentName => name;

  String get initName => initialName;

  void setName(String newName){
    name = newName;
  }

  void reset(){
    name = initialName;
  }
}

class HeroineName extends HeroineBase{
  static HeroineName _instance;

  HeroineName._internal(){
    initialName = 'Бегайым';
    name = initialName;
  }

  static HeroineName getState() {
    if(_instance == null){
      _instance = HeroineName._internal();
    }

    return _instance;
  }
}