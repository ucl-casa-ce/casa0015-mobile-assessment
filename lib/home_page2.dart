class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page 2'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // Number of columns
        padding: const EdgeInsets.all(16.0), // Padding around the grid
        childAspectRatio: 1.5, // Width-to-height ratio of each item
        mainAxisSpacing: 16.0, // Spacing between each row
        crossAxisSpacing: 16.0, // Spacing between each column
        children: <Widget>[
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 7'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 8'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 9'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 10'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 11'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button 12'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
