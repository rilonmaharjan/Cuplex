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
    return Scaffold(
      backgroundColor: Colors.black,
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
    );
  }
}