package com.ehotels.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Room")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Room_ID")
    private Long id;

    @Column(name = "Room_Number", unique = true, nullable = false)
    private Integer roomNumber;

    @ManyToOne
    @JoinColumn(name = "Hotel_ID", nullable = false)
    private Hotel hotel;

    @Enumerated(EnumType.STRING)
    @Column(name = "Room_Capacity", nullable = false)
    private RoomCapacity roomCapacity;

    @Column(name = "Extendable", nullable = false)
    private Boolean extendable;

    @Column(name = "Price", nullable = false)
    private Double price;

    @Enumerated(EnumType.STRING)
    @Column(name = "View_Type", nullable = false)
    private ViewType viewType;

    @Enumerated(EnumType.STRING)
    @Column(name = "Damage_Status", nullable = false)
    private DamageStatus damageStatus = DamageStatus.NONE;

    // Constructors, Getters, Setters
}
