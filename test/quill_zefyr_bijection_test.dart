import 'package:flutter_test/flutter_test.dart';

import 'package:quill_zefyr_bijection/quill_zefyr_bijection.dart';

import 'constants.dart';


void main() {
  test('try converting', () {
    expect(QuillZefyrBijection.convertJSONToZefyrDelta(QUILL_TO_ZEFYR_SAMPLE),
        isNotNull);
    // expect(bijection.convertToZefyrDelta(SAMPLE_1), throwsNoSuchMethodError);
  });
}
