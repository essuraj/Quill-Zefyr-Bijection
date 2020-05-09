library quill_zefyr_bijection;

import 'dart:convert';

import 'package:quill_delta/quill_delta.dart';
import 'package:quill_zefyr_bijection/quill_to_zeyfr.dart';

/// A converter from quill and zefyr.
class QuillZefyrBijection {
  /// Returns zeyfr delta for the given valid quill json string `{"ops":[]}`
  static Delta convertJSONToZefyrDelta(String jsonString) {
    try {
      var decodedJson = jsonDecode(jsonString);
      var quillOps = decodedJson["ops"] as Iterable;
      return convertIterableToDelta(quillOps);
    } catch (e) {
      throw e;
    }
  }

  /// Returns zeyfr delta for the given valid already parsed json `[{"insert":""},"attributes":{}]`
  static Delta convertIterableToZefyrDelta(Iterable list) {
    try {
      return convertIterableToDelta(list);
    } catch (e) {
      throw e;
    }
  }
}
