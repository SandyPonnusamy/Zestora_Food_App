package com.tap.dao;


import com.tap.model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
 boolean insertRestaurant(Restaurant restaurant);
 Restaurant getRestaurantByID(int restaurantID);
 List<Restaurant> getAllRestaurants();
 List<Restaurant> getRestaurantsByAdmin(int adminUserID);
 boolean updateRestaurant(Restaurant restaurant);
 boolean deleteRestaurant(int restaurantID);
}