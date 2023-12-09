
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/addres_folder.dart';
import 'package:first_project/model/get_song_file.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';

class ShowSongFolder extends StatelessWidget {
  final String path;
  final String nameFile;
  ShowSongFolder({Key? key, required this.path, required this.nameFile,}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white24,
        backgroundColor: const Color(0xff1a1b1d),
        title:Text(nameFile,style: TextStyle(color: Colors.white),) ,
      ),
      backgroundColor: const Color(0xff1a1b1d),
      body: FutureBuilder<List<SongModel>>(
        future: locator.get<GetSongFile>().getSongFile(path),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(maxLines: 1,snapshot.data![index].title,style: TextStyle(color: Colors.white),),
                  subtitle: Text(maxLines: 1,snapshot.data![index].displayName,style: TextStyle(fontSize: 18),),
                  leading: QueryArtworkWidget(
                      artworkWidth: 60,
                      artworkHeight: 60,
                      artworkFit: BoxFit.cover,
                      artworkBorder: const BorderRadius.all(Radius.circular(0)),
                      id: snapshot.data![index].id, type: ArtworkType.AUDIO),
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
                                audioPlayer: locator.get<AudioPlayer>(),
                              ),
                            )));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
// namefolder() async {
//   List<String> path = await AddressFolder().getSongs();
//   print(path);
// }
}