import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Databases database;
  AppwriteService() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Cloud Appwrite endpoint
        .setProject('67063a6f003a4b04f99d'); // Cloud project ID
    database = Databases(client);
  }
  //USED FOR LOGIN PAGE FOR STUDENT USERS
  Future<bool> verifyUserCredentials(
      String username, String password, int dId, String Role) async {
    try {
      final result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b70002a8f541a52', // user table
        queries: [Query.equal('username', username)],
      );
      final resultdID = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b2600143fa8cd34', //Students Table
          queries: [Query.equal('stud_department', dId)]);

      if (result.documents.isNotEmpty && resultdID.documents.isNotEmpty) {
        final userDocument = result.documents.first;
        final userDepartment = resultdID.documents.first;
        final storedPassword = userDocument.data['password'];
        final storedRole = userDocument.data['role'];
        print('Role Received S: $Role');
        print('Role Received from Database S: $storedRole');

        if ((password == storedPassword) &&
            (userDepartment.data['stud_department'] == dId) &&
            (Role == storedRole)) {
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

//TO GET DEPARTMENT ID BY USING NAME FROM SELECT DEPARTMENT PAGE
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

  //USED FOR LOGIN PAGE FOR FACULTY USERS
  Future<bool> verifyUserCredentialsF(
      String username, String password, int dId, String Role) async {
    try {
      final result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b70002a8f541a52', // user table
        queries: [Query.equal('username', username)],
      );
      final resultdID = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b2e001e51be5681', //Faculty Table
          queries: [Query.equal('faculty_department', dId)]);

      if (result.documents.isNotEmpty && resultdID.documents.isNotEmpty) {
        final userDocument = result.documents.first;
        final userDepartment = resultdID.documents.first;
        final storedPassword = userDocument.data['password'];
        final storedRole = userDocument.data['role'];
        print('Role Received F: $Role');
        print('Role Received from Database F: $storedRole');

        if ((password == storedPassword) &&
            (userDepartment.data['faculty_department'] == dId) &&
            (Role == storedRole)) {
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

  //inputing list of faculty names through departmentID
  Future<List<String>> getFacultyByDepartment( int departmentId) async {
    try {
      var response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b2e001e51be5681',
        queries: [Query.equal('faculty_department', departmentId)],
      );

      // Extract faculty names from the response
      List<String> facultyNames = response.documents.map((doc) => doc.data['faculty_name'].toString()).toList();
      return facultyNames;
    } catch (e) {
      print('Error fetching faculty: $e');
      return [];
    }
  }
}
