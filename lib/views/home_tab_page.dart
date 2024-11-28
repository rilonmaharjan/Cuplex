import 'package:cuplex/views/movies/movies_list.dart';
import 'package:cuplex/views/series/series_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this); 
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: customAppBar(),
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                Container(
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5
                      )
                    )
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.red,
                    labelColor: Colors.white,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 40),
                    labelStyle: const TextStyle(fontSize: 16),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                    isScrollable: false,
                    physics: const NeverScrollableScrollPhysics(),
                    tabs: const [
                      Tab(
                        child: Text(
                          'Movies',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Series', 
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: const [
                      MoviesListPage(),
                      SeriesListPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  customAppBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 26,),
          Container(
            padding: const EdgeInsets.only(top : 18, bottom : 0, left : 18),
            child: Row(
              children: [
                const SizedBox(width: 30),
                SizedBox(
                  height: 36,
                  width: 310.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextFormField( 
                      onTap: () {
                        // Get.to(() => const Settings(), transition: Transition.downToUp, duration: const Duration(milliseconds: 350));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.only(top: 6.0, left: 15.0, right: 10),
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Search',
                        hintStyle:  const TextStyle(fontSize: 14, color: Color.fromARGB(255, 110, 108, 110)),
                        prefixIconConstraints: const BoxConstraints(
                          maxWidth: 62.0,
                          minWidth: 52.0
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 110, 108, 110))
                      ),
                    ),
                  ),
                ),                
                const SizedBox(width: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}