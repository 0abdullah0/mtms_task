import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mtm/const/app_const.dart';
import 'package:mtm/models/position_model.dart';
import 'package:mtm/models/result_model.dart';
import 'package:mtm/view_models/map_viewmodel.dart';

class SourceSearchScreen extends StatefulWidget {
  final TextEditingController? controller;
  final MapViewModel mapViewModel;
  const SourceSearchScreen({
    Key? key,
    required this.controller,
    required this.mapViewModel,
  }) : super(key: key);

  @override
  State<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends State<SourceSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'Source',
      searchBy: 'name',
      scaffoldBody: const Center(),
      dataListFromSnapshot: Result().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Result>? dataList = snapshot.data as List<Result>?;
          if (dataList!.isEmpty) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppConstants.NOT_FOUND,
                        width: 0.8.sw,
                        height: 0.15.sh,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "We couldn't find this location",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final Result data = dataList[index];
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    '${data.name}',
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
                          'long: ${data.longitude}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'lat: ${data.latitude}',
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
                    widget.controller!.text = data.name!;
                    widget.mapViewModel.sourcePosition = MtmsPosition(
                      name: widget.controller!.text,
                      latitude: data.latitude,
                      longitude: data.longitude,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              thickness: 1.0,
              indent: 20,
              endIndent: 20,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
