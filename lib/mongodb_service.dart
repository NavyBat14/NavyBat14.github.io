import 'package:mongo_dart/mongo_dart.dart';
import 'user_data.dart';

class MongoDBService {
  late final Db db;
  late final DbCollection usersCollection;

  final String connectionString =
      "mongodb+srv://<username>:<password>@cluster0.mongodb.net/skymiles?retryWrites=true&w=majority";

  Future<void> connect() async {
    db = Db(connectionString);
    await db.open();
    usersCollection = db.collection('users');
    print('Connected to MongoDB');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return await usersCollection.findOne(where.eq('email', email));
  }

  Future<void> createUser(UserData user) async {
    await usersCollection.insert(user.toMap());
  }

  Future<void> updateUser(UserData user) async {
    await usersCollection.replaceOne(
      where.eq('email', user.email),
      user.toMap(),
      upsert: true,
    );
  }

  Future<void> close() async {
    await db.close();
  }
}
