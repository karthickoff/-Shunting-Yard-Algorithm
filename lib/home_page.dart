import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<String> _error = ValueNotifier<String>("");
  void handleEval() {
    String exp = myController.text;
    if (exp.isEmpty || (exp.contains(RegExp('^[a-zA-Z]+')))) {
      _error.value = 'Enter valid  expression';

      myController.clear();
      return;
    }

    List<String> sym = [];
    List<String> num = [];
    String currNum = '';
    for (int i = 0; i < exp.length; i++) {
      if ("1234567890".contains(exp[i])) {
        currNum += exp[i];
        // num.add(exp[i]);
      } else {
        debugPrint('before adding currNum');
        debugPrint(currNum);
        if (currNum != "") {
          num.add(currNum);
        }
        currNum = '';
        if (exp[i] == ')') {
          int j = sym.length - 1;
          while (sym[j] != '(') {
            num.add(sym[j]);
            sym.removeAt(j);
            j--;
          }
          if (sym[j] == '(') {
            sym.removeAt(j);
          }
        } else {
          sym.add(exp[i]);
        }
      }
    }
    if (currNum != "") {
      num.add(currNum);
    }
    // num.add(currNum);
    for (int i = 0; i < sym.length; i++) {
      num.add(sym[i]);
    }
    debugPrint(sym.toString());
    debugPrint(num.toString());
    List<String> resultNum = [];

    for (int i = 0; i < num.length; i++) {
      debugPrint(num[i]);
      debugPrint(resultNum.toString());
      if (!("+-/%()*".contains(num[i]))) {
        resultNum.add(num[i]);
      } else {
        debugPrint("expresssions ");
        debugPrint(num[i]);
        if (resultNum.length < 2) {
          _error.value = 'Invalid Expression';

          return;
        }
        debugPrint(resultNum[resultNum.length - 2]);
        debugPrint(resultNum[resultNum.length - 1]);
        int resultExp = handleOP(int.parse(resultNum[resultNum.length - 2]),
            int.parse(resultNum[resultNum.length - 1]), num[i]);
        debugPrint("after result exp");
        debugPrint(resultExp.toString());
        debugPrint(i.toString());
        debugPrint(resultNum.toString());
        debugPrint(resultNum.length.toString());
        resultNum.removeLast();
        resultNum.removeLast();
        debugPrint(resultNum.toString());
        resultNum.add(resultExp.toString());
        debugPrint("result++++++++++++++++++++++++");
        debugPrint(resultExp.toString());
        debugPrint(resultNum.toString());
        debugPrint(num[i]);
      }
    }
    _counter.value = int.parse(resultNum[0]);
  }

  handleOP(int a, int b, String c) {
    switch (c) {
      case '+':
        return a + b;
      case '-':
        return (a - b);
      case '*':
        return a * b;
      case '/':
        return a / b;
      case '%':
        return a % b;
      default:
    }
  }

  int result = 0;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shunting Yard Algorithm'),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Exp ',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 35, vertical: 10)),
          controller: myController,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: handleEval,
          child: const Text('Evaluate'),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) {
            return Text(
              'Result: $value',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
        ValueListenableBuilder<String>(
          valueListenable: _error,
          builder: (context, value, child) {
            return Text(
              ' $value',
              style: const TextStyle(fontSize: 24, color: Colors.red),
            );
          },
        ),
      ]),
    );
  }
}
