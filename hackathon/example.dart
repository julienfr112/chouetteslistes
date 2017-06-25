import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final googleSignIn = new GoogleSignIn();

//---PRODUCT----

class Product {
  const Product({this.name,this.quantity});
  final String name;
  final int quantity;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
      : product = product,
        super(key: new ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        onCartChanged(product, !inCart);
      },
      //title: new Text(product.name, style: _getTextStyle(context)),
      title: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    product.name,
                    style: _getTextStyle(context),
                  ),
                ),
                new Text(
                  product.quantity.toString(),
                  style: new TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.only(right: 64.0),
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.remove_circle),
                  color: Colors.red[500],
                  tooltip: 'retirer',
                  onPressed: () => _handleDecreaseQuantity(product.quantity),
                ),
                new IconButton(
                  icon: new Icon(Icons.add_circle),
                  color: Colors.green[500],
                  tooltip: 'ajouter',
                  onPressed: () => _handleIncreaseQuantity(product.quantity),
                ),
              ],
            ),
          ),
          new Row(
            children: <Widget>[
              new Icon(
                Icons.local_play,
                color: Colors.red[500],
              ),
              new Text('-40%'),
            ],
          )
        ],
      ),
    );
  }

  void _handleDecreaseQuantity(int quantity) {
    quantity--;
    print("remove");
  }

  void _handleIncreaseQuantity(int quantity) {
    quantity++;
    print("add");
  }
}

//----------------------------------------------------------------
//--------------------------- ShoppingList -----------------------
//----------------------------------------------------------------

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => new _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = new Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When user changes what is in the cart, we need to change _shoppingCart
      // inside a setState call to trigger a rebuild. The framework then calls
      // build, below, which updates the visual appearance of the app.

      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading:
        new IconButton(
          icon: new Icon(Icons.home),
          tooltip: 'Accueil',
          onPressed: _openHome,
        ),
        title: new Text("Chouettes Listes"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: widget.products.map((Product product) {
              return new ShoppingListItem(
                product: product,
                inCart: _shoppingCart.contains(product),
                onCartChanged: _handleCartChanged,
              );
            }).toList(),
          ),
          new Divider(height: 1.0),                                   //new
          new Container(                                              //new
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor),                   //new
            child: _buildTextComposer(),                         //modified
          ),
        ],
      ),
    );
  }

  final TextEditingController _textController = new TextEditingController();
  final List<Product> _messages = <Product>[];

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Ajouter un produit..."),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () => _handleSubmitted(_textController.text)),
              ),
            ],
          ),
        )
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    Product message = new Product(
      name: text,
      quantity: 1,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _openSettings() {
    print("Open settings");
  }

  void _openHome() {
    print("Home");
  }
}

class ChouettesListesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Chouettes Listes",
      home: new ShoppingList(
        products: <Product>[
          new Product(name: 'Eggs', quantity: 1),
        ],
      ),
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      //...
    );
  }
}

void main() {
  runApp(new ChouettesListesApp());
}