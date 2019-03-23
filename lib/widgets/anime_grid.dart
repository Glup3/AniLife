import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'package:anilife/data/queries.dart' as queries;
import 'package:anilife/widgets/cover_card.dart';

class AnimeGridView extends StatefulWidget {
  @override
  _AnimeGridViewState createState() => _AnimeGridViewState();
}

GraphQLClient client = GraphQLClient(
  link: HttpLink(uri: 'https://graphql.anilist.co'),
  cache: InMemoryCache(),
);

class _AnimeGridViewState extends State<AnimeGridView> {

  Future<List<dynamic>> _getListOfMedias(int pageNumber, int pageSize) async {
     QueryResult result =  await client.query(
      QueryOptions(
        document: queries.getAnimesOfSeasonAndYear,
        variables: {
          'page': pageNumber,
          'perPage': pageSize,
          'seasonYear': 2019,
          'season': 'WINTER'
        },
      ),
    );

    if (result.errors != null) { return null; }

    if (result.loading) { return null; }

    return result.data['Page']['media'];
  }

  @override
  Widget build(BuildContext context) {
    return PagewiseGridView.count(
      pageSize: 20,
      crossAxisCount: 2,
      itemBuilder: (BuildContext context, dynamic media, int index) => CoverCard(media: media, index: index,),
      pageFuture: (int pageIndex) {
        return _getListOfMedias(pageIndex + 1, 20);
      },
    );
  }

  
}
