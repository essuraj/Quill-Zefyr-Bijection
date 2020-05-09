import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:quill_zefyr_bijection/quill_zefyr_bijection.dart';
import 'package:zefyr/zefyr.dart';

import 'constants.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              var res = QuillZefyrBijection.convertDeltaIterableToQuillJSON(
                  _controller.document.toDelta());
              Scaffold.of(context)
                  .showBottomSheet((context) => SingleChildScrollView(
                          child: Text(
                        res,
                        style: Theme.of(context).textTheme.caption,
                      )));
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    try {
      Delta d =
          QuillZefyrBijection.convertJSONToZefyrDelta(QUILL_TO_ZEFYR_SAMPLE);
      return NotusDocument.fromDelta(d);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
