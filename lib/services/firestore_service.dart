import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/models/note_model.dart';

class FirestoreService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Create - Add a new note
  Future<void> addNote(String title, String description) async {
    try {
      final now = DateTime.now();
      await notesCollection.add({
        'title': title,
        'description': description,
        'createdAt': now,
        'updatedAt': now,
      });
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Read - Get all notes
  Stream<List<Note>> getNotes() {
    return notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update - Edit an existing note
  Future<void> updateNote(String id, String title, String description) async {
    try {
      await notesCollection.doc(id).update({
        'title': title,
        'description': description,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete - Remove a note
  Future<void> deleteNote(String id) async {
    try {
      await notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}