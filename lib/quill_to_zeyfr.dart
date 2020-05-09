import 'package:quill_delta/quill_delta.dart';

Delta convertIterableToDelta(Iterable list) {
  try {
    var finalZefyrData = [];
    list.toList().forEach((quillNode) {
      var finalZefyrNode = {};
      print(quillNode);
      var quillInsertNode = quillNode["insert"];
      var quillAttributesNode = quillNode["attributes"];
      // var text = f["insert"];
      if (quillAttributesNode != null) {
        var finalZefyrAttributes = {};
        if (quillAttributesNode is Map) {
          quillAttributesNode.keys.forEach((attrKey) {
            if (["background", "align"].contains(attrKey)) {
              // finalNode["attributes"] = null;
            } else {
              if (attrKey == "bold") finalZefyrAttributes["b"] = true;
              if (attrKey == "italic") finalZefyrAttributes["i"] = true;
              if (attrKey == "blockquote")
                finalZefyrAttributes["block"] = "quote";
              if (attrKey == "header")
                finalZefyrAttributes["heading"] =
                    quillAttributesNode[attrKey] ?? 1;
              if (attrKey == "link")
                finalZefyrAttributes["a"] =
                    quillAttributesNode[attrKey] ?? "n/a";
            }
          });
          if (finalZefyrAttributes.keys.length > 0)
            finalZefyrNode["attributes"] = finalZefyrAttributes;
        }
      }
      if (quillInsertNode != null) {
        if (quillInsertNode is Map && quillInsertNode.containsKey("image")) {
          // print("Image not supported");
          var finalAttributes = {
            "embed": {"image": quillInsertNode["image"]}
          };
          finalZefyrNode["insert"] = "";
          finalZefyrNode["attributes"] = finalAttributes;
        } else {
          finalZefyrNode["insert"] = quillInsertNode;
        }
        finalZefyrData.add(finalZefyrNode);
      }
    });
    return Delta.fromJson(finalZefyrData);
  } catch (e) {
    throw e;
  }
}
