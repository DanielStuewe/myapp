import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:myapp/models/Todo.dart';
import 'package:myapp/widgets/my_home_page.dart'; // Import your Todo model
 
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}
 
class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _deadline;
 
  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a new Todo object
      Todo newTodo = Todo(
        name: _nameController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        deadline: TemporalDateTime(_deadline!),
      );
 
      // Do something with the newTodo, like adding it to a list or sending it to a server
      createTodo(newTodo);
      // Clear the form
      
      setState(() {
        _formKey.currentState!.reset();
        _deadline = null;
      });
      _navigateAndDisplaySelection(context);

    }
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Hackathon Todo App')),
    );
  }

  Future<void> createTodo(Todo todo) async {
  try {
    final request = ModelMutations.create(todo);
    final response = await Amplify.API.mutate(request: request).response;

    final createdTodo = response.data;
    if (createdTodo == null) {
      safePrint('errors: ${response.errors}');
      return;
    }
    safePrint('Mutation result: ${createdTodo.name}');
  } on ApiException catch (e) {
    safePrint('Mutation failed: $e');
  }
}
 
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Name Field (Mandatory)
                      Container(
                        width: 250,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Description Field (Optional)
                      Container(
                        width: 250,
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Deadline Field (Optional)
                      Container(
                        width: 250,
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _deadline = pickedDate;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: _deadline == null
                                    ? 'Select Deadline (Optional)'
                                    : 'Deadline: ${DateFormat('yyyy-MM-dd').format(_deadline!)}',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Submit Button
                      OutlinedButton(
                        onPressed: _submitForm,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ),
      );
  }
}