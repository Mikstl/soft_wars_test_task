import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:soft_wars_test_task/bloc/block.dart';
import 'package:soft_wars_test_task/bloc/event_block.dart';
import 'package:soft_wars_test_task/models/task.dart';

class ChangeTaskForm extends StatefulWidget {
  const ChangeTaskForm({Key? key}) : super(key: key);

  @override
  State<ChangeTaskForm> createState() => _ChangeTaskFormState();
}

//This widget allows you to create new tasks
class _ChangeTaskFormState extends State<ChangeTaskForm> {
  //The variable is responsible for getting the date from the user and storing its state
  DateTime? selectedDate;
  //Variable used to display the usage rate in a convenient format in the app
  late String formattedCreateDate;

  //boolean variable used to check if the user loaded the image
  bool imageIsLoad = false;
  //Boolean variable responsible for stopping the receipt of task data from the server
  bool isLoad = false;

  //Variable responsible for getting the picture from use and storing its value and path
  XFile? loadImage;
  //A variable for encoding our image in base64 format to send to the server
  String? base64Image;
  //Used to display the downloaded image from the server through the device's memory
  Uint8List? bytes;

  //Variables that store the values of our task fields received for the server
  int? taskId;
  int? type;
  int? urgent;
  late TextEditingController nameTask;
  late TextEditingController description;
  int? status;
  String? finishDate;
  String? file;

  //An asynchronous function that allows the user to select a date for setting a task
  Future<void> _selectDate(BuildContext context) async {
    //Widget that allows you to enter a date
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //Convert date to correctly send to server and correct custom output
        finishDate = DateFormat('MMM d, yyyy').format(selectedDate!);
        formattedCreateDate =
            DateFormat('yyyy-MM-dd').format(selectedDate!).toString();
      });
    }
  }

  //An asynchronous function that allows you to select an image from the focus, and convert it to the desired size.
  _getFromGallery() async {
    //Image widget initialization
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      loadImage = image;
      File imagefile = File(image.path);
      //Image base64 encoding
      Uint8List imagebytes = await (imagefile).readAsBytes();
      base64Image = base64Encode(imagebytes);
      setState(() {
        imageIsLoad = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Getting the width and height of our application window
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    //Initialization of a variable responsible for storing application path settings and receiving data passed from another window
    RouteSettings settings = ModalRoute.of(context)!.settings;
    //Getting the model of our task in the form of the Task class
    Task dateTask = settings.arguments as Task;
    //Initializing our block to send events from this widget to our business logic
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    //If our widget has not yet received values from the server...
    if (isLoad == false) {
      //Initializing our widget fields using the task data received from the server
      taskId = dateTask.id;
      type = dateTask.type;
      urgent = dateTask.urgent;
      nameTask = TextEditingController(text: dateTask.name);
      description = TextEditingController(text: dateTask.description);
      status = dateTask.status;
      formattedCreateDate = dateTask.finishDate!;
      finishDate = DateFormat('MMM d, yyyy')
          .format(DateTime.parse(dateTask.finishDate as String));
      file = dateTask.file;
      if (file != "" && file != null) {
        bytes = const Base64Decoder().convert(file!);
        imageIsLoad = true;
      }
      isLoad = true;
    }

    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xffA9A9A9),
            Color(0xff383838),
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            // Top panel for entering the name of the task
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.17,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: width * 0.10,
                      color: const Color(0xffFFD600),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.60,
                  child: TextField(
                    controller: nameTask,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff383838)),
                    decoration: const InputDecoration(
                      hintText: 'Назва завдання...',
                      hintStyle: TextStyle(
                          fontSize: 24,
                          color: Color(0xff383838),
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.2,
                  child: IconButton(
                    icon: Icon(
                      Icons.done,
                      size: width * 0.10,
                    ),
                    onPressed: () {
                      if (imageIsLoad == false) {
                        base64Image = '';
                      }
                      setState(() {
                        userBloc.add(UserPutUpdateTask(
                          taskId: taskId.toString(),
                          status: status,
                          type: type,
                          description: description.text,
                          name: nameTask.text,
                          urgent: urgent,
                          selectedDate: formattedCreateDate,
                          image: base64Image,
                        ));

                        Navigator.pop(context);
                      });
                    },
                    color: const Color(0xffFFD600),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            //Switch between task type
            Container(
              height: 50,
              color: const Color(0xffFBEFB4),
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 1;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xffDBDBDB),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                            child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: type == 1
                                      ? const Color(0xffFFD600)
                                      : const Color(0xffDBDBDB),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Робочі",
                          style: TextStyle(
                              fontSize: 21,
                              color: Color(0xff383838),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type = 2;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xffDBDBDB),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                            child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: type == 2
                                      ? const Color(0xffFFD600)
                                      : const Color(0xffDBDBDB),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Особисті",
                          style: TextStyle(
                              fontSize: 21,
                              color: Color(0xff383838),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            //Field for task description
            TextField(
              controller: description,
              style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff383838)),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 40, top: 40),
                hintText: 'Додати опис...',
                hintStyle: TextStyle(
                    fontSize: 21,
                    color: Color(0xff383838),
                    fontWeight: FontWeight.w500),
                filled: true,
                fillColor: Color(0xffFBEFB4),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            //Field for entering a custom image
            Container(
                child: (imageIsLoad == false)
                    ? GestureDetector(
                        onTap: (() {
                          _getFromGallery();
                        }),
                        child: Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment.centerLeft,
                            height: 60,
                            width: width,
                            color: const Color(0xffFBEFB4),
                            child: const Text(
                              "Додати зображення",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Color(0xff383838),
                                  fontWeight: FontWeight.w500),
                            )),
                      )
                    : Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 40),
                        alignment: Alignment.centerLeft,
                        width: width,
                        color: const Color(0xffFBEFB4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Вкладене зображення",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff383838),
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                ((loadImage == null)
                                    ? Image.memory(
                                        bytes!,
                                        height: height * 0.2,
                                        width: width * 0.6,
                                      )
                                    : Image.file(
                                        File(loadImage!.path),
                                        height: height * 0.2,
                                        width: width * 0.6,
                                      )),
                                const SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        imageIsLoad = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: width * 0.08,
                                      color: const Color(0xff383838),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )),
            const SizedBox(height: 16),
            //Field for entering a custom date
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                height: 60,
                width: width,
                color: const Color(0xffFBEFB4),
                child: finishDate == null
                    ? const Text(
                        "Дата завершення",
                        style: TextStyle(
                            fontSize: 21,
                            color: Color(0xff383838),
                            fontWeight: FontWeight.w500),
                      )
                    : Text(finishDate!,
                        style: const TextStyle(
                            fontSize: 21,
                            color: Color(0xff383838),
                            fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 16),
            //Task urgency switch
            Container(
              height: 50,
              color: const Color(0xffFBEFB4),
              padding: const EdgeInsets.only(left: 40),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (urgent == 0) {
                      urgent = 1;
                    } else {
                      urgent = 0;
                    }
                  });
                },
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xffDBDBDB),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: urgent == 1
                                  ? const Color(0xffFFD600)
                                  : const Color(0xffDBDBDB),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Термінове",
                      style: TextStyle(
                          fontSize: 21,
                          color: Color(0xff383838),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //Button responsible for deleting a task
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
                  minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffFF8989))),
              onPressed: () {
                userBloc.add(UserDeleteTask(taskId: dateTask.id));
                Navigator.pop(context);
              },
              child: const Text(
                "Видалити",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff383838),
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
