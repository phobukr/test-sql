import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class DisplayOptionsRepository {

    private final JdbcTemplate jdbcTemplate;

    public DisplayOptionsRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<DisplayOption> callGetDisplayOptions(int orderId, String xmlData) {
        String sql = "EXEC GetDisplayOptions @order_id = ?, @XmlData = ?";
        return jdbcTemplate.query(sql, new Object[]{orderId, xmlData}, (rs, rowNum) -> {
            // Map the result set to DisplayOption object
            return new DisplayOption(rs.getInt("ItemId"), rs.getString("CustomerSegment"), ...);
        });
    }
}