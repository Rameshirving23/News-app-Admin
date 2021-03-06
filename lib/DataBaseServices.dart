import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newsapp/dataModel.dart';

class DatabaseService{
  
  CollectionReference dataReference = Firestore.instance.collection('news');
  StorageReference image_Storage = FirebaseStorage.instance.ref();

  String generatePassword(bool _isWithLetters, bool _isWithUppercase,
    bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {

    //Define the allowed chars to use in the password
    String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
    String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String _numbers = "0123456789";
    String _special = "@#=+!£%&?[](){}";

    //Create the empty string that will contain the allowed chars
    String _allowedChars = "";

    //Put chars on the allowed ones based on the input values
    _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
    _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
    _allowedChars += (_isWithNumbers ? _numbers : '');
    _allowedChars += (_isWithSpecial ? _special : '');

    int i = 0;
    String _result = "";

    //Create password
    while (i < _numberCharPassword.round()) {
      //Get random int
      int randomInt = Random.secure().nextInt(_allowedChars.length);
      //Get random char and append it to the password
      _result += _allowedChars[randomInt];
      i++;
    }

    return _result;
  }


  addData(InputModel inputModel, File file) async{
    Map<String,dynamic> data = {
      "tag" : inputModel.tag,
      "title": inputModel.title,
      "description": inputModel.description,
      "date": inputModel.date,
      "day": inputModel.day,
      "timestamp": inputModel.time,
      "image": await addImage(file, generatePassword(true,true ,true ,true,8)),
      "timepostedhours": inputModel.timePostedHours,
      "timepostedminutes": inputModel.timePostedMinutes
    };
    dataReference.add(data);
  }
  
  Future<String> addImage(File file, String imageName) async{
    var response = await image_Storage.child("$imageName").putFile(file).onComplete;
    var downloadURL = await response.ref.getDownloadURL();
    return downloadURL;
  }
  
  
}