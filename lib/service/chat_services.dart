import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doots/constants/global.dart';
import 'package:doots/controller/bottom_sheet_controller/gallery_controller.dart';
import 'package:doots/controller/chatting_screen_controller.dart';
import 'package:doots/controller/contact_screen_controller.dart';
import 'package:doots/controller/profile_page_controller.dart';
import 'package:doots/models/chat_user.dart';
import 'package:doots/models/group_model.dart';
import 'package:doots/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  Timer? typingTimer;
  bool isTyping = false;

  static User get user => authInstance.currentUser!;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  static Future<void> playSendMessageSound() async {
    final player = AudioPlayer();
    await player
        .setAsset("assets/sounds/WhatsAppSendingMessageSoundEffect.mp3");
    await player.play();
    player.dispose();
  }

  static void onTextChanged(String text, String groupID) {
    ChatService chatService = ChatService();

    chatService.isTyping = text.isNotEmpty;
    if (chatService.isTyping) {
      chatService.typingTimer?.cancel();
      chatService.typingTimer =
          Timer(const Duration(seconds: 4), () => onTypingTimeout(groupID));
    }
  }

  static void onTypingTimeout(String groupID) {
    ChatService chatService = ChatService();
    if (chatService.isTyping) {
      chatService.isTyping = false;
      updateIsTypingStatusOfGroup(
          groupID, false); // Call your function to update Firestore
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> contactIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: contactIds)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCommonGroups(
      List<String> groupIds) {
    return firestore
        .collection('groups')
        .where('groupId', whereIn: groupIds)
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      String chatUserId, String msg, String type) async {
    await firestore
        .collection('users')
        .doc(chatUserId)
        .collection('my_contacts')
        .doc(user.uid)
        .set({}).then((value) {
      if (chatUserId.isNotEmpty) {
        sendMessage(chatUserId: chatUserId, groupId: '', msg: msg, type: type);
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String? id) {
    return firestore
        .collection('chats/${getConversationID(id!)}/messages/')
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageOfGroup(
      String? id) {
    return firestore
        .collection('groups/$id/messages/')
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getContactsId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_contacts')
        .snapshots();
  }

  static Stream<ChatUser> getMyUserData() {
    return ChatService.firestore
        .collection('users')
        .doc(ChatService.user.uid)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return ChatUser.fromJson(data!);
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatuser) {
    return firestore
        .collection('chats/${getConversationID(chatuser.id!)}/messages/')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages(
      String groupId) {
    return firestore
        .collection('groups/$groupId/messages/')
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getConversationMetadata(
      ChatUser chatuser) {
    return firestore
        .collection('chats')
        .doc(getConversationID(chatuser.id!))
        .snapshots();
  }

  static void updateIsTypingStatus(String chatuserID, bool isTyping) {
    String conversationID = getConversationID(chatuserID);

    DocumentReference<Map<String, dynamic>> metadataRef =
        firestore.collection('chats').doc(conversationID);

    if (isTyping) {
      metadataRef.set({'userId': user.uid}, SetOptions(merge: true));
    } else {
      metadataRef.set({'userId': FieldValue.delete()}, SetOptions(merge: true));
    }
  }

  static void updateIsTypingStatusOfGroup(String groupId, bool isTyping) {
    DocumentReference<Map<String, dynamic>> metadataRef =
        firestore.collection('groups').doc(groupId);
    if (isTyping) {
      metadataRef.set({
        'userId': user.uid,
        'name': user.displayName,
      }, SetOptions(merge: true));
    } else {
      metadataRef.set(
          {'userId': FieldValue.delete(), 'name': FieldValue.delete()},
          SetOptions(merge: true));
    }
  }

  static Future<void> sendMessage({
    required String chatUserId,
    required String groupId,
    required String msg,
    required String type,
    String? localPath,
    String? fileName,
    String? fileSize,
    String? ext,
    String? localThumbnailPath,
    String? thumbnailPath,
    String? duration,
    String? replyMessage,
    String? name,
  }) async {
    var c = Get.put(ChattingScreenController());
    var proCtr = Get.put(ProfilePageController());
    proCtr.fetchUserData();
    if (chatUserId.isNotEmpty) {
      final Message individualMessage = Message(
          name: proCtr.currentUserData!.nickName,
          replyMessage: replyMessage ?? '',
          duration: duration ?? "",
          localThumbnailPath: localThumbnailPath ?? "",
          thumbnailPath: thumbnailPath ?? "",
          isDownloaded: false,
          isDownloading: false,
          localFileLocation: localPath ?? "",
          filename: fileName ?? "",
          size: fileSize ?? "",
          ext: ext ?? '',
          toId: chatUserId,
          msg: msg,
          read: '',
          messageType: type,
          fromId: user.uid,
          sent: DateTime.now().millisecondsSinceEpoch.toString());
      // final ref = firestore
      //     .collection('chats/${getConversationID(chatUserId)}/messages/');
      c.scrollToOldest();
      final ref = firestore
          .collection("chats")
          .doc(getConversationID(chatUserId))
          .collection("messages");

      await ref.doc(individualMessage.sent).set(individualMessage.toJson());

      await playSendMessageSound();
      await setUnreadCount(
        chatUserId: chatUserId,
      );
    } else if (groupId.isNotEmpty) {
      final Message groupMessage = Message(
          name: proCtr.currentUserData!.nickName,
          replyMessage: replyMessage ?? '',
          duration: duration ?? "",
          localThumbnailPath: localThumbnailPath ?? "",
          thumbnailPath: thumbnailPath ?? "",
          isDownloaded: false,
          isDownloading: false,
          localFileLocation: localPath ?? "",
          filename: fileName ?? "",
          size: fileSize ?? "",
          ext: ext ?? '',
          toId: groupId,
          msg: msg,
          read: '',
          messageType: type,
          fromId: user.uid,
          sent: DateTime.now().millisecondsSinceEpoch.toString());
      final ref = firestore.collection('groups/$groupId/messages/');
      await ref.doc(groupMessage.sent).set(groupMessage.toJson());
      await playSendMessageSound();
    }
  }

  static Stream<int> getUnreadCount(String id) {
    String currentUserId = user.uid;
    String conversationID = getConversationID(id);

    DocumentReference<Map<String, dynamic>> metadataRef =
        firestore.collection('chats').doc(conversationID);

    // Access the specific unread count for the current user
    String unreadCountField = 'user${currentUserId}UnreadCount';

    return metadataRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Ensure data exists before accessing fields
        return snapshot.data()?[unreadCountField] ??
            0; // Use null-safety operators
      } else {
        // Handle the case where the document doesn't exist
        // (e.g., return default value or error)
        return 0; // Or handle differently based on your logic
      }
    });
  }

  static Future<void> setUnreadCount({
    required String chatUserId,
  }) async {
    DocumentReference<Map<String, dynamic>> metadataRef =
        firestore.collection("chats").doc(getConversationID(chatUserId));
    String unreadCountField = 'user${chatUserId}UnreadCount';

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await metadataRef.get();

      if (snapshot.exists) {
        await metadataRef.update({unreadCountField: FieldValue.increment(1)});
      } else {
        await metadataRef.set({unreadCountField: 1});
      }
    } catch (error) {
      print('Error setting unread count: $error');
      // Handle the error accordingly
    }
  }

  static Future<void> resetUnreadCount({
    required String chatUserID,
  }) async {
    DocumentReference<Map<String, dynamic>> metadataRef =
        firestore.collection('chats').doc(getConversationID(chatUserID));
    await metadataRef.update({'user${user.uid}UnreadCount': 0});
  }

  static Future<void> deleteExistingProfilePicture(String oldImageUrl) async {
    if (oldImageUrl.isEmpty) return;
    final storageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
    try {
      await storageRef.delete();
    } on FirebaseException catch (error) {
      log('Error deleting profile picture: $error');
    }
  }

  static void addNewMembersToGroup(
    String groupId,
    List<ChatUser> selectedMembersChatUser,
    List<String> currentMembers,
  ) async {
    DocumentReference groupRef = firestore.collection('groups').doc(groupId);
    List<String> selectedMembers =
        selectedMembersChatUser.map((chatUser) => chatUser.id!).toList();

    log(selectedMembers.toString());

    // Check for existing members
    List<String> existingMembers = selectedMembers
        .where((member) => currentMembers.contains(member))
        .toList();

    if (existingMembers.isNotEmpty) {
      // Show a toast message indicating members already in the group
      Fluttertoast.showToast(
          msg: '${existingMembers.join(', ')} already in the group');
      return;
    }

    // Update the group with new members
    await groupRef.update({
      'membersId': FieldValue.arrayUnion(selectedMembers),
    }).then((_) {
      print('Members added successfully');
      Fluttertoast.showToast(msg: 'Members added successfully');
    }).catchError((error) {
      print('Failed to add members: $error');
      Fluttertoast.showToast(msg: 'Failed to add members: $error');
    });
    selectedMembers.forEach((userID) async {
      await firestore.collection("users").doc(userID).update({
        "groupIds": FieldValue.arrayUnion([groupId])
      }).then((_) {
        print("Value added to array successfully");
      }).catchError((error) {
        print("Failed to add value to array: $error");
      });
    });
  }

  static Future<void> updateUserData({
    required String currentUserId,
    File? imageFile,
    required String name,
    required String location,
    required String status,
    required String number,
  }) async {
    try {
      if (imageFile != null) {
        final newRef = storage.ref().child("profileimage/$currentUserId.jpg");
        await newRef.putFile(imageFile);
        var imageUrl = await newRef.getDownloadURL();

        firestore
            .collection('users')
            .doc(currentUserId)
            .update({'image': imageUrl}).then(
                (value) => Fluttertoast.showToast(msg: "Updated Successfully"));
      }
      firestore.collection('users').doc(currentUserId).update({
        'name': name,
        "location": location,
        "about": status,
        "phoneNumber": number
      }).then((value) => Fluttertoast.showToast(msg: "Updated Successfully"));
    } on FirebaseException catch (e) {
      log('Error deleting file: ${e.message}');
      // Handle any errors that occur during the deletion process
    }
  }

  static Future<void> changeNickNameOfOtherUser(
      ChatUser chatUser, String newNickName) async {
    firestore
        .collection('users')
        .doc(chatUser.id)
        .update({'nickName': newNickName}).then(
            (value) => Fluttertoast.showToast(msg: "Updated Successfully"));
  }

  static Future<void> createGroup(
    String groupName,
    String description,
    List<String> members,
    File? photoUrl,
  ) async {
    String? imageUrl;
    try {
      final groupId = const Uuid().v4();
      members.add(user.uid);
      if (photoUrl != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("groupImage")
            .child("$groupId.jpg");
        await ref.putFile(photoUrl);
        imageUrl = await ref.getDownloadURL();
      }
      GroupChat groupChat = GroupChat(
          photoUrl: imageUrl ??
              "https://w0.peakpx.com/wallpaper/342/576/HD-wallpaper-whatsapp-dp-smile-ball-dp-whatsapp-smile-ball.jpg",
          groupId: groupId,
          groupName: groupName,
          adminId: user.uid,
          description: description,
          membersId: members);
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .set(groupChat.toJson())
          .then((value) => Fluttertoast.showToast(msg: "Group Created"));

      members.forEach((userID) async {
        await firestore.collection("users").doc(userID).update({
          "groupIds": FieldValue.arrayUnion([groupId])
        }).then((_) {
          print("Value added to array successfully");
        }).catchError((error) {
          print("Failed to add value to array: $error");
        });
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroups() {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('membersId', arrayContains: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupInfo(
      String groupId) {
    return firestore.collection('groups').doc(groupId).snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static Future<bool> addContacts(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection('my_contacts')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> sendImage(
      String chatUserId, String groupId, File image, String type) async {
    try {
      var gallaryCtr = Get.put(GallaryController());
      final ext = image.path.split('.').last;
      final ref = storage.ref().child(
          'images/${getConversationID(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      gallaryCtr.changeUploadingState(true);
      await ref.putFile(image).then((p0) {
        log("Data Transfer: ${p0.bytesTransferred / 1000} kb");
      });
      gallaryCtr.changeUploadingState(false);

      final imageUrl = await ref.getDownloadURL();
      await sendMessage(
          chatUserId: chatUserId, groupId: groupId, msg: imageUrl, type: type);
    } on FirebaseException catch (e) {
      Get.snackbar("title", e.message.toString());
    }
  }

  static Future<void> sendVideo({
    required String chatUserId,
    required String groupId,
    required File video,
    required String type,
    required String localPath,
    required String thumbnailPath,
    required String thumbnailLocalPath,
    required String videoName,
  }) async {
    try {
      final ext = video.path.split('.').last;
      final ref = storage.ref().child(
          'videos/${getConversationID(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      await ref.putFile(video).then((p0) {
        log("Data Transfer: ${p0.bytesTransferred / 1000} kb");
      });
      final videoUrl = await ref.getDownloadURL();
      await sendMessage(
          fileName: videoName,
          chatUserId: chatUserId,
          groupId: groupId,
          msg: videoUrl,
          type: type,
          localPath: localPath,
          localThumbnailPath: thumbnailLocalPath,
          thumbnailPath: thumbnailPath);
    } on FirebaseException catch (e) {
      Get.snackbar("title", e.message.toString());
    }
  }

  static Future<void> sendDocuments({
    required String chatUserId,
    required String groupId,
    required File? file,
    required String type,
    required String fileName,
    required String fileSize,
    required String ext,
    required String localPath,
  }) async {
    try {
      if (file != null) {
        final ref = storage.ref().child(
            'files/${getConversationID(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

        await ref.putFile(file).then((p0) {
          log("Data Transfer: ${p0.bytesTransferred / 1000} kb");
        });

        final fileUrl = await ref.getDownloadURL();
        await sendMessage(
            localPath: localPath,
            chatUserId: chatUserId,
            groupId: groupId,
            msg: fileUrl,
            type: type,
            ext: ext,
            fileName: fileName,
            fileSize: fileSize);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("title", e.message.toString());
    }
  }

  static Future<void> sendAudioDoc({
    required String chatUserId,
    required String groupId,
    required File? file,
    required String type,
    required String fileName,
    required String fileSize,
    required String localPath,
    required String duration,
  }) async {
    try {
      if (file != null) {
        final ext = file.path.split('.').last;
        final ref = storage.ref().child(
            'files/${getConversationID(chatUserId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

        await ref.putFile(file).then((p0) {
          log("Data Transfer: ${p0.bytesTransferred / 1000} kb");
        });

        final fileUrl = await ref.getDownloadURL();
        await sendMessage(
            duration: duration,
            localPath: localPath,
            chatUserId: chatUserId,
            groupId: groupId,
            msg: fileUrl,
            type: type,
            ext: ext,
            fileName: fileName,
            fileSize: fileSize);
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  static Future<void> updateMessageStatus(
    Message message,
  ) async {
    var c = Get.put(ContactScreenController());
    resetUnreadCount(chatUserID: c.currentChatUserId.value);
    CollectionReference usersCollection = firestore.collection('users');
    QuerySnapshot querySnapshot =
        await usersCollection.where('id', isEqualTo: user.uid).get();
    DocumentSnapshot userDoc = querySnapshot.docs.first;
    bool isOnline = userDoc.get('is_online');
    bool isReadRecieptOn = userDoc.get("is_read_receipt_on");

    if (isOnline && isReadRecieptOn) {
      firestore
          .collection('chats/${getConversationID(message.fromId)}/messages/')
          .doc(message.sent)
          .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    }
  }

  static Future<void> updateDownloadingStatus(
      Message message, bool isDownloading) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'isDownloading': isDownloading});
  }

  static Future<void> updateDownloadingStatusForGroup(
      Message message, bool isDownloading, String groupId) async {
    firestore
        .collection('groups/$groupId/messages/')
        .doc(message.sent)
        .update({'isDownloading': isDownloading});
  }

  static Future<void> updateDownloadedStatusForGroup(
      Message message, bool isDownloaded, String groupId) async {
    firestore
        .collection('groups/$groupId/messages/')
        .doc(message.sent)
        .update({'isDownloaded': isDownloaded});
  }

  static Future<void> updateDownloadedStatus(
      Message message, bool isDownloaded) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'isDownloaded': isDownloaded});
  }

  static String convertTimestampTo12HrTime(int timestamp) {
    // Convert timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format DateTime in 12-hour time
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  static String formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static Future<void> isProfilePhotoVisibile(bool isVisible) async {
    try {
      CollectionReference<Map<String, dynamic>> users =
          firestore.collection('users');

      await users.doc(user.uid).update({'is_photo_on': isVisible});
      print('Document updated successfully!');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  static Future<void> isLastSeenVisible(bool isVisible) async {
    try {
      CollectionReference<Map<String, dynamic>> users =
          firestore.collection('users');

      await users.doc(user.uid).update({'is_last_seen_on': isVisible});
      print('Document updated successfully!');
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  // static Future<void> isPinned(
  //     bool isPinned, String chatuserId, String groupId) async {
  //   if (chatuserId != '') {
  //     try {
  //       CollectionReference<Map<String, dynamic>> users =
  //           firestore.collection('users');

  //       await users.doc(chatuserId).update({'pinned': !isPinned});
  //       print('Document updated successfully!');
  //     } catch (error) {
  //       print('Error updating document: $error');
  //     }
  //   }
  //   if (groupId != '') {
  //     try {
  //       CollectionReference<Map<String, dynamic>> users =
  //           firestore.collection('groups');

  //       await users.doc(groupId).update({'pinned': !isPinned});
  //       print('Document updated successfully!');
  //     } catch (error) {
  //       print('Error updating document: $error');
  //     }
  //   }
  // }

  static Future<void> isReadOn(bool isVisible) async {
    try {
      CollectionReference<Map<String, dynamic>> users =
          firestore.collection('users');

      await users.doc(user.uid).update({'is_read_receipt_on': isVisible});
      print('Document updated successfully!');
    } catch (error) {
      print('Error updating document: $error');
    }
  }
}
