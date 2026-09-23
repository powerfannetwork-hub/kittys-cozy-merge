class MissionProgressService {
  int current = 0;

  void addProgress() {
    current++;
  }

  void reset() {
    current = 0;
  }

  bool isCompleted(int target) {
    return current >= target;
  }
}
