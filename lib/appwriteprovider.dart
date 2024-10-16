import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

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
  Future<List<String>> getFacultyByDepartment(int departmentId) async {
    try {
      var response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b2e001e51be5681', //Faculty Table
        queries: [Query.equal('faculty_department', departmentId)],
      );

      // Extract faculty names from the response
      List<String> facultyNames = response.documents
          .map((doc) => doc.data['faculty_name'].toString())
          .toList();
      return facultyNames;
    } catch (e) {
      print('Error fetching faculty: $e');
      return [];
    }
  }

//Verifying Email by using username
  Future<bool> verifyEmail(
      String gvnUserName, String userRole, String gvnEmail) async {
    try {
      if (userRole == 'Student') {
        final studentemailResponse = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2600143fa8cd34',
            queries: [Query.equal('enrollment_no', gvnUserName)]);
        if (studentemailResponse.documents.isNotEmpty) {
          final dbUser = studentemailResponse.documents.first;
          final email = dbUser.data['stud_e_mail'].toString();
          if (gvnEmail == email) {
            print('E-mail Verification done Successfully.');
            return true;
          } else {
            print('Username and E-mail doesnt match');
            return false;
          }
        } else {
          print('Incorrect UserName');
          return false;
        }
      } else {
        final facultyemailResponse = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2e001e51be5681',
            queries: [Query.equal('faculty_id', gvnUserName)]);
        if (facultyemailResponse.documents.isNotEmpty) {
          final dbUser = facultyemailResponse.documents.first;
          final email = dbUser.data['faculty_email'].toString();
          if (gvnEmail == email) {
            print('E-mail Verification done Successfully.');
            return true;
          } else {
            print('Username and E-mail doesnt match');
            return false;
          }
        } else {
          print('Incorrect UserName');
          return false;
        }
      }
    } catch (Exception) {
      print('Error Verifying E-mail: $Exception');
      return false;
    }
  }

  //Resetting Password by using UserName
  Future<bool> resetPassword(String rpusername, String rpPassword) async {
    try {
      final rpResponse = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b70002a8f541a52',
          queries: [Query.equal('username', rpusername)]);
      if (rpResponse.documents.isNotEmpty) {
        final userDoc = rpResponse.documents.first;
        final userID = userDoc.$id;
        await database.updateDocument(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b70002a8f541a52',
            documentId: userID,
            data: {'password': rpPassword});
        print('Password Updated Successfully');
        return true;
      } else {
        print('Could not resetthe password');
        return false;
      }
    } catch (Exception) {
      print('Could not reset the password ;$Exception');
      return false;
    }
  }

  // Fetch courses by department
  Future<List<String>> getCoursesByDepartment(int departmentId) async {
    try {
      // Replace 'databaseId' and 'collectionId' with your actual IDs
      DocumentList result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b', // Replace with your database ID
        collectionId: '67063b40000de94d73f4', // Replace with your courses collection ID
        queries: [
          Query.equal('course_dept', departmentId), // Filter by department ID
        ],
      );

    List<String> courseName = result.documents
          .map((doc) => doc.data['course_name'].toString())
          .toList();
          print(courseName);
      return courseName;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

//getting course code via course name and departmentId
  Future<String> getCourseCode(String courseName, int departmentId) async {
    try{
      print('executing try block : $courseName');
      print('executing try block : $departmentId');
      final ccresponse = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b', // Replace with your database ID
        collectionId: '67063b40000de94d73f4', // Replace with your courses collection ID
        queries: [
          Query.equal('course_name', courseName), // Filter by department ID
        ],
      );
      if(ccresponse.documents.isEmpty){
        print('document is empty!');
      } else{
         print('document recieved : $ccresponse');
      }
     
      final courseDoc = ccresponse.documents.first;
      print(courseDoc);
      int recdeptId = courseDoc.data['course_dept'];
      print(recdeptId);

      if(recdeptId == departmentId){
        final coursecode = courseDoc.data['course_code'];
        print(coursecode);
        return coursecode;
      } else{
        print('could not fetch course code');
        return '';
      }

    } catch(e){
      print('Error fetching course code: $e');
      return '';
    }
  }

  
}
