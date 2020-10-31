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
    // Note that the editor requires special `ZefyrToolbar` widget for styling.
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              var res = QuillZefyrBijection.convertDeltaIterableToQuillJSON(
                _controller.document.toDelta(),
              );
              Scaffold.of(context).showBottomSheet(
                (context) => SingleChildScrollView(
                  child: Text(
                    res,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              );
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ZefyrToolbar.basic(controller: _controller),
          ),
          Expanded(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
              embedBuilder: _customZefyrEmbedBuilder,
            ),
          ),
        ],
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    try {
      Delta d = QuillZefyrBijection.convertJSONToZefyrDelta(QUILL_TO_ZEFYR_SAMPLE);
      return NotusDocument.fromDelta(d);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // displaying embedded images is no longer supported by default
  // this requires a custom EmbedBuilder
  Widget _customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
    Widget result;
    UnimplementedError defaultError;

    // try default implementation first
    try {
      result = defaultZefyrEmbedBuilder(context, node);
    } on UnimplementedError catch (e) {
      defaultError = e;
    }

    // own implementation
    if (node.value.type == 'image') {
      final String url = (node?.value?.data ?? {})['source'];
      if (url != null) {
        return Image.network(
          url,
          fit: BoxFit.contain,
        );
      }
    }

    if (result == null && defaultError != null) {
      throw defaultError;
    }

    return result;
  }
}
