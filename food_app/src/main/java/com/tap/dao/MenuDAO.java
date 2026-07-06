package com.tap.dao;


import com.tap.model.Menu;
import java.util.List;

public interface MenuDAO {
 boolean insertMenu(Menu menu);
 Menu getMenuByID(int menuID);
 List<Menu> getMenuByRestaurant(int restaurantID);
 boolean updateMenu(Menu menu);
 boolean softDeleteMenu(int menuID); // sets DeletedAt
}