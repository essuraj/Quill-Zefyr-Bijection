# Quill Zefyr Bijection

A Flutter package that converts quill json to zefyr delta.

## Example
```dart
Delta d=QuillZefyrBijection.convertJSONToZefyrDelta('{
  "ops": [
    {
      "insert": "Gandalf the Grey\n"
    }
  ]
}');
```
