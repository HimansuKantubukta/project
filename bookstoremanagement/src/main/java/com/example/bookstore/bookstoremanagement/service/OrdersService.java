// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Orders;
import com.example.bookstore.bookstoremanagement.repository.ordersRepository;

// Define a service class for Orders related operations.
@Service
public class OrdersService {
    @Autowired
    ordersRepository orderrepository;

    // Retrieve all orders.
    @Transactional(readOnly = true)
    public List<Orders> getAlldetails() {
        return orderrepository.findAll();
    }

    // Retrieve an order by its ID.
    @Transactional(readOnly = true)
    public Orders getoredresbyId(int id) {
        Optional<Orders> oo = orderrepository.findById(id);
        if (oo.isPresent())
            return oo.get();
        return null;
    }

    // Insert or modify an order.
    @Transactional
    public boolean insertOrmodify(Orders order) {
        return orderrepository.save(order) != null;
    }

    // Delete an order by its ID.
    @Transactional
    public boolean deleteByid(int id) {
        long count = orderrepository.count();
        orderrepository.deleteById(id);
        return count > orderrepository.count();
    }
}
