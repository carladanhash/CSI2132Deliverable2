package com.ehotels.service;

import com.ehotels.model.Room;
import com.ehotels.model.RoomCapacity;
import com.ehotels.model.ViewType;
import com.ehotels.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoomService {

    private final RoomRepository roomRepository;

    public RoomService(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

 

    public List<Room> searchRooms(String hotelChain, String area, RoomCapacity capacity, Double price, ViewType viewType) {
        // Log the parameters to see what values are being passed to the query
        System.out.println("🔍 Searching with filters:");
        System.out.println("Hotel Chain: " + hotelChain);
        System.out.println("Area: " + area);
        System.out.println("Capacity: " + capacity);
        System.out.println("Price: " + price);
        System.out.println("View Type: " + viewType);

        // Perform the query with the given parameters
        List<Room> rooms = roomRepository.searchRooms(hotelChain, area, capacity, price, viewType);

        // Log how many results were found
        System.out.println("🔍 Rooms found: " + rooms.size());

        return rooms;
    }
}
