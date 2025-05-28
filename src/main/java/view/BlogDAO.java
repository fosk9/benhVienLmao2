package view;

import model.Blog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext<Blog> {

    @Override
    public List<Blog> select() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blog ORDER BY date DESC";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Blog select(int... id) {
        String sql = "SELECT * FROM Blog WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Blog blog) {
        String sql = "INSERT INTO Blog(blog_name, content, image, author, date, type_id, selected_banner) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, blog.getBlogName());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getImage());
            ps.setString(4, blog.getAuthor());
            ps.setDate(5, Date.valueOf(blog.getDate()));
            ps.setInt(6, blog.getTypeId());
            ps.setBoolean(7, blog.isSelectedBanner());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Blog blog) {
        String sql = "UPDATE Blog SET blog_name = ?, content = ?, image = ?, author = ?, date = ?, type_id = ?, selected_banner = ? WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, blog.getBlogName());
            ps.setString(2, blog.getContent());
            ps.setString(3, blog.getImage());
            ps.setString(4, blog.getAuthor());
            ps.setDate(5, Date.valueOf(blog.getDate()));
            ps.setInt(6, blog.getTypeId());
            ps.setBoolean(7, blog.isSelectedBanner());
            ps.setInt(8, blog.getBlogId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        String sql = "DELETE FROM Blog WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Blog getBannerBlog() {
        String sql = "SELECT * FROM Blog WHERE selected_banner = 1 ORDER BY date DESC";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Blog mapResultSet(ResultSet rs) throws SQLException {
        return Blog.builder()
                .blogId(rs.getInt("blog_id"))
                .blogName(rs.getString("blog_name"))
                .content(rs.getString("content"))
                .image(rs.getString("image"))
                .author(rs.getString("author"))
                .date(rs.getDate("date").toLocalDate())
                .typeId(rs.getInt("type_id"))
                .selectedBanner(rs.getBoolean("selected_banner"))
                .build();
    }
}
