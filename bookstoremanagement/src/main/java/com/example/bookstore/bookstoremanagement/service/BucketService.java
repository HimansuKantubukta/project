// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Bucket;
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.BucketRepository;

// Define a service class for Bucket related operations.
@Service
public class BucketService {
    @Autowired
    BucketRepository bucketRepository;

    // Retrieve all bucket details.
    @Transactional(readOnly=true)
    public List<Bucket> getalldetails(){
        return  bucketRepository.findAll();
    }

    // Retrieve a bucket by its ID.
    @Transactional(readOnly=true)
    public Bucket getbucketByid(int id) {
        Optional<Bucket> bt = bucketRepository.findById(id);
        if (bt.isPresent())
            return bt.get();
        return null;
    }

    // Insert or modify a bucket.
    @Transactional
    public boolean insertorModify(Bucket bucket) {
        return  bucketRepository.save(bucket) != null;
    }

    // Delete a bucket by its ID.
    @Transactional
    public boolean deleteByid(int id) {
        long count = bucketRepository.count();
        bucketRepository.deleteById(id);
        return count > bucketRepository.count();
    }
}
