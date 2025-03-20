package com.ehotels.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "HotelChain")
public class HotelChain {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Chain_ID")
    private Long id;

    @Column(name = "Chain_Name", nullable = false, unique = true)
    private String name;

    @Column(name = "Number_Of_Hotels", nullable = false)
    private Integer numberOfHotels;

    @Column(name = "CentralOffice_Address", nullable = false)
    private String centralOfficeAddress;

    @OneToMany(mappedBy = "hotelChain", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Hotel> hotels;

    // Constructors, Getters, Setters
}
