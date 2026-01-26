import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class DisplayOptionsService {

    @Autowired
    private DisplayOptionsRepository displayOptionsRepository;

    public List<DisplayOption> getDisplayOptions(int orderId, String xmlData) {
        return displayOptionsRepository.callGetDisplayOptions(orderId, xmlData);
    }
}