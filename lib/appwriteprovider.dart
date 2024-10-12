import 'package:appwrite/models.dart' as models;
import 'package:appwrite/appwrite.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

class AppwriteService {
  late Client client;
  late Databases database;

  AppwriteService() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Cloud Appwrite endpoint
        .setProject('67063a6f003a4b04f99d'); // Cloud project ID

    database = Databases(client);
  }
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> verifyUserCredentials(
      String username, String password, int dId) async {
    try {
      final result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b70002a8f541a52', // user table
        queries: [Query.equal('username', username)],
      );
      print(dId);
      print(result.documents[0].data);
      final resultdID = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b2600143fa8cd34', //Students Table
          queries: [Query.equal('stud_department', dId)]);
      print(resultdID.documents[0].data);

      if (result.documents.isNotEmpty && resultdID.documents.isNotEmpty) {
        final userDocument = result.documents.first;
        final userDepartment = resultdID.documents.first;
        final storedPassword = userDocument.data['password'];
        print('Documents returned: ${result.documents}');
        print(userDepartment);
        print(storedPassword);
        if ((password == storedPassword) &&
            (userDepartment.data['stud_department'] == dId)) {
          print('Logged in Successfully');
          return true;
        } else {
          print('Invalid Password');
          return false;
        }
      } else {
        print(' No user found with the provided username');
        return false;
      }
    } catch (Exception) {
      print(' Error validating credentials :$Exception');
      return false;
    }
  }

  Future<int> getDepartmentIdByName(String? selectedDepartmentName) async {
    try {
      final response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b38001859339782', // Department Table
        queries: [
          Query.equal('department_name',
              selectedDepartmentName), // Query by the department name
        ],
      );
      if (response.documents.isNotEmpty) {
        print(response);
        return response
            .documents.first.data['department_id']; // Return the department ID
      } else {
        return 0; // No department found with the given name
      }
    } catch (e) {
      print('Error fetching department ID: $e');
      return 0;
    }
  }
}
