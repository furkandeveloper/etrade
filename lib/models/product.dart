class Product {
  int _id;
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  // id içeren cons
  Product.withId(this._id, this._name, this._description, this._price);

  // get metodları
  int get id => _id;

  String get name => _name;

  String get description => _description;

  double get price => _price;

  // set metodları

  set name(String newName) {
    if (newName.length >= 2) {
      _name = newName;
    }
  }

  set descripton(String newDescription) {
    if (newDescription.length >= 10) {
      _description = newDescription;
    }
  }

  set price(double newPrice) {
    if (newPrice > 0) {
      _price = newPrice;
    }
  }

  //nesneleri map 'e çevirecek
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Name"] = _name;
    map["Description"] = _description;
    map["Price"] = _price;
    if (_id != null) {
      map["Id"] = _id;
    }
    return map;
  }

  // gelen veri json tipinde ama senin class'ına uyuyorsa bunu class'a çevirmen için;
  Product.fromObject(dynamic o){
    this._id=o["Id"];
    this._description=o["Description"];
    this._price=double.tryParse(o["Price"].toString());
    this._name=o["Name"];
  }
}
