package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items;

    public Cart() {
        items = new HashMap<Integer, CartItem>();
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void addItem(CartItem cartItem) {

        int menuId = cartItem.getMenuId();

        if (items.containsKey(menuId)) {
            CartItem existingCartItem = items.get(menuId);
            existingCartItem.setQuantity(existingCartItem.getQuantity() + cartItem.getQuantity());
        } else {
            items.put(menuId, cartItem);
        }
    }

    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    public void updateQuantity(int menuId, int newQuantity) {
        if (items.containsKey(menuId)) {
            // Minimum quantity is 1. Deleting an item is a separate, explicit
            // action (removeItem) — quantity updates should never silently
            // delete the item just because someone clicked "-" too many times.
            int clamped = Math.max(1, newQuantity);
            items.get(menuId).setQuantity(clamped);
        }
    }

    public double getGrandTotal() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getPrice() * item.getQuantity();
        }
        return total;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public int getTotalItemCount() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public void clear() {
        items.clear();
    }
}