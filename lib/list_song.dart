import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/widget/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'model/songs_model.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({super.key});

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  bool isPlaying = false;

  playSong(String? uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      Uri.parse(uri);
      audioPlayer.play();
      print("play");
      isPlaying = true;
    } on Exception {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Song List'),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: SongList().getSongs(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                      trailing: const SizedBox(
                          width: 35,
                          child: PopupMenuButtonWidget()),
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].displayName),
                  leading: QueryArtworkWidget(
                      id: snapshot.data![index].id, type: ArtworkType.AUDIO),
                  onTap: () {
                        int? length=snapshot.data?.length;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                        create: (context) => PlaySongBloc()),
                                    BlocProvider(
                                        create: (context) => PlayNewSongBloc())
                                  ],
                                  child: PlayPage(
                                      songModel: snapshot.data![index],
                                      audioPlayer: audioPlayer,
                                    length:length ,
                                  ),
                                )));
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
