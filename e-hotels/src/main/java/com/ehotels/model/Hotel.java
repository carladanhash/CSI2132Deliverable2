package com.ehotels.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Hotel")
public class Hotel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Hotel_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "Chain_ID", nullable = false)
    private HotelChain hotelChain;

    @Column(name = "Hotel_Name", nullable = false)
    private String name;

    @Column(name = "Address", nullable = false)
    private String address;

    @Enumerated(EnumType.STRING)
    @Column(name = "Category", nullable = false)
    private HotelCategory category;

    @Column(name = "Number_Of_Rooms", nullable = false)
    private Integer numberOfRooms;

    @OneToMany(mappedBy = "hotel", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Room> rooms;

    // Constructors, Getters, Setters
}
