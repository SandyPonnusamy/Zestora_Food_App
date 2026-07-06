package com.tap.dao;

import com.tap.model.User;
import java.util.List;

public interface UserDAO {
 boolean insertUser(User user);
 User getUserByID(int userID);
 User getUserByEmail(String email);
 List<User> getAllUsers();
 boolean updateUser(User user);
 boolean deleteUser(int userID);
}