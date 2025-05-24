package view;

import java.sql.Connection;
import java.util.List;

public class SimpleDBContext extends DBContext<Object> {
    @Override public List<Object> select() { return null; }
    @Override public Object select(int... id) { return null; }
    @Override public int insert(Object obj) { return 0; }
    @Override public int update(Object obj) { return 0; }
    @Override public int delete(int... id) { return 0; }
}
