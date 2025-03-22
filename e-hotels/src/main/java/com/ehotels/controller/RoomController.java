package com.ehotels.controller;

import com.ehotels.model.Room;
import com.ehotels.model.RoomCapacity;
import com.ehotels.model.ViewType;
import com.ehotels.service.RoomService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomService roomService;

    public RoomController(RoomService roomService) {
        this.roomService = roomService;
    }

    @GetMapping("/search")
    public List<Room> searchRooms(
            @RequestParam(required = false) String hotelChain,
            @RequestParam(required = false) String area,
            @RequestParam(required = false) String capacity,
            @RequestParam(required = false) Double price,
            @RequestParam(required = false) String viewType) {

        // Log the incoming parameters
        System.out.println("Incoming search parameters:");
        System.out.println("Hotel Chain: " + hotelChain);
        System.out.println("Area: " + area);
        System.out.println("Capacity: " + capacity);
        System.out.println("Price: " + price);
        System.out.println("View Type: " + viewType);
        
        // Convert String to enum for RoomCapacity and ViewType
        RoomCapacity roomCapacity = null;
        if (capacity != null) {
            try {
                roomCapacity = RoomCapacity.valueOf(capacity.toUpperCase());
                System.out.println("Mapped Room Capacity: " + roomCapacity);
            } catch (IllegalArgumentException e) {
                System.out.println("Invalid Room Capacity provided: " + capacity);
                throw new IllegalArgumentException("Invalid Room Capacity: " + capacity);
            }
        }

        ViewType view = null;
        if (viewType != null) {
            try {
                view = ViewType.valueOf(viewType.toUpperCase());
                System.out.println("Mapped View Type: " + view);
            } catch (IllegalArgumentException e) {
                System.out.println("Invalid View Type provided: " + viewType);
                throw new IllegalArgumentException("Invalid View Type: " + viewType);
            }
        }

        // Call the service and log the results
        List<Room> rooms = roomService.searchRooms(hotelChain, area, roomCapacity, price, view);
        System.out.println("Found rooms: " + rooms.size());
        
        return rooms;
    }
}
