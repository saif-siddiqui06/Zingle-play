import '../data/repositories/music_repository.dart';
import '../data/services/audio_player_service.dart';
import '../data/services/purchase_service.dart';
import '../data/services/storage_service.dart';

class AppBootstrap {
  const AppBootstrap({
    required this.storageService,
    required this.musicRepository,
    required this.audioService,
    required this.purchaseService,
  });

  final StorageService storageService;
  final MusicRepository musicRepository;
  final AudioPlayerService audioService;
  final PurchaseService purchaseService;

  static Future<AppBootstrap> create() async {
    final storage = StorageService();
    await storage.open();

    final audio = AudioPlayerService();
    await audio.configure();

    final purchases = PurchaseService(storage);
    await purchases.initialize();

    return AppBootstrap(
      storageService: storage,
      musicRepository: MusicRepository(storage),
      audioService: audio,
      purchaseService: purchases,
    );
  }
}
