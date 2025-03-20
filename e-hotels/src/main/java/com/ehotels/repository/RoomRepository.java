package com.ehotels.repository;

import com.ehotels.model.Room;
import com.ehotels.model.RoomCapacity;
import com.ehotels.model.ViewType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RoomRepository extends JpaRepository<Room, Long> {

    @Query("SELECT r FROM Room r " +
            "JOIN r.hotel h " +
            "WHERE (:hotelChain IS NULL OR h.hotelChain.chainName = :hotelChain) " +
            "AND (:area IS NULL OR h.address LIKE %:area%) " +
            "AND (:capacity IS NULL OR r.roomCapacity = :capacity) " +
            "AND (:price IS NULL OR r.price <= :price) " +
            "AND (:viewType IS NULL OR r.viewType = :viewType) " +
            "AND r.id NOT IN (SELECT b.room.id FROM Booking b WHERE b.bookingStatus = 'Checked-In')")
    List<Room> searchRooms(
            @Param("hotelChain") String hotelChain,
            @Param("area") String area,
            @Param("capacity") RoomCapacity capacity,
            @Param("price") Double price,
            @Param("viewType") ViewType viewType
    );
}
