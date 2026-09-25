class GameStorageService {
  GameStorageService._();

  static final GameStorageService instance = GameStorageService._();

  int _currentLevel = 1;
  int _diamonds = 50;
  int _lives = 5;

  int get currentLevel => _currentLevel;

  int get diamonds => _diamonds;

  int get lives => _lives;

  Future<void> initialize() async {
    // Local persistence will be added here later.
  }

  Future<void> saveCurrentLevel(int level) async {
    _currentLevel = level;
  }

  Future<void> saveDiamonds(int diamonds) async {
    _diamonds = diamonds < 0 ? 0 : diamonds;
  }

  Future<void> saveLives(int lives) async {
    _lives = lives < 0 ? 0 : lives;
  }
}
