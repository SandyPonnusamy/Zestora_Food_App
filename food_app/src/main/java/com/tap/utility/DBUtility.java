
package com.tap.utility;

import java.sql.*;

public class DBUtility {

    public static void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            // Don't close connection here (singleton)
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeResources(PreparedStatement ps, ResultSet rs) {
        closeResources(null, ps, rs);
    }

    public static void closeResources(PreparedStatement ps) {
        closeResources(null, ps, null);
    }
}