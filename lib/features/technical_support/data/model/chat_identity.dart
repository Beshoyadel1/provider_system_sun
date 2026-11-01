/// A user ID is only unique together with its account type.
class ChatIdentity {
  const ChatIdentity(this.id, this.type);

  final int id;
  final int type;

  String get key => '$id:$type';

  bool matches(int userId, int userType) => id == userId && type == userType;

  static ChatIdentity? peer({
    required int userId,
    required int userType,
    required int? fromId,
    required int? fromType,
    required int? toId,
    required int? toType,
  }) {
    if (fromId == null ||
        fromType == null ||
        toId == null ||
        toType == null ||
        fromId < 0 ||
        toId < 0 ||
        fromType <= 0 ||
        toType <= 0) {
      return null;
    }
    if (fromId == userId && fromType == userType) {
      return ChatIdentity(toId, toType);
    }
    if (toId == userId && toType == userType) {
      return ChatIdentity(fromId, fromType);
    }
    return null;
  }
}
