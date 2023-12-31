
import 'package:first_project/core/popup.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(SongSortType.ALBUM),
              builder:
                  (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length??0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          trailing:
                              const SizedBox(width: 35, child: PopupMenuButtonWidget()),
                          title: Text(
                            style: locator.get<MyThemes>().title(context),
                            maxLines: 1,
                            snapshot.data![index].album??snapshot.data![index].displayName,
                          ),
                          subtitle: Text(
                            style: locator.get<MyThemes>().subTitle(context),
                            maxLines: 1,
                            snapshot.data![index].artist??snapshot.data![index].title,
                          ),
                          leading: QueryArtworkWidget(
                              artworkWidth: 60,
                              artworkHeight: 60,
                              artworkFit: BoxFit.cover,
                              artworkBorder: const BorderRadius.all(Radius.circular(0)),
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO),
                          // onTap: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => MultiBlocProvider(
                          //                 providers: [
                          //                   BlocProvider(
                          //                       create: (context) =>
                          //                           locator.get<PlaySongBloc>()),
                          //                   BlocProvider(
                          //                       create: (context) => PlayNewSongBloc())
                          //                 ],
                          //                 child: PlayPage(
                          //                   songModel: snapshot.data![index],
                          //                    play: true,
                          //                 ),
                          //               )));
                          // },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
