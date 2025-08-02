enum BookStatus { available, borrowed }

class Book {
  String _title;
  String _author;
  String _isbn;
  BookStatus _status;

  Book(this._title, this._author, this._isbn, [this._status = BookStatus.available]) {
    if (!isValidISBN(_isbn)) {
      throw ArgumentError('Invalid ISBN');
    }
  }

  String get title => _title;
  String get author => _author;
  String get isbn => _isbn;
  BookStatus get status => _status;

  set title(String value) => _title = value;
  set author(String value) => _author = value;
  set isbn(String value) {
    if (!isValidISBN(value)) {
      throw ArgumentError('Invalid ISBN');
    }
    _isbn = value;
  }
  set status(BookStatus value) => _status = value;

  bool isValidISBN(String isbn) {
    return RegExp(r'^(?:\d{10}|\d{13})$').hasMatch(isbn);
  }

  void updateStatus(BookStatus newStatus) {
    _status = newStatus;
  }

  @override
  String toString() {
    return 'Title: $_title, Author: $_author, ISBN: $_isbn, Status: ${_status.name}';
  }
}

class TextBook extends Book {
  String _subjectArea;
  String _gradeLevel;

  TextBook(String title, String author, String isbn, this._subjectArea, this._gradeLevel, [BookStatus status = BookStatus.available])
      : super(title, author, isbn, status);

  String get subjectArea => _subjectArea;
  String get gradeLevel => _gradeLevel;

  set subjectArea(String value) => _subjectArea = value;
  set gradeLevel(String value) => _gradeLevel = value;

  @override
  String toString() {
    return super.toString() + ', Subject: $_subjectArea, Grade: $_gradeLevel';
  }
}

class BookManager {
  final List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  bool removeBook(String isbn) {
    final initialLength = _books.length;
    _books.removeWhere((b) => b.isbn == isbn);
    return _books.length < initialLength;
  }

  bool updateBookStatus(String isbn, BookStatus status) {
    for (var book in _books) {
      if (book.isbn == isbn) {
        book.updateStatus(status);
        return true;
      }
    }
    return false;
  }

  List<Book> searchByTitle(String title) {
    return _books.where((b) => b.title.toLowerCase().contains(title.toLowerCase())).toList();
  }

  List<Book> searchByAuthor(String author) {
    return _books.where((b) => b.author.toLowerCase().contains(author.toLowerCase())).toList();
  }

  List<Book> filterByStatus(BookStatus status) {
    return _books.where((b) => b.status == status).toList();
  }

  List<Book> get allBooks => List.unmodifiable(_books);
}

void main() {
  final manager = BookManager();

  try {
    var b1 = Book('The Alchemist', 'Paulo Coelho', '1111111111');
    var b2 = TextBook('Mathematics Essentials', 'John Doe', '2222222222222', 'Mathematics', 'Grade 10');
    var b3 = Book('To Kill a Mockingbird', 'Harper Lee', '3333333333');
    var b4 = TextBook('History of World War II', 'Anna Smith', '4444444444444', 'History', 'Grade 12');
    var b5 = Book('Pride and Prejudice', 'Jane Austen', '5555555555');

    manager.addBook(b1);
    manager.addBook(b2);
    manager.addBook(b3);
    manager.addBook(b4);
    manager.addBook(b5);
  } catch (e) {
    print('Error: $e');
  }

  print('\n📚 All Books:');
  manager.allBooks.forEach((book) => print(book));

  print('\n🔄 Borrowing book with ISBN 1111111111');
  bool updated = manager.updateBookStatus('1111111111', BookStatus.borrowed);
  print(updated ? 'Status updated.' : 'Book not found.');

  print('\n🔍 Search results for "History":');
  var titleResults = manager.searchByTitle('History');
  titleResults.forEach((book) => print(book));

  print('\n👨‍💼 Search results for author "Jane":');
  var authorResults = manager.searchByAuthor('Jane');
  authorResults.forEach((book) => print(book));

  print('\n✅ Available Books:');
  var available = manager.filterByStatus(BookStatus.available);
  available.forEach((book) => print(book));

  print('\n❌ Removing book with ISBN 2222222222222');
  bool removed = manager.removeBook('2222222222222');
  print(removed ? 'Book removed.' : 'Book not found.');

  print('\n📘 Final Book List:');
  manager.allBooks.forEach((book) => print(book));
}
