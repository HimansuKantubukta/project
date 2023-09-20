// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Inventory;
import com.example.bookstore.bookstoremanagement.repository.InventoryRepository;

// Define a service class for Inventory related operations.
@Service
public class InventoryService {
    @Autowired
    InventoryRepository inventoryrepository;

    // Retrieve all inventory items.
    @Transactional(readOnly=true)
    public List<Inventory> getAllinventories(){
        return inventoryrepository.findAll();
    }

    // Retrieve an inventory item by its ID.
    @Transactional(readOnly=true)
    public Inventory getcustomersById(int cust_id) {
        Optional<Inventory> ct = inventoryrepository.findById(cust_id);
        if (ct.isPresent())
            return ct.get();
        return null;
    }

    // Insert an inventory item.
    @Transactional
    public boolean insertIntoinventory(Inventory cust) {
        return inventoryrepository.save(cust) != null;
    }

    // Delete an inventory item by its ID.
    @Transactional
    public boolean deletBycustomerId(int cus_id) {
        long count = inventoryrepository.count();
        inventoryrepository.deleteById(cus_id);
        return count > inventoryrepository.count();
    }
}
