package com.ehotels.repository;

import com.ehotels.model.Room;
import com.ehotels.model.RoomCapacity;
import com.ehotels.model.ViewType;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {

    @Query("SELECT r FROM Room r " +
           "WHERE r.hotel.hotelChain.name = :hotelChain " +
           "AND r.hotel.address LIKE %:area% " +
           "AND r.capacity = :capacity " +
           "AND r.price <= :price " +
           "AND r.viewType = :viewType")
    List<Room> searchRooms(@Param("hotelChain") String hotelChain,
                           @Param("area") String area,
                           @Param("capacity") RoomCapacity capacity,
                           @Param("price") Double price,
                           @Param("viewType") ViewType viewType);
}
