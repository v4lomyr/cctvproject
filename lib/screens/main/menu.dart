import 'package:flutter/material.dart';
import 'package:seguro/screens/main/chat_command.dart';

import '../../globals/preferences.dart';
import 'input_photo.dart';
import 'list_photo.dart';
import 'cctv.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                "lib/assets/image/143215.jpg",
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ButtonImage(
                          name: "Input Photo",
                          iconURL: "lib/assets/image/camera.jpeg",
                          navigateTo: InputPhoto(),
                        ),
                        ButtonImage(
                          name: "My Photo",
                          iconURL: "lib/assets/image/my_picture.jpeg",
                          navigateTo: ListPhoto(),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ButtonImage(
                          name: "CCTV",
                          iconURL: "lib/assets/image/icon_cctv.jpeg",
                          navigateTo: CCTV(channel: "channel"),
                        ),
                        LockWidget(),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ButtonImage extends StatelessWidget {
  const ButtonImage(
      {Key? key,
      required this.name,
      required this.iconURL,
      required this.navigateTo})
      : super(key: key);
  final String iconURL;
  final String name;
  final Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(17)
      ),
      height: 150,
      width: 100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => navigateTo))
                  },
                  child: Image.asset(
                    iconURL,
                    width: 75,
                    height: 75,
                  ),
                )
            ),
            Expanded(
                child: Center(
                  child: Text(name),
                )
            )
          ]
      ),
    );
  }
}

class LockWidget extends StatefulWidget {
  const LockWidget({Key? key}) : super(key: key);

  @override
  State<LockWidget> createState() => _LockWidgetState();
}

class _LockWidgetState extends State<LockWidget> {
  bool _state = false;

  @override
  void initState() {
    getLockStatus().then( (value) =>
      setState(() {
        _state = value;
      })
    );
    super.initState();
  }

  void _onSwitch(bool value) {
    telegramClient.sendMessage(value == true ? "/lock" : "/unlock");
    saveLockStatus(value);
    getLockStatus().then((value) => {
      setState(() {
        _state = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: (_state == true ? Colors.green : Colors.red)),
        borderRadius: BorderRadius.circular(17)
      ),
      height: 150,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 2,
              child: Switch(
                activeColor: Colors.green.withOpacity(0.1),
                inactiveThumbColor: Colors.red.withOpacity(0.1),
                inactiveTrackColor: Colors.red,
                inactiveThumbImage: const AssetImage("lib/assets/image/unlocked_switch.png"),
                activeThumbImage: const AssetImage("lib/assets/image/locked_switch.png"),
                value: _state,
                onChanged: _onSwitch,
              )
          ),
          Expanded(
              child: Center(
                child: Text(_state == true ? 'LOCKED' : 'UNLOCKED'),
              )
          )
        ],
      ),
    );
  }
}