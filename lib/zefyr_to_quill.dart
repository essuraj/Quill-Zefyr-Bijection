import 'dart:convert';

import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

String convertIterableToQuillJSON(Delta list) {
  try {
    var finalZefyrData = [];
    list.toList().forEach((operation) {
      var finalZefyrNode = {};
      print(operation);

      var quillInsertNode = operation.data;
      var quillAttributesNode = operation.attributes;

      // handle BlockEmbed-Operation:
      // at this point the operation is sometimes of type
      // BlockEmbed and other times of type Map<String, dynamic>
      if (quillInsertNode is BlockEmbed || quillInsertNode is Map<String, dynamic>) {
        String _type;
        String _source;
        if (quillInsertNode is BlockEmbed) {
          _type = quillInsertNode.type;
          _source = quillInsertNode.data['source'];
        } else if (quillInsertNode is Map<String, dynamic>) {
          _type = quillInsertNode['_type'];
          _source = quillInsertNode['source'];
        }
        switch (_type) {
          case 'image':
            String source = _source;
            finalZefyrNode["insert"] = {
              "image": source,
            };
            break;
          case 'hr':
            finalZefyrNode["insert"] = '';
            quillAttributesNode = quillAttributesNode ?? {};
            quillAttributesNode['embed'] = {"type": "dots"};
            break;
        }
      }

      if (quillAttributesNode != null) {
        var finalZefyrAttributes = {};

        quillAttributesNode.keys.forEach((attrKey) {
          if (attrKey == "b") {
            finalZefyrAttributes["bold"] = true;
          } else if (attrKey == "i") {
            finalZefyrAttributes["italic"] = true;
          } else if (attrKey == "a") {
            finalZefyrAttributes["link"] = quillAttributesNode[attrKey] ?? "n/a";
          } else if (attrKey == "block" && quillAttributesNode[attrKey] == "quote") {
            finalZefyrAttributes["blockquote"] = true;
          } else if (attrKey == "embed") {
            // is BlockEmbed-Operation, already handled above
            // attributes entry just has to be preserved
            finalZefyrAttributes["embed"] = quillAttributesNode[attrKey];
          } else if (attrKey == "heading") {
            finalZefyrAttributes["header"] = quillAttributesNode[attrKey] ?? 1;
          } else {
            print("ignoring " + attrKey);
          }
        });
        if (finalZefyrAttributes.keys.length > 0) finalZefyrNode["attributes"] = finalZefyrAttributes;
      }
      if (quillInsertNode != null) {
        // set insert only if not already set from BlockEmbed-Operation
        if (finalZefyrNode["insert"] == null) {
          finalZefyrNode["insert"] = quillInsertNode;
        }
        finalZefyrData.add(finalZefyrNode);
      }
    });
    return jsonEncode({"ops": finalZefyrData});
  } catch (e) {
    throw e;
  }
}
