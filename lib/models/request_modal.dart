enum RequestStatus { pending, completed }

class Request {
  int? id;
  int userId;
  DateTime datetime;
  RequestStatus status;
  List<RequestItem>? items;

  Request({
    this.id,
    required this.userId,
    required this.datetime,
    required this.status,
    this.items,
  });

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      userId: map['user_id'],
      datetime: DateTime.parse(map['datetime']),
      status: map['status'] == 'completed' ? RequestStatus.completed : RequestStatus.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'datetime': datetime.toIso8601String(),
      'status': status == RequestStatus.completed ? 'completed' : 'pending',
    };
  }
}

class RequestItem {
  int? id;
  int requestId;
  int gallonId;
  int quantity;

  RequestItem({
    this.id,
    required this.requestId,
    required this.gallonId,
    required this.quantity,
  });

  factory RequestItem.fromMap(Map<String, dynamic> map) {
    return RequestItem(
      id: map['id'],
      requestId: map['request_id'],
      gallonId: map['gallon_id'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'request_id': requestId,
      'gallon_id': gallonId,
      'quantity': quantity,
    };
  }
}
