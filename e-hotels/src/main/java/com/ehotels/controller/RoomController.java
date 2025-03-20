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
            @RequestParam(required = false) RoomCapacity capacity,
            @RequestParam(required = false) Double price,
            @RequestParam(required = false) ViewType viewType) {
        
        return roomService.searchRooms(hotelChain, area, capacity, price, viewType);
    }
}
