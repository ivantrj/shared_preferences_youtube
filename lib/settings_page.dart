import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  bool _isSaving = false;

  void _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text;
    final country = _countryController.text;
    final title = _titleController.text;
    final languages = _languagesController.text;

    if (name.isNotEmpty && country.isNotEmpty && title.isNotEmpty && languages.isNotEmpty) {
      await prefs.setString('name', name);
      await prefs.setString('country', country);
      await prefs.setString('title', title);
      await prefs.setString('languages', languages);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your settings have been saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill out all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final country = prefs.getString('country') ?? '';
    final title = prefs.getString('title') ?? '';
    final languages = prefs.getString('languages') ?? '';

    setState(() {
      _nameController.text = name;
      _countryController.text = country;
      _titleController.text = title;
      _languagesController.text = languages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _languagesController,
              decoration: InputDecoration(
                labelText: 'Languages Spoken',
              ),
            ),
            SizedBox(height: 16),
            _isSaving
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveSettings,
                    child: Text('Save Settings'),
                  ),
          ],
        ),
      ),
    );
  }
}
