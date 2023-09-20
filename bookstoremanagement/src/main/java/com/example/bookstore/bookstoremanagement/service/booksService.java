// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Books;
import com.example.bookstore.bookstoremanagement.repository.Booksrepository;

// Define a service class for Books related operations.
@Service
public class booksService {

    @Autowired
    Booksrepository booksRepository;

    // Retrieve all books.
    @Transactional(readOnly = true)
    public List<Books> getAllBooks() {
        return booksRepository.findAll();
    }

    // Retrieve a book by its ID.
    @Transactional(readOnly = true)
    public Books getBookById(int Book_id) {
        Optional<Books> ct = booksRepository.findById(Book_id);
        if (ct.isPresent())
            return ct.get();
        return null;
    }

    // Search books by name using a provided search query.
    @Transactional
    public List<Books> searchBooksBy(String name) {
        return booksRepository.searchBook(name);
    }
}
