import 'package:flame/components.dart';

class EnemyTurnScene extends Component {
  final Vector2 _size;

  EnemyTurnScene({required Vector2 size})
      : _size = size;

  @override
  Future<void> onMount() async {
    super.onMount();

    _loadGameComponents();
  }

  void _loadGameComponents() {
    // Load enemy turn specific components
  }
}
