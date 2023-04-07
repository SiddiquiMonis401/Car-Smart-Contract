// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.18;

contract Car {

    struct CarDetails {
        string name;
        string model;
        uint year;
        address payable owner;
        uint256 price;
    }
    mapping(uint => CarDetails) public carMap;

    event CarOwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint carId);
    event CarPriceChanged(uint256 indexed newPrice, uint carId);

    modifier isCarOwner(CarDetails memory car) {
        require(car.owner == msg.sender, "Owner can mutate the state");
        _;
    }

    modifier haveEnoughFund(CarDetails memory car, uint256 value) {
        require(msg.value >= value, "Insufficient funds");
        _;
    }

    function addCar(string memory name, string memory model, uint year, uint id, uint256 price) public {
        CarDetails memory car;
        car.name = name;
        car.model = model;
        car.year = year;
        car.owner = payable(msg.sender);
        car.price = price;

        carMap[id] = car;
    }

    function transferCar(uint carId) public payable haveEnoughFund(getCar(carId), getCar(carId).price) {
        CarDetails storage car = carMap[carId];

        emit CarOwnershipTransferred(car.owner, msg.sender, carId);

        car.owner.transfer(car.price);
        car.owner = payable(msg.sender);
    }

    function getCar(uint id) public view returns (CarDetails memory) {
        return carMap[id];
    }

    function changeCarPrice(uint carId, uint256 newPrice) public isCarOwner(getCar(carId)) {
        CarDetails storage car = carMap[carId];
        car.price = newPrice;
        emit CarPriceChanged(newPrice, carId);
    }

    function checkCarPrice(uint carId) public view returns (uint256) {
        CarDetails storage car = carMap[carId];
        return car.price;
    }
}
