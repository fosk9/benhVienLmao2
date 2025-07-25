package dal;

import model.Blog;
import model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class BlogDAO extends DBContext<Blog> {
    private static final Logger LOGGER = Logger.getLogger(BlogDAO.class.getName());


    public List<Blog> getRecentBlogsLimited(int limit) {
        List<Blog> recentBlogs = new ArrayList<>();
        if (limit <= 0) {
            LOGGER.warning("Invalid limit value: " + limit + ". Defaulting to 3.");
            limit = 3;
        }
        String sql = String.format(
                "SELECT TOP %d b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                        "b.author, b.date, b.category_id, c.category_name " +
                        "FROM Blog b " +
                        "LEFT JOIN Category c ON b.category_id = c.category_id " +
                        "ORDER BY b.date DESC", limit);

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("blog_id"));
                blog.setBlogName(rs.getString("blog_name"));
                blog.setBlogSubContent(rs.getString("blog_sub_content"));
                blog.setContent(rs.getString("content"));
                blog.setBlogImg(rs.getString("blog_img"));
                blog.setAuthor(rs.getString("author"));
                blog.setDate(rs.getDate("date"));
                blog.setCategoryId(rs.getInt("category_id"));
                blog.setCategoryName(rs.getString("category_name"));
                recentBlogs.add(blog);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error executing query: " + e.getMessage());
            e.printStackTrace();
        }
        return recentBlogs;
    }

    @Override
    public List<Blog> select() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBlog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 1. Tìm kiếm blog theo tên
    public List<Blog> searchBlogsByName(String blogName, int offset, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "WHERE b.blog_name LIKE ? " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Dùng OFFSET và FETCH cho SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + blogName + "%");
            ps.setInt(2, offset);  // Tính toán offset
            ps.setInt(3, pageSize); // Giới hạn số lượng kết quả mỗi trang
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBlog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }



    // 2. Lấy tất cả danh mục và tổng số bài viết trong mỗi danh mục
    public List<Category> getCategoriesWithBlogCount() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.category_id, c.category_name, COUNT(b.blog_id) AS blog_count " +
                "FROM Category c " +
                "LEFT JOIN Blog b ON c.category_id = b.category_id " +
                "GROUP BY c.category_id, c.category_name"; // Đảm bảo GROUP BY có category_id

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));  // Lấy categoryId
                category.setCategoryName(rs.getString("category_name"));
                category.setBlogCount(rs.getInt("blog_count"));
                categories.add(category);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }


    // 3. Lấy 4 bài viết gần nhất
    public List<Blog> getRecentBlogs() {
        List<Blog> recentBlogs = new ArrayList<>();
        String sql = "SELECT TOP 4 b.blog_id, b.blog_name, b.blog_img, b.date " +
                "FROM Blog b " +
                "ORDER BY b.blog_id DESC";  // Sử dụng TOP 4 thay vì LIMIT

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("blog_id"));
                blog.setBlogName(rs.getString("blog_name"));
                blog.setBlogImg(rs.getString("blog_img"));
                blog.setDate(rs.getDate("date"));
                recentBlogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recentBlogs;
    }

    // Lấy các bài viết theo danh mục
    public List<Blog> getBlogsByCategory(int categoryId, int offset, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "WHERE b.category_id = ? " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";  // Sửa lại cú pháp phân trang cho SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogId(rs.getInt("blog_id"));
                blog.setBlogName(rs.getString("blog_name"));
                blog.setBlogSubContent(rs.getString("blog_sub_content"));
                blog.setContent(rs.getString("content"));
                blog.setBlogImg(rs.getString("blog_img"));
                blog.setAuthor(rs.getString("author"));
                blog.setDate(rs.getDate("date"));
                blog.setCategoryId(rs.getInt("category_id"));
                blog.setCategoryName(rs.getString("category_name"));
                blog.setCommentCount(rs.getInt("comment_count"));
                blogs.add(blog);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }

    // Lấy tổng số bài viết của một danh mục
    public int getTotalBlogsCountByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Blog WHERE category_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Phương thức để lấy blog theo phân trang (sửa cho SQL Server)
    public List<Blog> getPaginatedBlogs(int offset, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";  // Sử dụng OFFSET và FETCH cho SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);   // Tham số OFFSET
            ps.setInt(2, pageSize);  // Tham số FETCH
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                blogs.add(mapResultSetToBlog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }

    // Phương thức để lấy tổng số bài viết
    public int getTotalBlogsCount() {
        String sql = "SELECT COUNT(*) FROM Blog";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Phương thức để lấy tổng số bài viết theo từ khóa tìm kiếm
    public int getTotalBlogsCount(String blogName) {
        // Định nghĩa câu truy vấn để đếm số lượng bài viết theo từ khóa tìm kiếm
        String sql = "SELECT COUNT(*) FROM Blog b WHERE b.blog_name LIKE ?";

        // Sử dụng try-with-resources để đảm bảo đóng tài nguyên khi không còn sử dụng
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thêm tham số tìm kiếm vào câu truy vấn, sử dụng dấu "%" để tìm kiếm theo chuỗi
            ps.setString(1, "%" + blogName + "%");

            // Thực thi câu truy vấn và nhận kết quả
            ResultSet rs = ps.executeQuery();

            // Nếu có kết quả, lấy số lượng bài viết tìm được
            if (rs.next()) {
                return rs.getInt(1); // Lấy giá trị của cột đầu tiên (tổng số bài viết)
            }
        } catch (SQLException e) {
            // In lỗi nếu có lỗi xảy ra
            e.printStackTrace();
        }

        // Trả về 0 nếu không có bài viết nào tìm được hoặc có lỗi
        return 0;
    }
    public List<Blog> searchBlogsByNameAndCategory(String blogName, int categoryId, int offset, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "WHERE b.blog_name LIKE ? AND b.category_id = ? " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Dùng OFFSET và FETCH cho SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + blogName + "%");
            ps.setInt(2, categoryId);
            ps.setInt(3, offset);  // Tính toán offset
            ps.setInt(4, pageSize); // Giới hạn số lượng kết quả mỗi trang
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBlog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public int addNewCategory(String categoryName) {
        int categoryId = -1;
        String sql = "INSERT INTO Category (category_name) VALUES (?)";

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, categoryName);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        categoryId = generatedKeys.getInt(1);  // Lấy ID của danh mục vừa thêm
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categoryId;
    }


    @Override
    public Blog select(int... id) {
        if (id == null || id.length == 0) return null;
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "WHERE b.blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id[0]);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToBlog(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Blog> select(int offset, int pageSize) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name, COUNT(cm.comment_id) AS comment_count " +
                "FROM Blog b " +
                "LEFT JOIN Category c ON b.category_id = c.category_id " +
                "LEFT JOIN Comment cm ON b.blog_id = cm.blog_id " +
                "GROUP BY b.blog_id, b.blog_name, b.blog_sub_content, b.content, b.blog_img, " +
                "b.author, b.date, b.category_id, c.category_name " +
                "ORDER BY b.blog_id DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Sử dụng OFFSET và FETCH cho phân trang trong SQL Server

        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);  // Tham số OFFSET (vị trí bắt đầu)
            ps.setInt(2, pageSize); // Tham số FETCH (số lượng blog mỗi trang)

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBlog(rs)); // Chuyển dữ liệu từ ResultSet sang đối tượng Blog
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    @Override
    public int insert(Blog blog) {
        String sql = "INSERT INTO Blog (blog_name, blog_sub_content, content, blog_img, author, date, category_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromBlog(ps, blog);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(Blog blog) {
        String sql = "UPDATE Blog SET blog_name = ?, blog_sub_content = ?, content = ?, blog_img = ?, " +
                "author = ?, date = ?, category_id = ? WHERE blog_id = ?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setPreparedStatementFromBlog(ps, blog);
            ps.setInt(8, blog.getBlogId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(int... id) {
        if (id == null || id.length == 0) return 0;

        // Xóa các comment liên quan
        CommentDAO commentDAO = new CommentDAO();
        int deletedComments = commentDAO.deleteCommentsByBlogId(id[0]);

        String sqlDeleteBlog = "DELETE FROM Blog WHERE blog_id = ?";

        try (Connection conn = getConn();
             PreparedStatement psDeleteBlog = conn.prepareStatement(sqlDeleteBlog)) {

            // Xóa bài viết
            psDeleteBlog.setInt(1, id[0]);
            int rowsAffected = psDeleteBlog.executeUpdate();

            System.out.println("[LOG] deleted " + deletedComments + " comments and " + rowsAffected + " blog(s)");

            return rowsAffected;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }



    // Thêm hàm lấy tất cả danh mục
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM Category";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    private Blog mapResultSetToBlog(ResultSet rs) throws SQLException {
        Blog blog = Blog.builder()
                .blogId(rs.getInt("blog_id"))
                .blogName(rs.getString("blog_name"))
                .blogSubContent(rs.getString("blog_sub_content"))
                .content(rs.getString("content"))
                .blogImg(rs.getString("blog_img"))
                .author(rs.getString("author"))
                .date(rs.getDate("date"))
                .categoryId(rs.getInt("category_id"))
                .categoryName(rs.getString("category_name"))
                .build();

        // Nếu có cột comment_count thì set thêm
        try {
            int count = rs.getInt("comment_count");
            blog.setCommentCount(count);
        } catch (SQLException ignored) {
        }

        return blog;
    }

    private void setPreparedStatementFromBlog(PreparedStatement ps, Blog blog) throws SQLException {
        ps.setString(1, blog.getBlogName());
        ps.setString(2, blog.getBlogSubContent());
        ps.setString(3, blog.getContent());
        ps.setString(4, blog.getBlogImg());
        ps.setString(5, blog.getAuthor());
        if (blog.getDate() != null) {
            ps.setDate(6, blog.getDate());
        } else {
            ps.setNull(6, Types.DATE);
        }
        ps.setInt(7, blog.getCategoryId());
    }
}