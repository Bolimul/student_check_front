import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Buttons/show_legend_button.dart';
import 'package:student_check/UI/Forms/chart_download.dart';
import 'package:student_check/UI/Forms/choose_student_form.dart';
import 'package:student_check/UI/Providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:network_info_plus/network_info_plus.dart';




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final Controller controller = Controller();
  String showData = "";
  bool interactability = true;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().setGroups();
      context.read<UserProvider>().setNames();
        subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async{
          Map<Permission, PermissionStatus> statuses = await[Permission.location].request();
          var info = NetworkInfo();
          final wifi = await info.getWifiName();
          final bssid = await info.getWifiBSSID();
          stdout.writeln('BSSID: $bssid');
          final wifiName = wifi.toString().replaceAll('"', '');
          if(Platform.isAndroid){
            if(((statuses[Permission.location]!.isGranted == true) || (await Permission.location.isGranted == true && await Permission.storage.isGranted == true))){
              if (result.contains(ConnectivityResult.wifi) &&  wifiName == 'Ashdod1'){
                controller.socketListenersSetupUI();
                await controller.connectSocketUI();
                if(mounted){
                  context.read<UserProvider>().setConnection(false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("חיבור לשרת עבר בהצלחה")));
                }
              }
              else{
                controller.disconnectSocketUI();
                controller.disableListenersUI();
                if(mounted){
                  context.read<UserProvider>().setConnection(true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("חיבור לשרת נכשל. אפשר להשתמש רק שנתונים מקומיים"), duration: Duration(seconds: 5),));
                }
              }
            }
          }
          else if(Platform.isWindows){
            if (result.contains(ConnectivityResult.wifi) &&  wifiName == 'Ashdod1'){
              controller.socketListenersSetupUI();
              await controller.connectSocketUI();
              if(mounted){
                context.read<UserProvider>().setConnection(false);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("חיבור לשרת עבר בהצלחה")));
              }
            }
            else{
              controller.disconnectSocketUI();
              controller.disableListenersUI();
              if(mounted){
                context.read<UserProvider>().setConnection(true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("חיבור לשרת נכשל. אפשר להשתמש רק שנתונים מקומיים"), duration: Duration(seconds: 5),));
              }
            }
          }
        });
      
    });
    
  }

  @override
  void dispose() {
    controller.closeDBUI();
    controller.disposeSocketUI();
    subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.sizeOf(context).height/1.5;
    final double itemWidth = MediaQuery.sizeOf(context).width/2;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            Container(
              alignment: Alignment.center,
              width: kToolbarHeight,
              height: kToolbarHeight,
              decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child: Icon(context.watch<UserProvider>().isConnected? Icons.public_off: Icons.public, size:50),
            )
          ],
        ),
        body: MediaQuery.orientationOf(context) == Orientation.landscape? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                height: itemHeight*2 - kToolbarHeight,
                child: ChartDownload(context: context, controller: controller, itemHeight: itemHeight, itemWidth: itemWidth)
              ),
            ),
            Expanded(
              child: SizedBox(
                height: itemHeight*2 - kToolbarHeight,
                child: ChooseStudentForm(itemWidth: itemWidth, itemHeight: itemHeight)
              ),
            ),
          ],
        ): const Center(
          child: Text('תעביר.י את המכשיר לאוריינטציה אופקית'),
        ),
        floatingActionButton: const ShowLegendButton(),
      ),
    );
  }
}