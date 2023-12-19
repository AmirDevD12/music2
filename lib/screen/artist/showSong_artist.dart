
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/core/popup.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/list_artist.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowListArtist extends StatefulWidget {
  final String nameArtist;
  const ShowListArtist({Key? key, required this.nameArtist}) : super(key: key);

  @override
  State<ShowListArtist> createState() => _ShowListArtistState();
}

class _ShowListArtistState extends State<ShowListArtist> {


  final OnAudioQuery onAudioQuery = OnAudioQuery();



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(


          title: Text(widget.nameArtist,),
        ),
        body:Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: SizedBox(
                  width: 110,
                  height: 30,
                  child: PlayAllContainer()),
            ),
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: locator.get<ListArtist>().getLisArtist(widget.nameArtist),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ListTile(
                            trailing: const SizedBox(
                                width: 35,
                                child: PopupMenuButtonWidget()),
                            title: Text(maxLines: 1,snapshot.data![index].title),
                            subtitle: Text(maxLines: 1,snapshot.data![index].displayName,),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                              create: (context) => locator.get<PlaySongBloc>()),
                                          BlocProvider(
                                              create: (context) => PlayNewSongBloc())
                                        ],
                                        child: PlayPage(
                                          songModel: snapshot.data![index],
                                          audioPlayer: locator.get<AudioPlayer>(), play: true,
                                        ),
                                      )));

                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ));
  }
}
