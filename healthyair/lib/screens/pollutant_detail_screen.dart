// lib/screens/pollutant_detail_screen.dart
import 'package:flutter/material.dart';

class PollutantDetailScreen extends StatefulWidget {
  const PollutantDetailScreen({Key? key}) : super(key: key);

  @override
  State<PollutantDetailScreen> createState() => _PollutantDetailScreenState();
}

class _PollutantDetailScreenState extends State<PollutantDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Jump to the specified pollutant tab if parameters are passed from previous screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        switch (args) {
          case 'PM2.5': _tabController.animateTo(0); break;
          case 'PM10': _tabController.animateTo(1); break;
          case 'O₃': _tabController.animateTo(2); break;
          case 'NO₂': _tabController.animateTo(3); break;
          case 'CO': _tabController.animateTo(4); break;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Pollutants Health Guide'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'PM2.5'),
            Tab(text: 'PM10'),
            Tab(text: 'Ozone (O₃)'),
            Tab(text: 'Nitrogen Dioxide (NO₂)'),
            Tab(text: 'Carbon Monoxide (CO)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPM25Info(),
          _buildPM10Info(),
          _buildOzoneInfo(),
          _buildNO2Info(),
          _buildCOInfo(),
        ],
      ),
    );
  }

  Widget _buildPM25Info() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is PM2.5?'),
          const SizedBox(height: 8),
          const Text(
            'PM2.5 refers to particulate matter in the air that is 2.5 micrometers or smaller in diameter. These particles are extremely small, about 1/30 the diameter of a human hair, and can penetrate deep into the lungs and even enter the bloodstream.',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Sources'),
          const SizedBox(height: 8),
          const Text(
            '• Industrial emissions and combustion processes\n'
            '• Vehicle exhaust emissions\n'
            '• Construction site dust\n'
            '• Forest fires and agricultural burning\n'
            '• Household cooking and heating (especially using solid fuels like coal and wood)',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Health Effects'),
          const SizedBox(height: 8),
          const Text(
            'PM2.5 is a significant air pollutant and long-term exposure may lead to:\n\n'
            '• Aggravation of respiratory diseases such as asthma and chronic bronchitis\n'
            '• Increased risk of cardiovascular disease\n'
            '• Impact on lung development, especially in children\n'
            '• Reduced life expectancy\n'
            '• Possible association with certain cancers',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Protective Measures'),
          const SizedBox(height: 8),
          _buildProtectionCard('PM2.5 < 12 μg/m³', 'Good Air Quality', 
            'Normal outdoor activities are safe', Colors.green),
          const SizedBox(height: 12),
          _buildProtectionCard('PM2.5: 12-35.4 μg/m³', 'Moderate Air Quality', 
            'Sensitive individuals should consider reducing strenuous outdoor activities', Colors.yellow),
          const SizedBox(height: 12),
          _buildProtectionCard('PM2.5: 35.5-55.4 μg/m³', 'Slightly harmful', 
            'Elderly, children, and those with respiratory conditions should reduce outdoor activities. Consider wearing a mask.', Colors.orange),
          const SizedBox(height: 12),
          _buildProtectionCard('PM2.5: 55.5-150.4 μg/m³', 'Unhealthy', 
            'Everyone should reduce outdoor activities. Wear N95 masks when outside. Air purifiers recommended indoors.', Colors.red),
          const SizedBox(height: 12),
          _buildProtectionCard('PM2.5 > 150.5 μg/m³', 'Hazardous', 
            'Avoid outdoor activities, keep windows closed, use air purifiers. If you must go outside, properly wear an N95 mask.', Colors.purple),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Expert Recommendations'),
          const SizedBox(height: 8),
          const Text(
            '• Monitor local Air Quality Index (AQI) forecasts\n'
            '• Reduce outdoor activities on days with poor air quality\n'
            '• Use HEPA air purifiers indoors\n'
            '• Correctly choose and wear masks (N95 or KN95)\n'
            '• Maintain indoor air circulation (open windows for ventilation when air quality is good)',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPM10Info() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is PM10?'),
          const SizedBox(height: 8),
          const Text(
            'PM10 refers to particulate matter in the air with a diameter of 10 micrometers or less. These particles include dust, dirt, smoke, and droplets that can enter the upper respiratory tract and lungs.',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Sources'),
          const SizedBox(height: 8),
          const Text(
            '• Road dust and construction sites\n'
            '• Agricultural activities and wind erosion\n'
            '• Industrial processes\n'
            '• Combustion activities (including vehicle emissions)\n'
            '• Natural sources (such as pollen, mold spores, etc.)',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Health Effects'),
          const SizedBox(height: 8),
          const Text(
            'Exposure to PM10 may lead to:\n\n'
            '• Coughing, sneezing, and upper respiratory discomfort\n'
            '• Aggravation of asthma symptoms and bronchitis\n'
            '• Reduced lung function\n'
            '• Irritation of eyes, nose, and throat\n'
            '• Long-term exposure may increase the risk of respiratory diseases',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Protective Measures'),
          const SizedBox(height: 8),
          _buildProtectionCard('PM10 < 54 μg/m³', 'Good Air Quality', 
            'Normal outdoor activities are safe', Colors.green),
          const SizedBox(height: 12),
          _buildProtectionCard('PM10: 54-154 μg/m³', 'Moderate Air Quality', 
            'Very few sensitive individuals should consider reducing outdoor activities', Colors.yellow),
          const SizedBox(height: 12),
          _buildProtectionCard('PM10: 155-254 μg/m³', 'Slightly harmful', 
            'Children, elderly, and those with respiratory conditions should reduce prolonged outdoor activities', Colors.orange),
          const SizedBox(height: 12),
          _buildProtectionCard('PM10: 255-354 μg/m³', 'Unhealthy', 
            'Everyone should reduce outdoor activities. Consider wearing a mask when outside', Colors.red),
          const SizedBox(height: 12),
          _buildProtectionCard('PM10 > 355 μg/m³', 'Hazardous', 
            'Avoid outdoor activities, keep doors and windows closed, use air purifiers', Colors.purple),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Expert Recommendations'),
          const SizedBox(height: 8),
          const Text(
            '• Wear appropriate masks in dusty environments\n'
            '• Reduce outdoor activities during windy, dry weather\n'
            '• Clean indoors regularly to reduce dust accumulation\n'
            '• Those with allergies should pay special attention to PM10 concentration changes\n'
            '• Close windows while driving and use the internal air circulation mode',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildOzoneInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is Ozone (O₃)?'),
          const SizedBox(height: 8),
          const Text(
            'Ozone (O₃) is a gas composed of three oxygen atoms. While stratospheric ozone is necessary to protect Earth from harmful ultraviolet radiation, ground-level ozone is a harmful air pollutant.',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Sources'),
          const SizedBox(height: 8),
          const Text(
            'Ground-level ozone is not directly emitted but formed through chemical reactions:\n\n'
            '• Reaction between nitrogen oxides (NOx) and volatile organic compounds (VOCs) in the presence of sunlight\n'
            '• Vehicle exhaust, industrial emissions, chemical solvents, and fuel evaporation are major sources of NOx and VOCs\n'
            '• Ozone concentrations typically peak on hot days with strong sunlight, especially in the afternoon and early evening',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Health Effects'),
          const SizedBox(height: 8),
          const Text(
            'Health effects of ozone include:\n\n'
            '• Irritation of the respiratory system, causing coughing, sore throat, and chest tightness\n'
            '• Reduced lung function, making breathing more difficult\n'
            '• Aggravation of asthma and other respiratory diseases\n'
            '• Increased susceptibility to respiratory infections\n'
            '• Long-term exposure may lead to permanent lung damage',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Protective Measures'),
          const SizedBox(height: 8),
          _buildProtectionCard('O₃ < 54 μg/m³', 'Safe Level', 
            'Good air quality, normal outdoor activities are safe', Colors.green),
          const SizedBox(height: 12),
          _buildProtectionCard('O₃: 55-70 μg/m³', 'Moderate Level', 
            'Very few people who are unusually sensitive to ozone should reduce outdoor activities', Colors.yellow),
          const SizedBox(height: 12),
          _buildProtectionCard('O₃: 71-85 μg/m³', 'Slightly harmful', 
            'People with asthma and other respiratory conditions should avoid prolonged outdoor activities, especially in the afternoon', Colors.orange),
          const SizedBox(height: 12),
          _buildProtectionCard('O₃: 86-105 μg/m³', 'Unhealthy', 
            'Try to avoid strenuous outdoor activities, especially for children and the elderly. Stay indoors when possible.', Colors.red),
          const SizedBox(height: 12),
          _buildProtectionCard('O₃ > 105 μg/m³', 'Very Unhealthy', 
            'Everyone should avoid outdoor activities, especially in the afternoon. Use air purifiers indoors (Note: Regular HEPA filters have limited effectiveness against ozone; specialized activated carbon filters are needed)', Colors.purple),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Expert Recommendations'),
          const SizedBox(height: 8),
          const Text(
            '• Monitor ozone forecasts and plan outdoor activities when ozone levels are low\n'
            '• Ozone typically peaks in the afternoon; outdoor activities are safer in early morning or after sunset\n'
            '• Indoor ozone levels are usually lower, but ensure there are no ozone-generating sources (such as certain types of "air purifiers")\n'
            '• Exercise away from high-traffic areas\n'
            '• Note: Regular masks offer limited protection against ozone',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNO2Info() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is Nitrogen Dioxide (NO₂)?'),
          const SizedBox(height: 8),
          const Text(
            'Nitrogen Dioxide (NO₂) is a highly irritating reddish-brown gas, part of the nitrogen oxides (NOx) family. It has a strong irritating odor and is an important precursor to the formation of ozone and fine particulate matter.',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Sources'),
          const SizedBox(height: 8),
          const Text(
            'The main sources of nitrogen dioxide include:\n\n'
            '• Combustion processes, especially high-temperature combustion (such as vehicle engines)\n'
            '• Power plants and industrial combustion facilities\n'
            '• Household gas stoves and water heaters\n'
            '• Indoor concentrations can be higher, especially in kitchens with gas stoves but poor ventilation',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Health Effects'),
          const SizedBox(height: 8),
          const Text(
            'Health effects of nitrogen dioxide include:\n\n'
            '• Respiratory tract irritation, potentially causing coughing, wheezing, and shortness of breath\n'
            '• Aggravation of asthma symptoms and increased frequency of asthma attacks\n'
            '• Increased susceptibility to respiratory infections\n'
            '• Long-term exposure may reduce lung function development\n'
            '• May increase sensitivity to allergens',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Protective Measures'),
          const SizedBox(height: 8),
          _buildProtectionCard('NO₂ < 53 μg/m³', 'Safe Level', 
            'Good air quality, normal outdoor activities are safe', Colors.green),
          const SizedBox(height: 12),
          _buildProtectionCard('NO₂: 54-100 μg/m³', 'Moderate Level', 
            'Sensitive individuals may experience mild symptoms, consider moderately reducing outdoor activities', Colors.yellow),
          const SizedBox(height: 12),
          _buildProtectionCard('NO₂: 101-360 μg/m³', 'Slightly harmful', 
            'People with asthma and respiratory conditions should reduce outdoor activities, especially in high-traffic areas', Colors.orange),
          const SizedBox(height: 12),
          _buildProtectionCard('NO₂: 361-649 μg/m³', 'Unhealthy', 
            'General public may experience respiratory symptoms, sensitive groups should avoid outdoor activities', Colors.red),
          const SizedBox(height: 12),
          _buildProtectionCard('NO₂ > 650 μg/m³', 'Very Unhealthy', 
            'Everyone should avoid outdoor activities. If going outside is necessary, avoid high-traffic areas', Colors.purple),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Expert Recommendations'),
          const SizedBox(height: 8),
          const Text(
            '• Maintain good kitchen ventilation, use exhaust fans\n'
            '• Avoid outdoor activities during peak traffic hours and in busy traffic areas\n'
            '• Regularly check and maintain gas appliances to ensure proper operation\n'
            '• Consider using air purifiers with activated carbon filters\n'
            '• Note: Regular masks have limited effectiveness against gaseous pollutants like NO₂',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCOInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What is Carbon Monoxide (CO)?'),
          const SizedBox(height: 8),
          const Text(
            'Carbon Monoxide (CO) is a colorless, odorless, non-irritating toxic gas, therefore known as the "silent killer." It causes poisoning by binding with hemoglobin and preventing oxygen transport.',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Sources'),
          const SizedBox(height: 8),
          const Text(
            'The main sources of carbon monoxide include:\n\n'
            '• Incomplete combustion of fossil fuels\n'
            '• Vehicle emissions\n'
            '• Indoor combustion equipment (such as coal stoves, gas heaters)\n'
            '• Smoking\n'
            '• Forest fires and other burning activities',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Health Effects'),
          const SizedBox(height: 8),
          const Text(
            'Carbon monoxide poses serious health hazards, including:\n\n'
            '• Combining with hemoglobin to form carboxyhemoglobin, reducing blood\'s ability to transport oxygen\n'
            '• Mild poisoning: headache, dizziness, fatigue, nausea\n'
            '• Moderate poisoning: severe headache, increased heart rate, confusion\n'
            '• Severe poisoning: unconsciousness, seizures, cardiac and cerebral failure, even death\n'
            '• Long-term low-concentration exposure may affect heart health',
            style: TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Protective Measures'),
          const SizedBox(height: 8),
          _buildProtectionCard('CO < 4.4 mg/m³', 'Safe Level', 
            'Generally does not affect health', Colors.green),
          const SizedBox(height: 12),
          _buildProtectionCard('CO: 4.5-9.4 mg/m³', 'Moderate Level', 
            'Heart disease patients may begin to experience minor effects', Colors.yellow),
          const SizedBox(height: 12),
          _buildProtectionCard('CO: 9.5-12.4 mg/m³', 'Slightly harmful', 
            'People with cardiovascular disease should reduce strenuous activities and avoid high-traffic areas', Colors.orange),
          const SizedBox(height: 12),
          _buildProtectionCard('CO: 12.5-15.4 mg/m³', 'Unhealthy', 
            'General population may experience mild symptoms, heart disease patients should avoid outdoor activities', Colors.red),
          const SizedBox(height: 12),
          _buildProtectionCard('CO > 15.5 mg/m³', 'Hazardous', 
            'Everyone should avoid outdoor activities, especially in congested traffic areas. Ensure good ventilation indoors.', Colors.purple),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Expert Recommendations & Safety Measures'),
          const SizedBox(height: 8),
          const Text(
            '• Install carbon monoxide detectors at home\n'
            '• Ensure combustion equipment (such as gas furnaces, water heaters) are properly installed and regularly maintained\n'
            '• Never use combustion equipment for heating in enclosed spaces\n'
            '• Never run engines in garages, even with the door open\n'
            '• Carbon monoxide poisoning is a medical emergency - seek immediate medical attention if symptoms occur\n'
            '• Note: Regular masks cannot filter carbon monoxide',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildProtectionCard(String level, String status, String recommendation, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  level,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              recommendation,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}