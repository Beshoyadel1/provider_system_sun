import '../../../../../core/api/api_json.dart';

enum OrderLineKind { service, product, package }

/// Historical order amounts; never replaced with current catalog prices.
class OrderLineItem {
  const OrderLineItem(
      {required this.kind,
      this.id,
      this.name,
      this.latinName,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.taxPercentage,
      this.size,
      this.contents});

  final OrderLineKind kind;
  final int? id;
  final String? name, latinName, size, contents;
  final num? quantity, unitPrice, totalPrice, taxPercentage;

  factory OrderLineItem.fromJson(Map raw, OrderLineKind kind) {
    final json = ApiJson.object(raw);
    num? number(String key) {
      final value = num.tryParse('${json[key]}');
      return value?.isFinite == true ? value : null;
    }

    String? size;
    final rawSize = json['size'];
    if (rawSize is Map) {
      final value = ApiJson.object(rawSize);
      size = (value['size'] ?? value['name'] ?? value['sizeName'])?.toString();
    } else {
      size = rawSize?.toString();
    }
    return OrderLineItem(
      kind: kind,
      id: int.tryParse('${json['id']}'),
      name: (kind == OrderLineKind.package ? json['packageName'] : json['name'])
          ?.toString(),
      latinName: (kind == OrderLineKind.package
              ? json['packageLatinName']
              : json['latinName'])
          ?.toString(),
      quantity: number('quantity'),
      unitPrice:
          number(kind == OrderLineKind.product ? 'productPrice' : 'price'),
      totalPrice: number('totalPrice'),
      taxPercentage: number('taxPercentage'),
      size: size,
      contents: json['items']?.toString(),
    );
  }

  String displayName(bool arabic) =>
      (arabic ? name : latinName)?.trim().isNotEmpty == true
          ? (arabic ? name : latinName)!
          : (arabic ? latinName : name) ?? '—';

  Map<String, dynamic> toJson() => {
        'id': id,
        if (kind == OrderLineKind.package) ...{
          'packageName': name,
          'packageLatinName': latinName,
          'items': contents
        } else ...{
          'name': name,
          'latinName': latinName
        },
        'quantity': quantity,
        if (kind == OrderLineKind.product)
          'productPrice': unitPrice
        else
          'price': unitPrice,
        'totalPrice': totalPrice,
        'taxPercentage': taxPercentage,
        'size': size,
      };
}
