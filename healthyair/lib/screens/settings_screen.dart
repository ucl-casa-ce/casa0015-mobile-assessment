// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/air_quality_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedUnit = 'AQI';
  String _updateFrequency = '1 hour';
  List<String> _favoriteLocations = [];
  TextEditingController _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load user settings from Firebase Firestore
  Future<void> _loadSettings() async {
    // Get the currently authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If not logged in, use default settings
      setState(() {
        _notificationsEnabled = true;
        _selectedUnit = 'AQI';
        _updateFrequency = '1 hour';
        _favoriteLocations = [];
      });
      return;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('user_settings')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        _notificationsEnabled = data?['notifications_enabled'] ?? true;
        _selectedUnit = data?['selected_unit'] ?? 'AQI';
        _updateFrequency = data?['update_frequency'] ?? '1 hour';
        _favoriteLocations =
            List<String>.from(data?['favorite_locations'] ?? []);
      });
    } else {
      // Use default values if no settings exist
      setState(() {
        _notificationsEnabled = true;
        _selectedUnit = 'AQI';
        _updateFrequency = '1 hour';
        _favoriteLocations = [];
      });
    }
  }

  // Save user settings to Firebase Firestore
  Future<void> _saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save settings')),
      );
      return;
    }
    final settingsData = {
      'notifications_enabled': _notificationsEnabled,
      'selected_unit': _selectedUnit,
      'update_frequency': _updateFrequency,
      'favorite_locations': _favoriteLocations,
    };

    await FirebaseFirestore.instance
        .collection('user_settings')
        .doc(user.uid)
        .set(settingsData, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  // Add favorite location and validate by fetching air quality data
  void _addFavoriteLocation() async {
    if (_formKey.currentState!.validate()) {
      final inputCity = _cityController.text.trim();
      setState(() {
        _isLoading = true;
      });
      try {
        final provider = Provider.of<AirQualityProvider>(context, listen: false);
        await provider.fetchAirQualityForCity(inputCity); // Validate city by fetching data
        if (provider.airQualityData != null) {
          final apiCityName = provider.airQualityData!.city; // Use API-returned city name
          final normalizedCityName = _normalizeCityName(apiCityName); // Normalize city name
          if (!_favoriteLocations.contains(normalizedCityName)) {
            setState(() {
              _favoriteLocations.add(normalizedCityName); // Save normalized city name
              _cityController.clear();
            });
            _saveSettings();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$normalizedCityName has been added to your favorites')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('City is already in your favorites')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid city name')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid city name')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Normalize city name format
  String _normalizeCityName(String city) {
    return city
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ');
  }

  // Remove a favorite location
  void _removeFavoriteLocation(String location) {
    setState(() {
      _favoriteLocations.remove(location);
    });
    _saveSettings();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  // Build section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  // Show login/register dialog
  void _showAuthDialog(BuildContext context, {bool isRegisterMode = false}) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(isRegisterMode ? Icons.person_add : Icons.login, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(isRegisterMode ? 'Register' : 'Login'),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      if (!isRegisterMode)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _showForgotPasswordDialog(context),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (isRegisterMode) {
                        await _registerUser(context, emailController.text.trim(), passwordController.text.trim());
                      } else {
                        await _loginUser(context, emailController.text.trim(), passwordController.text.trim());
                      }
                    }
                  },
                  child: Text(isRegisterMode ? 'Register' : 'Login'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isRegisterMode = !isRegisterMode; // Switch mode
                    });
                  },
                  child: Text(isRegisterMode ? 'Switch to Login' : 'Switch to Register'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Register user
  Future<void> _registerUser(BuildContext context, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent. Please check your inbox.')),
        );
      }
      Navigator.pop(context); // Close dialog
    } catch (e) {
      _handleAuthError(context, e);
    }
  }

  // Login user
  Future<void> _loginUser(BuildContext context, String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email before logging in.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully')),
        );
        setState(() {}); // Update UI
      }
      Navigator.pop(context); // Close dialog
    } catch (e) {
      if (e.toString().contains("type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?")) {
        // Treat this specific error as a successful login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully ')),
        );
        setState(() {}); // Update UI
        Navigator.pop(context); // Close dialog
      } else if (e is FirebaseAuthException) {
        _handleAuthError(context, e);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: ${e.toString()}')),
        );
      }
    }
  }

  // Forgot password
  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.lock_reset, color: Colors.blue),
              SizedBox(width: 8),
              Text('Reset Password'),
            ],
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset email sent')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    _handleAuthError(context, e);
                  }
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  // Handle authentication errors
  void _handleAuthError(BuildContext context, dynamic error) {
    String errorMessage = 'An error occurred';
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = error.message ?? 'An unknown error occurred.';
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Login/Logout button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (user == null) {
                    // User not logged in, show login dialog
                    _showAuthDialog(context);
                  } else {
                    // User logged in, perform logout
                    try {
                      await FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully')),
                      );
                      _loadSettings(); // Reset settings to default after logout
                      setState(() {}); // Update UI
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: user == null ? Colors.blue : Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(user == null ? 'Login' : 'Logout'),
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionTitle('General Settings'),
            const SizedBox(height: 16),
            // Notifications setting
            Card(
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive alerts when air quality significantly changes'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Unit selection setting
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Display Unit',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedUnit,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedUnit = newValue;
                          });
                        }
                      },
                      items: <String>['AQI', 'CAQI', 'µg/m³']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Update frequency setting
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Update Frequency',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _updateFrequency,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _updateFrequency = newValue;
                          });
                        }
                      },
                      items: <String>['30 minutes', '1 hour', '3 hours', '6 hours']
                          .toSet() // Ensure no duplicate values
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Favorite Locations'),
            const SizedBox(height: 16),
            // Add favorite location input
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City Name',
                        hintText: 'Enter city name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a city name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final provider = Provider.of<AirQualityProvider>(context, listen: false);
                              await provider.fetchAirQualityForCity(_cityController.text.trim());
                              // If successful, add the city to favorites
                              _addFavoriteLocation();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('City not found: ${e.toString()}')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Favorite locations list
            if (_favoriteLocations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No favorite locations.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _favoriteLocations.length,
                itemBuilder: (context, index) {
                  final location = _favoriteLocations[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(location),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final provider = Provider.of<AirQualityProvider>(context, listen: false);
                                await provider.fetchAirQualityForCity(location);
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Update failed: ${e.toString()}')),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFavoriteLocation(location),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            _buildSectionTitle('About the App'),
            const SizedBox(height: 16),
            // About & License card
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About Healthy Air'),
                    onTap: () {
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Privacy Policy'),
                          content: const SingleChildScrollView(
                            child: Text(
                              'We value your privacy. The app requires location permission only to retrieve local air quality data and this information is not shared with third parties.',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text('Share the App'),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share functionality coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Reset settings (delete user settings document) after confirmation
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Settings'),
                      content: const Text('Are you sure you want to reset all settings to default?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FirebaseFirestore.instance
                                  .collection('user_settings')
                                  .doc(user.uid)
                                  .delete();
                            }
                            Navigator.pop(context);
                            _loadSettings(); // Reload default settings
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All settings reset')),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red[900],
                ),
                child: const Text('Reset All Settings'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
