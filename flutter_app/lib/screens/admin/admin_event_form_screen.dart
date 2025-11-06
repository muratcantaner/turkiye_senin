import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/providers/event_provider.dart';
import 'package:turkiye_senin/providers/council_provider.dart';

class AdminEventFormScreen extends StatefulWidget {
  final Event? event; // If provided, edit mode; otherwise, create mode

  const AdminEventFormScreen({super.key, this.event});

  @override
  State<AdminEventFormScreen> createState() => _AdminEventFormScreenState();
}

class _AdminEventFormScreenState extends State<AdminEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _limitController;
  
  DateTime? _selectedDate;
  int? _selectedCouncilId;
  bool _isFree = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _nameController = TextEditingController(text: widget.event?.eventName ?? '');
    _categoryController = TextEditingController(text: widget.event?.eventCategory ?? '');
    _locationController = TextEditingController(text: widget.event?.eventLocation ?? '');
    _priceController = TextEditingController(
      text: widget.event?.eventPrice.toString() ?? '0',
    );
    _limitController = TextEditingController(
      text: widget.event?.participantLimit?.toString() ?? '',
    );
    
    _selectedDate = widget.event?.eventDate;
    _selectedCouncilId = widget.event?.councilId;
    _isFree = widget.event?.isFree ?? true;
    
    // Load councils
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<CouncilProvider>(context, listen: false).fetchCouncils();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final councilProvider = Provider.of<CouncilProvider>(context);
    final isEditMode = widget.event != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Etkinliği Düzenle' : 'Yeni Etkinlik'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Event Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik Adı *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Etkinlik adı gereklidir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Kategori *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                        hintText: 'Örn: Eğitim, Spor, Kültür',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori gereklidir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Etkinlik Tarihi *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(_selectedDate!)
                              : 'Tarih seçin',
                          style: TextStyle(
                            color: _selectedDate != null ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Konum *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konum gereklidir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Council Selection
                    DropdownButtonFormField<int>(
                      value: _selectedCouncilId,
                      decoration: const InputDecoration(
                        labelText: 'Düzenleyen Meclis',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      items: councilProvider.councils.map((council) {
                        return DropdownMenuItem(
                          value: council.id,
                          child: Text(council.councilName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCouncilId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Is Free
                    SwitchListTile(
                      title: const Text('Ücretsiz Etkinlik'),
                      subtitle: const Text('Etkinlik ücretsiz mi?'),
                      value: _isFree,
                      onChanged: (value) {
                        setState(() {
                          _isFree = value;
                          if (value) {
                            _priceController.text = '0';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price (if not free)
                    if (!_isFree)
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Fiyat (TL)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (!_isFree && (value == null || value.isEmpty)) {
                            return 'Fiyat gereklidir';
                          }
                          return null;
                        },
                      ),
                    if (!_isFree) const SizedBox(height: 16),

                    // Participant Limit
                    TextFormField(
                      controller: _limitController,
                      decoration: const InputDecoration(
                        labelText: 'Katılımcı Limiti',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                        hintText: 'Boş bırakılırsa limitsiz',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isEditMode ? 'Güncelle' : 'Oluştur',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen etkinlik tarihini seçin')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      
      final event = Event(
        id: widget.event?.id ?? 0,
        eventName: _nameController.text,
        eventCategory: _categoryController.text,
        eventDate: _selectedDate!,
        eventLocation: _locationController.text,
        eventPrice: _isFree ? 0 : double.parse(_priceController.text),
        participantLimit: _limitController.text.isEmpty 
            ? null 
            : int.parse(_limitController.text),
        councilId: _selectedCouncilId,
      );

      if (widget.event != null) {
        // Update existing event
        await eventProvider.updateEvent(event);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Etkinlik güncellendi')),
          );
        }
      } else {
        // Create new event
        await eventProvider.createEvent(event);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Etkinlik oluşturuldu')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
