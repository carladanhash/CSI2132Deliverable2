package com.ehotels.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Room")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Room_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "Hotel_ID", nullable = false)
    private Hotel hotel;

    @Enumerated(EnumType.STRING)
    @Column(name = "Room_Capacity", nullable = false) // ✅ MUST MATCH DB COLUMN
    private RoomCapacity capacity;

    @Column(name = "Price", nullable = false)
    private Double price;

    @Enumerated(EnumType.STRING)
    @Column(name = "View_Type", nullable = false)
    private ViewType viewType;

    @Enumerated(EnumType.STRING)
    @Column(name = "Damage_Status", nullable = false)
    private DamageStatus damageStatus;

    // Getters and setters (or use Lombok if you're using it)
}
