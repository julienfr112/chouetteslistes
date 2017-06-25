import 'package:flutter/material.dart';

void main() {
  runApp(new ChouettesListesApp());
}

class ChouettesListesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Chouettes Listes",
      home: new HomeScreen(),
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      //...
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State createState() => new HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {

  final TextEditingController _textController = new TextEditingController();
  final List<Product> _messages = <Product>[];

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
          children: <Widget>[                                         //
            new Flexible(                                               //new
                child: new ListView.builder(                              //new
                  padding: new EdgeInsets.all(8.0),                       //new
                  reverse: true,                                          //new
                  itemBuilder: (_, int index) => _messages[index],        //new
                  itemCount: _messages.length,
                  //new
                )                                                         //new
            ),                                                          //new
            new Divider(height: 1.0),                                   //new
            new Container(                                              //new
              decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor),                   //new
              child: _buildTextComposer(),                         //modified
            ),                                                          //new
          ]                                                            //new
      ),
    );
  }

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
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAdd() {

  }

  void _openSettings() {
    print("Open settings");
  }

  void _openHome() {
    print("Home");
  }
}

//----------------------------------------------------------------
//--------------------------- PRODUCT ----------------------------
//----------------------------------------------------------------

class Product extends StatefulWidget {
  @override
  State createState() => new ProductState();
}

class ProductState extends State<Product> {
  final String text;
  final int quantity=1;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(text[0])),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    text,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                new Text(
                  quantity.toString(),
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
                  onPressed: () => _handleDecreaseQuantity(quantity),
                ),
                new IconButton(
                  icon: new Icon(Icons.add_circle),
                  color: Colors.green[500],
                  tooltip: 'ajouter',
                  onPressed: () => _handleIncreaseQuantity(quantity),
                ),
              ],
            ),
          ),
          new Row(
            children: <Widget>[
              new Icon(
                //Icons.whatshot,
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