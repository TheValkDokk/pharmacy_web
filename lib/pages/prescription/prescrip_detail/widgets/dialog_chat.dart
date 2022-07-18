import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_web/constant/constant.dart';

import '../../../../models/note.dart';

class DialogChat extends StatelessWidget {
  const DialogChat(this.id);

  final String id;

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('prescription')
        .doc(id)
        .collection('note')
        .orderBy('time', descending: false)
        .snapshots();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          final List<Note> notes =
              snapshot.data!.docs.map((e) => Note.fromMap(e.data())).toList();

          return _buildChat(notes);
        }
      },
    );
  }

  Widget _buildChat(List<Note> notes) {
    String mail = authController.firebaseUser.value!.email.toString();
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        bool isSender = note.mail == mail;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BubbleSpecialThree(
              text: note.msg.substring(0),
              isSender: isSender,
              color: isSender ? const Color(0xFFE8E8EE) : Colors.blue,
            ),
          ),
        );
      },
    );
  }
}
