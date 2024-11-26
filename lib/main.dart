import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sampleaura/model/countermodel.dart';
import 'package:sampleaura/screen/leaverequest.dart';
import 'package:sampleaura/screen/loginpage.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context)=> CounterModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0x00fcfcfc),
        useMaterial3: true,
      ),
     // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Loginpage(),
     // home: Leaverequest(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {

    return Consumer<CounterModel>(builder: (context,value,child)  =>   Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              value.count.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              final counter = context.read<CounterModel>();
              counter.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            onPressed: (){
              final counter = context.read<CounterModel>();
              counter.decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),

        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
    
  }
}
