import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/display-options")
public class DisplayOptionsController {

    @Autowired
    private DisplayOptionsService displayOptionsService;

    @GetMapping("/{orderId}")
    public List<DisplayOption> getDisplayOptions(@PathVariable int orderId, @RequestBody String xmlData) {
        return displayOptionsService.getDisplayOptions(orderId, xmlData);
    }
}