
// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.17;

contract Car {

    struct CarDetails {
        string name;
        string model;
        uint256 year;
        address owner;
    }
    mapping(uint => CarDetails) public carMap;

    event CarOwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint carId);

    modifier isCarOwner(CarDetails memory car) {
        require(car.owner == msg.sender, "Owner can only transfer ownership");
        _;
    }

    function addCar(string memory name, string memory model, uint year, address owner, uint id) public {
        CarDetails memory car;
        car.name = name;
        car.model = model;
        car.year = year;
        car.owner = owner;

        carMap[id] = car;
    }

    function transferCar(address transferAddress, uint carId) public isCarOwner(getCar(carId)) {
        CarDetails storage car = carMap[carId];

        emit CarOwnershipTransferred(car.owner, transferAddress, carId);

        car.owner = transferAddress;
    }

    

    function getCar(uint id) public view returns (CarDetails memory) {
        return carMap[id];
    }
}


