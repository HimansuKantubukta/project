// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Payments;
import com.example.bookstore.bookstoremanagement.repository.PaymentsRepository;

// Define a service class for Payments related operations.
@Service
public class PaymentsService {

    @Autowired
    PaymentsRepository paymentrepository;

    // Retrieve all payments.
    @Transactional(readOnly = true)
    public List<Payments> getallPayments() {
        return paymentrepository.findAll();
    }

    // Retrieve a payment by its ID.
    @Transactional(readOnly = true)
    public Payments getPaymentbyId(int id) {
        Optional<Payments> pp = paymentrepository.findById(id);
        if (pp.isPresent())
            return pp.get();
        return null;
    }

    // Insert or modify a payment.
    @Transactional
    public boolean insertorModify(Payments payment) {
        return paymentrepository.save(payment) != null;
    }

    // Delete a payment by its ID.
    @Transactional
    public boolean deletepayment(int id) {
        long count = paymentrepository.count();
        paymentrepository.deleteById(id);
        return count > paymentrepository.count();
    }
}
