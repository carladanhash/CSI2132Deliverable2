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
        return roomRepository.searchRooms(hotelChain, area, capacity, price, viewType);
    }
}
