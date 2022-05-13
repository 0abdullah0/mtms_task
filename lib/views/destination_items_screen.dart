import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mtm/models/destination_model.dart';
import 'package:mtm/models/position_model.dart';
import 'package:mtm/notifiers/destination_notifier.dart';
import 'package:mtm/providers/providers.dart';
import 'package:mtm/view_models/destination_viewmodel.dart';
import 'package:mtm/view_models/map_viewmodel.dart';

class DestinationItemsScreen extends StatefulWidget {
  final TextEditingController controller;
  final MapViewModel mapViewModel;
  const DestinationItemsScreen({
    Key? key,
    required this.controller,
    required this.mapViewModel,
  }) : super(key: key);

  @override
  State<DestinationItemsScreen> createState() => _DestinationItemsScreenState();
}

class _DestinationItemsScreenState extends State<DestinationItemsScreen> {
  final int increment = 10;
  bool isLoading = false;
  bool isFirstLoad = true;
  int currentLength = 0;
  List<Destination> paginatedData = [];
  List<Destination> allData = [];

  final DestinationViewModel _destinationViewModel = DestinationViewModel();

  @override
  void initState() {
    super.initState();
    _destinationViewModel.loadDestinations(context);
  }

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });

    // dummy delay
    await Future.delayed(const Duration(seconds: 1));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      paginatedData.add(allData[i]);
    }
    setState(() {
      isLoading = false;
      currentLength = paginatedData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Destination list",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ProviderListener(
        provider: destinationNotifierProvider.state,
        onChange: (context, watch) {},
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(destinationNotifierProvider.state);
            if (state is DestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DestinationLoaded) {
              if (isFirstLoad) {
                allData = state.destinations;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _loadMore();
                });
                isFirstLoad = false;
              }
              return LazyLoadScrollView(
                isLoading: isLoading,
                onEndOfPage: () => _loadMore(),
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: paginatedData.length,
                      itemBuilder: (context, position) {
                        return ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            '${paginatedData[position].name}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(
                                  'long: ${paginatedData[position].lng}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    'lat: ${paginatedData[position].lat}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            widget.controller.text =
                                paginatedData[position].name!;
                            widget.mapViewModel.destinationPosition =
                                MtmsPosition(
                              name: widget.controller.text,
                              latitude:
                                  double.parse(paginatedData[position].lat!),
                              longitude:
                                  double.parse(paginatedData[position].lng!),
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        thickness: 1.0,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    Builder(
                      builder: (_) {
                        if (isLoading) {
                          return const Align(
                            alignment: Alignment.bottomCenter,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
