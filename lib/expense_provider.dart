class ExpenseProvider with ChangeNotifier {

  final LocalStorage storage;

  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider(this.storage) {
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() async {
    await storage.ready;
    var storedExpenses = storage.getItem('expenses');
    if (storedExpenses != null) {
      _expenses = List<Expense>.from(
        (storedExpenses as List).map((item) => Expense.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveExpensesToStorage() {
    storage.setItem('expenses', _expenses.map((e) => e.toJson()).toList());
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }
  
  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }
}