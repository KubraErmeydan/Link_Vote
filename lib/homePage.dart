import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'linkitem.dart';
import 'linkstorage.dart';


enum SortingType {
  MostVotesToLeastVotes,
  LeastVotesToMostVotes,
  Default,
}


class HomePage extends StatefulWidget {
  int itemsPerPage = 3;  // Her sayfada kaç bağlantı gösterileceğini belirliyoruz.


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LinkStorage _linkStorage = LinkStorage();
  List<LinkItem> _linkItems = [];
  SortingType _sortingType = SortingType.Default;
  int _currentPage = 1;



  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    List<LinkItem> items = await _linkStorage.getStoredItems();
    setState(() {
      _linkItems = items;
      _sortLinks();
    });
  }

  Future<void> _deleteLink(int index) async {
    if (_linkItems.length > index) {
      setState(() {
        _linkItems.removeAt(index);
      });
      await _linkStorage.saveItems(_linkItems);
    }
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this link?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteLink(index);
                Navigator.of(context).pop();
                _showDeleteToast();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteToast() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Link deleted successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  double _iconSize = 20;
  Color _iconColor = Colors.orangeAccent;
  String _counterLabel = "Points";

  void _onUpVote(int index) {
    setState(() {
      _linkItems[index].incrementUpVotes();
      _sortLinks();
    });
  }

  void _onDownVote(int index) {
    setState(() {
      _linkItems[index].incrementDownVotes();
      _sortLinks();
    });
  }

  void _addLink(LinkItem newLink) {
    setState(() {
      _linkItems.insert(0, newLink);// Yeni bağlantıyı listenin başına ekler
      _sortLinks();
    });
    _linkStorage.saveItems(_linkItems);
  }
  void _sortLinks() {
    switch (_sortingType) {
      case SortingType.MostVotesToLeastVotes:
        _linkItems.sort((a, b) => b.totalVotes.compareTo(a.totalVotes));
        break;
      case SortingType.LeastVotesToMostVotes:
        _linkItems.sort((a, b) => a.totalVotes.compareTo(b.totalVotes));
        break;
      case SortingType.Default:
      default:
      // Varsayılan
        break;
    }
  }


  // List<LinkItem> getPaginatedLinks(int pageIndex) {
  //   final startIndex = pageIndex * widget.itemsPerPage;
  //   final endIndex = startIndex + widget.itemsPerPage;
  //   return _linkItems.sublist(startIndex, endIndex);
  // }
  //



  @override
  Widget build(BuildContext context) {

    final width= MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkVOTE Challenge', style: TextStyle(color: Colors.white),) ,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    const VerticalDivider(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[100]),
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 50,
                              color: Colors.black,
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                var result = await Navigator.pushNamed(context, '/add_link');
                                if (result != null && result is LinkItem) {
                                  _addLink(result);
                                }
                              },
                            ),
                            const VerticalDivider(),
                            const Text('SUBMIT A LINK', style: TextStyle(fontSize: 30),),
                          ],
                        ),
                      ),
                    ),],),
              )
          ),
          DropdownButton<SortingType>(
            value: _sortingType,
            onChanged: (SortingType? newValue) {
              setState(() {
                _sortingType = newValue!;
                _sortLinks(); // Sıralama türü değiştikten sonra tekrar sırala
              });
            },
            items: const [
              DropdownMenuItem(
                value: SortingType.MostVotesToLeastVotes,
                child: Text('Most Voted'),
              ),
              DropdownMenuItem(
                value: SortingType.LeastVotesToMostVotes,
                child: Text('Least Voted'),
              ),
              DropdownMenuItem(
                value: SortingType.Default,
                child: Text('Order By'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
            //  itemCount: _linkItems.length,
              itemCount: (_linkItems.length).ceil(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _showDeleteConfirmationDialog(index);
                      },
                      child: Container(
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 35,
                              left: 20,
                              child: Material(
                                child: Container(
                                  height: 150,
                                  width: width*0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),),
                            Positioned(
                                top: 0,
                                left: 10,
                                child: Card(
                                  elevation: 10,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 135,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:Border.all(width: 1.0, color: Colors.grey)
                                    ),
                                    child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text('${_linkItems[index].totalVotes ?? 0}', style: TextStyle(fontSize: 30),),
                                              Text(_counterLabel, style: TextStyle(fontSize: 20),),
                                            ],
                                          ),]
                                    ),
                                  ),
                                )),
                            Positioned(
                              top: 0,
                              left: 100,
                              child: Container(
                                height: 150,
                                width: 240,

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_linkItems[index].name, style: TextStyle(fontSize: 26),),
                                    Text(_linkItems[index].urlLink, style: TextStyle(fontSize: 18),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          iconSize: _iconSize,
                                          color: _iconColor,
                                          icon: Icon(Icons.arrow_upward),
                                          onPressed: () => _onUpVote(index),
                                        ),
                                        Text('Up Vote', style: TextStyle(fontSize: 16)),
                                        IconButton(
                                          iconSize: _iconSize,
                                          color: _iconColor,
                                          icon: Icon(Icons.arrow_downward),
                                          onPressed: () => _onDownVote(index),
                                        ),
                                        Text('Down Vote', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),

                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Center(
            child: Pagination(

              width: MediaQuery.of(context).size.width * 0.6, // Pagination'ın genişliği
              paginateButtonStyles: PaginateButtonStyles(
                activeBackgroundColor: Colors.grey,
                backgroundColor: Colors.transparent,activeTextStyle: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 20 ),textStyle: TextStyle(color: Colors.black, fontWeight:FontWeight.bold,fontSize: 20)
              ),
              prevButtonStyles: PaginateSkipButton(
                buttonBackgroundColor: Colors.transparent,
                icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,)
                     ),
              nextButtonStyles: PaginateSkipButton(
                  buttonBackgroundColor: Colors.transparent,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,)
              ),
              onPageChange: (int number) {
                setState(() {
                  _currentPage = number;
                });
              },
              totalPage:5,
              show: 4,
              currentPage: _currentPage,
              //... Diğer özellikler burada
            ),
          ),


        ],
      ),
    );
  }
}